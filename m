Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2DEPAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:00:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61334 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2DEO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:18 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 24/34] nfs: clean up ->create in nfs_rpc_ops
Date: Thu,  5 Apr 2012 16:58:50 +0200
Message-Id: <1333637940-31884-25-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
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
index 1fb5d66..8bfced6 100644
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
@@ -1556,42 +1554,6 @@ no_open:
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
@@ -1658,7 +1620,7 @@ static int nfs_create(struct inode *dir, struct dentry *dentry,
 	if (nd)
 		open_flags = nd->intent.open.flags;
 
-	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, NULL);
+	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags);
 	if (error != 0)
 		goto out_err;
 	return 0;
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 5242eae..dd62b6e 100644
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
index f82bde0..5750e9c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2676,37 +2676,22 @@ static int nfs4_proc_readlink(struct inode *inode, struct page *page,
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
@@ -2714,11 +2699,9 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
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
index b63b6f4..f3909ed 100644
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
index bfd0d1b..f2b5d09 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1239,7 +1239,7 @@ struct nfs_rpc_ops {
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

