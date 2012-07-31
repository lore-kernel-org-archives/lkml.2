Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2GaEuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:50:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48497 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891Ab2GaEuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:00 -0400
Message-Id: <20120731044313.503219008@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [ 14/73] mm: vmscan: convert global reclaim to per-memcg LRU lists
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <jweiner@redhat.com>

commit b95a2f2d486d0d768a92879c023a03757b9c7e58 upstream - WARNING: this is a substitute patch.

Stable note: Not tracked in Bugzilla. This is a partial backport of an
	upstream commit addressing a completely different issue
	that accidentally contained an important fix. The workload
	this patch helps was memcached when IO is started in the
	background. memcached should stay resident but without this patch
	it gets swapped. Sometimes this manifests as a drop in throughput
	but mostly it was observed through /proc/vmstat.

Commit [246e87a9: memcg: fix get_scan_count() for small targets] was meant
to fix a problem whereby small scan targets on memcg were ignored causing
priority to raise too sharply. It forced scanning to take place if the
target was small, memcg or kswapd.

>From the time it was introduced it caused excessive reclaim by kswapd
with workloads being pushed to swap that previously would have stayed
resident. This was accidentally fixed in commit [b95a2f2d: mm: vmscan:
convert global reclaim to per-memcg LRU lists] by making it harder for
kswapd to force scan small targets but that patchset is not suitable for
backporting. This was later changed again by commit [90126375: mm/vmscan:
push lruvec pointer into get_scan_count()] into a format that looks
like it would be a straight-forward backport but there is a subtle
difference due to the use of lruvecs.

The impact of the accidental fix is to make it harder for kswapd to force
scan small targets by taking zone->all_unreclaimable into account. This
patch is the closest equivalent available based on what is backported.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1911,7 +1911,8 @@ static void get_scan_count(struct zone *
 	 * latencies, so it's better to scan a minimum amount there as
 	 * well.
 	 */
-	if (scanning_global_lru(sc) && current_is_kswapd())
+	if (scanning_global_lru(sc) && current_is_kswapd() &&
+	    zone->all_unreclaimable)
 		force_scan = true;
 	if (!scanning_global_lru(sc))
 		force_scan = true;


