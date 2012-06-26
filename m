Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab2FZQgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:36:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33496 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715Ab2FZQfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:35:55 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 9/9] audit: overhaul __audit_inode_child to accomodate retrying
Date: Tue, 26 Jun 2012 12:35:37 -0400
Message-Id: <1340728537-25599-10-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340728537-25599-1-git-send-email-jlayton@redhat.com>
References: <1340728537-25599-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to accomodate retrying path-based syscalls, we need to add a
new "type" argument to audit_inode_child. This will tell us whether
we're looking for a child entry that represents a create or a delete.

If we find a parent, don't automatically assume that we need to create a
new entry. Instead, use the information we have to try to find an
existing entry first. Update it if one is found and create a new one if
not.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/ioctl.c         |    2 +-
 fs/namei.c               |    2 +-
 include/linux/audit.h    |   12 ++++++---
 include/linux/fsnotify.h |    8 +++---
 kernel/auditsc.c         |   57 ++++++++++++++++++++++++---------------------
 5 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 90c67b0..b638ac5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -592,7 +592,7 @@ static int btrfs_may_delete(struct inode *dir,struct dentry *victim,int isdir)
 		return -ENOENT;
 
 	BUG_ON(victim->d_parent->d_inode != dir);
-	audit_inode_child(dir, victim);
+	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
 
 	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
diff --git a/fs/namei.c b/fs/namei.c
index 8c1b3cd..196f039 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1998,7 +1998,7 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
 		return -ENOENT;
 
 	BUG_ON(victim->d_parent->d_inode != dir);
-	audit_inode_child(dir, victim);
+	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
 
 	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 2fc6831..7a15359 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -454,6 +454,8 @@ extern int audit_classify_arch(int arch);
 #define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */
 #define AUDIT_TYPE_NORMAL	1	/* a "normal" audit record */
 #define AUDIT_TYPE_PARENT	2	/* a parent audit record */
+#define AUDIT_TYPE_CHILD_DELETE 3	/* a child being deleted */
+#define AUDIT_TYPE_CHILD_CREATE 4	/* a child being created */
 
 #ifdef CONFIG_AUDITSYSCALL
 /* These are defined in auditsc.c */
@@ -469,7 +471,8 @@ extern void audit_putname(const char *name);
 extern void __audit_inode(const char *name, const struct dentry *dentry,
 				unsigned int parent);
 extern void __audit_inode_child(const struct inode *parent,
-				const struct dentry *dentry);
+				const struct dentry *dentry,
+				const unsigned char type);
 extern void __audit_seccomp(unsigned long syscall, long signr, int code);
 extern void __audit_ptrace(struct task_struct *t);
 
@@ -510,9 +513,10 @@ static inline void audit_inode(const char *name, const struct dentry *dentry,
 		__audit_inode(name, dentry, parent);
 }
 static inline void audit_inode_child(const struct inode *parent,
-				     const struct dentry *dentry) {
+				     const struct dentry *dentry,
+				     const unsigned char type) {
 	if (unlikely(!audit_dummy_context()))
-		__audit_inode_child(parent, dentry);
+		__audit_inode_child(parent, dentry, type);
 }
 void audit_core_dumps(long signr);
 
@@ -640,7 +644,7 @@ extern int audit_signals;
 #define __audit_inode(n,d,p) do { ; } while (0)
 #define __audit_inode_child(p,d) do { ; } while (0)
 #define audit_inode(n,d,p) do { (void)(d); } while (0)
-#define audit_inode_child(p,d) do { ; } while (0)
+#define audit_inode_child(p,d,t) do { ; } while (0)
 #define audit_core_dumps(i) do { ; } while (0)
 #define audit_seccomp(i,s,c) do { ; } while (0)
 #define auditsc_get_stamp(c,t,s) (0)
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 9c28471..0fbfb46 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -109,7 +109,7 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 
 	if (source)
 		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
-	audit_inode_child(new_dir, moved);
+	audit_inode_child(new_dir, moved, AUDIT_TYPE_CHILD_CREATE);
 }
 
 /*
@@ -155,7 +155,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 {
-	audit_inode_child(inode, dentry);
+	audit_inode_child(inode, dentry, AUDIT_TYPE_CHILD_CREATE);
 
 	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
@@ -168,7 +168,7 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
 {
 	fsnotify_link_count(inode);
-	audit_inode_child(dir, new_dentry);
+	audit_inode_child(dir, new_dentry, AUDIT_TYPE_CHILD_CREATE);
 
 	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
 }
@@ -181,7 +181,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 	__u32 mask = (FS_CREATE | FS_ISDIR);
 	struct inode *d_inode = dentry->d_inode;
 
-	audit_inode_child(inode, dentry);
+	audit_inode_child(inode, dentry, AUDIT_TYPE_CHILD_CREATE);
 
 	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f4cdefe..bafb618 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2199,6 +2199,7 @@ out:
  * __audit_inode_child - collect inode info for created/removed objects
  * @parent: inode of dentry parent
  * @dentry: dentry being audited
+ * @type:   AUDIT_TYPE_* value that we're looking for
  *
  * For syscalls that create or remove filesystem objects, audit_inode
  * can only collect information for the filesystem object's parent.
@@ -2209,13 +2210,13 @@ out:
  * unsuccessful attempts.
  */
 void __audit_inode_child(const struct inode *parent,
-			 const struct dentry *dentry)
+			 const struct dentry *dentry,
+			 const unsigned char type)
 {
 	struct audit_context *context = current->audit_context;
-	const char *found_parent = NULL, *found_child = NULL;
 	const struct inode *inode = dentry->d_inode;
 	const char *dname = dentry->d_name.name;
-	struct audit_names *n;
+	struct audit_names *n, *found_parent = NULL, *found_child = NULL;
 
 	if (!context->in_syscall)
 		return;
@@ -2223,63 +2224,65 @@ void __audit_inode_child(const struct inode *parent,
 	if (inode)
 		handle_one(inode);
 
-	/* parent is more likely, look for it first */
+	/* look for a parent entry first */
 	list_for_each_entry(n, &context->names_list, list) {
-		if (!n->name)
+		if (!n->name || n->type != AUDIT_TYPE_PARENT)
 			continue;
 
 		if (n->ino == parent->i_ino &&
 		    !audit_compare_dname_path(dname, n->name, n->name_len)) {
-			found_parent = n->name;
-			goto add_names;
+			found_parent = n;
+			break;
 		}
 	}
 
-	/* no matching parent, look for matching child */
+	/* is there a matching child entry? */
 	list_for_each_entry(n, &context->names_list, list) {
-		if (!n->name)
+		/* can only match entries that have a name */
+		if (!n->name || n->type != type)
+			continue;
+
+		/* if we found a parent, make sure this one is a child of it */
+		if (found_parent && (n->name != found_parent->name))
 			continue;
 
-		/* strcmp() is the more likely scenario */
 		if (!strcmp(dname, n->name) ||
 		    !audit_compare_dname_path(dname, n->name,
+						found_parent ?
+						found_parent->name_len :
 						AUDIT_NAME_FULL)) {
-			if (inode)
-				audit_copy_inode(n, dentry, inode);
-			else
-				n->ino = (unsigned long)-1;
-			n->type = AUDIT_TYPE_NORMAL;
-			found_child = n->name;
-			goto add_names;
+			found_child = n;
+			break;
 		}
 	}
 
-add_names:
 	if (!found_parent) {
-		n = audit_alloc_name(context, AUDIT_TYPE_NORMAL);
+		/* create a new, "anonymous" parent record */
+		n = audit_alloc_name(context, AUDIT_TYPE_PARENT);
 		if (!n)
 			return;
 		audit_copy_inode(n, NULL, parent);
 	}
 
 	if (!found_child) {
-		n = audit_alloc_name(context, AUDIT_TYPE_NORMAL);
-		if (!n)
+		found_child = audit_alloc_name(context, type);
+		if (!found_child)
 			return;
 
 		/* Re-use the name belonging to the slot for a matching parent
 		 * directory. All names for this context are relinquished in
 		 * audit_free_names() */
 		if (found_parent) {
-			n->name = found_parent;
-			n->name_len = AUDIT_NAME_FULL;
+			found_child->name = found_parent->name;
+			found_child->name_len = AUDIT_NAME_FULL;
 			/* don't call __putname() */
-			n->name_put = false;
+			found_child->name_put = false;
 		}
-
-		if (inode)
-			audit_copy_inode(n, dentry, inode);
 	}
+	if (inode)
+		audit_copy_inode(found_child, dentry, inode);
+	else
+		found_child->ino = (unsigned long)-1;
 }
 EXPORT_SYMBOL_GPL(__audit_inode_child);
 
-- 
1.7.7.6

