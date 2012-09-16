Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2IPMWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 08:22:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59184 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2IPMWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 08:22:53 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v3 3/5] fat (exportfs): rebuild inode if ilookup() fails
Date: Sun, 16 Sep 2012 08:22:42 -0400
Message-Id: <1347798163-2697-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since the previous patch in this patch-set uses i_pos as the inode
number, we can use it to find the directory entry of the inode and
subsequently rebuild the inode if the cache lookups fail.

Since this involves  accessing the FAT media,it is better to do this
only if the 'nfs' mount option is enabled with limited_stable.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/nfs.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index ef4b5fa..3cf5412 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -52,6 +52,31 @@ static struct inode *fat_nfs_get_inode(struct super_block *sb,
 		iput(inode);
 		inode = NULL;
 	}
+	if (inode == NULL && MSDOS_SB(sb)->options.nfs == FAT_NFS_LIMITED) {
+		struct buffer_head *bh = NULL;
+		struct msdos_dir_entry *de ;
+		loff_t i_pos = (loff_t)ino;
+		int bits = MSDOS_SB(sb)->dir_per_block_bits;
+		loff_t blocknr = i_pos >> bits;
+		bh = sb_bread(sb, blocknr);
+		if (!bh) {
+			fat_msg(sb, KERN_ERR,
+				 "unable to read block(%llu) for building NFS inode",
+				(llu)blocknr);
+			return inode;
+		}
+		de = (struct msdos_dir_entry *)bh->b_data;
+		/* If a file is deleted on server and client is not updated
+		 * yet, we must not build the inode upon a lookup call.
+		 */
+		if (de[i_pos&((1<<bits)-1)].name[0] == DELETED_FLAG)
+
+			inode = NULL;
+		else
+			inode = fat_build_inode(sb, &de[i_pos&((1<<bits)-1)],
+					i_pos);
+		brelse(bh);
+	}
 
 	return inode;
 }
-- 
1.7.9.5

