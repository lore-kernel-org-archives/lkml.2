Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1BWReV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:34:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37855 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1BWReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mtFu+xYYkoTDl9Wg6YoQd6X/zAbpxrwJR6RgROl/IX4A94/ydbZi4kR8o/KTDeKW6G
         m3wMz6dOcYLnx8n4fWUKcb5yCgrmA5XBMfhssA8/q7ibondD9ExJ2hN15SSCEw2SJg2y
         j0jX2ktgR1WKUCVxlwrHBu/RJxIw6UwuIqUpA=
Date: Wed, 23 Feb 2011 18:30:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223173004.GB2591@nowhere>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110223161645.GA1819@nowhere>
 <1298479302.7666.94.camel@gandalf.stny.rr.com>
 <BLU0-SMTP5642728A153E83B94895F896DB0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP5642728A153E83B94895F896DB0@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:03:56PM -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Wed, 2011-02-23 at 17:16 +0100, Frederic Weisbecker wrote:
> > > On Tue, Feb 22, 2011 at 05:39:40PM -0800, Paul E. McKenney wrote:
> > > > +/*
> > > > + * Wake up the current CPU's kthread.  This replaces raise_softirq()
> > > > + * in earlier versions of RCU.
> > > > + */
> > > > +static void invoke_rcu_kthread(void)
> > > > +{
> > > > +	unsigned long flags;
> > > > +	wait_queue_head_t *q;
> > > > +	int cpu;
> > > > +
> > > > +	local_irq_save(flags);
> > > > +	cpu = smp_processor_id();
> > > > +	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {
> > > > +		local_irq_restore(flags);
> > > > +		return;
> > > > +	}
> > > > +	per_cpu(rcu_cpu_has_work, cpu) = 1;
> > > > +	q = &per_cpu(rcu_cpu_wq, cpu);
> > > 
> > > I see you make extensive use of per_cpu() accessors even for
> > > local variables.
> > > 
> > > I tend to think it's better to use __get_cpu_var() for local
> > > accesses and keep per_cpu() for remote accesses.
> > > 
> > > There are several reasons for that:
> > > 
> > > * __get_cpu_var() checks we are in a non-preemptible section,
> > > per_cpu() doesn't. That may sound of a limited interest for code like the
> > > above, but by the time code can move, and then we might lose track of some
> > > things, etc...
> > 
> > Ah, but so does smp_processor_id() ;-)
> > 
> > > 
> > > * local accesses can be optimized by architectures. per_cpu() implies
> > > finding the local cpu number, and dereference an array of cpu offsets with
> > > that number to find the local cpu offset.
> > > __get_cpu_var() does a direct access to __my_cpu_offset which is a nice
> > > shortcut if the arch implements it.
> 
> [Adding Christoph Lameter to CC list]
> 
> This is not quite true on x86_64 and s390 anymore. __get_cpu_var() now
> uses a segment selector override to get the local CPU variable on x86.
> See x86's percpu.h for details.
> 
> So even performance-wise, using __get_cpu_var() over per_cpu() should be
> a win on widely used architectures nowadays,

Looking at x86_64, it indeed optimizes further by overriding this_cpu_ptr().
It does the same than the generic this_cpu_ptr() on an
overriden my_cpu_offset, but it also economizes a temporary store.

> 
> > 
> > True, but we could also argue that the multiple checks for being preempt
> > can also be an issue.
> 
> At least on x86 preemption don't actually need to be disabled: selection
> of the right per-cpu memory location is done atomically with the rest of
> the instruction by the segment selector.

It depends on the case, you may still need to disable preemption if you use
your variable further than just a quick op, which is often the case.

That's up to this_cpu_add() op things, depending on what the arch is capable
of wrt. local atomicity.
