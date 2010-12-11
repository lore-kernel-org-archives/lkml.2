Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab0LKAss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:48:48 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43954 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609Ab0LKAsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:48:47 -0500
Date: Fri, 10 Dec 2010 16:48:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, laijs@cn.fujitsu.com
Subject: Re: [PATCH 2/2] rcu: Keep gpnum and completed fields synchronized
Message-ID: <20101211004842.GO2125@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
 <1292015471-19227-3-git-send-email-fweisbec@gmail.com>
 <20101210230200.GK2125@linux.vnet.ibm.com>
 <20101211000036.GD1713@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101211000036.GD1713@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 01:00:39AM +0100, Frederic Weisbecker wrote:
> On Fri, Dec 10, 2010 at 03:02:00PM -0800, Paul E. McKenney wrote:
> > On Fri, Dec 10, 2010 at 10:11:11PM +0100, Frederic Weisbecker wrote:
> > > When a CPU that was in an extended quiescent state wakes
> > > up and catches up with grace periods that remote CPUs
> > > completed on its behalf, we update the completed field
> > > but not the gpnum that keeps a stale value of a backward
> > > grace period ID.
> > > 
> > > Later, note_new_gpnum() will interpret the shift between
> > > the local CPU and the node grace period ID as some new grace
> > > period to handle and will then start to hunt quiescent state.
> > > 
> > > But if every grace periods have already been completed, this
> > > interpretation becomes broken. And we'll be stuck in clusters
> > > of spurious softirqs because rcu_report_qs_rdp() will make
> > > this broken state run into infinite loop.
> > > 
> > > The solution, as suggested by Lai Jiangshan, is to ensure that
> > > the gpnum and completed fields are well synchronized when we catch
> > > up with completed grace periods on their behalf by other cpus.
> > > This way we won't start noting spurious new grace periods.
> > 
> > Also good, queued!
> > 
> > One issue -- this approach is vulnerable to overflow.  I therefore
> > followed up with a patch that changes the condition to
> > 
> > 	if (ULONG_CMP_LT(rdp->gpnum, rdp->completed))
> > 
> > And I clearly need to make RCU defend itself against the scenario where
> > a CPU stays in dyntick-idle mode long enough for the grace-period number
> > to wrap halfway around its range of possible values.  Not a problem at
> > the moment, and never will be for 64-bit systems, but...
> > 
> > I will fix that up.
> 
> Oh you're right of course. I did not think about possible overflows.
> 
> Now looking at ULONG_CMP_LT() definition, if it wraps more than halfways
> we are screwed anyway. I suspect it won't ever happen, but it can. Perhaps
> we need some watchguard code in note_new_gpnum() to fixup that corner case.

We still have to guard against a full wrap, though there are lots of other
things that break if you stay in dyntick-idle mode that long.  My plan is
to have a counter in the rcu_state structure that cycles through the CPUs.
Check the current CPU at the start of each grace period.  If a given
CPU is more than one-quarter of the way behind, force it to wake up
and catch up.  This gets easier to do given my in-progress changes to
convert from softirq to kthread, so I will combine it with those changes.

So I will cover this.

							Thanx, Paul

> > > Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Steven Rostedt <rostedt@goodmis.org
> > > ---
> > >  kernel/rcutree.c |    9 +++++++++
> > >  1 files changed, 9 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > index 8c4ed60..2e16da3 100644
> > > --- a/kernel/rcutree.c
> > > +++ b/kernel/rcutree.c
> > > @@ -683,6 +683,15 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
> > >  		rdp->completed = rnp->completed;
> > > 
> > >  		/*
> > > +		 * If we were in an extended quiescent state, we may have
> > > +		 * missed some grace periods that others CPUs took care on
> > > +		 * our behalf. Catch up with this state to avoid noting
> > > +		 * spurious new grace periods.
> > > +		 */
> > > +		if (rdp->completed > rdp->gpnum)
> > > +			rdp->gpnum = rdp->completed;
> > > +
> > > +		/*
> > >  		 * If another CPU handled our extended quiescent states and
> > >  		 * we have no more grace period to complete yet, then stop
> > >  		 * chasing quiescent states.
> > > -- 
> > > 1.7.3.2
> > > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
