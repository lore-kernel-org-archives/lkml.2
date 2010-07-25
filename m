Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0GYW7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 18:59:24 -0400
Received: from norkia.v3.sk ([91.210.183.14]:54065 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0GYW7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 18:59:23 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Lubomir Rintel <lkundrak@v3.sk>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] V7: Add support for non-PDP11 v7 filesystems
Date: Mon, 26 Jul 2010 00:59:16 +0200
Message-Id: <1280098756-26522-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100724135128.GA11645@ZenIV.linux.org.uk>
References: <20100724135128.GA11645@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds byte order autodetection (of PDP-11 and LE filesystems).
No attempt is made to detect big-endian filesystems -- were there any?
Tested with PDP-11 v7 filesystems and PC-IX maintenance floppy.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 fs/sysv/super.c |   74 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index ac7b008..0433f23 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
+#include <linux/parser.h>
 #include "sysv.h"
 
 /*
@@ -435,12 +436,46 @@ Ebadsize:
 	goto failed;
 }
 
-static int v7_fill_super(struct super_block *sb, void *data, int silent)
+static int v7_sanity_check(struct super_block *sb, struct buffer_head *bh)
 {
-	struct sysv_sb_info *sbi;
-	struct buffer_head *bh, *bh2 = NULL;
 	struct v7_super_block *v7sb;
 	struct sysv_inode *v7i;
+	struct buffer_head *bh2;
+	struct sysv_sb_info *sbi;
+
+	sbi = sb->s_fs_info;
+
+	/* plausibility check on superblock */
+	v7sb = (struct v7_super_block *) bh->b_data;
+	if (fs16_to_cpu(sbi, v7sb->s_nfree) > V7_NICFREE ||
+	    fs16_to_cpu(sbi, v7sb->s_ninode) > V7_NICINOD ||
+	    fs32_to_cpu(sbi, v7sb->s_fsize) > V7_MAXSIZE)
+		return 0;
+
+	/* plausibility check on root inode: it is a directory,
+	   with a nonzero size that is a multiple of 16 */
+	if ((bh2 = sb_bread(sb, 2)) == NULL) {
+		return 0;
+	}
+
+	v7i = (struct sysv_inode *)(bh2->b_data + 64);
+	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
+	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
+	    (fs32_to_cpu(sbi, v7i->i_size) & 017) ||
+	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
+             sizeof (struct sysv_dir_entry))) {
+		brelse(bh2);
+		return 0;
+	}
+
+	brelse(bh2);
+	return 1;
+}
+
+static int v7_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct sysv_sb_info *sbi;
+	struct buffer_head *bh;
 
 	if (440 != sizeof (struct v7_super_block))
 		panic("V7 FS: bad super-block size");
@@ -454,7 +489,6 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_sb = sb;
 	sbi->s_block_base = 0;
 	sbi->s_type = FSTYPE_V7;
-	sbi->s_bytesex = BYTESEX_PDP;
 	sb->s_fs_info = sbi;
 	
 	sb_set_blocksize(sb, 512);
@@ -466,34 +500,26 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed;
 	}
 
-	/* plausibility check on superblock */
-	v7sb = (struct v7_super_block *) bh->b_data;
-	if (fs16_to_cpu(sbi, v7sb->s_nfree) > V7_NICFREE ||
-	    fs16_to_cpu(sbi, v7sb->s_ninode) > V7_NICINOD ||
-	    fs32_to_cpu(sbi, v7sb->s_fsize) > V7_MAXSIZE)
-		goto failed;
+	/* Try PDP-11 UNIX */
+	sbi->s_bytesex = BYTESEX_PDP;
+	if (v7_sanity_check (sb, bh))
+		goto detected;
 
-	/* plausibility check on root inode: it is a directory,
-	   with a nonzero size that is a multiple of 16 */
-	if ((bh2 = sb_bread(sb, 2)) == NULL)
-		goto failed;
-	v7i = (struct sysv_inode *)(bh2->b_data + 64);
-	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
-	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
-	    (fs32_to_cpu(sbi, v7i->i_size) & 017) ||
-	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
-	     sizeof (struct sysv_dir_entry)))
-		goto failed;
-	brelse(bh2);
-	bh2 = NULL;
+	/* Try PC/IX, v7/x86 */
+	sbi->s_bytesex = BYTESEX_LE;
+	if (v7_sanity_check (sb, bh))
+		goto detected;
 
+	goto failed;
+
+detected:
 	sbi->s_bh1 = bh;
 	sbi->s_bh2 = bh;
 	if (complete_read_super(sb, silent, 1))
 		return 0;
 
 failed:
-	brelse(bh2);
+	printk("VFS: could not find a valid V7 on %s.\n", sb->s_id);
 	brelse(bh);
 	kfree(sbi);
 	return -EINVAL;
-- 
1.7.2

