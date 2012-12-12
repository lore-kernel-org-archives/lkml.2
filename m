Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab2LLOiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:38:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59034 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2LLOiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:38:08 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct parent inode number
Date: Wed, 12 Dec 2012 23:37:57 +0900
Message-Id: <1355323077-5803-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Test Case:
[NFS Client]
ls -lR .

[NFS Server]
while [ 1 ]
do
echo 3 > /proc/sys/vm/drop_caches
done

Error on NFS Client: "No such file or directory"

When cache is dropped at the server, it results in lookup failure at the
NFS client due to non-connection with the parent. The default path is it
initiates a lookup by calculating the hash value for the name, even though
the hash values stored on the disk for "." and ".." is maintained as zero,
which results in failure from find_in_block due to not matching HASH values.
Fix up, by using the correct hashing values for these entries.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c  |    4 ++--
 fs/f2fs/hash.c |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index b4e24f3..e1f66df 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -540,13 +540,13 @@ int f2fs_make_empty(struct inode *inode, struct inode *parent)
 
 	de = &dentry_blk->dentry[0];
 	de->name_len = cpu_to_le16(1);
-	de->hash_code = 0;
+	de->hash_code = f2fs_dentry_hash(".", 1);
 	de->ino = cpu_to_le32(inode->i_ino);
 	memcpy(dentry_blk->filename[0], ".", 1);
 	set_de_type(de, inode);
 
 	de = &dentry_blk->dentry[1];
-	de->hash_code = 0;
+	de->hash_code = f2fs_dentry_hash("..", 2);
 	de->name_len = cpu_to_le16(2);
 	de->ino = cpu_to_le32(parent->i_ino);
 	memcpy(dentry_blk->filename[1], "..", 2);
diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
index a60f042..30ca4a2 100644
--- a/fs/f2fs/hash.c
+++ b/fs/f2fs/hash.c
@@ -76,6 +76,10 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int len)
 	const char *p;
 	__u32 in[8], buf[4];
 
+	/* dot and dotdot dentries should have zero-value hash code */
+	if (!memcmp(name, ".", 1) || !memcmp(name, "..", 2))
+		return 0;
+
 	/* Initialize the default seed for the hash checksum functions */
 	buf[0] = 0x67452301;
 	buf[1] = 0xefcdab89;
-- 
1.7.9.5

