Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab1CNUHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:07:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:39364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1CNUHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:07:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,317,1297065600"; 
   d="scan'208";a="612861503"
Message-ID: <4D7E756E.1040701@intel.com>
Date: Mon, 14 Mar 2011 13:07:10 -0700
From: Darren Hart <darren.hart@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Darren Hart <darren@dvhart.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] futex: do not pagefault_disable in futex_atomic_cmpxchg_inatomic()
References: <20110307021127.GB31188@google.com> <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6> <20110309112550.GA3050@google.com> <alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6> <20110311021654.GA26122@google.com> <20110311024731.GB26122@google.com> <AANLkTinXxCMVozx-NKEVXJLNrB1V93VEAJ8FiHQHXY_=@mail.gmail.com> <alpine.LFD.2.00.1103140913010.2787@localhost6.localdomain6> <alpine.LFD.2.00.1103141126590.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103141126590.2787@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 06:56 AM, Thomas Gleixner wrote:
> On Mon, 14 Mar 2011, Thomas Gleixner wrote:
>> On Sun, 13 Mar 2011, Linus Torvalds wrote:
>>> On Thu, Mar 10, 2011 at 6:47 PM, Michel Lespinasse<walken@google.com>  wrote:
>> That's my fault.
>>
>> I really checked the call sites of futex_atomic_cmpxchg_inatomic() and
>> totally failed to see the one in handle_futex_death() which does not
>> use the helper function cmpxchg_futex_value_locked(). That helper
>> function is safe and does the right thing:
>>
>> 	pagefault_disable();
>> 	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
>> 	pagefault_enable();
>>
>> So, that means we have all call sites covered except one, which needs
>> to be fixed _AND_ also pushed into stable as all arch implementations
>> except ARM rely on the caller doing the pagefault_disable().
>
> After applying some coffee to my brain, I noticed that the ability to
> fault in handle_futex_death() is desired. The get_user() before that
> call covers the case where the futex is paged out, but it does not
> handle the case where the futex is in a non writeable mapping. That
> lacks a big fat comment at least.
>
> So the removal of the pagefault_disable() in ARM is correct, just the
> changelog and the comment there sucks. Sorry for not catching it.
>
> Thinking more about it. Adding a comment is to handle_futex_death() is
> good, but changing the code to make it entirely clear what is going on
> is even better.
>
> -------->
> Subject: futex: Deobfuscate handle_futex_death()
> From: Thomas Gleixner<tglx@linutronix.de>
> Date: Mon, 14 Mar 2011 10:34:35 +0100
>
> handle_futex_death() uses futex_atomic_cmpxchg_inatomic() without
> disabling page faults. That's ok, but totally non obvious.
>
> We don't hold locks so we actually can and want to fault here, because
> the get_user() before futex_atomic_cmpxchg_inatomic() does not
> guarantee a R/W mapping.
>
> We could just add a big fat comment to explain this, but actually
> changing the code so that the functionality is entirely clear is
> better.
>
> Use the helper function which disables page faults around the
> futex_atomic_cmpxchg_inatomic() and handle a fault with a call to
> fault_in_user_writeable() as all other places in the futex code do as
> well.
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>

Acked-by: Darren Hart <dvhart@linux.intel.com>

> ---
>   kernel/futex.c |   17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
>
> Index: linux-2.6-tip/kernel/futex.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/futex.c
> +++ linux-2.6-tip/kernel/futex.c
> @@ -2458,9 +2458,20 @@ retry:
>   		 * userspace.
>   		 */
>   		mval = (uval&  FUTEX_WAITERS) | FUTEX_OWNER_DIED;
> -		if (futex_atomic_cmpxchg_inatomic(&nval, uaddr, uval, mval))
> -			return -1;
> -
> +		/*
> +		 * We are not holding a lock here, but we want to have
> +		 * the pagefault_disable/enable() protection because
> +		 * we want to handle the fault gracefully. If the
> +		 * access fails we try to fault in the futex with R/W
> +		 * verification via get_user_pages. get_user() above
> +		 * does not guarantee R/W access. If that fails we
> +		 * give up and leave the futex locked.
> +		 */
> +		if (cmpxchg_futex_value_locked(&nval, uaddr, uval, mval)) {
> +			if (fault_in_user_writeable(uaddr))
> +				return -1;
> +			goto retry;
> +		}
>   		if (nval != uval)
>   			goto retry;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
