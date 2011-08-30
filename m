Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab1H3CNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:13:38 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:43339 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab1H3CNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:13:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0DAHBFXE55LIxDgWdsb2JhbABCqAYVAQEWJiWBQAEBBAEnExwjBQsIAw4KLhQlAyETh3IEuEwOhj8EpDo
Date: Tue, 30 Aug 2011 12:13:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shrinker: fix a bug when callback returns -1
Message-ID: <20110830021333.GL3162@dastard>
References: <Pine.LNX.4.64.1108291534140.19003@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108291534140.19003@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 03:36:48PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This patch fixes a lockup when shrinker callback returns -1.

What lockup is that? I haven't seen any bug reports, and this code
has been like this for several years, so I'm kind of wondering why
this is suddenly an issue....

> BTW. shouldn't the value returned by callback be long instead of int? On 
> 64-bit architectures, there may be more than 2^32 entries allocated.

The API hasn't changed since the early 2.5 series, so that wasn't a
consideration when it was originally written. As it is, I make this
exact change in the shrinker API update patchset I proposed
recently for exactly the reasons you suggest:

http://thread.gmane.org/gmane.linux.kernel.mm/67326


> Mikulas
> 
> ---
> 
> shrinker: fix a bug when callback returns -1
> 
> Shrinker callback can return -1 if it is at a risk of deadlock.
> However, this is not tested at some places.
> 
> If do_shrinker_shrink returns -1 here
> "max_pass = do_shrinker_shrink(shrinker, shrink, 0)",
> it is converted to an unsigned long integer. This may result in excessive
> total_scan value and a lockup due to code looping too much in
> "while (total_scan >= batch_size)" cycle.

> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  mm/vmscan.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Index: linux-3.1-rc3-fast/mm/vmscan.c
> ===================================================================
> --- linux-3.1-rc3-fast.orig/mm/vmscan.c	2011-08-29 20:34:27.000000000 +0200
> +++ linux-3.1-rc3-fast/mm/vmscan.c	2011-08-29 20:37:38.000000000 +0200
> @@ -250,6 +250,7 @@ unsigned long shrink_slab(struct shrink_
>  		unsigned long long delta;
>  		unsigned long total_scan;
>  		unsigned long max_pass;
> +		int sr;
>  		int shrink_ret = 0;
>  		long nr;
>  		long new_nr;
> @@ -266,7 +267,10 @@ unsigned long shrink_slab(struct shrink_
>  		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
>  
>  		total_scan = nr;
> -		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
> +		sr = do_shrinker_shrink(shrinker, shrink, 0);
> +		if (sr == -1)
> +			continue;

IIRC from my recent shrinker audit, none of the existing shrinkers
return return -1 when nr_to_scan == 0, so this check has never been
necessary.

> +		max_pass = sr;
>  		delta = (4 * nr_pages_scanned) / shrinker->seeks;
>  		delta *= max_pass;
>  		do_div(delta, lru_pages + 1);
> @@ -309,6 +313,8 @@ unsigned long shrink_slab(struct shrink_
>  			int nr_before;
>  
>  			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
> +			if (nr_before == -1)
> +				break;

Same here.

>  			shrink_ret = do_shrinker_shrink(shrinker, shrink,
>  							batch_size);
>  			if (shrink_ret == -1)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
