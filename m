Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab1COLaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:30:46 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43722 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab1COLan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:30:43 -0400
Date: Tue, 15 Mar 2011 04:30:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Message-ID: <20110315113038.GB2167@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D7F356C.8020903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7F356C.8020903@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 05:46:20PM +0800, Lai Jiangshan wrote:
> kfree_rcu() which was original proposed by Lai 2.5 years ago is one of
> the most important RCU TODO list entries, Lai and Manfred have worked on
> patches for this. This V4 patch is based on the Manfred's patch and
> the V1 of Lai's patch. (These two patches are almost the same
> in implementation, and this patch is mainly based on the Manfred's).
> 
> Lai's V1 patch: http://lkml.org/lkml/2008/9/18/1
> Manfred's patch: http://lkml.org/lkml/2009/1/2/115
> RCU TODO list: http://www.kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> 
> This new introduced API kfree_rcu() primitive kfree()s the specified memory
> after a RCU grace period elapses.
> 
> It replaces many simple "call_rcu(head, simple_kfree_callback)";
> These many simple_kfree_callback() instances just does
> 
> 	kfree(containerof(head,struct whatever_struct,rcu_member));
> 
> These simple_kfree_callback() instances are just duplicate code, we need
> a generic function for them.
> 
> And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
> queue any function which belong to the module, so a rcu_barrier() can
> be avoid when module exit. (If we queue any other function by call_rcu(),
> rcu_barrier() is still needed.)

Thank you for putting this together!  It does represent a nice
reduction in code size.

Once it settles out a bit, I intend to queue this patch.  It would be
best if the subsystems queue their own patches using kfree_rcu() once
this patch reaches mainline.

Seem reasonable?

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  include/linux/rcupdate.h |   40 ++++++++++++++++++++++++++++++++++++++++
>  kernel/rcutiny.c         |    2 +-
>  kernel/rcutree.c         |    2 +-
>  3 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 7d62909..18f7ade 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -777,4 +777,44 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
>  }
>  #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> 
> +static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
> +{
> +	return offset < 4096;
> +}
> +
> +static __always_inline
> +void __kfree_rcu(struct rcu_head *head, unsigned long offset)
> +{
> +	typedef void (*rcu_callback)(struct rcu_head *);
> +
> +	BUILD_BUG_ON(!__builtin_constant_p(offset));
> +	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
> +
> +	call_rcu(head, (rcu_callback)offset);
> +}
> +
> +extern void kfree(const void *);
> +
> +static inline void __rcu_reclaim(struct rcu_head *head)
> +{
> +	unsigned long offset = (unsigned long)head->func;
> +
> +	if (__is_kfree_rcu_offset(offset))
> +		kfree((void *)head - offset);
> +	else
> +		head->func(head);
> +}
> +
> +/**
> + * kfree_rcu() - kfree an object after a grace period.
> + * @ptr:	pointer to kfree
> + * @rcu_head:	the name of the struct rcu_head within the type of @ptr.
> + *
> + * Many rcu callbacks just call kfree() on the base structure. This helper
> + * function calls kfree internally. The rcu_head structure must be embedded
> + * in the to be freed structure.
> + */
> +#define kfree_rcu(ptr, rcu_head)					\
> +	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
> +
>  #endif /* __LINUX_RCUPDATE_H */
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 0c343b9..4d60fbc 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -167,7 +167,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
>  		prefetch(next);
>  		debug_rcu_head_unqueue(list);
>  		local_bh_disable();
> -		list->func(list);
> +		__rcu_reclaim(list);
>  		local_bh_enable();
>  		list = next;
>  		RCU_TRACE(cb_count++);
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index dd4aea8..b3c1aed 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1143,7 +1143,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
>  		next = list->next;
>  		prefetch(next);
>  		debug_rcu_head_unqueue(list);
> -		list->func(list);
> +		__rcu_reclaim(list);
>  		list = next;
>  		if (++count >= rdp->blimit)
>  			break;
> -- 
> 1.7.4
