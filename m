Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab2FENK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:10:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934039Ab2FENKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:55 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 08/21] nfs: clean up ->create in nfs_rpc_ops
Date: Tue,  5 Jun 2012 15:10:19 +0200
Message-Id: <1338901832-14049-9-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
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
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/dir.c            |   42 ++----------------------------------------
 fs/nfs/nfs3proc.c       |    2 +-
 fs/nfs/nfs4proc.c       |   37 ++++++++++---------------------------
 fs/nfs/proc.c           |    2 +-
 include/linux/nfs_xdr.h |    2 +-
 5 files changed, 15 insertions(+), 70 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 0d8c712..45015d3 100644
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
@@ -1582,42 +1580,6 @@ no_open:
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
@@ -1684,7 +1646,7 @@ static int nfs_create(struct inode *dir, struct dentry *dentry,
 	if (nd)
 		open_flags = nd->intent.open.flags;
 
-	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, NULL);
+	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags);
 	if (error != 0)
 		goto out_err;
 	return 0;
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 2292a0f..3187e24 100644
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
index d48dbef..267be3c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2779,37 +2779,22 @@ static int nfs4_proc_readlink(struct inode *inode, struct page *page,
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
-	state = nfs4_do_open(dir, de, fmode, flags, sattr, cred, NULL);
+	state = nfs4_do_open(dir, dentry, ctx->mode, flags, sattr, ctx->cred, NULL);
 	d_drop(dentry);
 	if (IS_ERR(state)) {
 		status = PTR_ERR(state);
@@ -2817,11 +2802,9 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
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
index a706b6b..81a0a42 100644
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
index d1a7bf5..660c0f5 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1371,7 +1371,7 @@ struct nfs_rpc_ops {
 	int	(*readlink)(struct inode *, struct page *, unsigned int,
 			    unsigned int);
 	int	(*create)  (struct inode *, struct dentry *,
-			    struct iattr *, int, struct nfs_open_context *);
+			    struct iattr *, int);
 	int	(*remove)  (struct inode *, struct qstr *);
 	void	(*unlink_setup)  (struct rpc_message *, struct inode *dir);
 	void	(*unlink_rpc_prepare) (struct rpc_task *, struct nfs_unlinkdata *);
-- 
1.7.7

