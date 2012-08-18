Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab2HRJnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:43:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2HRJnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:43:02 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/4] fat (exportfs): rebuild inode if ilookup() fails
Date: Sat, 18 Aug 2012 05:42:54 -0400
Message-Id: <1345282974-7603-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since the previous patch in this patch-set uses i_pos as the inode
number, we can use it to find the directory entry of the inode and
subsequently rebuild the inode if the cache lookups fail.

Since this involves  accessing the FAT media,it is better to do this
only if the 'nfs' mount option is enabled.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/nfs.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index ef4b5fa..44678e4 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -52,6 +52,24 @@ static struct inode *fat_nfs_get_inode(struct super_block *sb,
 		iput(inode);
 		inode = NULL;
 	}
+	if (inode == NULL && MSDOS_SB(sb)->options.nfs) {
+		struct buffer_head *bh = NULL;
+		struct msdos_dir_entry *de ;
+		loff_t i_pos = (loff_t)ino;
+		int bits = MSDOS_SB(sb)->dir_per_block_bits;
+		loff_t blocknr = i_pos >> bits;
+		bh = sb_bread(sb, blocknr);
+		if (!bh) {
+			fat_msg(sb, KERN_ERR,
+				"unable to read block(%llu) for building NFS inode",
+				(llu)blocknr);
+			return inode;
+		}
+		de = (struct msdos_dir_entry *)bh->b_data;
+		inode = fat_build_inode(sb, &de[i_pos&((1<<bits)-1)],
+					i_pos);
+		brelse(bh);
+	}
 
 	return inode;
 }
-- 
1.7.9.5

