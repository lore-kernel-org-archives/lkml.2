Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab2IDXxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:53:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37546 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2IDXx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:53:29 -0400
Date: Tue, 4 Sep 2012 16:53:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Disallow callback registry on
 offline CPUs
Message-ID: <20120904235321.GZ2593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830190245.GA32625@linux.vnet.ibm.com>
 <1346353383-350-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346353383-350-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831162130.GB21673@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831162130.GB21673@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090423-4242-0000-0000-000002C86B74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 09:21:30AM -0700, Josh Triplett wrote:
> On Thu, Aug 30, 2012 at 12:03:02PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > Posting a callback after the CPU_DEAD notifier effectively leaks
> > that callback unless/until that CPU comes back online.  Silence is
> > unhelpful when attempting to track down such leaks, so this commit emits
> > a WARN_ON_ONCE() and unconditionally leaks the callback when an offline
> > CPU attempts to register a callback.  The rdp->nxttail[RCU_NEXT_TAIL] is
> > set to NULL in the CPU_DEAD notifier and restored in the CPU_UP_PREPARE
> > notifier, allowing _call_rcu() to determine exactly when posting callbacks
> > is illegal.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> One suggestion below; with or without that change:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > ---
> >  kernel/rcutree.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 9854a00..5f8c4dd 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1503,6 +1503,9 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
> >  	WARN_ONCE(rdp->qlen != 0 || rdp->nxtlist != NULL,
> >  		  "rcu_cleanup_dead_cpu: Callbacks on offline CPU %d: qlen=%lu, nxtlist=%p\n",
> >  		  cpu, rdp->qlen, rdp->nxtlist);
> > +	init_callback_list(rdp);
> > +	/* Disallow further callbacks on this CPU. */
> > +	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
> >  }
> >  
> >  #else /* #ifdef CONFIG_HOTPLUG_CPU */
> > @@ -1925,6 +1928,12 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
> >  	rdp = this_cpu_ptr(rsp->rda);
> >  
> >  	/* Add the callback to our list. */
> > +	if (unlikely(rdp->nxttail[RCU_NEXT_TAIL] == NULL)) {
> > +		/* _call_rcu() is illegal on offline CPU; leak the callback. */
> > +		WARN_ON_ONCE(1);
> 
> You can write this as:
> 
> if (WARN_ON_ONCE(rdp->nxttail[RCU_NEXT_TAIL] == NULL))
> 
> WARN_ON_ONCE also has a built-in unlikely() already.

Indeed, I missed the fact that WARN_ON_ONCE() returns its argument.
I believe that there are a number of other places in RCU where I could
bury a WARN_ON_ONCE(1) into the preceding "if" statement, so added a
todo-list item to check all of them and convert as appropriate.

							Thanx, Paul

> > +		local_irq_restore(flags);
> > +		return;
> > +	}
> >  	ACCESS_ONCE(rdp->qlen)++;
> >  	if (lazy)
> >  		rdp->qlen_lazy++;
> > @@ -2462,6 +2471,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
> >  	rdp->qlen_last_fqs_check = 0;
> >  	rdp->n_force_qs_snap = rsp->n_force_qs;
> >  	rdp->blimit = blimit;
> > +	init_callback_list(rdp);  /* Re-enable callbacks on this CPU. */
> >  	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
> >  	atomic_set(&rdp->dynticks->dynticks,
> >  		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
> > -- 
> > 1.7.8
> > 
> 

