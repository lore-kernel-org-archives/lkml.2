Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848Ab2CGV2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:28:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43421 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2CGVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:08 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 08/25] nfs: clean up ->create in nfs_rpc_ops
Date: Wed,  7 Mar 2012 22:22:25 +0100
Message-Id: <1331155362-11132-9-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Don't pass nfs_open_context() to ->create().  Only the NFS4 implementation
needed that and only because it wanted to return an open file using open
intents.  That task has been replaced by ->atomic_open so it is not necessary
anymore to pass the context to the create rpc operation.

Despite nfs4_proc_create apparently being okay with a NULL context it Oopses
somewhere down the call chain.  So allocate a context here.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c            |   42 ++----------------------------------------
 fs/nfs/nfs3proc.c       |    2 +-
 fs/nfs/nfs4proc.c       |   37 ++++++++++---------------------------
 fs/nfs/proc.c           |    2 +-
 include/linux/nfs_xdr.h |    2 +-
 5 files changed, 15 insertions(+), 70 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 949b9e8..24bf3c9 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -114,10 +114,8 @@ const struct inode_operations nfs3_dir_inode_operations = {
 static struct file *nfs_atomic_open(struct inode *, struct dentry *,
 				    struct opendata *, unsigned, umode_t,
 				    bool *);
-static int nfs4_create(struct inode *dir, struct dentry *dentry,
-		       umode_t mode, struct nameidata *nd);
 const struct inode_operations nfs4_dir_inode_operations = {
-	.create		= nfs4_create,
+	.create		= nfs_create,
 	.lookup		= nfs_lookup,
 	.atomic_open	= nfs_atomic_open,
 	.link		= nfs_link,
@@ -1534,42 +1532,6 @@ no_open:
 	return nfs_lookup_revalidate(dentry, nd);
 }
 
-static int nfs4_create(struct inode *dir, struct dentry *dentry,
-		       umode_t mode, struct nameidata *nd)
-{
-	struct nfs_open_context *ctx = NULL;
-	struct iattr attr;
-	int error;
-	int open_flags = O_CREAT|O_EXCL;
-
-	dfprintk(VFS, "NFS: create(%s/%ld), %s\n",
-			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
-
-	attr.ia_mode = mode;
-	attr.ia_valid = ATTR_MODE;
-
-	if (nd)
-		open_flags = nd->intent.open.flags;
-
-	ctx = create_nfs_open_context(dentry, open_flags);
-	error = PTR_ERR(ctx);
-	if (IS_ERR(ctx))
-		goto out_err_drop;
-
-	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, ctx);
-	if (error != 0)
-		goto out_put_ctx;
-
-	put_nfs_open_context(ctx);
-
-	return 0;
-out_put_ctx:
-	put_nfs_open_context(ctx);
-out_err_drop:
-	d_drop(dentry);
-	return error;
-}
-
 #endif /* CONFIG_NFSV4 */
 
 /*
@@ -1636,7 +1598,7 @@ static int nfs_create(struct inode *dir, struct dentry *dentry,
 	if (nd)
 		open_flags = nd->intent.open.flags;
 
-	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, NULL);
+	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags);
 	if (error != 0)
 		goto out_err;
 	return 0;
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 9194395..821c8bf 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -314,7 +314,7 @@ static void nfs3_free_createdata(struct nfs3_createdata *data)
  */
 static int
 nfs3_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-		 int flags, struct nfs_open_context *ctx)
+		 int flags)
 {
 	struct nfs3_createdata *data;
 	umode_t mode = sattr->ia_mode;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ec9f6ef..f80c547 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2613,37 +2613,22 @@ static int nfs4_proc_readlink(struct inode *inode, struct page *page,
 }
 
 /*
- * Got race?
- * We will need to arrange for the VFS layer to provide an atomic open.
- * Until then, this create/open method is prone to inefficiency and race
- * conditions due to the lookup, create, and open VFS calls from sys_open()
- * placed on the wire.
- *
- * Given the above sorry state of affairs, I'm simply sending an OPEN.
- * The file will be opened again in the subsequent VFS open call
- * (nfs4_proc_file_open).
- *
- * The open for read will just hang around to be used by any process that
- * opens the file O_RDONLY. This will all be resolved with the VFS changes.
+ * This is just for mknod.  open(O_CREAT) will always do ->open_context().
  */
-
 static int
 nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-                 int flags, struct nfs_open_context *ctx)
+		 int flags)
 {
-	struct dentry *de = dentry;
+	struct nfs_open_context *ctx;
 	struct nfs4_state *state;
-	struct rpc_cred *cred = NULL;
-	fmode_t fmode = 0;
 	int status = 0;
 
-	if (ctx != NULL) {
-		cred = ctx->cred;
-		de = ctx->dentry;
-		fmode = ctx->mode;
-	}
+	ctx = alloc_nfs_open_context(dentry, FMODE_READ);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
 	sattr->ia_mode &= ~current_umask();
-	state = nfs4_do_open(dir, de, fmode, flags, sattr, cred);
+	state = nfs4_do_open(dir, dentry, ctx->mode, flags, sattr, ctx->cred);
 	d_drop(dentry);
 	if (IS_ERR(state)) {
 		status = PTR_ERR(state);
@@ -2651,11 +2636,9 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	}
 	d_add(dentry, igrab(state->inode));
 	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
-	if (ctx != NULL)
-		ctx->state = state;
-	else
-		nfs4_close_sync(state, fmode);
+	ctx->state = state;
 out:
+	put_nfs_open_context(ctx);
 	return status;
 }
 
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 0c672588..60834bc 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -259,7 +259,7 @@ static void nfs_free_createdata(const struct nfs_createdata *data)
 
 static int
 nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-		int flags, struct nfs_open_context *ctx)
+		int flags)
 {
 	struct nfs_createdata *data;
 	struct rpc_message msg = {
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index d6ba9a1..c3df045 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1218,7 +1218,7 @@ struct nfs_rpc_ops {
 	int	(*readlink)(struct inode *, struct page *, unsigned int,
 			    unsigned int);
 	int	(*create)  (struct inode *, struct dentry *,
-			    struct iattr *, int, struct nfs_open_context *);
+			    struct iattr *, int);
 	int	(*remove)  (struct inode *, struct qstr *);
 	void	(*unlink_setup)  (struct rpc_message *, struct inode *dir);
 	int	(*unlink_done) (struct rpc_task *, struct inode *);
-- 
1.7.7

