Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0GZDDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 23:03:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45804 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0GZDDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 23:03:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/4] vmscan: convert direct reclaim tracepoint to DEFINE_TRACE
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
References: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
Message-Id: <20100726120224.2EF1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 26 Jul 2010 12:03:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman recently added some vmscan tracepoints. Unfortunately they are
covered only global reclaim. But we want to trace memcg reclaim too.

Thus, this patch convert them to DEFINE_TRACE macro. it help to reuse
tracepoint definition for other similar usage (i.e. memcg).
This patch have no functionally change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
 include/trace/events/vmscan.h |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index f2da66a..a601763 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -68,7 +68,7 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 		__entry->order)
 );
 
-TRACE_EVENT(mm_vmscan_direct_reclaim_begin,
+DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
 	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
 
@@ -92,7 +92,15 @@ TRACE_EVENT(mm_vmscan_direct_reclaim_begin,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
-TRACE_EVENT(mm_vmscan_direct_reclaim_end,
+DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
+
+	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
+
+	TP_ARGS(order, may_writepage, gfp_flags)
+);
+
+
+DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 
 	TP_PROTO(unsigned long nr_reclaimed),
 
@@ -109,6 +117,13 @@ TRACE_EVENT(mm_vmscan_direct_reclaim_end,
 	TP_printk("nr_reclaimed=%lu", __entry->nr_reclaimed)
 );
 
+DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
+
+	TP_PROTO(unsigned long nr_reclaimed),
+
+	TP_ARGS(nr_reclaimed)
+);
+
 TRACE_EVENT(mm_vmscan_lru_isolate,
 
 	TP_PROTO(int order,
-- 
1.6.5.2



