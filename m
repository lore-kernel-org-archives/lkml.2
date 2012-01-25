Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2AYXNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:13:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2AYXNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:13:44 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ravTz9YwjkQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=4J3sseGrNZgZm6rhoP8A:9 a=l8q8ktyxNqY60g0xdZ4A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327533221.22710.74.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Wed, 25 Jan 2012 18:13:41 -0500
In-Reply-To: <20120120170232.GF18056@somewhere>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
	 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
	 <1326912275-26405-3-git-send-email-jolsa@redhat.com>
	 <20120120170232.GF18056@somewhere>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 18:02 +0100, Frederic Weisbecker wrote:
>  
> > +/**
> > + * ftrace_function_enable - enable controlled ftrace_ops on given cpu
> > + *
> > + * This function enables tracing on given cpu by decreasing
> > + * the per cpu control variable.
> > + * It must be called with preemption disabled and only on
> > + * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
> > + */
> > +static inline void ftrace_function_enable(struct ftrace_ops *ops, int cpu)
> > +{
> > +	atomic_t *disabled;
> > +
> > +	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL) ||
> > +			 !preempt_count()))
> > +		return;
> > +
> > +	disabled = per_cpu_ptr(ops->disabled, cpu);
> > +	atomic_dec(disabled);
> > +}
> 
> As you're using this for the local CPU exclusively, I suggest you rather
> rename it to "ftrace_function_{dis,en}able_cpu(struct ftrace_ops *ops)"

I wonder if "ftrace_function_local_{dis,en}able(ops)" would be better?
That would match something like local_irq_disable/enable.

> and use __get_cpu_var() that does the preempt check for you.

Hmm, I haven't tried that with allocated per_cpu pointers before. If it
works, sure.

> 
> [...]
> > +static void control_ops_disable_all(struct ftrace_ops *ops)
> > +{
> > +	int cpu;
> > +
> > +	for_each_possible_cpu(cpu)
> > +		atomic_set(per_cpu_ptr(ops->disabled, cpu), 1);
> > +}
> > +
> > +static int control_ops_alloc(struct ftrace_ops *ops)
> > +{
> > +	atomic_t *disabled;
> > +
> > +	disabled = alloc_percpu(atomic_t);
> > +	if (!disabled)
> > +		return -ENOMEM;
> > +
> > +	ops->disabled = disabled;
> > +	control_ops_disable_all(ops);
> > +	return 0;
> > +}
> > +
> > +static void control_ops_free(struct ftrace_ops *ops)
> > +{
> > +	free_percpu(ops->disabled);
> > +}
> > +
> > +static int control_ops_is_disabled(struct ftrace_ops *ops, int cpu)
> > +{
> > +	atomic_t *disabled = per_cpu_ptr(ops->disabled, cpu);
> > +	return atomic_read(disabled);
> 
> I think this is checked only locally. Better use __get_cpu_var().

If it works, sure.

> Also note atomic_read() doesn't involve an smp barrier.

None needed, as this should all be done for the same CPU, and preemption
disabled.


> 
> atomic_inc/dec are smp safe wrt. ordering. But atomic_set() and atomic_read()
> are not. I believe this is safe because we still have PERF_HES_STOPPED check.

It should be safe because smp is not involved. We disable/enable
function tracing per cpu, and then check per cpu if it is running. The
same task will disable or enable it (I believe in the scheduler).

> 
> And also it seems we read the value from the same CPU we have set it. So
> we actually don't need SMP ordering. But then this raise the question of

Right.

> the relevance of using atomic ops. Normal values would do the trick.

Good point. The atomic here isn't needed.

> 
> [...]
> >  static void
> > +ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip)
> > +{
> > +	struct ftrace_ops *op;
> > +	int cpu;
> > +
> > +	if (unlikely(trace_recursion_test(TRACE_CONTROL_BIT)))
> > +		return;
> > +
> > +	/*
> > +	 * Some of the ops may be dynamically allocated,
> > +	 * they must be freed after a synchronize_sched().
> > +	 */
> > +	preempt_disable_notrace();
> > +	trace_recursion_set(TRACE_CONTROL_BIT);
> > +	cpu = smp_processor_id();
> > +	op = rcu_dereference_raw(ftrace_control_list);
> > +	while (op != &ftrace_list_end) {
> > +		if (!control_ops_is_disabled(op, cpu) &&
> > +		    ftrace_ops_test(op, ip))
> > +			op->func(ip, parent_ip);
> > +
> > +		op = rcu_dereference_raw(op->next);
> 
> Should it be rcu_dereference_sched() ?

>From the comment posted by Paul McKenney who converted the global_list
ops (that does somewhat the same thing as the control ops here):

/*
 * Traverse the ftrace_global_list, invoking all entries.  The reason that we
 * can use rcu_dereference_raw() is that elements removed from this list
 * are simply leaked, so there is no need to interact with a grace-period
 * mechanism.  The rcu_dereference_raw() calls are needed to handle
 * concurrent insertions into the ftrace_global_list.
 *
 * Silly Alpha and silly pointer-speculation compiler optimizations!
 */


But then reading the commit he has:

    Replace the calls to read_barrier_depends() in
    ftrace_list_func() with rcu_dereference_raw() to improve
    readability.  The reason that we use rcu_dereference_raw() here
    is that removed entries are never freed, instead they are simply
    leaked.  This is one of a very few cases where use of
    rcu_dereference_raw() is the long-term right answer.  And I
    don't yet know of any others.  ;-)

Hmm, and I use the rcu_derefrence_raw() in other places in this file,
but those places now get freed. Although, I'm a bit nervous in changing
these to rcu_dereference_sched, because if CONFIG_DEBUG_LOCK_ALLOC is
enabled, then the checks will be done for *every function* called.

We obviously have preemption disabled, or other bad things may happen.
Wonder if we really need this?  Ftrace itself is a internal checker and
not truly a kernel component. It may be "exempt" from theses checks ;-)

I could make the switch and see what overhead this causes. It may live
lock the system. It wouldn't be the first time lockdep & ftrace live
locked the system. Or made it so unbearably slow. Lockdep and ftrace do
not play well together. They both are very intrusive. The two remind me
of the United States congress. Where there is two parties trying to take
control of everything, but nothing ever gets done. We end up with a
grid/live lock in the country/computer.
 
> 
> > +	};
> > +	trace_recursion_clear(TRACE_CONTROL_BIT);
> > +	preempt_enable_notrace();
> > +}
> > +
> > +static struct ftrace_ops control_ops = {
> > +	.func = ftrace_ops_control_func,
> > +};
> 
> So note this patch is optimizing for the off case (when
> we have called pmu->del()), but at the cost of having an
> impact in the on case with having at least one level
> of multiplexing (and two on the worst case if we have ftrace
> running in parallel but this is enough a corner case that we
> don't care).
> 
> But this is perhaps still a win.

There's a lot more overhead elsewhere that this shouldn't be an issue.

-- Steve


