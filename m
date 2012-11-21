Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2KUNYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:24:03 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2KUNYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:24:00 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v5 2/8] fat: move fat_i_pos_read to fat.h
Date: Wed, 21 Nov 2012 22:23:50 +0900
Message-Id: <1353504230-5845-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Move fat_i_pos_read to fat.h so that it can be called from nfs.c in the
subsequent patches to encode the file handle.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |   14 ++++++++++++++
 fs/fat/inode.c |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 873b795..be2943a 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -216,6 +216,20 @@ static inline sector_t fat_clus_to_blknr(struct msdos_sb_info *sbi, int clus)
 		+ sbi->data_start;
 }
 
+static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
+					struct inode *inode)
+{
+	loff_t i_pos;
+#if BITS_PER_LONG == 32
+	spin_lock(&sbi->inode_hash_lock);
+#endif
+	i_pos = MSDOS_I(inode)->i_pos;
+#if BITS_PER_LONG == 32
+	spin_unlock(&sbi->inode_hash_lock);
+#endif
+	return i_pos;
+}
+
 static inline void fat16_towchar(wchar_t *dst, const __u8 *src, size_t len)
 {
 #ifdef __BIG_ENDIAN
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 0ed6cd7..c1459c7 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -597,20 +597,6 @@ static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
-				    struct inode *inode)
-{
-	loff_t i_pos;
-#if BITS_PER_LONG == 32
-	spin_lock(&sbi->inode_hash_lock);
-#endif
-	i_pos = MSDOS_I(inode)->i_pos;
-#if BITS_PER_LONG == 32
-	spin_unlock(&sbi->inode_hash_lock);
-#endif
-	return i_pos;
-}
-
 static int __fat_write_inode(struct inode *inode, int wait)
 {
 	struct super_block *sb = inode->i_sb;
-- 
1.7.9.5

