Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2DEPJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:09:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52339 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2DEO7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:23 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 27/34] fuse: implement i_op->atomic_create()
Date: Thu,  5 Apr 2012 16:58:53 +0200
Message-Id: <1333637940-31884-28-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Replace fuse's ->create implementation with a ->atomic_create implementation.
No functionality is changed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c |   97 ++++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 69 insertions(+), 28 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 2066328..75e5142 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -369,8 +369,9 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
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
@@ -382,17 +383,15 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	struct fuse_entry_out outentry;
 	struct fuse_file *ff;
 	struct file *file;
-	int flags = nd->intent.open.flags;
-
-	if (fc->no_create)
-		return -ENOSYS;
 
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
@@ -431,11 +430,8 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	req->out.args[1].value = &outopen;
 	fuse_request_send(fc, req);
 	err = req->out.h.error;
-	if (err) {
-		if (err == -ENOSYS)
-			fc->no_create = 1;
+	if (err)
 		goto out_free_ff;
-	}
 
 	err = -EIO;
 	if (!S_ISREG(outentry.attr.mode) || invalid_nodeid(outentry.nodeid))
@@ -451,28 +447,78 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
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
 
- out_free_ff:
+out_free_ff:
 	fuse_file_free(ff);
- out_put_request:
+out_put_request:
 	fuse_put_request(fc, req);
- out_put_forget_req:
+out_put_forget_req:
 	kfree(forget);
-	return err;
+out_err:
+	return ERR_PTR(err);
+}
+
+static int fuse_mknod(struct inode *, struct dentry *, umode_t, dev_t);
+static struct file *fuse_atomic_open(struct inode *dir, struct dentry *entry,
+				     struct opendata *od, unsigned flags,
+				     umode_t mode, bool *created)
+{
+	int err;
+	struct fuse_conn *fc = get_fuse_conn(dir);
+	struct file *file;
+	struct dentry *res = NULL;
+
+	if (d_unhashed(entry)) {
+		res = fuse_lookup(dir, entry, NULL);
+		if (IS_ERR(res))
+			return ERR_CAST(res);
+
+		if (res)
+			entry = res;
+	}
+
+	if (!(flags & O_CREAT) || entry->d_inode)
+		goto no_open;
+
+	/* Only creates */
+	*created = true;
+
+	if (fc->no_create)
+		goto mknod;
+
+	file = fuse_create_open(dir, entry, od, flags, mode);
+	if (PTR_ERR(file) == -ENOSYS) {
+		fc->no_create = 1;
+		goto mknod;
+	}
+out_dput:
+	dput(res);
+	return file;
+
+mknod:
+	err = fuse_mknod(dir, entry, mode, 0);
+	if (err) {
+		file = ERR_PTR(err);
+		goto out_dput;
+	}
+no_open:
+	finish_no_open(od, res);
+	return NULL;
 }
 
 /*
@@ -576,12 +622,6 @@ static int fuse_mknod(struct inode *dir, struct dentry *entry, umode_t mode,
 static int fuse_create(struct inode *dir, struct dentry *entry, umode_t mode,
 		       struct nameidata *nd)
 {
-	if (nd) {
-		int err = fuse_create_open(dir, entry, mode, nd);
-		if (err != -ENOSYS)
-			return err;
-		/* Fall back on mknod */
-	}
 	return fuse_mknod(dir, entry, mode, 0);
 }
 
@@ -1632,6 +1672,7 @@ static const struct inode_operations fuse_dir_inode_operations = {
 	.link		= fuse_link,
 	.setattr	= fuse_setattr,
 	.create		= fuse_create,
+	.atomic_open	= fuse_atomic_open,
 	.mknod		= fuse_mknod,
 	.permission	= fuse_permission,
 	.getattr	= fuse_getattr,
-- 
1.7.7

