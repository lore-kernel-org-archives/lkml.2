Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2AZChf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 21:37:35 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55077 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431Ab2AZChd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 21:37:33 -0500
Date: Thu, 26 Jan 2012 03:37:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120126023726.GI20878@somewhere>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-3-git-send-email-jolsa@redhat.com>
 <20120120170232.GF18056@somewhere>
 <1327533221.22710.74.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327533221.22710.74.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 06:13:41PM -0500, Steven Rostedt wrote:
> On Fri, 2012-01-20 at 18:02 +0100, Frederic Weisbecker wrote:
> >  
> > > +/**
> > > + * ftrace_function_enable - enable controlled ftrace_ops on given cpu
> > > + *
> > > + * This function enables tracing on given cpu by decreasing
> > > + * the per cpu control variable.
> > > + * It must be called with preemption disabled and only on
> > > + * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
> > > + */
> > > +static inline void ftrace_function_enable(struct ftrace_ops *ops, int cpu)
> > > +{
> > > +	atomic_t *disabled;
> > > +
> > > +	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL) ||
> > > +			 !preempt_count()))
> > > +		return;
> > > +
> > > +	disabled = per_cpu_ptr(ops->disabled, cpu);
> > > +	atomic_dec(disabled);
> > > +}
> > 
> > As you're using this for the local CPU exclusively, I suggest you rather
> > rename it to "ftrace_function_{dis,en}able_cpu(struct ftrace_ops *ops)"
> 
> I wonder if "ftrace_function_local_{dis,en}able(ops)" would be better?
> That would match something like local_irq_disable/enable.

Good idea.

> 
> > and use __get_cpu_var() that does the preempt check for you.
> 
> Hmm, I haven't tried that with allocated per_cpu pointers before. If it
> works, sure.

Yeah that works. In fact this_cpu_ptr() would do the best. Both this_cpu_ptr()
and __get_cpu_var() map to the same internal ops with preemption checks.

> > >  static void
> > > +ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip)
> > > +{
> > > +	struct ftrace_ops *op;
> > > +	int cpu;
> > > +
> > > +	if (unlikely(trace_recursion_test(TRACE_CONTROL_BIT)))
> > > +		return;
> > > +
> > > +	/*
> > > +	 * Some of the ops may be dynamically allocated,
> > > +	 * they must be freed after a synchronize_sched().
> > > +	 */
> > > +	preempt_disable_notrace();
> > > +	trace_recursion_set(TRACE_CONTROL_BIT);
> > > +	cpu = smp_processor_id();
> > > +	op = rcu_dereference_raw(ftrace_control_list);
> > > +	while (op != &ftrace_list_end) {
> > > +		if (!control_ops_is_disabled(op, cpu) &&
> > > +		    ftrace_ops_test(op, ip))
> > > +			op->func(ip, parent_ip);
> > > +
> > > +		op = rcu_dereference_raw(op->next);
> > 
> > Should it be rcu_dereference_sched() ?
> 
> From the comment posted by Paul McKenney who converted the global_list
> ops (that does somewhat the same thing as the control ops here):
> 
> /*
>  * Traverse the ftrace_global_list, invoking all entries.  The reason that we
>  * can use rcu_dereference_raw() is that elements removed from this list
>  * are simply leaked, so there is no need to interact with a grace-period
>  * mechanism.  The rcu_dereference_raw() calls are needed to handle
>  * concurrent insertions into the ftrace_global_list.
>  *
>  * Silly Alpha and silly pointer-speculation compiler optimizations!
>  */

Ok.

> 
> 
> But then reading the commit he has:
> 
>     Replace the calls to read_barrier_depends() in
>     ftrace_list_func() with rcu_dereference_raw() to improve
>     readability.  The reason that we use rcu_dereference_raw() here
>     is that removed entries are never freed, instead they are simply
>     leaked.  This is one of a very few cases where use of
>     rcu_dereference_raw() is the long-term right answer.  And I
>     don't yet know of any others.  ;-)
> 
> Hmm, and I use the rcu_derefrence_raw() in other places in this file,
> but those places now get freed. Although, I'm a bit nervous in changing
> these to rcu_dereference_sched, because if CONFIG_DEBUG_LOCK_ALLOC is
> enabled, then the checks will be done for *every function* called.
> 
> We obviously have preemption disabled, or other bad things may happen.
> Wonder if we really need this?  Ftrace itself is a internal checker and
> not truly a kernel component. It may be "exempt" from theses checks ;-)
> 
> I could make the switch and see what overhead this causes. It may live
> lock the system. It wouldn't be the first time lockdep & ftrace live
> locked the system. Or made it so unbearably slow.

Yeah right. We can probably make this exception for function tracing by
keeping rcu_dereference_raw(). But now that it involves a grace period,
the comment probably should be updated :)

> Lockdep and ftrace do
> not play well together. They both are very intrusive. The two remind me
> of the United States congress. Where there is two parties trying to take
> control of everything, but nothing ever gets done. We end up with a
> grid/live lock in the country/computer.

:o)

> > 
> > > +	};
> > > +	trace_recursion_clear(TRACE_CONTROL_BIT);
> > > +	preempt_enable_notrace();
> > > +}
> > > +
> > > +static struct ftrace_ops control_ops = {
> > > +	.func = ftrace_ops_control_func,
> > > +};
> > 
> > So note this patch is optimizing for the off case (when
> > we have called pmu->del()), but at the cost of having an
> > impact in the on case with having at least one level
> > of multiplexing (and two on the worst case if we have ftrace
> > running in parallel but this is enough a corner case that we
> > don't care).
> > 
> > But this is perhaps still a win.
> 
> There's a lot more overhead elsewhere that this shouldn't be an issue.

Yeah that looks fine.
