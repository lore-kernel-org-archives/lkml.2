Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2K3FrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:47:09 -0500
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:60619 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2K3FrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:47:07 -0500
X-AuditID: b753bd60-94a4dba000002f78-7a-50b847d23500
X-AuditID: b753bd60-94a4dba000002f78-7a-50b847d23500
Message-ID: <50B84822.6010409@hitachi.com>
Date: Fri, 30 Nov 2012 14:46:10 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v2 -tip 3/4] tracing: make a snapshot feature available
 from userspace
References: <20121017025608.2627.87497.stgit@falsita>	 <20121017025619.2627.96794.stgit@falsita> <1353030384.9391.19.camel@gandalf.local.home>
In-Reply-To: <1353030384.9391.19.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven,

Thank you for your review.

(2012/11/16 10:46), Steven Rostedt wrote:
[snip]
 > I was thinking about this some more, and I don't like the
 > snapshot_allocate part. Also, I think the snapshot should not be
 > allocated by default, and not used until the user explicitly asks for
 > it.
 >
 > Have this:
 >
 > ---
 >  # cat snapshot
 > Snapshot is not allocated. To allocate it write the ASCII "1" into
 > this file:
 >
 >   echo 1 > snapshot
 >
 > This will allocate the buffer for you. To free the snapshot echo "0"
 > into this file.
 >
 >   echo "0" > snapshot
 >
 > Anything else will reset the snapshot if it is allocated, or return
 > EINVAL if it is not allocated.
 > ---
 >

Your idea about "snapshot" is like following table, isn't it?

  status\input |     0      |     1      |    else    |
--------------+------------+------------+------------+
not allocated |   EINVAL   | alloc+swap |   EINVAL   |
--------------+------------+------------+------------+
   allocated   |    free    | clear+swap |   clear    |
--------------+------------+------------+------------+

I think it is almost OK, but there is a problem.
When we echo "1" to the allocated snapshot, the clear operation adds
some delay because the time cost of tracing_reset_online_cpus() is in
proportion to the number of CPUs.
(It takes 72ms in my 8 CPU environment.)

So, when the snapshot is already cleared by echoing "else" values, we
can avoid the delay on echoing "1" by keeping "cleared" status
internally. For example, we can add the "cleared" flag to struct tracer.
What do you think about it?

 >
 > Also we can add a "trace_snapshot" to the kernel parameters to have it
 > allocated on boot. But I can add that if you update these patches.
 >

OK, I'll update my patches.

[snip]
 >> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
 >> index 4cea4f4..73d56d5 100644
 >> --- a/kernel/trace/Kconfig
 >> +++ b/kernel/trace/Kconfig
 >> @@ -102,6 +102,17 @@ config RING_BUFFER_ALLOW_SWAP
 >>       Allow the use of ring_buffer_swap_cpu.
 >>       Adds a very slight overhead to tracing when enabled.
 >>
 >
 > Move this config down below FTRACE_SYSCALLS and give it a prompt. As
 > well as do not make it default y.
 >

I'll modify it.

 >
 >> +config TRACER_SNAPSHOT
 >> +    bool
 >
 >     bool "Create a snapshot trace buffer"
 >

I'll fix it.


 >
 >> +    default y
 >> +    select TRACER_MAX_TRACE
 >> +    help
 >> +      Allow tracing users to take snapshot of the current buffer 
using the
 >> +      ftrace interface, e.g.:
 >> +
 >> +          echo 1 > /sys/kernel/debug/tracing/snapshot
 >> +          cat snapshot
 >> +
[snip]
 >>  static struct trace_iterator *
 >> -__tracing_open(struct inode *inode, struct file *file)
 >> +__tracing_open(struct inode *inode, struct file *file, int snapshot)
 >
 >     bool snapshot
 >

I'll fix it.


 >>  {
 >>      long cpu_file = (long) inode->i_private;
 >>      struct trace_iterator *iter;
 >> @@ -2408,10 +2410,11 @@ __tracing_open(struct inode *inode, struct 
file *file)
 >>      if (!zalloc_cpumask_var(&iter->started, GFP_KERNEL))
 >>          goto fail;
 >>
 >> -    if (current_trace && current_trace->print_max)
 >> +    if ((current_trace && current_trace->print_max) || snapshot)
 >>          iter->tr = &max_tr;
 >>      else
 >>          iter->tr = &global_trace;
 >> +    iter->snapshot = !!snapshot;
 >
 > Get rid of the !!
 >

I'll fix it.

[snip]
 >> @@ -2517,7 +2522,7 @@ static int tracing_open(struct inode *inode, 
struct file *file)
 >>      }
 >>
 >>      if (file->f_mode & FMODE_READ) {
 >> -        iter = __tracing_open(inode, file);
 >> +        iter = __tracing_open(inode, file, 0);
 >
 >     , false)
 >

I'll fix it.

 >>          if (IS_ERR(iter))
 >>              ret = PTR_ERR(iter);
 >>          else if (trace_flags & TRACE_ITER_LATENCY_FMT)
 >> @@ -3186,7 +3191,8 @@ static int tracing_set_tracer(const char *buf)
 >>      trace_branch_disable();
 >>      if (current_trace && current_trace->reset)
 >>          current_trace->reset(tr);
 >> -    if (current_trace && current_trace->use_max_tr) {
 >> +    if (current_trace && current_trace->allocated_snapshot) {
 >> +        tracing_reset_online_cpus(&max_tr);
 >
 > max_tr->buffer could be NULL.
 >
 > Either test here, or better yet, put the test into
 > tracing_reset_online_cpus().
 >
 >     if (!buffer)
 >         return;
 >

I see. I'll add the test to tracing_reset_online_cpus(). Should I make a
separated patch?

[snip]
 >> +static ssize_t tracing_snapshot_read(struct file *filp, char __user 
*ubuf,
 >> +                     size_t cnt, loff_t *ppos)
 >> +{
 >> +    ssize_t ret = 0;
 >> +
 >> +    mutex_lock(&trace_types_lock);
 >> +    if (current_trace && current_trace->use_max_tr)
 >> +        ret = -EBUSY;
 >> +    mutex_unlock(&trace_types_lock);
 >
 > I don't like this, as it is racy. The current tracer could change after
 > the unlock, and your back to the problem.
 >

You're right...
This is racy.

 > Now what we may be able to do, but it would take a little checking for
 > lock ordering with trace_access_lock() and trace_event_read_lock(), but
 > we could add the mutex to trace_types_lock to both s_start() and
 > s_stop() and do the check in s_start() if iter->snapshot is true.
 >

If I catch your meaning, do s_start() and s_stop() become like following
code?
(Now, s_start() is used from two files - "trace" and "snapshot", so we
should change static "old_tracer" to per open-file.)

static void *s_start(struct seq_file *m, loff_t *pos)
{
      struct trace_iterator *iter = m->private;
-    static struct tracer *old_tracer;
...
      /* copy the tracer to avoid using a global lock all around */
      mutex_lock(&trace_types_lock);
-    if (unlikely(old_tracer != current_trace && current_trace)) {
-        old_tracer = current_trace;
+    if (unlikely(iter->old_tracer != current_trace && current_trace)) {
+        iter->old_tracer = current_trace;
          *iter->trace = *current_trace;
      }
      mutex_unlock(&trace_types_lock);

+    if (iter->snapshot && iter->trace->use_max_tr)
+        return ERR_PTR(-EBUSY);
+
...
}

static void s_stop(struct seq_file *m, void *p)
{
      struct trace_iterator *iter = m->private;

+    if (iter->snapshot && iter->trace->use_max_tr)
+        return;
...
}

 > This means we can nuke the tracing_snapshot_read() and just use
 > seq_read() directly.
 >

Yes, I see.

Thanks,
Hiraku Toyooka


 >> +    if (ret < 0)
 >> +        return ret;
 >> +
 >> +    ret = seq_read(filp, ubuf, cnt, ppos);
 >> +
 >> +    return ret;
 >> +}
 >> +
 >> +static ssize_t
 >> +tracing_snapshot_write(struct file *filp, const char __user *ubuf,
size_t cnt,
 >> +               loff_t *ppos)
 >> +{
 >> +    unsigned long val = 0;
 >> +    int ret;
 >> +
 >> +    ret = tracing_update_buffers();
 >> +    if (ret < 0)
 >> +        return ret;
 >> +
 >> +    ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
 >> +    if (ret)
 >> +        return ret;
 >> +
 >> +    mutex_lock(&trace_types_lock);
 >> +
 >> +    if (current_trace->use_max_tr) {
 >> +        ret = -EBUSY;
 >> +        goto out;
 >> +    }
 >
 > Again, I would check the value of 'val' and if it is '1' then allocate
 > the buffers, '0' free them, and anything else just clear them or return
 > EINVAL if the buffers are not allocated.
 >
 > If it is '1' and the buffers are already allocated, then clear them too.
 >
 > Then we can just remove the 'snapshot_allocate' file.
 >
 > Thanks!
 >
 > -- Steve
 >
 >> +
 >> +    if (!current_trace->allocated_snapshot) {
 >> +        /* allocate spare buffer for snapshot */
 >> +        ret = resize_buffer_duplicate_size(&max_tr, &global_trace,
 >> +                           RING_BUFFER_ALL_CPUS);
 >> +        if (ret < 0)
 >> +            goto out;
 >> +        current_trace->allocated_snapshot = true;
 >> +    }
 >> +
 >> +    if (val) {
 >> +        local_irq_disable();
 >> +        update_max_tr(&global_trace, current, smp_processor_id());
 >> +        local_irq_enable();
 >> +    } else
 >> +        tracing_reset_online_cpus(&max_tr);
 >> +
 >> +    *ppos += cnt;
 >> +    ret = cnt;
 >> +out:
 >> +    mutex_unlock(&trace_types_lock);
 >> +    return ret;
 >> +}
 >> +
 >> +static ssize_t
 >> +tracing_snapshot_allocate_read(struct file *filp, char __user *ubuf,
 >> +                   size_t cnt, loff_t *ppos)
 >> +{
 >> +    char buf[64];
 >> +    int r;
 >> +
 >> +    r = sprintf(buf, "%d\n", current_trace->allocated_snapshot);
 >> +    return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 >> +}
 >> +
 >> +static ssize_t
 >> +tracing_snapshot_allocate_write(struct file *filp, const char
__user *ubuf,
 >> +                size_t cnt, loff_t *ppos)
 >> +{
 >> +    unsigned long val;
 >> +    int ret;
 >> +
 >> +    ret = tracing_update_buffers();
 >> +    if (ret < 0)
 >> +        return ret;
 >> +
 >> +    ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
 >> +    if (ret)
 >> +        return ret;
 >> +
 >> +    mutex_lock(&trace_types_lock);
 >> +
 >> +    if (current_trace->use_max_tr) {
 >> +        ret = -EBUSY;
 >> +        goto out;
 >> +    }
 >> +
 >> +    if (current_trace->allocated_snapshot == !val) {
 >> +        if (val) {
 >> +            /* allocate spare buffer for snapshot */
 >> +            ret = resize_buffer_duplicate_size(&max_tr,
 >> +                    &global_trace, RING_BUFFER_ALL_CPUS);
 >> +            if (ret < 0)
 >> +                goto out;
 >> +        } else {
 >> +            tracing_reset_online_cpus(&max_tr);
 >> +            ring_buffer_resize(max_tr.buffer, 1,
 >> +                       RING_BUFFER_ALL_CPUS);
 >> +            set_buffer_entries(&max_tr, 1);
 >> +        }
 >> +        current_trace->allocated_snapshot = !!val;
 >> +    }
 >> +
 >> +    *ppos += cnt;
 >> +    ret = cnt;
 >> +out:
 >> +    mutex_unlock(&trace_types_lock);
 >> +    return ret;
 >> +}
 >> +#endif /* CONFIG_TRACER_SNAPSHOT */
 >> +
 >>  static const struct file_operations tracing_max_lat_fops = {
 >>      .open        = tracing_open_generic,
 >>      .read        = tracing_max_lat_read,
 >> @@ -4092,6 +4233,23 @@ static const struct file_operations
trace_clock_fops = {
 >>      .write        = tracing_clock_write,
 >>  };
 >>
 >> +#ifdef CONFIG_TRACER_SNAPSHOT
 >> +static const struct file_operations snapshot_fops = {
 >> +    .open        = tracing_snapshot_open,
 >> +    .read        = tracing_snapshot_read,
 >> +    .write        = tracing_snapshot_write,
 >> +    .llseek        = tracing_seek,
 >> +    .release    = tracing_release,
 >> +};
 >> +
 >> +static const struct file_operations snapshot_allocate_fops = {
 >> +    .open           = tracing_open_generic,
 >> +    .read           = tracing_snapshot_allocate_read,
 >> +    .write          = tracing_snapshot_allocate_write,
 >> +    .llseek         = generic_file_llseek,
 >> +};
 >> +#endif /* CONFIG_TRACER_SNAPSHOT */
 >> +
 >>  struct ftrace_buffer_info {
 >>      struct trace_array    *tr;
 >>      void            *spare;
 >> @@ -4878,6 +5036,14 @@ static __init int tracer_init_debugfs(void)
 >>              &ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 >>  #endif
 >>
 >> +#ifdef CONFIG_TRACER_SNAPSHOT
 >> +    trace_create_file("snapshot", 0644, d_tracer,
 >> +              (void *) TRACE_PIPE_ALL_CPU, &snapshot_fops);
 >> +
 >> +    trace_create_file("snapshot_allocate", 0644, d_tracer,
 >> +              NULL, &snapshot_allocate_fops);
 >> +#endif
 >> +
 >>      create_trace_options_dir();
 >>
 >>      for_each_tracing_cpu(cpu)
 >> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
 >> index 0eb6a1a..66a8631 100644
 >> --- a/kernel/trace/trace.h
 >> +++ b/kernel/trace/trace.h
 >> @@ -287,6 +287,7 @@ struct tracer {
 >>      struct tracer_flags    *flags;
 >>      bool            print_max;
 >>      bool            use_max_tr;
 >> +    bool            allocated_snapshot;
 >>  };
 >>
 >>
 >
 >


