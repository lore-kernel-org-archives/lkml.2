Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1GZMQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:16:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44078 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1GZMQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:16:25 -0400
Date: Tue, 26 Jul 2011 15:15:36 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        DaveJones <davej@redhat.com>
Subject: Re: [GIT PULL] core/printk changes for v3.1
Message-ID: <20110726121536.GA3469@swordfish.minsk.epam.com>
References: <20110722125934.GA25433@elte.hu>
 <CACqU3MW-7_gCqNARdrPA5rZoZGLti+DMvkZsJN40VSDtU+VhpQ@mail.gmail.com>
 <1311679697.24752.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311679697.24752.28.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (07/26/11 13:28), Peter Zijlstra wrote:
> > WARNING: at /src/linux/linux/kernel/lockdep.c:2529
> 
> Not actually having reproduced the problem, does the below cure things?
>

Able to reproduce bad_area()-cases (http://lkml.org/lkml/2011/7/25/144). 
Previously:
kernel: [ 3634.499710] Call Trace:
kernel: [ 3634.499718]  [<ffffffff8103e630>] warn_slowpath_common+0x7e/0x96
kernel: [ 3634.499726]  [<ffffffff81474f38>] ? __bad_area_nosemaphore+0x35/0x1b9
kernel: [ 3634.499730]  [<ffffffff8103e65d>] warn_slowpath_null+0x15/0x17
kernel: [ 3634.499735]  [<ffffffff81072200>] trace_hardirqs_on_caller+0x6d/0x166
kernel: [ 3634.499741]  [<ffffffff81072306>] trace_hardirqs_on+0xd/0xf
kernel: [ 3634.499746]  [<ffffffff81474f38>] __bad_area_nosemaphore+0x35/0x1b9
kernel: [ 3634.499751]  [<ffffffff81475111>] bad_area+0x45/0x4c
kernel: [ 3634.499759]  [<ffffffff81482fb9>] do_page_fault+0x2da/0x48a
kernel: [ 3634.499766]  [<ffffffff810ebd41>] ? do_brk+0x24e/0x2a2
kernel: [ 3634.499774]  [<ffffffff812450bd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
kernel: [ 3634.499780]  [<ffffffff81480835>] page_fault+0x25/0x30
kernel: [ 3634.499784] ---[ end trace 642edd2b5d1b3694 ]---
kernel: [ 3634.499791] conftest[21907]: segfault at 0 ip 00007f591a6e7144 sp 00007fff03423550 error 4 in libc-2.14.so[7f591a62a000+157000]

which is not true for the patched kernel. That said, that at least 
bad_area() is cured for now.

Here is mine:
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Best,
	Sergey

 
> ---
> Subject: lockdep: Fix trace_hardirqs_on_caller()
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Jul 26 13:13:44 CEST 2011
> 
> Commit dd4e5d3ac4a ("lockdep: Fix trace_[soft,hard]irqs_[on,off]()
> recursion") made a bit of a mess of the various checks and error
> conditions.
> 
> In particular it moved the check for !irqs_disabled() before the
> spurious enable test, resulting in some warnings.
> 
> Reported-by: Arnaud Lacombe <lacombar@gmail.com>
> Reported-by: Dave Jones <davej@redhat.com>
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/lockdep.c |   30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -2485,23 +2485,9 @@ static void __trace_hardirqs_on_caller(u
>  {
>  	struct task_struct *curr = current;
>  
> -	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
> -		return;
> -
> -	if (unlikely(curr->hardirqs_enabled)) {
> -		/*
> -		 * Neither irq nor preemption are disabled here
> -		 * so this is racy by nature but losing one hit
> -		 * in a stat is not a big deal.
> -		 */
> -		__debug_atomic_inc(redundant_hardirqs_on);
> -		return;
> -	}
>  	/* we'll do an OFF -> ON transition: */
>  	curr->hardirqs_enabled = 1;
>  
> -	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
> -		return;
>  	/*
>  	 * We are going to turn hardirqs on, so set the
>  	 * usage bit for all held locks:
> @@ -2529,9 +2515,25 @@ void trace_hardirqs_on_caller(unsigned l
>  	if (unlikely(!debug_locks || current->lockdep_recursion))
>  		return;
>  
> +	if (unlikely(current->hardirqs_enabled)) {
> +		/*
> +		 * Neither irq nor preemption are disabled here
> +		 * so this is racy by nature but losing one hit
> +		 * in a stat is not a big deal.
> +		 */
> +		__debug_atomic_inc(redundant_hardirqs_on);
> +		return;
> +	}
> +
>  	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
>  		return;
>  
> +	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
> +		return;
> +
> +	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
> +		return;
> +
>  	current->lockdep_recursion = 1;
>  	__trace_hardirqs_on_caller(ip);
>  	current->lockdep_recursion = 0;
> 
