Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2J1Bxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 21:53:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36574 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2J1Bxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 21:53:37 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/5] fat: (exportfs) move code to rebuild directory-inode to separate function
Date: Sun, 28 Oct 2012 10:53:27 +0900
Message-Id: <1351389207-2592-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Move the logic to rebuild directory inode (when mounted with nostale_ro)
to new function fat_rebuild_parent

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/nfs.c |   71 ++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index 0abfacf..6e6b233 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -312,6 +312,45 @@ static int fat_read_next_clus(struct super_block *sb, int search_clus)
 }
 
 /*
+ * Rebuild the parent for a directory that is not connected
+ * to the filesystem root
+ */
+static
+struct inode *fat_rebuild_parent(struct super_block *sb, int parent_logstart)
+{
+	int search_clus, clus_to_match;
+	struct msdos_dir_entry *de;
+	struct inode *parent;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	sector_t blknr = fat_clus_to_blknr(sbi, parent_logstart);
+	struct buffer_head *parent_bh = sb_bread(sb, blknr);
+
+	if (!parent_bh) {
+		fat_msg(sb, KERN_ERR,
+			"NFS:unable to read cluster of parent directory");
+		return NULL;
+	}
+	de = (struct msdos_dir_entry *) parent_bh->b_data;
+	clus_to_match = fat_get_start(sbi, &de[0]);
+	search_clus = fat_get_start(sbi, &de[1]);
+	if (!search_clus)
+		search_clus = sbi->root_cluster;
+	brelse(parent_bh);
+	do {
+		parent =  fat_traverse_cluster(sb,
+					search_clus, clus_to_match);
+		if (IS_ERR(parent) || parent)
+			break;
+		search_clus = fat_read_next_clus(sb, search_clus);
+		if (search_clus < 0)
+			break;
+	} while (search_clus != FAT_ENT_EOF);
+
+	return parent;
+
+
+}
+/*
  * Find the parent for a directory that is not currently connected to
  * the filesystem root.
  *
@@ -320,44 +359,18 @@ static int fat_read_next_clus(struct super_block *sb, int search_clus)
 struct dentry *fat_get_parent(struct dentry *child_dir)
 {
 	struct super_block *sb = child_dir->d_sb;
-	struct buffer_head *dotdot_bh = NULL, *parent_bh = NULL;
+	struct buffer_head *dotdot_bh = NULL;
 	struct msdos_dir_entry *de;
 	struct inode *parent_inode = NULL;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	int parent_logstart;
-	int search_clus, clus_to_match;
-	sector_t blknr;
 
 	if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
 		parent_logstart = fat_get_start(sbi, de);
 		parent_inode = fat_dget(sb, parent_logstart);
-		if (parent_inode || sbi->options.nfs != FAT_NFS_NOSTALE_RO)
-			goto out;
-		blknr = fat_clus_to_blknr(sbi, parent_logstart);
-		parent_bh = sb_bread(sb, blknr);
-		if (!parent_bh) {
-			fat_msg(sb, KERN_ERR,
-				"NFS:unable to read cluster of parent directory");
-			goto out;
-		}
-		de = (struct msdos_dir_entry *) parent_bh->b_data;
-		clus_to_match = fat_get_start(sbi, &de[0]);
-		search_clus = fat_get_start(sbi, &de[1]);
-		if (!search_clus)
-			search_clus = sbi->root_cluster;
-		brelse(parent_bh);
-		do {
-			parent_inode =  fat_traverse_cluster(sb,
-					search_clus, clus_to_match);
-			if (IS_ERR(parent_inode) || parent_inode)
-				break;
-			search_clus = fat_read_next_clus(sb,
-							search_clus);
-			if (search_clus < 0)
-				break;
-		} while (search_clus != FAT_ENT_EOF);
+		if (!parent_inode && sbi->options.nfs == FAT_NFS_NOSTALE_RO)
+			parent_inode = fat_rebuild_parent(sb, parent_logstart);
 	}
-out:
 	brelse(dotdot_bh);
 
 	return d_obtain_alias(parent_inode);
-- 
1.7.9.5

