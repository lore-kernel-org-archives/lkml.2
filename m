Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1EWNB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:01:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab1EWNBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:01:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/2] GFS2: Wait properly when flushing the ail list
Date: Mon, 23 May 2011 13:39:19 +0100
Message-Id: <1306154359-7046-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1306154359-7046-1-git-send-email-swhiteho@redhat.com>
References: <1306154359-7046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ail flush code has always relied upon log flushing to prevent
it from spinning needlessly. This fixes it to wait on the last
I/O request submitted (we don't need to wait for all of it)
instead of either spinning with io_schedule or sleeping.

As a result cpu usage of gfs2_logd is much reduced with certain
workloads.

Reported-by: Abhijith Das <adas@redhat.com>
Tested-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index cec26c0..903115f 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -228,6 +228,27 @@ static int gfs2_ail1_empty(struct gfs2_sbd *sdp)
 	return ret;
 }
 
+static void gfs2_ail1_wait(struct gfs2_sbd *sdp)
+{
+	struct gfs2_ail *ai;
+	struct gfs2_bufdata *bd;
+	struct buffer_head *bh;
+
+	spin_lock(&sdp->sd_ail_lock);
+	list_for_each_entry_reverse(ai, &sdp->sd_ail1_list, ai_list) {
+		list_for_each_entry(bd, &ai->ai_ail1_list, bd_ail_st_list) {
+			bh = bd->bd_bh;
+			if (!buffer_locked(bh))
+				continue;
+			get_bh(bh);
+			spin_unlock(&sdp->sd_ail_lock);
+			wait_on_buffer(bh);
+			brelse(bh);
+			return;
+		}
+	}
+	spin_unlock(&sdp->sd_ail_lock);
+}
 
 /**
  * gfs2_ail2_empty_one - Check whether or not a trans in the AIL has been synced
@@ -878,9 +899,9 @@ void gfs2_meta_syncfs(struct gfs2_sbd *sdp)
 	gfs2_log_flush(sdp, NULL);
 	for (;;) {
 		gfs2_ail1_start(sdp);
+		gfs2_ail1_wait(sdp);
 		if (gfs2_ail1_empty(sdp))
 			break;
-		msleep(10);
 	}
 }
 
@@ -920,12 +941,14 @@ int gfs2_logd(void *data)
 
 		if (gfs2_ail_flush_reqd(sdp)) {
 			gfs2_ail1_start(sdp);
-			io_schedule();
+			gfs2_ail1_wait(sdp);
 			gfs2_ail1_empty(sdp);
 			gfs2_log_flush(sdp, NULL);
 		}
 
-		wake_up(&sdp->sd_log_waitq);
+		if (!gfs2_ail_flush_reqd(sdp))
+			wake_up(&sdp->sd_log_waitq);
+
 		t = gfs2_tune_get(sdp, gt_logd_secs) * HZ;
 		if (freezing(current))
 			refrigerator();
-- 
1.7.4

