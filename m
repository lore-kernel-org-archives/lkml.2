Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab2KUNZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:25:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52314 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2KUNZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:25:05 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v5 6/8] fat (exportfs): rebuild inode if ilookup() fails
Date: Wed, 21 Nov 2012 22:24:54 +0900
Message-Id: <1353504294-5985-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

If the cache lookups fail,use the i_pos value to find the
directory entry of the inode and rebuild the inode.Since this
involves accessing the FAT media, do this only if the "nostale_ro" nfs
mount option is specified.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |    1 +
 fs/fat/inode.c |   15 +++++++++++++++
 fs/fat/nfs.c   |   40 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 40ceb79..bbad32c 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -75,6 +75,7 @@ struct msdos_sb_info {
 	unsigned long root_cluster;   /* first cluster of the root directory */
 	unsigned long fsinfo_sector;  /* sector number of FAT32 fsinfo */
 	struct mutex fat_lock;
+	struct mutex nfs_build_inode_lock;
 	struct mutex s_lock;
 	unsigned int prev_free;      /* previously allocated cluster number */
 	unsigned int free_clusters;  /* -1 if undefined */
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3127c0b..62e0ad5 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -444,12 +444,25 @@ static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
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
@@ -469,6 +482,7 @@ struct inode *fat_build_inode(struct super_block *sb,
 	fat_attach(inode, i_pos);
 	insert_inode_hash(inode);
 out:
+	fat_unlock_build_inode(MSDOS_SB(sb));
 	return inode;
 }
 
@@ -1188,6 +1202,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	sb->s_magic = MSDOS_SUPER_MAGIC;
 	sb->s_op = &fat_sops;
 	sb->s_export_op = &fat_export_ops;
+	mutex_init(&sbi->nfs_build_inode_lock);
 	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
 			     DEFAULT_RATELIMIT_BURST);
 
diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index 6ea1d41..898bef4 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -52,19 +52,49 @@ static struct inode *fat_dget(struct super_block *sb, int i_logstart)
 	return inode;
 }
 
+static struct inode *fat_ilookup(struct super_block *sb, u64 ino, loff_t i_pos)
+{
+	if (MSDOS_SB(sb)->options.nfs == FAT_NFS_NOSTALE_RO)
+		return fat_iget(sb, i_pos);
+	else {
+		if ((ino < MSDOS_ROOT_INO) || (ino == MSDOS_FSINFO_INO))
+			return NULL;
+		return ilookup(sb, ino);
+	}
+}
+
 static struct inode *__fat_nfs_get_inode(struct super_block *sb,
 				       u64 ino, u32 generation, loff_t i_pos)
 {
-	struct inode *inode;
-
-	if ((ino < MSDOS_ROOT_INO) || (ino == MSDOS_FSINFO_INO))
-		return NULL;
+	struct inode *inode = fat_ilookup(sb, ino, i_pos);
 
-	inode = ilookup(sb, ino);
 	if (inode && generation && (inode->i_generation != generation)) {
 		iput(inode);
 		inode = NULL;
 	}
+	if (inode == NULL && MSDOS_SB(sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
+		struct buffer_head *bh = NULL;
+		struct msdos_dir_entry *de ;
+		sector_t blocknr;
+		int offset;
+		fat_get_blknr_offset(MSDOS_SB(sb), i_pos, &blocknr, &offset);
+		bh = sb_bread(sb, blocknr);
+		if (!bh) {
+			fat_msg(sb, KERN_ERR,
+				"unable to read block(%llu) for building NFS inode",
+				(llu)blocknr);
+			return inode;
+		}
+		de = (struct msdos_dir_entry *)bh->b_data;
+		/* If a file is deleted on server and client is not updated
+		 * yet, we must not build the inode upon a lookup call.
+		 */
+		if (IS_FREE(de[offset].name))
+			inode = NULL;
+		else
+			inode = fat_build_inode(sb, &de[offset], i_pos);
+		brelse(bh);
+	}
 
 	return inode;
 }
-- 
1.7.9.5

