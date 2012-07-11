Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030560Ab2GKX0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 19:26:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21963 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030544Ab2GKX0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 19:26:21 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=s7eJLgHA8LkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ag1SF4gXAAAA:8 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=y5Yq1ZyPAAAA:8 a=VwQbUJbxAAAA:8 a=W41WdEzfMOnPMITjtFEA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=nt6uV6JkblEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1342049178.14828.67.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH -tip ] tracing: make a snapshot feature available
 from userspace.
From: Steven Rostedt <rostedt@goodmis.org>
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Rob Landley <rob@landley.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 19:26:18 -0400
In-Reply-To: <20120605120637.16419.43353.stgit@jirocho.sdl.hitachi.co.jp>
References: <20120605120637.16419.43353.stgit@jirocho.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for taking so long, I've been hammering away at other things. :-/


On Tue, 2012-06-05 at 21:06 +0900, Hiraku Toyooka wrote:
> Hello,
> 
> This patch provides new debugfs interfaces for taking a snapshot
> in ftrace.
> 
> Ftrace is available as a flight recorder. When a kernel panic
> occurs, we can get trace data from the dumped kernel image.
> 
> But in case of some systems, non-critical errors (such as
> application's errors) are difficult to handle because of following
> reasons.
> 
>  - When the system has to continue to run, it can't stop tracing.
>  - Even then, failure analysis is necessary to prevent the same
>    errors.
> 
> So, I propose making the ftrace's snapshot feature available from
> userspace to solve above dilemma.
> (See also
> https://events.linuxfoundation.org/images/stories/pdf/lcjp2012_toyooka.pdf)
> 
> This enables to preserve trace buffer at a particular point in time
> without stopping tracing.  When a snapshot is taken, ftrace swaps the
> current buffer with a spare buffer which is prepared in advance. This
> means that the tracing itself continues on the spare buffer.
> 
> Currently, ftrace has a snapshot feature available from kernel space
> and some tracers (e.g. irqsoff) are using it. This patch allows users
> to use the same snapshot feature via debugfs.
> 
> I added two debugfs files in "tracing" directory.
> 
>   snapshot_enabled:
> 
>         This is used to set or display whether the snapshot is
>         enabled. Echo 1 into this file to prepare a spare buffer
>         or 0 to shrink it. So, the memory for the spare buffer
>         will be consumed only when this knob is set.
> 
>   snapshot_pipe:
> 
>         This is used to take a snapshot and to read the output
>         of the snapshot (max_tr). Echo 1 into this file to take a
>         snapshot. Reads from this file is the same as the
>         "trace_pipe" file.
> 
> Here is an example of using the snapshot feature.
> 
>  # echo nop > current_tracer
>  # echo 1 > snapshot_enabled
>  # echo 1 > events/sched/enable
>  [...]
>  # echo 1 > snapshot_pipe
>  # cat snapshot_pipe
>             bash-3352  [001] dN.. 18440.883932: sched_wakeup: comm=migration/6 p
> id=28 prio=0 success=1 target_cpu=006
>             bash-3352  [001] dN.. 18440.883933: sched_wakeup: comm=migration/7 p
> id=32 prio=0 success=1 target_cpu=007
>             bash-3352  [001] d... 18440.883935: sched_switch: prev_comm=bash pre
> v_pid=3352 prev_prio=120 prev_state=R ==> next_comm=migration/1 next_pid=8 next_
> prio=0
> [...]
> 
> 
> Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  Documentation/trace/ftrace.txt    |   47 +++++++++++
>  kernel/trace/trace.c              |  152 +++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.h              |    8 ++
>  kernel/trace/trace_irqsoff.c      |    3 +
>  kernel/trace/trace_sched_wakeup.c |    2 
>  5 files changed, 210 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index 6f51fed..df9fa13 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -1842,6 +1842,53 @@ an error.
>   # cat buffer_size_kb
>  85
>  
> +
> +Snapshot
> +--------
> +If CONFIG_TRACER_MAX_TRACE is set, the (generic) snapshot
> +feature is available in all tracers except for the special
> +tracers which use a snapshot inside themselves(such as "irqsoff"
> +or "wakeup").

I find this kind of ironic, that it is only defined when one of the
tracers that can't use it defines it.

Maybe we should make it a prompt config for this feature.

> +
> +This enables to preserve trace buffer at a particular point in
> +time without stopping tracing.  When a snapshot is taken, ftrace
> +swaps the current buffer with a spare buffer which is prepared
> +in advance. This means that the tracing itself continues on the
> +spare buffer.
> +
> +Following debugfs files in "tracing" directory are related with
> +this feature.
> +
> +  snapshot_enabled:
> +
> +	This is used to set or display whether the snapshot is
> +	enabled. Echo 1 into this file to prepare a spare buffer
> +	or 0 to shrink it. So, the memory for the spare buffer
> +	will be consumed only when this knob is set.
> +
> +  snapshot_pipe:
> +
> +	This is used to take a snapshot and to read the output
> +	of the snapshot. Echo 1 into this file to take a
> +	snapshot. Reads from this file is the same as the
> +	"trace_pipe" file (described above "The File System"
> +	section), so that both reads from the snapshot and
> +	tracing are executable in parallel.

I don't really like the name snapshot_pipe. What about just calling it
snapshot, and just document that it works like trace_pipe?

Also, rename snapshot_enabled, to snapshot_allocate. If someone echos 1
into snapshot, it would automatically allocate the buffer (and set
snapshot_allocate to 1). If you don't want the delay (for allocation),
then you can do the echo 1 into snapshot_allocate first, and it would
behave as it does here.


> +
> +Here is an example of using the snapshot feature.
> +
> + # echo nop > current_tracer
> + # echo 1 > snapshot_enabled
> + # echo 1 > events/sched/enable
> + [...]
> + # echo 1 > snapshot_pipe
> + # cat snapshot_pipe
> +            bash-3352  [001] dN.. 18440.883932: sched_wakeup: comm=migration/6 pid=28 prio=0 success=1 target_cpu=006
> +            bash-3352  [001] dN.. 18440.883933: sched_wakeup: comm=migration/7 pid=32 prio=0 success=1 target_cpu=007
> +            bash-3352  [001] d... 18440.883935: sched_switch: prev_comm=bash prev_pid=3352 prev_prio=120 prev_state=R ==> next_comm=migration/1 next_pid=8 next_prio=0
> +[...]

BTW, why make it a pipe action anyway? As a snapshot doesn't have a
writer to it, doing just an iterate over the snapshot would make sense,
wouldn't it?

If you reply with a good rational for keeping the snapshot_pipe, then we
should have both snapshot and snapshot_pipe, where snapshot works like
trace and snapshot_pipe works like trace_pipe.

> +
> +
>  -----------
>  
>  More details can be found in the source code, in the
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 68032c6..8e722c3 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3266,7 +3266,8 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
>  	return cnt;
>  }
>  
> -static int tracing_open_pipe(struct inode *inode, struct file *filp)
> +static int __tracing_open_pipe(struct inode *inode, struct file *filp,
> +			       struct trace_array *tr)
>  {
>  	long cpu_file = (long) inode->i_private;
>  	struct trace_iterator *iter;
> @@ -3308,7 +3309,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  		iter->iter_flags |= TRACE_FILE_LAT_FMT;
>  
>  	iter->cpu_file = cpu_file;
> -	iter->tr = &global_trace;
> +	iter->tr = tr;
>  	mutex_init(&iter->mutex);
>  	filp->private_data = iter;
>  
> @@ -3327,6 +3328,11 @@ fail:
>  	return ret;
>  }
>  
> +static int tracing_open_pipe(struct inode *inode, struct file *filp)
> +{
> +	return __tracing_open_pipe(inode, filp, &global_trace);
> +}
> +
>  static int tracing_release_pipe(struct inode *inode, struct file *file)
>  {
>  	struct trace_iterator *iter = file->private_data;
> @@ -4008,6 +4014,122 @@ static int tracing_clock_open(struct inode *inode, struct file *file)
>  	return single_open(file, tracing_clock_show, NULL);
>  }
>  
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +static int tracing_open_snapshot_pipe(struct inode *inode, struct file *filp)
> +{
> +	return __tracing_open_pipe(inode, filp, &max_tr);
> +}
> +
> +static ssize_t
> +tracing_write_snapshot_pipe(struct file *filp, const char __user *ubuf,
> +		       size_t cnt, loff_t *ppos)
> +{
> +	unsigned long val = 0;
> +	int ret;
> +
> +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&trace_types_lock);
> +
> +	/* If current tracer's use_max_tr == 0, we prevent taking a snapshot */

Here we should just allocate it first.

> +	if (!current_trace->use_max_tr) {

I also have issues with the use of 'use_max_tr' here, but I'll explain
that below.

> +		ret = -EBUSY;
> +		goto out;
> +	}
> +	if (val) {
> +		unsigned long flags;
> +		local_irq_save(flags);

Interrupts will never be disabled here. Just use
'local_irq_disable/enable()', and remove flags.

> +		update_max_tr(&global_trace, current, raw_smp_processor_id());

Also, get rid of the 'raw_' that's for critical paths that can be broken
by the debug version of the normal user (like in function tracing and
callbacks from disabling interrupts).


> +		local_irq_restore(flags);
> +	}
> +out:
> +	mutex_unlock(&trace_types_lock);
> +
> +	if (!ret) {
> +		*ppos += cnt;
> +		ret = cnt;
> +	}
> +
> +	return ret;
> +}
> +
> +static ssize_t
> +tracing_snapshot_ctrl_read(struct file *filp, char __user *ubuf,
> +			   size_t cnt, loff_t *ppos)
> +{
> +	char buf[64];
> +	int r;
> +
> +	r = sprintf(buf, "%d\n", current_trace->use_max_tr);
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> +}
> +
> +static ssize_t
> +tracing_snapshot_ctrl_write(struct file *filp, const char __user *ubuf,
> +			    size_t cnt, loff_t *ppos)
> +{
> +	unsigned long val;
> +	int ret;
> +
> +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	val = !!val;
> +
> +	mutex_lock(&trace_types_lock);
> +	tracing_stop();
> +	arch_spin_lock(&ftrace_max_lock);
> +
> +	/* When always_use_max_tr == 1, we can't toggle use_max_tr. */
> +	if (current_trace->always_use_max_tr) {

I'll state my issue here. Don't rename use_max_tr to always_use_max_tr,
keep it as is and its use as is. Your other value should be
"allocated_snapshot", which can be set even for the use_max_tr user.


> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	if (!(current_trace->use_max_tr ^ val))
> +		goto out;
> +
> +	if (val) {
> +		int cpu;
> +		for_each_tracing_cpu(cpu) {
> +			ret = ring_buffer_resize(max_tr.buffer,
> +						global_trace.data[cpu]->entries,
> +						cpu);
> +			if (ret < 0)
> +				break;
> +			max_tr.data[cpu]->entries =
> +				global_trace.data[cpu]->entries;
> +		}
> +		if (ret < 0) {
> +			ring_buffer_resize(max_tr.buffer, 1,
> +					   RING_BUFFER_ALL_CPUS);
> +			set_buffer_entries(&max_tr, 1);
> +			ret = -ENOMEM;
> +			goto out;
> +		}

The above code is basically duplicated by the
__tracing_resize_ring_buffer(). As this code is not that trivial, lets
make use of a helper function and keep the bugs in one location. Have
both this function and the resize function use the same code.

In fact, the __tracing_resize_ring_buffer() could be modified to do all
the work. It will either shrink or expand as necessary. This isn't a
critical section so calling ring_buffer_resize() even when there's
nothing to do should not be an issue.

In fact, I think there's a small bug in the code that you just
duplicated. Not your bug, but you copied it.


> +		current_trace->use_max_tr = 1;
> +	} else {
> +		/* shrink buffer for saving memory */
> +		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
> +		set_buffer_entries(&max_tr, 1);
> +		current_trace->use_max_tr = 0;
> +	}
> +out:
> +	arch_spin_unlock(&ftrace_max_lock);
> +	tracing_start();
> +	mutex_unlock(&trace_types_lock);
> +
> +	if (!ret) {
> +		*ppos += cnt;
> +		ret = cnt;
> +	}
> +	return ret;
> +}
> +#endif /* CONFIG_TRACER_MAX_TRACE */
> +
>  static const struct file_operations tracing_max_lat_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_max_lat_read,
> @@ -4071,6 +4193,25 @@ static const struct file_operations trace_clock_fops = {
>  	.write		= tracing_clock_write,
>  };
>  
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +static const struct file_operations tracing_snapshot_pipe_fops = {
> +	.open           = tracing_open_snapshot_pipe,
> +	.poll           = tracing_poll_pipe,
> +	.read           = tracing_read_pipe,
> +	.write          = tracing_write_snapshot_pipe,
> +	.splice_read    = tracing_splice_read_pipe,
> +	.release        = tracing_release_pipe,
> +	.llseek         = no_llseek,
> +};
> +
> +static const struct file_operations tracing_snapshot_ctrl_fops = {
> +	.open           = tracing_open_generic,
> +	.read           = tracing_snapshot_ctrl_read,
> +	.write          = tracing_snapshot_ctrl_write,
> +	.llseek         = generic_file_llseek,
> +};
> +#endif /* CONFIG_TRACER_MAX_TRACE */
> +
>  struct ftrace_buffer_info {
>  	struct trace_array	*tr;
>  	void			*spare;
> @@ -4819,6 +4960,13 @@ static __init int tracer_init_debugfs(void)
>  #ifdef CONFIG_TRACER_MAX_TRACE
>  	trace_create_file("tracing_max_latency", 0644, d_tracer,
>  			&tracing_max_latency, &tracing_max_lat_fops);
> +
> +	trace_create_file("snapshot_pipe", 0644, d_tracer,
> +			  (void *) TRACE_PIPE_ALL_CPU,
> +			  &tracing_snapshot_pipe_fops);
> +
> +	trace_create_file("snapshot_enabled", 0644, d_tracer,
> +			  NULL, &tracing_snapshot_ctrl_fops);
>  #endif
>  
>  	trace_create_file("tracing_thresh", 0644, d_tracer,
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 5aec220..602657a 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -254,6 +254,8 @@ struct tracer_flags {
>   * @print_line: callback that prints a trace
>   * @set_flag: signals one of your private flags changed (trace_options file)
>   * @flags: your private flags
> + * @use_max_tr: show whether the snapshot feature is available on this tracer
> + * @always_use_max_tr: show that max_tr is always used on this tracer
>   */
>  struct tracer {
>  	const char		*name;
> @@ -286,7 +288,13 @@ struct tracer {
>  	struct tracer		*next;
>  	struct tracer_flags	*flags;
>  	int			print_max;
> +	/* Dynamically toggled via "snapshot_enabled" debugfs file */
>  	int			use_max_tr;
> +	/*
> +	 * If this value is 1, this tracer always uses max_tr and "use_max_tr"
> +	 * can't be toggled.
> +	 */
> +	int			always_use_max_tr;

I already said how I dislike this. Leave use_max_tr alone, but add a
allocated_snapshot. Also, I hate the wasting of 4 bytes just to act like
a flag. We should probably make print_max, use_max_tr and
always_use_max_tr into 'bool's.

The print_max change should be a separate patch.

>  };
>  
> 
> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index 99d20e9..37cdb75 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -614,6 +614,7 @@ static struct tracer irqsoff_tracer __read_mostly =
>  	.open           = irqsoff_trace_open,
>  	.close          = irqsoff_trace_close,
>  	.use_max_tr	= 1,
> +	.always_use_max_tr	= 1,

Remove all these. Have the 'allocated_snapshot' get set when the tracer
is added, not here.

But on the whole, I like the idea of a snapshot (and this has actually
been on my todo list for some time, thanks for doing it for me ;-)

-- Steve


>  };
>  # define register_irqsoff(trace) register_tracer(&trace)
>  #else
> @@ -647,6 +648,7 @@ static struct tracer preemptoff_tracer __read_mostly =
>  	.open		= irqsoff_trace_open,
>  	.close		= irqsoff_trace_close,
>  	.use_max_tr	= 1,
> +	.always_use_max_tr	= 1,
>  };
>  # define register_preemptoff(trace) register_tracer(&trace)
>  #else
> @@ -682,6 +684,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
>  	.open		= irqsoff_trace_open,
>  	.close		= irqsoff_trace_close,
>  	.use_max_tr	= 1,
> +	.always_use_max_tr	= 1,
>  };
>  
>  # define register_preemptirqsoff(trace) register_tracer(&trace)
> diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
> index ff791ea..b6e91a0 100644
> --- a/kernel/trace/trace_sched_wakeup.c
> +++ b/kernel/trace/trace_sched_wakeup.c
> @@ -599,6 +599,7 @@ static struct tracer wakeup_tracer __read_mostly =
>  	.open		= wakeup_trace_open,
>  	.close		= wakeup_trace_close,
>  	.use_max_tr	= 1,
> +	.always_use_max_tr	= 1,
>  };
>  
>  static struct tracer wakeup_rt_tracer __read_mostly =
> @@ -620,6 +621,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
>  	.open		= wakeup_trace_open,
>  	.close		= wakeup_trace_close,
>  	.use_max_tr	= 1,
> +	.always_use_max_tr	= 1,
>  };
>  
>  __init static int init_wakeup_tracer(void)


