Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2ECMtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:49:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab2ECMsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:36 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 8/9] vfs: Rename end_writeback() to clear_inode()
Date: Thu,  3 May 2012 14:48:02 +0200
Message-Id: <1336049283-5859-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we moved inode_sync_wait() from end_writeback() it doesn't make sense
to call the function end_writeback() anymore. Rename it to clear_inode()
which well says what the function really does - set I_CLEAR flag.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/porting         |   16 +++++++---------
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 arch/s390/hypfs/inode.c                   |    2 +-
 fs/9p/vfs_inode.c                         |    2 +-
 fs/affs/inode.c                           |    2 +-
 fs/afs/inode.c                            |    2 +-
 fs/autofs4/inode.c                        |    2 +-
 fs/bfs/inode.c                            |    2 +-
 fs/binfmt_misc.c                          |    2 +-
 fs/block_dev.c                            |    2 +-
 fs/btrfs/inode.c                          |    2 +-
 fs/cifs/cifsfs.c                          |    2 +-
 fs/coda/inode.c                           |    2 +-
 fs/ecryptfs/super.c                       |    2 +-
 fs/exofs/inode.c                          |    4 ++--
 fs/ext2/inode.c                           |    2 +-
 fs/ext3/inode.c                           |    6 +++---
 fs/ext4/super.c                           |    2 +-
 fs/fat/inode.c                            |    2 +-
 fs/freevxfs/vxfs_inode.c                  |    2 +-
 fs/fuse/inode.c                           |    2 +-
 fs/gfs2/super.c                           |    2 +-
 fs/hfs/inode.c                            |    2 +-
 fs/hfsplus/super.c                        |    2 +-
 fs/hostfs/hostfs_kern.c                   |    2 +-
 fs/hpfs/inode.c                           |    2 +-
 fs/hppfs/hppfs.c                          |    2 +-
 fs/hugetlbfs/inode.c                      |    2 +-
 fs/inode.c                                |    6 +++---
 fs/jffs2/fs.c                             |    2 +-
 fs/jfs/inode.c                            |    2 +-
 fs/logfs/readwrite.c                      |    2 +-
 fs/minix/inode.c                          |    2 +-
 fs/ncpfs/inode.c                          |    2 +-
 fs/nfs/inode.c                            |    4 ++--
 fs/nilfs2/inode.c                         |    4 ++--
 fs/ntfs/inode.c                           |    2 +-
 fs/ocfs2/dlmfs/dlmfs.c                    |    2 +-
 fs/ocfs2/inode.c                          |    2 +-
 fs/omfs/inode.c                           |    2 +-
 fs/proc/inode.c                           |    2 +-
 fs/pstore/inode.c                         |    2 +-
 fs/reiserfs/inode.c                       |    4 ++--
 fs/sysfs/inode.c                          |    2 +-
 fs/sysv/inode.c                           |    2 +-
 fs/ubifs/super.c                          |    2 +-
 fs/udf/inode.c                            |    2 +-
 fs/ufs/inode.c                            |    2 +-
 fs/xfs/xfs_super.c                        |    2 +-
 include/linux/fs.h                        |    6 +++---
 ipc/mqueue.c                              |    2 +-
 mm/shmem.c                                |    2 +-
 52 files changed, 68 insertions(+), 70 deletions(-)

diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 74acd96..8c91d10 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -297,7 +297,8 @@ in the beginning of ->setattr unconditionally.
 be used instead.  It gets called whenever the inode is evicted, whether it has
 remaining links or not.  Caller does *not* evict the pagecache or inode-associated
 metadata buffers; getting rid of those is responsibility of method, as it had
-been for ->delete_inode().
+been for ->delete_inode(). Caller makes sure async writeback cannot be running
+for the inode while (or after) ->evict_inode() is called.
 
 	->drop_inode() returns int now; it's called on final iput() with
 inode->i_lock held and it returns true if filesystems wants the inode to be
@@ -306,14 +307,11 @@ updated appropriately.  generic_delete_inode() is also alive and it consists
 simply of return 1.  Note that all actual eviction work is done by caller after
 ->drop_inode() returns.
 
-	clear_inode() is gone; use end_writeback() instead.  As before, it must
-be called exactly once on each call of ->evict_inode() (as it used to be for
-each call of ->delete_inode()).  Unlike before, if you are using inode-associated
-metadata buffers (i.e. mark_buffer_dirty_inode()), it's your responsibility to
-call invalidate_inode_buffers() before end_writeback().
-	No async writeback (and thus no calls of ->write_inode()) will happen
-after end_writeback() returns, so actions that should not overlap with ->write_inode()
-(e.g. freeing on-disk inode if i_nlink is 0) ought to be done after that call.
+	As before, clear_inode() must be called exactly once on each call of
+->evict_inode() (as it used to be for each call of ->delete_inode()).  Unlike
+before, if you are using inode-associated metadata buffers (i.e.
+mark_buffer_dirty_inode()), it's your responsibility to call
+invalidate_inode_buffers() before clear_inode().
 
 	NOTE: checking i_nlink in the beginning of ->write_inode() and bailing out
 if it's zero is not *and* *never* *had* *been* enough.  Final unlink() and iput()
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 1d75c92..66519d2 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -151,7 +151,7 @@ static void
 spufs_evict_inode(struct inode *inode)
 {
 	struct spufs_inode_info *ei = SPUFS_I(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (ei->i_ctx)
 		put_spu_context(ei->i_ctx);
 	if (ei->i_gang)
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 6a2cb56..73dae8b 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -115,7 +115,7 @@ static struct inode *hypfs_make_inode(struct super_block *sb, umode_t mode)
 
 static void hypfs_evict_inode(struct inode *inode)
 {
-	end_writeback(inode);
+	clear_inode(inode);
 	kfree(inode->i_private);
 }
 
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 014c8dd..57ccb75 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -448,7 +448,7 @@ void v9fs_evict_inode(struct inode *inode)
 	struct v9fs_inode *v9inode = V9FS_I(inode);
 
 	truncate_inode_pages(inode->i_mapping, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	filemap_fdatawrite(inode->i_mapping);
 
 #ifdef CONFIG_9P_FSCACHE
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 88a4b0b..8bc4a59 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -264,7 +264,7 @@ affs_evict_inode(struct inode *inode)
 	}
 
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	affs_free_prealloc(inode);
 	cache_page = (unsigned long)AFFS_I(inode)->i_lc;
 	if (cache_page) {
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index d890ae3..95cffd3 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -423,7 +423,7 @@ void afs_evict_inode(struct inode *inode)
 	ASSERTCMP(inode->i_ino, ==, vnode->fid.vnode);
 
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	afs_give_up_callback(vnode);
 
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 6e488eb..8a4fed8 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -100,7 +100,7 @@ static int autofs4_show_options(struct seq_file *m, struct dentry *root)
 
 static void autofs4_evict_inode(struct inode *inode)
 {
-	end_writeback(inode);
+	clear_inode(inode);
 	kfree(inode->i_private);
 }
 
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index e23dc7c..9870417 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -174,7 +174,7 @@ static void bfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages(&inode->i_data, 0);
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (inode->i_nlink)
 		return;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 613aa06..790b3cd 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -505,7 +505,7 @@ static struct inode *bm_get_inode(struct super_block *sb, int mode)
 
 static void bm_evict_inode(struct inode *inode)
 {
-	end_writeback(inode);
+	clear_inode(inode);
 	kfree(inode->i_private);
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index e08f6a2..d8a7959 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -487,7 +487,7 @@ static void bdev_evict_inode(struct inode *inode)
 	struct list_head *p;
 	truncate_inode_pages(&inode->i_data, 0);
 	invalidate_inode_buffers(inode); /* is it needed here? */
-	end_writeback(inode);
+	clear_inode(inode);
 	spin_lock(&bdev_lock);
 	while ( (p = bdev->bd_inodes.next) != &bdev->bd_inodes ) {
 		__bd_forget(list_entry(p, struct inode, i_devices));
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 61b16c6..ceb7b9c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3756,7 +3756,7 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
 no_delete:
-	end_writeback(inode);
+	clear_inode(inode);
 	return;
 }
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 811245b..e98146e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -272,7 +272,7 @@ static void
 cifs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	cifs_fscache_release_inode_cookie(inode);
 }
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 2870597..f181312 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -244,7 +244,7 @@ static void coda_put_super(struct super_block *sb)
 static void coda_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	coda_cache_clear_inode(inode);
 }
 
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index 2dd946b..e879cf8 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -133,7 +133,7 @@ static int ecryptfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 static void ecryptfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	iput(ecryptfs_inode_to_lower(inode));
 }
 
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index ea5e1f9..5badb0c 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1473,7 +1473,7 @@ void exofs_evict_inode(struct inode *inode)
 		goto no_delete;
 
 	inode->i_size = 0;
-	end_writeback(inode);
+	clear_inode(inode);
 
 	/* if we are deleting an obj that hasn't been created yet, wait.
 	 * This also makes sure that create_done cannot be called with an
@@ -1503,5 +1503,5 @@ void exofs_evict_inode(struct inode *inode)
 	return;
 
 no_delete:
-	end_writeback(inode);
+	clear_inode(inode);
 }
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 740cad8..37b8bf6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -90,7 +90,7 @@ void ext2_evict_inode(struct inode * inode)
 	}
 
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	ext2_discard_reservation(inode);
 	rsv = EXT2_I(inode)->i_block_alloc_info;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 10d7812..ca5eb61 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -272,18 +272,18 @@ void ext3_evict_inode (struct inode *inode)
 	if (ext3_mark_inode_dirty(handle, inode)) {
 		/* If that failed, just dquot_drop() and be done with that */
 		dquot_drop(inode);
-		end_writeback(inode);
+		clear_inode(inode);
 	} else {
 		ext3_xattr_delete_inode(handle, inode);
 		dquot_free_inode(inode);
 		dquot_drop(inode);
-		end_writeback(inode);
+		clear_inode(inode);
 		ext3_free_inode(handle, inode);
 	}
 	ext3_journal_stop(handle);
 	return;
 no_delete:
-	end_writeback(inode);
+	clear_inode(inode);
 	dquot_drop(inode);
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e1fb1d5..6750c95 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1007,7 +1007,7 @@ static void destroy_inodecache(void)
 void ext4_clear_inode(struct inode *inode)
 {
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
 	if (EXT4_I(inode)->jinode) {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 21687e3..b3d290c 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -454,7 +454,7 @@ static void fat_evict_inode(struct inode *inode)
 		fat_truncate_blocks(inode, 0);
 	}
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	fat_cache_inval_inode(inode);
 	fat_detach(inode);
 }
diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index cf9ef91..ef67c95 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -355,6 +355,6 @@ void
 vxfs_evict_inode(struct inode *ip)
 {
 	truncate_inode_pages(&ip->i_data, 0);
-	end_writeback(ip);
+	clear_inode(ip);
 	call_rcu(&ip->i_rcu, vxfs_i_callback);
 }
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 26783eb..56f6dcf 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -122,7 +122,7 @@ static void fuse_destroy_inode(struct inode *inode)
 static void fuse_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (inode->i_sb->s_flags & MS_ACTIVE) {
 		struct fuse_conn *fc = get_fuse_conn(inode);
 		struct fuse_inode *fi = get_fuse_inode(inode);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 6172fa7..713e621 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1554,7 +1554,7 @@ out_unlock:
 out:
 	/* Case 3 starts here */
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	gfs2_dir_hash_inval(ip);
 	ip->i_gl->gl_object = NULL;
 	flush_delayed_work_sync(&ip->i_gl->gl_work);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 737dbeb..761ec06 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -532,7 +532,7 @@ out:
 void hfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (HFS_IS_RSRC(inode) && HFS_I(inode)->rsrc_inode) {
 		HFS_I(HFS_I(inode)->rsrc_inode)->rsrc_inode = NULL;
 		iput(HFS_I(inode)->rsrc_inode);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index ceb1c28..a9bca4b 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -154,7 +154,7 @@ static void hfsplus_evict_inode(struct inode *inode)
 {
 	dprint(DBG_INODE, "hfsplus_evict_inode: %lu\n", inode->i_ino);
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (HFSPLUS_IS_RSRC(inode)) {
 		HFSPLUS_I(HFSPLUS_I(inode)->rsrc_inode)->rsrc_inode = NULL;
 		iput(HFSPLUS_I(inode)->rsrc_inode);
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 07c516b..2afa5bb 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -240,7 +240,7 @@ static struct inode *hostfs_alloc_inode(struct super_block *sb)
 static void hostfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (HOSTFS_I(inode)->fd != -1) {
 		close_file(&HOSTFS_I(inode)->fd);
 		HOSTFS_I(inode)->fd = -1;
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 3b2cec2..b43066c 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -299,7 +299,7 @@ void hpfs_write_if_changed(struct inode *inode)
 void hpfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (!inode->i_nlink) {
 		hpfs_lock(inode->i_sb);
 		hpfs_remove_fnode(inode->i_sb, inode->i_ino);
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index a80e45a..d4f93b5 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -614,7 +614,7 @@ static struct inode *hppfs_alloc_inode(struct super_block *sb)
 
 void hppfs_evict_inode(struct inode *ino)
 {
-	end_writeback(ino);
+	clear_inode(ino);
 	dput(HPPFS_I(ino)->proc_dentry);
 	mntput(ino->i_sb->s_fs_info);
 }
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 001ef01..cc9281b 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -393,7 +393,7 @@ static void truncate_hugepages(struct inode *inode, loff_t lstart)
 static void hugetlbfs_evict_inode(struct inode *inode)
 {
 	truncate_hugepages(inode, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 }
 
 static inline void
diff --git a/fs/inode.c b/fs/inode.c
index 501fc5d..02c0fa5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -486,7 +486,7 @@ void __remove_inode_hash(struct inode *inode)
 }
 EXPORT_SYMBOL(__remove_inode_hash);
 
-void end_writeback(struct inode *inode)
+void clear_inode(struct inode *inode)
 {
 	might_sleep();
 	/*
@@ -503,7 +503,7 @@ void end_writeback(struct inode *inode)
 	/* don't need i_lock here, no concurrent mods to i_state */
 	inode->i_state = I_FREEING | I_CLEAR;
 }
-EXPORT_SYMBOL(end_writeback);
+EXPORT_SYMBOL(clear_inode);
 
 /*
  * Free the inode passed in, removing it from the lists it is still connected
@@ -537,7 +537,7 @@ static void evict(struct inode *inode)
 	} else {
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
-		end_writeback(inode);
+		clear_inode(inode);
 	}
 	if (S_ISBLK(inode->i_mode) && inode->i_bdev)
 		bd_forget(inode);
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index bb6f993..3d3092e 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -240,7 +240,7 @@ void jffs2_evict_inode (struct inode *inode)
 	jffs2_dbg(1, "%s(): ino #%lu mode %o\n",
 		  __func__, inode->i_ino, inode->i_mode);
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	jffs2_do_clear_inode(c, f);
 }
 
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 77b69b2..4692bf3 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -169,7 +169,7 @@ void jfs_evict_inode(struct inode *inode)
 	} else {
 		truncate_inode_pages(&inode->i_data, 0);
 	}
-	end_writeback(inode);
+	clear_inode(inode);
 	dquot_drop(inode);
 }
 
diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index e3ab5e5..f1cb512 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -2175,7 +2175,7 @@ void logfs_evict_inode(struct inode *inode)
 		}
 	}
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	/* Cheaper version of write_inode.  All changes are concealed in
 	 * aliases, which are moved back.  No write to the medium happens.
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index fcb05d2..2a503ad 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -32,7 +32,7 @@ static void minix_evict_inode(struct inode *inode)
 		minix_truncate(inode);
 	}
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (!inode->i_nlink)
 		minix_free_inode(inode);
 }
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 87484fb..333df07 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -292,7 +292,7 @@ static void
 ncp_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (S_ISDIR(inode->i_mode)) {
 		DDPRINTK("ncp_evict_inode: put directory %ld\n", inode->i_ino);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index e8bbfa5..c607313 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -121,7 +121,7 @@ static void nfs_clear_inode(struct inode *inode)
 void nfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	nfs_clear_inode(inode);
 }
 
@@ -1500,7 +1500,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 void nfs4_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	pnfs_return_layout(inode);
 	pnfs_destroy_layout(NFS_I(inode));
 	/* If we are holding a delegation, return it! */
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 8f7b95a..7cc6446 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -734,7 +734,7 @@ void nilfs_evict_inode(struct inode *inode)
 	if (inode->i_nlink || !ii->i_root || unlikely(is_bad_inode(inode))) {
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
-		end_writeback(inode);
+		clear_inode(inode);
 		nilfs_clear_inode(inode);
 		return;
 	}
@@ -746,7 +746,7 @@ void nilfs_evict_inode(struct inode *inode)
 	/* TODO: some of the following operations may fail.  */
 	nilfs_truncate_bmap(ii, 0);
 	nilfs_mark_inode_dirty(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	ret = nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino);
 	if (!ret)
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 2eaa666..c6dbd3d 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2258,7 +2258,7 @@ void ntfs_evict_big_inode(struct inode *vi)
 	ntfs_inode *ni = NTFS_I(vi);
 
 	truncate_inode_pages(&vi->i_data, 0);
-	end_writeback(vi);
+	clear_inode(vi);
 
 #ifdef NTFS_RW
 	if (NInoDirty(ni)) {
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 3b5825e..e31d6ae 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -367,7 +367,7 @@ static void dlmfs_evict_inode(struct inode *inode)
 	int status;
 	struct dlmfs_inode_private *ip;
 
-	end_writeback(inode);
+	clear_inode(inode);
 
 	mlog(0, "inode %lu\n", inode->i_ino);
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 17454a9..735514c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1069,7 +1069,7 @@ static void ocfs2_clear_inode(struct inode *inode)
 	int status;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	end_writeback(inode);
+	clear_inode(inode);
 	trace_ocfs2_clear_inode((unsigned long long)oi->ip_blkno,
 				inode->i_nlink);
 
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index dbc8422..e6213b3 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -184,7 +184,7 @@ int omfs_sync_inode(struct inode *inode)
 static void omfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (inode->i_nlink)
 		return;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 205c922..29ab406 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -33,7 +33,7 @@ static void proc_evict_inode(struct inode *inode)
 	const struct proc_ns_operations *ns_ops;
 
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	/* Stop tracking associated processes */
 	put_pid(PROC_I(inode)->pid);
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 1950788..aeb19e6 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -85,7 +85,7 @@ static void pstore_evict_inode(struct inode *inode)
 	struct pstore_private	*p = inode->i_private;
 	unsigned long		flags;
 
-	end_writeback(inode);
+	clear_inode(inode);
 	if (p) {
 		spin_lock_irqsave(&allpstore_lock, flags);
 		list_del(&p->list);
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 494c315..59d0687 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -76,14 +76,14 @@ void reiserfs_evict_inode(struct inode *inode)
 		;
 	}
       out:
-	end_writeback(inode);	/* note this must go after the journal_end to prevent deadlock */
+	clear_inode(inode);	/* note this must go after the journal_end to prevent deadlock */
 	dquot_drop(inode);
 	inode->i_blocks = 0;
 	reiserfs_write_unlock_once(inode->i_sb, depth);
 	return;
 
 no_delete:
-	end_writeback(inode);
+	clear_inode(inode);
 	dquot_drop(inode);
 }
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index feb2d69..b8ce6a9 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -310,7 +310,7 @@ void sysfs_evict_inode(struct inode *inode)
 	struct sysfs_dirent *sd  = inode->i_private;
 
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	sysfs_put(sd);
 }
 
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 3da5ce2..08d0b25 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -316,7 +316,7 @@ static void sysv_evict_inode(struct inode *inode)
 		sysv_truncate(inode);
 	}
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (!inode->i_nlink)
 		sysv_free_inode(inode);
 }
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 76e4e05..7bf60ae 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -378,7 +378,7 @@ out:
 		smp_wmb();
 	}
 done:
-	end_writeback(inode);
+	clear_inode(inode);
 }
 
 static void ubifs_dirty_inode(struct inode *inode, int flags)
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7d75280..873e1ba 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -80,7 +80,7 @@ void udf_evict_inode(struct inode *inode)
 	} else
 		truncate_inode_pages(&inode->i_data, 0);
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
 	    inode->i_size != iinfo->i_lenExtents) {
 		udf_warn(inode->i_sb, "Inode %lu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 7cdd395..dd7c89d 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -895,7 +895,7 @@ void ufs_evict_inode(struct inode * inode)
 	}
 
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (want_delete) {
 		lock_ufs(inode->i_sb);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index dab9a5f..5b806f2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -926,7 +926,7 @@ xfs_fs_evict_inode(
 	trace_xfs_evict_inode(ip);
 
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	XFS_STATS_INC(vn_rele);
 	XFS_STATS_INC(vn_remove);
 	XFS_STATS_DEC(vn_active);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..c79316c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1744,8 +1744,8 @@ struct super_operations {
  * I_FREEING		Set when inode is about to be freed but still has dirty
  *			pages or buffers attached or the inode itself is still
  *			dirty.
- * I_CLEAR		Added by end_writeback().  In this state the inode is clean
- *			and can be destroyed.  Inode keeps I_FREEING.
+ * I_CLEAR		Added by clear_inode().  In this state the inode is
+ *			clean and can be destroyed.  Inode keeps I_FREEING.
  *
  *			Inodes that are I_WILL_FREE, I_FREEING or I_CLEAR are
  *			prohibited for many purposes.  iget() must wait for
@@ -2328,7 +2328,7 @@ extern unsigned int get_next_ino(void);
 
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
-extern void end_writeback(struct inode *);
+extern void clear_inode(struct inode *);
 extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode_pseudo(struct super_block *sb);
 extern struct inode *new_inode(struct super_block *sb);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 28bd64d..0032d9c 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -249,7 +249,7 @@ static void mqueue_evict_inode(struct inode *inode)
 	int i;
 	struct ipc_namespace *ipc_ns;
 
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (S_ISDIR(inode->i_mode))
 		return;
diff --git a/mm/shmem.c b/mm/shmem.c
index f99ff3e..68412fa 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -597,7 +597,7 @@ static void shmem_evict_inode(struct inode *inode)
 	}
 	BUG_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
-	end_writeback(inode);
+	clear_inode(inode);
 }
 
 /*
-- 
1.7.1

