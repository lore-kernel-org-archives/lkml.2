Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2IPMWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 08:22:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46740 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2IPMWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 08:22:22 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v3 1/5] fat: modify nfs mount option
Date: Sun, 16 Sep 2012 08:22:10 -0400
Message-Id: <1347798130-2626-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Provide two possible values 'full_unstable' and 'limited_stable' for
the -o nfs mount option.The first one allows all file operations but
does not reduce ESTALE errors on memory constrained systems. The second
one eliminates ESTALE errors but mounts the filesystem as read-only.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |    7 +++++--
 fs/fat/inode.c |   22 +++++++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 76f036f..94e5a07 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -23,6 +23,9 @@
 #define FAT_ERRORS_PANIC	2      /* panic on error */
 #define FAT_ERRORS_RO		3      /* remount r/o on error */
 
+#define FAT_NFS_FULL		1      /* Full but unstable support over NFS */
+#define FAT_NFS_LIMITED		2      /* Limited but stable support over NFS*/
+
 struct fat_mount_options {
 	uid_t fs_uid;
 	gid_t fs_gid;
@@ -33,6 +36,7 @@ struct fat_mount_options {
 	unsigned short shortname;  /* flags for shortname display/create rule */
 	unsigned char name_check;  /* r = relaxed, n = normal, s = strict */
 	unsigned char errors;	   /* On error: continue, panic, remount-ro */
+	unsigned char nfs;	  /* NFS support:full_unstable,limited_stable */
 	unsigned short allow_utime;/* permission for setting the [am]time */
 	unsigned quiet:1,          /* set = fake successful chmods and chowns */
 		 showexec:1,       /* set = only set x bit for com/exe/bat */
@@ -47,8 +51,7 @@ struct fat_mount_options {
 		 usefree:1,	   /* Use free_clusters for FAT32 */
 		 tz_utc:1,	   /* Filesystem timestamps are in UTC */
 		 rodir:1,	   /* allow ATTR_RO for directory */
-		 discard:1,	   /* Issue discard requests on deletions */
-		 nfs:1;		   /* Do extra work needed for NFS export */
+		 discard:1;	   /* Issue discard requests on deletions */
 };
 
 #define FAT_HASH_BITS	8
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 056297d..2689ef5 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -752,8 +752,6 @@ static int fat_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",usefree");
 	if (opts->quiet)
 		seq_puts(m, ",quiet");
-	if (opts->nfs)
-		seq_puts(m, ",nfs");
 	if (opts->showexec)
 		seq_puts(m, ",showexec");
 	if (opts->sys_immutable)
@@ -783,6 +781,10 @@ static int fat_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",errors=panic");
 	else
 		seq_puts(m, ",errors=remount-ro");
+	if (opts->nfs == FAT_NFS_LIMITED)
+		seq_puts(m, ",nfs=limited_stable");
+	else if (opts->nfs == FAT_NFS_FULL)
+		seq_puts(m, ",nfs=full_unstable");
 	if (opts->discard)
 		seq_puts(m, ",discard");
 
@@ -798,7 +800,8 @@ enum {
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
-	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_err,
+	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs_full,
+	Opt_nfs_limited, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -827,7 +830,8 @@ static const match_table_t fat_tokens = {
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_discard, "discard"},
-	{Opt_nfs, "nfs"},
+	{Opt_nfs_full, "nfs=full_unstable"},
+	{Opt_nfs_limited, "nfs=limited_stable"},
 	{Opt_obsolete, "conv=binary"},
 	{Opt_obsolete, "conv=text"},
 	{Opt_obsolete, "conv=auto"},
@@ -1011,6 +1015,13 @@ static int parse_options(struct super_block *sb, char *options, int is_vfat,
 		case Opt_err_ro:
 			opts->errors = FAT_ERRORS_RO;
 			break;
+		case Opt_nfs_full:
+			opts->nfs = FAT_NFS_FULL;
+			break;
+		case Opt_nfs_limited:
+			opts->nfs = FAT_NFS_LIMITED;
+			sb->s_flags |= MS_RDONLY;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
@@ -1069,9 +1080,6 @@ static int parse_options(struct super_block *sb, char *options, int is_vfat,
 		case Opt_discard:
 			opts->discard = 1;
 			break;
-		case Opt_nfs:
-			opts->nfs = 1;
-			break;
 
 		/* obsolete mount options */
 		case Opt_obsolete:
-- 
1.7.9.5

