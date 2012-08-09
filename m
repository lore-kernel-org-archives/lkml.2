Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2HIVld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:41:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab2HIVlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:41:32 -0400
Date: Thu, 9 Aug 2012 23:41:11 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] mm/mpol: Remove NUMA_INTERLEAVE_HIT
Message-ID: <20120809214111.GF10459@redhat.com>
References: <20120731191204.540691987@chello.nl>
 <20120731192808.459705289@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731192808.459705289@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 31, 2012 at 09:12:06PM +0200, Peter Zijlstra wrote:
> Since the NUMA_INTERLEAVE_HIT statistic is useless on its own; it wants
> to be compared to either a total of interleave allocations or to a miss
> count, remove it.
> 
> Fixing it would be possible, but since we've gone years without these
> statistics I figure we can continue that way.
> 
> Also NUMA_HIT fully includes NUMA_INTERLEAVE_HIT so users might
> switch to using that.
> 
> This cleans up some of the weird MPOL_INTERLEAVE allocation exceptions.

It's not apparent why you need to remove it for sched-numa. I think I
see it but it'd be nicer if it would explained so one doesn't need to
read an internal bit of several patches later to understand why this
is needed.

> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -169,7 +169,7 @@ static ssize_t node_read_numastat(struct
>  		       node_page_state(dev->id, NUMA_HIT),
>  		       node_page_state(dev->id, NUMA_MISS),
>  		       node_page_state(dev->id, NUMA_FOREIGN),
> -		       node_page_state(dev->id, NUMA_INTERLEAVE_HIT),
> +		       0UL,
>  		       node_page_state(dev->id, NUMA_LOCAL),
>  		       node_page_state(dev->id, NUMA_OTHER));
>  }

Not so nice to leave forever a 0 here. It doesn't matter if nobody can
act on it because it wants to be compared, it's still useful as an
informative value for vmstat below:

> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -717,7 +717,6 @@ const char * const vmstat_text[] = {
>  	"numa_hit",
>  	"numa_miss",
>  	"numa_foreign",
> -	"numa_interleave",
>  	"numa_local",
>  	"numa_other",
>  #endif
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
