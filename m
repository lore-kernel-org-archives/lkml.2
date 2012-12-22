Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab2LVDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:09:29 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:40265 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LVDJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:09:26 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/5] f2fs: Introduce some information prints in the mount path
Date: Sat, 22 Dec 2012 12:08:45 +0900
Message-Id: <1356145725-19940-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Added few informative prints in the mount path, to convey proper error
in case of mount failure.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/super.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index cf0ffb8..86f8549 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -342,19 +342,29 @@ static int sanity_check_raw_super(struct f2fs_super_block *raw_super)
 {
 	unsigned int blocksize;
 
-	if (F2FS_SUPER_MAGIC != le32_to_cpu(raw_super->magic))
+	if (F2FS_SUPER_MAGIC != le32_to_cpu(raw_super->magic)) {
+		pr_info("Magic Mismatch, valid(0x%x) - read(0x%x)\n",
+			F2FS_SUPER_MAGIC, le32_to_cpu(raw_super->magic));
 		return 1;
+	}
 
 	/* Currently, support only 4KB block size */
 	blocksize = 1 << le32_to_cpu(raw_super->log_blocksize);
-	if (blocksize != PAGE_CACHE_SIZE)
+	if (blocksize != PAGE_CACHE_SIZE) {
+		pr_info("Not valid blocksize (%u), supports only 4KB\n",
+			blocksize);
 		return 1;
+	}
 	if (le32_to_cpu(raw_super->log_sectorsize) !=
-					F2FS_LOG_SECTOR_SIZE)
+					F2FS_LOG_SECTOR_SIZE) {
+		pr_info("Not valid log sectorsize\n");
 		return 1;
+	}
 	if (le32_to_cpu(raw_super->log_sectors_per_block) !=
-					F2FS_LOG_SECTORS_PER_BLOCK)
+					F2FS_LOG_SECTORS_PER_BLOCK) {
+			pr_info("Not valid log sectors per block\n");
 		return 1;
+	}
 	return 0;
 }
 
@@ -415,13 +425,16 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 
 	/* set a temporary block size */
-	if (!sb_set_blocksize(sb, F2FS_BLKSIZE))
+	if (!sb_set_blocksize(sb, F2FS_BLKSIZE)) {
+		pr_err("unable to set blocksize\n");
 		goto free_sbi;
+	}
 
 	/* read f2fs raw super block */
 	raw_super_buf = sb_bread(sb, 0);
 	if (!raw_super_buf) {
 		err = -EIO;
+		pr_err("unable to read superblock\n");
 		goto free_sbi;
 	}
 	raw_super = (struct f2fs_super_block *)
@@ -443,8 +456,10 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto free_sb_buf;
 
 	/* sanity checking of raw super */
-	if (sanity_check_raw_super(raw_super))
+	if (sanity_check_raw_super(raw_super)) {
+		pr_err("Not a valid F2FS filesystem\n");
 		goto free_sb_buf;
+	}
 
 	sb->s_maxbytes = max_file_size(le32_to_cpu(raw_super->log_blocksize));
 	sb->s_max_links = F2FS_LINK_MAX;
@@ -478,18 +493,23 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	/* get an inode for meta space */
 	sbi->meta_inode = f2fs_iget(sb, F2FS_META_INO(sbi));
 	if (IS_ERR(sbi->meta_inode)) {
+		pr_err("Failed to read F2FS meta data inode\n");
 		err = PTR_ERR(sbi->meta_inode);
 		goto free_sb_buf;
 	}
 
 	err = get_valid_checkpoint(sbi);
-	if (err)
+	if (err) {
+		pr_err("Failed to get valid F2FS checkpoint\n");
 		goto free_meta_inode;
+	}
 
 	/* sanity checking of checkpoint */
 	err = -EINVAL;
-	if (sanity_check_ckpt(raw_super, sbi->ckpt))
+	if (sanity_check_ckpt(raw_super, sbi->ckpt)) {
+		pr_err("Not a valid F2FS checkpoint\n");
 		goto free_cp;
+	}
 
 	sbi->total_valid_node_count =
 				le32_to_cpu(sbi->ckpt->valid_node_count);
@@ -511,17 +531,22 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* setup f2fs internal modules */
 	err = build_segment_manager(sbi);
-	if (err)
+	if (err) {
+		pr_err("Failed to initialize F2FS segment manager\n");
 		goto free_sm;
+	}
 	err = build_node_manager(sbi);
-	if (err)
+	if (err) {
+		pr_err("Failed to initialize F2FS node manager\n");
 		goto free_nm;
+	}
 
 	build_gc_manager(sbi);
 
 	/* get an inode for node space */
 	sbi->node_inode = f2fs_iget(sb, F2FS_NODE_INO(sbi));
 	if (IS_ERR(sbi->node_inode)) {
+		pr_err("Failed to read node inode\n");
 		err = PTR_ERR(sbi->node_inode);
 		goto free_nm;
 	}
@@ -534,6 +559,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	/* read root inode and dentry */
 	root = f2fs_iget(sb, F2FS_ROOT_INO(sbi));
 	if (IS_ERR(root)) {
+		pr_err("Failed to read root inode\n");
 		err = PTR_ERR(root);
 		goto free_node_inode;
 	}
-- 
1.7.9.5

