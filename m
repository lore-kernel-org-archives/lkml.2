Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab2IFRcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:32:36 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50166 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab2IFRcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:32:33 -0400
Date: Thu, 6 Sep 2012 10:32:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 06/23] rcu: Break up rcu_gp_kthread() into
 subfunctions
Message-ID: <20120906173207.GK2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346938791.18408.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346938791.18408.7.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090617-7408-0000-0000-00000841F0D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:39:51PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > +static int rcu_gp_kthread(void *arg)
> > +{
> > +       struct rcu_state *rsp = arg;
> > +       struct rcu_node *rnp = rcu_get_root(rsp);
> > +
> > +       for (;;) {
> > +
> > +               /* Handle grace-period start. */
> > +               for (;;) {
> > +                       wait_event_interruptible(rsp->gp_wq, rsp->gp_flags);
> > +                       if (rsp->gp_flags && rcu_gp_init(rsp))
> > +                               break;
> > +                       cond_resched();
> > +                       flush_signals(current);
> > +               }
> >  
> >                 /* Handle grace-period end. */
> >                 for (;;) {
> >                         wait_event_interruptible(rsp->gp_wq,
> >                                                  !ACCESS_ONCE(rnp->qsmask) &&
> >                                                  !rcu_preempt_blocked_readers_cgp(rnp));
> >                         if (!ACCESS_ONCE(rnp->qsmask) &&
> > +                           !rcu_preempt_blocked_readers_cgp(rnp) &&
> > +                           rcu_gp_cleanup(rsp))
> >                                 break;
> > +                       cond_resched();
> >                         flush_signals(current);
> >                 }
> >         }
> >         return 0;
> >  } 
> 
> Should there not be a kthread_stop() / kthread_park() call somewhere in
> there?

The kthread stops only when the system goes down, so no need for any
kthread_stop() or kthread_park().  The "return 0" suppresses complaints
about falling of the end of a non-void function.

> Also, it could be me, but all those nested for (;;) loops make the flow
> rather non-obvious.

For those two loops, I suppose I could pull the cond_resched() and
flush_signals() to the top, and make a do-while out of it.

							Thanx, Paul

