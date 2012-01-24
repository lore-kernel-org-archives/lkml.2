Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2AXBD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 20:03:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab2AXBD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:03:56 -0500
Date: Mon, 23 Jan 2012 17:03:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: fix malused nr_reclaimed in shrinking zone
Message-Id: <20120123170354.82b9f127.akpm@linux-foundation.org>
In-Reply-To: <CAJd=RBDVxT5Pc2HZjz15LUb7xhFbztpFmXqLXVB3nCoQLKHiHg@mail.gmail.com>
References: <CAJd=RBDVxT5Pc2HZjz15LUb7xhFbztpFmXqLXVB3nCoQLKHiHg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jan 2012 22:41:59 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> The value of nr_reclaimed is the amount of pages reclaimed in the current round,
> whereas nr_to_reclaim shoud be compared with the amount of pages
> reclaimed in all
> rounds, so we have to buffer the pages reclaimed in the past rounds for correct
> comparison.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/vmscan.c	Sat Jan 14 14:02:20 2012
> +++ b/mm/vmscan.c	Sat Jan 21 22:23:48 2012
> @@ -2081,13 +2081,15 @@ static void shrink_mem_cgroup_zone(int p
>  				   struct scan_control *sc)
>  {
>  	unsigned long nr[NR_LRU_LISTS];
> +	unsigned long reclaimed = 0;
>  	unsigned long nr_to_scan;
>  	enum lru_list lru;
> -	unsigned long nr_reclaimed, nr_scanned;
> +	unsigned long nr_reclaimed = 0, nr_scanned;
>  	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
>  	struct blk_plug plug;
> 
>  restart:
> +	reclaimed += nr_reclaimed;
>  	nr_reclaimed = 0;
>  	nr_scanned = sc->nr_scanned;
>  	get_scan_count(mz, sc, nr, priority);
> @@ -2113,7 +2115,8 @@ restart:
>  		 * with multiple processes reclaiming pages, the total
>  		 * freeing target can get unreasonably large.
>  		 */
> -		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
> +		if ((nr_reclaimed + reclaimed) >= nr_to_reclaim &&
> +					priority < DEF_PRIORITY)
>  			break;
>  	}
>  	blk_finish_plug(&plug);

Well, let's step back and look at it.

- The multiple-definitions-of-a-local-per-line thing is generally a
  bad idea, partly because it prevents people from adding comments to
  the definition.  It would be better like this:

	unsigned long reclaimed = 0;	/* total for this function */
	unsigned long nr_reclaimed = 0;	/* on each pass through the loop */

- The names of these things are terrible!  Why not
  reclaimed_this_pass and reclaimed_total or similar?

- It would be cleaner to do the "reclaimed += nr_reclaimed" at the
  end of the loop, if we've decided to goto restart.  (But better
  to do it within the loop!)

- Only need to update sc->nr_reclaimed at the end of the function
  (assumes that callees of this function aren't interested in
  sc->nr_reclaimed, which seems a future-safe assumption to me).

- Should be able to avoid the temporary addition of nr_reclaimed to
  reclaimed inside the loop by updating `reclaimed' at an appropriate
  place.


Or whatever.  That code's handling of `reclaimed' and `nr_reclaimed' is
a twisty mess.  Please clean it up!  If it is done correctly,
`nr_reclaimed' can (and should) be local to the internal loop.
