Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab2FOURB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:17:01 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50968 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab2FOUQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:16:58 -0400
Date: Fri, 15 Jun 2012 13:16:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 4/6] rcu: Fix bug in rcu_barrier() torture
 test
Message-ID: <20120615201632.GI2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339786674-25265-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615194454.GA6366@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615194454.GA6366@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061520-7408-0000-0000-000005E497C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 03:44:54PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> [...]
> > @@ -1642,6 +1643,7 @@ void rcu_torture_barrier_cbf(struct rcu_head *rcu)
> >  static int rcu_torture_barrier_cbs(void *arg)
> >  {
> >  	long myid = (long)arg;
> > +	bool lastphase = 0;
> >  	struct rcu_head rcu;
> >  
> >  	init_rcu_head_on_stack(&rcu);
> > @@ -1649,9 +1651,11 @@ static int rcu_torture_barrier_cbs(void *arg)
> >  	set_user_nice(current, 19);
> >  	do {
> >  		wait_event(barrier_cbs_wq[myid],
> > -			   atomic_read(&barrier_cbs_count) == n_barrier_cbs ||
> > +			   barrier_phase != lastphase ||
> >  			   kthread_should_stop() ||
> >  			   fullstop != FULLSTOP_DONTSTOP);
> > +		lastphase = barrier_phase;
> > +		smp_mb();
> 
> Hi Paul,
> 
> Documenting this barrier, and the barrier below, along with the variable
> accesses they order, would appear to be a good idea, especially since
> the bug this is correcting was caused by the lack of appropriate
> smp_mb().

Fair point, even in rcutorture.  Or maybe especially in rcutorture...

Will fix!

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> >  		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
> >  			break;
> >  		cur_ops->call(&rcu, rcu_torture_barrier_cbf);
> > @@ -1676,7 +1680,8 @@ static int rcu_torture_barrier(void *arg)
> >  	do {
> >  		atomic_set(&barrier_cbs_invoked, 0);
> >  		atomic_set(&barrier_cbs_count, n_barrier_cbs);
> > -		/* wake_up() path contains the required barriers. */
> > +		smp_mb();
> > +		barrier_phase = !barrier_phase;
> >  		for (i = 0; i < n_barrier_cbs; i++)
> >  			wake_up(&barrier_cbs_wq[i]);
> >  		wait_event(barrier_wq,
> > -- 
> > 1.7.8
> > 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
> 

