Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0HZPOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:14:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44996 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab0HZPOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:14:18 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] writeback: Account for time spent congestion_waited
Date: Thu, 26 Aug 2010 16:14:14 +0100
Message-Id: <1282835656-5638-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is strong evidence to indicate a lot of time is being spent in
congestion_wait(), some of it unnecessarily. This patch adds a
tracepoint for congestion_wait to record when congestion_wait() occurred
and how long was spent.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/trace/events/writeback.h |   17 +++++++++++++++++
 mm/backing-dev.c                 |    4 ++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index f345f66..e3bee61 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -153,6 +153,23 @@ DEFINE_WBC_EVENT(wbc_balance_dirty_written);
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+TRACE_EVENT(writeback_congest_waited,
+
+	TP_PROTO(unsigned int usec_delayed),
+
+	TP_ARGS(usec_delayed),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	usec_delayed	)
+	),
+
+	TP_fast_assign(
+		__entry->usec_delayed	= usec_delayed;
+	),
+
+	TP_printk("usec_delayed=%u", __entry->usec_delayed)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index eaa4a5b..7ae33e2 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -759,12 +759,16 @@ EXPORT_SYMBOL(set_bdi_congested);
 long congestion_wait(int sync, long timeout)
 {
 	long ret;
+	unsigned long start = jiffies;
 	DEFINE_WAIT(wait);
 	wait_queue_head_t *wqh = &congestion_wqh[sync];
 
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = io_schedule_timeout(timeout);
 	finish_wait(wqh, &wait);
+
+	trace_writeback_congest_waited(jiffies_to_usecs(jiffies - start));
+
 	return ret;
 }
 EXPORT_SYMBOL(congestion_wait);
-- 
1.7.1

