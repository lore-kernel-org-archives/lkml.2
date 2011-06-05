Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1FEQ7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:59:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52688 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1FEQ7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:59:08 -0400
Date: Sun, 5 Jun 2011 09:59:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] CFQ: use proper locking for cache of last hit cic
Message-ID: <20110605165903.GE6093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307291201.8545.46.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307291201.8545.46.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 06:26:40PM +0200, Paul Bolle wrote:
> io_context.last_cic is a (single entry) cache of the last hit
> cfq_io_context ("cic").
> 
> It turns out last_cic wasn't always accessed with io_context.lock held
> and under the correct RCU semantics. That meant that last_cic could be
> out of sync with the hlist it was supposed to cache, leading to hard to
> reproduce and hard to debug issues. Using proper locking makes those
> issues go away.
> 
> Many thanks to Vivek Goyal, Paul McKenney, and Jens Axboe, in suggesting
> various options, looking at all the debug output I generated, etc. If we
> hadn't done all that I would have never concluded that the best way to
> solve this issue was to, yet again, read the code looking for
> problematic sections.
> 
> This should finally resolve bugzilla.redhat.com/show_bug.cgi?id=577968

Good stuff!  A few minor comments below.

							Thanx, Paul

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  block/cfq-iosched.c |   27 +++++++++++++++++++--------
>  1 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 39e4d01..9206ee3 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2695,6 +2695,8 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
>  					 struct cfq_io_context *cic)
>  {
>  	struct io_context *ioc = cic->ioc;
> +	struct cfq_io_context *last_cic;
> +	unsigned long flags;
> 
>  	list_del_init(&cic->queue_list);
> 
> @@ -2704,8 +2706,13 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
>  	smp_wmb();
>  	cic->key = cfqd_dead_key(cfqd);
> 
> -	if (ioc->last_cic == cic)
> +	spin_lock_irqsave(&ioc->lock, flags);
> +	rcu_read_lock();
> +	last_cic = rcu_dereference(ioc->last_cic);
> +	rcu_read_unlock();
> +	if (last_cic == cic)
>  		rcu_assign_pointer(ioc->last_cic, NULL);

Because we are holding ioc->lock, no one else is permitted to change
the value of ioc->last_cic, correct?

If so, I suggest the following replacement for the above code,
starting at the rcu_read_lock():

	last_cic = rcu_dereference_protected(ioc->last_cic
					     lockdep_is_held(&ioc->lock));
	if (last_cic == cic)
		rcu_assign_pointer(ioc->last_cic, NULL);

> +	spin_unlock_irqrestore(&ioc->lock, flags);
> 
>  	if (cic->cfqq[BLK_RW_ASYNC]) {
>  		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
> @@ -3000,23 +3007,25 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
> 
>  /*
>   * We drop cfq io contexts lazily, so we may find a dead one.
> + *
> + * Called with ioc->lock held.
>   */
>  static void
>  cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
>  		  struct cfq_io_context *cic)
>  {
> -	unsigned long flags;
> +	struct cfq_io_context *last_cic;
> 
>  	WARN_ON(!list_empty(&cic->queue_list));
>  	BUG_ON(cic->key != cfqd_dead_key(cfqd));
> 
> -	spin_lock_irqsave(&ioc->lock, flags);
> -
> -	BUG_ON(ioc->last_cic == cic);
> +	rcu_read_lock();
> +	last_cic = rcu_dereference(ioc->last_cic);
> +	rcu_read_unlock();
> +	BUG_ON(last_cic == cic);

And the above insertion can be replaced with:

	BUG_ON(rcu_access_pointer(ioc->last_cic) == cic);

Use of rcu_access_pointer() is OK here because you are just testing
the value of the RCU-protected pointer, not actually dereferencing it.
Also, because you are just testing the value, you don't need to hold
the update-side lock.

> 
>  	radix_tree_delete(&ioc->radix_root, cfqd->cic_index);
>  	hlist_del_rcu(&cic->cic_node);
> -	spin_unlock_irqrestore(&ioc->lock, flags);
> 
>  	cfq_cic_free(cic);
>  }
> @@ -3035,8 +3044,10 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
>  	/*
>  	 * we maintain a last-hit cache, to avoid browsing over the tree
>  	 */
> +	spin_lock_irqsave(&ioc->lock, flags);
>  	cic = rcu_dereference(ioc->last_cic);

Is the above rcu_dereference() is the only reason that we are in this
RCU read-side critical section?  If so, you can drop the RCU read-side
critical section and use rcu_dereference_protected(), as noted earlier.

>  	if (cic && cic->key == cfqd) {
> +		spin_unlock_irqrestore(&ioc->lock, flags);
>  		rcu_read_unlock();
>  		return cic;
>  	}
> @@ -3052,12 +3063,12 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
>  			continue;
>  		}
> 
> -		spin_lock_irqsave(&ioc->lock, flags);
>  		rcu_assign_pointer(ioc->last_cic, cic);
> -		spin_unlock_irqrestore(&ioc->lock, flags);
>  		break;
>  	} while (1);
> 
> +	spin_unlock_irqrestore(&ioc->lock, flags);
> +
>  	return cic;
>  }
> 
> -- 
> 1.7.5.2
> 
> 
> 
