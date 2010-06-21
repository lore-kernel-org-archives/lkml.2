Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab0FULqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:46:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54220 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab0FULpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:45:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Larry Woodman <lwoodman@redhat.com>
Subject: Re: [Patch] Call cond_resched() at bottom of main look in balance_pgdat()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1276800520.8736.236.camel@dhcp-100-19-198.bos.redhat.com>
References: <1276800520.8736.236.camel@dhcp-100-19-198.bos.redhat.com>
Message-Id: <20100618093954.FBE7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 21 Jun 2010 20:45:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We are seeing a problem where kswapd gets stuck and hogs the CPU on a
> small single CPU system when an OOM kill should occur.  When this
> happens swap space has been exhausted and the pagecache has been shrunk
> to zero.  Once kswapd gets the CPU it never gives it up because at least
> one zone is below high.  Adding a single cond_resched() at the end of
> the main loop in balance_pgdat() fixes the problem by allowing the
> watchdog and tasks to run and eventually do an OOM kill which frees up
> the resources.

Thank you. this seems regression.

> Mem-Info:
> DMA per-cpu:
> CPU    0: hi:    0, btch:   1 usd:   0
> Normal per-cpu:
> CPU    0: hi:  186, btch:  31 usd: 152
> active_anon:54902 inactive_anon:54849 isolated_anon:32
>  active_file:0 inactive_file:25 isolated_file:0
>  unevictable:660 dirty:0 writeback:6 unstable:0
>  free:1172 slab_reclaimable:1969 slab_unreclaimable:8322
>  mapped:196 shmem:801 pagetables:1300 bounce:0
> ...
> Normal free:2672kB min:2764kB low:3452kB high:4144kB 
> ...
> 21729 total pagecache pages
> 20240 pages in swap cache
> Swap cache stats: add 468211, delete 447971, find 12560445/12560936
> Free swap  = 0kB
> Total swap = 1015800kB
> 128720 pages RAM
> 0 pages HighMem
> 3223 pages reserved
> 1206 pages shared
> 121413 pages non-shared
> 

zero free swap. then, vmscan don't try to scan anon pages. but
file pages are almost zero. then, shrink_page_list() was not called
enough frequently....

I guess it is caused following commit (by me).

	commit bb3ab596832b920c703d1aea1ce76d69c0f71fb7
	Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
	Date:   Mon Dec 14 17:58:55 2009 -0800
	    vmscan: stop kswapd waiting on congestion when the min watermark is not being met

Very thanks your effort. your analysis seems perfect.

btw, I reformat your patch a bit. your previous email is a bit akpm 
unfriendly.


=============================================================
Subject: [PATCH] Call cond_resched() at bottom of main look in balance_pgdat()
From: Larry Woodman <lwoodman@redhat.com>

We are seeing a problem where kswapd gets stuck and hogs the CPU on a
small single CPU system when an OOM kill should occur.  When this
happens swap space has been exhausted and the pagecache has been shrunk
to zero.  Once kswapd gets the CPU it never gives it up because at least
one zone is below high.  Adding a single cond_resched() at the end of
the main loop in balance_pgdat() fixes the problem by allowing the
watchdog and tasks to run and eventually do an OOM kill which frees up
the resources.

kosaki note: This seems regression caused by commit bb3ab59683
(vmscan: stop kswapd waiting on congestion when the min watermark is
 not being met)

Signed-off-by: Larry Woodman <lwoodman@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c7e57c..c5c46b7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2182,6 +2182,7 @@ loop_again:
 		 */
 		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
 			break;
+		cond_resched();
 	}
 out:
 	/*
-- 
1.6.5.2



