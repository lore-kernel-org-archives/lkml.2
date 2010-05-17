Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0EQAjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:39:20 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42364 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0EQAjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:39:19 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] fat: ratelimit corruption report
References: <87k4r3cqgz.fsf@devron.myhome.or.jp>
Date: Mon, 17 May 2010 09:39:17 +0900
In-Reply-To: <87k4r3cqgz.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Mon, 17 May 2010 09:38:20 +0900")
Message-ID: <87fx1rcqfe.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/cache.c |   13 +++++++------
 fs/fat/fat.h   |   12 ++++++++++--
 fs/fat/inode.c |    2 ++
 fs/fat/misc.c  |   22 ++++++++++++----------
 4 files changed, 31 insertions(+), 18 deletions(-)

diff -puN fs/fat/cache.c~fat-error-ratelimit fs/fat/cache.c
--- linux-2.6/fs/fat/cache.c~fat-error-ratelimit	2010-05-17 03:58:03.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/cache.c	2010-05-17 03:58:03.000000000 +0900
@@ -242,9 +242,10 @@ int fat_get_cluster(struct inode *inode,
 	while (*fclus < cluster) {
 		/* prevent the infinite loop of cluster chain */
 		if (*fclus > limit) {
-			fat_fs_error(sb, "%s: detected the cluster chain loop"
-				     " (i_pos %lld)", __func__,
-				     MSDOS_I(inode)->i_pos);
+			fat_fs_error_ratelimit(sb,
+					"%s: detected the cluster chain loop"
+					" (i_pos %lld)", __func__,
+					MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
 		}
@@ -253,9 +254,9 @@ int fat_get_cluster(struct inode *inode,
 		if (nr < 0)
 			goto out;
 		else if (nr == FAT_ENT_FREE) {
-			fat_fs_error(sb, "%s: invalid cluster chain"
-				     " (i_pos %lld)", __func__,
-				     MSDOS_I(inode)->i_pos);
+			fat_fs_error_ratelimit(sb, "%s: invalid cluster chain"
+					       " (i_pos %lld)", __func__,
+					       MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
 		} else if (nr == FAT_ENT_EOF) {
diff -puN fs/fat/fat.h~fat-error-ratelimit fs/fat/fat.h
--- linux-2.6/fs/fat/fat.h~fat-error-ratelimit	2010-05-17 03:58:03.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fat.h	2010-05-17 03:58:03.000000000 +0900
@@ -6,6 +6,7 @@
 #include <linux/nls.h>
 #include <linux/fs.h>
 #include <linux/mutex.h>
+#include <linux/ratelimit.h>
 #include <linux/msdos_fs.h>
 
 /*
@@ -82,6 +83,8 @@ struct msdos_sb_info {
 	struct fatent_operations *fatent_ops;
 	struct inode *fat_inode;
 
+	struct ratelimit_state ratelimit;
+
 	spinlock_t inode_hash_lock;
 	struct hlist_head inode_hashtable[FAT_HASH_SIZE];
 };
@@ -322,8 +325,13 @@ extern int fat_fill_super(struct super_b
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 /* fat/misc.c */
-extern void fat_fs_error(struct super_block *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3))) __cold;
+extern void
+__fat_fs_error(struct super_block *s, int report, const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4))) __cold;
+#define fat_fs_error(s, fmt, args...)		\
+	__fat_fs_error(s, 1, fmt , ## args)
+#define fat_fs_error_ratelimit(s, fmt, args...) \
+	__fat_fs_error(s, __ratelimit(&MSDOS_SB(s)->ratelimit), fmt , ## args)
 extern int fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
diff -puN fs/fat/inode.c~fat-error-ratelimit fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat-error-ratelimit	2010-05-17 03:58:03.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2010-05-17 03:58:03.000000000 +0900
@@ -1250,6 +1250,8 @@ int fat_fill_super(struct super_block *s
 	sb->s_op = &fat_sops;
 	sb->s_export_op = &fat_export_ops;
 	sbi->dir_ops = fs_dir_inode_ops;
+	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
 
 	error = parse_options(data, isvfat, silent, &debug, &sbi->options);
 	if (error)
diff -puN fs/fat/misc.c~fat-error-ratelimit fs/fat/misc.c
--- linux-2.6/fs/fat/misc.c~fat-error-ratelimit	2010-05-17 03:58:03.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/misc.c	2010-05-17 03:59:05.000000000 +0900
@@ -20,27 +20,29 @@
  * In case the file system is remounted read-only, it can be made writable
  * again by remounting it.
  */
-void fat_fs_error(struct super_block *s, const char *fmt, ...)
+void __fat_fs_error(struct super_block *s, int report, const char *fmt, ...)
 {
 	struct fat_mount_options *opts = &MSDOS_SB(s)->options;
 	va_list args;
 
-	printk(KERN_ERR "FAT: Filesystem error (dev %s)\n", s->s_id);
+	if (report) {
+		printk(KERN_ERR "FAT: Filesystem error (dev %s)\n", s->s_id);
 
-	printk(KERN_ERR "    ");
-	va_start(args, fmt);
-	vprintk(fmt, args);
-	va_end(args);
-	printk("\n");
+		printk(KERN_ERR "    ");
+		va_start(args, fmt);
+		vprintk(fmt, args);
+		va_end(args);
+		printk("\n");
+	}
 
 	if (opts->errors == FAT_ERRORS_PANIC)
-		panic("    FAT fs panic from previous error\n");
+		panic("FAT: fs panic from previous error\n");
 	else if (opts->errors == FAT_ERRORS_RO && !(s->s_flags & MS_RDONLY)) {
 		s->s_flags |= MS_RDONLY;
-		printk(KERN_ERR "    File system has been set read-only\n");
+		printk(KERN_ERR "FAT: Filesystem has been set read-only\n");
 	}
 }
-EXPORT_SYMBOL_GPL(fat_fs_error);
+EXPORT_SYMBOL_GPL(__fat_fs_error);
 
 /* Flushes the number of free clusters on FAT32 */
 /* XXX: Need to write one per FSINFO block.  Currently only writes 1 */
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
