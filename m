Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1HDLqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:46:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33958 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1HDLqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:46:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110801154636.GA2096@zod.bos.redhat.com>
References: <20110801154636.GA2096@zod.bos.redhat.com>
Date: Thu, 4 Aug 2011 07:46:03 -0400
Message-ID: <CA+5PVA5EZWHv_tuzA22twGQ7rZZ2zhqi1zs6OiFbpORiiYbzMg@mail.gmail.com>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
From: Josh Boyer <jwboyer@gmail.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 11:46 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> We're seeing a scheduling while atomic backtrace in rawhide from pidmap_init
> (https://bugzilla.redhat.com/show_bug.cgi?id=726877).  While this seems
> mostly harmless given that there isn't anything else to schedule to at
> this point, I do wonder why things are marked as needing rescheduled so
> early.
>
> We get to might_sleep through the might_sleep_if call in
> slab_pre_alloc_hook because both kzalloc and KMEM_CACHE are called with
> GFP_KERNEL.  That eventually has a call chain like:
>
> might_resched->_cond_resched->should_resched
>
> which apparently returns true.  Why the initial thread says it should
> reschedule at this point, I'm not sure.
>
> I tried cheating by making the kzalloc call in pidmap_init use GFP_IOFS
> instead of GFP_KERNEL to avoid the might_sleep_if call, and that worked
> but I can't do the same for the kmalloc calls in kmem_cache_create, so
> getting to the bottom of why should_resched is returning true seems to
> be a better approach.

A bit more info on this.

What seems to be happening is that late_time_init is called, which
gets around to calling hpet_time_init, which enables the HPET, and
then calls setup_default_timer_irq.  setup_default_timer_irq in
arch/x86/kernel/time.c calls setup_irq with the timer_interrupt
handler.

At this point the timer interrupt hits, and then tick_handle_periodic is called

timer int
tick_handle_periodic -> tick_periodic -> update_process_times ->
rcu_check_callbacks -> rcu_pending ->
__rcp_pending -> set_need_resched (this is called around line 1685 in
kernel/rcutree.c)

So what's happening is that once the timer interrupt starts, RCU is
coming in and marking current as needing reschedule, and that in turn
makes the slab_pre_alloc_hook -> might_sleep_if -> might_sleep ->
might_resched -> _cond_resched to trigger when pidmap_init calls
kzalloc later on and produce the oops below later on in the init
sequence.  I believe we see this because of all the debugging options
we have enabled in the kernel configs.

This might be normal for all I know, but the oops is rather annoying.
It seems RCU isn't in a quiescent state, we aren't preemptible yet,
and it _really_ wants to reschedule things to make itself happy.
Anyone have any thoughts on how to either keep RCU from marking
current as needing reschdule so early, or otherwise working around the
bug?

josh

[    0.007005] pid_max: default: 32768 minimum: 301
[    0.008619] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.009004] no locks held by swapper/0.
[    0.010005] Modules linked in:
[    0.010628] Pid: 0, comm: swapper Not tainted
3.1.0-0.rc0.git18.1.fc17.x86_64 #17
[    0.011004] Call Trace:
[    0.012009]  [<ffffffff814e5c9e>] __schedule_bug+0x75/0x7a
[    0.013011]  [<ffffffff814edced>] schedule+0x95/0x7bb
[    0.013621]  [<ffffffff81077199>] ? kzalloc.constprop.3+0x29/0x2b
[    0.014007]  [<ffffffff81056cbf>] __cond_resched+0x28/0x34
[    0.015006]  [<ffffffff814ee62b>] _cond_resched+0x19/0x22
[    0.015630]  [<ffffffff8112d1b1>] slab_pre_alloc_hook+0x3b/0x54
[    0.016006]  [<ffffffff8112f9ea>] kmem_cache_alloc_trace+0x29/0xca
[    0.017006]  [<ffffffff81077199>] kzalloc.constprop.3+0x29/0x2b
[    0.017646]  [<ffffffff81d6793b>] pidmap_init+0xb7/0xf6
[    0.018007]  [<ffffffff81d4f05a>] start_kernel+0x898/0x92f
[    0.019006]  [<ffffffff81d4e2c4>] x86_64_start_reservations+0xaf/0xb3
[    0.019653]  [<ffffffff81d4e140>] ? early_idt_handlers+0x140/0x140
[    0.020006]  [<ffffffff81d4e3ca>] x86_64_start_kernel+0x102/0x111
[    0.021288] Security Framework initialized
[    0.022011] SELinux:  Initializing.
