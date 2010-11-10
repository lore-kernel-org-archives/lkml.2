Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0KJXq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:46:26 -0500
Received: from mail.perches.com ([173.55.12.10]:4947 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab0KJXqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:46:25 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 2/6] fs/affs: Add printf format/argument verification and fix fallout
Date: Wed, 10 Nov 2010 15:46:14 -0800
Message-Id: <61b367bd6aa6fc5664bce431f91f25f5cb2489f5.1289432524.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289432524.git.joe@perches.com>
References: <cover.1289432524.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __attribute__((format... to affs_error and affs_warning.
Change formats to match types of arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/affs/affs.h |    2 ++
 fs/affs/file.c |   14 ++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index a8cbdeb..c3f746b 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -138,7 +138,9 @@ extern void	affs_fix_checksum(struct super_block *sb, struct buffer_head *bh);
 extern void	secs_to_datestamp(time_t secs, struct affs_date *ds);
 extern mode_t	prot_to_mode(u32 prot);
 extern void	mode_to_prot(struct inode *inode);
+__attribute__ ((format(printf, 3, 4)))
 extern void	affs_error(struct super_block *sb, const char *function, const char *fmt, ...);
+__attribute__ ((format(printf, 3, 4)))
 extern void	affs_warning(struct super_block *sb, const char *function, const char *fmt, ...);
 extern int	affs_check_name(const unsigned char *name, int len);
 extern int	affs_copy_name(unsigned char *bstr, struct dentry *dentry);
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 0a90dcd..4c82c40 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -355,7 +355,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 
 		/* store new block */
 		if (bh_result->b_blocknr)
-			affs_warning(sb, "get_block", "block already set (%x)", bh_result->b_blocknr);
+			affs_warning(sb, "get_block", "block already set (%lx)",
+				     (unsigned long)bh_result->b_blocknr);
 		AFFS_BLOCK(sb, ext_bh, block) = cpu_to_be32(blocknr);
 		AFFS_HEAD(ext_bh)->block_count = cpu_to_be32(block + 1);
 		affs_adjust_checksum(ext_bh, blocknr - bh_result->b_blocknr + 1);
@@ -377,7 +378,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 	return 0;
 
 err_big:
-	affs_error(inode->i_sb,"get_block","strange block request %d", block);
+	affs_error(inode->i_sb,"get_block","strange block request %d",
+		   (int)block);
 	return -EIO;
 err_ext:
 	// unlock cache
@@ -848,8 +850,8 @@ affs_truncate(struct inode *inode)
 	// lock cache
 	ext_bh = affs_get_extblock(inode, ext);
 	if (IS_ERR(ext_bh)) {
-		affs_warning(sb, "truncate", "unexpected read error for ext block %u (%d)",
-			     ext, PTR_ERR(ext_bh));
+		affs_warning(sb, "truncate", "unexpected read error for ext block %u (%ld)",
+			     (unsigned int)ext, PTR_ERR(ext_bh));
 		return;
 	}
 	if (AFFS_I(inode)->i_lc) {
@@ -895,8 +897,8 @@ affs_truncate(struct inode *inode)
 			struct buffer_head *bh = affs_bread_ino(inode, last_blk, 0);
 			u32 tmp;
 			if (IS_ERR(bh)) {
-				affs_warning(sb, "truncate", "unexpected read error for last block %u (%d)",
-					     ext, PTR_ERR(bh));
+				affs_warning(sb, "truncate", "unexpected read error for last block %u (%ld)",
+					     (unsigned int)ext, PTR_ERR(bh));
 				return;
 			}
 			tmp = be32_to_cpu(AFFS_DATA_HEAD(bh)->next);
-- 
1.7.3.1.g432b3.dirty

