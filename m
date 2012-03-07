Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab2CGV2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:28:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47153 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab2CGVXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:10 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 09/25] nfs: remove nfs4 specific create function
Date: Wed,  7 Mar 2012 22:22:26 +0100
Message-Id: <1331155362-11132-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Make nfs_atomic_open() work for non-open creates.  This is trivial to do and
allows the NFSv4 specific create code to be removed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c      |   28 ++++++++++++++++++++--------
 fs/nfs/nfs4proc.c |   31 -------------------------------
 2 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 24bf3c9..8627965 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -114,10 +114,13 @@ const struct inode_operations nfs3_dir_inode_operations = {
 static struct file *nfs_atomic_open(struct inode *, struct dentry *,
 				    struct opendata *, unsigned, umode_t,
 				    bool *);
+static struct file *nfs_atomic_open_common(struct inode *, struct dentry *,
+					   struct opendata *, unsigned,
+					   umode_t);
 const struct inode_operations nfs4_dir_inode_operations = {
-	.create		= nfs_create,
 	.lookup		= nfs_lookup,
 	.atomic_open	= nfs_atomic_open,
+	.atomic_create	= nfs_atomic_open_common, /* called for mknod */
 	.link		= nfs_link,
 	.unlink		= nfs_unlink,
 	.symlink	= nfs_symlink,
@@ -1383,7 +1386,7 @@ static struct file *nfs_finish_open(struct nfs_open_context *ctx,
 				    struct dentry *dentry,
 				    struct opendata *od, unsigned open_flags)
 {
-	struct file *filp;
+	struct file *filp = NULL;
 	int err;
 
 	if (ctx->dentry != dentry) {
@@ -1400,18 +1403,20 @@ static struct file *nfs_finish_open(struct nfs_open_context *ctx,
 		}
 	}
 
-	filp = finish_open(od, dentry, do_open);
-	if (!IS_ERR(filp))
-		nfs_file_set_open_context(filp, ctx);
+	if (od) {
+		filp = finish_open(od, dentry, do_open);
+		if (!IS_ERR(filp))
+			nfs_file_set_open_context(filp, ctx);
+	}
 
 out:
 	put_nfs_open_context(ctx);
 	return filp;
 }
 
-static struct file *nfs_atomic_open(struct inode *dir, struct dentry *dentry,
-				    struct opendata *od, unsigned open_flags,
-				    umode_t mode, bool *created)
+static struct file *nfs_atomic_open_common(struct inode *dir,
+			struct dentry *dentry, struct opendata *od,
+			unsigned open_flags, umode_t mode)
 {
 	struct nfs_open_context *ctx;
 	struct dentry *res;
@@ -1485,6 +1490,13 @@ no_open:
 	return NULL;
 }
 
+static struct file *nfs_atomic_open(struct inode *dir, struct dentry *dentry,
+				    struct opendata *od, unsigned open_flags,
+				    umode_t mode, bool *created)
+{
+	return nfs_atomic_open_common(dir, dentry, od, open_flags, mode);
+}
+
 static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct dentry *parent = NULL;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f80c547..a0f169a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2612,36 +2612,6 @@ static int nfs4_proc_readlink(struct inode *inode, struct page *page,
 	return err;
 }
 
-/*
- * This is just for mknod.  open(O_CREAT) will always do ->open_context().
- */
-static int
-nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-		 int flags)
-{
-	struct nfs_open_context *ctx;
-	struct nfs4_state *state;
-	int status = 0;
-
-	ctx = alloc_nfs_open_context(dentry, FMODE_READ);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
-	sattr->ia_mode &= ~current_umask();
-	state = nfs4_do_open(dir, dentry, ctx->mode, flags, sattr, ctx->cred);
-	d_drop(dentry);
-	if (IS_ERR(state)) {
-		status = PTR_ERR(state);
-		goto out;
-	}
-	d_add(dentry, igrab(state->inode));
-	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
-	ctx->state = state;
-out:
-	put_nfs_open_context(ctx);
-	return status;
-}
-
 static int _nfs4_proc_remove(struct inode *dir, struct qstr *name)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
@@ -6240,7 +6210,6 @@ const struct nfs_rpc_ops nfs_v4_clientops = {
 	.lookup		= nfs4_proc_lookup,
 	.access		= nfs4_proc_access,
 	.readlink	= nfs4_proc_readlink,
-	.create		= nfs4_proc_create,
 	.remove		= nfs4_proc_remove,
 	.unlink_setup	= nfs4_proc_unlink_setup,
 	.unlink_done	= nfs4_proc_unlink_done,
-- 
1.7.7

