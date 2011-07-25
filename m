Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1GYB5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:57:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:33397 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab1GYB5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:57:09 -0400
Subject: Re: perf PPC: kernel panic with callchains and context switch
 events
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Ahern <dsahern@gmail.com>, Kumar Gala <galak@kernel.crashing.org>,
        Becky Bruce <beckyb@kernel.crashing.org>
Cc: Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <4E2C53E0.3020400@gmail.com>
References: <4E274F5F.7000604@gmail.com>  <4E2C53E0.3020400@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 11:55:49 +1000
Message-ID: <1311558949.25044.614.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-24 at 11:18 -0600, David Ahern wrote:
> On 07/20/2011 03:57 PM, David Ahern wrote:
> > I am hoping someone familiar with PPC can help understand a panic that
> > is generated when capturing callchains with context switch events.
> > 
> > Call trace is below. The short of it is that walking the callchain
> > generates a page fault. To handle the page fault the mmap_sem is needed,
> > but it is currently held by setup_arg_pages. setup_arg_pages calls
> > shift_arg_pages with the mmap_sem held. shift_arg_pages then calls
> > move_page_tables which has a cond_resched at the top of its for loop. If
> > the cond_resched() is removed from move_page_tables everything works
> > beautifully - no panics.
> > 
> > So, the question: is it normal for walking the stack to trigger a page
> > fault on PPC? The panic is not seen on x86 based systems.
> 
> Can anyone confirm whether page faults while walking the stack are
> normal for PPC? We really want to use the context switch event with
> callchains and need to understand whether this behavior is normal. Of
> course if it is normal, a way to address the problem without a panic
> will be needed.

Now that leads to interesting discoveries :-) Becky, can you read all
the way and let me know what you think ?

So, trying to walk the user stack directly will potentially cause page
faults if it's done by direct access. So if you're going to do it in a
spot where you can't afford it, you need to pagefault_disable() I
suppose. I think the problem with our existing code is that it's missing
those around __get_user_inatomic().

In fact, arguably, we don't want the hash code from modifying the hash
either (or even hashing things in). Our 64-bit code handles it today in
perf_callchain.c in a way that involves pretty much duplicating the
functionality of __get_user_pages_fast() as used by x86 (see below), but
as a fallback from a direct access which misses the pagefault_disable()
as well.

I think it comes from an old assumption that this would always be called
from an nmi, and the explicit tracepoints broke that assumption.

In fact we probably want to bump the NMI count, not just the IRQ count
as pagefault_disable() does, to make sure we prevent hashing. 

x86 does things differently, using __get_user_pages_fast() (a variant of
get_user_page_fast() that doesn't fallback to normal get_user_pages()).

Now, we could do the same (use __gup_fast too), but I can see a
potential issue with ppc 32-bit platforms that have 64-bit PTEs, since
we could end up GUP'ing in the middle of the two accesses.

Becky: I think gup_fast is generally broken on 32-bit with 64-bit PTE
because of that, the problem isn't specific to perf backtraces, I'll
propose a solution further down.

Now, on x86, there is a similar problem with PAE, which is handled by

 - having gup disable IRQs
 - rely on the fact that to change from a valid value to another valid
   value, the PTE will first get invalidated, which requires an IPI
   and thus will be blocked by our interrupts being off

We do the first part, but the second part will break if we use HW TLB
invalidation broadcast (yet another reason why those are bad, I think I
will write a blog entry about it one of these days).

I think we can work around this while keeping our broadcast TLB
invalidations by having the invalidation code also increment a global
generation count (using the existing lock used by the invalidation code,
all 32-bit platforms have such a lock).

>From there, gup_fast can be changed to, with proper ordering, check the
generation count around the loading of the PTE and loop if it has
changed, kind-of a seqlock.

We also need the NMI count bump if we are going to try to keep the
attempt at doing a direct access first for perfs.

Becky, do you feel like giving that a shot or should I find another
victim ? (Or even do it myself ... ) :-)

Cheers,
Ben.

> Thanks,
> David
> 
> > 
> >  [<b0180e00>]rb_erase+0x1b4/0x3e8
> >  [<b00430f4>]__dequeue_entity+0x50/0xe8
> >  [<b0043304>]set_next_entity+0x178/0x1bc
> >  [<b0043440>]pick_next_task_fair+0xb0/0x118
> >  [<b02ada80>]schedule+0x500/0x614
> >  [<b02afaa8>]rwsem_down_failed_common+0xf0/0x264
> >  [<b02afca0>]rwsem_down_read_failed+0x34/0x54
> >  [<b02aed4c>]down_read+0x3c/0x54
> >  [<b0023b58>]do_page_fault+0x114/0x5e8
> >  [<b001e350>]handle_page_fault+0xc/0x80
> >  [<b0022dec>]perf_callchain+0x224/0x31c
> >  [<b009ba70>]perf_prepare_sample+0x240/0x2fc
> >  [<b009d760>]__perf_event_overflow+0x280/0x398
> >  [<b009d914>]perf_swevent_overflow+0x9c/0x10c
> >  [<b009db54>]perf_swevent_ctx_event+0x1d0/0x230
> >  [<b009dc38>]do_perf_sw_event+0x84/0xe4
> >  [<b009dde8>]perf_sw_event_context_switch+0x150/0x1b4
> >  [<b009de90>]perf_event_task_sched_out+0x44/0x2d4
> >  [<b02ad840>]schedule+0x2c0/0x614
> >  [<b0047dc0>]__cond_resched+0x34/0x90
> >  [<b02adcc8>]_cond_resched+0x4c/0x68
> >  [<b00bccf8>]move_page_tables+0xb0/0x418
> >  [<b00d7ee0>]setup_arg_pages+0x184/0x2a0
> >  [<b0110914>]load_elf_binary+0x394/0x1208
> >  [<b00d6e28>]search_binary_handler+0xe0/0x2c4
> >  [<b00d834c>]do_execve+0x1bc/0x268
> >  [<b0015394>]sys_execve+0x84/0xc8
> >  [<b001df10>]ret_from_syscall+0x0/0x3c
> > 
> > Thanks,
> > David
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


