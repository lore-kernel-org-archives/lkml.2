Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1DZMbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:31:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:48688 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab1DZMbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:31:12 -0400
Date: Tue, 26 Apr 2011 22:30:59 +1000
From: NeilBrown <neilb@suse.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 12/13] mm: Throttle direct reclaimers if PF_MEMALLOC
 reserves are low and swap is backed by network storage
Message-ID: <20110426223059.10f3edda@notabene.brown>
In-Reply-To: <1303803414-5937-13-git-send-email-mgorman@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
	<1303803414-5937-13-git-send-email-mgorman@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 08:36:53 +0100 Mel Gorman <mgorman@suse.de> wrote:


> +/*
> + * Throttle direct reclaimers if backing storage is backed by the network
> + * and the PFMEMALLOC reserve for the preferred node is getting dangerously
> + * depleted. kswapd will continue to make progress and wake the processes
> + * when the low watermark is reached
> + */
> +static void throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
> +					nodemask_t *nodemask)
> +{
> +	struct zone *zone;
> +	int high_zoneidx = gfp_zone(gfp_mask);
> +	DEFINE_WAIT(wait);
> +
> +	/* Check if the pfmemalloc reserves are ok */
> +	first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
> +	prepare_to_wait(&zone->zone_pgdat->pfmemalloc_wait, &wait,
> +							TASK_INTERRUPTIBLE);
> +	if (pfmemalloc_watermark_ok(zone->zone_pgdat, high_zoneidx))
> +		goto out;
> +
> +	/* Throttle */
> +	do {
> +		schedule();
> +		finish_wait(&zone->zone_pgdat->pfmemalloc_wait, &wait);
> +		prepare_to_wait(&zone->zone_pgdat->pfmemalloc_wait, &wait,
> +							TASK_INTERRUPTIBLE);
> +	} while (!pfmemalloc_watermark_ok(zone->zone_pgdat, high_zoneidx) &&
> +			!fatal_signal_pending(current));
> +
> +out:
> +	finish_wait(&zone->zone_pgdat->pfmemalloc_wait, &wait);
> +}

You are doing an interruptible wait, but only checking for fatal signals.
So if a non-fatal signal arrives, you will busy-wait.

So I suspect you want TASK_KILLABLE, so just use:

    wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
                        pgmemalloc_watermark_ok(zone->zone_pgdata,
                                                high_zoneidx));

(You also have an extraneous call to finish_wait)

NeilBrown


