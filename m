Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936087Ab2C3V2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:28:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966075Ab2C3VWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:22:10 -0400
Message-Id: <20120330194845.531765417@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stuart Foster <smf.linux@ntlworld.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Christoph Lameter <cl@linux.com>
Subject: [ 101/175] mm: vmscan: forcibly scan highmem if there are too many buffer_heads pinning highmem
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit cc715d99e529d470dde2f33a6614f255adea71f3 upstream.

Stuart Foster reported on bugzilla that copying large amounts of data
from NTFS caused an OOM kill on 32-bit X86 with 16G of memory.  Andrew
Morton correctly identified that the problem was NTFS was using 512
blocks meaning each page had 8 buffer_heads in low memory pinning it.

In the past, direct reclaim used to scan highmem even if the allocating
process did not specify __GFP_HIGHMEM but not any more.  kswapd no longer
will reclaim from zones that are above the high watermark.  The intention
in both cases was to minimise unnecessary reclaim.  The downside is on
machines with large amounts of highmem that lowmem can be fully consumed
by buffer_heads with nothing trying to free them.

The following patch is based on a suggestion by Andrew Morton to extend
the buffer_heads_over_limit case to force kswapd and direct reclaim to
scan the highmem zone regardless of the allocation request or watermarks.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=42578

[hughd@google.com: move buffer_heads_over_limit check up]
[akpm@linux-foundation.org: buffer_heads_over_limit is unlikely]
Reported-by: Stuart Foster <smf.linux@ntlworld.com>
Tested-by: Stuart Foster <smf.linux@ntlworld.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 mm/vmscan.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1643,18 +1643,6 @@ static void move_active_pages_to_lru(str
 	unsigned long pgmoved = 0;
 	struct page *page;
 
-	if (buffer_heads_over_limit) {
-		spin_unlock_irq(&zone->lru_lock);
-		list_for_each_entry(page, list, lru) {
-			if (page_has_private(page) && trylock_page(page)) {
-				if (page_has_private(page))
-					try_to_release_page(page, 0);
-				unlock_page(page);
-			}
-		}
-		spin_lock_irq(&zone->lru_lock);
-	}
-
 	while (!list_empty(list)) {
 		struct lruvec *lruvec;
 
@@ -1737,6 +1725,14 @@ static void shrink_active_list(unsigned
 			continue;
 		}
 
+		if (unlikely(buffer_heads_over_limit)) {
+			if (page_has_private(page) && trylock_page(page)) {
+				if (page_has_private(page))
+					try_to_release_page(page, 0);
+				unlock_page(page);
+			}
+		}
+
 		if (page_referenced(page, 0, mz->mem_cgroup, &vm_flags)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
@@ -2235,6 +2231,14 @@ static bool shrink_zones(int priority, s
 	unsigned long nr_soft_scanned;
 	bool aborted_reclaim = false;
 
+	/*
+	 * If the number of buffer_heads in the machine exceeds the maximum
+	 * allowed level, force direct reclaim to scan the highmem zone as
+	 * highmem pages could be pinning lowmem pages storing buffer_heads
+	 */
+	if (buffer_heads_over_limit)
+		sc->gfp_mask |= __GFP_HIGHMEM;
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
@@ -2724,6 +2728,17 @@ loop_again:
 			 */
 			age_active_anon(zone, &sc, priority);
 
+			/*
+			 * If the number of buffer_heads in the machine
+			 * exceeds the maximum allowed level and this node
+			 * has a highmem zone, force kswapd to reclaim from
+			 * it to relieve lowmem pressure.
+			 */
+			if (buffer_heads_over_limit && is_highmem_idx(i)) {
+				end_zone = i;
+				break;
+			}
+
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
@@ -2786,7 +2801,8 @@ loop_again:
 				(zone->present_pages +
 					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
 				KSWAPD_ZONE_BALANCE_GAP_RATIO);
-			if (!zone_watermark_ok_safe(zone, order,
+			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
+				    !zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone) + balance_gap,
 					end_zone, 0)) {
 				shrink_zone(priority, zone, &sc);


