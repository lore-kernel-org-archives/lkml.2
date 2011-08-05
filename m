Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1HEOWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:22:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1HEOWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:22:51 -0400
Date: Fri, 5 Aug 2011 10:22:45 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        fweisbec@gmail.com
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110805142245.GP2096@zod.bos.redhat.com>
References: <20110801154636.GA2096@zod.bos.redhat.com>
 <CA+5PVA5EZWHv_tuzA22twGQ7rZZ2zhqi1zs6OiFbpORiiYbzMg@mail.gmail.com>
 <20110804140438.GT13065@linux.vnet.ibm.com>
 <20110804150603.GL2096@zod.bos.redhat.com>
 <20110804162658.GZ13065@linux.vnet.ibm.com>
 <20110804173145.GM2096@zod.bos.redhat.com>
 <CA+5PVA7R+H4MfU=war6G3ZRYEi6nZ=vVZ3B8g-Ag6pOdA4cTBw@mail.gmail.com>
 <20110805065646.GC13065@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805065646.GC13065@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 11:56:46PM -0700, Paul E. McKenney wrote:
> > > I could be missing something obvious, but I don't see a way to avoid
> > > using GFP_KERNEL without a lot of rip-up in the rest of the init path.
> > 
> > As an aside, I bisected this back to:
> > 
> > e8f7c70f44f sched: Make sleeping inside spinlock detection working in
> > !CONFIG_PREEMPT
> 
> OK, added Frederic on CC.
> 
> > However, that doesn't seem all that helpful.  The
> > CONFIG_DEBUG_SPINLOCK_SLEEP option later got renamed to
> > DEBUG_ATOMIC_SLEEP, and all it's doing is selecting PREEMPT_COUNT.  At
> > first glance, it seems this commit just allowed an issue that's been
> > around for a while (benign or otherwise) to finally show up.
> > 
> > (The Fedora kernel configs have CONFIG_PREEMPT_VOLUNTARY set, but not
> > CONFIG_PREEMPT so PREEMPT_COUNT wasn't getting selected until this
> > option did so.)
> 
> Understood.  So my question is "what is the real way to fix this?"
> Within RCU, I would probably wrapper the calls to set_need_resched()
> so that it checks for the scheduler being fully alive.  Except for the
> call from rcu_enter_nohz(), of course -- if that one is called before
> the scheduler is ready, then that is a bug that needs to be fixed.

By scheduler being fully alive, do you mean when rcu_scheduler_starting
is called?  Or do you mean the actual scheduler, because sched_init is
called well before any of this happens.

> Nevertheless, I am wondering if all of this isn't really papering over
> some real problem somewhere.  The way we get to this place is from people
> registering RCU callbacks during early boot, which is OK in and of itself,
> at least in moderation.  But if someone is expecting those callbacks to be
> invoked before the scheduler is fully set up and running multiple tasks,
> they are going to be disappointed.

Is there a way to dump what callbacks have been registered?  As far as I
can see, we call rcu_check_callbacks unconditionally when a timer
interrupt is taken and that calls rcu_pending unconditionally as well.
Before that, rcu_init is called which eventually sets up the per-cpu
data via rcu_init_percpu_data and that sets rdp->qs_pending = 1.
Until a quiescent state is reached __rcu_pending is going to try and
force it, which is where the set_need_resched is called.

Basically, I took what you said about wrapping set_need_resched and came
up with the patch below.  It gets rid of the oops from pidmap_init, but
I need to test it a bit more.  Would be happy to have feedback.

josh

---

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ba06207..8c6cb6e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1681,8 +1681,14 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 		rdp->n_rp_qs_pending++;
 		if (!rdp->preemptible &&
 		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
-				 jiffies))
-			set_need_resched();
+				 jiffies)) {
+			/* Make sure we're ready to mark the task as needing
+ 			 * rescheduling otherwise we can trigger oopes early
+ 			 * in the init path
+ 			 */
+			if (rcu_scheduler_active)
+				set_need_resched();
+		}
 	} else if (rdp->qs_pending && rdp->passed_quiesc) {
 		rdp->n_rp_report_qs++;
 		return 1;
