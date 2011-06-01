Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162721Ab1FAIXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:23:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162705Ab1FAIXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:23:16 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:45 2011
Message-Id: <20110601081144.952563782@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:02 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [092/165] mm: vmscan: correctly check if reclaimer should schedule
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 during shrink_slab
Content-Length: 3067
Lines: 80

From: Minchan Kim <minchan.kim@gmail.com>

commit f06590bd718ed950c98828e30ef93204028f3210 upstream.

It has been reported on some laptops that kswapd is consuming large
amounts of CPU and not being scheduled when SLUB is enabled during large
amounts of file copying.  It is expected that this is due to kswapd
missing every cond_resched() point because;

shrink_page_list() calls cond_resched() if inactive pages were isolated
        which in turn may not happen if all_unreclaimable is set in
        shrink_zones(). If for whatver reason, all_unreclaimable is
        set on all zones, we can miss calling cond_resched().

balance_pgdat() only calls cond_resched if the zones are not
        balanced. For a high-order allocation that is balanced, it
        checks order-0 again. During that window, order-0 might have
        become unbalanced so it loops again for order-0 and returns
        that it was reclaiming for order-0 to kswapd(). It can then
        find that a caller has rewoken kswapd for a high-order and
        re-enters balance_pgdat() without ever calling cond_resched().

shrink_slab only calls cond_resched() if we are reclaiming slab
	pages. If there are a large number of direct reclaimers, the
	shrinker_rwsem can be contended and prevent kswapd calling
	cond_resched().

This patch modifies the shrink_slab() case.  If the semaphore is
contended, the caller will still check cond_resched().  After each
successful call into a shrinker, the check for cond_resched() remains in
case one shrinker is particularly slow.

[mgorman@suse.de: preserve call to cond_resched after each call into shrinker]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Tested-by: Colin King <colin.king@canonical.com>
Cc: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmscan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -230,8 +230,11 @@ unsigned long shrink_slab(unsigned long
 	if (scanned == 0)
 		scanned = SWAP_CLUSTER_MAX;
 
-	if (!down_read_trylock(&shrinker_rwsem))
-		return 1;	/* Assume we'll be able to shrink next time */
+	if (!down_read_trylock(&shrinker_rwsem)) {
+		/* Assume we'll be able to shrink next time */
+		ret = 1;
+		goto out;
+	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
 		unsigned long long delta;
@@ -282,6 +285,8 @@ unsigned long shrink_slab(unsigned long
 		shrinker->nr += total_scan;
 	}
 	up_read(&shrinker_rwsem);
+out:
+	cond_resched();
 	return ret;
 }
 


