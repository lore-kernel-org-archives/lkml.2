Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454Ab2LITvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 14:51:55 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36848 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934440Ab2LITvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 14:51:53 -0500
Message-ID: <50C4EB79.5050203@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 01:20:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com> <20121209191437.GA2816@redhat.com>
In-Reply-To: <20121209191437.GA2816@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120919-5490-0000-0000-0000029E1EF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 12:44 AM, Oleg Nesterov wrote:
> On 12/07, Srivatsa S. Bhat wrote:
>>
>> Per-cpu counters can help solve the cache-line bouncing problem. So we
>> actually use the best of both: per-cpu counters (no-waiting) at the reader
>> side in the fast-path, and global rwlocks in the slowpath.
>>
>> [ Fastpath = no writer is active; Slowpath = a writer is active ]
>>
>> IOW, the hotplug readers just increment/decrement their per-cpu refcounts
>> when no writer is active.
> 
> Plus LOCK and cli/sti. I do not pretend I really know how bad this is
> performance-wise though. And at first glance this look overcomplicated.
>

Hehe, I agree ;-) But I couldn't think of any other way to get rid of the
deadlock possibilities, other than using global rwlocks. So I designed a
way in which we can switch between per-cpu counters and global rwlocks
dynamically. Probably there is a smarter way to achieve what we want, dunno...
 
> But yes, it is easy to blame somebody else's code ;) And I can't suggest
> something better at least right now. If I understand correctly, we can not
> use, say, synchronize_sched() in _cpu_down() path

We can't sleep in that code.. so that's a no-go.

>, you also want to improve
> the latency. And I guess something like kick_all_cpus_sync() is "too heavy".
> 

I hadn't considered that. Thinking of it, I don't think it would help us..
It won't get rid of the currently running preempt_disable() sections no?

> Also. After the quick reading this doesn't look correct, please see below.
> 
>> +void get_online_cpus_atomic(void)
>> +{
>> +	unsigned int cpu = smp_processor_id();
>> +	unsigned long flags;
>> +
>> +	preempt_disable();
>> +	local_irq_save(flags);
>> +
>> +	if (cpu_hotplug.active_writer == current)
>> +		goto out;
>> +
>> +	smp_rmb(); /* Paired with smp_wmb() in drop_writer_signal() */
>> +
>> +	if (likely(!writer_active(cpu))) {
> 
> WINDOW. Suppose that reader_active() == F.
> 
>> +		mark_reader_fastpath();
>> +		goto out;
> 
> Why take_cpu_down() can't do announce_cpu_offline_begin() + sync_all_readers()
> in between?
> 
> Looks like we should increment the counter first, then check writer_active().

You are right, I missed the above race-conditions.

> And sync_atomic_reader() needs rmb between 2 atomic_read's.
> 

OK.

> 
> Or. Again, suppose that reader_active() == F. But is_new_writer() == T.
> 
>> +	if (is_new_writer(cpu)) {
>> +		/*
>> +		 * ACK the writer's signal only if this is a fresh read-side
>> +		 * critical section, and not just an extension of a running
>> +		 * (nested) read-side critical section.
>> +		 */
>> +		if (!reader_active(cpu)) {
>> +			ack_writer_signal();
> 
> What if take_cpu_down() does announce_cpu_offline_end() right before
> ack_writer_signal() ? In this case get_online_cpus_atomic() returns
> with writer_signal == -1. If nothing else this breaks the next
> raise_writer_signal().
> 

Oh, yes, this one is wrong too! We need to mark ourselves as active
reader right in the beginning. And probably change the check to
"reader_nested()" or something like that.

Thanks a lot Oleg!
Regards,
Srivatsa S. Bhat

