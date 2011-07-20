Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab1GTEyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 00:54:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55988 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1GTEyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 00:54:22 -0400
Date: Tue, 19 Jul 2011 21:54:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca
Subject: Re: [PATCH tip/core/urgent 1/7] rcu: decrease rcu_report_exp_rnp
 coupling with scheduler
Message-ID: <20110720045414.GC2400@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110720001738.GA16369@linux.vnet.ibm.com>
 <1311121103-16978-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1311129618.5345.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311129618.5345.2.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 04:40:18AM +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-19 at 17:18 -0700, Paul E. McKenney wrote:
> > +++ b/kernel/rcutree_plugin.h
> > @@ -696,8 +696,10 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
> >         raw_spin_lock_irqsave(&rnp->lock, flags);
> >         for (;;) {
> >                 if (!sync_rcu_preempt_exp_done(rnp))
> > +                       raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >                         break;
> 
> I bet that'll all work much better if you wrap it in curly braces like:
> 
> 		if (!sync_rcu_preempt_exp_done(rnp)) {
> 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> 			break;
> 		}
> 
> That might also explain those explosions Ed and Ben have been seeing.

Indeed.  Must be the call of the snake.  :-(

Thank you for catching this!

> >                 if (rnp->parent == NULL) {
> > +                       raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >                         wake_up(&sync_rcu_preempt_exp_wq);
> >                         break;
> >                 }
> > @@ -707,7 +709,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
> >                 raw_spin_lock(&rnp->lock); /* irqs already disabled */
> >                 rnp->expmask &= ~mask;
> >         }
> > -       raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >  } 

So this time I am testing the exact patch series before resending.
In the meantime, here is the updated version of this patch.

							Thanx, Paul

------------------------------------------------------------------------

rcu: decrease rcu_report_exp_rnp coupling with scheduler

PREEMPT_RCU read-side critical sections blocking an expedited grace
period invoke rcu_report_exp_rnp().  When the last such critical section
has completed, rcu_report_exp_rnp() invokes the scheduler to wake up the
task that invoked synchronize_rcu_expedited() -- needlessly holding the
root rcu_node structure's lock while doing so, thus needlessly providing
a way for RCU and the scheduler to deadlock.

This commit therefore releases the root rcu_node structure's lock before
calling wake_up().

Reported-by: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 75113cb..6abef3c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -695,9 +695,12 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	for (;;) {
-		if (!sync_rcu_preempt_exp_done(rnp))
+		if (!sync_rcu_preempt_exp_done(rnp)) {
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			break;
+		}
 		if (rnp->parent == NULL) {
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			wake_up(&sync_rcu_preempt_exp_wq);
 			break;
 		}
@@ -707,7 +710,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 		raw_spin_lock(&rnp->lock); /* irqs already disabled */
 		rnp->expmask &= ~mask;
 	}
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
