Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0KJKX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:23:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39090 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754069Ab0KJKXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:23:23 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19U3jQ0DIpU3suoZJuqlBWXhKNNkg868lnaJECjXQ
	12srnmq19IjRO8
From: Alexey Fisher <bug-track@fisher-privat.net>
To: <linux-kernel@vger.kernel.org>, joe@perches.com,
        hirofumi@mail.parknet.co.jp
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH 1/4] Convert fat_fs_error to use %pV
Date: Wed, 10 Nov 2010 11:23:09 +0100
Message-Id: <1289384592-4881-1-git-send-email-bug-track@fisher-privat.net>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289331805.28590.17.camel@Joe-Laptop>
References: <1289331805.28590.17.camel@Joe-Laptop>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- convert fat_fs_error to use %pV
- be consequent and use "supor_block *sb" instead of "supor_block *s"
- use devise name in each message.

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
---
 fs/fat/fat.h  |   10 +++++-----
 fs/fat/misc.c |   25 ++++++++++++++-----------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index d75a77f..4f99235 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -325,12 +325,12 @@ extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 /* fat/misc.c */
 extern void
-__fat_fs_error(struct super_block *s, int report, const char *fmt, ...)
+__fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4))) __cold;
-#define fat_fs_error(s, fmt, args...)		\
-	__fat_fs_error(s, 1, fmt , ## args)
-#define fat_fs_error_ratelimit(s, fmt, args...) \
-	__fat_fs_error(s, __ratelimit(&MSDOS_SB(s)->ratelimit), fmt , ## args)
+#define fat_fs_error(sb, fmt, args...)		\
+	__fat_fs_error(sb, 1, fmt , ## args)
+#define fat_fs_error_ratelimit(sb, fmt, args...) \
+	__fat_fs_error(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), fmt , ## args)
 extern int fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 970e682..958c5f9 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -20,26 +20,29 @@
  * In case the file system is remounted read-only, it can be made writable
  * again by remounting it.
  */
-void __fat_fs_error(struct super_block *s, int report, const char *fmt, ...)
+void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 {
-	struct fat_mount_options *opts = &MSDOS_SB(s)->options;
+	struct fat_mount_options *opts = &MSDOS_SB(sb)->options;
 	va_list args;
+	struct va_format vaf;
 
 	if (report) {
-		printk(KERN_ERR "FAT: Filesystem error (dev %s)\n", s->s_id);
-
-		printk(KERN_ERR "    ");
 		va_start(args, fmt);
-		vprintk(fmt, args);
+
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		printk(KERN_ERR "FAT-fs (%s): error, %pV\n", sb->s_id, &vaf);
+
 		va_end(args);
-		printk("\n");
 	}
 
 	if (opts->errors == FAT_ERRORS_PANIC)
-		panic("FAT: fs panic from previous error\n");
-	else if (opts->errors == FAT_ERRORS_RO && !(s->s_flags & MS_RDONLY)) {
-		s->s_flags |= MS_RDONLY;
-		printk(KERN_ERR "FAT: Filesystem has been set read-only\n");
+		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
+	else if (opts->errors == FAT_ERRORS_RO && !(sb->s_flags & MS_RDONLY)) {
+		sb->s_flags |= MS_RDONLY;
+		printk(KERN_ERR "FAT-fs (%s): Filesystem has been "
+				"set read-only\n", sb->s_id);
 	}
 }
 EXPORT_SYMBOL_GPL(__fat_fs_error);
-- 
1.7.1

