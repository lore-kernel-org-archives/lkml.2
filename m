Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab2IDWwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:52:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43820 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2IDWwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:52:07 -0400
Date: Tue, 4 Sep 2012 15:51:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 10/15] rcu: Protect rcu_node accesses during
 CPU stall warnings
Message-ID: <20120904225153.GU2593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-10-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831182302.GH4259@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831182302.GH4259@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090422-6148-0000-0000-0000094621EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 11:23:02AM -0700, Josh Triplett wrote:
> On Thu, Aug 30, 2012 at 11:56:23AM -0700, Paul E. McKenney wrote:
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
> Now that you've extended the lock over the rest of the loop body, I
> think this would look much clearer if written without the continue and
> duplicate lock release:
> 
> 		...
> 		if (rnp->qsmask != 0)
> 			for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
> 				....
> 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> 	}

And my Hollerith experience strikes again!  ;-)

Though this one seems more worthwhile, so I am making the change, conflicts
permitting.

							Thanx, Paul

