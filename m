Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1LVQuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:50:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60556 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab1LVQuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:50:05 -0500
Date: Thu, 22 Dec 2011 08:49:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + mempool-fix-first-round-failure-behavior.patch added to -mm
 tree
Message-ID: <20111222164958.GG17084@google.com>
References: <20111222163900.GA1448@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222163900.GA1448@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Thu, Dec 22, 2011 at 05:39:00PM +0100, Oleg Nesterov wrote:
> I can't even explain why this (simple!) logic looks confusing to me,

Yeah, gfp_mask and temp confused me pretty good too.

> with or without the patch. A couple of questions:
> 
> 	1. Why do we remove __GFP_WAIT unconditionally before the the
> 	   very 1st allocation?

To avoid blocking when there's pool sitting around.

> 	2. Why do we always restore it after io_schedule(), even if
> 	   we have the reserved items?

No idea.

> @@ -212,10 +212,12 @@ void * mempool_alloc(mempool_t *pool, gf
>  	gfp_mask |= __GFP_NORETRY;	/* don't loop in __alloc_pages */
>  	gfp_mask |= __GFP_NOWARN;	/* failures are OK */
>  
> -	gfp_temp = gfp_mask & ~(__GFP_WAIT|__GFP_IO);
> -
>  repeat_alloc:
>  
> +	gfp_temp = gfp_mask;
> +	if (pool->curr_nr)
> +		gfp_temp &= ~(__GFP_WAIT|__GFP_IO);
> +
>  	element = pool->alloc(gfp_temp, pool->pool_data);
>  	if (likely(element != NULL))
>  		return element;
> @@ -229,13 +231,15 @@ repeat_alloc:
>  	}
>  
>  	/* We must not sleep in the GFP_ATOMIC case */
> -	if (!(gfp_mask & __GFP_WAIT)) {
> +	if (!(gfp_temp & __GFP_WAIT)) {
>  		spin_unlock_irqrestore(&pool->lock, flags);
> +		/* raced with another mempool_alloc? */
> +		if (gfp_mask & __GFP_WAIT)
> +			goto repeat_alloc;
>  		return NULL;
>  	}
>  
>  	/* Let's wait for someone else to return an element to @pool */
> -	gfp_temp = gfp_mask;
>  	init_wait(&wait);
>  	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);

Yeah, this one definitely looks better & makes more sense.  Andrew,
please feel free to drop mine and take this one.

Thanks.

-- 
tejun
