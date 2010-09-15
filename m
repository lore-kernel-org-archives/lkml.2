Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0IOM15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:27:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44478 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0IOM1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:27:55 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/8] writeback: Account for time spent congestion_waited
Date: Wed, 15 Sep 2010 13:27:45 +0100
Message-Id: <1284553671-31574-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284553671-31574-1-git-send-email-mel@csn.ul.ie>
References: <1284553671-31574-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is strong evidence to indicate a lot of time is being spent in
congestion_wait(), some of it unnecessarily. This patch adds a tracepoint
for congestion_wait to record when congestion_wait() was called, how long
the timeout was for and how long it actually slept.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/trace/events/writeback.h |   28 ++++++++++++++++++++++++++++
 mm/backing-dev.c                 |    5 +++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index f345f66..275d477 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -153,6 +153,34 @@ DEFINE_WBC_EVENT(wbc_balance_dirty_written);
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+DECLARE_EVENT_CLASS(writeback_congest_waited_template,
+
+	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
+
+	TP_ARGS(usec_timeout, usec_delayed),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	usec_timeout	)
+		__field(	unsigned int,	usec_delayed	)
+	),
+
+	TP_fast_assign(
+		__entry->usec_timeout	= usec_timeout;
+		__entry->usec_delayed	= usec_delayed;
+	),
+
+	TP_printk("usec_timeout=%u usec_delayed=%u",
+			__entry->usec_timeout,
+			__entry->usec_delayed)
+);
+
+DEFINE_EVENT(writeback_congest_waited_template, writeback_congestion_wait,
+
+	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
+
+	TP_ARGS(usec_timeout, usec_delayed)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index c2bf86f..e891794 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -762,12 +762,17 @@ EXPORT_SYMBOL(set_bdi_congested);
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
+	trace_writeback_congestion_wait(jiffies_to_usecs(timeout),
+					jiffies_to_usecs(jiffies - start));
+
 	return ret;
 }
 EXPORT_SYMBOL(congestion_wait);
-- 
1.7.1

