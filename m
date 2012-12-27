Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab2L0RTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 12:19:19 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57351 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab2L0RTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 12:19:17 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        bug-track@fisher-privat.net
Subject: [PATCH 1/2] fat: add extended fileds to struct fat_boot_sector
Date: Fri, 28 Dec 2012 02:19:13 +0900
Message-ID: <87pq1vza3y.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Oleksij Rempel <bug-track@fisher-privat.net>

later we will need "state" field to check if volume was cleanly unmounted.

Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c                |    8 ++++----
 include/uapi/linux/msdos_fs.h |   36 ++++++++++++++++++++++++++++--------
 2 files changed, 32 insertions(+), 12 deletions(-)

diff -puN fs/fat/inode.c~fat-check-dirty-1 fs/fat/inode.c
--- linux/fs/fat/inode.c~fat-check-dirty-1	2012-12-28 02:17:39.000000000 +0900
+++ linux-hirofumi/fs/fat/inode.c	2012-12-28 02:17:39.000000000 +0900
@@ -1298,17 +1298,17 @@ int fat_fill_super(struct super_block *s
 	sbi->prev_free = FAT_START_ENT;
 	sb->s_maxbytes = 0xffffffff;
 
-	if (!sbi->fat_length && b->fat32_length) {
+	if (!sbi->fat_length && b->fat32.length) {
 		struct fat_boot_fsinfo *fsinfo;
 		struct buffer_head *fsinfo_bh;
 
 		/* Must be FAT32 */
 		sbi->fat_bits = 32;
-		sbi->fat_length = le32_to_cpu(b->fat32_length);
-		sbi->root_cluster = le32_to_cpu(b->root_cluster);
+		sbi->fat_length = le32_to_cpu(b->fat32.length);
+		sbi->root_cluster = le32_to_cpu(b->fat32.root_cluster);
 
 		/* MC - if info_sector is 0, don't multiply by 0 */
-		sbi->fsinfo_sector = le16_to_cpu(b->info_sector);
+		sbi->fsinfo_sector = le16_to_cpu(b->fat32.info_sector);
 		if (sbi->fsinfo_sector == 0)
 			sbi->fsinfo_sector = 1;
 
diff -puN include/uapi/linux/msdos_fs.h~fat-check-dirty-1 include/uapi/linux/msdos_fs.h
--- linux/include/uapi/linux/msdos_fs.h~fat-check-dirty-1	2012-12-28 02:17:39.000000000 +0900
+++ linux-hirofumi/include/uapi/linux/msdos_fs.h	2012-12-28 02:17:39.000000000 +0900
@@ -120,14 +120,34 @@ struct fat_boot_sector {
 	__le32	hidden;		/* hidden sectors (unused) */
 	__le32	total_sect;	/* number of sectors (if sectors == 0) */
 
-	/* The following fields are only used by FAT32 */
-	__le32	fat32_length;	/* sectors/FAT */
-	__le16	flags;		/* bit 8: fat mirroring, low 4: active fat */
-	__u8	version[2];	/* major, minor filesystem version */
-	__le32	root_cluster;	/* first cluster in root directory */
-	__le16	info_sector;	/* filesystem info sector */
-	__le16	backup_boot;	/* backup boot sector */
-	__le16	reserved2[6];	/* Unused */
+	union {
+		struct {
+			/*  Extended BPB Fields for FAT16 */
+			__u8	drive_number;	/* Physical drive number */
+			__u8	state;		/* undocumented, but used
+						   for mount state. */
+			/* other fiealds are not added here */
+		} fat16;
+
+		struct {
+			/* only used by FAT32 */
+			__le32	length;		/* sectors/FAT */
+			__le16	flags;		/* bit 8: fat mirroring,
+						   low 4: active fat */
+			__u8	version[2];	/* major, minor filesystem
+						   version */
+			__le32	root_cluster;	/* first cluster in
+						   root directory */
+			__le16	info_sector;	/* filesystem info sector */
+			__le16	backup_boot;	/* backup boot sector */
+			__le16	reserved2[6];	/* Unused */
+			/* Extended BPB Fields for FAT32 */
+			__u8	drive_number;   /* Physical drive number */
+			__u8    state;       	/* undocumented, but used
+						   for mount state. */
+			/* other fiealds are not added here */
+		} fat32;
+	};
 };
 
 struct fat_boot_fsinfo {
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
