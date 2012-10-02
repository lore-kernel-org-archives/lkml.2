Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2JBARx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:17:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61020 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2JBARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:11 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 04/49] audit: reverse arguments to audit_inode_child
Date: Mon,  1 Oct 2012 20:16:13 -0400
Message-Id: <1349137018-21948-5-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the callers get called with an inode and dentry in the reverse
order. The compiler then has to reshuffle the arg registers and/or
stack in order to pass them on to audit_inode_child.

Reverse those arguments for a micro-optimization.

Reported-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/ioctl.c         |  2 +-
 fs/namei.c               |  2 +-
 include/linux/audit.h    | 14 +++++++-------
 include/linux/fsnotify.h |  8 ++++----
 kernel/auditsc.c         |  8 ++++----
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9df50fa..7e78d47 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -614,7 +614,7 @@ static int btrfs_may_delete(struct inode *dir,struct dentry *victim,int isdir)
 		return -ENOENT;
 
 	BUG_ON(victim->d_parent->d_inode != dir);
-	audit_inode_child(victim, dir);
+	audit_inode_child(dir, victim);
 
 	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
diff --git a/fs/namei.c b/fs/namei.c
index e3661762..d431111 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2180,7 +2180,7 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
 		return -ENOENT;
 
 	BUG_ON(victim->d_parent->d_inode != dir);
-	audit_inode_child(victim, dir);
+	audit_inode_child(dir, victim);
 
 	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 36abf2a..2d8b761 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -462,8 +462,8 @@ extern void __audit_syscall_exit(int ret_success, long ret_value);
 extern void __audit_getname(const char *name);
 extern void audit_putname(const char *name);
 extern void __audit_inode(const char *name, const struct dentry *dentry);
-extern void __audit_inode_child(const struct dentry *dentry,
-				const struct inode *parent);
+extern void __audit_inode_child(const struct inode *parent,
+				const struct dentry *dentry);
 extern void __audit_seccomp(unsigned long syscall, long signr, int code);
 extern void __audit_ptrace(struct task_struct *t);
 
@@ -502,10 +502,10 @@ static inline void audit_inode(const char *name, const struct dentry *dentry) {
 	if (unlikely(!audit_dummy_context()))
 		__audit_inode(name, dentry);
 }
-static inline void audit_inode_child(const struct dentry *dentry,
-				     const struct inode *parent) {
+static inline void audit_inode_child(const struct inode *parent,
+				     const struct dentry *dentry) {
 	if (unlikely(!audit_dummy_context()))
-		__audit_inode_child(dentry, parent);
+		__audit_inode_child(parent, dentry);
 }
 void audit_core_dumps(long signr);
 
@@ -631,9 +631,9 @@ extern int audit_signals;
 #define audit_getname(n) do { ; } while (0)
 #define audit_putname(n) do { ; } while (0)
 #define __audit_inode(n,d) do { ; } while (0)
-#define __audit_inode_child(i,p) do { ; } while (0)
+#define __audit_inode_child(p,d) do { ; } while (0)
 #define audit_inode(n,d) do { (void)(d); } while (0)
-#define audit_inode_child(i,p) do { ; } while (0)
+#define audit_inode_child(p,d) do { ; } while (0)
 #define audit_core_dumps(i) do { ; } while (0)
 #define audit_seccomp(i,s,c) do { ; } while (0)
 #define auditsc_get_stamp(c,t,s) (0)
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index a6dfe69..9c28471 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -109,7 +109,7 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 
 	if (source)
 		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
-	audit_inode_child(moved, new_dir);
+	audit_inode_child(new_dir, moved);
 }
 
 /*
@@ -155,7 +155,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 {
-	audit_inode_child(dentry, inode);
+	audit_inode_child(inode, dentry);
 
 	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
@@ -168,7 +168,7 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
 {
 	fsnotify_link_count(inode);
-	audit_inode_child(new_dentry, dir);
+	audit_inode_child(dir, new_dentry);
 
 	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
 }
@@ -181,7 +181,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 	__u32 mask = (FS_CREATE | FS_ISDIR);
 	struct inode *d_inode = dentry->d_inode;
 
-	audit_inode_child(dentry, inode);
+	audit_inode_child(inode, dentry);
 
 	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4099440..ff58089 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2180,9 +2180,9 @@ out:
 }
 
 /**
- * audit_inode_child - collect inode info for created/removed objects
- * @dentry: dentry being audited
+ * __audit_inode_child - collect inode info for created/removed objects
  * @parent: inode of dentry parent
+ * @dentry: dentry being audited
  *
  * For syscalls that create or remove filesystem objects, audit_inode
  * can only collect information for the filesystem object's parent.
@@ -2192,8 +2192,8 @@ out:
  * must be hooked prior, in order to capture the target inode during
  * unsuccessful attempts.
  */
-void __audit_inode_child(const struct dentry *dentry,
-			 const struct inode *parent)
+void __audit_inode_child(const struct inode *parent,
+			 const struct dentry *dentry)
 {
 	struct audit_context *context = current->audit_context;
 	const char *found_parent = NULL, *found_child = NULL;
-- 
1.7.11.4

