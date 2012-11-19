Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2KSKur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:50:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46658 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2KSKun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:50:43 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 02:50:18 -0800
Message-Id: <1353322222-27060-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353322222-27060-1-git-send-email-ebiederm@xmission.com>
References: <87k3thc1h3.fsf@xmission.com>
 <1353322222-27060-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+B9WJHfQEaWQT3AJnoUaH+FYfwfKOs7kM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0478]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 2/6] vfs: Add setns support for the mount namespace
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

setns support for the mount namespace is a little tricky as an
arbitrary decision must be made about what to set fs->root and
fs->pwd to, as there is no expectation of a relationship between
the two mount namespaces.  Therefore I arbitrarily find the root
mount point, and follow every mount on top of it to find the top
of the mount stack.  Then I set fs->root and fs->pwd to that
location.  The topmost root of the mount stack seems like a
reasonable place to be.

Bind mount support for the mount namespace inodes has the
possibility of creating circular dependencies between mount
namespaces.  Circular dependencies can result in loops that
prevent mount namespaces from every being freed.  I avoid
creating those circular dependencies by adding a sequence number
to the mount namespace and require all bind mounts be of a
younger mount namespace into an older mount namespace.

Add a helper function proc_ns_inode so it is possible to
detect when we are attempting to bind mound a namespace inode.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/mount.h              |    1 +
 fs/namespace.c          |   95 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/namespaces.c    |    5 ++
 include/linux/proc_fs.h |    7 +++
 4 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index 4f291f9..e9c37dd 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -6,6 +6,7 @@ struct mnt_namespace {
 	atomic_t		count;
 	struct mount *	root;
 	struct list_head	list;
+	u64			seq;	/* Sequence number to prevent loops */
 	wait_queue_head_t poll;
 	int event;
 };
diff --git a/fs/namespace.c b/fs/namespace.c
index 2496062..d287e7e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -20,6 +20,7 @@
 #include <linux/fs_struct.h>	/* get_fs_root et.al. */
 #include <linux/fsnotify.h>	/* fsnotify_vfsmount_delete */
 #include <linux/uaccess.h>
+#include <linux/proc_fs.h>
 #include "pnode.h"
 #include "internal.h"
 
@@ -1308,6 +1309,26 @@ static int mount_is_safe(struct path *path)
 #endif
 }
 
+static bool mnt_ns_loop(struct path *path)
+{
+	/* Could bind mounting the mount namespace inode cause a
+	 * mount namespace loop?
+	 */
+	struct inode *inode = path->dentry->d_inode;
+	struct proc_inode *ei;
+	struct mnt_namespace *mnt_ns;
+
+	if (!proc_ns_inode(inode))
+		return false;
+
+	ei = PROC_I(inode);
+	if (ei->ns_ops != &mntns_operations)
+		return false;
+
+	mnt_ns = ei->ns;
+	return current->nsproxy->mnt_ns->seq >= mnt_ns->seq;
+}
+
 struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
 					int flag)
 {
@@ -1655,6 +1676,10 @@ static int do_loopback(struct path *path, const char *old_name,
 	if (err)
 		return err;
 
+	err = -EINVAL;
+	if (mnt_ns_loop(&old_path))
+		goto out; 
+
 	err = lock_mount(path);
 	if (err)
 		goto out;
@@ -2261,6 +2286,15 @@ dput_out:
 	return retval;
 }
 
+/*
+ * Assign a sequence number so we can detect when we attempt to bind
+ * mount a reference to an older mount namespace into the current
+ * mount namespace, preventing reference counting loops.  A 64bit
+ * number incrementing at 10Ghz will take 12,427 years to wrap which
+ * is effectively never, so we can ignore the possibility.
+ */
+static atomic64_t mnt_ns_seq = ATOMIC64_INIT(1);
+
 static struct mnt_namespace *alloc_mnt_ns(void)
 {
 	struct mnt_namespace *new_ns;
@@ -2268,6 +2302,7 @@ static struct mnt_namespace *alloc_mnt_ns(void)
 	new_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
 	if (!new_ns)
 		return ERR_PTR(-ENOMEM);
+	new_ns->seq = atomic64_add_return(1, &mnt_ns_seq);
 	atomic_set(&new_ns->count, 1);
 	new_ns->root = NULL;
 	INIT_LIST_HEAD(&new_ns->list);
@@ -2681,3 +2716,63 @@ bool our_mnt(struct vfsmount *mnt)
 {
 	return check_mnt(real_mount(mnt));
 }
+
+static void *mntns_get(struct task_struct *task)
+{
+	struct mnt_namespace *ns = NULL;
+	struct nsproxy *nsproxy;
+
+	rcu_read_lock();
+	nsproxy = task_nsproxy(task);
+	if (nsproxy) {
+		ns = nsproxy->mnt_ns;
+		get_mnt_ns(ns);
+	}
+	rcu_read_unlock();
+
+	return ns;
+}
+
+static void mntns_put(void *ns)
+{
+	put_mnt_ns(ns);
+}
+
+static int mntns_install(struct nsproxy *nsproxy, void *ns)
+{
+	struct fs_struct *fs = current->fs;
+	struct mnt_namespace *mnt_ns = ns;
+	struct path root;
+
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_CHROOT))
+		return -EINVAL;
+
+	if (fs->users != 1)
+		return -EINVAL;
+
+	get_mnt_ns(mnt_ns);
+	put_mnt_ns(nsproxy->mnt_ns);
+	nsproxy->mnt_ns = mnt_ns;
+
+	/* Find the root */
+	root.mnt    = &mnt_ns->root->mnt;
+	root.dentry = mnt_ns->root->mnt.mnt_root;
+	path_get(&root);
+	while(d_mountpoint(root.dentry) && follow_down_one(&root))
+		;
+
+	/* Update the pwd and root */
+	set_fs_pwd(fs, &root);
+	set_fs_root(fs, &root);
+
+	path_put(&root);
+	return 0;
+}
+
+const struct proc_ns_operations mntns_operations = {
+	.name		= "mnt",
+	.type		= CLONE_NEWNS,
+	.get		= mntns_get,
+	.put		= mntns_put,
+	.install	= mntns_install,
+};
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index b178ed7..f91b1ed 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -24,6 +24,7 @@ static const struct proc_ns_operations *ns_entries[] = {
 #ifdef CONFIG_IPC_NS
 	&ipcns_operations,
 #endif
+	&mntns_operations,
 };
 
 static const struct file_operations ns_file_operations = {
@@ -198,3 +199,7 @@ out_invalid:
 	return ERR_PTR(-EINVAL);
 }
 
+bool proc_ns_inode(struct inode *inode)
+{
+	return inode->i_fop == &ns_file_operations;
+}
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 3fd2e87..bf1df81 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -174,6 +174,7 @@ extern struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
 	struct proc_dir_entry *parent);
 
 extern struct file *proc_ns_fget(int fd);
+extern bool proc_ns_inode(struct inode *inode);
 
 #else
 
@@ -229,6 +230,11 @@ static inline struct file *proc_ns_fget(int fd)
 	return ERR_PTR(-EINVAL);
 }
 
+static inline bool proc_ns_inode(struct inode *inode)
+{
+	return false;
+}
+
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)
@@ -251,6 +257,7 @@ struct proc_ns_operations {
 extern const struct proc_ns_operations netns_operations;
 extern const struct proc_ns_operations utsns_operations;
 extern const struct proc_ns_operations ipcns_operations;
+extern const struct proc_ns_operations mntns_operations;
 
 union proc_op {
 	int (*proc_get_link)(struct dentry *, struct path *);
-- 
1.7.5.4

