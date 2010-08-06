Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030Ab0HFWmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:42:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935099Ab0HFWgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:36:33 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 16/38] fallthru: tmpfs fallthru support
Date: Fri,  6 Aug 2010 15:35:02 -0700
Message-Id: <1281134124-17041-17-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for fallthru directory entries to tmpfs

XXX - Makes up inode number for dirent

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/dcache.c |    3 +-
 fs/libfs.c  |   21 ++++++++++++++++--
 mm/shmem.c  |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 249d077..2cd367a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2240,7 +2240,8 @@ resume:
 		 * we can evict it.
 		 */
 		if (d_unhashed(dentry)||(!dentry->d_inode &&
-					 !d_is_whiteout(dentry)))
+					 !d_is_whiteout(dentry) &&
+					 !d_is_fallthru(dentry)))
 			continue;
 		if (!list_empty(&dentry->d_subdirs)) {
 			this_parent = dentry;
diff --git a/fs/libfs.c b/fs/libfs.c
index dcaf972..20e9a49 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -130,6 +130,7 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct dentry *cursor = filp->private_data;
 	struct list_head *p, *q = &cursor->d_u.d_child;
 	ino_t ino;
+	int d_type;
 	int i = filp->f_pos;
 
 	switch (i) {
@@ -155,14 +156,28 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				if (d_unhashed(next) || !next->d_inode)
+				if (d_unhashed(next) || (!next->d_inode && !d_is_fallthru(next)))
 					continue;
 
+				if (d_is_fallthru(next)) {
+					/* XXX We don't know the inode
+					 * number of the directory
+					 * entry in the underlying
+					 * file system.  Should look
+					 * it up, either on fallthru
+					 * creation at first readdir
+					 * or now at filldir time. */
+					ino = 123; /* Made up ino */
+					d_type = DT_UNKNOWN;
+				} else {
+					ino = next->d_inode->i_ino;
+					d_type = dt_type(next->d_inode);
+				}
+
 				spin_unlock(&dcache_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
-					    next->d_inode->i_ino, 
-					    dt_type(next->d_inode)) < 0)
+					    ino, d_type) < 0)
 					return 0;
 				spin_lock(&dcache_lock);
 				/* next is still alive */
diff --git a/mm/shmem.c b/mm/shmem.c
index a0a4fa5..eab3f27 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1809,8 +1809,7 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry);
 static int shmem_unlink(struct inode *dir, struct dentry *dentry);
 
 /*
- * This is the whiteout support for tmpfs. It uses one singleton whiteout
- * inode per superblock thus it is very similar to shmem_link().
+ * Create a dentry to signify a whiteout.
  */
 static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
 			  struct dentry *new_dentry)
@@ -1841,8 +1840,10 @@ static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
 		spin_unlock(&sbinfo->stat_lock);
 	}
 
-	if (old_dentry->d_inode) {
-		if (S_ISDIR(old_dentry->d_inode->i_mode))
+	if (old_dentry->d_inode || d_is_fallthru(old_dentry)) {
+		/* A fallthru for a dir is treated like a regular link */
+		if (old_dentry->d_inode &&
+		    S_ISDIR(old_dentry->d_inode->i_mode))
 			shmem_rmdir(dir, old_dentry);
 		else
 			shmem_unlink(dir, old_dentry);
@@ -1859,6 +1860,48 @@ static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
 }
 
 static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
+				struct inode *inode);
+
+/*
+ * Create a dentry to signify a fallthru.  A fallthru in tmpfs is the
+ * logical equivalent of an in-kernel readdir() cache.  It can't be
+ * deleted until the file system is unmounted.
+ */
+static int shmem_fallthru(struct inode *dir, struct dentry *dentry)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(dir->i_sb);
+
+	/* FIXME: this is stupid */
+	if (!(dir->i_sb->s_flags & MS_WHITEOUT))
+		return -EPERM;
+
+	if (dentry->d_inode || d_is_fallthru(dentry) || d_is_whiteout(dentry))
+		return -EEXIST;
+
+	/*
+	 * Each new link needs a new dentry, pinning lowmem, and tmpfs
+	 * dentries cannot be pruned until they are unlinked.
+	 */
+	if (sbinfo->max_inodes) {
+		spin_lock(&sbinfo->stat_lock);
+		if (!sbinfo->free_inodes) {
+			spin_unlock(&sbinfo->stat_lock);
+			return -ENOSPC;
+		}
+		sbinfo->free_inodes--;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+
+	shmem_d_instantiate(dir, dentry, NULL);
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_FALLTHRU;
+	spin_unlock(&dentry->d_lock);
+	return 0;
+}
+
+static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
 				struct inode *inode)
 {
 	if (d_is_whiteout(dentry)) {
@@ -1866,14 +1909,15 @@ static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
 		shmem_free_inode(dir->i_sb);
 		if (S_ISDIR(inode->i_mode))
 			inode->i_mode |= S_OPAQUE;
+	} else if (d_is_fallthru(dentry)) {
+		shmem_free_inode(dir->i_sb);
 	} else {
 		/* New dentry */
 		dir->i_size += BOGO_DIRENT_SIZE;
 		dget(dentry); /* Extra count - pin the dentry in core */
 	}
-	/* Will clear DCACHE_WHITEOUT flag */
+	/* Will clear DCACHE_WHITEOUT and DCACHE_FALLTHRU flags */
 	d_instantiate(dentry, inode);
-
 }
 /*
  * File creation. Allocate an inode, and we're done..
@@ -1955,7 +1999,8 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (d_is_whiteout(dentry) || (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)))
+	if (d_is_whiteout(dentry) || d_is_fallthru(dentry) ||
+	    (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)))
 		shmem_free_inode(dir->i_sb);
 
 	if (inode) {
@@ -2479,8 +2524,10 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_root = root;
 
 #ifdef CONFIG_TMPFS
-	if (!(sb->s_flags & MS_NOUSER))
+	if (!(sb->s_flags & MS_NOUSER)) {
 		sb->s_flags |= MS_WHITEOUT;
+		sb->s_flags |= MS_FALLTHRU;
+	}
 #endif
 
 	return 0;
@@ -2583,6 +2630,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
 	.whiteout       = shmem_whiteout,
+	.fallthru       = shmem_fallthru,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
-- 
1.6.3.3

