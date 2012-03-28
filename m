Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab2C1UYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:24:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42688 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2C1UYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:24:36 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 05/16] nfs: don't open in ->d_revalidate
Date: Wed, 28 Mar 2012 22:24:34 +0200
Message-Id: <1332966285-30358-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
References: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

NFSv4 can't do reliable opens in d_revalidate, since it cannot know whether a
mount needs to be followed or not.  It does check d_mountpoint() on the dentry,
which can result in a weird error if the VFS found that the mount does not in
fact need to be followed, e.g.:

  # mount --bind /mnt/nfs /mnt/nfs-clone
  # echo something > /mnt/nfs/tmp/bar
  # echo x > /tmp/file
  # mount --bind /tmp/file /mnt/nfs-clone/tmp/bar
  # cat  /mnt/nfs/tmp/bar
  cat: /mnt/nfs/tmp/bar: Not a directory

Which should, by any sane filesystem, result in "something" being printed.

So instead do the open in f_op->open() and in the unlikely case that the cached
dentry turned out to be invalid, drop the dentry and return ESTALE to let the
VFS retry.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/dir.c  |   47 ++++----------------------------------
 fs/nfs/file.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 70 insertions(+), 46 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index fd9a872..715a8c1 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1328,10 +1328,10 @@ out:
 }
 
 #ifdef CONFIG_NFS_V4
-static int nfs_open_revalidate(struct dentry *, struct nameidata *);
+static int nfs4_lookup_revalidate(struct dentry *, struct nameidata *);
 
 const struct dentry_operations nfs4_dentry_operations = {
-	.d_revalidate	= nfs_open_revalidate,
+	.d_revalidate	= nfs4_lookup_revalidate,
 	.d_delete	= nfs_dentry_delete,
 	.d_iput		= nfs_dentry_iput,
 	.d_automount	= nfs_d_automount,
@@ -1489,12 +1489,11 @@ no_open:
 	return nfs_lookup(dir, dentry, nd);
 }
 
-static int nfs_open_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct dentry *parent = NULL;
 	struct inode *inode;
 	struct inode *dir;
-	struct nfs_open_context *ctx;
 	int openflags, ret = 0;
 
 	if (nd->flags & LOOKUP_RCU)
@@ -1523,49 +1522,13 @@ static int nfs_open_revalidate(struct dentry *dentry, struct nameidata *nd)
 	/* We cannot do exclusive creation on a positive dentry */
 	if ((openflags & (O_CREAT|O_EXCL)) == (O_CREAT|O_EXCL))
 		goto no_open_dput;
-	/* We can't create new files, or truncate existing ones here */
-	openflags &= ~(O_CREAT|O_EXCL|O_TRUNC);
 
-	ctx = create_nfs_open_context(dentry, openflags);
-	ret = PTR_ERR(ctx);
-	if (IS_ERR(ctx))
-		goto out;
-	/*
-	 * Note: we're not holding inode->i_mutex and so may be racing with
-	 * operations that change the directory. We therefore save the
-	 * change attribute *before* we do the RPC call.
-	 */
-	inode = NFS_PROTO(dir)->open_context(dir, ctx, openflags, NULL);
-	if (IS_ERR(inode)) {
-		ret = PTR_ERR(inode);
-		switch (ret) {
-		case -EPERM:
-		case -EACCES:
-		case -EDQUOT:
-		case -ENOSPC:
-		case -EROFS:
-			goto out_put_ctx;
-		default:
-			goto out_drop;
-		}
-	}
-	iput(inode);
-	if (inode != dentry->d_inode)
-		goto out_drop;
+	/* Let f_op->open() actually open (and revalidate) the file */
+	ret = 1;
 
-	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
-	ret = nfs_intent_set_file(nd, ctx);
-	if (ret >= 0)
-		ret = 1;
 out:
 	dput(parent);
 	return ret;
-out_drop:
-	d_drop(dentry);
-	ret = 0;
-out_put_ctx:
-	put_nfs_open_context(ctx);
-	goto out;
 
 no_open_dput:
 	dput(parent);
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index c43a452..4e626ec 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -870,12 +870,73 @@ const struct file_operations nfs_file_operations = {
 static int
 nfs4_file_open(struct inode *inode, struct file *filp)
 {
+	struct nfs_open_context *ctx;
+	struct dentry *dentry = filp->f_path.dentry;
+	struct dentry *parent = NULL;
+	struct inode *dir;
+	unsigned openflags = filp->f_flags;
+	int err;
+
+	BUG_ON(inode != dentry->d_inode);
 	/*
-	 * NFSv4 opens are handled in d_lookup and d_revalidate. If we get to
-	 * this point, then something is very wrong
+	 * If no cached dentry exists or if it's negative, NFSv4 handled the
+	 * opens in ->lookup() or ->create().
+	 *
+	 * We only get this far for a cached positive dentry.  We skipped
+	 * revalidation, so handle it here by dropping the dentry and returning
+	 * -ESTALE.  The VFS will retry the lookup/create/open.
 	 */
-	dprintk("NFS: %s called! inode=%p filp=%p\n", __func__, inode, filp);
-	return -ENOTDIR;
+
+	dprintk("NFS: open file(%s/%s)\n",
+		dentry->d_parent->d_name.name,
+		dentry->d_name.name);
+
+	if ((openflags & O_ACCMODE) == 3)
+		openflags--;
+
+	/* We can't create new files, or truncate existing ones here */
+	openflags &= ~(O_CREAT|O_EXCL|O_TRUNC);
+
+	parent = dget_parent(dentry);
+	dir = parent->d_inode;
+
+	ctx = alloc_nfs_open_context(filp->f_path.dentry, filp->f_mode);
+	err = PTR_ERR(ctx);
+	if (IS_ERR(ctx))
+		goto out;
+
+	inode = NFS_PROTO(dir)->open_context(dir, ctx, openflags, NULL);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		switch (err) {
+		case -EPERM:
+		case -EACCES:
+		case -EDQUOT:
+		case -ENOSPC:
+		case -EROFS:
+			goto out_put_ctx;
+		default:
+			goto out_drop;
+		}
+	}
+	iput(inode);
+	if (inode != dentry->d_inode)
+		goto out_drop;
+
+	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
+	nfs_file_set_open_context(filp, ctx);
+	err = 0;
+
+out_put_ctx:
+	put_nfs_open_context(ctx);
+out:
+	dput(parent);
+	return err;
+
+out_drop:
+	d_drop(dentry);
+	err = -ESTALE;
+	goto out_put_ctx;
 }
 
 const struct file_operations nfs4_file_operations = {
-- 
1.7.7

