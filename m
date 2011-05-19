Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab1ESJKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab1ESJKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:22 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/32] GFS2: Add an AIL writeback tracepoint
Date: Thu, 19 May 2011 09:47:09 +0100
Message-Id: <1305794847-3291-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a tracepoint for monitoring writeback of the AIL.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 03e0041..ad1f188 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -144,6 +144,7 @@ void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc)
 	struct list_head *head = &sdp->sd_ail1_list;
 	struct gfs2_ail *ai;
 
+	trace_gfs2_ail_flush(sdp, wbc, 1);
 	spin_lock(&sdp->sd_ail_lock);
 	list_for_each_entry_reverse(ai, head, ai_list) {
 		if (wbc->nr_to_write <= 0)
@@ -151,6 +152,7 @@ void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc)
 		gfs2_ail1_start_one(sdp, wbc, ai); /* This may drop ail lock */
 	}
 	spin_unlock(&sdp->sd_ail_lock);
+	trace_gfs2_ail_flush(sdp, wbc, 0);
 }
 
 /**
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 9133d0a..5d07609 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -10,6 +10,7 @@
 #include <linux/buffer_head.h>
 #include <linux/dlmconstants.h>
 #include <linux/gfs2_ondisk.h>
+#include <linux/writeback.h>
 #include "incore.h"
 #include "glock.h"
 
@@ -320,6 +321,33 @@ TRACE_EVENT(gfs2_log_blocks,
 		  MINOR(__entry->dev), __entry->blocks)
 );
 
+/* Writing back the AIL */
+TRACE_EVENT(gfs2_ail_flush,
+
+	TP_PROTO(const struct gfs2_sbd *sdp, const struct writeback_control *wbc, int start),
+
+	TP_ARGS(sdp, wbc, start),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	int, start			)
+		__field(	int, sync_mode			)
+		__field(	long, nr_to_write		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= sdp->sd_vfs->s_dev;
+		__entry->start		= start;
+		__entry->sync_mode	= wbc->sync_mode;
+		__entry->nr_to_write	= wbc->nr_to_write;
+	),
+
+	TP_printk("%u,%u ail flush %s %s %ld", MAJOR(__entry->dev),
+		  MINOR(__entry->dev), __entry->start ? "start" : "end",
+		  __entry->sync_mode == WB_SYNC_ALL ? "all" : "none",
+		  __entry->nr_to_write)
+);
+
 /* Section 3 - bmap
  *
  * Objectives:
-- 
1.7.4

