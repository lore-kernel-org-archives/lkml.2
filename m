Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0LHUQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:16:40 -0500
Received: from smtp-out.google.com ([74.125.121.35]:7451 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab0LHUQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:16:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LgEZKmIdPJBP0nb7xJFjHK7V/gkK7w7ZpUWuAitZAxTQG5DEOSaDguNTBPjNhiXKOE
         bDigaRSLk3PGT0vur3hg==
MIME-Version: 1.0
In-Reply-To: <1291427830.16223.16.camel@gandalf.stny.rr.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <1291421609-14665-2-git-send-email-dhsharp@google.com> <1291427830.16223.16.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Wed, 8 Dec 2010 12:15:51 -0800
Message-ID: <AANLkTim7xZvUJSxW0KzbZX1wxf19gZhvh1GLnU63zdgW@mail.gmail.com>
Subject: Re: [PATCH 01/15] tracing: Add a 'buffer_overwrite' debugfs file
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Jiaying Zhang <jiayingz@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 3, 2010 at 5:57 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
>> From: Jiaying Zhang <jiayingz@google.com>
>>
>> Add a "buffer_overwrite" debugfs file for ftrace to control whether the buffer
>
> Instead of adding a new file, make this another "trace_option".

To do this, I had to add a special case to set_tracer_flags() to call
ring_buffer_change_overwrite. It also means adding something not
iterator-related to trace_iterator_flags. Although, maybe it's just
the name of the enum and value prefix that should change.

I'll send the new patch to you separately today.

>
> Thanks,
>
> -- Steve
>
>
>> should be overwritten on overflow or not. The default remains to overwrite old
>> events when the buffer is full. This patch adds the option to instead discard
>> newest events when the buffer is full. This is useful to get a snapshot of
>> traces just after enabling traces. Dropping the current event is also a simpler
>> code path.
>>
>> Signed-off-by: David Sharp <dhsharp@google.com>
>> ---
>>  Documentation/trace/ftrace.txt |    6 ++++
>>  include/linux/ring_buffer.h    |    2 +
>>  kernel/trace/ring_buffer.c     |   11 +++++++
>>  kernel/trace/trace.c           |   59 +++++++++++++++++++++++++++++++++++++---
>>  4 files changed, 74 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
>> index 557c1ed..9237da3 100644
>> --- a/Documentation/trace/ftrace.txt
>> +++ b/Documentation/trace/ftrace.txt
>> @@ -138,6 +138,12 @@ of ftrace. Here is a list of some of the key files:
>>       This can only be updated when the current_tracer
>>       is set to "nop".
>>
>> +  buffer_overwrite:
>> +
>> +     This controls what happens when the trace buffer is full.
>> +     If "1" (default), the oldest events are discarded and
>> +     overwritten. If "0", then the newest events are discarded.
>> +
>>    tracing_cpumask:
>>
>>       This is a mask that lets the user only trace
>> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
>> index 8d3a248..ab38ac8 100644
>> --- a/include/linux/ring_buffer.h
>> +++ b/include/linux/ring_buffer.h
>> @@ -100,6 +100,8 @@ void ring_buffer_free(struct ring_buffer *buffer);
>>
>>  int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
>>
>> +void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val);
>> +
>>  struct ring_buffer_event *ring_buffer_lock_reserve(struct ring_buffer *buffer,
>>                                                  unsigned long length);
>>  int ring_buffer_unlock_commit(struct ring_buffer *buffer,
>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>> index 9ed509a..3207147 100644
>> --- a/kernel/trace/ring_buffer.c
>> +++ b/kernel/trace/ring_buffer.c
>> @@ -1429,6 +1429,17 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
>>  }
>>  EXPORT_SYMBOL_GPL(ring_buffer_resize);
>>
>> +void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val)
>> +{
>> +     mutex_lock(&buffer->mutex);
>> +     if (val)
>> +             buffer->flags |= RB_FL_OVERWRITE;
>> +     else
>> +             buffer->flags &= ~RB_FL_OVERWRITE;
>> +     mutex_unlock(&buffer->mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(ring_buffer_change_overwrite);
>> +
>>  static inline void *
>>  __rb_data_page_index(struct buffer_data_page *bpage, unsigned index)
>>  {
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index c380612..ed5c14f 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -41,8 +41,6 @@
>>  #include "trace.h"
>>  #include "trace_output.h"
>>
>> -#define TRACE_BUFFER_FLAGS   (RB_FL_OVERWRITE)
>> -
>>  /*
>>   * On boot up, the ring buffer is set to the minimum size, so that
>>   * we do not waste memory on systems that are not using tracing.
>> @@ -241,6 +239,9 @@ int tracing_is_enabled(void)
>>
>>  static unsigned long         trace_buf_size = TRACE_BUF_SIZE_DEFAULT;
>>
>> +/* whether the trace buffer should be overwritten on overflow or not. */
>> +static enum ring_buffer_flags  trace_buffer_flags = RB_FL_OVERWRITE;
>> +
>>  /* trace_types holds a link list of available tracers. */
>>  static struct tracer         *trace_types __read_mostly;
>>
>> @@ -3466,6 +3467,47 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>>       return cnt;
>>  }
>>
>> +static ssize_t
>> +tracing_overwrite_read(struct file *filp, char __user *ubuf,
>> +                  size_t cnt, loff_t *ppos)
>> +{
>> +     char buf[64];
>> +     int r;
>> +     r = snprintf(buf, 64, "%u\n", trace_buffer_flags);
>> +     return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
>> +}
>> +
>> +static ssize_t
>> +tracing_overwrite_write(struct file *filp, const char __user *ubuf,
>> +                   size_t cnt, loff_t *ppos)
>> +{
>> +     unsigned long val;
>> +     char buf[64];
>> +     int ret;
>> +
>> +     if (cnt >= sizeof(buf))
>> +             return -EINVAL;
>> +
>> +     if (copy_from_user(&buf, ubuf, cnt))
>> +             return -EFAULT;
>> +
>> +     buf[cnt] = 0;
>> +
>> +     ret = strict_strtoul(buf, 10, &val);
>> +     if (ret < 0)
>> +             return ret;
>> +     *ppos += cnt;
>> +
>> +     if (val != 0 && val != 1)
>> +             return -EINVAL;
>> +
>> +     if (trace_buffer_flags != val) {
>> +             trace_buffer_flags = val;
>> +             ring_buffer_change_overwrite(global_trace.buffer, val);
>> +     }
>> +     return cnt;
>> +}
>> +
>>  static int mark_printk(const char *fmt, ...)
>>  {
>>       int ret;
>> @@ -3611,6 +3653,12 @@ static const struct file_operations tracing_entries_fops = {
>>       .llseek         = generic_file_llseek,
>>  };
>>
>> +static const struct file_operations tracing_overwrite_fops = {
>> +     .open           = tracing_open_generic,
>> +     .read           = tracing_overwrite_read,
>> +     .write          = tracing_overwrite_write,
>> +};
>> +
>>  static const struct file_operations tracing_mark_fops = {
>>       .open           = tracing_open_generic,
>>       .write          = tracing_mark_write,
>> @@ -4336,6 +4384,9 @@ static __init int tracer_init_debugfs(void)
>>       trace_create_file("buffer_size_kb", 0644, d_tracer,
>>                       &global_trace, &tracing_entries_fops);
>>
>> +     trace_create_file("buffer_overwrite", 0644, d_tracer,
>> +                     &global_trace, &tracing_overwrite_fops);
>> +
>>       trace_create_file("trace_marker", 0220, d_tracer,
>>                       NULL, &tracing_mark_fops);
>>
>> @@ -4565,7 +4616,7 @@ __init static int tracer_alloc_buffers(void)
>>
>>       /* TODO: make the number of buffers hot pluggable with CPUS */
>>       global_trace.buffer = ring_buffer_alloc(ring_buf_size,
>> -                                                TRACE_BUFFER_FLAGS);
>> +                                                trace_buffer_flags);
>>       if (!global_trace.buffer) {
>>               printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
>>               WARN_ON(1);
>> @@ -4575,7 +4626,7 @@ __init static int tracer_alloc_buffers(void)
>>
>>
>>  #ifdef CONFIG_TRACER_MAX_TRACE
>> -     max_tr.buffer = ring_buffer_alloc(1, TRACE_BUFFER_FLAGS);
>> +     max_tr.buffer = ring_buffer_alloc(1, trace_buffer_flags);
>>       if (!max_tr.buffer) {
>>               printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
>>               WARN_ON(1);
>
>
>
