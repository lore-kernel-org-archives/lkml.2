Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab2IFVCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:02:12 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55792 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab2IFVCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:02:08 -0400
Date: Thu, 6 Sep 2012 14:01:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 10/15] rcu: Protect rcu_node accesses during
 CPU stall warnings
Message-ID: <20120906210112.GB2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-10-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346943078.18408.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346943078.18408.29.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090621-7408-0000-0000-0000084404FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 04:51:18PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:56 -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The print_other_cpu_stall() function accesses a number of rcu_node
> > fields without protection from the ->lock.  In theory, this is not
> > a problem because the fields accessed are all integers, but in
> > practice the compiler can get nasty.  Therefore, the commit extends
> > the existing critical section to cover the entire loop body.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 9f44749..fbe43b0 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -746,14 +746,16 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
> >  	rcu_for_each_leaf_node(rsp, rnp) {
> >  		raw_spin_lock_irqsave(&rnp->lock, flags);
> >  		ndetected += rcu_print_task_stall(rnp);
> > -		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > -		if (rnp->qsmask == 0)
> > +		if (rnp->qsmask == 0) {
> > +			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >  			continue;
> > +		}
> >  		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
> >  			if (rnp->qsmask & (1UL << cpu)) {
> >  				print_cpu_stall_info(rsp, rnp->grplo + cpu);
> >  				ndetected++;
> >  			}
> > +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >  	}
> 
> You now cover printk() and all that that can call with a RCU lock.. is
> this a good thing?

Not particularly good.  However, this happens only if something manages to
block a grace period for 60 seconds, so it should not happen in normal
circumstances.  If that happens, holding the lock allows consistent
state to be printed, which can be helpful in tracking down the bug,
be it in RCU or elsewhere.  So the disease really is worse than the cure.

							Thanx, Paul

