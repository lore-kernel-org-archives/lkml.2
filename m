Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2LULvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:51:39 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61452 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2LULvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:51:32 -0500
X-Greylist: delayed 172040 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 06:51:32 EST
MIME-Version: 1.0
In-Reply-To: <50D24CD9.8070507@iskon.hr>
References: <50D24AF3.1050809@iskon.hr>
	<50D24CD9.8070507@iskon.hr>
Date: Fri, 21 Dec 2012 19:51:31 +0800
Message-ID: <CAJd=RBCQN1GxOUCwGPXL27d_q8hv50uHK5LhDnsv7mdv_2Usaw@mail.gmail.com>
Subject: Re: [PATCH] mm: do not sleep in balance_pgdat if there's no i/o congestion
From: Hillf Danton <dhillf@gmail.com>
To: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 7:25 AM, Zlatko Calusic <zlatko.calusic@iskon.hr> wrote:
>  static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
>                                                         int *classzone_idx)
>  {
> -       int all_zones_ok;
> +       struct zone *unbalanced_zone;

nit: less hunks if not erase that mark

Hillf
>         unsigned long balanced;
>         int i;
>         int end_zone = 0;       /* Inclusive.  0 = ZONE_DMA */
> @@ -2580,7 +2580,7 @@ loop_again:
>                 unsigned long lru_pages = 0;
>                 int has_under_min_watermark_zone = 0;
>
> -               all_zones_ok = 1;
> +               unbalanced_zone = NULL;
>                 balanced = 0;
>
>                 /*
> @@ -2719,7 +2719,7 @@ loop_again:
>                         }
>
>                         if (!zone_balanced(zone, testorder, 0, end_zone)) {
> -                               all_zones_ok = 0;
> +                               unbalanced_zone = zone;
>                                 /*
>                                  * We are still under min water mark.  This
>                                  * means that we have a GFP_ATOMIC allocation
> @@ -2752,7 +2752,7 @@ loop_again:
>                                 pfmemalloc_watermark_ok(pgdat))
>                         wake_up(&pgdat->pfmemalloc_wait);
>
> -               if (all_zones_ok || (order && pgdat_balanced(pgdat, balanced, *classzone_idx)))
> +               if (!unbalanced_zone || (order && pgdat_balanced(pgdat, balanced, *classzone_idx)))
>                         break;          /* kswapd: all done */
>                 /*
>                  * OK, kswapd is getting into trouble.  Take a nap, then take
> @@ -2762,7 +2762,7 @@ loop_again:
>                         if (has_under_min_watermark_zone)
>                                 count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
>                         else
> -                               congestion_wait(BLK_RW_ASYNC, HZ/10);
> +                               wait_iff_congested(unbalanced_zone, BLK_RW_ASYNC, HZ/10);
>                 }
>
>                 /*
> @@ -2781,7 +2781,7 @@ out:
>          * high-order: Balanced zones must make up at least 25% of the node
>          *             for the node to be balanced
>          */
> -       if (!(all_zones_ok || (order && pgdat_balanced(pgdat, balanced, *classzone_idx)))) {
> +       if (unbalanced_zone && (!order || !pgdat_balanced(pgdat, balanced, *classzone_idx))) {
>                 cond_resched();
>
>                 try_to_freeze();
> -- 1.7.10.4
