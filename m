Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0K2XHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:07:00 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57406 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0K2XG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:06:59 -0500
Date: Mon, 29 Nov 2010 15:06:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states
 after extended grace periods
Message-ID: <20101129230654.GG2182@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101124062212.GA2165@linux.vnet.ibm.com>
 <AANLkTimjZnAfeuAXU7oXPRG5=qJ2d7aZVoozSm88kXMT@mail.gmail.com>
 <20101124144240.GC2165@linux.vnet.ibm.com>
 <AANLkTi=EA09DACMNLUpTU8qH5wFPdXvOMQzJeejXX170@mail.gmail.com>
 <20101124161513.GA2207@linux.vnet.ibm.com>
 <AANLkTikbZUO6MbSC=uWYp4JRCdHPHrr5Z2_=to1YsC1X@mail.gmail.com>
 <20101124182051.GF2207@linux.vnet.ibm.com>
 <20101124234257.36870244@nowhere>
 <20101125145632.GC2162@linux.vnet.ibm.com>
 <20101126140639.GA1675@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101126140639.GA1675@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 03:06:43PM +0100, Frederic Weisbecker wrote:
> On Thu, Nov 25, 2010 at 06:56:32AM -0800, Paul E. McKenney wrote:
> > On Wed, Nov 24, 2010 at 11:42:57PM +0100, Frederic Weisbecker wrote:
> > > Le Wed, 24 Nov 2010 10:20:51 -0800,
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> a écrit :
> > > 
> > > > On Wed, Nov 24, 2010 at 06:38:45PM +0100, Frederic Weisbecker wrote:
> > > > > Yeah. I mean, I need to read how the code manages the different
> > > > > queues. But __rcu_process_gp_end() seems to sum it up quite well.
> > > > 
> > > > For advancing callbacks, that is the one!  For invocation of
> > > > callbacks, see rcu_do_batch().
> > > 
> > > Ok.
> > > 
> > > > > It's more like couldn't ever stop the tick. But that doesn't
> > > > > concern mainline. This is because I have a hook that prevents the
> > > > > tick from beeing stopped until rcu_pending() == 0.
> > > > 
> > > > That would certainly change behavior!!!  Why did you need to do that?
> > > > 
> > > > Ah, because force_quiescent_state() has not yet been taught about
> > > > dyntick-HPC, got it...
> > > 
> > > Oh actually I have taught it about that. For such isolated CPU that
> > > doesn't respond, it sends a specific IPI that will restart the tick if
> > > we are not in nohz.
> > > 
> > > The point in restarting the tick is to find some quiescent states and
> > > also to keep the tick for a little while for potential further grace
> > > periods to complete while we are in the kernel.
> > > 
> > > This is why I use rcu_pending() from the tick: to check if we still
> > > need the tick for rcu.
> > 
> > So if you have received the IPI, then you turn on the tick.  As soon as
> > rcu_pending() returns false, you can turn off the tick.  Once the tick
> > is off, you can go back to using rcu_needs_cpu(), right?  (At least
> > until that CPU receives another RCU IPI.)
> 
> Yep. Although there is already a test for rcu_needs_cpu() in
> tick_nohz_stop_sched_tick() that cancels the switch to nohz mode.

Sounds plausible.  ;-)

> > Either that or you need to check for both rcu_needs_cpu() -and-
> > rcu_pending().  Actually, you do need to check both during the time that
> > you have the tick on after receiving an RCU IPI.
> 
> Yeah.

Before I forget (again!) -- my thinking over the past few months has
been in terms of making rcu_pending() simpler by permitting more false
positives.  This makes sense if the only penalty is a needless softirq.
I am guessing that this sort of change would be a bad idea from your
viewpoint, but thought I should check.

> > > But it's not enough to track quiescent states. And we have no more timer
> > > interrupts to track them. So we need to restart the tick at least until
> > > we find a quiescent state for the grace period waiting for us.
> > > 
> > > But I may be missing something either :)
> > 
> > Well, I don't know whether or not you are missing it, but I do need to
> > get my act together and get RCU priority boosting ported from tiny
> > RCU to tree RCU.  Otherwise, force_quiescent_state() cannot do much
> > for preemptible RCU.
> 
> And if I understood it correctly, RCU priority boosting involves a new
> kthread that handles the callbacks instead of a softirq? So that you
> can give dynamic priority to this thread and so?

Yes, there will be a new kthread, and yes, because this allows its
priority to be adjusted independently of non-RCU stuff.  My current
design (and code, in the case of Tiny RCU) runs this at a fixed real-time
priority.  This priority can be adjusted via the chrt command, if desired,
though you can of course shoot yourself in the foot quite impressively
if you do this carelessly.

> How will that help in the preemptibe RCU case to force the quiescent
> state? Scheduling the kthread doesn't mean that every tasks that were
> preempted have been rescheduled and exited their rcu_read_unlock(), so
> I guess you plan another trickery :)

There is one kthread per CPU, so that there can be lock-free interaction
similar to that between mainline and the RCU softirq.  ;-)

But in the meantime, your approach is good for experimental purposes.
And might well be the way it needs to happen longer term, for all I know.

> > > > > Ah, I see what you mean. So you would suggest to even ignore those
> > > > > explicit QS report when in dynticj-hpc mode for CPUs that don't
> > > > > have callbacks?
> > > > > 
> > > > > Why not keeping them?
> > > > 
> > > > My belief is that people needing dyntick-HPC are OK with RCU grace
> > > > periods taking a few jiffies longer than they might otherwise.
> > > > Besides, when you are running dyntick-HPC, you aren't context
> > > > switching much, so keeping the tick doesn't buy you as much reduction
> > > > in grace-period latency.
> > > 
> > > But don't we still need the tick on such cases, (if we aren't in
> > > userspace) when a grace period starts, to note our grace periods?
> > > The rcu IPI itself doesn't seem to be sufficient for that.
> > > 
> > > I'm not sure I undrstand what you mean.
> > 
> > If there is a grace period, there must be an RCU callback.  The CPU that
> > has the RCU callback queued will keep its own tick going, because
> > rcu_needs_cpu() will return true.
> > 
> > The reason for ignoring the explicit QS reports in at least some of the
> > cases is that paying attention to them requires that the tick be enabled.
> > Which is fine for most workloads, but not so good for workloads that care
> > about OS jitter.
> 
> Is there another solution than restarting the tick a local CPU when we need
> a quiescent state from it? The simple IPI is not enough to ensure we find a
> decent grace period, in that case we need to restart the tick anyway if we
> are in the kernel, no?

It depends on the flavor of RCU.  RCU-sched and RCU-bh are taken
care of if the IPI handler does a set_need_resched() followed by a
raise_softirq().  Of course, perhaps set_need_resched() ends up restarting
the tick, depending on the order of checks in your schedule() path.

But it doesn't need to.  RCU's force_quiescent_state() would resend the
IPI periodically, which would force the CPU through its state machine.
The set_need_resched() would force a quiescent state, and the IPIs
following that would push RCU through the steps needed to note that the
corresponding CPU was no longer blocking the grace period.

Preemptible RCU works similarly, unless there is a low-priority task
that is being indefinitely preempted in an RCU read-side critical
section.  In that case, the low-priority task is in need of priority
boosting.

Or am I still missing something?

> Enjoy your turkey(s) ;-)

I did, thank you!  Only one turkey, though.  You must be confusing me
with my 30-years-ago self.  ;-)

							Thanx, Paul
