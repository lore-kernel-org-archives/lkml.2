Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0EQM6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:58:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab0EQM6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:10 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/11] GFS2: Add some useful messages
Date: Mon, 17 May 2010 13:40:21 +0100
Message-Id: <1274100025-26629-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-7-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-4-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-5-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-6-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-7-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds a message to indicate when barriers have been
disabled due to a block device which doesn't support them. You could
already tell this via the mount options in /proc/mounts, but all the
other filesystems also log a message at the same time.

Also, the same mechanisms are used to indicate when the lock
demote interface has been used (only ever used for debugging)
which is a request from our support team.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/incore.h |    1 +
 fs/gfs2/log.c    |    1 +
 fs/gfs2/super.c  |    3 ++-
 fs/gfs2/sys.c    |    2 ++
 4 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 08dd657..b5d7363 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -459,6 +459,7 @@ enum {
 	SDF_SHUTDOWN		= 2,
 	SDF_NOBARRIERS		= 3,
 	SDF_NORECOVERY		= 4,
+	SDF_DEMOTE		= 5,
 };
 
 #define GFS2_FSNAME_LEN		256
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index d5959df..b593f0e 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -600,6 +600,7 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	if (buffer_eopnotsupp(bh)) {
 		clear_buffer_eopnotsupp(bh);
 		set_buffer_uptodate(bh);
+		fs_info(sdp, "barrier sync failed - disabling barriers\n");
 		set_bit(SDF_NOBARRIERS, &sdp->sd_flags);
 		lock_buffer(bh);
 skip_barrier:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 7a93e9f..4d1aad3 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1334,7 +1334,8 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	}
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
 		seq_printf(s, ",nobarrier");
-
+	if (test_bit(SDF_DEMOTE, &sdp->sd_flags))
+		seq_printf(s, ",demote_interface_used");
 	return 0;
 }
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 2ac845d..7afb62e 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -233,6 +233,8 @@ static ssize_t demote_rq_store(struct gfs2_sbd *sdp, const char *buf, size_t len
 	glops = gfs2_glops_list[gltype];
 	if (glops == NULL)
 		return -EINVAL;
+	if (test_and_set_bit(SDF_DEMOTE, &sdp->sd_flags))
+		fs_info(sdp, "demote interface used\n");
 	rv = gfs2_glock_get(sdp, glnum, glops, 0, &gl);
 	if (rv)
 		return rv;
-- 
1.6.2.5

