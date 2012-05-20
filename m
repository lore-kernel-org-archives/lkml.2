Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab2ETXWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 19:22:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58728 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2ETXWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 19:22:35 -0400
Date: Sun, 20 May 2012 16:22:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] pidmap: Use GFP_ATOMIC to allocate page (was: Re: [
 00/54] 3.0.32-stable review)
In-Reply-To: <CA+55aFwGpDtMR=8GfDqyZGdw_pQFxG-EL15LaNm0wVoXZChXSA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205201333210.10189@chino.kir.corp.google.com>
References: <20120518212656.GA4992@kroah.com> <20120519010105.GB18264@home.goodmis.org> <20120519042038.GB11939@kroah.com> <1337479307.32434.16.camel@gandalf.stny.rr.com> <alpine.DEB.2.00.1205191930310.24674@chino.kir.corp.google.com>
 <CA+55aFwGpDtMR=8GfDqyZGdw_pQFxG-EL15LaNm0wVoXZChXSA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2012, Linus Torvalds wrote:

> > Why wasn't this caught by gfp_allowed_mask in slab_pre_alloc_hook()?
> > GFP_KERNEL should be allowed in this context.
> 
> We set gfp_allowed_mask to allow all allocations before this point: it
> happens when we enable interrupts fairly early during start_kernel().
> 
> So by the time pidmap_init() is called, GFP_KERNEL does imply that
> scheduling can happen.
> 

Steven notes that he's using CONFIG_PREEMPT_VOLUNTARY which means all 
might_sleep()'s in the kernel actually get turned into cond_resched()'s.  
I had thought that might_sleep() and might_sleep_if() such as in the slab 
allocators were simply for CONFIG_DEBUG_ATOMIC_SLEEP, but it has been 
hijacked for other purposes.  Do we really want to infuse cond_resched()'s 
on every slab allocation for desktop users who are urged in the Kconfig to 
enable CONFIG_PREEMPT_VOLUNTARY?

> Which does imply that we set gfp_allowed_mask *much* too early. We
> still cannot schedule at that point (well, at least there's a comment
> saying so):
> 
>         /*
>          * Disable preemption - early bootup scheduling is extremely
>          * fragile until we cpu_idle() for the first time.
>          */
>         preempt_disable();
> 
> so logically we should move the gfp_allowed_mask setting down to where
> we really are properly alive.
> 
> How about moving it down to after we've done the full smp_init() and
> after we've actually done the first schedule and have proper idle
> CPU's?
> 
> Something like the attached (UNTESTED!) patch?
> 
>  init/main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 44b2433334c7..0cf00943d755 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -560,9 +560,6 @@ asmlinkage void __init start_kernel(void)
>  	early_boot_irqs_disabled = false;
>  	local_irq_enable();
>  
> -	/* Interrupts are enabled now so all GFP allocations are safe. */
> -	gfp_allowed_mask = __GFP_BITS_MASK;
> -
>  	kmem_cache_init_late();
>  
>  	/*
> @@ -861,6 +858,9 @@ static int __init kernel_init(void * unused)
>  	smp_init();
>  	sched_init_smp();
>  
> +	/* Now we're finally set up and can do any allocation */
> +	gfp_allowed_mask = __GFP_BITS_MASK;
> +
>  	do_basic_setup();
>  
>  	/* Open the /dev/console on the rootfs, this should never fail */

I think this may be unnecessarily too late; smp_init() will rely on the 
arch-dependent cpu_up to guarantee that cpu_idle() has been called and 
sched_init_smp() seems to think we can do GFP_KERNEL.

So putting this in between smp_init() and sched_init_smp() may be the 
first time we can absolutely guarantee that we are scheduable.  BUT, we 
typically become schedulable when kernel_init() returns from the 
wait_for_completion(&kthreadd_done) because cpu_idle() has been called in 
rest_init() right after doing complete(&kthreadd_done) so it's slightly 
racy.

I think we should look in between that wait_for_completion() and 
smp_init() to determine if there's anything that would benefit from 
GFP_KERNEL over GFP_NOWAIT and I can't see anything.  I do think 
sched_init_smp() unnecessarily suppresses __GFP_WAIT with your patch, so 
perhaps it should be moved right before it if we're actually going to 
allow CONFIG_PREEMPT_VOLUNTARY to schedule on might_sleep()'s.
