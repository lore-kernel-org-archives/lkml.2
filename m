Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1GNIoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:44:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542Ab1GNIok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:44:40 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/3] GFS2: Fix race during filesystem mount
Date: Thu, 14 Jul 2011 09:21:55 +0100
Message-Id: <1310631716-18700-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1310631716-18700-1-git-send-email-swhiteho@redhat.com>
References: <1310631716-18700-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential race during filesystem mounting which has recently
been reported. It occurs when the userland gfs_controld is able to
process requests fast enough that it tries to use the sysfs interface
before the lock module is properly initialised. This is a pretty
unusual case as normally the lock module initialisation is very quick
compared with gfs_controld.

This patch adds an interruptible completion which is used to ensure that
userland will wait for the initialisation of the lock module to
complete.

There are other potential solutions to this problem, but this is the
quickest at this stage and has been tested both with and without
mount.gfs2 present in the system.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: David Booher <dbooher@adams.net>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 0a064e9..81206e7 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -17,6 +17,7 @@
 #include <linux/buffer_head.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist_bl.h>
+#include <linux/completion.h>
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
@@ -546,6 +547,7 @@ struct gfs2_sbd {
 	struct gfs2_glock *sd_trans_gl;
 	wait_queue_head_t sd_glock_wait;
 	atomic_t sd_glock_disposal;
+	struct completion sd_locking_init;
 
 	/* Inode Stuff */
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 8ac9ae1..2a77071 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -72,6 +72,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	init_waitqueue_head(&sdp->sd_glock_wait);
 	atomic_set(&sdp->sd_glock_disposal, 0);
+	init_completion(&sdp->sd_locking_init);
 	spin_lock_init(&sdp->sd_statfs_spin);
 
 	spin_lock_init(&sdp->sd_rindex_spin);
@@ -1017,11 +1018,13 @@ hostdata_error:
 		fsname++;
 	if (lm->lm_mount == NULL) {
 		fs_info(sdp, "Now mounting FS...\n");
+		complete(&sdp->sd_locking_init);
 		return 0;
 	}
 	ret = lm->lm_mount(sdp, fsname);
 	if (ret == 0)
 		fs_info(sdp, "Joined cluster. Now mounting FS...\n");
+	complete(&sdp->sd_locking_init);
 	return ret;
 }
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index e20eab3..443cabc 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -338,6 +338,9 @@ static ssize_t lkfirst_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	rv = sscanf(buf, "%u", &first);
 	if (rv != 1 || first > 1)
 		return -EINVAL;
+	rv = wait_for_completion_killable(&sdp->sd_locking_init);
+	if (rv)
+		return rv;
 	spin_lock(&sdp->sd_jindex_spin);
 	rv = -EBUSY;
 	if (test_bit(SDF_NOJOURNALID, &sdp->sd_flags) == 0)
@@ -414,7 +417,9 @@ static ssize_t jid_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	rv = sscanf(buf, "%d", &jid);
 	if (rv != 1)
 		return -EINVAL;
-
+	rv = wait_for_completion_killable(&sdp->sd_locking_init);
+	if (rv)
+		return rv;
 	spin_lock(&sdp->sd_jindex_spin);
 	rv = -EINVAL;
 	if (sdp->sd_lockstruct.ls_ops->lm_mount == NULL)
-- 
1.7.4

