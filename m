Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab0IHWUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:20:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756220Ab0IHWUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:20:03 -0400
Date: Wed, 8 Sep 2010 15:19:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>, stable@kernel.org
Subject: Re: [PATCH] vmscan: check all_unreclaimable in direct reclaim path
Message-Id: <20100908151929.2586ace5.akpm@linux-foundation.org>
In-Reply-To: <20100908154527.GA5936@barrios-desktop>
References: <1283697637-3117-1-git-send-email-minchan.kim@gmail.com>
	<20100908054831.GB20955@cmpxchg.org>
	<20100908154527.GA5936@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010 00:45:27 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> +static inline bool zone_reclaimable(struct zone *zone)
> +{
> +	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
> +}
> +
> +static inline bool all_unreclaimable(struct zonelist *zonelist,
> +		struct scan_control *sc)
> +{
> +	struct zoneref *z;
> +	struct zone *zone;
> +	bool all_unreclaimable = true;
> +
> +	if (!scanning_global_lru(sc))
> +		return false;
> +
> +	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> +			gfp_zone(sc->gfp_mask), sc->nodemask) {
> +		if (!populated_zone(zone))
> +			continue;
> +		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
> +			continue;
> +		if (zone_reclaimable(zone)) {
> +			all_unreclaimable = false;
> +			break;
> +		}
> +	}
> +
>  	return all_unreclaimable;
>  }

Could we have some comments over these functions please?  Why they
exist, what problem they solve, how they solve them, etc.  Stuff which
will be needed for maintaining this code three years from now.

We may as well remove the `inline's too.  gcc will tkae care of that.

> -		if (nr_slab == 0 &&
> -		   zone->pages_scanned >= (zone_reclaimable_pages(zone) * 6))
> +		if (nr_slab == 0 && !zone_reclaimable(zone))

Extra marks for working out and documenting how we decided on the value
of "6".  Sigh.  It's hopefully in the git record somewhere.
