Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab2A2GJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 01:09:44 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:42269 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2A2GJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 01:09:42 -0500
Date: Sat, 28 Jan 2012 22:09:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
Message-ID: <20120129060921.GC17696@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120125140029.GA2534@linux.vnet.ibm.com>
 <4F200F4D.5000201@numascale.com>
 <20120125181441.GD2849@linux.vnet.ibm.com>
 <4F2070B9.2000104@numascale.com>
 <20120125213450.GJ2849@linux.vnet.ibm.com>
 <4F2086DA.4040203@numascale.com>
 <20120126015843.GN2849@linux.vnet.ibm.com>
 <4F216B85.7010208@numascale.com>
 <20120126192653.GC2437@linux.vnet.ibm.com>
 <4F2285E5.9050705@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2285E5.9050705@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012906-7282-0000-0000-000006024A1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 12:09:25PM +0100, Steffen Persvold wrote:
> On 1/26/2012 20:26, Paul E. McKenney wrote:
> >On Thu, Jan 26, 2012 at 04:04:37PM +0100, Steffen Persvold wrote:
> >>On 1/26/2012 02:58, Paul E. McKenney wrote:
> >>>On Wed, Jan 25, 2012 at 11:48:58PM +0100, Steffen Persvold wrote:
> >>[]
> >>>
> >>>This looks like it will produce useful information, but I am not seeing
> >>>output from it below.
> >>>
> >>>							Thanx, Paul
> >>>
> >>>>This run it was CPU24 that triggered the issue :
> >>>>
> >>
> >>This line is the printout for the root level :
> >>
> >>>>[  231.572688] CPU 24, treason uncloaked, rsp @ ffffffff81a1cd80 (rcu_sched), rnp @ ffffffff81a1cd80(r) qsmask=0x1f, c=5132 g=5132 nc=5132 ng=5133 sc=5132 sg=5133 mc=5132 mg=5133
> >
> >OK, so the rcu_state structure (sc and sg) believes that grace period
> >5133 has started but not completed, as expected.  Strangely enough, so
> >does the root rcu_node structure (nc and ng) and the CPU's leaf rcu_node
> >structure (mc and mg).
> >
> >The per-CPU rcu_data structure (c and g) does not yet know about the
> >new 5133 grace period, as expected.
> >
> >So this is the code in kernel/rcutree.c:rcu_start_gp() that does the
> >initialization:
> >
> >	rcu_for_each_node_breadth_first(rsp, rnp) {
> >		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
> >		rcu_preempt_check_blocked_tasks(rnp);
> >		rnp->qsmask = rnp->qsmaskinit;
> >		rnp->gpnum = rsp->gpnum;
> >		rnp->completed = rsp->completed;
> >		if (rnp == rdp->mynode)
> >			rcu_start_gp_per_cpu(rsp, rnp, rdp);
> >		rcu_preempt_boost_start_gp(rnp);
> >		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
> >					    rnp->level, rnp->grplo,
> >					    rnp->grphi, rnp->qsmask);
> >		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
> >	}
> >
> >I am assuming that your debug prints are still invoked right after
> >the raw_spin_lock() above.  If so, I would expect nc==ng and mc==mg.
> >Even if your debug prints followed the assignments to rnp->gpnum and
> >rnp->completed, I would expect mc==mg for the root and internal rcu_node
> >structures.  But you say below that you get the same values throughout,
> >and in that case, I would expect the leaf rcu_node structure to show
> >something different than the root and internal structures.
> >
> >The code really does hold the root rcu_node lock at all calls to
> >rcu_gp_start(), so I don't see how we could be getting two CPUs in that
> >code at the same time, which would be one way that the rcu_node and
> >rcu_data structures might get advance notice of the new grace period,
> >but in that case, you would have more than one bit set in ->qsmask.
> >
> >So, any luck with the trace events for rcu_grace_period and
> >rcu_grace_period_init?
> >
> 
> I've successfully enabled them and it seems to work, however once
> the issue is triggered any attempt to access
> /sys/kernel/debug/tracing/trace just hangs :/

Hmmm...  I wonder if it waits for a grace period?

If it cannot be made to work, I can probably put together some
alternative diagnostics, but it will take me a day or three.

							Thanx, Paul

