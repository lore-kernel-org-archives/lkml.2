Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918Ab1D2TqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:46:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760905Ab1D2TqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 15:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xcmR4lTOUD5J0qmpEFRCK6BglnP0brKKQ7jcawsKBUWgl7nteBKCe2bEP1vYV/u/0l
         tATl9EBFRMpWCbjm2sHA==
MIME-Version: 1.0
In-Reply-To: <1304033561.18763.212.camel@gandalf.stny.rr.com>
References: <1303512373-25992-1-git-send-email-vnagarnaik@google.com> <1304033561.18763.212.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Apr 2011 12:45:28 -0700
Message-ID: <BANLkTimY9weoBhiQv+dfS4UzYPGBFDdPQQ@mail.gmail.com>
Subject: Re: [PATCH] trace: Add a free on close control mechanism for buffer_size_kb
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 4:32 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Sorry, my mind has been elsewhere and I forgot about your patches.
>
> On Fri, 2011-04-22 at 15:46 -0700, Vaibhav Nagarnaik wrote:
>> The proc file entry buffer_size_kb is used to set the size of tracing
>> buffer. The memory to expand the buffer size is kernel memory. Consider
>> a use case where tracing is handled by a user space utility, which acts
>> as a gate keeper for tracing requests. In an OOM condition, tracing is
>> considered a low priority task and if the utility gets killed the ring
>> buffer memory cannot be released back to the kernel.
>>
>> This patch adds an IOCTL on the buffer_size_kb file to set a boolean.
>> When this boolean is enabled, closing buffer_size_kb file will cause
>> tracing to stop and free up the ring buffer memory.
>>
>> The user space process can then open the buffer_size_kb file to set the
>> new buffer size for tracing, enable the boolean through IOCTL and keep
>> the file open. Under OOM condition, if the process gets killed, the
>> kernel closes the file descriptor for buffer_size_kb. The release
>> handler stops the tracing and releases the kernel memory automatically.
>>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>> ---
>>  include/linux/ftrace.h |    3 +
>>  kernel/trace/trace.c   |  135 ++++++++++++++++++++++++++++++++++++------------
>>  2 files changed, 105 insertions(+), 33 deletions(-)
>>
>> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
>> index ca29e03..30c8a23 100644
>> --- a/include/linux/ftrace.h
>> +++ b/include/linux/ftrace.h
>> @@ -114,6 +114,9 @@ struct ftrace_func_command {
>>                                       char *params, int enable);
>>  };
>>
>> +/* enable/disable auto free ring buffer on file close */
>> +#define TRACE_RINGBUF_FREE_ON_CLOSE _IOW('t', 0x01, int)
>> +
>>  #ifdef CONFIG_DYNAMIC_FTRACE
>>
>>  int ftrace_arch_code_modify_prepare(void);
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index d38c16a..c676f17 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -2817,6 +2817,42 @@ static int tracing_resize_ring_buffer(unsigned long size)
>>       return ret;
>>  }
>>
>> +static ssize_t tracing_buffer_resize_atomic(unsigned long size)
>
> Why call it "atomic"? Because you do the mutex? Anyway I hate the name.
> It sounds like it can do it without preemption, which it clearly can't
> do.

I just wanted to note that it was a locked operation. I have changed the name
to tracing_buffer_resize_locked.

If you think it can be named better, I will change it.

>
> The rest looks fine to me.
>
Thanks for reviewing. I will send the updated patch.

> -- Steve
>
>> +{
>> +     int cpu, ret = 0;
>> +
>> +     mutex_lock(&trace_types_lock);
>> +
>> +     tracing_stop();
>> +
>> +     /* disable all cpu buffers */
>> +     for_each_tracing_cpu(cpu) {
>> +             if (global_trace.data[cpu])
>> +                     atomic_inc(&global_trace.data[cpu]->disabled);
>> +             if (max_tr.data[cpu])
>> +                     atomic_inc(&max_tr.data[cpu]->disabled);
>> +     }
>> +
>> +     if (size != global_trace.entries)
>> +             ret = tracing_resize_ring_buffer(size);
>> +
>> +     /* If check pages failed, return ENOMEM */
>> +     if (tracing_disabled)
>> +             ret = -ENOMEM;
>> +
>> +     for_each_tracing_cpu(cpu) {
>> +             if (global_trace.data[cpu])
>> +                     atomic_dec(&global_trace.data[cpu]->disabled);
>> +             if (max_tr.data[cpu])
>> +                     atomic_dec(&max_tr.data[cpu]->disabled);
>> +     }
>> +
>> +     tracing_start();
>> +     mutex_unlock(&trace_types_lock);
>> +
>> +     return ret;
>> +}
>> +
>>
>
>
>

Vaibhav Nagarnaik
