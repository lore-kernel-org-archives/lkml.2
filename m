Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1FBHBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:01:45 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:27315 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932956Ab1FBHBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:01:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYDAAky5015LCoegWdsb2JhbABThEmhZxUBARYmJbZukGKBK4NsgQoEmDKHdw
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com
Subject: [PATCH 01/12] vmscan: add shrink_slab tracepoints
Date: Thu,  2 Jun 2011 17:00:56 +1000
Message-Id: <1306998067-27659-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1306998067-27659-1-git-send-email-david@fromorbit.com>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Іt is impossible to understand what the shrinkers are actually doing
without instrumenting the code, so add a some tracepoints to allow
insight to be gained.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/trace/events/vmscan.h |   67 +++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |    6 +++-
 2 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index ea422aa..c798cd7 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -310,6 +310,73 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
+TRACE_EVENT(mm_shrink_slab_start,
+	TP_PROTO(struct shrinker *shr, struct shrink_control *sc,
+		unsigned long pgs_scanned, unsigned long lru_pgs,
+		unsigned long cache_items, unsigned long long delta,
+		unsigned long total_scan),
+
+	TP_ARGS(shr, sc, pgs_scanned, lru_pgs, cache_items, delta, total_scan),
+
+	TP_STRUCT__entry(
+		__field(struct shrinker *, shr)
+		__field(long, shr_nr)
+		__field(gfp_t, gfp_flags)
+		__field(unsigned long, pgs_scanned)
+		__field(unsigned long, lru_pgs)
+		__field(unsigned long, cache_items)
+		__field(unsigned long long, delta)
+		__field(unsigned long, total_scan)
+	),
+
+	TP_fast_assign(
+		__entry->shr = shr;
+		__entry->shr_nr = shr->nr;
+		__entry->gfp_flags = sc->gfp_mask;
+		__entry->pgs_scanned = pgs_scanned;
+		__entry->lru_pgs = lru_pgs;
+		__entry->cache_items = cache_items;
+		__entry->delta = delta;
+		__entry->total_scan = total_scan;
+	),
+
+	TP_printk("shrinker %p: nr %ld gfp_flags %s pgs_scanned %ld lru_pgs %ld cache items %ld delta %lld total_scan %ld",
+		__entry->shr,
+		__entry->shr_nr,
+		show_gfp_flags(__entry->gfp_flags),
+		__entry->pgs_scanned,
+		__entry->lru_pgs,
+		__entry->cache_items,
+		__entry->delta,
+		__entry->total_scan)
+);
+
+TRACE_EVENT(mm_shrink_slab_end,
+	TP_PROTO(struct shrinker *shr, int shrinker_ret,
+		unsigned long total_scan),
+
+	TP_ARGS(shr, shrinker_ret, total_scan),
+
+	TP_STRUCT__entry(
+		__field(struct shrinker *, shr)
+		__field(long, shr_nr)
+		__field(int, shrinker_ret)
+		__field(unsigned long, total_scan)
+	),
+
+	TP_fast_assign(
+		__entry->shr = shr;
+		__entry->shr_nr = shr->nr;
+		__entry->shrinker_ret = shrinker_ret;
+		__entry->total_scan = total_scan;
+	),
+
+	TP_printk("shrinker %p: nr %ld total_scan %ld return val %d",
+		__entry->shr,
+		__entry->shr_nr,
+		__entry->total_scan,
+		__entry->shrinker_ret)
+);
 
 #endif /* _TRACE_VMSCAN_H */
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index faa0a08..48e3fbd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -250,6 +250,7 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		unsigned long long delta;
 		unsigned long total_scan;
 		unsigned long max_pass;
+		int shrink_ret = 0;
 
 		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
@@ -274,9 +275,11 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		total_scan = shrinker->nr;
 		shrinker->nr = 0;
 
+		trace_mm_shrink_slab_start(shrinker, shrink, nr_pages_scanned,
+					lru_pages, max_pass, delta, total_scan);
+
 		while (total_scan >= SHRINK_BATCH) {
 			long this_scan = SHRINK_BATCH;
-			int shrink_ret;
 			int nr_before;
 
 			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
@@ -293,6 +296,7 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		}
 
 		shrinker->nr += total_scan;
+		trace_mm_shrink_slab_end(shrinker, shrink_ret, total_scan);
 	}
 	up_read(&shrinker_rwsem);
 out:
-- 
1.7.5.1

