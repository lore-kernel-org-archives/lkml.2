Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2G3Rq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:46:28 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38307 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2G3RcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:32:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [ 15/41] vmscan: limit direct reclaim for higher order allocations
Date: Mon, 30 Jul 2012 10:31:14 -0700
Message-Id: <20120730172902.497265875@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120730172901.306897424@linuxfoundation.org>
References: <20120730172901.306897424@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@redhat.com>

commit e0887c19b2daa140f20ca8104bdc5740f39dbb86 upstream.

Stable note: Not tracked on Bugzilla. THP and compaction was found to
	aggressively reclaim pages and stall systems under different
	situations that was addressed piecemeal over time.  Paragraph
	3 of this changelog is the motivation for this patch.

When suffering from memory fragmentation due to unfreeable pages, THP page
faults will repeatedly try to compact memory.  Due to the unfreeable
pages, compaction fails.

Needless to say, at that point page reclaim also fails to create free
contiguous 2MB areas.  However, that doesn't stop the current code from
trying, over and over again, and freeing a minimum of 4MB (2UL <<
sc->order pages) at every single invocation.

This resulted in my 12GB system having 2-3GB free memory, a corresponding
amount of used swap and very sluggish response times.

This can be avoided by having the direct reclaim code not reclaim from
zones that already have plenty of free memory available for compaction.

If compaction still fails due to unmovable memory, doing additional
reclaim will only hurt the system, not help.

[jweiner@redhat.com: change comment to explain the order check]
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2059,6 +2059,22 @@ static void shrink_zones(int priority, s
 				continue;
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
+			if (COMPACTION_BUILD) {
+				/*
+				 * If we already have plenty of memory
+				 * free for compaction, don't free any
+				 * more.  Even though compaction is
+				 * invoked for any non-zero order,
+				 * only frequent costly order
+				 * reclamation is disruptive enough to
+				 * become a noticable problem, like
+				 * transparent huge page allocations.
+				 */
+				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
+					(compaction_suitable(zone, sc->order) ||
+					 compaction_deferred(zone)))
+					continue;
+			}
 			/*
 			 * This steals pages from memory cgroups over softlimit
 			 * and returns the number of reclaimed pages and


