Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1HAX1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:27:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab1HAX0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:56 2011
Message-Id: <20110801232056.139640092@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [55/70] vmscan: fix a livelock in kswapd
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 4746efded84d7c5a9c8d64d4c6e814ff0cf9fb42 upstream.

I'm running a workload which triggers a lot of swap in a machine with 4
nodes.  After I kill the workload, I found a kswapd livelock.  Sometimes
kswapd3 or kswapd2 are keeping running and I can't access filesystem,
but most memory is free.

This looks like a regression since commit 08951e545918c159 ("mm: vmscan:
correct check for kswapd sleeping in sleeping_prematurely").

Node 2 and 3 have only ZONE_NORMAL, but balance_pgdat() will return 0
for classzone_idx.  The reason is end_zone in balance_pgdat() is 0 by
default, if all zones have watermark ok, end_zone will keep 0.

Later sleeping_prematurely() always returns true.  Because this is an
order 3 wakeup, and if classzone_idx is 0, both balanced_pages and
present_pages in pgdat_balanced() are 0.  We add a special case here.
If a zone has no page, we think it's balanced.  This fixes the livelock.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2245,7 +2245,8 @@ static bool pgdat_balanced(pg_data_t *pg
 	for (i = 0; i <= classzone_idx; i++)
 		present_pages += pgdat->node_zones[i].present_pages;
 
-	return balanced_pages > (present_pages >> 2);
+	/* A special case here: if zone has no page, we think it's balanced */
+	return balanced_pages >= (present_pages >> 2);
 }
 
 /* is kswapd sleeping prematurely? */


