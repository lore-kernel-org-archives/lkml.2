Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241Ab2CGVYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:24:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46985 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802Ab2CGVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:34 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 22/25] nfs: use i_op->atomic_create()
Date: Wed,  7 Mar 2012 22:22:39 +0100
Message-Id: <1331155362-11132-23-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

NFS doesn't open the file in ->create, but it does check the LOOKUP_EXCL flag in
it's generic create function.  Convert to using ->atomic_create and checking
O_EXCL so that the nameidata argument is no longer necessary.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 36a12b4..887226d 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -47,7 +47,8 @@ static int nfs_opendir(struct inode *, struct file *);
 static int nfs_closedir(struct inode *, struct file *);
 static int nfs_readdir(struct file *, void *, filldir_t);
 static struct dentry *nfs_lookup(struct inode *, struct dentry *, struct nameidata *);
-static int nfs_create(struct inode *, struct dentry *, umode_t, struct nameidata *);
+static struct file *nfs_create(struct inode *, struct dentry *,
+			       struct opendata *, unsigned, umode_t);
 static int nfs_mkdir(struct inode *, struct dentry *, umode_t);
 static int nfs_rmdir(struct inode *, struct dentry *);
 static int nfs_unlink(struct inode *, struct dentry *);
@@ -70,7 +71,7 @@ const struct file_operations nfs_dir_operations = {
 };
 
 const struct inode_operations nfs_dir_inode_operations = {
-	.create		= nfs_create,
+	.atomic_create	= nfs_create,
 	.lookup		= nfs_lookup,
 	.link		= nfs_link,
 	.unlink		= nfs_unlink,
@@ -90,7 +91,7 @@ const struct address_space_operations nfs_dir_aops = {
 
 #ifdef CONFIG_NFS_V3
 const struct inode_operations nfs3_dir_inode_operations = {
-	.create		= nfs_create,
+	.atomic_create	= nfs_create,
 	.lookup		= nfs_lookup,
 	.link		= nfs_link,
 	.unlink		= nfs_unlink,
@@ -1577,12 +1578,12 @@ out_error:
  * that the operation succeeded on the server, but an error in the
  * reply path made it appear to have failed.
  */
-static int nfs_create(struct inode *dir, struct dentry *dentry,
-		umode_t mode, struct nameidata *nd)
+static struct file *nfs_create(struct inode *dir, struct dentry *dentry,
+			       struct opendata *od, unsigned open_flags,
+			       umode_t mode)
 {
 	struct iattr attr;
 	int error;
-	int open_flags = O_CREAT|O_EXCL;
 
 	dfprintk(VFS, "NFS: create(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
@@ -1590,16 +1591,13 @@ static int nfs_create(struct inode *dir, struct dentry *dentry,
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
-	if (nd && !(nd->flags & LOOKUP_EXCL))
-		open_flags = O_CREAT;
-
 	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags);
 	if (error != 0)
 		goto out_err;
-	return 0;
+	return NULL;
 out_err:
 	d_drop(dentry);
-	return error;
+	return ERR_PTR(error);
 }
 
 /*
-- 
1.7.7

