Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab0LTQva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:51:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47895 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab0LTQv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:51:29 -0500
Date: Mon, 20 Dec 2010 08:51:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC tip/core/rcu 15/20] rcu: Keep gpnum and completed
 fields synchronized
Message-ID: <20101220165118.GI2143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101217205433.GA10199@linux.vnet.ibm.com>
 <1292619291-2468-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D0EBBCF.2070305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0EBBCF.2070305@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 10:13:35AM +0800, Lai Jiangshan wrote:
> On 12/18/2010 04:54 AM, Paul E. McKenney wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > When a CPU that was in an extended quiescent state wakes
> > up and catches up with grace periods that remote CPUs
> > completed on its behalf, we update the completed field
> > but not the gpnum that keeps a stale value of a backward
> > grace period ID.
> > 
> > Later, note_new_gpnum() will interpret the shift between
> > the local CPU and the node grace period ID as some new grace
> > period to handle and will then start to hunt quiescent state.
> > 
> > But if every grace periods have already been completed, this
> > interpretation becomes broken. And we'll be stuck in clusters
> > of spurious softirqs because rcu_report_qs_rdp() will make
> > this broken state run into infinite loop.
> > 
> > The solution, as suggested by Lai Jiangshan, is to ensure that
> > the gpnum and completed fields are well synchronized when we catch
> > up with completed grace periods on their behalf by other cpus.
> > This way we won't start noting spurious new grace periods.
> > 
> > Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Steven Rostedt <rostedt@goodmis.org
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 916f42b..8105271 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -680,6 +680,15 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
> >  		rdp->completed = rnp->completed;
> >  
> >  		/*
> > +		 * If we were in an extended quiescent state, we may have
> > +		 * missed some grace periods that others CPUs took care on
> > +		 * our behalf. Catch up with this state to avoid noting
> > +		 * spurious new grace periods.
> > +		 */
> > +		if (rdp->completed > rdp->gpnum)
> > +			rdp->gpnum = rdp->completed;
> 
> Need to use ULONG_CMP_LT(rdp->gpnum, rdp->completed) instead.

You are quite correct!  And the next patch in this series made exactly
that change.

							Thanx, Paul

> > +
> > +		/*
> >  		 * If another CPU handled our extended quiescent states and
> >  		 * we have no more grace period to complete yet, then stop
> >  		 * chasing quiescent states.
> 
