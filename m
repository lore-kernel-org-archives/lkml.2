Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0KFToP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:44:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49044 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab0KFToO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:44:14 -0400
Date: Sat, 6 Nov 2010 12:44:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Joe Korty <joe.korty@ccur.com>, fweisbec@gmail.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101106194408.GK15561@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105210059.GA27317@tsunami.ccur.com>
 <20101106192812.GI15561@linux.vnet.ibm.com>
 <20101106193456.GA14197@Krystal>
 <20101106194219.GA24135@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101106194219.GA24135@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 03:42:19PM -0400, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > > > +/**
> > > > + * rcu_read_unlock - marks the end of an RCU read-side critical section.
> > > > + * Check if a RCU batch was started while we were in the critical
> > > > + * section.  If so, call rcu_quiescent() join the rendezvous.
> > > > + *
> > > > + * See rcu_read_lock() for more information.
> > > > + */
> > > > +void __rcu_read_unlock(void)
> > > > +{
> > > > +	struct rcu_data *r;
> > > > +	int	cpu, flags;
> > > > +
> > 
> > Another memory barrier would be needed here to ensure that the memory accesses
> > performed within the C.S. are not reordered wrt nest_count decrement.
> 
> Nevermind. xchg() acts as a memory barrier, and nest_count is only ever touched
> by the local CPU. No memory barrier needed here.

You beat me to it.  ;-)

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> > 
> > > > +	cpu = smp_processor_id();
> > > > +	r = &per_cpu(rcu_data, cpu);
> > > > +	if (--r->nest_count == 0) {
> > > > +		flags = xchg(&r->flags, 0);
> > > > +		if (flags & DO_RCU_COMPLETION)
> > > > +			rcu_quiescent(cpu);
> > > > +	}
> > > > +}
> > > > +EXPORT_SYMBOL(__rcu_read_unlock);
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > -- 
> > Mathieu Desnoyers
> > Operating System Efficiency R&D Consultant
> > EfficiOS Inc.
> > http://www.efficios.com
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
