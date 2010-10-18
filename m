Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0JROhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab0JROhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:45 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/22] GFS2: Remove localcaching mount option
Date: Mon, 18 Oct 2010 15:15:36 +0100
Message-Id: <1287411346-17855-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option defaulted to on for lock_nolock mounts and off
otherwise. The only function was to avoid the revalidation of
dentries. In the cluster case, that is entirely pointless and
liable to cause coherency problems.

The patch changes the revalidation to depend upon whether the
fs is a local or cluster fs (i.e. it follows the existing default
behaviour). I very much doubt anybody ever used this option as
there is no reason to. Even so we will continue to accept it
on the mount command line, but ignore it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dentry.c b/fs/gfs2/dentry.c
index bb7907b..6798755 100644
--- a/fs/gfs2/dentry.c
+++ b/fs/gfs2/dentry.c
@@ -49,7 +49,7 @@ static int gfs2_drevalidate(struct dentry *dentry, struct nameidata *nd)
 		ip = GFS2_I(inode);
 	}
 
-	if (sdp->sd_args.ar_localcaching)
+	if (sdp->sd_lockstruct.ls_ops->lm_mount == NULL)
 		goto valid;
 
 	had_lock = (gfs2_glock_is_locked_by_me(dip->i_gl) != NULL);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index c8a2db1..2990a0a 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -417,7 +417,6 @@ struct gfs2_args {
 	char ar_hostdata[GFS2_LOCKNAME_LEN];	/* Host specific data */
 	unsigned int ar_spectator:1;		/* Don't get a journal */
 	unsigned int ar_localflocks:1;		/* Let the VFS do flock|fcntl */
-	unsigned int ar_localcaching:1;		/* Local caching */
 	unsigned int ar_debug:1;		/* Oops on errors */
 	unsigned int ar_upgrade:1;		/* Upgrade ondisk format */
 	unsigned int ar_posix_acl:1;		/* Enable posix acls */
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 5b5c87d..558bba4 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1022,7 +1022,6 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 	if (!strcmp("lock_nolock", proto)) {
 		lm = &nolock_ops;
 		sdp->sd_args.ar_localflocks = 1;
-		sdp->sd_args.ar_localcaching = 1;
 #ifdef CONFIG_GFS2_FS_LOCKING_DLM
 	} else if (!strcmp("lock_dlm", proto)) {
 		lm = &gfs2_dlm_ops;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 06a4a7e..e78de8b 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -165,7 +165,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			args->ar_localflocks = 1;
 			break;
 		case Opt_localcaching:
-			args->ar_localcaching = 1;
+			/* Retained for backwards compat only */
 			break;
 		case Opt_debug:
 			if (args->ar_errors == GFS2_ERRORS_PANIC) {
@@ -1129,7 +1129,6 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 	/* Some flags must not be changed */
 	if (args_neq(&args, &sdp->sd_args, spectator) ||
 	    args_neq(&args, &sdp->sd_args, localflocks) ||
-	    args_neq(&args, &sdp->sd_args, localcaching) ||
 	    args_neq(&args, &sdp->sd_args, meta))
 		return -EINVAL;
 
@@ -1234,8 +1233,6 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",spectator");
 	if (args->ar_localflocks)
 		seq_printf(s, ",localflocks");
-	if (args->ar_localcaching)
-		seq_printf(s, ",localcaching");
 	if (args->ar_debug)
 		seq_printf(s, ",debug");
 	if (args->ar_upgrade)
-- 
1.7.1.1

