Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0LKAAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:00:54 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:64642 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0LKAAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:00:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G3e8plantA/1L8e39OlE5155++OVrkt/oggxdpHYWWhQ1C50ZDqXrhcsNnFZziCq9r
         gHRmOcVc4m2foJyavec1l0+vv5dtpp/LRRVrlbSV5NBWQgArW+GvPlRK+dTN8qWuy+eC
         g/1xhQTskNSrUZ3yuBRTKisc75ZfiEMQF5JUk=
Date: Sat, 11 Dec 2010 01:00:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, laijs@cn.fujitsu.com
Subject: Re: [PATCH 2/2] rcu: Keep gpnum and completed fields synchronized
Message-ID: <20101211000036.GD1713@nowhere>
References: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
 <1292015471-19227-3-git-send-email-fweisbec@gmail.com>
 <20101210230200.GK2125@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210230200.GK2125@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 03:02:00PM -0800, Paul E. McKenney wrote:
> On Fri, Dec 10, 2010 at 10:11:11PM +0100, Frederic Weisbecker wrote:
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
> 
> Also good, queued!
> 
> One issue -- this approach is vulnerable to overflow.  I therefore
> followed up with a patch that changes the condition to
> 
> 	if (ULONG_CMP_LT(rdp->gpnum, rdp->completed))
> 
> And I clearly need to make RCU defend itself against the scenario where
> a CPU stays in dyntick-idle mode long enough for the grace-period number
> to wrap halfway around its range of possible values.  Not a problem at
> the moment, and never will be for 64-bit systems, but...
> 
> I will fix that up.

Oh you're right of course. I did not think about possible overflows.

Now looking at ULONG_CMP_LT() definition, if it wraps more than halfways
we are screwed anyway. I suspect it won't ever happen, but it can. Perhaps
we need some watchguard code in note_new_gpnum() to fixup that corner case.


> 
> 							Thanx, Paul
> 
> > Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Steven Rostedt <rostedt@goodmis.org
> > ---
> >  kernel/rcutree.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 8c4ed60..2e16da3 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -683,6 +683,15 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
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
> > +
> > +		/*
> >  		 * If another CPU handled our extended quiescent states and
> >  		 * we have no more grace period to complete yet, then stop
> >  		 * chasing quiescent states.
> > -- 
> > 1.7.3.2
> > 
