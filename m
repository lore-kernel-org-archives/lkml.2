Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0KFTmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:42:22 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42163 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752612Ab0KFTmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:42:21 -0400
Date: Sat, 6 Nov 2010 15:42:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Joe Korty <joe.korty@ccur.com>, fweisbec@gmail.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101106194219.GA24135@Krystal>
References: <20101104232148.GA28037@linux.vnet.ibm.com> <20101105210059.GA27317@tsunami.ccur.com> <20101106192812.GI15561@linux.vnet.ibm.com> <20101106193456.GA14197@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101106193456.GA14197@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:41:25 up 44 days, 23:43,  5 users,  load average: 0.09, 0.13,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > > +/**
> > > + * rcu_read_unlock - marks the end of an RCU read-side critical section.
> > > + * Check if a RCU batch was started while we were in the critical
> > > + * section.  If so, call rcu_quiescent() join the rendezvous.
> > > + *
> > > + * See rcu_read_lock() for more information.
> > > + */
> > > +void __rcu_read_unlock(void)
> > > +{
> > > +	struct rcu_data *r;
> > > +	int	cpu, flags;
> > > +
> 
> Another memory barrier would be needed here to ensure that the memory accesses
> performed within the C.S. are not reordered wrt nest_count decrement.

Nevermind. xchg() acts as a memory barrier, and nest_count is only ever touched
by the local CPU. No memory barrier needed here.

Thanks,

Mathieu

> 
> > > +	cpu = smp_processor_id();
> > > +	r = &per_cpu(rcu_data, cpu);
> > > +	if (--r->nest_count == 0) {
> > > +		flags = xchg(&r->flags, 0);
> > > +		if (flags & DO_RCU_COMPLETION)
> > > +			rcu_quiescent(cpu);
> > > +	}
> > > +}
> > > +EXPORT_SYMBOL(__rcu_read_unlock);
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
