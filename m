Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0KXGWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:22:21 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50366 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab0KXGWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:22:19 -0500
Date: Tue, 23 Nov 2010 22:22:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states
 after extended grace periods
Message-ID: <20101124062212.GA2165@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
 <1290558673-23580-2-git-send-crap-fweisbec@gmail.com>
 <20101124005820.GH8056@linux.vnet.ibm.com>
 <AANLkTikhGErGQrFB-QNiYjWt2PqRGdF+m3kOkt2tmnER@mail.gmail.com>
 <AANLkTinFhEf1XVSRYuL+JL=JETLZ6cz3GYCR8CL3ex8X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinFhEf1XVSRYuL+JL=JETLZ6cz3GYCR8CL3ex8X@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 03:33:21AM +0100, Frederic Weisbecker wrote:
> 2010/11/24 Frederic Weisbecker <fweisbec@gmail.com>:
> > On Tue, Nov 23, 2010 at 04:58:20PM -0800, Paul E. McKenney wrote:
> >> On Wed, Nov 24, 2010 at 01:31:12AM +0100, Frederic Weisbecker wrote:
> >> > When a cpu is in an extended quiescent state, which includes idle
> >> > nohz or CPU offline, others CPUs will take care of the grace periods
> >> > on its behalf.
> >> >
> >> > When this CPU exits its extended quiescent state, it will catch up
> >> > with the last started grace period and start chasing its own
> >> > quiescent states to end the current grace period.
> >> >
> >> > However in this case we always start to track quiescent states if the
> >> > grace period number has changed since we started our extended
> >> > quiescent state. And we do this because we always assume that the last
> >> > grace period is not finished and needs us to complete it, which is
> >> > sometimes wrong.
> >> >
> >> > This patch verifies if the last grace period has been completed and
> >> > if so, start hunting local quiescent states like we always did.
> >> > Otherwise don't do anything, this economizes us some work and
> >> > an unnecessary softirq.
> >>
> >> Interesting approach!  I can see how this helps in the case where the
> >> CPU just came online, but I don't see it in the nohz case, because the
> >> nohz case does not update the rdp->completed variable.  In contrast,
> >> the online path calls rcu_init_percpu_data() which sets up this variable.
> >>
> >> So, what am I missing here?
> >>
> >>                                                       Thanx, Paul
> >>
> >> PS.  It might well be worthwhile for the online case alone, but
> >>      the commit message does need to be accurate.
> >
> >
> > So, let's take this scenario (inspired from a freshly dumped trace to
> > clarify my ideas):
> >
> > CPU 1 was idle, it has missed several grace periods, but CPU 0 took care
> > of that.
> >
> > Hence, CPU 0's rdp->gpnum = rdp->completed = 4294967000

But CPU 1's rdp state is outdated, due to locking design.

> > But the last grace period was 4294967002 and it's completed
> > (rnp->pgnum = rnp->completed = rsp->pgnum = 4294967002).
> >
> > Now CPU 0 gets a tick for a random reason, it calls rcu_check_callbacks()
> > and then rcu_pending() which raises the softirq because of this:
> >
> >        /* Has another RCU grace period completed?  */
> >        if (ACCESS_ONCE(rnp->completed) != rdp->completed) { /* outside lock */
> >                rdp->n_rp_gp_completed++;
> >                return 1;
> >        }

Yes, because CPU 0 has not yet updated its rdp state.

> > The softirq fires, we call rcu_process_gp_end() which will
> > update rdp->completed into the global state:
> > (rsp->completed = rnp->pgnum = rnp->completed = rsp->pgnum = 4294967002).
> >
> > But rsp->pgnum is still 2 offsets backwards.

This one is hard for me to believe -- rsp->gpnum drives the rest of
the ->gpnum fields, right?

> > Now we call rcu_check_quiescent_state() -> check_for_new_grace_period()
> > -> note_new_gpnum() and then we end up a requested quiescent state while
> > every grace periods are completed.
> 
> Sorry I should have described that in the changelogs but my ideas
> weren't as clear as they
> are now (at least I feel they are, doesn't mean they actually are ;)
> Chasing these RCU bugs for too much hours has toasted my brain..

Welcome to my world!!!  But keep in mind that an extra timer tick
or two is much preferable to a potential hang!  And you only get
the extra timer tick if there was some other reason that the
CPU came out of nohz mode, correct?

Which is why checking the rnp fields makes more sense to me, actually.
Acquiring rnp->lock is much less painful than pinning down the rsp state.

							Thanx, Paul
