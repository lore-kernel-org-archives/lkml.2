Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0GMVz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:55:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab0GMVzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:55:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com
Subject: [RFC][PATCH] Add a dentry op to handle automounting rather than abusing follow_link
Date: Tue, 13 Jul 2010 22:55:50 +0100
Message-ID: <27282.1279058150@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a dentry op (d_automount) to handle automounting directories rather than
abusing the follow_link() inode operation.

I've only changed __follow_mount() to handle automount points, but it might be
necessary to change follow_mount() too.  The latter is only used from
follow_dotdot(), but any automounts on ".." should be pinned whilst we're using
a child of it.

AFS is made to use this facility so that it can be tested.  Other filesystems
abusing the follow_mount() inode operation will also need to be modified.

Not-yet-signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/Locking |    2 +
 Documentation/filesystems/vfs.txt |   13 +++++
 fs/afs/dir.c                      |   12 ++++-
 fs/afs/internal.h                 |    1 
 fs/afs/mntpt.c                    |   45 +++++------------
 fs/namei.c                        |   96 +++++++++++++++++++++++++------------
 include/linux/dcache.h            |    7 +++
 7 files changed, 112 insertions(+), 64 deletions(-)


diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 96d4293..ccbfa98 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -16,6 +16,7 @@ prototypes:
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
+	struct vfsmount *(*d_automount)(struct path *path);
 
 locking rules:
 	none have BKL
@@ -27,6 +28,7 @@ d_delete:	yes		no		yes		no
 d_release:	no		no		no		yes
 d_iput:		no		no		no		yes
 d_dname:	no		no		no		no
+d_automount:	no		no		no		yes
 
 --------------------------- inode_operations --------------------------- 
 prototypes:
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 94677e7..040a85f 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -851,6 +851,7 @@ struct dentry_operations {
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
+	struct vfsmount *(*d_automount)(struct path *);
 };
 
   d_revalidate: called when the VFS needs to revalidate a dentry. This
@@ -885,6 +886,18 @@ struct dentry_operations {
 	at the end of the buffer, and returns a pointer to the first char.
 	dynamic_dname() helper function is provided to take care of this.
 
+  d_automount: called when an automount dentry is to be traversed (optional).
+	This should create a new VFS mount record, mount it on the directory
+	and return the record to the caller.  The caller is supplied with a
+	path parameter giving the automount directory to describe the automount
+	target and the parent VFS mount record to provide inheritable mount
+	parameters.  NULL should be returned if someone else managed to make
+	the automount first.  If the automount failed, then an error code
+	should be returned.
+
+	The presence of a non-NULL d_automount for a dentry is taken to
+	indicate that the directory is an automount point.
+
 Example :
 
 static char *pipefs_dname(struct dentry *dent, char *buffer, int buflen)
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index afb9ff8..cc2eb94 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -67,6 +67,13 @@ static const struct dentry_operations afs_fs_dentry_operations = {
 	.d_release	= afs_d_release,
 };
 
+static const struct dentry_operations afs_mntpt_dentry_operations = {
+	.d_revalidate	= afs_d_revalidate,
+	.d_delete	= afs_d_delete,
+	.d_release	= afs_d_release,
+	.d_automount	= afs_mntpt_d_automount,
+};
+
 #define AFS_DIR_HASHTBL_SIZE	128
 #define AFS_DIR_DIRENT_SIZE	32
 #define AFS_DIRENT_PER_BLOCK	64
@@ -539,7 +546,10 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 		return ERR_CAST(inode);
 	}
 
-	dentry->d_op = &afs_fs_dentry_operations;
+	if (test_bit(AFS_VNODE_MOUNTPOINT, &AFS_FS_I(inode)->flags))
+		dentry->d_op = &afs_mntpt_dentry_operations;
+	else
+		dentry->d_op = &afs_fs_dentry_operations;
 
 	d_add(dentry, inode);
 	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%u }",
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 5f679b7..47b99b5 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -583,6 +583,7 @@ extern int afs_abort_to_error(u32);
 extern const struct inode_operations afs_mntpt_inode_operations;
 extern const struct file_operations afs_mntpt_file_operations;
 
+extern struct vfsmount *afs_mntpt_d_automount(struct path *);
 extern int afs_mntpt_check_symlink(struct afs_vnode *, struct key *);
 extern void afs_mntpt_kill_timer(void);
 
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index a9e2303..5b95370 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -24,7 +24,6 @@ static struct dentry *afs_mntpt_lookup(struct inode *dir,
 				       struct dentry *dentry,
 				       struct nameidata *nd);
 static int afs_mntpt_open(struct inode *inode, struct file *file);
-static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd);
 static void afs_mntpt_expiry_timed_out(struct work_struct *work);
 
 const struct file_operations afs_mntpt_file_operations = {
@@ -33,7 +32,6 @@ const struct file_operations afs_mntpt_file_operations = {
 
 const struct inode_operations afs_mntpt_inode_operations = {
 	.lookup		= afs_mntpt_lookup,
-	.follow_link	= afs_mntpt_follow_link,
 	.readlink	= page_readlink,
 	.getattr	= afs_getattr,
 };
@@ -205,52 +203,37 @@ error_no_devname:
 }
 
 /*
- * follow a link from a mountpoint directory, thus causing it to be mounted
+ * handle an automount point
  */
-static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd)
+struct vfsmount *afs_mntpt_d_automount(struct path *path)
 {
 	struct vfsmount *newmnt;
 	int err;
 
-	_enter("%p{%s},{%s:%p{%s},}",
-	       dentry,
-	       dentry->d_name.name,
-	       nd->path.mnt->mnt_devname,
-	       dentry,
-	       nd->path.dentry->d_name.name);
-
-	dput(nd->path.dentry);
-	nd->path.dentry = dget(dentry);
+	_enter("{%s,%s}", path->mnt->mnt_devname, path->dentry->d_name.name);
 
-	newmnt = afs_mntpt_do_automount(nd->path.dentry);
-	if (IS_ERR(newmnt)) {
-		path_put(&nd->path);
-		return (void *)newmnt;
-	}
+	newmnt = afs_mntpt_do_automount(path->dentry);
+	if (IS_ERR(newmnt))
+		return newmnt;
 
 	mntget(newmnt);
-	err = do_add_mount(newmnt, &nd->path, MNT_SHRINKABLE, &afs_vfsmounts);
+	err = do_add_mount(newmnt, path, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		path_put(&nd->path);
-		nd->path.mnt = newmnt;
-		nd->path.dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
 				      afs_mntpt_expiry_timeout * HZ);
-		break;
+		_leave(" = %p {%s}", newmnt, newmnt->mnt_devname);
+		return newmnt;
 	case -EBUSY:
 		/* someone else made a mount here whilst we were busy */
-		while (d_mountpoint(nd->path.dentry) &&
-		       follow_down(&nd->path))
-			;
-		err = 0;
+		mntput(newmnt);
+		_leave(" = NULL [EBUSY]");
+		return NULL;
 	default:
 		mntput(newmnt);
-		break;
+		_leave(" = %d", err);
+		return ERR_PTR(err);
 	}
-
-	_leave(" = %d", err);
-	return ERR_PTR(err);
 }
 
 /*
diff --git a/fs/namei.c b/fs/namei.c
index 868d0cb..19b99f9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -617,24 +617,65 @@ int follow_up(struct path *path)
 	return 1;
 }
 
+/*
+ * Perform an automount
+ */
+static int follow_automount(struct path *path, int res)
+{
+	struct vfsmount *mnt;
+
+	current->total_link_count++;
+	if (current->total_link_count >= 40)
+		return -ELOOP;
+
+	mnt = path->dentry->d_op->d_automount(path);
+	if (IS_ERR(mnt))
+		return PTR_ERR(mnt);
+	if (!mnt) /* mount collision */
+		return 0;
+
+	if (mnt->mnt_sb == path->mnt->mnt_sb && mnt->mnt_root == path->dentry)
+		return -ELOOP;
+
+	dput(path->dentry);
+	if (res)
+		mntput(path->mnt);
+	path->mnt = mnt;
+	path->dentry = dget(mnt->mnt_root);
+	return 0;
+}
+
 /* no need for dcache_lock, as serialization is taken care in
  * namespace.c
  */
-static int __follow_mount(struct path *path)
+static int __follow_mount(struct path *path, unsigned nofollow)
 {
-	int res = 0;
-	while (d_mountpoint(path->dentry)) {
-		struct vfsmount *mounted = lookup_mnt(path);
-		if (!mounted)
+	struct vfsmount *mounted;
+	int ret, res = 0;
+	for (;;) {
+		while (d_mountpoint(path->dentry)) {
+			if (nofollow)
+				return -ELOOP;
+			mounted = lookup_mnt(path);
+			if (!mounted)
+				break;
+			dput(path->dentry);
+			if (res)
+				mntput(path->mnt);
+			path->mnt = mounted;
+			path->dentry = dget(mounted->mnt_root);
+			res = 1;
+		}
+		if (!d_automount_point(path->dentry))
 			break;
-		dput(path->dentry);
-		if (res)
-			mntput(path->mnt);
-		path->mnt = mounted;
-		path->dentry = dget(mounted->mnt_root);
+		if (nofollow)
+			return -ELOOP;
+		ret = follow_automount(path, res);
+		if (ret < 0)
+			return ret;
 		res = 1;
 	}
-	return res;
+	return 0;
 }
 
 static void follow_mount(struct path *path)
@@ -702,6 +743,8 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 	struct vfsmount *mnt = nd->path.mnt;
 	struct dentry *dentry, *parent;
 	struct inode *dir;
+	int ret;
+
 	/*
 	 * See if the low-level filesystem might want
 	 * to use its own hash..
@@ -720,8 +763,10 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 done:
 	path->mnt = mnt;
 	path->dentry = dentry;
-	__follow_mount(path);
-	return 0;
+	ret = __follow_mount(path, 0);
+	if (unlikely(ret < 0))
+		path_put(path);
+	return ret;
 
 need_lookup:
 	parent = nd->path.dentry;
@@ -794,17 +839,6 @@ fail:
 }
 
 /*
- * This is a temporary kludge to deal with "automount" symlinks; proper
- * solution is to trigger them on follow_mount(), so that do_lookup()
- * would DTRT.  To be killed before 2.6.34-final.
- */
-static inline int follow_on_final(struct inode *inode, unsigned lookup_flags)
-{
-	return inode && unlikely(inode->i_op->follow_link) &&
-		((lookup_flags & LOOKUP_FOLLOW) || S_ISDIR(inode->i_mode));
-}
-
-/*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
  * the final dentry. We expect 'base' to be positive and a directory.
@@ -924,7 +958,8 @@ last_component:
 		if (err)
 			break;
 		inode = next.dentry->d_inode;
-		if (follow_on_final(inode, lookup_flags)) {
+		if (inode && unlikely(inode->i_op->follow_link) &&
+		    (lookup_flags & LOOKUP_FOLLOW)) {
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;
@@ -1721,11 +1756,9 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (open_flag & O_EXCL)
 		goto exit_dput;
 
-	if (__follow_mount(path)) {
-		error = -ELOOP;
-		if (open_flag & O_NOFOLLOW)
-			goto exit_dput;
-	}
+	error = __follow_mount(path, open_flag & O_NOFOLLOW);
+	if (error < 0)
+		goto exit_dput;
 
 	error = -ENOENT;
 	if (!path->dentry->d_inode)
@@ -1839,8 +1872,7 @@ reval:
 		struct inode *inode = path.dentry->d_inode;
 		void *cookie;
 		error = -ELOOP;
-		/* S_ISDIR part is a temporary automount kludge */
-		if (!(nd.flags & LOOKUP_FOLLOW) && !S_ISDIR(inode->i_mode))
+		if (!(nd.flags & LOOKUP_FOLLOW))
 			goto exit_dput;
 		if (count++ == 32)
 			goto exit_dput;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index eebb617..0cfc4ac 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -139,6 +139,7 @@ struct dentry_operations {
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
+	struct vfsmount *(*d_automount)(struct path *);
 };
 
 /* the dentry parameter passed to d_hash and d_compare is the parent
@@ -157,6 +158,7 @@ d_compare:	no		yes		yes      no
 d_delete:	no		yes		no       no
 d_release:	no		no		no       yes
 d_iput:		no		no		no       yes
+d_automount:	no		no		no	 yes
  */
 
 /* d_flags entries */
@@ -389,6 +391,11 @@ static inline int d_mountpoint(struct dentry *dentry)
 	return dentry->d_mounted;
 }
 
+static inline bool d_automount_point(struct dentry *dentry)
+{
+	return !!dentry->d_op && dentry->d_op->d_automount;
+}
+
 extern struct vfsmount *lookup_mnt(struct path *);
 extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);
 
