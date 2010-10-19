Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0JSEtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:49:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60923 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0JSEtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 00:49:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: npiggin@kernel.dk
Subject: Re: [patch 03/35] mm: implement per-zone shrinker
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20101019034655.756353382@kernel.dk>
References: <20101019034216.319085068@kernel.dk> <20101019034655.756353382@kernel.dk>
Message-Id: <20101019134345.A1E9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 13:49:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h	2010-10-19 14:19:40.000000000 +1100
> +++ linux-2.6/include/linux/mm.h	2010-10-19 14:36:48.000000000 +1100
> @@ -997,6 +997,10 @@
>  /*
>   * A callback you can register to apply pressure to ageable caches.
>   *
> + * 'shrink_zone' is the new shrinker API. It is to be used in preference
> + * to 'shrink'. One must point to a shrinker function, the other must
> + * be NULL. See 'shrink_slab' for details about the shrink_zone API.
> + *
>   * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
>   * look through the least-recently-used 'nr_to_scan' entries and
>   * attempt to free them up.  It should return the number of objects
> @@ -1013,13 +1017,53 @@
>  	int (*shrink)(struct shrinker *, int nr_to_scan, gfp_t gfp_mask);
>  	int seeks;	/* seeks to recreate an obj */
>  
> +	/*
> +	 * shrink_zone - slab shrinker callback for reclaimable objects
> +	 * @shrink: this struct shrinker
> +	 * @zone: zone to scan
> +	 * @scanned: pagecache lru pages scanned in zone
> +	 * @total: total pagecache lru pages in zone
> +	 * @global: global pagecache lru pages (for zone-unaware shrinkers)
> +	 * @flags: shrinker flags
> +	 * @gfp_mask: gfp context we are operating within
> +	 *
> +	 * The shrinkers are responsible for calculating the appropriate
> +	 * pressure to apply, batching up scanning (and cond_resched,
> +	 * cond_resched_lock etc), and updating events counters including
> +	 * count_vm_event(SLABS_SCANNED, nr).
> +	 *
> +	 * This approach gives flexibility to the shrinkers. They know best how
> +	 * to do batching, how much time between cond_resched is appropriate,
> +	 * what statistics to increment, etc.
> +	 */
> +	void (*shrink_zone)(struct shrinker *shrink,
> +		struct zone *zone, unsigned long scanned,
> +		unsigned long total, unsigned long global,
> +		unsigned long flags, gfp_t gfp_mask);

Now we decided to don't remove old (*shrink)() interface and zone unaware
slab users continue to use it. so why do we need global argument?
If only zone aware shrinker user (*shrink_zone)(), we can remove it.

Personally I think we should remove it because a removing makes a clear
message that all shrinker need to implement zone awareness eventually.



