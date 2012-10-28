Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2J1BxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 21:53:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36574 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2J1BxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 21:53:22 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/5] fat: move fat_i_pos_read to fat.h
Date: Sun, 28 Oct 2012 10:53:11 +0900
Message-Id: <1351389191-2556-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Originally, fat_i_pos_read was a static inline function in inode.c.
The static keyword was removed so that it could be accessed from other
files. However it is better to make it a static inline function in fat.h
as suggested by Ogawa.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |   14 ++++++++++++++
 fs/fat/inode.c |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 65f9149..177e94e 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -222,6 +222,20 @@ static inline void fat_get_blknr_offset(struct msdos_sb_info *sbi,
 	*offset = i_pos & (sbi->dir_per_block - 1);
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
index 34253dc..63e0883 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -595,20 +595,6 @@ static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
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

