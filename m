Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1HCVOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:14:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab1HCVOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:14:17 -0400
Date: Wed, 3 Aug 2011 17:14:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Bolle <vivek.goyal2008@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] CFQ: simplify radix tree lookup in cfq_cic_lookup()
Message-ID: <20110803211413.GE32385@redhat.com>
References: <1312402472.22854.16.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312402472.22854.16.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 10:14:32PM +0200, Paul Bolle wrote:
> 0) Not tested and not signed-off.
> 
> 1) This is to see whether I understand the cfqd->cic_index usage (at
> least, part of it).
> 
> 2) If the lookup of a cic in the radix tree turned up a "dead" cic, then
> that cic will be dropped. There's no reason to again try to lookup that
> cic: that lookup should return NULL. (If it doesn't return NULL, we seem
> to be in trouble.) So there's no need for a do {[...]} while (1) loop
> and this code can be simplified a little.
> 
> 3) Does this make sense?


When a request queue exits, cfq_exit_queue(), it will free up the
associated cic_index (ida_remove(&cic_index_ida, cfqd->cic_index)). All
the cic which are on the request queue will be marked as dead. Now this
cic_index is up for grab and can be re-allocated to a different request
queue.

Now if the same process does IO to this new queue we same cic_index as
old request queue, then it should find the dead key and drop it and
then allocated a new cic.

So it does sound that there can not be more than one dead key associated
with a cic_index at a time in ioc tree.

But keeping current code does not harm.

Thanks
Vivek

> 
> 
> Paul Bolle
> ---
>  block/cfq-iosched.c |   28 +++++++++++++---------------
>  1 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 1f96ad6..0d33d8c 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3120,22 +3120,20 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
>  		return cic;
>  	}
>  
> -	do {
> -		cic = radix_tree_lookup(&ioc->radix_root, cfqd->cic_index);
> -		rcu_read_unlock();
> -		if (!cic)
> -			break;
> -		if (unlikely(cic->key != cfqd)) {
> -			cfq_drop_dead_cic(cfqd, ioc, cic);
> -			rcu_read_lock();
> -			continue;
> -		}
> +	cic = radix_tree_lookup(&ioc->radix_root, cfqd->cic_index);
> +	rcu_read_unlock();
>  
> -		spin_lock_irqsave(&ioc->lock, flags);
> -		rcu_assign_pointer(ioc->ioc_data, cic);
> -		spin_unlock_irqrestore(&ioc->lock, flags);
> -		break;
> -	} while (1);
> +	if (!cic)
> +		return NULL;
> +
> +	if (unlikely(cic->key != cfqd)) {
> +		cfq_drop_dead_cic(cfqd, ioc, cic);
> +		return NULL;
> +	}
> +
> +	spin_lock_irqsave(&ioc->lock, flags);
> +	rcu_assign_pointer(ioc->ioc_data, cic);
> +	spin_unlock_irqrestore(&ioc->lock, flags);
>  
>  	return cic;
>  }
> -- 
> 1.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
