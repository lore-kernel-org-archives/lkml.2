Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1JQTfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:35:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1JQTfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:35:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=squ8TgV7r/IfHSLlcnFgqdKvnYdYv8z9RtEfFsXPrkjI1AbHVlLqzEVUKomQLCZCD
	oW7SAq9sEq4IKkWvqI9tg==
Date: Mon, 17 Oct 2011 12:35:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rakib Mullick <rakib.mullick@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] drivers, vmw_balloon.c: Increment alloc and sleep_alloc
 only when page allocation succeeds.
In-Reply-To: <1318877852.10091.11.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1110171232460.12560@chino.kir.corp.google.com>
References: <1318877852.10091.11.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Rakib Mullick wrote:

>  While doing allocation statistics in vmballoon_reserve_page function, 
> alloc and sleep_alloc has been incremented even if allocation fails. 
> But, 
> b->stats.alloc and b->stats.sleep_alloc supposed to increment only when 
> they succeed. This patch makes sure that, alloc and sleep_alloc gets 
> incremented when page allocation succeeds.
> 

Dmitry could say for sure, but this seems to actually change the 
semantics.  If the allocations fail, it increments alloc_fail and 
sleep_alloc_fail accordingly so you could easily see 10 alloc and 5 
alloc_fail.  With your patch, it would be 5 alloc and 5 alloc_fail.

I don't know which one is best, but I would opt to stay with the semantics 
that alloc and sleep_alloc have already had rather than changing them.

> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 053d36c..d2c25c9 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -414,11 +414,6 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
>  	bool locked = false;
>  
>  	do {
> -		if (!can_sleep)
> -			STATS_INC(b->stats.alloc);
> -		else
> -			STATS_INC(b->stats.sleep_alloc);
> -
>  		flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
>  		page = alloc_page(flags);
>  		if (!page) {
> @@ -427,6 +422,11 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
>  			else
>  				STATS_INC(b->stats.sleep_alloc_fail);
>  			return -ENOMEM;
> +		} else {
> +			if (!can_sleep)
> +				STATS_INC(b->stats.alloc);
> +			else
> +				STATS_INC(b->stats.sleep_alloc);
>  		}
>  
>  		/* inform monitor */
