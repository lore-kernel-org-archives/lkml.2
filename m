Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab1EHSvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:51:19 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:58642 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab1EHSuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:21 -0400
Date: Sun, 8 May 2011 20:43:19 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/14] HPFS: Remove CR/LF conversion option
Message-ID: <alpine.DEB.2.00.1105082026020.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CR/LF conversion option

It is unused anyway. It was used on 2.2 kernels or so.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/dir.c     |    2 --
 fs/hpfs/hpfs_fn.h |   11 -----------
 fs/hpfs/inode.c   |    1 -
 fs/hpfs/name.c    |   33 ---------------------------------
 fs/hpfs/namei.c   |    3 ---
 fs/hpfs/super.c   |   32 +++++++-------------------------
 6 files changed, 7 insertions(+), 75 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/dir.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/dir.c	2011-05-05 01:01:55.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/dir.c	2011-05-05 01:02:47.000000000 +0200
@@ -250,8 +250,6 @@ struct dentry *hpfs_lookup(struct inode 
 	hpfs_result = hpfs_i(result);
 	if (!de->directory) hpfs_result->i_parent_dir = dir->i_ino;
 
-	hpfs_decide_conv(result, name, len);
-
 	if (de->has_acl || de->has_xtd_perm) if (!(dir->i_sb->s_flags & MS_RDONLY)) {
 		hpfs_error(result->i_sb, "ACLs or XPERM found. This is probably HPFS386. This driver doesn't support it now. Send me some info on these structures");
 		goto bail1;
Index: linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/hpfs_fn.h	2011-05-05 01:02:45.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h	2011-05-05 01:02:47.000000000 +0200
@@ -51,7 +51,6 @@ struct hpfs_inode_info {
 	unsigned i_disk_sec;	/* (files) minimalist cache of alloc info */
 	unsigned i_n_secs;	/* (files) minimalist cache of alloc info */
 	unsigned i_ea_size;	/* size of extended attributes */
-	unsigned i_conv : 2;	/* (files) crlf->newline hackery */
 	unsigned i_ea_mode : 1;	/* file's permission is stored in ea */
 	unsigned i_ea_uid : 1;	/* file's uid is stored in ea */
 	unsigned i_ea_gid : 1;	/* file's gid is stored in ea */
@@ -73,7 +72,6 @@ struct hpfs_sb_info {
 	uid_t sb_uid;			/* uid from mount options */
 	gid_t sb_gid;			/* gid from mount options */
 	umode_t sb_mode;		/* mode from mount options */
-	unsigned sb_conv : 2;		/* crlf->newline hackery */
 	unsigned sb_eas : 2;		/* eas: 0-ignore, 1-ro, 2-rw */
 	unsigned sb_err : 2;		/* on errs: 0-cont, 1-ro, 2-panic */
 	unsigned sb_chk : 2;		/* checks: 0-no, 1-normal, 2-strict */
@@ -90,14 +88,6 @@ struct hpfs_sb_info {
 	int sb_timeshift;
 };
 
-/*
- * conv= options
- */
-
-#define CONV_BINARY 0			/* no conversion */
-#define CONV_TEXT 1			/* crlf->newline */
-#define CONV_AUTO 2			/* decide based on file contents */
-
 /* Four 512-byte buffers and the 2k block obtained by concatenating them */
 
 struct quad_buffer_head {
@@ -298,7 +288,6 @@ int hpfs_compare_names(struct super_bloc
 		       const unsigned char *, unsigned, int);
 int hpfs_is_name_long(const unsigned char *, unsigned);
 void hpfs_adjust_length(const unsigned char *, unsigned *);
-void hpfs_decide_conv(struct inode *, const unsigned char *, unsigned);
 
 /* namei.c */
 
Index: linux-2.6.39-rc5-fast/fs/hpfs/inode.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/inode.c	2011-05-05 01:02:45.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/inode.c	2011-05-05 01:02:47.000000000 +0200
@@ -17,7 +17,6 @@ void hpfs_init_inode(struct inode *i)
 	i->i_uid = hpfs_sb(sb)->sb_uid;
 	i->i_gid = hpfs_sb(sb)->sb_gid;
 	i->i_mode = hpfs_sb(sb)->sb_mode;
-	hpfs_inode->i_conv = hpfs_sb(sb)->sb_conv;
 	i->i_size = -1;
 	i->i_blocks = -1;
 	
Index: linux-2.6.39-rc5-fast/fs/hpfs/name.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/name.c	2011-05-05 01:01:55.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/name.c	2011-05-05 01:02:47.000000000 +0200
@@ -8,39 +8,6 @@
 
 #include "hpfs_fn.h"
 
-static const char *text_postfix[]={
-".ASM", ".BAS", ".BAT", ".C", ".CC", ".CFG", ".CMD", ".CON", ".CPP", ".DEF",
-".DOC", ".DPR", ".ERX", ".H", ".HPP", ".HTM", ".HTML", ".JAVA", ".LOG", ".PAS",
-".RC", ".TEX", ".TXT", ".Y", ""};
-
-static const char *text_prefix[]={
-"AUTOEXEC.", "CHANGES", "COPYING", "CONFIG.", "CREDITS", "FAQ", "FILE_ID.DIZ",
-"MAKEFILE", "READ.ME", "README", "TERMCAP", ""};
-
-void hpfs_decide_conv(struct inode *inode, const unsigned char *name, unsigned len)
-{
-	struct hpfs_inode_info *hpfs_inode = hpfs_i(inode);
-	int i;
-	if (hpfs_inode->i_conv != CONV_AUTO) return;
-	for (i = 0; *text_postfix[i]; i++) {
-		int l = strlen(text_postfix[i]);
-		if (l <= len)
-			if (!hpfs_compare_names(inode->i_sb, text_postfix[i], l, name + len - l, l, 0))
-				goto text;
-	}
-	for (i = 0; *text_prefix[i]; i++) {
-		int l = strlen(text_prefix[i]);
-		if (l <= len)
-			if (!hpfs_compare_names(inode->i_sb, text_prefix[i], l, name, l, 0))
-				goto text;
-	}
-	hpfs_inode->i_conv = CONV_BINARY;
-	return;
-	text:
-	hpfs_inode->i_conv = CONV_TEXT;
-	return;
-}
-
 static inline int not_allowed_char(unsigned char c)
 {
 	return c<' ' || c=='"' || c=='*' || c=='/' || c==':' || c=='<' ||
Index: linux-2.6.39-rc5-fast/fs/hpfs/namei.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/namei.c	2011-05-05 01:02:45.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/namei.c	2011-05-05 01:02:47.000000000 +0200
@@ -151,7 +151,6 @@ static int hpfs_create(struct inode *dir
 	result->i_op = &hpfs_file_iops;
 	result->i_fop = &hpfs_file_ops;
 	result->i_nlink = 1;
-	hpfs_decide_conv(result, name, len);
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
 	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, dee.creation_date);
 	result->i_ctime.tv_nsec = 0;
@@ -616,8 +615,6 @@ static int hpfs_rename(struct inode *old
 		mark_buffer_dirty(bh);
 		brelse(bh);
 	}
-	hpfs_i(i)->i_conv = hpfs_sb(i->i_sb)->sb_conv;
-	hpfs_decide_conv(i, new_name, new_len);
 end1:
 	hpfs_unlock(i->i_sb);
 	return err;
Index: linux-2.6.39-rc5-fast/fs/hpfs/super.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/super.c	2011-05-05 01:02:45.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/super.c	2011-05-05 01:02:47.000000000 +0200
@@ -219,7 +219,6 @@ static void destroy_inodecache(void)
 
 enum {
 	Opt_help, Opt_uid, Opt_gid, Opt_umask, Opt_case_lower, Opt_case_asis,
-	Opt_conv_binary, Opt_conv_text, Opt_conv_auto,
 	Opt_check_none, Opt_check_normal, Opt_check_strict,
 	Opt_err_cont, Opt_err_ro, Opt_err_panic,
 	Opt_eas_no, Opt_eas_ro, Opt_eas_rw,
@@ -234,9 +233,6 @@ static const match_table_t tokens = {
 	{Opt_umask, "umask=%o"},
 	{Opt_case_lower, "case=lower"},
 	{Opt_case_asis, "case=asis"},
-	{Opt_conv_binary, "conv=binary"},
-	{Opt_conv_text, "conv=text"},
-	{Opt_conv_auto, "conv=auto"},
 	{Opt_check_none, "check=none"},
 	{Opt_check_normal, "check=normal"},
 	{Opt_check_strict, "check=strict"},
@@ -254,7 +250,7 @@ static const match_table_t tokens = {
 };
 
 static int parse_opts(char *opts, uid_t *uid, gid_t *gid, umode_t *umask,
-		      int *lowercase, int *conv, int *eas, int *chk, int *errs,
+		      int *lowercase, int *eas, int *chk, int *errs,
 		      int *chkdsk, int *timeshift)
 {
 	char *p;
@@ -296,15 +292,6 @@ static int parse_opts(char *opts, uid_t 
 		case Opt_case_asis:
 			*lowercase = 0;
 			break;
-		case Opt_conv_binary:
-			*conv = CONV_BINARY;
-			break;
-		case Opt_conv_text:
-			*conv = CONV_TEXT;
-			break;
-		case Opt_conv_auto:
-			*conv = CONV_AUTO;
-			break;
 		case Opt_check_none:
 			*chk = 0;
 			break;
@@ -371,9 +358,6 @@ HPFS filesystem options:\n\
       umask=xxx         set mode of files that don't have mode specified in eas\n\
       case=lower        lowercase all files\n\
       case=asis         do not lowercase files (default)\n\
-      conv=binary       do not convert CR/LF -> LF (default)\n\
-      conv=auto         convert only files with known text extensions\n\
-      conv=text         convert all files\n\
       check=none        no fs checks - kernel may crash on corrupted filesystem\n\
       check=normal      do some checks - it should not crash (default)\n\
       check=strict      do extra time-consuming checks, used for debugging\n\
@@ -395,7 +379,7 @@ static int hpfs_remount_fs(struct super_
 	uid_t uid;
 	gid_t gid;
 	umode_t umask;
-	int lowercase, conv, eas, chk, errs, chkdsk, timeshift;
+	int lowercase, eas, chk, errs, chkdsk, timeshift;
 	int o;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
 	char *new_opts = kstrdup(data, GFP_KERNEL);
@@ -406,11 +390,11 @@ static int hpfs_remount_fs(struct super_
 	lock_super(s);
 	uid = sbi->sb_uid; gid = sbi->sb_gid;
 	umask = 0777 & ~sbi->sb_mode;
-	lowercase = sbi->sb_lowercase; conv = sbi->sb_conv;
+	lowercase = sbi->sb_lowercase;
 	eas = sbi->sb_eas; chk = sbi->sb_chk; chkdsk = sbi->sb_chkdsk;
 	errs = sbi->sb_err; timeshift = sbi->sb_timeshift;
 
-	if (!(o = parse_opts(data, &uid, &gid, &umask, &lowercase, &conv,
+	if (!(o = parse_opts(data, &uid, &gid, &umask, &lowercase,
 	    &eas, &chk, &errs, &chkdsk, &timeshift))) {
 		printk("HPFS: bad mount options.\n");
 		goto out_err;
@@ -428,7 +412,7 @@ static int hpfs_remount_fs(struct super_
 
 	sbi->sb_uid = uid; sbi->sb_gid = gid;
 	sbi->sb_mode = 0777 & ~umask;
-	sbi->sb_lowercase = lowercase; sbi->sb_conv = conv;
+	sbi->sb_lowercase = lowercase;
 	sbi->sb_eas = eas; sbi->sb_chk = chk; sbi->sb_chkdsk = chkdsk;
 	sbi->sb_err = errs; sbi->sb_timeshift = timeshift;
 
@@ -472,7 +456,7 @@ static int hpfs_fill_super(struct super_
 	uid_t uid;
 	gid_t gid;
 	umode_t umask;
-	int lowercase, conv, eas, chk, errs, chkdsk, timeshift;
+	int lowercase, eas, chk, errs, chkdsk, timeshift;
 
 	dnode_secno root_dno;
 	struct hpfs_dirent *de = NULL;
@@ -498,14 +482,13 @@ static int hpfs_fill_super(struct super_
 	gid = current_gid();
 	umask = current_umask();
 	lowercase = 0;
-	conv = CONV_BINARY;
 	eas = 2;
 	chk = 1;
 	errs = 1;
 	chkdsk = 1;
 	timeshift = 0;
 
-	if (!(o = parse_opts(options, &uid, &gid, &umask, &lowercase, &conv,
+	if (!(o = parse_opts(options, &uid, &gid, &umask, &lowercase,
 	    &eas, &chk, &errs, &chkdsk, &timeshift))) {
 		printk("HPFS: bad mount options.\n");
 		goto bail0;
@@ -558,7 +541,6 @@ static int hpfs_fill_super(struct super_
 	sbi->sb_n_free = -1;
 	sbi->sb_n_free_dnodes = -1;
 	sbi->sb_lowercase = lowercase;
-	sbi->sb_conv = conv;
 	sbi->sb_eas = eas;
 	sbi->sb_chk = chk;
 	sbi->sb_chkdsk = chkdsk;
