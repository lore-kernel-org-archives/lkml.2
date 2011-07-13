Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323Ab1GMLCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:02:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965021Ab1GMLCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:02:49 -0400
Date: Wed, 13 Jul 2011 12:02:46 +0100
From: Mel Gorman <mgorman@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
Message-ID: <20110713110246.GF7529@suse.de>
References: <1310389274-13995-1-git-send-email-mgorman@suse.de>
 <1310389274-13995-3-git-send-email-mgorman@suse.de>
 <4E1CF1A3.3050401@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4E1CF1A3.3050401@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 10:15:15AM +0900, KOSAKI Motohiro wrote:
> (2011/07/11 22:01), Mel Gorman wrote:
> > The zonelist cache (ZLC) is used among other things to record if
> > zone_reclaim() failed for a particular zone recently. The intention
> > is to avoid a high cost scanning extremely long zonelists or scanning
> > within the zone uselessly.
> > 
> > Currently the zonelist cache is setup only after the first zone has
> > been considered and zone_reclaim() has been called. The objective was
> > to avoid a costly setup but zone_reclaim is itself quite expensive. If
> > it is failing regularly such as the first eligible zone having mostly
> > mapped pages, the cost in scanning and allocation stalls is far higher
> > than the ZLC initialisation step.
> > 
> > This patch initialises ZLC before the first eligible zone calls
> > zone_reclaim(). Once initialised, it is checked whether the zone
> > failed zone_reclaim recently. If it has, the zone is skipped. As the
> > first zone is now being checked, additional care has to be taken about
> > zones marked full. A zone can be marked "full" because it should not
> > have enough unmapped pages for zone_reclaim but this is excessive as
> > direct reclaim or kswapd may succeed where zone_reclaim fails. Only
> > mark zones "full" after zone_reclaim fails if it failed to reclaim
> > enough pages after scanning.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> If I understand correctly this patch's procs/cons is,
> 
> pros.
>  1) faster when zone reclaim doesn't work effectively
> 

Yes.

> cons.
>  2) slower when zone reclaim is off

How is it slower with zone_reclaim off?

Before

	if (zone_reclaim_mode == 0)
		goto this_zone_full;
	...
	this_zone_full:
	if (NUMA_BUILD)
		zlc_mark_zone_full(zonelist, z);
	if (NUMA_BUILD && !did_zlc_setup && nr_online_nodes > 1) {
		...
	}

After
	if (NUMA_BUILD && !did_zlc_setup && nr_online_nodes > 1) {
		...
	}
	if (zone_reclaim_mode == 0)
		goto this_zone_full;
	this_zone_full:
	if (NUMA_BUILD)
		zlc_mark_zone_full(zonelist, z);

Bear in mind that if the watermarks are met on the first zone, the zlc
setup does not occur.

>  3) slower when zone recliam works effectively
> 

Marginally slower. It's now calling zlc setup so once a second it's
zeroing a bitmap and calling zlc_zone_worth_trying() on the first
zone testing a bit on a cache-hot structure.

As the ineffective case can be triggered by a simple cp, I think the
cost is justified. Can you think of a better way of doing this?

> (2) and (3) are frequently happen than (1), correct?

Yes. I'd still expect zone_reclaim to be off on the majority of
machines and even when enabled, I think it's relatively rare we hit the
case where the workload is regularly falling over to the other node
except in the case where it's a file server. Still, a cp is not to
uncommon that the kernel should slow to a crawl as a result.

> At least, I think we need to keep zero impact when zone reclaim mode is off.
> 

I agree with this but I'm missing where we are taking the big hit with
zone_reclaim==0.

-- 
Mel Gorman
SUSE Labs
