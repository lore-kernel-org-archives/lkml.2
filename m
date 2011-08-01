Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1HAXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:25:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab1HAXZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232051.296291349@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [07/70] mm: vmscan: evaluate the watermarks against the correct classzone
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit da175d06b437093f93109ba9e5efbe44dfdf9409 upstream.

When deciding if kswapd is sleeping prematurely, the classzone is taken
into account but this is different to what balance_pgdat() and the
allocator are doing.  Specifically, the DMA zone will be checked based on
the classzone used when waking kswapd which could be for a GFP_KERNEL or
GFP_HIGHMEM request.  The lowmem reserve limit kicks in, the watermark is
not met and kswapd thinks it's sleeping prematurely keeping kswapd awake in
error.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Andrew Lutomirski <luto@mit.edu>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2279,7 +2279,7 @@ static bool sleeping_prematurely(pg_data
 		}
 
 		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
-							classzone_idx, 0))
+							i, 0))
 			all_zones_ok = false;
 		else
 			balanced += zone->present_pages;


