Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2A0JN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:13:29 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33733 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2A0JN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:13:26 -0500
MIME-Version: 1.0
In-Reply-To: <20120126145914.58619765@cuia.bos.redhat.com>
References: <20120126145450.2d3d2f4c@cuia.bos.redhat.com>
	<20120126145914.58619765@cuia.bos.redhat.com>
Date: Fri, 27 Jan 2012 17:13:25 +0800
Message-ID: <CAJd=RBB=MDiYLVSYJj8d8NfBZp+OU0Lf3-W5+xZUqj0J1JA4cQ@mail.gmail.com>
Subject: Re: [PATCH v3 -mm 1/3] mm: reclaim at order 0 when compaction is enabled
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

On Fri, Jan 27, 2012 at 3:59 AM, Rik van Riel <riel@redhat.com> wrote:
> When built with CONFIG_COMPACTION, kswapd should not try to free
> contiguous pages, because it is not trying hard enough to have
> a real chance at being successful, but still disrupts the LRU
> enough to break other things.
>
> Do not do higher order page isolation unless we really are in
> lumpy reclaim mode.
>
> Stop reclaiming pages once we have enough free pages that
> compaction can deal with things, and we hit the normal order 0
> watermarks used by kswapd.
>
> Also remove a line of code that increments balanced right before
> exiting the function.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> -v4: further cleanups suggested by Mel Gorman
>  mm/vmscan.c |   43 +++++++++++++++++++++++++++++--------------
>  1 files changed, 29 insertions(+), 14 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2880396..2e2e43d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1139,7 +1139,7 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file)
>  * @mz:                The mem_cgroup_zone to pull pages from.
>  * @dst:       The temp list to put pages on to.
>  * @nr_scanned:        The number of pages that were scanned.
> - * @order:     The caller's attempted allocation order
> + * @sc:                The scan_control struct for this reclaim session
>  * @mode:      One of the LRU isolation modes
>  * @active:    True [1] if isolating active pages
>  * @file:      True [1] if isolating file [!anon] pages
> @@ -1148,8 +1148,8 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file)
>  */
>  static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>                struct mem_cgroup_zone *mz, struct list_head *dst,
> -               unsigned long *nr_scanned, int order, isolate_mode_t mode,
> -               int active, int file)
> +               unsigned long *nr_scanned, struct scan_control *sc,
> +               isolate_mode_t mode, int active, int file)
>  {
>        struct lruvec *lruvec;
>        struct list_head *src;
> @@ -1195,7 +1195,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>                        BUG();
>                }
>
> -               if (!order)
> +               if (!sc->order || !(sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM))
>                        continue;
>
Just a tiny advice 8-)

mind to move checking lumpy reclaim out of the loop,
something like

	unsigned long nr_lumpy_failed = 0;
	unsigned long scan;
	int lru = LRU_BASE;
+	int order = sc->order;
+
+	if (!(sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM))
+		order = 0;

	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
	if (active)
		lru += LRU_ACTIVE;

with a line of comment?

Hillf
