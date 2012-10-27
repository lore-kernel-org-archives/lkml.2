Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2J0Oyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 10:54:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36347 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2J0Oyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 10:54:36 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/6] fat: remove parent_logstart check in fat_get_parent
Date: Sat, 27 Oct 2012 23:54:23 +0900
Message-Id: <1351349663-8134-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

The root directory inode is added to the directory hash table in
fat_attach when mounted with nfs option. Since root dentry never
expires until umount, fat_dget never fails to return the root inode
for subdirectories of root inode.i.e., parent_logstart cannot be zero.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/nfs.c |   51 ++++++++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index a4e6ac7..671a75d 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -274,36 +274,29 @@ struct dentry *fat_get_parent(struct dentry *child_dir)
 		parent_inode = fat_dget(sb, parent_logstart);
 		if (parent_inode || sbi->options.nfs != FAT_NFS_NOSTALE_RO)
 			goto out;
-		if (!parent_logstart)
-			/*logstart of dotdot entry is zero if
-			* if the directory's parent is root
-			*/
-			parent_inode = sb->s_root->d_inode;
-		else {
-			blknr = fat_clus_to_blknr(sbi, parent_logstart);
-			parent_bh = sb_bread(sb, blknr);
-			if (!parent_bh) {
-				fat_msg(sb, KERN_ERR,
-					"NFS:unable to read cluster of parent directory");
-				goto out;
-			}
-			de = (struct msdos_dir_entry *) parent_bh->b_data;
-			clus_to_match = fat_get_start(sbi, &de[0]);
-			search_clus = fat_get_start(sbi, &de[1]);
-			if (!search_clus)
-				search_clus = sbi->root_cluster;
-			brelse(parent_bh);
-			do {
-				parent_inode =  fat_traverse_cluster(sb,
-						search_clus, clus_to_match);
-				if (IS_ERR(parent_inode) || parent_inode)
-					break;
-				search_clus = fat_read_next_clus(sb,
-								search_clus);
-				if (search_clus < 0)
-					break;
-			} while (search_clus != FAT_ENT_EOF);
+		blknr = fat_clus_to_blknr(sbi, parent_logstart);
+		parent_bh = sb_bread(sb, blknr);
+		if (!parent_bh) {
+			fat_msg(sb, KERN_ERR,
+				"NFS:unable to read cluster of parent directory");
+			goto out;
 		}
+		de = (struct msdos_dir_entry *) parent_bh->b_data;
+		clus_to_match = fat_get_start(sbi, &de[0]);
+		search_clus = fat_get_start(sbi, &de[1]);
+		if (!search_clus)
+			search_clus = sbi->root_cluster;
+		brelse(parent_bh);
+		do {
+			parent_inode =  fat_traverse_cluster(sb,
+					search_clus, clus_to_match);
+			if (IS_ERR(parent_inode) || parent_inode)
+				break;
+			search_clus = fat_read_next_clus(sb,
+							search_clus);
+			if (search_clus < 0)
+				break;
+		} while (search_clus != FAT_ENT_EOF);
 	}
 out:
 	brelse(dotdot_bh);
-- 
1.7.9.5

