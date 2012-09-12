Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab2ILNwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:52:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39390 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab2ILNwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:52:38 -0400
Date: Wed, 12 Sep 2012 15:52:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH tip/core/rcu 11/26] rcu: Exit RCU extended QS on user
 preemption
Message-ID: <20120912135154.GA17139@somewhere.redhat.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346950959.18408.47.camel@twins>
 <1346951591.18408.48.camel@twins>
 <20120910202611.GB19268@somewhere>
 <1347442413.2124.70.camel@twins>
 <20120912120627.GA14705@somewhere>
 <1347453696.15764.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347453696.15764.24.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:41:36PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-12 at 14:06 +0200, Frederic Weisbecker wrote:
> > 
> > 1) This can happen if something calls set_need_resched() while no other task is
> > on the runqueue.
> 
> People really shouldn't be doing that... I think I know why RCU does
> this, but yuck. I also think RCU can avoid doing this, but its a toss up
> if that's worth the trouble.

There are other places that do this. Look at:

$ git grep set_need_resched drivers

drivers/gpu/drm/i915/i915_gem.c:                set_need_resched();
drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
drivers/gpu/drm/udl/udl_gem.c:          set_need_resched();

> 
> > 2) Remote wake up done but we haven't yet received the schedule IPI.
> > 
> > 3) Non IPI remote wakeup you're referring above, I'm not sure
> > what you mean though.
> 
> Well there's two ways of doing remote wakeups, one is doing the wakeup
> from the waking cpu and sending an IPI over to reschedule iff you need
> wakeup-preemption, the other is queueing the task remotely and sending
> an IPI to do the wakeup on the remote cpu.
> 
> The former has the problem, the latter not. 

In the former case, if we don't need preemption, we don't call resched_task()
and TIF_RESCHED is not set. So the arch code simply doesn't call schedule_user().

If we need wakeup-preemption, then the problem becomes the 2) above.

Am I missing something?

> 
> See ttwu_queue().
> 
> We could of course mandate that all remote wakeups to special nohz cpus
> get queued.

In any case, I think this is good idea to force remote wake ups in nohz cpus,
at least when rq->nr_running becomes 2.

In my draft branch, I send an IPI from inc_nr_running() when nr_running becomes 2,
so this covers every rq enqueuing scenario, not only wake up. But if we force
queued wakeups, I can avoid sending that specific IPI in wake up cases.

> That would just leave us with RCU and it would simply not
> send resched IPIs to extended quiescent CPUs anyway, right?

RCU doesn't send anymore IPIs to kick out CPUs that are delaying grace
periods. That was not really useful because it wasn't calling set_need_resched(task_cur(cpu))
before doing that. And if it was doing that, we would have missed some bugs
by runtime fixing culprits of stalls.

But RCU calls set_need_resched() from other places like rcu_pending() that
is called from rcu_check_callbacks(). IIRC, this is called
from the tick.

So if RCU sets TIF_RESCHED from the tick, we may call schedule_user()
before that tick resumes userspace.

The other one is on stall detection.

> So at that point all return to user schedule() calls have nr_running > 1
> and the tick is running and RCU is not in extended quiescent state.
> Since either we had nr_running > 1 and pre and post state are the same,
> or we had nr_running == 1 and we just got a fresh wakeup pushing it to
> 2, the wakeup will have executed on our cpu and have re-started the tick
> and kicked RCU into active gear again.

If we can guarantee that, but we have yet to make it clear with set_need_resched()
callers, then we can certainly remove the rcu_user_exit() call in that function.
RCU lockdep would detect what we forgot to think about anyway.

But the rcu_user_enter() call is still valid in the end of schedule_user(). It's going
to be useful only if we stop the tick right after returning from that schedule call
though. The possible window is very thin so it's probably not that worth the optimization.
We can still wait for another tick to stop the timer.

> 
> We cannot hit return to user schedule() with nr_running == 0, simply
> because in that case there's no userspace to return to, only the idle
> thread and that's very much not userspace :-)

Sure :)
 
> Hmm ?

Also I forgot one thing: if CONFIG_RCU_USER_QS is not set, I need to call schedule()
directly instead of schedule_user(). We don't need that intermediate call in this
configuration.
