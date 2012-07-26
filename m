Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2GZVfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:35:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62132 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab2GZVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:31:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Nai Xia <nai.xia@gmail.com>, Johannes Weiner <jweiner@redhat.com>
Subject: [ 29/40] mm: vmscan: when reclaiming for compaction, ensure there are sufficient free pages available
Date: Thu, 26 Jul 2012 14:29:47 -0700
Message-Id: <20120726211413.746514438@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit fe4b1b244bdb96136855f2c694071cb09d140766 upstream.

Stable note: Not tracked on Bugzilla. THP and compaction was found to
	aggressively reclaim pages and stall systems under different
	situations that was addressed piecemeal over time. This patch
	addresses a problem where the fix regressed THP allocation
	success rates.

In commit e0887c19 ("vmscan: limit direct reclaim for higher order
allocations"), Rik noted that reclaim was too aggressive when THP was
enabled.  In his initial patch he used the number of free pages to decide
if reclaim should abort for compaction.  My feedback was that reclaim and
compaction should be using the same logic when deciding if reclaim should
be aborted.

Unfortunately, this had the effect of reducing THP success rates when the
workload included something like streaming reads that continually
allocated pages.  The window during which compaction could run and return
a THP was too small.

This patch combines Rik's two patches together.  compaction_suitable() is
still used to decide if reclaim should be aborted to allow compaction is
used.  However, it will also ensure that there is a reasonable buffer of
free pages available.  This improves upon the THP allocation success rates
but bounds the number of pages that are freed for compaction.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel<riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2075,6 +2075,42 @@ restart:
 	throttle_vm_writeout(sc->gfp_mask);
 }
 
+/* Returns true if compaction should go ahead for a high-order request */
+static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
+{
+	unsigned long balance_gap, watermark;
+	bool watermark_ok;
+
+	/* Do not consider compaction for orders reclaim is meant to satisfy */
+	if (sc->order <= PAGE_ALLOC_COSTLY_ORDER)
+		return false;
+
+	/*
+	 * Compaction takes time to run and there are potentially other
+	 * callers using the pages just freed. Continue reclaiming until
+	 * there is a buffer of free pages available to give compaction
+	 * a reasonable chance of completing and allocating the page
+	 */
+	balance_gap = min(low_wmark_pages(zone),
+		(zone->present_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
+			KSWAPD_ZONE_BALANCE_GAP_RATIO);
+	watermark = high_wmark_pages(zone) + balance_gap + (2UL << sc->order);
+	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0, 0);
+
+	/*
+	 * If compaction is deferred, reclaim up to a point where
+	 * compaction will have a chance of success when re-enabled
+	 */
+	if (compaction_deferred(zone))
+		return watermark_ok;
+
+	/* If compaction is not ready to start, keep reclaiming */
+	if (!compaction_suitable(zone, sc->order))
+		return false;
+
+	return watermark_ok;
+}
+
 /*
  * This is the direct reclaim path, for page-allocating processes.  We only
  * try to reclaim pages from zones which will satisfy the caller's allocation
@@ -2092,8 +2128,8 @@ restart:
  * scan then give up on it.
  *
  * This function returns true if a zone is being reclaimed for a costly
- * high-order allocation and compaction is either ready to begin or deferred.
- * This indicates to the caller that it should retry the allocation or fail.
+ * high-order allocation and compaction is ready to begin. This indicates to
+ * the caller that it should retry the allocation or fail.
  */
 static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
@@ -2127,9 +2163,7 @@ static bool shrink_zones(int priority, s
 				 * noticable problem, like transparent huge page
 				 * allocations.
 				 */
-				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
-					(compaction_suitable(zone, sc->order) ||
-					 compaction_deferred(zone))) {
+				if (compaction_ready(zone, sc)) {
 					should_abort_reclaim = true;
 					continue;
 				}


