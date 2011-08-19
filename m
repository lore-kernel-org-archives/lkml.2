Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1HSSCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab1HSSCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:02:04 -0400
Date: Fri, 19 Aug 2011 14:02:00 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2] fs/minix: Verify bitmap block counts before mounting
Message-ID: <20110819180159.GB2270@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer versions of MINIX can create filesystems that allocate an extra
bitmap block.  Mounting of this succeeds, but doing a statfs call will
result in an oops in count_free because of a negative number being used
for the bh index.

Avoid this by verifying the number of allocated blocks at mount time,
erroring out if there are not enough and make statfs ignore the extras
if there are too many.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=18792

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---

v2: Remove some thinko stupidity and silently ignore the too many blocks case

 fs/minix/bitmap.c |   17 ++++++++++++-----
 fs/minix/inode.c  |   25 +++++++++++++++++++++++--
 fs/minix/minix.h  |   13 +++++++++++--
 3 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 3f32bcb..3265047 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -105,10 +105,13 @@ int minix_new_block(struct inode * inode)
 	return 0;
 }
 
-unsigned long minix_count_free_blocks(struct minix_sb_info *sbi)
+unsigned long minix_count_free_blocks(struct super_block *sb)
 {
-	return (count_free(sbi->s_zmap, sbi->s_zmap_blocks,
-		sbi->s_nzones - sbi->s_firstdatazone + 1)
+	struct minix_sb_info *sbi = minix_sb(sb);
+	u32 bits = sbi->s_nzones - (sbi->s_firstdatazone + 1);
+	unsigned blocks = minix_blocks_needed(bits, sb->s_blocksize);
+
+	return (count_free(sbi->s_zmap, blocks, bits)
 		<< sbi->s_log_zone_size);
 }
 
@@ -273,7 +276,11 @@ struct inode *minix_new_inode(const struct inode *dir, int mode, int *error)
 	return inode;
 }
 
-unsigned long minix_count_free_inodes(struct minix_sb_info *sbi)
+unsigned long minix_count_free_inodes(struct super_block *sb)
 {
-	return count_free(sbi->s_imap, sbi->s_imap_blocks, sbi->s_ninodes + 1);
+	struct minix_sb_info *sbi = minix_sb(sb);
+	u32 bits = sbi->s_ninodes + 1;
+	unsigned blocks = minix_blocks_needed(bits, sb->s_blocksize);
+
+	return count_free(sbi->s_imap, blocks, bits);
 }
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index e7d23e2..1ed1351 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -279,6 +279,27 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
  	else if (sbi->s_mount_state & MINIX_ERROR_FS)
 		printk("MINIX-fs: mounting file system with errors, "
 			"running fsck is recommended\n");
+
+	/* Apparently minix can create filesystems that allocate more blocks for
+	 * the bitmaps than needed.  We simply ignore that, but verify it didn't
+	 * create one with not enough blocks and bail out if so.
+	 */
+	block = minix_blocks_needed(sbi->s_ninodes, s->s_blocksize);
+	if (sbi->s_imap_blocks < block) {
+		printk("MINIX-fs: file system does not have enough "
+				"imap blocks allocated.  Refusing to mount\n");
+		goto out_iput;
+	}
+
+	block = minix_blocks_needed(
+			(sbi->s_nzones - (sbi->s_firstdatazone + 1)),
+			s->s_blocksize);
+	if (sbi->s_zmap_blocks < block) {
+		printk("MINIX-fs: file system does not have enough "
+				"zmap blocks allocated.  Refusing to mount.\n");
+		goto out_iput;
+	}
+
 	return 0;
 
 out_iput:
@@ -339,10 +360,10 @@ static int minix_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_type = sb->s_magic;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = (sbi->s_nzones - sbi->s_firstdatazone) << sbi->s_log_zone_size;
-	buf->f_bfree = minix_count_free_blocks(sbi);
+	buf->f_bfree = minix_count_free_blocks(sb);
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = sbi->s_ninodes;
-	buf->f_ffree = minix_count_free_inodes(sbi);
+	buf->f_ffree = minix_count_free_inodes(sb);
 	buf->f_namelen = sbi->s_namelen;
 	buf->f_fsid.val[0] = (u32)id;
 	buf->f_fsid.val[1] = (u32)(id >> 32);
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 341e212..9850080 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -48,10 +48,10 @@ extern struct minix_inode * minix_V1_raw_inode(struct super_block *, ino_t, stru
 extern struct minix2_inode * minix_V2_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 extern struct inode * minix_new_inode(const struct inode *, int, int *);
 extern void minix_free_inode(struct inode * inode);
-extern unsigned long minix_count_free_inodes(struct minix_sb_info *sbi);
+extern unsigned long minix_count_free_inodes(struct super_block *sb);
 extern int minix_new_block(struct inode * inode);
 extern void minix_free_block(struct inode *inode, unsigned long block);
-extern unsigned long minix_count_free_blocks(struct minix_sb_info *sbi);
+extern unsigned long minix_count_free_blocks(struct super_block *sb);
 extern int minix_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int minix_prepare_chunk(struct page *page, loff_t pos, unsigned len);
 
@@ -88,6 +88,15 @@ static inline struct minix_inode_info *minix_i(struct inode *inode)
 	return list_entry(inode, struct minix_inode_info, vfs_inode);
 }
 
+static inline unsigned minix_blocks_needed(unsigned bits, unsigned blocksize)
+{
+	unsigned blocks = bits / (blocksize * 8);
+
+	if (bits % (blocksize * 8))
+		blocks++;
+	return blocks;
+}
+
 #if defined(CONFIG_MINIX_FS_NATIVE_ENDIAN) && \
 	defined(CONFIG_MINIX_FS_BIG_ENDIAN_16BIT_INDEXED)
 
-- 
1.7.6

