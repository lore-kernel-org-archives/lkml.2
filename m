Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2JFKs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 06:48:28 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49825 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2JFKs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 06:48:26 -0400
Message-ID: <50700AEA.1080101@gmail.com>
Date: Sat, 06 Oct 2012 12:41:46 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] sysv: drop lock/unlock super
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed lock/unlock super. Added a new private s_lock mutex.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/sysv/balloc.c |   18 +++++++++---------
 fs/sysv/ialloc.c |   14 +++++++-------
 fs/sysv/inode.c  |    4 ++--
 fs/sysv/super.c  |    1 +
 fs/sysv/sysv.h   |    1 +
 5 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/sysv/balloc.c b/fs/sysv/balloc.c
index 9a6ad96..921c053 100644
--- a/fs/sysv/balloc.c
+++ b/fs/sysv/balloc.c
@@ -60,12 +60,12 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 		return;
 	}
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	count = fs16_to_cpu(sbi, *sbi->s_bcache_count);
 
 	if (count > sbi->s_flc_size) {
 		printk("sysv_free_block: flc_count > flc_size\n");
-		unlock_super(sb);
+		mutex_unlock(&sbi->s_lock);
 		return;
 	}
 	/* If the free list head in super-block is full, it is copied
@@ -77,7 +77,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 		bh = sb_getblk(sb, block);
 		if (!bh) {
 			printk("sysv_free_block: getblk() failed\n");
-			unlock_super(sb);
+			mutex_unlock(&sbi->s_lock);
 			return;
 		}
 		memset(bh->b_data, 0, sb->s_blocksize);
@@ -93,7 +93,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 	*sbi->s_bcache_count = cpu_to_fs16(sbi, count);
 	fs32_add(sbi, sbi->s_free_blocks, 1);
 	dirty_sb(sb);
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 }
 
 sysv_zone_t sysv_new_block(struct super_block * sb)
@@ -104,7 +104,7 @@ sysv_zone_t sysv_new_block(struct super_block * sb)
 	struct buffer_head * bh;
 	unsigned count;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	count = fs16_to_cpu(sbi, *sbi->s_bcache_count);
 
 	if (count == 0) /* Applies only to Coherent FS */
@@ -147,11 +147,11 @@ sysv_zone_t sysv_new_block(struct super_block * sb)
 	/* Now the free list head in the superblock is valid again. */
 	fs32_add(sbi, sbi->s_free_blocks, -1);
 	dirty_sb(sb);
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return nr;
 
 Enospc:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return 0;
 }
 
@@ -173,7 +173,7 @@ unsigned long sysv_count_free_blocks(struct super_block * sb)
 	if (sbi->s_type == FSTYPE_AFS)
 		return 0;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	sb_count = fs32_to_cpu(sbi, *sbi->s_free_blocks);
 
 	if (0)
@@ -211,7 +211,7 @@ unsigned long sysv_count_free_blocks(struct super_block * sb)
 	if (count != sb_count)
 		goto Ecount;
 done:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return count;
 
 Einval:
diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
index 8233b02..f9db4eb 100644
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -118,7 +118,7 @@ void sysv_free_inode(struct inode * inode)
 		       "%s\n", inode->i_sb->s_id);
 		return;
 	}
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	count = fs16_to_cpu(sbi, *sbi->s_sb_fic_count);
 	if (count < sbi->s_fic_size) {
 		*sv_sb_fic_inode(sb,count++) = cpu_to_fs16(sbi, ino);
@@ -128,7 +128,7 @@ void sysv_free_inode(struct inode * inode)
 	dirty_sb(sb);
 	memset(raw_inode, 0, sizeof(struct sysv_inode));
 	mark_buffer_dirty(bh);
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	brelse(bh);
 }
 
@@ -147,13 +147,13 @@ struct inode * sysv_new_inode(const struct inode * dir, umode_t mode)
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	count = fs16_to_cpu(sbi, *sbi->s_sb_fic_count);
 	if (count == 0 || (*sv_sb_fic_inode(sb,count-1) == 0)) {
 		count = refill_free_cache(sb);
 		if (count == 0) {
 			iput(inode);
-			unlock_super(sb);
+			mutex_unlock(&sbi->s_lock);
 			return ERR_PTR(-ENOSPC);
 		}
 	}
@@ -174,7 +174,7 @@ struct inode * sysv_new_inode(const struct inode * dir, umode_t mode)
 	sysv_write_inode(inode, &wbc);	/* ensure inode not allocated again */
 	mark_inode_dirty(inode);	/* cleared by sysv_write_inode() */
 	/* That's it. */
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return inode;
 }
 
@@ -185,7 +185,7 @@ unsigned long sysv_count_free_inodes(struct super_block * sb)
 	struct sysv_inode * raw_inode;
 	int ino, count, sb_count;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 
 	sb_count = fs16_to_cpu(sbi, *sbi->s_sb_total_free_inodes);
 
@@ -213,7 +213,7 @@ unsigned long sysv_count_free_inodes(struct super_block * sb)
 	if (count != sb_count)
 		goto Einval;
 out:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	return count;
 
 Einval:
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index d33e506..c327d4e 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -36,7 +36,7 @@ static int sysv_sync_fs(struct super_block *sb, int wait)
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
 	unsigned long time = get_seconds(), old_time;
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 
 	/*
 	 * If we are going to write out the super block,
@@ -51,7 +51,7 @@ static int sysv_sync_fs(struct super_block *sb, int wait)
 		mark_buffer_dirty(sbi->s_bh2);
 	}
 
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 
 	return 0;
 }
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 7491c33..a38e87b 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -368,6 +368,7 @@ static int sysv_fill_super(struct super_block *sb, void *data, int silent)
 
 	sbi->s_sb = sb;
 	sbi->s_block_base = 0;
+	mutex_init(&sbi->s_lock);
 	sb->s_fs_info = sbi;
 
 	sb_set_blocksize(sb, BLOCK_SIZE);
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 0bc35fd..69d4889 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -58,6 +58,7 @@ struct sysv_sb_info {
 	u32            s_nzones;	/* same as s_sbd->s_fsize */
 	u16	       s_namelen;       /* max length of dir entry */
 	int	       s_forced_ro;
+	struct mutex s_lock;
 };
 
 /*
-- 
1.7.3.4
