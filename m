Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab1ETTNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:13:52 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61839 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935691Ab1ETTNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:13:49 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: Eric Van Hensbergen <ericvh@gmail.com> (maintainer:9P FILE SYSTEM),
        Ron Minnich <rminnich@sandia.gov> (maintainer:9P FILE SYSTEM),
        Latchesar Ionkov <lucho@ionkov.net> (maintainer:9P FILE SYSTEM),
        v9fs-developer@lists.sourceforge.net (open list:9P FILE SYSTEM)
Subject: [PATCH 7/8] 9p: Kill set but not used warnings
Date: Fri, 20 May 2011 16:13:04 -0300
Message-Id: <1305918786-7239-7-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305918786-7239-6-git-send-email-padovan@profusion.mobi>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-4-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-5-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-6-git-send-email-padovan@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 fs/9p/cache.c     |    2 --
 fs/9p/vfs_file.c  |    2 --
 fs/9p/vfs_inode.c |    5 +----
 3 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index 5b335c5..18e6e1f 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -241,13 +241,11 @@ void v9fs_cache_inode_flush_cookie(struct inode *inode)
 void v9fs_cache_inode_set_cookie(struct inode *inode, struct file *filp)
 {
 	struct v9fs_inode *v9inode = V9FS_I(inode);
-	struct p9_fid *fid;
 
 	if (!v9inode->fscache)
 		return;
 
 	spin_lock(&v9inode->fscache_lock);
-	fid = filp->private_data;
 	if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
 		v9fs_cache_inode_flush_cookie(inode);
 	else
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index ffed558..0a04ad9 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -446,14 +446,12 @@ v9fs_file_write_internal(struct inode *inode, struct p9_fid *fid,
 	int n;
 	loff_t i_size;
 	size_t total = 0;
-	struct p9_client *clnt;
 	loff_t origin = *offset;
 	unsigned long pg_start, pg_end;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "data %p count %d offset %x\n", data,
 		(int)count, (int)*offset);
 
-	clnt = fid->clnt;
 	do {
 		n = p9_client_write(fid, NULL, data+total, origin+total, count);
 		if (n <= 0)
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 7f6c677..13a3ab9 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -738,7 +738,6 @@ static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 				      struct nameidata *nameidata)
 {
-	struct super_block *sb;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *dfid, *fid;
 	struct inode *inode;
@@ -751,7 +750,6 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	sb = dir->i_sb;
 	v9ses = v9fs_inode2v9ses(dir);
 	/* We can walk d_parent because we hold the dir->i_mutex */
 	dfid = v9fs_fid_lookup(dentry->d_parent);
@@ -929,13 +927,12 @@ static int
 v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
-	int err;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
 	struct p9_wstat *st;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "dentry: %p\n", dentry);
-	err = -EPERM;
+
 	v9ses = v9fs_dentry2v9ses(dentry);
 	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
 		generic_fillattr(dentry->d_inode, stat);
-- 
1.7.5.1

