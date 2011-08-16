Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1HPO3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:29:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55787 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1HPO3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:29:17 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] fat: fat16 support maximum 4GB file/vol size as WinXP or 7.
Date: Tue, 16 Aug 2011 23:28:51 +0900
Message-Id: <1313504931-1969-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAT16 support maximum 4GB vol/file size with 64KB cluster size.

Win NT/XP/7 increased the maximum cluster size to 64KB, and file/vol size increased 4GB also.
Although increasing, the file size of linux FAT is still limited at 2GB.
I found that it is limited by sb->maxbytes(0x7fffffff) when partition is formatted by FAT16.
sb->s_maxbytes in fill_super should be set to 0xffffffff like fat32.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/fat/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 5942fec..f2dce50 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1367,6 +1367,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	sbi->free_clusters = -1;	/* Don't know yet */
 	sbi->free_clus_valid = 0;
 	sbi->prev_free = FAT_START_ENT;
+	sb->s_maxbytes = 0xffffffff;
 
 	if (!sbi->fat_length && b->fat32_length) {
 		struct fat_boot_fsinfo *fsinfo;
@@ -1377,8 +1378,6 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		sbi->fat_length = le32_to_cpu(b->fat32_length);
 		sbi->root_cluster = le32_to_cpu(b->root_cluster);
 
-		sb->s_maxbytes = 0xffffffff;
-
 		/* MC - if info_sector is 0, don't multiply by 0 */
 		sbi->fsinfo_sector = le16_to_cpu(b->info_sector);
 		if (sbi->fsinfo_sector == 0)
-- 
1.7.4.4

