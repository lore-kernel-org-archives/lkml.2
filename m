Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2CGV1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:27:13 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46985 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2CGVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:16 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 12/25] fuse: implement i_op->atomic_create()
Date: Wed,  7 Mar 2012 22:22:29 +0100
Message-Id: <1331155362-11132-13-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Replace fuse's ->create implementation with a ->atomic_create implementation.
No functionality is changed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c |   57 +++++++++++++++++++++++++++++----------------------------
 1 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 2066328..584385e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -363,14 +363,16 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 	return ERR_PTR(err);
 }
 
+static int fuse_mknod(struct inode *, struct dentry *, umode_t, dev_t);
 /*
  * Atomic create+open operation
  *
  * If the filesystem doesn't support this, then fall back to separate
  * 'mknod' + 'open' requests.
  */
-static int fuse_create_open(struct inode *dir, struct dentry *entry,
-			    umode_t mode, struct nameidata *nd)
+static struct file *fuse_create_open(struct inode *dir, struct dentry *entry,
+				     struct opendata *od, unsigned flags,
+				     umode_t mode)
 {
 	int err;
 	struct inode *inode;
@@ -382,17 +384,18 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	struct fuse_entry_out outentry;
 	struct fuse_file *ff;
 	struct file *file;
-	int flags = nd->intent.open.flags;
 
-	if (fc->no_create)
-		return -ENOSYS;
+	if (!od || fc->no_create)
+		goto no_open;
 
+	err = -EINVAL;
 	if (flags & O_DIRECT)
-		return -EINVAL;
+		goto out_err;
 
 	forget = fuse_alloc_forget();
+	err = -ENOMEM;
 	if (!forget)
-		return -ENOMEM;
+		goto out_err;
 
 	req = fuse_get_req(fc);
 	err = PTR_ERR(req);
@@ -432,8 +435,10 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	if (err) {
-		if (err == -ENOSYS)
+		if (err == -ENOSYS) {
 			fc->no_create = 1;
+			goto no_open;
+		}
 		goto out_free_ff;
 	}
 
@@ -451,20 +456,21 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 		flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
 		fuse_sync_release(ff, flags);
 		fuse_queue_forget(fc, forget, outentry.nodeid, 1);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto out_err;
 	}
 	kfree(forget);
 	d_instantiate(entry, inode);
 	fuse_change_entry_timeout(entry, &outentry);
 	fuse_invalidate_attr(dir);
-	file = lookup_instantiate_filp(nd, entry, generic_file_open);
+	file = finish_open(od, entry, generic_file_open);
 	if (IS_ERR(file)) {
 		fuse_sync_release(ff, flags);
-		return PTR_ERR(file);
+	} else {
+		file->private_data = fuse_file_get(ff);
+		fuse_finish_open(inode, file);
 	}
-	file->private_data = fuse_file_get(ff);
-	fuse_finish_open(inode, file);
-	return 0;
+	return file;
 
  out_free_ff:
 	fuse_file_free(ff);
@@ -472,7 +478,14 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	fuse_put_request(fc, req);
  out_put_forget_req:
 	kfree(forget);
-	return err;
+out_err:
+	return ERR_PTR(err);
+
+no_open:
+	err = fuse_mknod(dir, entry, mode, 0);
+	if (err)
+		goto out_err;
+	return NULL;
 }
 
 /*
@@ -573,18 +586,6 @@ static int fuse_mknod(struct inode *dir, struct dentry *entry, umode_t mode,
 	return create_new_entry(fc, req, dir, entry, mode);
 }
 
-static int fuse_create(struct inode *dir, struct dentry *entry, umode_t mode,
-		       struct nameidata *nd)
-{
-	if (nd) {
-		int err = fuse_create_open(dir, entry, mode, nd);
-		if (err != -ENOSYS)
-			return err;
-		/* Fall back on mknod */
-	}
-	return fuse_mknod(dir, entry, mode, 0);
-}
-
 static int fuse_mkdir(struct inode *dir, struct dentry *entry, umode_t mode)
 {
 	struct fuse_mkdir_in inarg;
@@ -1631,7 +1632,7 @@ static const struct inode_operations fuse_dir_inode_operations = {
 	.rename		= fuse_rename,
 	.link		= fuse_link,
 	.setattr	= fuse_setattr,
-	.create		= fuse_create,
+	.atomic_create	= fuse_create_open,
 	.mknod		= fuse_mknod,
 	.permission	= fuse_permission,
 	.getattr	= fuse_getattr,
-- 
1.7.7

