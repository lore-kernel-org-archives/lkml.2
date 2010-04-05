Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0DES4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:56:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41531 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab0DES4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:56:30 -0400
Date: Mon, 5 Apr 2010 11:56:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 02/10] rcu: make dead code really dead
Message-ID: <20100405185624.GF2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100405183403.GA23075@linux.vnet.ibm.com>
 <1270492472-23222-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100405184928.GA4505@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405184928.GA4505@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 02:49:28PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > cleanup: make dead code really dead
> 
> Is it just me or this spinlock change is more than just a cleanup ? Or
> maybe it just needs a much more descriptive changelog.

Just a cleanup.  In the case where the "break" could be executed,
control will never reach the RCU_SAVE_DYNTICK leg of the switch statement.

That said, yes, if control -could- reach the RCU_SAVE_DYNTICK when
this "break" statement was executed, we would have had a locking
problem.  But as it is, this change just makes the dead code really
all be dead so that gcc knows not to produce the corresponding binary.

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index e54c123..6042fb8 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1236,11 +1236,11 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
> >  		break; /* grace period idle or initializing, ignore. */
> >  
> >  	case RCU_SAVE_DYNTICK:
> > -
> > -		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
> >  		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
> >  			break; /* So gcc recognizes the dead code. */
> >  
> > +		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
> > +
> >  		/* Record dyntick-idle state. */
> >  		force_qs_rnp(rsp, dyntick_save_progress_counter);
> >  		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
> > -- 
> > 1.7.0
> > 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
