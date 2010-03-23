Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab0CWM0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:26:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53476 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab0CWMZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:25:55 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 11/11] Do not compact within a preferred zone after a compaction failure
Date: Tue, 23 Mar 2010 12:25:46 +0000
Message-Id: <1269347146-7461-12-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fragmentation index may indicate that a failure it due to external
fragmentation, a compaction run complete and an allocation failure still
fail. There are two obvious reasons as to why

  o Page migration cannot move all pages so fragmentation remains
  o A suitable page may exist but watermarks are not met

In the event of compaction and allocation failure, this patch prevents
compaction happening for a short interval. It's only recorded on the
preferred zone but that should be enough coverage. This could have been
implemented similar to the zonelist_cache but the increased size of the
zonelist did not appear to be justified.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
---
 include/linux/compaction.h |   35 +++++++++++++++++++++++++++++++++++
 include/linux/mmzone.h     |    7 +++++++
 mm/page_alloc.c            |    5 ++++-
 3 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index b851428..bc7059d 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -14,6 +14,32 @@ extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask);
+
+/* defer_compaction - Do not compact within a zone until a given time */
+static inline void defer_compaction(struct zone *zone, unsigned long resume)
+{
+	/*
+	 * This function is called when compaction fails to result in a page
+	 * allocation success. This is somewhat unsatisfactory as the failure
+	 * to compact has nothing to do with time and everything to do with
+	 * the requested order, the number of free pages and watermarks. How
+	 * to wait on that is more unclear, but the answer would apply to
+	 * other areas where the VM waits based on time.
+	 */
+	zone->compact_resume = resume;
+}
+
+static inline int compaction_deferred(struct zone *zone)
+{
+	/* init once if necessary */
+	if (unlikely(!zone->compact_resume)) {
+		zone->compact_resume = jiffies;
+		return 0;
+	}
+
+	return time_before(jiffies, zone->compact_resume);
+}
+
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask)
@@ -21,6 +47,15 @@ static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 	return COMPACT_INCOMPLETE;
 }
 
+static inline void defer_compaction(struct zone *zone, unsigned long resume)
+{
+}
+
+static inline int compaction_deferred(struct zone *zone)
+{
+	return 1;
+}
+
 #endif /* CONFIG_COMPACTION */
 
 #if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index cf9e458..bde879b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -321,6 +321,13 @@ struct zone {
 	unsigned long		*pageblock_flags;
 #endif /* CONFIG_SPARSEMEM */
 
+#ifdef CONFIG_COMPACTION
+	/*
+	 * If a compaction fails, do not try compaction again until
+	 * jiffies is after the value of compact_resume
+	 */
+	unsigned long		compact_resume;
+#endif
 
 	ZONE_PADDING(_pad1_)
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e301108..f481df2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1767,7 +1767,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	cond_resched();
 
 	/* Try memory compaction for high-order allocations before reclaim */
-	if (order) {
+	if (order && !compaction_deferred(preferred_zone)) {
 		*did_some_progress = try_to_compact_pages(zonelist,
 						order, gfp_mask, nodemask);
 		if (*did_some_progress != COMPACT_INCOMPLETE) {
@@ -1787,6 +1787,9 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 			 */
 			count_vm_event(COMPACTFAIL);
 
+			/* On failure, avoid compaction for a short time. */
+			defer_compaction(preferred_zone, jiffies + HZ/50);
+
 			cond_resched();
 		}
 	}
-- 
1.6.5

