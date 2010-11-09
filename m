Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0KIQzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:55:42 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51960 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753712Ab0KIQzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:55:39 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX18B5p8qPCsBQvKl7AxtNtqcNxt4aOFGM+tjUpEQzs
	RR2zM5Wf5uzj/z
From: Alexey Fisher <bug-track@fisher-privat.net>
To: <linux-kernel@vger.kernel.org>
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH 1/2] Introduce fat_msg() for unified kernel messages
Date: Tue,  9 Nov 2010 17:55:17 +0100
Message-Id: <1289321718-6373-2-git-send-email-bug-track@fisher-privat.net>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add fat_msg() function to unify printkas. And use it
to report mounts and remounts.

new dmesg looks like this:
[ 6264.957109] FAT-fs (sdg1): Mounted. Opts: uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush
[ 6402.175028] FAT-fs (sdg1): re-mounted. Opts: (null)

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
---
 fs/fat/inode.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ad6998a..4699173 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -37,6 +37,20 @@
 static int fat_default_codepage = CONFIG_FAT_DEFAULT_CODEPAGE;
 static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
 
+/* unify messages.
+ * this function is copy of ext4_msg() from fs/ext4/super.c
+ */
+void fat_msg(struct super_block *sb, const char *prefix,
+			const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	printk("%sFAT-fs (%s): ", prefix, sb->s_id);
+	vprintk(fmt, args);
+	printk("\n");
+	va_end(args);
+}
 
 static int fat_add_cluster(struct inode *inode)
 {
@@ -552,6 +566,8 @@ static int fat_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	*flags |= MS_NODIRATIME | (sbi->options.isvfat ? 0 : MS_NOATIME);
+
+	fat_msg(sb, KERN_INFO, "re-mounted. Opts: %s", data);
 	return 0;
 }
 
@@ -1249,6 +1265,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	unsigned int media;
 	long error;
 	char buf[50];
+	char *orig_data = kstrdup(data, GFP_KERNEL);
 
 	/*
 	 * GFP_KERNEL is ok here, because while we do hold the
@@ -1502,6 +1519,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		goto out_fail;
 	}
 
+	fat_msg(sb, KERN_INFO, "Mounted. Opts: %s", orig_data);
+	kfree(orig_data);
+
 	return 0;
 
 out_invalid:
-- 
1.7.1

