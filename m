Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab2IFStc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:49:32 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39463 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2IFStb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:49:31 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 173.246.103.110
Date: Thu, 6 Sep 2012 11:49:21 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 06/23] rcu: Break up rcu_gp_kthread() into
 subfunctions
Message-ID: <20120906184921.GA5738@jtriplet-mobl1>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346938791.18408.7.camel@twins>
 <20120906173207.GK2448@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906173207.GK2448@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 10:32:07AM -0700, Paul E. McKenney wrote:
> On Thu, Sep 06, 2012 at 03:39:51PM +0200, Peter Zijlstra wrote:
> > On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > > +static int rcu_gp_kthread(void *arg)
> > > +{
> > > +       struct rcu_state *rsp = arg;
> > > +       struct rcu_node *rnp = rcu_get_root(rsp);
> > > +
> > > +       for (;;) {
> > > +
> > > +               /* Handle grace-period start. */
> > > +               for (;;) {
> > > +                       wait_event_interruptible(rsp->gp_wq, rsp->gp_flags);
> > > +                       if (rsp->gp_flags && rcu_gp_init(rsp))
> > > +                               break;
> > > +                       cond_resched();
> > > +                       flush_signals(current);
> > > +               }
> > >  
> > >                 /* Handle grace-period end. */
> > >                 for (;;) {
> > >                         wait_event_interruptible(rsp->gp_wq,
> > >                                                  !ACCESS_ONCE(rnp->qsmask) &&
> > >                                                  !rcu_preempt_blocked_readers_cgp(rnp));
> > >                         if (!ACCESS_ONCE(rnp->qsmask) &&
> > > +                           !rcu_preempt_blocked_readers_cgp(rnp) &&
> > > +                           rcu_gp_cleanup(rsp))
> > >                                 break;
> > > +                       cond_resched();
> > >                         flush_signals(current);
> > >                 }
> > >         }
> > >         return 0;
> > >  } 
> > 
> > Should there not be a kthread_stop() / kthread_park() call somewhere in
> > there?
> 
> The kthread stops only when the system goes down, so no need for any
> kthread_stop() or kthread_park().  The "return 0" suppresses complaints
> about falling of the end of a non-void function.

Huh, I thought GCC knew to not emit that warning unless it actually
found control flow reaching the end of the function; since the infinite
loop has no break in it, you shouldn't need the return.  Annoying.

> > Also, it could be me, but all those nested for (;;) loops make the flow
> > rather non-obvious.
> 
> For those two loops, I suppose I could pull the cond_resched() and
> flush_signals() to the top, and make a do-while out of it.

I think it makes more sense to move the wait_event_interruptible to the
bottom, and make a while out of it.

- Josh Triplett
