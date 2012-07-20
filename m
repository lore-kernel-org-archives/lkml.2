Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab2GTF1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 01:27:25 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:54849 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2GTF1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 01:27:22 -0400
X-AuditID: b753bd60-95ef6ba000004f2e-3a-5008ebb4f206
X-AuditID: b753bd60-95ef6ba000004f2e-3a-5008ebb4f206
Message-ID: <5008EBE7.4000302@hitachi.com>
Date: Fri, 20 Jul 2012 14:25:59 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Rob Landley <rob@landley.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -tip ] tracing: make a snapshot feature available
 from userspace.
References: <20120605120637.16419.43353.stgit@jirocho.sdl.hitachi.co.jp> <1342049178.14828.67.camel@gandalf.stny.rr.com>
In-Reply-To: <1342049178.14828.67.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven,
(Sorry for the late reply.)

Tnank you for your comments.

(2012/07/12 8:26), Steven Rostedt wrote:
>> +Snapshot
>> +--------
>> +If CONFIG_TRACER_MAX_TRACE is set, the (generic) snapshot
>> +feature is available in all tracers except for the special
>> +tracers which use a snapshot inside themselves(such as "irqsoff"
>> +or "wakeup").
> 
> I find this kind of ironic, that it is only defined when one of the
> tracers that can't use it defines it.
> 

Ah, I missed that.

> Maybe we should make it a prompt config for this feature.
> 

Yes, I'll make the new config like "CONFIG_TRACER_SNAPSHOT".


>> +  snapshot_enabled:
>> +
>> +	This is used to set or display whether the snapshot is
>> +	enabled. Echo 1 into this file to prepare a spare buffer
>> +	or 0 to shrink it. So, the memory for the spare buffer
>> +	will be consumed only when this knob is set.
>> +
>> +  snapshot_pipe:
>> +
>> +	This is used to take a snapshot and to read the output
>> +	of the snapshot. Echo 1 into this file to take a
>> +	snapshot. Reads from this file is the same as the
>> +	"trace_pipe" file (described above "The File System"
>> +	section), so that both reads from the snapshot and
>> +	tracing are executable in parallel.
> 
> I don't really like the name snapshot_pipe. What about just calling it
> snapshot, and just document that it works like trace_pipe?
> 

Agreed. I'll change the name to snapshot and modify document.


> Also, rename snapshot_enabled, to snapshot_allocate. If someone echos 1
> into snapshot, it would automatically allocate the buffer (and set
> snapshot_allocate to 1). If you don't want the delay (for allocation),
> then you can do the echo 1 into snapshot_allocate first, and it would
> behave as it does here.
> 

I'll change them to that way.

> 
>> +
>> +Here is an example of using the snapshot feature.
>> +
>> + # echo nop > current_tracer
>> + # echo 1 > snapshot_enabled
>> + # echo 1 > events/sched/enable
>> + [...]
>> + # echo 1 > snapshot_pipe
>> + # cat snapshot_pipe
>> +            bash-3352  [001] dN.. 18440.883932: sched_wakeup: comm=migration/6 pid=28 prio=0 success=1 target_cpu=006
>> +            bash-3352  [001] dN.. 18440.883933: sched_wakeup: comm=migration/7 pid=32 prio=0 success=1 target_cpu=007
>> +            bash-3352  [001] d... 18440.883935: sched_switch: prev_comm=bash prev_pid=3352 prev_prio=120 prev_state=R ==> next_comm=migration/1 next_pid=8 next_prio=0
>> +[...]
> 
> BTW, why make it a pipe action anyway? As a snapshot doesn't have a
> writer to it, doing just an iterate over the snapshot would make sense,
> wouldn't it?
> 

I thought I should reuse existing code as much as possible. So I'd like
to reuse the "trace" code at first. But opening "trace" stops tracing
until it is closed. Therefore, I reused "trace_pipe" code instead of
"trace".

However, it seems that I should have made new iteration code as you
pointed out. I will make it the "trace"-like action.

> If you reply with a good rational for keeping the snapshot_pipe, then we
> should have both snapshot and snapshot_pipe, where snapshot works like
> trace and snapshot_pipe works like trace_pipe.
> 

I think only "snapshot" file is enough for the present.


>> +static ssize_t
>> +tracing_write_snapshot_pipe(struct file *filp, const char __user *ubuf,
>> +		       size_t cnt, loff_t *ppos)
>> +{
>> +	unsigned long val = 0;
>> +	int ret;
>> +
>> +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	mutex_lock(&trace_types_lock);
>> +
>> +	/* If current tracer's use_max_tr == 0, we prevent taking a snapshot */
> 
> Here we should just allocate it first.
> 

OK. I'll add that.

>> +	if (!current_trace->use_max_tr) {
> 
> I also have issues with the use of 'use_max_tr' here, but I'll explain
> that below.
> 
>> +		ret = -EBUSY;
>> +		goto out;
>> +	}
>> +	if (val) {
>> +		unsigned long flags;
>> +		local_irq_save(flags);
> 
> Interrupts will never be disabled here. Just use
> 'local_irq_disable/enable()', and remove flags.
> 

Yes. I'll fix it.

>> +		update_max_tr(&global_trace, current, raw_smp_processor_id());
> 
> Also, get rid of the 'raw_' that's for critical paths that can be broken
> by the debug version of the normal user (like in function tracing and
> callbacks from disabling interrupts).
> 

I'll fix it.


>> +static ssize_t
>> +tracing_snapshot_ctrl_write(struct file *filp, const char __user *ubuf,
>> +			    size_t cnt, loff_t *ppos)
>> +{
>> +	unsigned long val;
>> +	int ret;
>> +
>> +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	val = !!val;
>> +
>> +	mutex_lock(&trace_types_lock);
>> +	tracing_stop();
>> +	arch_spin_lock(&ftrace_max_lock);
>> +
>> +	/* When always_use_max_tr == 1, we can't toggle use_max_tr. */
>> +	if (current_trace->always_use_max_tr) {
> 
> I'll state my issue here. Don't rename use_max_tr to always_use_max_tr,
> keep it as is and its use as is. Your other value should be
> "allocated_snapshot", which can be set even for the use_max_tr user.
> 

Yes. I'll put use_max_tr back to its original.

> 
>> +		ret = -EBUSY;
>> +		goto out;
>> +	}
>> +
>> +	if (!(current_trace->use_max_tr ^ val))
>> +		goto out;
>> +
>> +	if (val) {
>> +		int cpu;
>> +		for_each_tracing_cpu(cpu) {
>> +			ret = ring_buffer_resize(max_tr.buffer,
>> +						global_trace.data[cpu]->entries,
>> +						cpu);
>> +			if (ret < 0)
>> +				break;
>> +			max_tr.data[cpu]->entries =
>> +				global_trace.data[cpu]->entries;
>> +		}
>> +		if (ret < 0) {
>> +			ring_buffer_resize(max_tr.buffer, 1,
>> +					   RING_BUFFER_ALL_CPUS);
>> +			set_buffer_entries(&max_tr, 1);
>> +			ret = -ENOMEM;
>> +			goto out;
>> +		}
> 
> The above code is basically duplicated by the
> __tracing_resize_ring_buffer(). As this code is not that trivial, lets
> make use of a helper function and keep the bugs in one location. Have
> both this function and the resize function use the same code.
> 
> In fact, the __tracing_resize_ring_buffer() could be modified to do all
> the work. It will either shrink or expand as necessary. This isn't a
> critical section so calling ring_buffer_resize() even when there's
> nothing to do should not be an issue.
> 

OK. I think I can make the common helper function.

> In fact, I think there's a small bug in the code that you just
> duplicated. Not your bug, but you copied it.
> 

Oh, I didn't notice that...
Is it related to return value?


>>  struct tracer {
>>  	const char		*name;
>> @@ -286,7 +288,13 @@ struct tracer {
>>  	struct tracer		*next;
>>  	struct tracer_flags	*flags;
>>  	int			print_max;
>> +	/* Dynamically toggled via "snapshot_enabled" debugfs file */
>>  	int			use_max_tr;
>> +	/*
>> +	 * If this value is 1, this tracer always uses max_tr and "use_max_tr"
>> +	 * can't be toggled.
>> +	 */
>> +	int			always_use_max_tr;
> 
> I already said how I dislike this. Leave use_max_tr alone, but add a
> allocated_snapshot. Also, I hate the wasting of 4 bytes just to act like
> a flag. We should probably make print_max, use_max_tr and
> always_use_max_tr into 'bool's.
> 
> The print_max change should be a separate patch.
> 

I see.
By the way, I noticed that struct tracer's values become invisible when
the current_tracer is changed. This may be somewhat problematic. I'm now
considering we should put the allocated_snapshot value into global
trace_flags as a flag and access this value by
options/snapshot_allocate. What do you think of this?


>>  };
>>  
>>
>> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
>> index 99d20e9..37cdb75 100644
>> --- a/kernel/trace/trace_irqsoff.c
>> +++ b/kernel/trace/trace_irqsoff.c
>> @@ -614,6 +614,7 @@ static struct tracer irqsoff_tracer __read_mostly =
>>  	.open           = irqsoff_trace_open,
>>  	.close          = irqsoff_trace_close,
>>  	.use_max_tr	= 1,
>> +	.always_use_max_tr	= 1,
> 
> Remove all these. Have the 'allocated_snapshot' get set when the tracer
> is added, not here.
> 

OK, I'll remove them.


> But on the whole, I like the idea of a snapshot (and this has actually
> been on my todo list for some time, thanks for doing it for me ;-)
> 

Thank you for your review!

Best regards,
Hiraku Toyooka

