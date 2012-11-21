Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2KUNXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:23:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64912 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2KUNXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:23:45 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v5 1/8] fat: modify nfs mount option
Date: Wed, 21 Nov 2012 22:23:34 +0900
Message-Id: <1353504214-5811-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Provide two possible values 'stale_rw' and 'nostale_ro' for
the -o nfs mount option.The first one allows all file operations but
does not reduce ESTALE errors on memory constrained systems. The second
one eliminates ESTALE errors but mounts the filesystem as
read-only. Not specifying a value defaults to 'stale_rw'.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |    7 +++++--
 fs/fat/inode.c |   23 ++++++++++++++++-------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 12701a5..873b795 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -23,6 +23,9 @@
 #define FAT_ERRORS_PANIC	2      /* panic on error */
 #define FAT_ERRORS_RO		3      /* remount r/o on error */
 
+#define FAT_NFS_STALE_RW	1      /* NFS RW support, can cause ESTALE */
+#define FAT_NFS_NOSTALE_RO	2      /* NFS RO support, no ESTALE issue */
+
 struct fat_mount_options {
 	kuid_t fs_uid;
 	kgid_t fs_gid;
@@ -34,6 +37,7 @@ struct fat_mount_options {
 	unsigned short shortname;  /* flags for shortname display/create rule */
 	unsigned char name_check;  /* r = relaxed, n = normal, s = strict */
 	unsigned char errors;	   /* On error: continue, panic, remount-ro */
+	unsigned char nfs;	  /* NFS support: nostale_ro, stale_rw */
 	unsigned short allow_utime;/* permission for setting the [am]time */
 	unsigned quiet:1,          /* set = fake successful chmods and chowns */
 		 showexec:1,       /* set = only set x bit for com/exe/bat */
@@ -48,8 +52,7 @@ struct fat_mount_options {
 		 usefree:1,	   /* Use free_clusters for FAT32 */
 		 tz_set:1,	   /* Filesystem timestamps' offset set */
 		 rodir:1,	   /* allow ATTR_RO for directory */
-		 discard:1,	   /* Issue discard requests on deletions */
-		 nfs:1;		   /* Do extra work needed for NFS export */
+		 discard:1;	   /* Issue discard requests on deletions */
 };
 
 #define FAT_HASH_BITS	8
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3b733a7..0ed6cd7 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -755,8 +755,6 @@ static int fat_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",usefree");
 	if (opts->quiet)
 		seq_puts(m, ",quiet");
-	if (opts->nfs)
-		seq_puts(m, ",nfs");
 	if (opts->showexec)
 		seq_puts(m, ",showexec");
 	if (opts->sys_immutable)
@@ -790,6 +788,10 @@ static int fat_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",errors=panic");
 	else
 		seq_puts(m, ",errors=remount-ro");
+	if (opts->nfs == FAT_NFS_NOSTALE_RO)
+		seq_puts(m, ",nfs=nostale_ro");
+	else if (opts->nfs)
+		seq_puts(m, ",nfs=stale_rw");
 	if (opts->discard)
 		seq_puts(m, ",discard");
 
@@ -806,7 +808,7 @@ enum {
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
 	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_time_offset,
-	Opt_err,
+	Opt_nfs_stale_rw, Opt_nfs_nostale_ro, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -836,7 +838,9 @@ static const match_table_t fat_tokens = {
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_discard, "discard"},
-	{Opt_nfs, "nfs"},
+	{Opt_nfs_stale_rw, "nfs"},
+	{Opt_nfs_stale_rw, "nfs=stale_rw"},
+	{Opt_nfs_nostale_ro, "nfs=nostale_ro"},
 	{Opt_obsolete, "conv=binary"},
 	{Opt_obsolete, "conv=text"},
 	{Opt_obsolete, "conv=auto"},
@@ -1033,6 +1037,12 @@ static int parse_options(struct super_block *sb, char *options, int is_vfat,
 		case Opt_err_ro:
 			opts->errors = FAT_ERRORS_RO;
 			break;
+		case Opt_nfs_stale_rw:
+			opts->nfs = FAT_NFS_STALE_RW;
+			break;
+		case Opt_nfs_nostale_ro:
+			opts->nfs = FAT_NFS_NOSTALE_RO;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
@@ -1091,9 +1101,6 @@ static int parse_options(struct super_block *sb, char *options, int is_vfat,
 		case Opt_discard:
 			opts->discard = 1;
 			break;
-		case Opt_nfs:
-			opts->nfs = 1;
-			break;
 
 		/* obsolete mount options */
 		case Opt_obsolete:
@@ -1124,6 +1131,8 @@ out:
 		opts->allow_utime = ~opts->fs_dmask & (S_IWGRP | S_IWOTH);
 	if (opts->unicode_xlate)
 		opts->utf8 = 0;
+	if (opts->nfs == FAT_NFS_NOSTALE_RO)
+		sb->s_flags |= MS_RDONLY;
 
 	return 0;
 }
-- 
1.7.9.5

