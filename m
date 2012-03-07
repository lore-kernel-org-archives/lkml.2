Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2CGVX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:23:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61992 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2CGVXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:22 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 15/25] ceph: implement i_op->atomic_open() and i_op->atomic_create()
Date: Wed,  7 Mar 2012 22:22:32 +0100
Message-Id: <1331155362-11132-16-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Instead of calling ceph_lookup_open() from ->lookup and ->create, call it from
->atomic_open and ->atomic_create.

CEPH does non-create open in ->atomic_open and create-open in ->atomic_create.
To prevent unnecessary call to ->atomic_open the FS_NO_LOOKUP_CREATE flag is set
in the filesystem flags to only call ->atomic_open on non-create opens.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ceph/dir.c   |   33 +++++++++------------------------
 fs/ceph/file.c  |   22 +++++++++++-----------
 fs/ceph/super.c |    2 +-
 fs/ceph/super.h |    5 +++--
 4 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index c4b7832..62b10e7 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -594,14 +594,6 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	/* open (but not create!) intent? */
-	if (nd &&
-	    (nd->flags & LOOKUP_OPEN) &&
-	    !(nd->intent.open.flags & O_CREAT)) {
-		int mode = nd->intent.open.create_mode & ~current->fs->umask;
-		return ceph_lookup_open(dir, dentry, nd, mode);
-	}
-
 	/* can we conclude ENOENT locally? */
 	if (dentry->d_inode == NULL) {
 		struct ceph_inode_info *ci = ceph_inode(dir);
@@ -699,26 +691,18 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
 	return err;
 }
 
-static int ceph_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		       struct nameidata *nd)
+struct file *ceph_create(struct inode *dir, struct dentry *dentry,
+			 struct opendata *od, unsigned flags, umode_t mode)
 {
-	dout("create in dir %p dentry %p name '%.*s'\n",
-	     dir, dentry, dentry->d_name.len, dentry->d_name.name);
+	bool created = true;
 
-	if (ceph_snap(dir) != CEPH_NOSNAP)
-		return -EROFS;
+	if (!od) {
+		int err = ceph_mknod(dir, dentry, mode, 0);
 
-	if (nd) {
-		BUG_ON((nd->flags & LOOKUP_OPEN) == 0);
-		dentry = ceph_lookup_open(dir, dentry, nd, mode);
-		/* hrm, what should i do here if we get aliased? */
-		if (IS_ERR(dentry))
-			return PTR_ERR(dentry);
-		return 0;
+		return err ? ERR_PTR(err) : NULL;
 	}
 
-	/* fall back to mknod */
-	return ceph_mknod(dir, dentry, (mode & ~S_IFMT) | S_IFREG, 0);
+	return ceph_lookup_open(dir, dentry, od, flags, mode, &created);
 }
 
 static int ceph_symlink(struct inode *dir, struct dentry *dentry,
@@ -1356,7 +1340,8 @@ const struct inode_operations ceph_dir_iops = {
 	.unlink = ceph_unlink,
 	.rmdir = ceph_unlink,
 	.rename = ceph_rename,
-	.create = ceph_create,
+	.atomic_create = ceph_create,
+	.atomic_open = ceph_lookup_open,
 };
 
 const struct dentry_operations ceph_dentry_ops = {
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 2fe9a3e..6a00f89 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -214,21 +214,16 @@ out:
  * may_open() fails, the struct *file gets cleaned up (i.e.
  * ceph_release gets called).  So fear not!
  */
-/*
- * flags
- *  path_lookup_open   -> LOOKUP_OPEN
- *  path_lookup_create -> LOOKUP_OPEN|LOOKUP_CREATE
- */
-struct dentry *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
-				struct nameidata *nd, int mode)
+struct file *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
+			      struct opendata *od, unsigned flags, umode_t mode,
+			      bool *created)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
-	struct file *file;
+	struct file *file = NULL;
 	struct ceph_mds_request *req;
 	struct dentry *ret;
 	int err;
-	int flags = nd->intent.open.flags;
 
 	dout("ceph_lookup_open dentry %p '%.*s' flags %d mode 0%o\n",
 	     dentry, dentry->d_name.len, dentry->d_name.name, flags, mode);
@@ -254,14 +249,19 @@ struct dentry *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
 		err = ceph_handle_notrace_create(dir, dentry);
 	if (err)
 		goto out;
-	file = lookup_instantiate_filp(nd, req->r_dentry, ceph_open);
+	file = finish_open(od, req->r_dentry, ceph_open);
 	if (IS_ERR(file))
 		err = PTR_ERR(file);
 out:
 	ret = ceph_finish_lookup(req, dentry, err);
 	ceph_mdsc_put_request(req);
 	dout("ceph_lookup_open result=%p\n", ret);
-	return ret;
+
+	if (IS_ERR(ret))
+		return ERR_CAST(ret);
+
+	dput(ret);
+	return err ? ERR_PTR(err) : file;
 }
 
 int ceph_release(struct inode *inode, struct file *file)
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 00de2c9..6e87fc2 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -915,7 +915,7 @@ static struct file_system_type ceph_fs_type = {
 	.name		= "ceph",
 	.mount		= ceph_mount,
 	.kill_sb	= ceph_kill_sb,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE,
+	.fs_flags	= FS_RENAME_DOES_D_MOVE | FS_NO_LOOKUP_CREATE,
 };
 
 #define _STRINGIFY(x) #x
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c6b2cba..cf66773 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -804,8 +804,9 @@ extern int ceph_copy_from_page_vector(struct page **pages,
 				    loff_t off, size_t len);
 extern struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags);
 extern int ceph_open(struct inode *inode, struct file *file);
-extern struct dentry *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
-				       struct nameidata *nd, int mode);
+extern struct file *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
+				     struct opendata *od, unsigned flags,
+				     umode_t mode, bool *);
 extern int ceph_release(struct inode *inode, struct file *filp);
 
 /* dir.c */
-- 
1.7.7

