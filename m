Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2ETCdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:33:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58489 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab2ETCdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:33:02 -0400
Date: Sat, 19 May 2012 19:32:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] pidmap: Use GFP_ATOMIC to allocate page (was: Re: [
 00/54] 3.0.32-stable review)
In-Reply-To: <1337479307.32434.16.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1205191930310.24674@chino.kir.corp.google.com>
References: <20120518212656.GA4992@kroah.com> <20120519010105.GB18264@home.goodmis.org> <20120519042038.GB11939@kroah.com> <1337479307.32434.16.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012, Steven Rostedt wrote:

> Ran 18 tests against 3.0.32-rc, 2 failed (16 passed!). One failed by a
> lock up (still looking into it) and the other is this one:
> 
> Calibrating delay loop (skipped), value calculated using timer frequency.. 4799.59 BogoMIPS (lpj=2399799)
> pid_max: default: 32768 minimum: 301
> BUG: scheduling while atomic: swapper/0/0x10000002
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 3.1.0-rc9-test+ #1
> Call Trace:
>  [<ffffffff81435b3e>] __schedule_bug+0x57/0x5b
>  [<ffffffff8143c44f>] __schedule+0x90/0x672
>  [<ffffffff810636dd>] ? kzalloc.constprop.2+0x24/0x26
>  [<ffffffff810460d1>] __cond_resched+0x23/0x2f
>  [<ffffffff8143ca83>] _cond_resched+0x14/0x1d^M
>  [<ffffffff810f7cd3>] slab_pre_alloc_hook.isra.52+0x28/0x2c
>  [<ffffffff810f8b1a>] kmem_cache_alloc_trace+0x29/0xbd
>  [<ffffffff810636dd>] kzalloc.constprop.2+0x24/0x26
>  [<ffffffff81b7a434>] pidmap_init+0x81/0xc0
>  [<ffffffff81b61b03>] start_kernel+0x330/0x3c2
>  [<ffffffff81b612c4>] x86_64_start_reservations+0xaf/0xb3
>  [<ffffffff81b61140>] ? early_idt_handlers+0x140/0x140
>  [<ffffffff81b613ca>] x86_64_start_kernel+0x102/0x111
> Security Framework initialized
> 
> Had CONFIG_SLUB, IRQ_FORCED_THREADING and voluntary preempt enabled.
> Seems the might_resched() check from might_sleep_if() in
> pre_alloc_hook() caused a schedule in early boot (pidmap_init). Not sure
> why it scheduled that early, perhaps a threaded interrupt was added? I
> haven't been able to reproduce it again.
> 
> Perhaps we should not be using GFP_KERNEL when allocating memory for
> pidmap_init()? As we have preemption disabled at this point, we should
> be using GFP_ATOMIC. Also add a BUG_ON if the page fails to get
> allocated.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> This patch is against 3.4-rc2 (just happened to be a kernel checkout I
> had).
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 9f08dfa..32dab20 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -563,7 +563,9 @@ void __init pidmap_init(void)
>  				PIDS_PER_CPU_MIN * num_possible_cpus());
>  	pr_info("pid_max: default: %u minimum: %u\n", pid_max, pid_max_min);
>  
> -	init_pid_ns.pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	/* Preemption is still disabled at this point */
> +	init_pid_ns.pidmap[0].page = kzalloc(PAGE_SIZE, GFP_ATOMIC);
> +	BUG_ON(!init_pid_ns.pidmap[0].page);
>  	/* Reserve PID 0. We never call free_pidmap(0) */
>  	set_bit(0, init_pid_ns.pidmap[0].page);
>  	atomic_dec(&init_pid_ns.pidmap[0].nr_free);

Why wasn't this caught by gfp_allowed_mask in slab_pre_alloc_hook()?  
GFP_KERNEL should be allowed in this context.
