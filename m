Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0LNAkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:40:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:32651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab0LNAkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:40:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ew9tRiPBhB9cIFkUWe2ZRnzhQUy1qpKslCQWK7WzzrjG0DxsyIBQbzLTcKJkC1Jwz+
         zRCa2jhtWargK2lsYrfg==
MIME-Version: 1.0
In-Reply-To: <1291844807-15481-1-git-send-email-dhsharp@google.com>
References: <AANLkTim7xZvUJSxW0KzbZX1wxf19gZhvh1GLnU63zdgW@mail.gmail.com> <1291844807-15481-1-git-send-email-dhsharp@google.com>
From: David Sharp <dhsharp@google.com>
Date: Mon, 13 Dec 2010 16:39:49 -0800
Message-ID: <AANLkTi=BbmNqXmM8OJUsj4XKhTm7DG13yGR2JtBQfQwb@mail.gmail.com>
Subject: Re: [PATCH] tracing: Add an 'overwrite' trace_option.
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, jiayingz@google.com,
        David Sharp <dhsharp@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve, any feedback on this patch?

On Wed, Dec 8, 2010 at 1:46 PM, David Sharp <dhsharp@google.com> wrote:
> Add an "overwrite" trace_option for ftrace to control whether the buffer should
> be overwritten on overflow or not. The default remains to overwrite old events
> when the buffer is full. This patch adds the option to instead discard newest
> events when the buffer is full. This is useful to get a snapshot of traces just
> after enabling traces. Dropping the current event is also a simpler code path.
> ---
>  Documentation/trace/ftrace.txt |    5 +++++
>  include/linux/ring_buffer.h    |    2 ++
>  kernel/trace/ring_buffer.c     |   11 +++++++++++
>  kernel/trace/trace.c           |   17 +++++++++++------
>  kernel/trace/trace.h           |    1 +
>  5 files changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index 557c1ed..2842ea7 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -491,6 +491,11 @@ x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
>                    latencies, as described in "Latency
>                    trace format".
>
> +  overwrite - This controls what happens when the trace buffer is
> +              full. If "1" (default), the oldest events are
> +              discarded and overwritten. If "0", then the newest
> +              events are discarded.
> +
>  sched_switch
>  ------------
>
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index 8d3a248..ab38ac8 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -100,6 +100,8 @@ void ring_buffer_free(struct ring_buffer *buffer);
>
>  int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
>
> +void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val);
> +
>  struct ring_buffer_event *ring_buffer_lock_reserve(struct ring_buffer *buffer,
>                                                   unsigned long length);
>  int ring_buffer_unlock_commit(struct ring_buffer *buffer,
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 9ed509a..3207147 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1429,6 +1429,17 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_resize);
>
> +void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val)
> +{
> +       mutex_lock(&buffer->mutex);
> +       if (val)
> +               buffer->flags |= RB_FL_OVERWRITE;
> +       else
> +               buffer->flags &= ~RB_FL_OVERWRITE;
> +       mutex_unlock(&buffer->mutex);
> +}
> +EXPORT_SYMBOL_GPL(ring_buffer_change_overwrite);
> +
>  static inline void *
>  __rb_data_page_index(struct buffer_data_page *bpage, unsigned index)
>  {
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index c380612..6f7494c 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -41,8 +41,6 @@
>  #include "trace.h"
>  #include "trace_output.h"
>
> -#define TRACE_BUFFER_FLAGS     (RB_FL_OVERWRITE)
> -
>  /*
>  * On boot up, the ring buffer is set to the minimum size, so that
>  * we do not waste memory on systems that are not using tracing.
> @@ -340,7 +338,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
>  /* trace_flags holds trace_options default values */
>  unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
>        TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
> -       TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD;
> +       TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE;
>
>  static int trace_stop_count;
>  static DEFINE_SPINLOCK(tracing_start_lock);
> @@ -425,6 +423,7 @@ static const char *trace_options[] = {
>        "sleep-time",
>        "graph-time",
>        "record-cmd",
> +       "overwrite",
>        NULL
>  };
>
> @@ -2523,6 +2522,9 @@ static void set_tracer_flags(unsigned int mask, int enabled)
>
>        if (mask == TRACE_ITER_RECORD_CMD)
>                trace_event_enable_cmd_record(enabled);
> +
> +       if (mask == TRACE_ITER_OVERWRITE)
> +               ring_buffer_change_overwrite(global_trace.buffer, enabled);
>  }
>
>  static ssize_t
> @@ -4545,9 +4547,11 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
>  __init static int tracer_alloc_buffers(void)
>  {
>        int ring_buf_size;
> +       enum ring_buffer_flags rb_flags;
>        int i;
>        int ret = -ENOMEM;
>
> +
>        if (!alloc_cpumask_var(&tracing_buffer_mask, GFP_KERNEL))
>                goto out;
>
> @@ -4560,12 +4564,13 @@ __init static int tracer_alloc_buffers(void)
>        else
>                ring_buf_size = 1;
>
> +       rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
> +
>        cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
>        cpumask_copy(tracing_cpumask, cpu_all_mask);
>
>        /* TODO: make the number of buffers hot pluggable with CPUS */
> -       global_trace.buffer = ring_buffer_alloc(ring_buf_size,
> -                                                  TRACE_BUFFER_FLAGS);
> +       global_trace.buffer = ring_buffer_alloc(ring_buf_size, rb_flags);
>        if (!global_trace.buffer) {
>                printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
>                WARN_ON(1);
> @@ -4575,7 +4580,7 @@ __init static int tracer_alloc_buffers(void)
>
>
>  #ifdef CONFIG_TRACER_MAX_TRACE
> -       max_tr.buffer = ring_buffer_alloc(1, TRACE_BUFFER_FLAGS);
> +       max_tr.buffer = ring_buffer_alloc(1, rb_flags);
>        if (!max_tr.buffer) {
>                printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
>                WARN_ON(1);
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 9021f8c..9cd025a 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -606,6 +606,7 @@ enum trace_iterator_flags {
>        TRACE_ITER_SLEEP_TIME           = 0x40000,
>        TRACE_ITER_GRAPH_TIME           = 0x80000,
>        TRACE_ITER_RECORD_CMD           = 0x100000,
> +       TRACE_ITER_OVERWRITE            = 0x200000,
>  };
>
>  /*
> --
> 1.7.3.1
>
>
