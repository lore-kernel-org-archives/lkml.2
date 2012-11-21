Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2KUNYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:24:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35987 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2KUNYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:24:31 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v5 4/8] fat: introduce a helper fat_get_blknr_offset()
Date: Wed, 21 Nov 2012 22:24:21 +0900
Message-Id: <1353504261-5913-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Introduce helper function to get the block number and offset for a given
i_pos value. Use it in __fat_write_inode() now and later on in nfs.c

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |    7 +++++++
 fs/fat/inode.c |    9 +++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index e8047a1..1f1c9df 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -216,6 +216,13 @@ static inline sector_t fat_clus_to_blknr(struct msdos_sb_info *sbi, int clus)
 		+ sbi->data_start;
 }
 
+static inline void fat_get_blknr_offset(struct msdos_sb_info *sbi,
+				loff_t i_pos, sector_t *blknr, int *offset)
+{
+	*blknr = i_pos >> sbi->dir_per_block_bits;
+	*offset = i_pos & (sbi->dir_per_block - 1);
+}
+
 static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
 					struct inode *inode)
 {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index c1459c7..7a62be4 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -604,7 +604,8 @@ static int __fat_write_inode(struct inode *inode, int wait)
 	struct buffer_head *bh;
 	struct msdos_dir_entry *raw_entry;
 	loff_t i_pos;
-	int err;
+	sector_t blocknr;
+	int err, offset;
 
 	if (inode->i_ino == MSDOS_ROOT_INO)
 		return 0;
@@ -614,7 +615,8 @@ retry:
 	if (!i_pos)
 		return 0;
 
-	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
+	fat_get_blknr_offset(sbi, i_pos, &blocknr, &offset);
+	bh = sb_bread(sb, blocknr);
 	if (!bh) {
 		fat_msg(sb, KERN_ERR, "unable to read inode block "
 		       "for updating (i_pos %lld)", i_pos);
@@ -627,8 +629,7 @@ retry:
 		goto retry;
 	}
 
-	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))
-	    [i_pos & (sbi->dir_per_block - 1)];
+	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))[offset];
 	if (S_ISDIR(inode->i_mode))
 		raw_entry->size = 0;
 	else
-- 
1.7.9.5

