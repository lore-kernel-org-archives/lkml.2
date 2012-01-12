Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab2ALJxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:53:13 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48092 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2ALJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:53:08 -0500
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.15.19
Date: Thu, 12 Jan 2012 01:52:57 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com, manfred@colorfullife.com,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: avoid checking for constant
Message-ID: <20120112095257.GA2441@leaf>
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
 <20120112071431.GA1896@leaf>
 <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 10:25:23AM +0100, Jan Engelhardt wrote:
> rcu: avoid checking for constant
> 
> When compiling kernel or module code with -O0, "offset" is no longer
> considered a constant, and therefore always triggers the build error
> that BUILD_BUG_ON is defined to yield.
> 
> What is the rationale between the forced constant check,
> introduced in 9ab1544eb4196ca8d05c433b2eb56f74496b1ee3?

This question shouldn't live in the commit message.  Please replace it
with an explanation of the change instead.

> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  include/linux/rcupdate.h |   22 ++++------------------
>  1 files changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 2cf4226..5e7286d 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -795,24 +795,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>  #define RCU_INIT_POINTER(p, v) \
>  		p = (typeof(*v) __force __rcu *)(v)
>  
> -static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
> -{
> -	return offset < 4096;
> -}
> -
> -static __always_inline
> -void __kfree_rcu(struct rcu_head *head, unsigned long offset)
> -{
> -	typedef void (*rcu_callback)(struct rcu_head *);
> -
> -	BUILD_BUG_ON(!__builtin_constant_p(offset));
> -
> -	/* See the kfree_rcu() header comment. */
> -	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
> -
> -	call_rcu(head, (rcu_callback)offset);
> -}
> -
>  /**
>   * kfree_rcu() - kfree an object after a grace period.
>   * @ptr:	pointer to kfree
> @@ -836,6 +818,10 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
>   * Note that the allowable offset might decrease in the future, for example,
>   * to allow something like kmem_cache_free_rcu().
>   */
> +#define __kfree_rcu(head, offset) \
> +	call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset) + \
> +		 BUILD_BUG_ON_ZERO((offset) >= 4096))
> +

I had to stare at this for a while, and look up the definition of
BUILD_BUG_ON_ZERO.  Naturally I assumed that BUILD_BUG_ON_ZERO(arg)
meant BUILT_BUG_ON((arg) == 0), which would have made the logic
backwards here.  However, per the definition it just provides a
zero-returning version of BUILD_BUG_ON.  Ow.

In any case, __kfree_rcu has void return type, so how about just using
do { ... } while(0) and BUILD_BUG_ON instead?  That seems significantly
clearer.

Apart from that, I can live with this, though it seems horribly
backwards to replace an inline with a macro rather than the other way
around.

- Josh Triplett
