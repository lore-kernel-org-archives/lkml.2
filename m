Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0KJKXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:23:30 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39290 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754069Ab0KJKX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:23:27 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19LBM8l4HxL4CXkgLtvgImW8DrFAQlBd+NyVvWQHs
	8PuPn0cP0Rf4Sy
From: Alexey Fisher <bug-track@fisher-privat.net>
To: <linux-kernel@vger.kernel.org>, joe@perches.com,
        hirofumi@mail.parknet.co.jp
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH 2/4] Add fat_msg() function for preformated FAT messages
Date: Wed, 10 Nov 2010 11:23:10 +0100
Message-Id: <1289384592-4881-2-git-send-email-bug-track@fisher-privat.net>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289331805.28590.17.camel@Joe-Laptop>
References: <1289331805.28590.17.camel@Joe-Laptop>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add fat_msg() to replace not cosequent used printk() in fs/fat/*
New message format should be as fallow:
FAT-fs (sda1): some thing happened.

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
---
 fs/fat/fat.h  |    1 +
 fs/fat/misc.c |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 4f99235..803eade 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -331,6 +331,7 @@ __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 	__fat_fs_error(sb, 1, fmt , ## args)
 #define fat_fs_error_ratelimit(sb, fmt, args...) \
 	__fat_fs_error(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), fmt , ## args)
+void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
 extern int fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 958c5f9..3aac24b 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -47,6 +47,25 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(__fat_fs_error);
 
+/**
+ * fat_msg() - print preformated FAT specific messages. Every thing what is
+ * not fat_fs_error() should be fat_msg().
+ */
+void __attribute__ ((format (printf, 3, 4)))
+fat_msg(struct super_block *sb, const char *level, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk("%sFAT-fs (%s): %pV\n", level, sb->s_id, &vaf);
+
+	va_end(args);
+}
+
 /* Flushes the number of free clusters on FAT32 */
 /* XXX: Need to write one per FSINFO block.  Currently only writes 1 */
 int fat_clusters_flush(struct super_block *sb)
-- 
1.7.1

