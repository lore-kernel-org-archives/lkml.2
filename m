Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab1I2VQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 17:16:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:54159 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab1I2VQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 17:16:32 -0400
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, eparis@redhat.com,
        Maxim Uvarov <maxim.uvarov@oracle.com>
Subject: [PATCH] audit: dynamically allocate audit_names when not enough spaceis in the names array
Date: Thu, 29 Sep 2011 14:15:24 -0700
Message-Id: <1317330924-11080-2-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317330924-11080-1-git-send-email-maxim.uvarov@oracle.com>
References: <1317330924-11080-1-git-send-email-maxim.uvarov@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E84E02E.00B3:SCFMA922111,ss=1,re=-6.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up to 3.0.3 commit from mailing list:
https://www.redhat.com/archives/linux-audit/2010-March/msg00010.html
Some system calls, such as loading a module, can cause filesystem activity
such as creating lots of new files in /sys or debugfs. Audit can only capture
20 inodes in a single syscall since it stores them in a fixed length array.
This patch shrinks the fixed length array to 5 names (the number used by a
rename operation) and then allocates names dynamically as they are needed
after 5. It should shut up the complaints we sometimes see about
'name_count maxed, losing inode data" such as that seen in Red Hat bugzilla
445757.
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
---
 kernel/auditsc.c |  436 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 245 insertions(+), 191 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 00d79df..5719c4c 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -71,8 +71,9 @@
 #include "audit.h"
 
 /* AUDIT_NAMES is the number of slots we reserve in the audit_context
- * for saving names from getname(). */
-#define AUDIT_NAMES    20
+ * for saving names from getname().  If we get more names we will allocate
+ * a name dynamically and also add those to the list anchored by names_list. */
+#define AUDIT_NAMES	5
 
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
@@ -101,6 +102,7 @@ struct audit_cap_data {
  *
  * Further, in fs/namei.c:path_lookup() we store the inode and device. */
 struct audit_names {
+	struct list_head list;          /* audit_context->names_list */
 	const char	*name;
 	int		name_len;	/* number of name's characters to log */
 	unsigned	name_put;	/* call __putname() for this name */
@@ -113,6 +115,12 @@ struct audit_names {
 	u32		osid;
 	struct audit_cap_data fcap;
 	unsigned int	fcap_ver;
+	/*
+	 * This was an allocated audit_names and not from the array of
+	 * names allocated in the task audit context. Thus this name
+	 * should be freed on syscall exit
+	 */
+	bool should_free;
 };
 
 struct audit_aux_data {
@@ -174,8 +182,17 @@ struct audit_context {
 	long		    return_code;/* syscall return code */
 	u64		    prio;
 	int		    return_valid; /* return code is valid */
-	int		    name_count;
-	struct audit_names  names[AUDIT_NAMES];
+	/*
+	 * The names_list is the list of all audit_names collected during this
+	 * syscall.  The first AUDIT_NAMES entries in the names_list will
+	 * actually be from the preallocated_names array for performance
+	 * reasons.  Except during allocation they should never be referenced
+	 * through the preallocated_names array and should only be found/used
+	 * by running the names_list.
+	 */
+	struct audit_names  preallocated_names[AUDIT_NAMES];
+	int		    name_count; /* total records in names_list */
+	struct list_head    names_list;	/* anchor for struct audit_names->list */
 	char *		    filterkey;	/* key for rule that triggered record */
 	struct path	    pwd;
 	struct audit_context *previous; /* For nested syscalls */
@@ -307,6 +324,8 @@ static int audit_match_perm(struct audit_context *ctx, int mask)
 
 static int audit_match_filetype(struct audit_context *ctx, int which)
 {
+	struct audit_names *n;
+	unsigned i = 0;
 	unsigned index = which & ~S_IFMT;
 	mode_t mode = which & S_IFMT;
 
@@ -315,11 +334,22 @@ static int audit_match_filetype(struct audit_context *ctx, int which)
 
 	if (index >= ctx->name_count)
 		return 0;
-	if (ctx->names[index].ino == -1)
-		return 0;
-	if ((ctx->names[index].mode ^ mode) & S_IFMT)
-		return 0;
-	return 1;
+
+	list_for_each_entry(n, &ctx->names_list, list) {
+		if (i != index) {
+			i++;
+			continue;
+		}
+
+		if (n->ino == -1)
+			return 0;
+		if ((n->mode ^ mode) & S_IFMT)
+			return 0;
+		return 1;
+	}
+
+	/* we should not get here since we should eventually hit i == index */
+	return 0;
 }
 
 /*
@@ -457,13 +487,14 @@ static int audit_filter_rules(struct task_struct *tsk,
 			      bool task_creation)
 {
 	const struct cred *cred;
-	int i, j, need_sid = 1;
+	int i, need_sid = 1;
 	u32 sid;
 
 	cred = rcu_dereference_check(tsk->cred, tsk == current || task_creation);
 
 	for (i = 0; i < rule->field_count; i++) {
 		struct audit_field *f = &rule->fields[i];
+		struct audit_names *n;
 		int result = 0;
 
 		switch (f->type) {
@@ -526,8 +557,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 				result = audit_comparator(MAJOR(name->dev),
 							  f->op, f->val);
 			else if (ctx) {
-				for (j = 0; j < ctx->name_count; j++) {
-					if (audit_comparator(MAJOR(ctx->names[j].dev),	f->op, f->val)) {
+				list_for_each_entry(n, &ctx->names_list, list) {
+					if (audit_comparator(MAJOR(n->dev), f->op, f->val)) {
 						++result;
 						break;
 					}
@@ -539,8 +570,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 				result = audit_comparator(MINOR(name->dev),
 							  f->op, f->val);
 			else if (ctx) {
-				for (j = 0; j < ctx->name_count; j++) {
-					if (audit_comparator(MINOR(ctx->names[j].dev), f->op, f->val)) {
+				list_for_each_entry(n, &ctx->names_list, list) {
+					if (audit_comparator(MINOR(n->dev), f->op, f->val)) {
 						++result;
 						break;
 					}
@@ -551,8 +582,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 			if (name)
 				result = (name->ino == f->val);
 			else if (ctx) {
-				for (j = 0; j < ctx->name_count; j++) {
-					if (audit_comparator(ctx->names[j].ino, f->op, f->val)) {
+				list_for_each_entry(n, &ctx->names_list, list) {
+					if (audit_comparator(n->ino, f->op, f->val)) {
 						++result;
 						break;
 					}
@@ -607,11 +638,10 @@ static int audit_filter_rules(struct task_struct *tsk,
 					           name->osid, f->type, f->op,
 					           f->lsm_rule, ctx);
 				} else if (ctx) {
-					for (j = 0; j < ctx->name_count; j++) {
-						if (security_audit_rule_match(
-						      ctx->names[j].osid,
-						      f->type, f->op,
-						      f->lsm_rule, ctx)) {
+					list_for_each_entry(n, &ctx->names_list, list) {
+						if (security_audit_rule_match(n->osid, f->type,
+									      f->op, f->lsm_rule,
+									      ctx)) {
 							++result;
 							break;
 						}
@@ -677,7 +707,7 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
 	rcu_read_lock();
 	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_TASK], list) {
 		if (audit_filter_rules(tsk, &e->rule, NULL, NULL,
-				       &state, true)) {
+			       &state, true)) {
 			if (state == AUDIT_RECORD_CONTEXT)
 				*key = kstrdup(e->rule.filterkey, GFP_ATOMIC);
 			rcu_read_unlock();
@@ -722,40 +752,53 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 	return AUDIT_BUILD_CONTEXT;
 }
 
-/* At syscall exit time, this filter is called if any audit_names[] have been
+/*
+ * Given an audit_name check the inode hash table to see if they match.
+ * Called holding the rcu read lock to protect the use of audit_inode_hash
+ */
+static int audit_filter_inode_name(struct task_struct *tsk,
+				   struct audit_names *n,
+				   struct audit_context *ctx)
+{
+	int word, bit;
+	int h = audit_hash_ino((u32)n->ino);
+	struct list_head *list = &audit_inode_hash[h];
+	struct audit_entry *e;
+	enum audit_state state;
+
+	word = AUDIT_WORD(ctx->major);
+	bit  = AUDIT_BIT(ctx->major);
+
+	if (list_empty(list))
+		return 0;
+
+	list_for_each_entry_rcu(e, list, list) {
+		if ((e->rule.mask[word] & bit) == bit &&
+		    audit_filter_rules(tsk, &e->rule, ctx, n, &state, false)) {
+			ctx->current_state = state;
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/* At syscall exit time, this filter is called if any audit_names have been
  * collected during syscall processing.  We only check rules in sublists at hash
- * buckets applicable to the inode numbers in audit_names[].
+ * buckets applicable to the inode numbers in audit_names.
  * Regarding audit_state, same rules apply as for audit_filter_syscall().
  */
 void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
 {
-	int i;
-	struct audit_entry *e;
-	enum audit_state state;
+	struct audit_names *n;
 
 	if (audit_pid && tsk->tgid == audit_pid)
 		return;
 
 	rcu_read_lock();
-	for (i = 0; i < ctx->name_count; i++) {
-		int word = AUDIT_WORD(ctx->major);
-		int bit  = AUDIT_BIT(ctx->major);
-		struct audit_names *n = &ctx->names[i];
-		int h = audit_hash_ino((u32)n->ino);
-		struct list_head *list = &audit_inode_hash[h];
-
-		if (list_empty(list))
-			continue;
-
-		list_for_each_entry_rcu(e, list, list) {
-			if ((e->rule.mask[word] & bit) == bit &&
-			    audit_filter_rules(tsk, &e->rule, ctx, n,
-				    	       &state, false)) {
-				rcu_read_unlock();
-				ctx->current_state = state;
-				return;
-			}
-		}
+	list_for_each_entry(n, &ctx->names_list, list) {
+		if (audit_filter_inode_name(tsk, n, ctx))
+			break;
 	}
 	rcu_read_unlock();
 }
@@ -799,7 +842,7 @@ static inline struct audit_context *audit_get_context(struct task_struct *tsk,
 
 static inline void audit_free_names(struct audit_context *context)
 {
-	int i;
+	struct audit_names *n, *next;
 
 #if AUDIT_DEBUG == 2
 	if (context->put_count + context->ino_count != context->name_count) {
@@ -810,10 +853,9 @@ static inline void audit_free_names(struct audit_context *context)
 		       context->serial, context->major, context->in_syscall,
 		       context->name_count, context->put_count,
 		       context->ino_count);
-		for (i = 0; i < context->name_count; i++) {
+		list_for_each_entry(n, &context->names_list, list) {
 			printk(KERN_ERR "names[%d] = %p = %s\n", i,
-			       context->names[i].name,
-			       context->names[i].name ?: "(null)");
+			       n->name, n->name ?: "(null)");
 		}
 		dump_stack();
 		return;
@@ -824,9 +866,12 @@ static inline void audit_free_names(struct audit_context *context)
 	context->ino_count  = 0;
 #endif
 
-	for (i = 0; i < context->name_count; i++) {
-		if (context->names[i].name && context->names[i].name_put)
-			__putname(context->names[i].name);
+	list_for_each_entry_safe(n, next, &context->names_list, list) {
+		list_del(&n->list);
+		if (n->name && n->name_put)
+			__putname(n->name);
+		if (n->should_free)
+			kfree(n);
 	}
 	context->name_count = 0;
 	path_put(&context->pwd);
@@ -864,6 +909,7 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
 		return NULL;
 	audit_zero_context(context, state);
 	INIT_LIST_HEAD(&context->killed_trees);
+	INIT_LIST_HEAD(&context->names_list);
 	return context;
 }
 
@@ -1324,6 +1370,68 @@ static void show_special(struct audit_context *context, int *call_panic)
 	audit_log_end(ab);
 }
 
+static void audit_log_name(struct audit_context *context, struct audit_names *n,
+			   int record_num, int *call_panic)
+{
+	struct audit_buffer *ab;
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PATH);
+	if (!ab)
+		return; /* audit_panic has been called */
+
+	audit_log_format(ab, "item=%d", record_num);
+
+	if (n->name) {
+		switch (n->name_len) {
+		case AUDIT_NAME_FULL:
+			/* log the full path */
+			audit_log_format(ab, " name=");
+			audit_log_untrustedstring(ab, n->name);
+			break;
+		case 0:
+			/* name was specified as a relative path and the
+			 * directory component is the cwd */
+			audit_log_d_path(ab, "name=", &context->pwd);
+			break;
+		default:
+			/* log the name's directory component */
+			audit_log_format(ab, " name=");
+			audit_log_n_untrustedstring(ab, n->name,
+						    n->name_len);
+		}
+	} else
+		audit_log_format(ab, " name=(null)");
+
+	if (n->ino != (unsigned long)-1) {
+		audit_log_format(ab, " inode=%lu"
+				 " dev=%02x:%02x mode=%#o"
+				 " ouid=%u ogid=%u rdev=%02x:%02x",
+				 n->ino,
+				 MAJOR(n->dev),
+				 MINOR(n->dev),
+				 n->mode,
+				 n->uid,
+				 n->gid,
+				 MAJOR(n->rdev),
+				 MINOR(n->rdev));
+	}
+	if (n->osid != 0) {
+		char *ctx = NULL;
+		u32 len;
+		if (security_secid_to_secctx(
+			n->osid, &ctx, &len)) {
+			audit_log_format(ab, " osid=%u", n->osid);
+			*call_panic = 2;
+		} else {
+			audit_log_format(ab, " obj=%s", ctx);
+			security_release_secctx(ctx, len);
+		}
+	}
+
+	audit_log_fcaps(ab, n);
+
+	audit_log_end(ab);
+}
+
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
 	const struct cred *cred;
@@ -1331,6 +1439,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	struct audit_buffer *ab;
 	struct audit_aux_data *aux;
 	const char *tty;
+	struct audit_names *n;
 
 	/* tsk == current */
 	context->pid = tsk->pid;
@@ -1470,66 +1579,10 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			audit_log_end(ab);
 		}
 	}
-	for (i = 0; i < context->name_count; i++) {
-		struct audit_names *n = &context->names[i];
 
-		ab = audit_log_start(context, GFP_KERNEL, AUDIT_PATH);
-		if (!ab)
-			continue; /* audit_panic has been called */
-
-		audit_log_format(ab, "item=%d", i);
-
-		if (n->name) {
-			switch(n->name_len) {
-			case AUDIT_NAME_FULL:
-				/* log the full path */
-				audit_log_format(ab, " name=");
-				audit_log_untrustedstring(ab, n->name);
-				break;
-			case 0:
-				/* name was specified as a relative path and the
-				 * directory component is the cwd */
-				audit_log_d_path(ab, "name=", &context->pwd);
-				break;
-			default:
-				/* log the name's directory component */
-				audit_log_format(ab, " name=");
-				audit_log_n_untrustedstring(ab, n->name,
-							    n->name_len);
-			}
-		} else
-			audit_log_format(ab, " name=(null)");
-
-		if (n->ino != (unsigned long)-1) {
-			audit_log_format(ab, " inode=%lu"
-					 " dev=%02x:%02x mode=%#o"
-					 " ouid=%u ogid=%u rdev=%02x:%02x",
-					 n->ino,
-					 MAJOR(n->dev),
-					 MINOR(n->dev),
-					 n->mode,
-					 n->uid,
-					 n->gid,
-					 MAJOR(n->rdev),
-					 MINOR(n->rdev));
-		}
-		if (n->osid != 0) {
-			char *ctx = NULL;
-			u32 len;
-			if (security_secid_to_secctx(
-				n->osid, &ctx, &len)) {
-				audit_log_format(ab, " osid=%u", n->osid);
-				call_panic = 2;
-			} else {
-				audit_log_format(ab, " obj=%s", ctx);
-				security_release_secctx(ctx, len);
-			}
-		}
-
-		audit_log_fcaps(ab, n);
-
-		audit_log_end(ab);
-	}
+	i = 0;
+	list_for_each_entry(n, &context->names_list, list)
+		audit_log_name(context, n, i++, &call_panic);
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
@@ -1821,6 +1874,30 @@ retry:
 #endif
 }
 
+static struct audit_names *audit_alloc_name(struct audit_context *context)
+{
+	struct audit_names *aname;
+
+	if (context->name_count < AUDIT_NAMES) {
+		aname = &context->preallocated_names[context->name_count];
+		memset(aname, 0, sizeof(*aname));
+	} else {
+		aname = kzalloc(sizeof(*aname), GFP_NOFS);
+		if (!aname)
+			return NULL;
+		aname->should_free = true;
+	}
+
+	aname->ino = (unsigned long)-1;
+	list_add_tail(&aname->list, &context->names_list);
+
+	context->name_count++;
+#if AUDIT_DEBUG
+	context->ino_count++;
+#endif
+	return aname;
+}
+
 /**
  * audit_getname - add a name to the list
  * @name: name to add
@@ -1831,6 +1908,7 @@ retry:
 void __audit_getname(const char *name)
 {
 	struct audit_context *context = current->audit_context;
+	struct audit_names *n;
 
 	if (IS_ERR(name) || !name)
 		return;
@@ -1843,15 +1921,22 @@ void __audit_getname(const char *name)
 #endif
 		return;
 	}
-	BUG_ON(context->name_count >= AUDIT_NAMES);
-	context->names[context->name_count].name = name;
-	context->names[context->name_count].name_len = AUDIT_NAME_FULL;
-	context->names[context->name_count].name_put = 1;
-	context->names[context->name_count].ino  = (unsigned long)-1;
-	context->names[context->name_count].osid = 0;
-	++context->name_count;
-	if (!context->pwd.dentry)
-		get_fs_pwd(current->fs, &context->pwd);
+
+	n = audit_alloc_name(context);
+	if (!n)
+		return;
+
+	n->name = name;
+	n->name_len = AUDIT_NAME_FULL;
+	n->name_put = true;
+
+	if (!context->pwd.dentry) {
+		spin_lock(&current->fs->lock);
+		context->pwd = current->fs->pwd;
+		path_get(&current->fs->pwd);
+		spin_unlock(&current->fs->lock);
+	}
+
 }
 
 /* audit_putname - intercept a putname request
@@ -1871,11 +1956,12 @@ void audit_putname(const char *name)
 		printk(KERN_ERR "%s:%d(:%d): __putname(%p)\n",
 		       __FILE__, __LINE__, context->serial, name);
 		if (context->name_count) {
+			struct audit_names *n;
 			int i;
-			for (i = 0; i < context->name_count; i++)
+
+			list_for_each_entry(n, &context->names_list, list)
 				printk(KERN_ERR "name[%d] = %p = %s\n", i,
-				       context->names[i].name,
-				       context->names[i].name ?: "(null)");
+				       n->name, n->name ?: "(null)");
 		}
 #endif
 		__putname(name);
@@ -1897,29 +1983,6 @@ void audit_putname(const char *name)
 #endif
 }
 
-static int audit_inc_name_count(struct audit_context *context,
-				const struct inode *inode)
-{
-	if (context->name_count >= AUDIT_NAMES) {
-		if (inode)
-			printk(KERN_DEBUG "audit: name_count maxed, losing inode data: "
-			       "dev=%02x:%02x, inode=%lu\n",
-			       MAJOR(inode->i_sb->s_dev),
-			       MINOR(inode->i_sb->s_dev),
-			       inode->i_ino);
-
-		else
-			printk(KERN_DEBUG "name_count maxed, losing inode data\n");
-		return 1;
-	}
-	context->name_count++;
-#if AUDIT_DEBUG
-	context->ino_count++;
-#endif
-	return 0;
-}
-
-
 static inline int audit_copy_fcaps(struct audit_names *name, const struct dentry *dentry)
 {
 	struct cpu_vfs_cap_data caps;
@@ -1969,34 +2032,30 @@ static void audit_copy_inode(struct audit_names *name, const struct dentry *dent
  */
 void __audit_inode(const char *name, const struct dentry *dentry)
 {
-	int idx;
 	struct audit_context *context = current->audit_context;
 	const struct inode *inode = dentry->d_inode;
+	struct audit_names *n;
 
 	if (!context->in_syscall)
 		return;
-	if (context->name_count
-	    && context->names[context->name_count-1].name
-	    && context->names[context->name_count-1].name == name)
-		idx = context->name_count - 1;
-	else if (context->name_count > 1
-		 && context->names[context->name_count-2].name
-		 && context->names[context->name_count-2].name == name)
-		idx = context->name_count - 2;
-	else {
-		/* FIXME: how much do we care about inodes that have no
-		 * associated name? */
-		if (audit_inc_name_count(context, inode))
-			return;
-		idx = context->name_count - 1;
-		context->names[idx].name = NULL;
+
+	list_for_each_entry_reverse(n, &context->names_list, list) {
+		if (n->name && (n->name == name))
+			goto out;
 	}
+
+	/* unable to find the name from a previous getname() */
+	n = audit_alloc_name(context);
+	if (!n)
+		return;
+out:
 	handle_path(dentry);
-	audit_copy_inode(&context->names[idx], dentry, inode);
+	audit_copy_inode(n, dentry, inode);
 }
 
 /**
  * audit_inode_child - collect inode info for created/removed objects
+ * @dname: inode's dentry name
  * @dentry: dentry being audited
  * @parent: inode of dentry parent
  *
@@ -2011,11 +2070,11 @@ void __audit_inode(const char *name, const struct dentry *dentry)
 void __audit_inode_child(const struct dentry *dentry,
 			 const struct inode *parent)
 {
-	int idx;
 	struct audit_context *context = current->audit_context;
 	const char *found_parent = NULL, *found_child = NULL;
 	const struct inode *inode = dentry->d_inode;
 	const char *dname = dentry->d_name.name;
+	struct audit_names *n;
 	int dirlen = 0;
 
 	if (!context->in_syscall)
@@ -2023,11 +2082,12 @@ void __audit_inode_child(const struct dentry *dentry,
 
 	if (inode)
 		handle_one(inode);
+	/* determine matching parent */
+	if (!dname)
+		goto add_names;
 
 	/* parent is more likely, look for it first */
-	for (idx = 0; idx < context->name_count; idx++) {
-		struct audit_names *n = &context->names[idx];
-
+	list_for_each_entry(n, &context->names_list, list) {
 		if (!n->name)
 			continue;
 
@@ -2040,9 +2100,7 @@ void __audit_inode_child(const struct dentry *dentry,
 	}
 
 	/* no matching parent, look for matching child */
-	for (idx = 0; idx < context->name_count; idx++) {
-		struct audit_names *n = &context->names[idx];
-
+	list_for_each_entry(n, &context->names_list, list) {
 		if (!n->name)
 			continue;
 
@@ -2060,34 +2118,29 @@ void __audit_inode_child(const struct dentry *dentry,
 
 add_names:
 	if (!found_parent) {
-		if (audit_inc_name_count(context, parent))
+		n = audit_alloc_name(context);
+		if (!n)
 			return;
-		idx = context->name_count - 1;
-		context->names[idx].name = NULL;
-		audit_copy_inode(&context->names[idx], NULL, parent);
+		audit_copy_inode(n, NULL, parent);
 	}
 
 	if (!found_child) {
-		if (audit_inc_name_count(context, inode))
+		n = audit_alloc_name(context);
+		if (!n)
 			return;
-		idx = context->name_count - 1;
 
 		/* Re-use the name belonging to the slot for a matching parent
 		 * directory. All names for this context are relinquished in
 		 * audit_free_names() */
 		if (found_parent) {
-			context->names[idx].name = found_parent;
-			context->names[idx].name_len = AUDIT_NAME_FULL;
+			n->name = found_parent;
+			n->name_len = AUDIT_NAME_FULL;
 			/* don't call __putname() */
-			context->names[idx].name_put = 0;
-		} else {
-			context->names[idx].name = NULL;
+			n->name_put = false;
 		}
 
 		if (inode)
-			audit_copy_inode(&context->names[idx], NULL, inode);
-		else
-			context->names[idx].ino = (unsigned long)-1;
+			audit_copy_inode(n, NULL, inode);
 	}
 }
 EXPORT_SYMBOL_GPL(__audit_inode_child);
@@ -2139,12 +2192,13 @@ int audit_set_loginuid(struct task_struct *task, uid_t loginuid)
 
 		ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_LOGIN);
 		if (ab) {
-			audit_log_format(ab, "login pid=%d uid=%u "
-				"old auid=%u new auid=%u"
-				" old ses=%u new ses=%u",
-				task->pid, task_uid(task),
-				task->loginuid, loginuid,
-				task->sessionid, sessionid);
+			audit_log_format(ab, "pid=%d uid=%u", task->pid,
+					 task_uid(task));
+			audit_log_task_context(ab);
+			audit_log_format(ab, " old auid=%u new auid=%u "
+					 "old ses=%u new ses=%u",
+					 task->loginuid, loginuid,
+					 task->sessionid, sessionid);
 			audit_log_end(ab);
 		}
 	}
-- 
1.7.4.1

