Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1BWREE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:04:04 -0500
Received: from blu0-omc1-s8.blu0.hotmail.com ([65.55.116.19]:48757 "EHLO
	blu0-omc1-s8.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab1BWREC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:04:02 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP26AA1E023F77177B51240996DB0@phx.gbl>
Date: Wed, 23 Feb 2011 12:03:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
	to kthread
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com> <20110223161645.GA1819@nowhere> <1298479302.7666.94.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1298479302.7666.94.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:50:12 up 322 days,  2:39,  6 users,  load average: 1.46, 1.62,
	1.56
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 23 Feb 2011 17:04:01.0403 (UTC) FILETIME=[AB0794B0:01CBD37B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2011-02-23 at 17:16 +0100, Frederic Weisbecker wrote:
> > On Tue, Feb 22, 2011 at 05:39:40PM -0800, Paul E. McKenney wrote:
> > > +/*
> > > + * Wake up the current CPU's kthread.  This replaces raise_softirq()
> > > + * in earlier versions of RCU.
> > > + */
> > > +static void invoke_rcu_kthread(void)
> > > +{
> > > +	unsigned long flags;
> > > +	wait_queue_head_t *q;
> > > +	int cpu;
> > > +
> > > +	local_irq_save(flags);
> > > +	cpu = smp_processor_id();
> > > +	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {
> > > +		local_irq_restore(flags);
> > > +		return;
> > > +	}
> > > +	per_cpu(rcu_cpu_has_work, cpu) = 1;
> > > +	q = &per_cpu(rcu_cpu_wq, cpu);
> > 
> > I see you make extensive use of per_cpu() accessors even for
> > local variables.
> > 
> > I tend to think it's better to use __get_cpu_var() for local
> > accesses and keep per_cpu() for remote accesses.
> > 
> > There are several reasons for that:
> > 
> > * __get_cpu_var() checks we are in a non-preemptible section,
> > per_cpu() doesn't. That may sound of a limited interest for code like the
> > above, but by the time code can move, and then we might lose track of some
> > things, etc...
> 
> Ah, but so does smp_processor_id() ;-)
> 
> > 
> > * local accesses can be optimized by architectures. per_cpu() implies
> > finding the local cpu number, and dereference an array of cpu offsets with
> > that number to find the local cpu offset.
> > __get_cpu_var() does a direct access to __my_cpu_offset which is a nice
> > shortcut if the arch implements it.

[Adding Christoph Lameter to CC list]

This is not quite true on x86_64 and s390 anymore. __get_cpu_var() now
uses a segment selector override to get the local CPU variable on x86.
See x86's percpu.h for details.

So even performance-wise, using __get_cpu_var() over per_cpu() should be
a win on widely used architectures nowadays, thanks to Christoph's work
on this_cpu accessors.

> 
> True, but we could also argue that the multiple checks for being preempt
> can also be an issue.

At least on x86 preemption don't actually need to be disabled: selection
of the right per-cpu memory location is done atomically with the rest of
the instruction by the segment selector.

> 
> > 
> > * It makes code easier to review: we know that __get_cpu_var() is
> > for local accesses and per_cpu() for remote.
> 
> This I'll agree with you.
> 
> In the past, I've thought about which one is better (per_cpu() vs
> __get_cpu_var()).
> 
> But, that last point is a good one. Just knowing that this is for the
> local CPU helps with the amount of info your mind needs to process when
> looking at this code. And the mind needs all the help it can get when
> reviewing this code ;-)
> 

Agreed, better documentation of the code is also a win.

Thanks,

Mathieu

> -- Steve
> 
> > 
> > > +	wake_up(q);
> > > +	local_irq_restore(flags);
> > > +}
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
