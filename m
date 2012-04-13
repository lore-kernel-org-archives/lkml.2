Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2DMOTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:19:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:60837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab2DMOTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:19:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88726502"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v2 1/4] fat: introduce special inode for managing the FSINFO block
Date: Fri, 13 Apr 2012 17:19:52 +0300
Message-Id: <1334326795-2446-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch is just a preparation for further changes. It introduces a special
inode ('fsinfo_inode') in FAT file-system which we'll later use for managing
the FSINFO block. Note, this there is already one special inode ('fat_inode')
which is used for managing the FAT tables.

Introduce new 'MSDOS_FSINFO_INO' constant for this special inode. It is safe to
do because FAT file-system does not store inode numbers on the media but
generates them run-time.

I've also cleaned up the comment to existing 'MSDOS_ROOT_INO' constant, while
on it.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/fat/fat.h             |    1 +
 fs/fat/inode.c           |   12 ++++++++++++
 include/linux/msdos_fs.h |    3 ++-
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 66994f3..951d12b 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -82,6 +82,7 @@ struct msdos_sb_info {
 	int fatent_shift;
 	struct fatent_operations *fatent_ops;
 	struct inode *fat_inode;
+	struct inode *fsinfo_inode;
 
 	struct ratelimit_state ratelimit;
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 21687e3..91e9a8a 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -490,6 +490,7 @@ static void fat_put_super(struct super_block *sb)
 	if (sb->s_dirt)
 		fat_write_super(sb);
 
+	iput(sbi->fsinfo_inode);
 	iput(sbi->fat_inode);
 
 	unload_nls(sbi->nls_disk);
@@ -1244,6 +1245,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		   void (*setup)(struct super_block *))
 {
 	struct inode *root_inode = NULL, *fat_inode = NULL;
+	struct inode *fsinfo_inode = NULL;
 	struct buffer_head *bh;
 	struct fat_boot_sector *b;
 	struct msdos_sb_info *sbi;
@@ -1490,6 +1492,14 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		goto out_fail;
 	MSDOS_I(fat_inode)->i_pos = 0;
 	sbi->fat_inode = fat_inode;
+
+	fsinfo_inode = new_inode(sb);
+	if (!fsinfo_inode)
+		goto out_fail;
+	fsinfo_inode->i_ino = MSDOS_FSINFO_INO;
+	sbi->fsinfo_inode = fsinfo_inode;
+	insert_inode_hash(fsinfo_inode);
+
 	root_inode = new_inode(sb);
 	if (!root_inode)
 		goto out_fail;
@@ -1516,6 +1526,8 @@ out_invalid:
 		fat_msg(sb, KERN_INFO, "Can't find a valid FAT filesystem");
 
 out_fail:
+	if (fsinfo_inode)
+		iput(fsinfo_inode);
 	if (fat_inode)
 		iput(fat_inode);
 	unload_nls(sbi->nls_io);
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index 34066e6..11cc2ac 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -21,8 +21,9 @@
 #define CT_LE_W(v)	cpu_to_le16(v)
 #define CT_LE_L(v)	cpu_to_le32(v)
 
+#define MSDOS_ROOT_INO	 1	/* The root inode number */
+#define MSDOS_FSINFO_INO 2	/* Used for managing the FSINFO block */
 
-#define MSDOS_ROOT_INO	1	/* == MINIX_ROOT_INO */
 #define MSDOS_DIR_BITS	5	/* log2(sizeof(struct msdos_dir_entry)) */
 
 /* directory limit */
-- 
1.7.7.6

