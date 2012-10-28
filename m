Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2J1Bxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 21:53:55 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46212 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2J1Bxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 21:53:53 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 5/5] fat: add mutex lock to fat_build_inode
Date: Sun, 28 Oct 2012 10:53:43 +0900
Message-Id: <1351389223-2628-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

fat_nfs_get_inode does not hold i_mutex of parent directory.So add
lock to fat_build_inode.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |    1 +
 fs/fat/inode.c |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 177e94e..811267c 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -75,6 +75,7 @@ struct msdos_sb_info {
 	unsigned long fsinfo_sector;  /* sector number of FAT32 fsinfo */
 	struct mutex fat_lock;
 	struct mutex s_lock;
+	struct mutex nfs_build_inode_lock;
 	unsigned int prev_free;      /* previously allocated cluster number */
 	unsigned int free_clusters;  /* -1 if undefined */
 	unsigned int free_clus_valid; /* is free_clusters valid? */
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 63e0883..a1650ef 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -443,12 +443,25 @@ static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 	return 0;
 }
 
+static inline void fat_lock_build_inode(struct msdos_sb_info *sbi)
+{
+	if (sbi->options.nfs == FAT_NFS_NOSTALE_RO)
+		mutex_lock(&sbi->nfs_build_inode_lock);
+}
+
+static inline void fat_unlock_build_inode(struct msdos_sb_info *sbi)
+{
+	if (sbi->options.nfs == FAT_NFS_NOSTALE_RO)
+		mutex_unlock(&sbi->nfs_build_inode_lock);
+}
+
 struct inode *fat_build_inode(struct super_block *sb,
 			struct msdos_dir_entry *de, loff_t i_pos)
 {
 	struct inode *inode;
 	int err;
 
+	fat_lock_build_inode(MSDOS_SB(sb));
 	inode = fat_iget(sb, i_pos);
 	if (inode)
 		goto out;
@@ -468,6 +481,7 @@ struct inode *fat_build_inode(struct super_block *sb,
 	fat_attach(inode, i_pos);
 	insert_inode_hash(inode);
 out:
+	fat_unlock_build_inode(MSDOS_SB(sb));
 	return inode;
 }
 
@@ -1173,6 +1187,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	sb->s_magic = MSDOS_SUPER_MAGIC;
 	sb->s_op = &fat_sops;
 	sb->s_export_op = &fat_export_ops;
+	mutex_init(&sbi->nfs_build_inode_lock);
 	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
 			     DEFAULT_RATELIMIT_BURST);
 
-- 
1.7.9.5

