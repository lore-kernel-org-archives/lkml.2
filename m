Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab0JROjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:39:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab0JROhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/22] GFS2: Remove upgrade mount option
Date: Mon, 18 Oct 2010 15:15:37 +0100
Message-Id: <1287411346-17855-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option has never done anything useful. Also at the same time
this cleans up the sb checks which are done at mount time. The
debug option will be accepted, but ignored in future. Since it
didn't do anything, there didn't seem much point in retaining it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 2990a0a..6f6ff8a 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -418,7 +418,6 @@ struct gfs2_args {
 	unsigned int ar_spectator:1;		/* Don't get a journal */
 	unsigned int ar_localflocks:1;		/* Let the VFS do flock|fcntl */
 	unsigned int ar_debug:1;		/* Oops on errors */
-	unsigned int ar_upgrade:1;		/* Upgrade ondisk format */
 	unsigned int ar_posix_acl:1;		/* Enable posix acls */
 	unsigned int ar_quota:2;		/* off/account/on */
 	unsigned int ar_suiddir:1;		/* suiddir support */
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 558bba4..5b11f37 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -38,14 +38,6 @@
 #define DO 0
 #define UNDO 1
 
-static const u32 gfs2_old_fs_formats[] = {
-        0
-};
-
-static const u32 gfs2_old_multihost_formats[] = {
-        0
-};
-
 /**
  * gfs2_tune_init - Fill a gfs2_tune structure with default values
  * @gt: tune
@@ -135,8 +127,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 static int gfs2_check_sb(struct gfs2_sbd *sdp, struct gfs2_sb_host *sb, int silent)
 {
-	unsigned int x;
-
 	if (sb->sb_magic != GFS2_MAGIC ||
 	    sb->sb_type != GFS2_METATYPE_SB) {
 		if (!silent)
@@ -150,55 +140,9 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, struct gfs2_sb_host *sb, int sile
 	    sb->sb_multihost_format == GFS2_FORMAT_MULTI)
 		return 0;
 
-	if (sb->sb_fs_format != GFS2_FORMAT_FS) {
-		for (x = 0; gfs2_old_fs_formats[x]; x++)
-			if (gfs2_old_fs_formats[x] == sb->sb_fs_format)
-				break;
-
-		if (!gfs2_old_fs_formats[x]) {
-			printk(KERN_WARNING
-			       "GFS2: code version (%u, %u) is incompatible "
-			       "with ondisk format (%u, %u)\n",
-			       GFS2_FORMAT_FS, GFS2_FORMAT_MULTI,
-			       sb->sb_fs_format, sb->sb_multihost_format);
-			printk(KERN_WARNING
-			       "GFS2: I don't know how to upgrade this FS\n");
-			return -EINVAL;
-		}
-	}
-
-	if (sb->sb_multihost_format != GFS2_FORMAT_MULTI) {
-		for (x = 0; gfs2_old_multihost_formats[x]; x++)
-			if (gfs2_old_multihost_formats[x] ==
-			    sb->sb_multihost_format)
-				break;
-
-		if (!gfs2_old_multihost_formats[x]) {
-			printk(KERN_WARNING
-			       "GFS2: code version (%u, %u) is incompatible "
-			       "with ondisk format (%u, %u)\n",
-			       GFS2_FORMAT_FS, GFS2_FORMAT_MULTI,
-			       sb->sb_fs_format, sb->sb_multihost_format);
-			printk(KERN_WARNING
-			       "GFS2: I don't know how to upgrade this FS\n");
-			return -EINVAL;
-		}
-	}
+	fs_warn(sdp, "Unknown on-disk format, unable to mount\n");
 
-	if (!sdp->sd_args.ar_upgrade) {
-		printk(KERN_WARNING
-		       "GFS2: code version (%u, %u) is incompatible "
-		       "with ondisk format (%u, %u)\n",
-		       GFS2_FORMAT_FS, GFS2_FORMAT_MULTI,
-		       sb->sb_fs_format, sb->sb_multihost_format);
-		printk(KERN_INFO
-		       "GFS2: Use the \"upgrade\" mount option to upgrade "
-		       "the FS\n");
-		printk(KERN_INFO "GFS2: See the manual for more details\n");
-		return -EINVAL;
-	}
-
-	return 0;
+	return -EINVAL;
 }
 
 static void end_bio_io_page(struct bio *bio, int error)
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index e78de8b..d85e0b7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -179,7 +179,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			args->ar_debug = 0;
 			break;
 		case Opt_upgrade:
-			args->ar_upgrade = 1;
+			/* Retained for backwards compat only */
 			break;
 		case Opt_acl:
 			args->ar_posix_acl = 1;
@@ -1235,8 +1235,6 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",localflocks");
 	if (args->ar_debug)
 		seq_printf(s, ",debug");
-	if (args->ar_upgrade)
-		seq_printf(s, ",upgrade");
 	if (args->ar_posix_acl)
 		seq_printf(s, ",acl");
 	if (args->ar_quota != GFS2_QUOTA_DEFAULT) {
-- 
1.7.1.1

