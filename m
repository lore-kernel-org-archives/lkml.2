Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0GZDGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 23:06:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45924 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0GZDGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 23:06:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/4] memcg: add mm_vmscan_memcg_isolate tracepoint
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
References: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
Message-Id: <20100726120519.2EFA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 26 Jul 2010 12:06:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memcg also need to trace page isolation information as global reclaim.
This patch does it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/trace/events/vmscan.h |   15 +++++++++++++++
 mm/memcontrol.c               |    6 ++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index b97a3db..776f92b 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -213,6 +213,21 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_lru_isolate,
 
 );
 
+DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_memcg_isolate,
+
+	TP_PROTO(int order,
+		unsigned long nr_requested,
+		unsigned long nr_scanned,
+		unsigned long nr_taken,
+		unsigned long nr_lumpy_taken,
+		unsigned long nr_lumpy_dirty,
+		unsigned long nr_lumpy_failed,
+		int isolate_mode),
+
+	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
+
+);
+
 TRACE_EVENT(mm_vmscan_writepage,
 
 	TP_PROTO(struct page *page,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2b648ce..2600776 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -52,6 +52,8 @@
 
 #include <asm/uaccess.h>
 
+#include <trace/events/vmscan.h>
+
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 struct mem_cgroup *root_mem_cgroup __read_mostly;
@@ -1011,6 +1013,10 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 	}
 
 	*scanned = scan;
+
+	trace_mm_vmscan_memcg_isolate(0, nr_to_scan, scan, nr_taken,
+				      0, 0, 0, mode);
+
 	return nr_taken;
 }
 
-- 
1.6.5.2



