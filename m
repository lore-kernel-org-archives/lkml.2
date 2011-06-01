Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab1FAIOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:14:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161792Ab1FAIOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:14:12 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:56 2011
Message-Id: <20110601080355.173084200@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:25 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [089/146] mm: vmscan: correct use of pgdat_balanced in
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------
 sleeping_prematurely

From: Johannes Weiner <hannes@cmpxchg.org>

commit afc7e326a3f5bafc41324d7926c324414e343ee5 upstream.

There are a few reports of people experiencing hangs when copying large
amounts of data with kswapd using a large amount of CPU which appear to be
due to recent reclaim changes.  SLUB using high orders is the trigger but
not the root cause as SLUB has been using high orders for a while.  The
root cause was bugs introduced into reclaim which are addressed by the
following two patches.

Patch 1 corrects logic introduced by commit 1741c877 ("mm: kswapd:
        keep kswapd awake for high-order allocations until a percentage of
        the node is balanced") to allow kswapd to go to sleep when
        balanced for high orders.

Patch 2 notes that it is possible for kswapd to miss every
        cond_resched() and updates shrink_slab() so it'll at least reach
        that scheduling point.

Chris Wood reports that these two patches in isolation are sufficient to
prevent the system hanging.  AFAIK, they should also resolve similar hangs
experienced by James Bottomley.

This patch:

Johannes Weiner poined out that the logic in commit 1741c877 ("mm: kswapd:
keep kswapd awake for high-order allocations until a percentage of the
node is balanced") is backwards.  Instead of allowing kswapd to go to
sleep when balancing for high order allocations, it keeps it kswapd
running uselessly.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Tested-by: Colin King <colin.king@canonical.com>
Cc: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2286,7 +2286,7 @@ static bool sleeping_prematurely(pg_data
 	 * must be balanced
 	 */
 	if (order)
-		return pgdat_balanced(pgdat, balanced, classzone_idx);
+		return !pgdat_balanced(pgdat, balanced, classzone_idx);
 	else
 		return !all_zones_ok;
 }


