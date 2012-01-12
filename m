Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2ALSmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 13:42:08 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38955 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2ALSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 13:42:04 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.15.19
Date: Thu, 12 Jan 2012 10:41:50 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com, manfred@colorfullife.com,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: avoid checking for constant
Message-ID: <20120112184150.GA8132@leaf>
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
 <20120112071431.GA1896@leaf>
 <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr>
 <20120112095257.GA2441@leaf>
 <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
 <20120112115830.GA3436@leaf>
 <alpine.LNX.2.01.1201121625060.25848@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1201121625060.25848@frira.zrqbmnf.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 04:38:52PM +0100, Jan Engelhardt wrote:
> On Thursday 2012-01-12 12:58, Josh Triplett wrote:
> >> Same impression here. BUILD_BUG_ON_ZERO was introduced by
> >> 
> >> commit 4552d5dc08b79868829b4be8951b29b07284753f
> >> Author: Jan Beulich <jbeulich@novell.com>
> >> Date:   Mon Jun 26 13:57:28 2006 +0200
> >> 
> >> while Rusty's CCAN archive calls it "BUILD_BUG_OR_ZERO" (since either 
> >> it's a bug, or returning neutral zero).
> >
> >Sounds like a good target for a fix at some point.
> 
> What names do you propose? I have BUILD_BUG_ON_EXPR for some of my code,
> though in the kernel, it has both _ON_ZERO and _ON_NULL.

BUILD_BUG_OR_ZERO (and BUILD_BUG_OR_NULL) seem like improvements over
_ON_ZERO and _ON_NULL; that would remove the ambiguity we both tripped
over.

> rcu: avoid checking for constant
> 
> When compiling kernel or module code with -O0, "offset" is no longer
> considered a constant, and therefore always triggers the build error
> that BUILD_BUG_ON is defined to yield.
> 
> Therefore, change the innards of kfree_rcu so that the offset is not
> tunneled through a function argument before checking it.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

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
> @@ -835,7 +817,18 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
>   *
>   * Note that the allowable offset might decrease in the future, for example,
>   * to allow something like kmem_cache_free_rcu().
> + *
> + * The BUILD_BUG_ON check must not involve any function calls, hence the
> + * checks are done in macros here.
>   */
> +#define __is_kfree_rcu_offset(offset) ((offset) < 4096)
> +
> +#define __kfree_rcu(head, offset) \
> +	do { \
> +		BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); \
> +		call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset)); \
> +	} while (0)
> +
>  #define kfree_rcu(ptr, rcu_head)					\
>  	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))

- Josh Triplett
