Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2BUTxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:53:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab2BUTxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/73] whiteout: Add vfs_whiteout() and whiteout inode
 operation [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        Jan Blunck <jblunck@suse.de> (Original author),
        David Woodhouse <dwmw2@infradead.org>,
        Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com> (Forward port)
Date: Tue, 21 Feb 2012 17:59:05 +0000
Message-ID: <20120221175905.25235.97225.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whiteout a given directory entry.  File systems that support whiteouts
must implement the new ->whiteout() directory inode operation.

XXX - Only whiteout when there is a matching entry in a lower layer.

Signed-off-by: Jan Blunck <jblunck@suse.de> (Original author)
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Forward port)
---

 Documentation/filesystems/vfs.txt |   10 ++++
 fs/dcache.c                       |    1 
 fs/namei.c                        |   89 +++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h            |    6 ++
 include/linux/fs.h                |    2 +
 5 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 3d9393b..8575c5b 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -338,7 +338,7 @@ struct inode_operations
 -----------------------
 
 This describes how the VFS can manipulate an inode in your
-filesystem. As of kernel 2.6.22, the following members are defined:
+filesystem. As of kernel 2.6.34, the following members are defined:
 
 struct inode_operations {
 	int (*create) (struct inode *,struct dentry *, umode_t, struct nameidata *);
@@ -349,6 +349,7 @@ struct inode_operations {
 	int (*mkdir) (struct inode *,struct dentry *,umode_t);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
+	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);
@@ -413,6 +414,13 @@ otherwise noted.
 	will probably need to call d_instantiate() just as you would
 	in the create() method
 
+  whiteout: called by the rmdir(2) and unlink(2) system calls on a
+        layered file system.  Only required if you want to support
+        whiteouts.  The first dentry passed in is that for the old
+        dentry if it exists, and a negative dentry otherwise.  The
+        second is the dentry for the whiteout itself.  This method
+        must unlink() or rmdir() the original entry if it exists.
+
   rename: called by the rename(2) system call to rename the object to
 	have the parent and name given by the second inode and dentry.
 
diff --git a/fs/dcache.c b/fs/dcache.c
index fe19ac1..a8355d5 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1311,6 +1311,7 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	spin_lock(&dentry->d_lock);
 	if (inode) {
+		dentry->d_flags &= ~DCACHE_WHITEOUT;
 		if (unlikely(IS_AUTOMOUNT(inode)))
 			dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
 		list_add(&dentry->d_alias, &inode->i_dentry);
diff --git a/fs/namei.c b/fs/namei.c
index 7f9df02..3d396fd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1948,7 +1948,6 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
 	if (!victim->d_inode)
 		return -ENOENT;
 
-	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim, dir);
 
 	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
@@ -2647,6 +2646,94 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 	return sys_mkdirat(AT_FDCWD, pathname, mode);
 }
 
+/**
+ * vfs_whiteout: Create a whiteout for the given directory entry
+ * @dir: Parent inode
+ * @dentry: Directory entry to whiteout
+ *
+ * Create a whiteout for the given directory entry.  A whiteout prevents lookup
+ * from dropping down to a lower layer of a union mounted file system.
+ *
+ * There are two important cases: (a) The directory entry to be whited-out may
+ * already exist, in which case it must first be deleted before we create the
+ * whiteout, and (b) no such directory entry exists and we only have to create
+ * the whiteout itself.
+ *
+ * The caller must pass in a dentry for the directory entry to be whited-out -
+ * a positive one if it exists, and a negative if not.  When this function
+ * returns, the caller should dput() the old, now defunct dentry it passed in.
+ * The dentry for the whiteout itself is created inside this function.
+ */
+static int vfs_whiteout(struct inode *dir, struct dentry *old_dentry, int isdir)
+{
+	struct inode *old_inode = old_dentry->d_inode;
+	struct dentry *parent, *whiteout;
+	bool do_dput = false;
+	int err = 0;
+
+	BUG_ON(old_dentry->d_parent->d_inode != dir);
+
+	if (!dir->i_op || !dir->i_op->whiteout)
+		return -EOPNOTSUPP;
+
+	/* If the old dentry is positive, then we have to delete this entry
+	 * before we create the whiteout.  The file system ->whiteout() op does
+	 * the actual delete, but we do all the VFS-level checks and changes
+	 * here.
+	 */
+	if (old_inode) {
+		mutex_lock(&old_inode->i_mutex);
+		if (d_mountpoint(old_dentry)) {
+			mutex_unlock(&old_inode->i_mutex);
+			return -EBUSY;
+		}
+		if (isdir)
+			err = security_inode_rmdir(dir, old_dentry);
+		else
+			err = security_inode_unlink(dir, old_dentry);
+		if (err)
+			goto error_unlock;
+	}
+
+	parent = dget_parent(old_dentry);
+	err = -ENOMEM;
+	whiteout = d_alloc_name(parent, old_dentry->d_name.name);
+	if (!whiteout)
+		goto error_put_parent;
+
+	if (old_inode && isdir) {
+		dentry_unhash(old_dentry);
+		do_dput = true;
+	}
+
+	err = dir->i_op->whiteout(dir, old_dentry, whiteout);
+	if (err)
+		goto error_put_whiteout;
+
+	if (old_inode) {
+		mutex_unlock(&old_inode->i_mutex);
+		fsnotify_link_count(old_inode);
+		d_delete(old_dentry);
+		if (do_dput)
+			dput(old_dentry);
+	}
+
+	dput(whiteout);
+	dput(parent);
+	return err;
+
+error_put_whiteout:
+	dput(whiteout);
+error_put_parent:
+	dput(parent);
+error_unlock:
+	if (old_inode)
+		mutex_unlock(&old_inode->i_mutex);
+	if (do_dput)
+		dput(old_dentry);
+	return err;
+}
+
 /*
  * The dentry_unhash() helper will try to drop the dentry early: we
  * should have a usage count of 2 if we're the only user of this
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index d64a55b..f22f530 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -204,6 +204,7 @@ struct dentry_operations {
 #define DCACHE_CANT_MOUNT	0x0100
 #define DCACHE_GENOCIDE		0x0200
 #define DCACHE_SHRINK_LIST	0x0400
+#define DCACHE_WHITEOUT		0x0800	/* Stop lookup in a unioned file system */
 
 #define DCACHE_NFSFS_RENAMED	0x1000
      /* this dentry has been "silly renamed" and has to be deleted on the last
@@ -414,6 +415,11 @@ static inline bool d_managed(struct dentry *dentry)
 	return dentry->d_flags & DCACHE_MANAGED_DENTRY;
 }
 
+static inline int d_is_whiteout(struct dentry *dentry)
+{
+	return dentry->d_flags & DCACHE_WHITEOUT;
+}
+
 static inline bool d_mountpoint(struct dentry *dentry)
 {
 	return dentry->d_flags & DCACHE_MOUNTED;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ab36080..1e4ae06 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -210,6 +210,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_WHITEOUT	(1<<25) /* FS supports whiteout filetype */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
@@ -1651,6 +1652,7 @@ struct inode_operations {
 	int (*mkdir) (struct inode *,struct dentry *,umode_t);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
+	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	void (*truncate) (struct inode *);

