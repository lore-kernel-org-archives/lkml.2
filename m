Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1CEPVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 10:21:11 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44115 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1CEPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 10:21:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BuOkDogK50quMmQNBtT8lPDHJMlDwE4o3OucjlGOUyLbzyeV+j9wKpbvrKL05NYQlO
         p5dPmDPcqTiEHZfhQ3Fbcp7C5Dv2HTe+VSziXwqdgmgC9DFJkwdcwiHj4iEwPNGRKtfm
         /g075bKY54FnKjS97huU2ljqXFYukgyoBRm08=
Date: Sun, 6 Mar 2011 00:20:57 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable()
Message-ID: <20110305152056.GA1918@barrios-desktop>
References: <1299325456-2687-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299325456-2687-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 05, 2011 at 02:44:16PM +0300, Andrey Vagin wrote:
> Check zone->all_unreclaimable in all_unreclaimable(), otherwise the
> kernel may hang up, because shrink_zones() will do nothing, but
> all_unreclaimable() will say, that zone has reclaimable pages.
> 
> do_try_to_free_pages()
> 	shrink_zones()
> 		 for_each_zone
> 			if (zone->all_unreclaimable)
> 				continue
> 	if !all_unreclaimable(zonelist, sc)
> 		return 1
> 
> __alloc_pages_slowpath()
> retry:
> 	did_some_progress = do_try_to_free_pages(page)
> 	...
> 	if (!page && did_some_progress)
> 		retry;
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  mm/vmscan.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6771ea7..1c056f7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2002,6 +2002,8 @@ static bool all_unreclaimable(struct zonelist *zonelist,
>  
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  			gfp_zone(sc->gfp_mask), sc->nodemask) {
> +		if (zone->all_unreclaimable)
> +			continue;
>  		if (!populated_zone(zone))
>  			continue;
>  		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))


zone_reclaimable checks it. Isn't it enough?
Does the hang up really happen or see it by code review?

> -- 
> 1.7.1
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
