Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0KIS7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:59:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:39002 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752361Ab0KIS7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:59:17 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19voV5u/j9vfToKBFirDFFpsuXGVy3aJDUlrVWIhT
	3KMYUdo3XuLS2V
From: Alexey Fisher <bug-track@fisher-privat.net>
To: <linux-kernel@vger.kernel.org>, joe@perches.com,
        hirofumi@mail.parknet.co.jp
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH 1/2] Idd fat_msg() to unified kernel messages for FAT fs.
Date: Tue,  9 Nov 2010 19:58:44 +0100
Message-Id: <1289329124-14358-1-git-send-email-bug-track@fisher-privat.net>
X-Mailer: git-send-email 1.7.1
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net> <1289321718-6373-2-git-send-email-bug-track@fisher-privat.net>
In-Reply-To: <1289323541.1823.73.camel@Joe-Laptop>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add fat_msg() function to unify printkas. And use it
to report mounts and remounts.

new dmesg looks like this:
[ 6264.957109] FAT-fs (sdg1): Mounted. Opts: uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush
[ 6402.175028] FAT-fs (sdg1): re-mounted. Opts: (null)

v2 - add prototype to fat.h;
     úse %pV; rename prefix to level;

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
---
 fs/fat/fat.h   |    2 ++
 fs/fat/inode.c |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index d75a77f..c9e4553 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -345,4 +345,6 @@ void fat_cache_destroy(void);
 /* helper for printk */
 typedef unsigned long long	llu;
 
+void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
+
 #endif /* !_FAT_H */
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ad6998a..a4e8f26 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -37,6 +37,24 @@
 static int fat_default_codepage = CONFIG_FAT_DEFAULT_CODEPAGE;
 static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
 
+/** 
+ * fat_msg() - print preformated FAT specific messages.
+ * this function is copy of ext4_msg() from fs/ext4/super.c
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
 
 static int fat_add_cluster(struct inode *inode)
 {
@@ -552,6 +570,8 @@ static int fat_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	*flags |= MS_NODIRATIME | (sbi->options.isvfat ? 0 : MS_NOATIME);
+
+	fat_msg(sb, KERN_INFO, "re-mounted. Opts: %s", data);
 	return 0;
 }
 
@@ -1249,6 +1269,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	unsigned int media;
 	long error;
 	char buf[50];
+	char *orig_data = kstrdup(data, GFP_KERNEL);
 
 	/*
 	 * GFP_KERNEL is ok here, because while we do hold the
@@ -1502,6 +1523,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		goto out_fail;
 	}
 
+	fat_msg(sb, KERN_INFO, "Mounted. Opts: %s", orig_data);
+	kfree(orig_data);
+
 	return 0;
 
 out_invalid:
-- 
1.7.1

