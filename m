Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068Ab2EQMs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:48:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760912Ab2EQMs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:27 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/24] GFS2: Drop "pull" argument from log_write_header()
Date: Thu, 17 May 2012 13:23:08 +0100
Message-Id: <1337257411-3173-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "pull" argument to log_write_header() is only used
for debug purposes and it is not really needed any more. There
are other tests for this particular problem, so I think we can
dispose of it in order to simplify the code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 4752ead..d886a17 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -32,8 +32,6 @@
 #include "dir.h"
 #include "trace_gfs2.h"
 
-#define PULL 1
-
 /**
  * gfs2_struct2blk - compute stuff
  * @sdp: the filesystem
@@ -580,7 +578,7 @@ static void gfs2_ordered_wait(struct gfs2_sbd *sdp)
  * Returns: the initialized log buffer descriptor
  */
 
-static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
+static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 {
 	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
 	struct buffer_head *bh;
@@ -628,8 +626,6 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 
 	if (sdp->sd_log_tail != tail)
 		log_pull_tail(sdp, tail);
-	else
-		gfs2_assert_withdraw(sdp, !pull);
 
 	sdp->sd_log_idle = (tail == sdp->sd_log_flush_head);
 	gfs2_log_incr_head(sdp);
@@ -680,13 +676,13 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	lops_before_commit(sdp);
 
 	if (sdp->sd_log_head != sdp->sd_log_flush_head) {
-		log_write_header(sdp, 0, 0);
+		log_write_header(sdp, 0);
 	} else if (sdp->sd_log_tail != current_tail(sdp) && !sdp->sd_log_idle){
 		gfs2_log_lock(sdp);
 		atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
 		trace_gfs2_log_blocks(sdp, -1);
 		gfs2_log_unlock(sdp);
-		log_write_header(sdp, 0, PULL);
+		log_write_header(sdp, 0);
 	}
 	lops_after_commit(sdp, ai);
 
@@ -798,8 +794,7 @@ void gfs2_log_shutdown(struct gfs2_sbd *sdp)
 	sdp->sd_log_flush_head = sdp->sd_log_head;
 	sdp->sd_log_flush_wrapped = 0;
 
-	log_write_header(sdp, GFS2_LOG_HEAD_UNMOUNT,
-			 (sdp->sd_log_tail == current_tail(sdp)) ? 0 : PULL);
+	log_write_header(sdp, GFS2_LOG_HEAD_UNMOUNT);
 
 	gfs2_assert_warn(sdp, atomic_read(&sdp->sd_log_blks_free) == sdp->sd_jdesc->jd_blocks);
 	gfs2_assert_warn(sdp, sdp->sd_log_head == sdp->sd_log_tail);
-- 
1.7.4

