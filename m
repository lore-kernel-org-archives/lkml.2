Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2GURN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 13:13:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42551 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab2GURNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 13:13:24 -0400
Date: Sat, 21 Jul 2012 10:12:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 3/7] smpboot: Provide infrastructure for percpu hotplug
 threads
Message-ID: <20120721171259.GA6698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120716103749.122800930@linutronix.de>
 <20120716103948.352501068@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716103948.352501068@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072117-2356-0000-0000-0000008F744E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 10:42:36AM -0000, Thomas Gleixner wrote:
> Provide a generic interface for setting up and tearing down percpu
> threads.
> 
> On registration the threads for already online cpus are created and
> started. On deregistration (modules) the threads are stoppped.
> 
> During hotplug operations the threads are created, started, parked and
> unparked. The datastructure for registration provides a pointer to
> percpu storage space and optional setup, cleanup, park, unpark
> functions. These functions are called when the thread state changes.
> 
> Each implementation has to provide a function which is queried and
> returns whether the thread should run and the thread function itself.
> 
> The core code handles all state transitions and avoids duplicated code
> in the call sites.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

This approach certainly results in much nicer code!

One issue noted below.

							Thanx, Paul

> +static int smpboot_thread_fn(void *data)
> +{
> +	struct smpboot_thread_data *td = data;
> +	struct smp_hotplug_thread *ht = td->ht;
> +
> +	while (1) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		preempt_disable();
> +		if (kthread_should_stop()) {
> +			set_current_state(TASK_RUNNING);
> +			preempt_enable();
> +			if (ht->cleanup)
> +				ht->cleanup(td->cpu, cpu_online(td->cpu));
> +			kfree(td);
> +			return 0;
> +		}
> +
> +		if (kthread_should_park()) {
> +			__set_current_state(TASK_RUNNING);
> +			preempt_enable();
> +			if (ht->park && td->status == HP_THREAD_ACTIVE) {
> +				BUG_ON(td->cpu != smp_processor_id());
> +				ht->park(td->cpu);
> +				td->status = HP_THREAD_PARKED;
> +			}
> +			kthread_parkme();
> +			/* We might have been woken for stop */
> +			continue;
> +		}
> +
> +		BUG_ON(td->cpu != smp_processor_id());
> +
> +		/* Check for state change setup */
> +		switch (td->status) {
> +		case HP_THREAD_NONE:
> +			preempt_enable();
> +			if (ht->setup)
> +				ht->setup(td->cpu);
> +			td->status = HP_THREAD_ACTIVE;
> +			preempt_disable();
> +			break;
> +		case HP_THREAD_PARKED:
> +			preempt_enable();
> +			if (ht->unpark)
> +				ht->unpark(td->cpu);
> +			td->status = HP_THREAD_ACTIVE;
> +			preempt_disable();
> +			break;
> +		}
> +
> +		if (!ht->thread_should_run(td->cpu)) {
> +			schedule_preempt_disabled();
> +		} else {
> +			set_current_state(TASK_RUNNING);
> +			preempt_enable();
> +			ht->thread_fn(td->cpu);
> +			preempt_disable();
> +		}

At this point, preemption is disabled, but the code at the beginning
of the loop will disable it again.  This results in "scheduling while
atomic" splats.  I did the following to clear them up:

+		if (!ht->thread_should_run(td->cpu)) {
+			preempt_enable();
+			schedule();
+		} else {
+			set_current_state(TASK_RUNNING);
+			preempt_enable();
+			ht->thread_fn(td->cpu);
+		}

I also placed the updated series on -rcu at branch rcu/smp/hotplug
(git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git),
based on tip/smp/hotplug, for Linaro testing purposes.

							Thanx, Paul

