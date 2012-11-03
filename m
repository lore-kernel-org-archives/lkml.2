Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2KCF2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 01:28:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59264 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2KCF2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 01:28:08 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 3/3] fat: warn when discard request fails other than EOPNOTSUPP
Date: Sat,  3 Nov 2012 14:27:58 +0900
Message-Id: <1351920478-3326-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAT also warn user then the discard request fails
as ext4(http://patchwork.ozlabs.org/patch/192669/)

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/fatent.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 260705c..fc1f407 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -583,12 +583,15 @@ int fat_free_clusters(struct inode *inode, int cluster)
 			 */
 			if (cluster != fatent.entry + 1) {
 				int nr_clus = fatent.entry - first_cl + 1;
-
-				sb_issue_discard(sb,
-					fat_clus_to_blknr(sbi, first_cl),
-					nr_clus * sbi->sec_per_clus,
-					GFP_NOFS, 0);
-
+				sector_t sblk = fat_clus_to_blknr(sbi, first_cl);
+				sector_t nrblk = nr_clus * sbi->sec_per_clus;
+
+				err = sb_issue_discard(sb,
+						sblk, nrblk, GFP_NOFS, 0);
+				if (err && err != -EOPNOTSUPP)
+					fat_msg(sb, KERN_WARNING, "discard request for"
+							" block:%llu count:%llu failed"
+							" with %d", sblk, nrblk, err);
 				first_cl = cluster;
 			}
 		}
-- 
1.7.9.5

