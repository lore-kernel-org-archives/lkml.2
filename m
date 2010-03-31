Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab0CaKeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:34:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21945 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab0CaKeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:34:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mOi4BaB+ECbkYdaVRLKEGgEe+6otNg1WDZVo2vvzuzOFcYxFo39W8jr+6uUrtpdNg
	BG76g8CenERQDV8jqYyMQ==
Date: Wed, 31 Mar 2010 03:34:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 4/4] cpuset,mm: update task's mems_allowed lazily
In-Reply-To: <4BB31BDA.8080203@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003310324550.17661@chino.kir.corp.google.com>
References: <4B94CD2D.8070401@cn.fujitsu.com> <alpine.DEB.2.00.1003081330370.18502@chino.kir.corp.google.com> <4B95F802.9020308@cn.fujitsu.com> <20100311081548.GJ5812@laptop> <4B98C6DE.3060602@cn.fujitsu.com> <20100311110317.GL5812@laptop>
 <4BB31BDA.8080203@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Miao Xie wrote:

> diff --git a/mm/mmzone.c b/mm/mmzone.c
> index f5b7d17..43ac21b 100644
> --- a/mm/mmzone.c
> +++ b/mm/mmzone.c
> @@ -58,6 +58,7 @@ struct zoneref *next_zones_zonelist(struct zoneref *z,
>  					nodemask_t *nodes,
>  					struct zone **zone)
>  {
> +	nodemask_t tmp_nodes;
>  	/*
>  	 * Find the next suitable zone to use for the allocation.
>  	 * Only filter based on nodemask if it's set
> @@ -65,10 +66,16 @@ struct zoneref *next_zones_zonelist(struct zoneref *z,
>  	if (likely(nodes == NULL))
>  		while (zonelist_zone_idx(z) > highest_zoneidx)
>  			z++;
> -	else
> -		while (zonelist_zone_idx(z) > highest_zoneidx ||
> -				(z->zone && !zref_in_nodemask(z, nodes)))
> -			z++;
> +	else {
> +		tmp_nodes = *nodes;
> +		if (nodes_empty(tmp_nodes))
> +			while (zonelist_zone_idx(z) > highest_zoneidx)
> +				z++;
> +		else
> +			while (zonelist_zone_idx(z) > highest_zoneidx ||
> +				(z->zone && !zref_in_nodemask(z, &tmp_nodes)))
> +				z++;
> +	}
>  
>  	*zone = zonelist_zone(z);
>  	return z;

Unfortunately, you can't allocate a nodemask_t on the stack here because 
this is used in the iteration for get_page_from_freelist() which can occur 
very deep in the stack already and there's a probability of overflow.  
Dynamically allocating a nodemask_t simply wouldn't scale here, either, 
since it would allocate on every iteration of a zonelist.
