Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1HDOEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:04:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44105 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1HDOEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:04:48 -0400
Date: Thu, 4 Aug 2011 07:04:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110804140438.GT13065@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110801154636.GA2096@zod.bos.redhat.com>
 <CA+5PVA5EZWHv_tuzA22twGQ7rZZ2zhqi1zs6OiFbpORiiYbzMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA5EZWHv_tuzA22twGQ7rZZ2zhqi1zs6OiFbpORiiYbzMg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 07:46:03AM -0400, Josh Boyer wrote:
> On Mon, Aug 1, 2011 at 11:46 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> > We're seeing a scheduling while atomic backtrace in rawhide from pidmap_init
> > (https://bugzilla.redhat.com/show_bug.cgi?id=726877).  While this seems
> > mostly harmless given that there isn't anything else to schedule to at
> > this point, I do wonder why things are marked as needing rescheduled so
> > early.
> >
> > We get to might_sleep through the might_sleep_if call in
> > slab_pre_alloc_hook because both kzalloc and KMEM_CACHE are called with
> > GFP_KERNEL.  That eventually has a call chain like:
> >
> > might_resched->_cond_resched->should_resched
> >
> > which apparently returns true.  Why the initial thread says it should
> > reschedule at this point, I'm not sure.
> >
> > I tried cheating by making the kzalloc call in pidmap_init use GFP_IOFS
> > instead of GFP_KERNEL to avoid the might_sleep_if call, and that worked
> > but I can't do the same for the kmalloc calls in kmem_cache_create, so
> > getting to the bottom of why should_resched is returning true seems to
> > be a better approach.
> 
> A bit more info on this.
> 
> What seems to be happening is that late_time_init is called, which
> gets around to calling hpet_time_init, which enables the HPET, and
> then calls setup_default_timer_irq.  setup_default_timer_irq in
> arch/x86/kernel/time.c calls setup_irq with the timer_interrupt
> handler.
> 
> At this point the timer interrupt hits, and then tick_handle_periodic is called
> 
> timer int
> tick_handle_periodic -> tick_periodic -> update_process_times ->
> rcu_check_callbacks -> rcu_pending ->
> __rcp_pending -> set_need_resched (this is called around line 1685 in
> kernel/rcutree.c)
> 
> So what's happening is that once the timer interrupt starts, RCU is
> coming in and marking current as needing reschedule, and that in turn
> makes the slab_pre_alloc_hook -> might_sleep_if -> might_sleep ->
> might_resched -> _cond_resched to trigger when pidmap_init calls
> kzalloc later on and produce the oops below later on in the init
> sequence.  I believe we see this because of all the debugging options
> we have enabled in the kernel configs.
> 
> This might be normal for all I know, but the oops is rather annoying.
> It seems RCU isn't in a quiescent state, we aren't preemptible yet,
> and it _really_ wants to reschedule things to make itself happy.
> Anyone have any thoughts on how to either keep RCU from marking
> current as needing reschdule so early, or otherwise working around the
> bug?

The deal is that RCU realizes that RCU needs a quiescent state from
this CPU.  The set_need_resched() is intended to cause one.  But there
is not much point this early in boot, because the scheduler isn't going
to do anything anyway.  I can prevent this with the following patch,
but isn't this same thing possible later at runtime?

You really do need to be able to handle set_need_resched() at random
times, and at first glance it appears to me that the warning could be
triggered at runtime as well.  If so, the real fix is elsewhere, right?
Especially given that the patch imposes extra cost at runtime...

							Thanx, Paul

------------------------------------------------------------------------

rcu: Prevent early boot set_need_resched() from __rcu_pending()

There isn't a whole lot of point in poking the scheduler before there
are other tasks to switch to.  This commit therefore adds a check
for rcu_scheduler_fully_active in __rcu_pending() to suppress any
pre-scheduler calls to set_need_resched().  The downside of this approach
is additional runtime overhead in a reasonably hot code path.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d22dccb..9ccd19e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1724,7 +1724,8 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	check_cpu_stall(rsp, rdp);
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	if (rdp->qs_pending && !rdp->passed_quiesce) {
+	if (rcu_scheduler_fully_active &&
+	    rdp->qs_pending && !rdp->passed_quiesce) {
 
 		/*
 		 * If force_quiescent_state() coming soon and this CPU
