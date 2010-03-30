Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0C3WSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:18:05 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:62897 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab0C3WSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=H/WXNXGhsL2tAL8gH2RJr65ToWT59oqmbuPqikEDYZy5bAqKPvzmLdQlQhB/eHcFpY
         zKZP7ZgW4lksJ5rGUit79vM+A20SlnehpQO6lhjKuQN0zYqRyLngvsMT+mVFFzENCkiq
         cwDIygx0BHBhH7+96VXx9swf6e4934QICyXXQ=
Date: Wed, 31 Mar 2010 00:17:11 +0200 (CEST)
From: Juraj Hlista <juro.hlista@gmail.com>
X-X-Sender: juro@laptop
To: viro@zeniv.linux.org.uk, sgrubb@redhat.com, mitr@redhat.com
cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       juro.hlista@gmail.com
Subject: [PATCH] audit: Reactive rules
Message-ID: <alpine.LNX.2.00.1003310009440.30178@laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juraj Hlista <juro.hlista@gmail.com>

Add support for reactive rules. An audit rule can contain more than one reaction. The reactions are identified by numbers in the kernel and by strings in the user space.

Signed-off-by: Juraj Hlista <juro.hlista@gmail.com>
---
 include/linux/audit.h |    9 ++++++++
 kernel/audit.c        |    8 +++++++
 kernel/audit_tree.c   |    1 +
 kernel/audit_watch.c  |    1 +
 kernel/auditfilter.c  |   52 ++++++++++++++++++++++++++++++++++++++++++------
 kernel/auditsc.c      |   23 +++++++++++++++++++++
 6 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index f391d45..0325516 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -102,6 +102,7 @@
 #define AUDIT_EOE		1320	/* End of multi-record event */
 #define AUDIT_BPRM_FCAPS	1321	/* Information about fcaps increasing perms */
 #define AUDIT_CAPSET		1322	/* Record showing argument to sys_capset */
+#define AUDIT_REACT_RULE	1323	/* Reactive rule */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
@@ -156,6 +157,7 @@
  * AUDIT_LIST commands must be implemented. */
 #define AUDIT_MAX_FIELDS   64
 #define AUDIT_MAX_KEY_LEN  256
+#define AUDIT_MAX_REACTS   8
 #define AUDIT_BITMASK_SIZE 64
 #define AUDIT_WORD(nr) ((__u32)((nr)/32))
 #define AUDIT_BIT(nr)  (1 << ((nr) - AUDIT_WORD(nr)*32))
@@ -227,6 +229,8 @@
 
 #define AUDIT_FILTERKEY	210
 
+#define AUDIT_REACTION	220
+
 #define AUDIT_NEGATE			0x80000000
 
 /* These are the supported operators.
@@ -384,6 +388,8 @@ struct audit_krule {
 	u32			action;
 	u32			mask[AUDIT_BITMASK_SIZE];
 	u32			buflen; /* for data alloc on list rules */
+	u32			react_count;
+	u32			react[AUDIT_MAX_REACTS];
 	u32			field_count;
 	char			*filterkey; /* ties events to rules */
 	struct audit_field	*fields;
@@ -600,6 +606,8 @@ extern void		    audit_log_d_path(struct audit_buffer *ab,
 					     struct path *path);
 extern void		    audit_log_key(struct audit_buffer *ab,
 					  char *key);
+extern void		    audit_log_react(struct audit_buffer *ab,
+					    u32 count, u32 *react);
 extern void		    audit_log_lost(const char *message);
 extern int		    audit_update_lsm_rules(void);
 
@@ -623,6 +631,7 @@ extern int audit_enabled;
 #define audit_log_untrustedstring(a,s) do { ; } while (0)
 #define audit_log_d_path(b, p, d) do { ; } while (0)
 #define audit_log_key(b, k) do { ; } while (0)
+#define audit_log_react(b, c, r) do { ; } while (0)
 #define audit_enabled 0
 #endif
 #endif
diff --git a/kernel/audit.c b/kernel/audit.c
index 05a32f0..6f4fd3b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1450,6 +1450,14 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 		audit_log_format(ab, "(null)");
 }
 
+void audit_log_react(struct audit_buffer *ab, u32 count, u32 *react)
+{
+	unsigned int i;
+	for (i = 0; i < count; i++)
+		audit_log_format(ab, " react=%u", react[i]);
+
+}
+
 /**
  * audit_log_end - end one audit record
  * @ab: the audit_buffer
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 28e5b20..b63faa5 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -468,6 +468,7 @@ static void kill_rules(struct audit_tree *tree)
 			audit_log_format(ab, " dir=");
 			audit_log_untrustedstring(ab, rule->tree->pathname);
 			audit_log_key(ab, rule->filterkey);
+			audit_log_react(ab, rule->react_count, rule->react);
 			audit_log_format(ab, " list=%d res=1", rule->listnr);
 			audit_log_end(ab);
 			rule->tree = NULL;
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 7499397..565fbad 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -249,6 +249,7 @@ static void audit_watch_log_rule_change(struct audit_krule *r, struct audit_watc
 		audit_log_format(ab, " path=");
 		audit_log_untrustedstring(ab, w->path);
 		audit_log_key(ab, r->filterkey);
+		audit_log_react(ab, r->react_count, r->react);
 		audit_log_format(ab, " list=%d res=1", r->listnr);
 		audit_log_end(ab);
 	}
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index eb76754..f0eb220 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -229,6 +229,7 @@ static inline struct audit_entry *audit_to_entry_common(struct audit_rule *rule)
 	unsigned listnr;
 	struct audit_entry *entry;
 	int i, err;
+	int r_count = 0;
 
 	err = -EINVAL;
 	listnr = rule->flags & ~AUDIT_FILTER_PREPEND;
@@ -253,15 +254,23 @@ static inline struct audit_entry *audit_to_entry_common(struct audit_rule *rule)
 	if (rule->field_count > AUDIT_MAX_FIELDS)
 		goto exit_err;
 
+	for (i = 0; i < rule->field_count; i++) {
+		if (rule->fields[i] == AUDIT_REACTION)
+			++r_count;
+		if (unlikely(r_count > AUDIT_MAX_REACTS))
+			goto exit_err;
+	}
+
 	err = -ENOMEM;
-	entry = audit_init_entry(rule->field_count);
+	entry = audit_init_entry(rule->field_count - r_count);
 	if (!entry)
 		goto exit_err;
 
 	entry->rule.flags = rule->flags & AUDIT_FILTER_PREPEND;
 	entry->rule.listnr = listnr;
 	entry->rule.action = rule->action;
-	entry->rule.field_count = rule->field_count;
+	entry->rule.field_count = rule->field_count - r_count;
+	entry->rule.react_count = r_count;
 
 	for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
 		entry->rule.mask[i] = rule->mask[i];
@@ -415,7 +424,8 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 	struct audit_entry *entry;
 	void *bufp;
 	size_t remain = datasz - sizeof(struct audit_rule_data);
-	int i;
+	int i, j = 0;
+	int k;
 	char *str;
 
 	entry = audit_to_entry_common((struct audit_rule *)data);
@@ -425,7 +435,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 	bufp = data->buf;
 	entry->rule.vers_ops = 2;
 	for (i = 0; i < data->field_count; i++) {
-		struct audit_field *f = &entry->rule.fields[i];
+		struct audit_field *f = &entry->rule.fields[i - j];
 
 		err = -EINVAL;
 
@@ -433,6 +443,18 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		if (f->op == Audit_bad)
 			goto exit_free;
 
+		if (data->fields[i] == AUDIT_REACTION) {
+			for (k = 0; k < j; k++) {
+				/* reactions must differ */
+				if (entry->rule.react[k] == data->values[i])
+					goto exit_free;
+			}
+			entry->rule.react[j] = data->values[i];
+			++j;
+			entry->rule.react_count = j;
+			continue;
+		}
+
 		f->type = data->fields[i];
 		f->val = data->values[i];
 		f->lsm_str = NULL;
@@ -601,7 +623,7 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 {
 	struct audit_rule_data *data;
 	void *bufp;
-	int i;
+	int i, j;
 
 	data = kmalloc(sizeof(*data) + krule->buflen, GFP_KERNEL);
 	if (unlikely(!data))
@@ -610,9 +632,9 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 
 	data->flags = krule->flags | krule->listnr;
 	data->action = krule->action;
-	data->field_count = krule->field_count;
+	data->field_count = krule->field_count + krule->react_count;
 	bufp = data->buf;
-	for (i = 0; i < data->field_count; i++) {
+	for (i = 0; i < krule->field_count; i++) {
 		struct audit_field *f = &krule->fields[i];
 
 		data->fields[i] = f->type;
@@ -649,6 +671,13 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 			data->values[i] = f->val;
 		}
 	}
+	j = i;
+	for (i = 0; i < krule->react_count; i++, j++) {
+		data->fields[j] = AUDIT_REACTION;
+		data->fieldflags[j] = AUDIT_EQUAL;
+		data->values[j] = krule->react[i];
+	}
+
 	for (i = 0; i < AUDIT_BITMASK_SIZE; i++) data->mask[i] = krule->mask[i];
 
 	return data;
@@ -663,6 +692,7 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
 	if (a->flags != b->flags ||
 	    a->listnr != b->listnr ||
 	    a->action != b->action ||
+	    a->react_count != b->react_count ||
 	    a->field_count != b->field_count)
 		return 1;
 
@@ -705,6 +735,10 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
 				return 1;
 		}
 	}
+	for (i = 0; i < a->react_count; i++) {
+		if (a->react[i] != b->react[i])
+			return 1;
+	}
 
 	for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
 		if (a->mask[i] != b->mask[i])
@@ -769,6 +803,9 @@ struct audit_entry *audit_dupe_rule(struct audit_krule *old)
 	new->prio = old->prio;
 	new->buflen = old->buflen;
 	new->inode_f = old->inode_f;
+	new->react_count = old->react_count;
+	for (i = 0; i < new->react_count; i++)
+		new->react[i] = old->react[i];
 	new->field_count = old->field_count;
 
 	/*
@@ -1075,6 +1112,7 @@ static void audit_log_rule_change(uid_t loginuid, u32 sessionid, u32 sid,
 	audit_log_format(ab, " op=");
 	audit_log_string(ab, action);
 	audit_log_key(ab, rule->filterkey);
+	audit_log_react(ab, rule->react_count, rule->react);
 	audit_log_format(ab, " list=%d res=%d", rule->listnr, res);
 	audit_log_end(ab);
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index bc2b57a..57ad669 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -176,6 +176,8 @@ struct audit_context {
 	int		    return_valid; /* return code is valid */
 	int		    name_count;
 	struct audit_names  names[AUDIT_NAMES];
+	int		    react_count;
+	u32		    react[AUDIT_MAX_REACTS];
 	char *		    filterkey;	/* key for rule that triggered record */
 	struct path	    pwd;
 	struct audit_context *previous; /* For nested syscalls */
@@ -622,6 +624,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 				result = audit_comparator(ctx->argv[f->type-AUDIT_ARG0], f->op, f->val);
 			break;
 		case AUDIT_FILTERKEY:
+		case AUDIT_REACTION:
 			/* ignore this field for filtering */
 			result = 1;
 			break;
@@ -642,6 +645,9 @@ static int audit_filter_rules(struct task_struct *tsk,
 	if (ctx) {
 		if (rule->prio <= ctx->prio)
 			return 0;
+		ctx->react_count = rule->react_count;
+		for (i = 0; i < ctx->react_count; i++)
+			ctx->react[i] = rule->react[i];
 		if (rule->filterkey) {
 			kfree(ctx->filterkey);
 			ctx->filterkey = kstrdup(rule->filterkey, GFP_ATOMIC);
@@ -1332,6 +1338,19 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	context->fsgid = cred->fsgid;
 	context->personality = tsk->personality;
 
+	if (context->react_count) {
+		ab = audit_log_start(context, GFP_KERNEL, AUDIT_REACT_RULE);
+		if (!ab)
+			return;
+		for (i = 0; i < context->react_count; i++) {
+			if (!i)
+				audit_log_format(ab, "react=%u", context->react[i]);
+			else
+				audit_log_format(ab, " react=%u", context->react[i]);
+		}
+		audit_log_end(ab);
+	}
+
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
 	if (!ab)
 		return;		/* audit_panic has been called */
@@ -1645,6 +1664,7 @@ void audit_syscall_entry(int arch, int major,
 
 void audit_finish_fork(struct task_struct *child)
 {
+	int i;
 	struct audit_context *ctx = current->audit_context;
 	struct audit_context *p = child->audit_context;
 	if (!p || !ctx)
@@ -1658,6 +1678,9 @@ void audit_finish_fork(struct task_struct *child)
 	p->dummy = ctx->dummy;
 	p->in_syscall = ctx->in_syscall;
 	p->filterkey = kstrdup(ctx->filterkey, GFP_KERNEL);
+	p->react_count = ctx->react_count;
+	for (i = 0; i < p->react_count; i++)
+		p->react[i] = ctx->react[i];
 	p->ppid = current->pid;
 	p->prio = ctx->prio;
 	p->current_state = ctx->current_state;
-- 
1.6.4.4

