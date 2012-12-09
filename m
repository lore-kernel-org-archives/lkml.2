Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401Ab2LITOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 14:14:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814Ab2LITOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 14:14:43 -0500
Date: Sun, 9 Dec 2012 20:14:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU
	offline from atomic context
Message-ID: <20121209191437.GA2816@redhat.com>
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07, Srivatsa S. Bhat wrote:
>
> Per-cpu counters can help solve the cache-line bouncing problem. So we
> actually use the best of both: per-cpu counters (no-waiting) at the reader
> side in the fast-path, and global rwlocks in the slowpath.
>
> [ Fastpath = no writer is active; Slowpath = a writer is active ]
>
> IOW, the hotplug readers just increment/decrement their per-cpu refcounts
> when no writer is active.

Plus LOCK and cli/sti. I do not pretend I really know how bad this is
performance-wise though. And at first glance this look overcomplicated.

But yes, it is easy to blame somebody else's code ;) And I can't suggest
something better at least right now. If I understand correctly, we can not
use, say, synchronize_sched() in _cpu_down() path, you also want to improve
the latency. And I guess something like kick_all_cpus_sync() is "too heavy".

Also. After the quick reading this doesn't look correct, please see below.

> +void get_online_cpus_atomic(void)
> +{
> +	unsigned int cpu = smp_processor_id();
> +	unsigned long flags;
> +
> +	preempt_disable();
> +	local_irq_save(flags);
> +
> +	if (cpu_hotplug.active_writer == current)
> +		goto out;
> +
> +	smp_rmb(); /* Paired with smp_wmb() in drop_writer_signal() */
> +
> +	if (likely(!writer_active(cpu))) {

WINDOW. Suppose that reader_active() == F.

> +		mark_reader_fastpath();
> +		goto out;

Why take_cpu_down() can't do announce_cpu_offline_begin() + sync_all_readers()
in between?

Looks like we should increment the counter first, then check writer_active().
And sync_atomic_reader() needs rmb between 2 atomic_read's.


Or. Again, suppose that reader_active() == F. But is_new_writer() == T.

> +	if (is_new_writer(cpu)) {
> +		/*
> +		 * ACK the writer's signal only if this is a fresh read-side
> +		 * critical section, and not just an extension of a running
> +		 * (nested) read-side critical section.
> +		 */
> +		if (!reader_active(cpu)) {
> +			ack_writer_signal();

What if take_cpu_down() does announce_cpu_offline_end() right before
ack_writer_signal() ? In this case get_online_cpus_atomic() returns
with writer_signal == -1. If nothing else this breaks the next
raise_writer_signal().

Oleg.

