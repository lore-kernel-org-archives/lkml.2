Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab2BPKuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:50:21 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:24951 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842Ab2BPKuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:50:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACrfPE/O+Ip3/2dsb2JhbABCsGmBCIFyAQEEAScTGwEjEAsYLhQlJBOHfwm1YItVCAwYCBABAgILCQUBAgklg2sDBAM1gmRjBIhNjGiOLYRa
X-IronPort-AV: E=Sophos;i="4.73,428,1325480400"; 
   d="scan'208";a="163281738"
Date: Thu, 16 Feb 2012 05:50:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, Avi Kiviti <avi@redhat.com>,
        Chris Mason <chris.mason@oracle.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
	implementation
Message-ID: <20120216105005.GA11674@Krystal>
References: <20120213020951.GA12138@linux.vnet.ibm.com> <1329310763.2293.78.camel@twins> <20120216063504.GE2976@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20120216063504.GE2976@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 05:49:11 up 7 days, 21:47,  1 user,  load average: 0.10, 0.14,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Feb 15, 2012 at 01:59:23PM +0100, Peter Zijlstra wrote:
> > On Sun, 2012-02-12 at 18:09 -0800, Paul E. McKenney wrote:
> > > The current implementation of synchronize_srcu_expedited() can cause
> > > severe OS jitter due to its use of synchronize_sched(), which in turn
> > > invokes try_stop_cpus(), which causes each CPU to be sent an IPI.
> > > This can result in severe performance degradation for real-time workloads
> > > and especially for short-interation-length HPC workloads.  Furthermore,
> > > because only one instance of try_stop_cpus() can be making forward progress
> > > at a given time, only one instance of synchronize_srcu_expedited() can
> > > make forward progress at a time, even if they are all operating on
> > > distinct srcu_struct structures.
> > > 
> > > This commit, inspired by an earlier implementation by Peter Zijlstra
> > > (https://lkml.org/lkml/2012/1/31/211) and by further offline discussions,
> > > takes a strictly algorithmic bits-in-memory approach.  This has the
> > > disadvantage of requiring one explicit memory-barrier instruction in
> > > each of srcu_read_lock() and srcu_read_unlock(), but on the other hand
> > > completely dispenses with OS jitter and furthermore allows SRCU to be
> > > used freely by CPUs that RCU believes to be idle or offline.
> > > 
> > > The update-side implementation handles the single read-side memory
> > > barrier by rechecking the per-CPU counters after summing them and
> > > by running through the update-side state machine twice.
> > 
> > Yeah, getting rid of that second memory barrier in srcu_read_lock() is
> > pure magic :-)
> > 
> > > This implementation has passed moderate rcutorture testing on both 32-bit
> > > x86 and 64-bit Power.  A call_srcu() function will be present in a later
> > > version of this patch.
> > 
> > Goodness ;-)
> 
> Glad you like the magic and the prospect of call_srcu().  ;-)
> 
> > > @@ -131,10 +214,11 @@ int __srcu_read_lock(struct srcu_struct *sp)
> > >  	int idx;
> > >  
> > >  	preempt_disable();
> > > -	idx = sp->completed & 0x1;
> > > -	barrier();  /* ensure compiler looks -once- at sp->completed. */
> > > -	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]++;
> > > -	srcu_barrier();  /* ensure compiler won't misorder critical section. */
> > > +	idx = rcu_dereference_index_check(sp->completed,
> > > +					  rcu_read_lock_sched_held()) & 0x1;
> > > +	ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]) +=
> > > +		SRCU_USAGE_COUNT + 1;
> > > +	smp_mb(); /* B */  /* Avoid leaking the critical section. */
> > >  	preempt_enable();
> > >  	return idx;
> > >  }
> > 
> > You could use __this_cpu_* muck to shorten some of that.
> 
> Ah, so something like this?
> 
> 	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 
> 		SRCU_USAGE_COUNT + 1;
> 
> Now that you mention it, this does look nicer, applied here and to
> srcu_read_unlock().

I think Peter refers to __this_cpu_add().

Thanks,

Mathieu

> 
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> 
> 							Thanx, Paul
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
