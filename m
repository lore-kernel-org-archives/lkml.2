Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1LNPR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:17:27 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:46988 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755349Ab1LNPRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:17:25 -0500
From: Tao Ma <tm@tao.ma>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3] vmscan/trace: Add 'file' info to trace_mm_vmscan_lru_isolate.
Date: Wed, 14 Dec 2011 23:14:53 +0800
Message-Id: <1323875693-3504-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20111213164507.fbee477c.akpm@linux-foundation.org>
References: <20111213164507.fbee477c.akpm@linux-foundation.org>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.40.102 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In trace_mm_vmscan_lru_isolate, we don't output 'file'
information to the trace event and it is a bit inconvenient for the
user to get the real information(like pasted below).
mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0

'active' can be gotten by analyzing mode(Thanks go to Minchan and Mel),
So this patch adds 'file' to the trace event and it now looks like:
mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0 file=0

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 include/trace/events/vmscan.h |   22 ++++++++++++++--------
 mm/memcontrol.c               |    2 +-
 mm/vmscan.c                   |    2 +-
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index edc4b3d..f64560e 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -266,9 +266,10 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolate_template,
 		unsigned long nr_lumpy_taken,
 		unsigned long nr_lumpy_dirty,
 		unsigned long nr_lumpy_failed,
-		isolate_mode_t isolate_mode),
+		isolate_mode_t isolate_mode,
+		int file),
 
-	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode),
+	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode, file),
 
 	TP_STRUCT__entry(
 		__field(int, order)
@@ -279,6 +280,7 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolate_template,
 		__field(unsigned long, nr_lumpy_dirty)
 		__field(unsigned long, nr_lumpy_failed)
 		__field(isolate_mode_t, isolate_mode)
+		__field(int, file)
 	),
 
 	TP_fast_assign(
@@ -290,9 +292,10 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolate_template,
 		__entry->nr_lumpy_dirty = nr_lumpy_dirty;
 		__entry->nr_lumpy_failed = nr_lumpy_failed;
 		__entry->isolate_mode = isolate_mode;
+		__entry->file = file;
 	),
 
-	TP_printk("isolate_mode=%d order=%d nr_requested=%lu nr_scanned=%lu nr_taken=%lu contig_taken=%lu contig_dirty=%lu contig_failed=%lu",
+	TP_printk("isolate_mode=%d order=%d nr_requested=%lu nr_scanned=%lu nr_taken=%lu contig_taken=%lu contig_dirty=%lu contig_failed=%lu file=%d",
 		__entry->isolate_mode,
 		__entry->order,
 		__entry->nr_requested,
@@ -300,7 +303,8 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolate_template,
 		__entry->nr_taken,
 		__entry->nr_lumpy_taken,
 		__entry->nr_lumpy_dirty,
-		__entry->nr_lumpy_failed)
+		__entry->nr_lumpy_failed,
+		__entry->file)
 );
 
 DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_lru_isolate,
@@ -312,9 +316,10 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_lru_isolate,
 		unsigned long nr_lumpy_taken,
 		unsigned long nr_lumpy_dirty,
 		unsigned long nr_lumpy_failed,
-		isolate_mode_t isolate_mode),
+		isolate_mode_t isolate_mode,
+		int file),
 
-	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
+	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode, file)
 
 );
 
@@ -327,9 +332,10 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_memcg_isolate,
 		unsigned long nr_lumpy_taken,
 		unsigned long nr_lumpy_dirty,
 		unsigned long nr_lumpy_failed,
-		isolate_mode_t isolate_mode),
+		isolate_mode_t isolate_mode,
+		int file),
 
-	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
+	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode, file)
 
 );
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6aff93c..cd0082d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1249,7 +1249,7 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 	*scanned = scan;
 
 	trace_mm_vmscan_memcg_isolate(0, nr_to_scan, scan, nr_taken,
-				      0, 0, 0, mode);
+				      0, 0, 0, mode, file);
 
 	return nr_taken;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f54a05b..a444dc0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1221,7 +1221,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			nr_to_scan, scan,
 			nr_taken,
 			nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed,
-			mode);
+			mode, file);
 	return nr_taken;
 }
 
-- 
1.7.0.4

