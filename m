Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1DRMaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:30:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1DRMa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:30:26 -0400
Date: Mon, 18 Apr 2011 22:30:14 +1000
From: NeilBrown <neilb@suse.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 12/12] mm: Throttle direct reclaimers if PF_MEMALLOC
 reserves are low and swap is backed by network storage
Message-ID: <20110418223014.22a6e490@notabene.brown>
In-Reply-To: <1302777698-28237-13-git-send-email-mgorman@suse.de>
References: <1302777698-28237-1-git-send-email-mgorman@suse.de>
	<1302777698-28237-13-git-send-email-mgorman@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 11:41:38 +0100 Mel Gorman <mgorman@suse.de> wrote:

> If swap is backed by network storage such as NBD, there is a risk that a
> large number of reclaimers can hang the system by consuming all
> PF_MEMALLOC reserves. To avoid these hangs, the administrator must tune
> min_free_kbytes in advance. This patch will throttle direct reclaimers
> if half the PF_MEMALLOC reserves are in use as the system is at risk of
> hanging. A message will be displayed so the administrator knows that
> min_free_kbytes should be tuned to a higher value to avoid the
> throttling in the future.

This sounds like a much simpler approach than all the pre-allocation.
Is it certain to work?  Are PF_MEMALLOC reserved only used from direct
reclaim?

Is printing a message for the admin really a good idea?  Auto-tuning is much
better than requiring the sysadmin to tune.
Is throttling when we are low on memory really a problem that needs to be
tuned away?  Presumably we would get over the memory shortage fairly soon and
the throttling would stop (??).

> +	if (printk_ratelimit())
> +		printk(KERN_INFO "Throttling %s due to reclaim pressure on "
> +				 "network storage\n",
> +			current->comm);
> +	do {
> +		prepare_to_wait(&zone->zone_pgdat->pfmemalloc_wait, &wait,
> +							TASK_INTERRUPTIBLE);
> +		schedule();
> +		finish_wait(&zone->zone_pgdat->pfmemalloc_wait, &wait);
> +	} while (!pfmemalloc_watermark_ok(zone->zone_pgdat, high_zoneidx) &&
> +			!fatal_signal_pending(current));
> +}
> +

This looks racing.  It is my understanding that you should always perform the
test between the 'prepare_to_wait' and the 'schedule'.  Otherwise the wakeup
could happen just before the prepare_to_wait and you never wake from the
schedule.
If that doesn't apply in this case I would appreciate a comment explaining
why.



>  unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  				gfp_t gfp_mask, nodemask_t *nodemask)
>  {
> @@ -2131,6 +2188,8 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  		.nodemask = nodemask,
>  	};
>  
> +	throttle_direct_reclaim(gfp_mask, zonelist, nodemask);
> +
>  	trace_mm_vmscan_direct_reclaim_begin(order,
>  				sc.may_writepage,
>  				gfp_mask);
> @@ -2482,6 +2541,13 @@ loop_again:
>  			}
>  
>  		}
> +
> +		/* Wake throttled direct reclaimers if low watermark is met */
> +		if (sk_memalloc_socks() &&
> +				waitqueue_active(&pgdat->pfmemalloc_wait) &&
> +				pfmemalloc_watermark_ok(pgdat, MAX_NR_ZONES - 1))
> +			wake_up_interruptible(&pgdat->pfmemalloc_wait);
> +

This test on sk_memalloc_socks looks ugly to me.
The VM shouldn't be checking on some networking state.

Do we really need the test?  It is not reasonable to always throttle direct
reclaim when mem gets really low?
If we do need the test - could networking set some global flag in the VM
which the VM can then test.
Maybe one day we will have something other than network which needs special
care with the last dregs of memory - then it could set the global flag too
(in which case it should probably be a global counter).

Thanks,
NeilBrown


>  		if (all_zones_ok || (order && pgdat_balanced(pgdat, balanced, *classzone_idx)))
>  			break;		/* kswapd: all done */
>  		/*

