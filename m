Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0KXSU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:20:57 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45435 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab0KXSUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:20:55 -0500
Date: Wed, 24 Nov 2010 10:20:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states
 after extended grace periods
Message-ID: <20101124182051.GF2207@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1290558673-23580-2-git-send-crap-fweisbec@gmail.com>
 <20101124005820.GH8056@linux.vnet.ibm.com>
 <AANLkTikhGErGQrFB-QNiYjWt2PqRGdF+m3kOkt2tmnER@mail.gmail.com>
 <AANLkTinFhEf1XVSRYuL+JL=JETLZ6cz3GYCR8CL3ex8X@mail.gmail.com>
 <20101124062212.GA2165@linux.vnet.ibm.com>
 <AANLkTimjZnAfeuAXU7oXPRG5=qJ2d7aZVoozSm88kXMT@mail.gmail.com>
 <20101124144240.GC2165@linux.vnet.ibm.com>
 <AANLkTi=EA09DACMNLUpTU8qH5wFPdXvOMQzJeejXX170@mail.gmail.com>
 <20101124161513.GA2207@linux.vnet.ibm.com>
 <AANLkTikbZUO6MbSC=uWYp4JRCdHPHrr5Z2_=to1YsC1X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikbZUO6MbSC=uWYp4JRCdHPHrr5Z2_=to1YsC1X@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 06:38:45PM +0100, Frederic Weisbecker wrote:
> 2010/11/24 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Wed, Nov 24, 2010 at 04:45:11PM +0100, Frederic Weisbecker wrote:
> >> 2010/11/24 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> >> > On Wed, Nov 24, 2010 at 02:48:46PM +0100, Frederic Weisbecker wrote:
> >> CPU 1, the one that was idle :-D
> >>
> >> So CPU 1 rdp did catch up with node and state for its completed field.
> >> But not its pgnum yet.
> >
> > OK, I will need to take a closer look at the rdp->gpnum setting.
> 
> Ok, do you want me to resend the patch with the changelog changed accordingly
> to our discussion or?

Please!

> >> >> >> > Now we call rcu_check_quiescent_state() -> check_for_new_grace_period()
> >> >> >> > -> note_new_gpnum() and then we end up a requested quiescent state while
> >> >> >> > every grace periods are completed.
> >> >> >>
> >> >> >> Sorry I should have described that in the changelogs but my ideas
> >> >> >> weren't as clear as they
> >> >> >> are now (at least I feel they are, doesn't mean they actually are ;)
> >> >> >> Chasing these RCU bugs for too much hours has toasted my brain..
> >> >> >
> >> >> > Welcome to my world!!!  But keep in mind that an extra timer tick
> >> >> > or two is much preferable to a potential hang!  And you only get
> >> >> > the extra timer tick if there was some other reason that the
> >> >> > CPU came out of nohz mode, correct?
> >> >>
> >> >> Yeah, either because of a timer, hrtimer, or a reschedule.
> >> >> But you still generate a spurious softirq in this scheme.
> >> >
> >> > Eliminating spurious softirqs is a good thing, but let's review the
> >> > overall priorities (probably missing a few, but this should give you
> >> > an overall view):
> >> >
> >> > 1.      No too-short grace periods!!!
> >>
> >> Oh, I did not know that. Is it to avoid too much
> >> short series of callbacks execution or?
> >
> > To avoid breaking RCU's fundamental guarantee.  ;-)
> >
> > It is easy to create bugs where a CPU thinks that it needs to respond
> > to the grace period based on a prior quiescent state, but unknown to
> > it that grace period has finished and a new one has started.  This
> > CPU might then wrongly report a quiescent state against the new grace
> > period.  Needless to say, this is very very very very very very bad.
> 
> Aaah ok. I thought you were talking about the time of a correct grace period,
> not a bug that would make it seem shorter than it actually is.
> 
> Ok. Of course, priority number 1.

;-)

> >> > 7.      Let CPUs that can do so go to sleep immediately (as opposed to
> >> >        waiting a few milliseconds).
> >> >
> >> > 8.      Avoid spurious softirqs.
> >>
> >> Avoiding spurious softirqs bring us back to 7, even though it's not a matter
> >> of ms but rather us.
> >
> > Microseconds should not be a problem as long as they are rare.  Milliseconds
> > are a problem for the battery-powered folks as well as for people who care
> > about OS jitter.
> 
> Right.
> 
> 
> >> >> Two in fact: one because of the rnp->completed != rsp->completed condition
> >> >> in rcu_pending(), another one because when we update the pgnum, we
> >> >> always start chasing QS, regardless of the last GP beeing completed or not.
> >> >
> >> > OK -- is this an example of #8 above, or is it really #7?  I am absolutely
> >> > not worried about a pair of back-to-back softirqs, and I don't believe
> >> > that you should be, either.  ;-)
> >>
> >> This seems to be 8 and 7.
> >>
> >> A pair of back-to-back softirqs is no huge deal, but still time
> >> consuming, spurious, etc...
> >> if we can easily spott they are useless, why not get rid of them. At
> >> least we can easily
> >> and reliably avoid the second one from note_new_gpnum().
> >
> > As long as I can prove to myself that the patch that gets rid of them
> > does not cause other problems.  ;-)
> 
> :)
> 
> >> >> > Which is why checking the rnp fields makes more sense to me, actually.
> >> >> > Acquiring rnp->lock is much less painful than pinning down the rsp state.
> >> >>
> >> >> Right.
> >> >>
> >> >> Another thing, we  already have the (rnp->gpnum) != rdp->gpnu check in
> >> >> rcu_pending(),
> >> >> why also checking (rnp->completed) != rdp->completed) ?
> >> >
> >> > Because if (rnp->completed != rdp->completed), we might need to process
> >> > some callbacks, either advancing them or invoking them.
> >>
> >> The rdp->nxttail in rcu is still an obscur part for me, so I just believe you :)
> >
> > It is just the place that the pending rcu_head callbacks are stored.
> 
> Yeah. I mean, I need to read how the code manages the different queues.
> But __rcu_process_gp_end() seems to sum it up quite well.

For advancing callbacks, that is the one!  For invocation of callbacks,
see rcu_do_batch().

> >> > By the way, have you introduced a config variable for your HPC dynticks
> >> > changes?
> >>
> >> I will, because I'll have to touch some fast path and I would prefer to do
> >> that compile-conditional.
> >>
> >> But for now I don't care and experiment drafts :)
> >
> > Well, if any of the softirq/tick streamlining in RCU is risky, it needs
> > to go under that same #ifdef!  ;-)
> 
> Sure, if something needs a reorg or a change even in the dyntick-hpc
> off-case code,
> I'll propose that to you, like I did for these two patches.
> 
> But I'll try to keep the invasive changes that are only for
> dyntick-hpc only under that config.

Sounds good!

> >> I'm quite close to something that seems to work well BTW, those series of
> >> softirq were my latest problem as it made rcu_pending() returning 1 for
> >> a good while and I coudn't stop the tick. After the 2nd patch it should be
> >> fine now, I hope.
> >
> > By "couldn't stop the tick" you mean "the tick went on a few times more
> > than you like" or do you really mean "couldn't ever stop the tick"?
> > My guess is the former.  If there were problems like the latter, Arjan
> > would probably have beat me up about it long ago!
> 
> It's more like couldn't ever stop the tick. But that doesn't concern mainline.
> This is because I have a hook that prevents the tick from beeing stopped
> until rcu_pending() == 0.

That would certainly change behavior!!!  Why did you need to do that?

Ah, because force_quiescent_state() has not yet been taught about
dyntick-HPC, got it...

> In mainline it doesn't prevent the CPU from going nohz idle though, because
> the softirq is armed from the tick. Once the softirq is processed, the CPU
> can go to sleep. On the next timer tick it would again raise the softirq and
> then could again go to sleep, etc..

You lost me on this one.  If the CPU goes to sleep (AKA enters dyntick-idle
mode, right?), then there wouldn't be a next timer tick, right?

> I still have a trace of that, with my rcu_pending() hook, in
> dyntick-hpc, that kept
> returning 1 during at least 100 seconds and on each tick.
> I did not go really further into this from my code as I immediately
> switched to tip:master
> to check if the problem came from my code or not.
> And then I discovered that rcu_pending() indeed kept returning 1 for some while
> in mainline (don't remember how much could be "some while" though), I
> saw all these
> spurious rcu softirq at each ticks caused by rcu_pending() and for
> random time slices:
> probably between a wake up from idle and the next grace period, if my
> theory is right, and I
> think that happened likely with bh flavour probably because it's
> subject to less grace periods.
> 
> And this is what the second patch fixes in mainline and that also
> seems to fix my issue in
> dyntick-hpc.
> 
> Probably it happened more easily on dynctick-hpc as I was calling
> rcu_pending() after
> calling rcu_enter_nohz() (some buggy part of mine).

OK, but that is why dyntick-idle is governed by rcu_needs_cpu() rather
than rcu_pending().  But yes, need to upgrade force_quiescent_state().

One hacky way to do that would be to replace smp_send_reschedule() with
an smp_call_function_single() that invoked something like the following
on the target CPU:

	static void rcu_poke_cpu(void *info)
	{
		raise_softirq(RCU_SOFTIRQ);
	}

So rcu_implicit_offline_qs() does something like the following in place
of the smp_send_reschedule():

	smp_call_function_single(rdp->cpu, rcu_poke_cpu, NULL, 0);

The call to set_need_resched() can remain as is.

Of course, a mainline version would need to be a bit more discerning,
but this should do work just fine for your experimental use.

This should allow you to revert back to rcu_needs_cpu().

Or am I missing something here?

> >> >  Longer term, __rcu_pending() for your HPC dynticks case
> >> > could check for the current CPU having any callbacks before the call to
> >> > check_cpu_stalls(), as in rcu_needs_cpu_quick_check().  That way, the
> >> > CPUs with callbacks would drive the RCU core state machine.
> >>
> >> Ah, because currently every CPUs calling rcu_pending() can be pulled into
> >> handling the state machine because of this check, right?
> >>
> >>         /* Has an RCU GP gone long enough to send resched IPIs &c? */
> >>       if (rcu_gp_in_progress(rsp) &&
> >>           ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies)) {
> >>               rdp->n_rp_need_fqs++;
> >>               return 1;
> >>
> >> So the goal would be to let this job to CPUs that have callbacks, right?
> >
> > In the dynticks-HPC case, yes.
> >
> >> > We don't
> >> > necessarily want this in the common case because it can increase
> >> > grace-period latency
> >>
> >> Because it makes less CPUs to handle the grace period state machine?
> >
> > Not quite.  Here I am not worried about the dyntick-HPC case, but rather
> > the usual more-runnable-tasks-than-CPUs case.  Here, CPUs are context
> > switching frequently, so if they report their own quiescent states (even
> > when they don't happen to have any callbacks queued) the grace period will
> > complete more quickly.  After all, force_quiescent_state() doesn't even
> > get started until the third tick following the start of the grace period.
> 
> Ah, I see what you mean. So you would suggest to even ignore those
> explicit QS report when in dynticj-hpc mode for CPUs that don't have callbacks?
> 
> Why not keeping them?

My belief is that people needing dyntick-HPC are OK with RCU grace periods
taking a few jiffies longer than they might otherwise.  Besides, when you
are running dyntick-HPC, you aren't context switching much, so keeping
the tick doesn't buy you as much reduction in grace-period latency.

> >> > but it could be very useful in the HPC-dyntick
> >> > case -- eliminate any number of sources of spurious ticks with low
> >> > risk to the high-priority RCU properties.  There are some corresponding
> >> > changes required on the force_quiescent_state() path, but these are
> >> > reasonably straightforward.
> >>
> >> Ok, I may have a try at it (if I completely understand what you suggest :-)
> >> But first I'll try to get that dyntick mode with the current state, which seems
> >> to be enough for the basic desired functionality.
> >
> > If the two changes you have posted thus far are all you need, this does
> > sound like a good starting point.
> 
> For now yeah, it seems to work well. I may run into further surpises though :)

Perish the thought!!!  ;-)

							Thanx, Paul
