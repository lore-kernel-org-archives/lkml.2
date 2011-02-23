Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab1BWTKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:10:48 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37298 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1BWTKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:10:47 -0500
Date: Wed, 23 Feb 2011 11:10:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223191043.GU2163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110223161645.GA1819@nowhere>
 <1298479302.7666.94.camel@gandalf.stny.rr.com>
 <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
 <alpine.DEB.2.00.1102231132140.562@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102231132140.562@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:34:32AM -0600, Christoph Lameter wrote:
> On Wed, 23 Feb 2011, Mathieu Desnoyers wrote:
> 
> > > > > +
> > > > > +	local_irq_save(flags);
> > > > > +	cpu = smp_processor_id();
> 
> Drop this line.
> 
> > > > > +	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {
> 
> use this_cpu_read(rcu_cpu_kthread_task)
> 
> > > > > +		local_irq_restore(flags);
> > > > > +		return;
> > > > > +	}
> > > > > +	per_cpu(rcu_cpu_has_work, cpu) = 1;
> 
> this_cpu_write(rcu_cpu_has_work, 1);

I have made these changes, thank you!

These do introduce redundant preempt_disable()/preempt_enable() calls, but
this is not on a fastpath, so should be OK, and the improved readability
is certainly nice.  The read and the write do need to happen on the same
CPU, FWIW.

> > This is not quite true on x86_64 and s390 anymore. __get_cpu_var() now
> > uses a segment selector override to get the local CPU variable on x86.
> > See x86's percpu.h for details.
> 
> __get_cpu_var cannot use a segment override since there are places where
> the address of the variable is taken. One needs to use this_cpu_ops for
> that.

Thanks for the info!

							Thanx, Paul

> > > True, but we could also argue that the multiple checks for being preempt
> > > can also be an issue.
> >
> > At least on x86 preemption don't actually need to be disabled: selection
> > of the right per-cpu memory location is done atomically with the rest of
> > the instruction by the segment selector.
> 
> Right.
