Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029Ab2FENKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:10:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46637 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab2FENKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:49 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 07/21] nfs: implement i_op->atomic_open()
Date: Tue,  5 Jun 2012 15:10:18 +0200
Message-Id: <1338901832-14049-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Replace NFS4 specific ->lookup implementation with ->atomic_open impelementation
and use the generic nfs_lookup for other lookups.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/dir.c |  183 +++++++++++++++++++++++++++++++---------------------------
 1 files changed, 97 insertions(+), 86 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index f430057..0d8c712 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -111,11 +111,15 @@ const struct inode_operations nfs3_dir_inode_operations = {
 
 #ifdef CONFIG_NFS_V4
 
-static struct dentry *nfs_atomic_lookup(struct inode *, struct dentry *, struct nameidata *);
-static int nfs_open_create(struct inode *dir, struct dentry *dentry, umode_t mode, struct nameidata *nd);
+static struct file *nfs_atomic_open(struct inode *, struct dentry *,
+				    struct opendata *, unsigned, umode_t,
+				    bool *);
+static int nfs4_create(struct inode *dir, struct dentry *dentry,
+		       umode_t mode, struct nameidata *nd);
 const struct inode_operations nfs4_dir_inode_operations = {
-	.create		= nfs_open_create,
-	.lookup		= nfs_atomic_lookup,
+	.create		= nfs4_create,
+	.lookup		= nfs_lookup,
+	.atomic_open	= nfs_atomic_open,
 	.link		= nfs_link,
 	.unlink		= nfs_unlink,
 	.symlink	= nfs_symlink,
@@ -1403,120 +1407,132 @@ static int do_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int nfs_intent_set_file(struct nameidata *nd, struct nfs_open_context *ctx)
+static struct file *nfs_finish_open(struct nfs_open_context *ctx,
+				    struct dentry *dentry,
+				    struct opendata *od, unsigned open_flags)
 {
 	struct file *filp;
-	int ret = 0;
+	int err;
+
+	if (ctx->dentry != dentry) {
+		dput(ctx->dentry);
+		ctx->dentry = dget(dentry);
+	}
 
 	/* If the open_intent is for execute, we have an extra check to make */
 	if (ctx->mode & FMODE_EXEC) {
-		ret = nfs_may_open(ctx->dentry->d_inode,
-				ctx->cred,
-				nd->intent.open.flags);
-		if (ret < 0)
+		err = nfs_may_open(dentry->d_inode, ctx->cred, open_flags);
+		if (err < 0) {
+			filp = ERR_PTR(err);
 			goto out;
+		}
 	}
-	filp = lookup_instantiate_filp(nd, ctx->dentry, do_open);
-	if (IS_ERR(filp))
-		ret = PTR_ERR(filp);
-	else
+
+	filp = finish_open(od, dentry, do_open);
+	if (!IS_ERR(filp))
 		nfs_file_set_open_context(filp, ctx);
+
 out:
 	put_nfs_open_context(ctx);
-	return ret;
+	return filp;
 }
 
-static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct file *nfs_atomic_open(struct inode *dir, struct dentry *dentry,
+				    struct opendata *od, unsigned open_flags,
+				    umode_t mode, bool *created)
 {
 	struct nfs_open_context *ctx;
-	struct iattr attr;
-	struct dentry *res = NULL;
+	struct dentry *res;
+	struct iattr attr = { .ia_valid = ATTR_OPEN };
 	struct inode *inode;
-	int open_flags;
+	struct file *filp;
 	int err;
 
-	dfprintk(VFS, "NFS: atomic_lookup(%s/%ld), %s\n",
+	/* Expect a negative dentry */
+	BUG_ON(dentry->d_inode);
+
+	dfprintk(VFS, "NFS: atomic_open(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
-	/* Check that we are indeed trying to open this file */
-	if (!is_atomic_open(nd))
+	/* NFS only supports OPEN on regular files */
+	if ((open_flags & O_DIRECTORY)) {
+		err = -ENOENT;
+		if (!d_unhashed(dentry)) {
+			/*
+			 * Hashed negative dentry with O_DIRECTORY: dentry was
+			 * revalidated and is fine, no need to perform lookup
+			 * again
+			 */
+			goto out_err;
+		}
 		goto no_open;
-
-	if (dentry->d_name.len > NFS_SERVER(dir)->namelen) {
-		res = ERR_PTR(-ENAMETOOLONG);
-		goto out;
 	}
 
-	/* Let vfs_create() deal with O_EXCL. Instantiate, but don't hash
-	 * the dentry. */
-	if (nd->flags & LOOKUP_EXCL) {
-		d_instantiate(dentry, NULL);
-		goto out;
-	}
-
-	open_flags = nd->intent.open.flags;
-	attr.ia_valid = ATTR_OPEN;
-
-	ctx = create_nfs_open_context(dentry, open_flags);
-	res = ERR_CAST(ctx);
-	if (IS_ERR(ctx))
-		goto out;
+	err = -ENAMETOOLONG;
+	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
+		goto out_err;
 
-	if (nd->flags & LOOKUP_CREATE) {
-		attr.ia_mode = nd->intent.open.create_mode;
+	if (open_flags & O_CREAT) {
 		attr.ia_valid |= ATTR_MODE;
-		attr.ia_mode &= ~current_umask();
-	} else
-		open_flags &= ~(O_EXCL | O_CREAT);
-
+		attr.ia_mode = mode & ~current_umask();
+	}
 	if (open_flags & O_TRUNC) {
 		attr.ia_valid |= ATTR_SIZE;
 		attr.ia_size = 0;
 	}
 
-	/* Open the file on the server */
+	ctx = create_nfs_open_context(dentry, open_flags);
+	err = PTR_ERR(ctx);
+	if (IS_ERR(ctx))
+		goto out_err;
+
 	nfs_block_sillyrename(dentry->d_parent);
 	inode = NFS_PROTO(dir)->open_context(dir, ctx, open_flags, &attr);
+	d_drop(dentry);
 	if (IS_ERR(inode)) {
 		nfs_unblock_sillyrename(dentry->d_parent);
 		put_nfs_open_context(ctx);
-		switch (PTR_ERR(inode)) {
-			/* Make a negative dentry */
-			case -ENOENT:
-				d_add(dentry, NULL);
-				res = NULL;
-				goto out;
-			/* This turned out not to be a regular file */
-			case -EISDIR:
-			case -ENOTDIR:
+		err = PTR_ERR(inode);
+		switch (err) {
+		case -ENOENT:
+			d_add(dentry, NULL);
+			break;
+		case -EISDIR:
+		case -ENOTDIR:
+			goto no_open;
+		case -ELOOP:
+			if (!(open_flags & O_NOFOLLOW))
 				goto no_open;
-			case -ELOOP:
-				if (!(nd->intent.open.flags & O_NOFOLLOW))
-					goto no_open;
+			break;
 			/* case -EINVAL: */
-			default:
-				res = ERR_CAST(inode);
-				goto out;
+		default:
+			break;
 		}
+		goto out_err;
 	}
 	res = d_add_unique(dentry, inode);
-	nfs_unblock_sillyrename(dentry->d_parent);
-	if (res != NULL) {
-		dput(ctx->dentry);
-		ctx->dentry = dget(res);
+	if (res != NULL)
 		dentry = res;
-	}
-	err = nfs_intent_set_file(nd, ctx);
-	if (err < 0) {
-		if (res != NULL)
-			dput(res);
-		return ERR_PTR(err);
-	}
-out:
+
+	nfs_unblock_sillyrename(dentry->d_parent);
 	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
-	return res;
+
+	filp = nfs_finish_open(ctx, dentry, od, open_flags);
+
+	dput(res);
+	return filp;
+
+out_err:
+	return ERR_PTR(err);
+
 no_open:
-	return nfs_lookup(dir, dentry, nd);
+	res = nfs_lookup(dir, dentry, NULL);
+	err = PTR_ERR(res);
+	if (IS_ERR(res))
+		goto out_err;
+
+	finish_no_open(od, res);
+	return NULL;
 }
 
 static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
@@ -1566,8 +1582,8 @@ no_open:
 	return nfs_lookup_revalidate(dentry, nd);
 }
 
-static int nfs_open_create(struct inode *dir, struct dentry *dentry,
-		umode_t mode, struct nameidata *nd)
+static int nfs4_create(struct inode *dir, struct dentry *dentry,
+		       umode_t mode, struct nameidata *nd)
 {
 	struct nfs_open_context *ctx = NULL;
 	struct iattr attr;
@@ -1591,19 +1607,14 @@ static int nfs_open_create(struct inode *dir, struct dentry *dentry,
 	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, ctx);
 	if (error != 0)
 		goto out_put_ctx;
-	if (nd) {
-		error = nfs_intent_set_file(nd, ctx);
-		if (error < 0)
-			goto out_err;
-	} else {
-		put_nfs_open_context(ctx);
-	}
+
+	put_nfs_open_context(ctx);
+
 	return 0;
 out_put_ctx:
 	put_nfs_open_context(ctx);
 out_err_drop:
 	d_drop(dentry);
-out_err:
 	return error;
 }
 
-- 
1.7.7

