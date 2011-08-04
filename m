Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1HDPGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1HDPGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:06:10 -0400
Date: Thu, 4 Aug 2011 11:06:03 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110804150603.GL2096@zod.bos.redhat.com>
References: <20110801154636.GA2096@zod.bos.redhat.com>
 <CA+5PVA5EZWHv_tuzA22twGQ7rZZ2zhqi1zs6OiFbpORiiYbzMg@mail.gmail.com>
 <20110804140438.GT13065@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110804140438.GT13065@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 07:04:38AM -0700, Paul E. McKenney wrote:
> On Thu, Aug 04, 2011 at 07:46:03AM -0400, Josh Boyer wrote:
> > On Mon, Aug 1, 2011 at 11:46 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> > > We're seeing a scheduling while atomic backtrace in rawhide from pidmap_init
> > > (https://bugzilla.redhat.com/show_bug.cgi?id=726877).  While this seems
> > > mostly harmless given that there isn't anything else to schedule to at
> > > this point, I do wonder why things are marked as needing rescheduled so
> > > early.
> > >
> > > We get to might_sleep through the might_sleep_if call in
> > > slab_pre_alloc_hook because both kzalloc and KMEM_CACHE are called with
> > > GFP_KERNEL.  That eventually has a call chain like:
> > >
> > > might_resched->_cond_resched->should_resched
> > >
> > > which apparently returns true.  Why the initial thread says it should
> > > reschedule at this point, I'm not sure.
> > >
> > > I tried cheating by making the kzalloc call in pidmap_init use GFP_IOFS
> > > instead of GFP_KERNEL to avoid the might_sleep_if call, and that worked
> > > but I can't do the same for the kmalloc calls in kmem_cache_create, so
> > > getting to the bottom of why should_resched is returning true seems to
> > > be a better approach.
> > 
> > A bit more info on this.
> > 
> > What seems to be happening is that late_time_init is called, which
> > gets around to calling hpet_time_init, which enables the HPET, and
> > then calls setup_default_timer_irq.  setup_default_timer_irq in
> > arch/x86/kernel/time.c calls setup_irq with the timer_interrupt
> > handler.
> > 
> > At this point the timer interrupt hits, and then tick_handle_periodic is called
> > 
> > timer int
> > tick_handle_periodic -> tick_periodic -> update_process_times ->
> > rcu_check_callbacks -> rcu_pending ->
> > __rcp_pending -> set_need_resched (this is called around line 1685 in
> > kernel/rcutree.c)
> > 
> > So what's happening is that once the timer interrupt starts, RCU is
> > coming in and marking current as needing reschedule, and that in turn
> > makes the slab_pre_alloc_hook -> might_sleep_if -> might_sleep ->
> > might_resched -> _cond_resched to trigger when pidmap_init calls
> > kzalloc later on and produce the oops below later on in the init
> > sequence.  I believe we see this because of all the debugging options
> > we have enabled in the kernel configs.
> > 
> > This might be normal for all I know, but the oops is rather annoying.
> > It seems RCU isn't in a quiescent state, we aren't preemptible yet,
> > and it _really_ wants to reschedule things to make itself happy.
> > Anyone have any thoughts on how to either keep RCU from marking
> > current as needing reschdule so early, or otherwise working around the
> > bug?
> 
> The deal is that RCU realizes that RCU needs a quiescent state from
> this CPU.  The set_need_resched() is intended to cause one.  But there
> is not much point this early in boot, because the scheduler isn't going
> to do anything anyway.  I can prevent this with the following patch,
> but isn't this same thing possible later at runtime?

Possibly, but I'm not sure at the moment.  The patch avoids the oops and
I haven't seen another once in some brief runtime testing.  (Trivial
fixing to make it apply to current linus.)

> You really do need to be able to handle set_need_resched() at random
> times, and at first glance it appears to me that the warning could be
> triggered at runtime as well.  If so, the real fix is elsewhere, right?
> Especially given that the patch imposes extra cost at runtime...

In staring at it for a while it seems to be a combination of being in
atomic context according to the scheduler but things in early boot using
GFP_KERNEL.  At the point we're at in the boot, that is perfectly legal
as it's not being called from an interrupt handler and the mm subsystem
should be all setup, but we're still really early in boot and preempt is
disabled.  As I mentioned before, KMEM_CACHE calls kmalloc with
GFP_KERNEL and I don't think we want to change that.

Once we're past early boot, I would expect that things running in true
atomic context won't be calling KMEM_CACHE or using GFP_KERNEL.  Or
maybe I hope?

I understand the desire to avoid another conditional, but I certainly
don't have any other suggestions at the moment.

josh
