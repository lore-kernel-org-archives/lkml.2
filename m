Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab2KPBq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:46:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31902 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2KPBq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:46:27 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=O7yW5i6_SjkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=apWNB6VHehcA:10 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=agFkoVGX3jDg1JNDeAQA:9 a=PUjeQqilurYA:10 a=Q60pFu-1FX0A:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353030384.9391.19.camel@gandalf.local.home>
Subject: Re: [PATCH v2 -tip 3/4] tracing: make a snapshot feature available
 from userspace
From: Steven Rostedt <rostedt@goodmis.org>
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Thu, 15 Nov 2012 20:46:24 -0500
In-Reply-To: <20121017025619.2627.96794.stgit@falsita>
References: <20121017025608.2627.87497.stgit@falsita>
	 <20121017025619.2627.96794.stgit@falsita>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 11:56 +0900, Hiraku Toyooka wrote:
> Ftrace has a snapshot feature available from kernel space and
> latency tracers (e.g. irqsoff) are using it. This patch enables
> user applictions to take a snapshot via debugfs.
> 
> Add following two debugfs files in "tracing" directory.
> 
>   snapshot:
>     This is used to take a snapshot and to read the output of the
>     snapshot.
>      # echo 1 > snapshot
>      # cat snapshot
> 
>   snapshot_allocate:
>     Echoing 1 to the "snapshot" allocates the max_tr buffer if
>     it is not allocated. So taking a snapshot may delay or fail
>     beacuse of memory allocation. To avoid that, this file
>     provides a mean to pre-allocate (or free) the max_tr buffer.
>      # echo 1 > snapshot_allocate
>      [...]
>      # echo 1 > snapshot

I was thinking about this some more, and I don't like the
snapshot_allocate part. Also, I think the snapshot should not be
allocated by default, and not used until the user explicitly asks for
it.

Have this:

---
 # cat snapshot
Snapshot is not allocated. To allocate it write the ASCII "1" into
this file:

  echo 1 > snapshot

This will allocate the buffer for you. To free the snapshot echo "0"
into this file.

  echo "0" > snapshot

Anything else will reset the snapshot if it is allocated, or return
EINVAL if it is not allocated.
---


Also we can add a "trace_snapshot" to the kernel parameters to have it
allocated on boot. But I can add that if you update these patches.



> 
> Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  include/linux/ftrace_event.h |    3 +
>  kernel/trace/Kconfig         |   11 ++
>  kernel/trace/trace.c         |  190 +++++++++++++++++++++++++++++++++++++++---
>  kernel/trace/trace.h         |    1 
>  4 files changed, 193 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 642928c..8c32c6e 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -84,6 +84,9 @@ struct trace_iterator {
>  	long			idx;
>  
>  	cpumask_var_t		started;
> +
> +	/* it's true when current open file is snapshot */
> +	bool			snapshot;
>  };
>  
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 4cea4f4..73d56d5 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -102,6 +102,17 @@ config RING_BUFFER_ALLOW_SWAP
>  	 Allow the use of ring_buffer_swap_cpu.
>  	 Adds a very slight overhead to tracing when enabled.
>  

Move this config down below FTRACE_SYSCALLS and give it a prompt. As
well as do not make it default y.


> +config TRACER_SNAPSHOT
> +	bool

	bool "Create a snapshot trace buffer"


> +	default y
> +	select TRACER_MAX_TRACE
> +	help
> +	  Allow tracing users to take snapshot of the current buffer using the
> +	  ftrace interface, e.g.:
> +
> +	      echo 1 > /sys/kernel/debug/tracing/snapshot
> +	      cat snapshot
> +
>  # All tracer options should select GENERIC_TRACER. For those options that are
>  # enabled by all tracers (context switch and event tracer) they select TRACING.
>  # This allows those options to appear when no other tracer is selected. But the
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d71eee1..b0d097e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -699,7 +699,7 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  		return;
>  
>  	WARN_ON_ONCE(!irqs_disabled());
> -	if (!current_trace->use_max_tr) {
> +	if (!current_trace->allocated_snapshot) {
>  		WARN_ON_ONCE(1);
>  		return;
>  	}
> @@ -729,7 +729,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  		return;
>  
>  	WARN_ON_ONCE(!irqs_disabled());
> -	if (!current_trace->use_max_tr) {
> +	if (!current_trace->allocated_snapshot) {
>  		WARN_ON_ONCE(1);
>  		return;
>  	}
> @@ -1902,7 +1902,8 @@ static void *s_start(struct seq_file *m, loff_t *pos)
>  	}
>  	mutex_unlock(&trace_types_lock);
>  
> -	atomic_inc(&trace_record_cmdline_disabled);
> +	if (!iter->snapshot)
> +		atomic_inc(&trace_record_cmdline_disabled);
>  
>  	if (*pos != iter->pos) {
>  		iter->ent = NULL;
> @@ -1941,7 +1942,8 @@ static void s_stop(struct seq_file *m, void *p)
>  {
>  	struct trace_iterator *iter = m->private;
>  
> -	atomic_dec(&trace_record_cmdline_disabled);
> +	if (!iter->snapshot)
> +		atomic_dec(&trace_record_cmdline_disabled);
>  	trace_access_unlock(iter->cpu_file);
>  	trace_event_read_unlock();
>  }
> @@ -2375,7 +2377,7 @@ static const struct seq_operations tracer_seq_ops = {
>  };
>  
>  static struct trace_iterator *
> -__tracing_open(struct inode *inode, struct file *file)
> +__tracing_open(struct inode *inode, struct file *file, int snapshot)

	bool snapshot

>  {
>  	long cpu_file = (long) inode->i_private;
>  	struct trace_iterator *iter;
> @@ -2408,10 +2410,11 @@ __tracing_open(struct inode *inode, struct file *file)
>  	if (!zalloc_cpumask_var(&iter->started, GFP_KERNEL))
>  		goto fail;
>  
> -	if (current_trace && current_trace->print_max)
> +	if ((current_trace && current_trace->print_max) || snapshot)
>  		iter->tr = &max_tr;
>  	else
>  		iter->tr = &global_trace;
> +	iter->snapshot = !!snapshot;

Get rid of the !!

>  	iter->pos = -1;
>  	mutex_init(&iter->mutex);
>  	iter->cpu_file = cpu_file;
> @@ -2424,8 +2427,9 @@ __tracing_open(struct inode *inode, struct file *file)
>  	if (ring_buffer_overruns(iter->tr->buffer))
>  		iter->iter_flags |= TRACE_FILE_ANNOTATE;
>  
> -	/* stop the trace while dumping */
> -	tracing_stop();
> +	/* stop the trace while dumping if we are not opening "snapshot" */
> +	if (!iter->snapshot)
> +		tracing_stop();
>  
>  	if (iter->cpu_file == TRACE_PIPE_ALL_CPU) {
>  		for_each_tracing_cpu(cpu) {
> @@ -2488,8 +2492,9 @@ static int tracing_release(struct inode *inode, struct file *file)
>  	if (iter->trace && iter->trace->close)
>  		iter->trace->close(iter);
>  
> -	/* reenable tracing if it was previously enabled */
> -	tracing_start();
> +	if (!iter->snapshot)
> +		/* reenable tracing if it was previously enabled */
> +		tracing_start();
>  	mutex_unlock(&trace_types_lock);
>  
>  	mutex_destroy(&iter->mutex);
> @@ -2517,7 +2522,7 @@ static int tracing_open(struct inode *inode, struct file *file)
>  	}
>  
>  	if (file->f_mode & FMODE_READ) {
> -		iter = __tracing_open(inode, file);
> +		iter = __tracing_open(inode, file, 0);

	, false)

>  		if (IS_ERR(iter))
>  			ret = PTR_ERR(iter);
>  		else if (trace_flags & TRACE_ITER_LATENCY_FMT)
> @@ -3186,7 +3191,8 @@ static int tracing_set_tracer(const char *buf)
>  	trace_branch_disable();
>  	if (current_trace && current_trace->reset)
>  		current_trace->reset(tr);
> -	if (current_trace && current_trace->use_max_tr) {
> +	if (current_trace && current_trace->allocated_snapshot) {
> +		tracing_reset_online_cpus(&max_tr);

max_tr->buffer could be NULL.

Either test here, or better yet, put the test into
tracing_reset_online_cpus().

	if (!buffer)
		return;

>  		/*
>  		 * We don't free the ring buffer. instead, resize it because
>  		 * The max_tr ring buffer has some state (e.g. ring->clock) and
> @@ -3194,6 +3200,7 @@ static int tracing_set_tracer(const char *buf)
>  		 */
>  		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
>  		set_buffer_entries(&max_tr, 1);
> +		current_trace->allocated_snapshot = false;
>  	}
>  	destroy_trace_option_files(topts);
>  
> @@ -3206,6 +3213,7 @@ static int tracing_set_tracer(const char *buf)
>  						   RING_BUFFER_ALL_CPUS);
>  		if (ret < 0)
>  			goto out;
> +		t->allocated_snapshot = true;
>  	}
>  
>  	if (t->init) {
> @@ -4029,6 +4037,139 @@ static int tracing_clock_open(struct inode *inode, struct file *file)
>  	return single_open(file, tracing_clock_show, NULL);
>  }
>  
> +#ifdef CONFIG_TRACER_SNAPSHOT
> +static int tracing_snapshot_open(struct inode *inode, struct file *file)
> +{
> +	struct trace_iterator *iter;
> +	int ret = 0;
> +
> +	if (file->f_mode & FMODE_READ) {
> +		iter = __tracing_open(inode, file, 1);
> +		if (IS_ERR(iter))
> +			ret = PTR_ERR(iter);
> +	}
> +	return ret;
> +}
> +
> +static ssize_t tracing_snapshot_read(struct file *filp, char __user *ubuf,
> +				     size_t cnt, loff_t *ppos)
> +{
> +	ssize_t ret = 0;
> +
> +	mutex_lock(&trace_types_lock);
> +	if (current_trace && current_trace->use_max_tr)
> +		ret = -EBUSY;
> +	mutex_unlock(&trace_types_lock);

I don't like this, as it is racy. The current tracer could change after
the unlock, and your back to the problem.

Now what we may be able to do, but it would take a little checking for
lock ordering with trace_access_lock() and trace_event_read_lock(), but
we could add the mutex to trace_types_lock to both s_start() and
s_stop() and do the check in s_start() if iter->snapshot is true.

This means we can nuke the tracing_snapshot_read() and just use
seq_read() directly.

> +	if (ret < 0)
> +		return ret;
> +
> +	ret = seq_read(filp, ubuf, cnt, ppos);
> +
> +	return ret;
> +}
> +
> +static ssize_t
> +tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
> +		       loff_t *ppos)
> +{
> +	unsigned long val = 0;
> +	int ret;
> +
> +	ret = tracing_update_buffers();
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&trace_types_lock);
> +
> +	if (current_trace->use_max_tr) {
> +		ret = -EBUSY;
> +		goto out;
> +	}

Again, I would check the value of 'val' and if it is '1' then allocate
the buffers, '0' free them, and anything else just clear them or return
EINVAL if the buffers are not allocated.

If it is '1' and the buffers are already allocated, then clear them too.

Then we can just remove the 'snapshot_allocate' file.

Thanks!

-- Steve

> +
> +	if (!current_trace->allocated_snapshot) {
> +		/* allocate spare buffer for snapshot */
> +		ret = resize_buffer_duplicate_size(&max_tr, &global_trace,
> +						   RING_BUFFER_ALL_CPUS);
> +		if (ret < 0)
> +			goto out;
> +		current_trace->allocated_snapshot = true;
> +	}
> +
> +	if (val) {
> +		local_irq_disable();
> +		update_max_tr(&global_trace, current, smp_processor_id());
> +		local_irq_enable();
> +	} else
> +		tracing_reset_online_cpus(&max_tr);
> +
> +	*ppos += cnt;
> +	ret = cnt;
> +out:
> +	mutex_unlock(&trace_types_lock);
> +	return ret;
> +}
> +
> +static ssize_t
> +tracing_snapshot_allocate_read(struct file *filp, char __user *ubuf,
> +			       size_t cnt, loff_t *ppos)
> +{
> +	char buf[64];
> +	int r;
> +
> +	r = sprintf(buf, "%d\n", current_trace->allocated_snapshot);
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> +}
> +
> +static ssize_t
> +tracing_snapshot_allocate_write(struct file *filp, const char __user *ubuf,
> +				size_t cnt, loff_t *ppos)
> +{
> +	unsigned long val;
> +	int ret;
> +
> +	ret = tracing_update_buffers();
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&trace_types_lock);
> +
> +	if (current_trace->use_max_tr) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	if (current_trace->allocated_snapshot == !val) {
> +		if (val) {
> +			/* allocate spare buffer for snapshot */
> +			ret = resize_buffer_duplicate_size(&max_tr,
> +					&global_trace, RING_BUFFER_ALL_CPUS);
> +			if (ret < 0)
> +				goto out;
> +		} else {
> +			tracing_reset_online_cpus(&max_tr);
> +			ring_buffer_resize(max_tr.buffer, 1,
> +					   RING_BUFFER_ALL_CPUS);
> +			set_buffer_entries(&max_tr, 1);
> +		}
> +		current_trace->allocated_snapshot = !!val;
> +	}
> +
> +	*ppos += cnt;
> +	ret = cnt;
> +out:
> +	mutex_unlock(&trace_types_lock);
> +	return ret;
> +}
> +#endif /* CONFIG_TRACER_SNAPSHOT */
> +
>  static const struct file_operations tracing_max_lat_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_max_lat_read,
> @@ -4092,6 +4233,23 @@ static const struct file_operations trace_clock_fops = {
>  	.write		= tracing_clock_write,
>  };
>  
> +#ifdef CONFIG_TRACER_SNAPSHOT
> +static const struct file_operations snapshot_fops = {
> +	.open		= tracing_snapshot_open,
> +	.read		= tracing_snapshot_read,
> +	.write		= tracing_snapshot_write,
> +	.llseek		= tracing_seek,
> +	.release	= tracing_release,
> +};
> +
> +static const struct file_operations snapshot_allocate_fops = {
> +	.open           = tracing_open_generic,
> +	.read           = tracing_snapshot_allocate_read,
> +	.write          = tracing_snapshot_allocate_write,
> +	.llseek         = generic_file_llseek,
> +};
> +#endif /* CONFIG_TRACER_SNAPSHOT */
> +
>  struct ftrace_buffer_info {
>  	struct trace_array	*tr;
>  	void			*spare;
> @@ -4878,6 +5036,14 @@ static __init int tracer_init_debugfs(void)
>  			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
>  #endif
>  
> +#ifdef CONFIG_TRACER_SNAPSHOT
> +	trace_create_file("snapshot", 0644, d_tracer,
> +			  (void *) TRACE_PIPE_ALL_CPU, &snapshot_fops);
> +
> +	trace_create_file("snapshot_allocate", 0644, d_tracer,
> +			  NULL, &snapshot_allocate_fops);
> +#endif
> +
>  	create_trace_options_dir();
>  
>  	for_each_tracing_cpu(cpu)
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 0eb6a1a..66a8631 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -287,6 +287,7 @@ struct tracer {
>  	struct tracer_flags	*flags;
>  	bool			print_max;
>  	bool			use_max_tr;
> +	bool			allocated_snapshot;
>  };
>  
> 


