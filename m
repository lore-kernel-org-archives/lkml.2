Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab2CUEhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:37:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60488 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2CUEhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:37:09 -0400
MIME-Version: 1.0
Date: Wed, 21 Mar 2012 12:37:08 +0800
Message-ID: <CAN628AFiRxGEYHBbahYgnUpr-M3cKmh4T=copKif=jesCSBYkA@mail.gmail.com>
Subject: Re: [PATCH] VMUFAT filesystem [4/4]
From: Adrian McMenamin <lkmladrian@gmail.com>
To: viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Cc: Linux-sh <linux-sh@vger.kernel.org>,
        Adrian McMenamin <adrianmcmenamin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/fs/vmufat/vmufat.h b/fs/vmufat/vmufat.h
new file mode 100644
index 0000000..8d4b714
--- /dev/null
+++ b/fs/vmufat/vmufat.h
@@ -0,0 +1,115 @@
+/* Header file for VMUFAT filesystem */
+#ifndef _VMUFAT_H_
+#define _VMUFAT_H_
+
+/* maximum length of file name */
+#define VMUFAT_NAMELEN			12
+
+/* GNU utils won't list files with inode num 0 */
+#define VMUFAT_ZEROBLOCK		0x10000
+#define VMU_BLK_SZ			512
+#define	VMU_BLK_SZ16			256
+
+/* file allocation table markers */
+#define VMUFAT_FILE_END			0xFFFA
+#define VMUFAT_UNALLOCATED		0xFFFC
+#define VMUFAT_ERROR			0xFFFF
+
+/* parameters for possible VMU volume sizes */
+#define VMUFAT_MIN_BLK			0x04
+#define VMUFAT_MAX_BLK			0x10000
+#define VMUFAT_START_ALLOC		199
+
+/* specifcations for directory entries */
+#define VMU_DIR_RECORD_LEN		0x20
+#define VMU_DIR_RECORD_LEN16		0x10
+#define VMU_DIR_ENTRIES_PER_BLOCK	0x10
+#define VMUFAT_NAME_OFFSET		0x04
+#define VMUFAT_FIRSTBLOCK_OFFSET16	0x01
+#define VMUFAT_START_OFFSET16		0x01
+#define VMUFAT_SIZE_OFFSET16		0x0C
+#define VMUFAT_HEADER_OFFSET16		0x0D
+
+/* File types used in directory */
+#define VMU_GAME			0xCC
+#define VMU_DATA			0x33
+
+/* filesystem locations marked in the root block */
+#define VMU_LOCATION_FAT		0x23
+#define VMU_LOCATION_FATLEN		0x24
+#define VMU_LOCATION_DIR		0x25
+#define VMU_LOCATION_DIRLEN		0x26
+#define VMU_LOCATION_USRLEN		0x28 /* reports false figure */
+
+/* date offsets */
+#define VMUFAT_SB_DATEOFFSET		0x30
+#define VMUFAT_FILE_DATEOFFSET		0x10
+
+#define EXEC				0111
+#define NOCOPY				0xFF
+#define CANCOPY				0x00
+
+u16 vmufat_get_fat(struct super_block *sb, long block);
+void vmufat_save_bcd(struct inode *in, char *bh, int index_to_dir);
+struct inode *vmufat_get_inode(struct super_block *sb, long ino);
+int vmufat_list_blocks(struct inode *in);
+
+enum vmufat_date {
+	VMUFAT_DIR_CENT	=		0x10,
+	VMUFAT_DIR_YEAR,
+	VMUFAT_DIR_MONTH,
+	VMUFAT_DIR_DAY,
+	VMUFAT_DIR_HOUR,
+	VMUFAT_DIR_MIN,
+	VMUFAT_DIR_SEC,
+	VMUFAT_DIR_DOW
+};
+
+/* constants for BCD conversion */
+#define SECONDS_PER_DAY			86400
+#define DAYS_PER_YEAR			365
+#define SECONDS_PER_HOUR		3600
+#define HOURS_PER_DAY			24
+#define SIXTY_MINS_OR_SECS		60
+#define FEB28				59
+
+struct memcard {
+	unsigned int sb_bnum;
+	unsigned int fat_bnum;
+	unsigned int fat_len;
+	unsigned int dir_bnum;
+	unsigned int dir_len;
+	unsigned int numblocks;
+	struct semaphore vmu_sem;
+};
+
+struct vmufat_block_list {
+	struct list_head b_list;
+	int bno;
+};
+
+struct vmufat_inode {
+	struct vmufat_block_list blocks;
+	unsigned int nblcks;
+	struct inode vfs_inode;
+};
+
+static inline struct vmufat_inode *VMUFAT_I(struct inode *in)
+{
+	return container_of(in, struct vmufat_inode, vfs_inode);
+}
+
+struct vmufat_file_info {
+	u8 ftype;
+	int fblk;
+	char fname[VMUFAT_NAMELEN];
+};
+
+static inline struct buffer_head *vmufat_sb_bread(struct super_block *sb,
+	sector_t block)
+{
+	if (!sb)
+		return NULL;
+	return sb_bread(sb, block);
+}
+#endif
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 2d4beab..f285512 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -29,6 +29,7 @@
 #define JFFS2_SUPER_MAGIC	0x72b6
 #define ANON_INODE_FS_MAGIC	0x09041934
 #define PSTOREFS_MAGIC		0x6165676C
+#define VMUFAT_MAGIC		0x55555555	/* opening bytes of root */

 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
-- 
1.7.5.4
