Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab0LUILA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 03:11:00 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49902 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab0LUIK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 03:10:59 -0500
Date: Tue, 21 Dec 2010 00:10:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 06/15] nohz_task: Keep the tick if rcu needs it
Message-ID: <20101221081043.GK2143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-7-git-send-email-fweisbec@gmail.com>
 <1292860700.5021.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292860700.5021.14.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:58:20PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> 
> > @@ -1634,7 +1633,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
> >   * by the current CPU, returning 1 if so.  This function is part of the
> >   * RCU implementation; it is -not- an exported member of the RCU API.
> >   */
> > -static int rcu_pending(int cpu)
> > +int rcu_pending(int cpu)
> 
> /me wonders about that comment.
> 
> >  {
> >  	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
> >  	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 6dbae46..45bd6e2 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2470,10 +2470,16 @@ static void nohz_task_cpu_update(void *unused)
> >  int nohz_task_can_stop_tick(void)
> >  {
> >  	struct rq *rq = this_rq();
> > +	int cpu;
> >  
> >  	if (rq->nr_running > 1)
> >  		return 0;
> >  
> > +	cpu = smp_processor_id();
> > +
> > +	if (rcu_pending(cpu) || rcu_needs_cpu(cpu))
> > +		return 0;
> 
> Arguable, rcu_needs_cpu() should imply rcu_pending(), because if there's
> work still to be done, it needs the cpu, hmm?

There are two cases:

1.	This CPU has callbacks.  In this case, rcu_pending() returns 1.

2.	The RCU core needs something from this CPU.  In this case,
	rcu_pending() returns 1.

The trick is that in dyntick-idle mode, if we have #2 but not #1, other
CPUs can (and will) act on the dyntick-idle CPU's behalf.  However, when
there is a task running, that task might do system calls, which can
queue callbacks and can contain RCU read-side critical sections, neither
of which can happen in dyntick-idle mode.

So the one-task-running-on-this-CPU case above does need special
handling.

> >  	return 1;
> >  }
> >  
> 
> This patch also implies you broke stuff with #4 because it would put the
> machine to sleep while RCU still had bits to do, not very nice.

Hmmm...  I need to look at this after getting some sleep.

							Thanx, Paul
