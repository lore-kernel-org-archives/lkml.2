Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab2HQLBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:01:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64847 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab2HQLBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:01:19 -0400
MIME-Version: 1.0
In-Reply-To: <1345151883.3708.7.camel@gandalf.local.home>
References: <1345043907-18299-1-git-send-email-elezegarcia@gmail.com>
	<1345151883.3708.7.camel@gandalf.local.home>
Date: Fri, 17 Aug 2012 08:01:18 -0300
Message-ID: <CALF0-+WVoJ2NTPm7xZc0rr8-ZZ6an1BsN0SLtJvxzFd3CxA6bA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] trace: Move trace event enable from fs_initcall
 to early_initcall
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        tim.bird@am.sony.com, lizefan@huawei.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Thu, Aug 16, 2012 at 6:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-08-15 at 12:18 -0300, Ezequiel Garcia wrote:
>> This patch splits trace event initialization in two stages:
>>  * ftrace enable
>>  * sysfs event entry creation
>>
>> This allows to capture trace events from an earlier point
>> by using 'trace_event' kernel parameter and is important
>> to trace boot-up allocations.
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> ---
>>  kernel/trace/trace_events.c |   71 ++++++++++++++++++++++++++++++++-----------
>>  1 files changed, 53 insertions(+), 18 deletions(-)
>>
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 29111da..3055bc9 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -1450,6 +1450,49 @@ static __init int setup_trace_event(char *str)
>>  }
>>  __setup("trace_event=", setup_trace_event);
>>
>> +static __init int event_trace_enable(void)
>> +{
>> +     struct ftrace_event_call **iter, *call;
>> +     char *buf = bootup_event_buf;
>> +     char *token;
>> +     int ret;
>> +
>> +     for_each_event(iter, __start_ftrace_events, __stop_ftrace_events) {
>> +
>> +             call = *iter;
>> +
>> +             /* The linker may leave blanks */
>
> Actually, this shouldn't be true anymore. I know you copied the comment,
> but with the new pointer settings, there should be no blanks. We
> probably should turn this into a WARN_ON().
>
>
>> +             if (!call->name)
>> +                     continue;
>> +
>> +             if (!call->class->raw_init)
>> +                     continue;
>> +
>> +             ret = call->class->raw_init(call);
>> +             if (ret < 0) {
>> +                     if (ret != -ENOSYS)
>> +                             pr_warning("Could not initialize trace events/%s\n",
>> +                                             call->name);
>> +                     continue;
>> +             }
>> +             list_add(&call->list, &ftrace_events);
>
> Anyway, this code is duplicated now here and in
> __trace_add_event_call(). A helper function should be created to store
> this in both locations.
>
>> +     }
>> +
>> +     while (true) {
>> +             token = strsep(&buf, ",");
>> +
>> +             if (!token)
>> +                     break;
>> +             if (!*token)
>> +                     continue;
>> +
>> +             ret = ftrace_set_clr_event(token, 1);
>> +             if (ret)
>> +                     pr_warning("Failed to enable trace event: %s\n", token);
>> +     }
>> +     return 0;
>> +}
>> +
>>  static __init int event_trace_init(void)
>>  {
>>       struct ftrace_event_call **call;
>> @@ -1457,8 +1500,6 @@ static __init int event_trace_init(void)
>>       struct dentry *entry;
>>       struct dentry *d_events;
>>       int ret;
>> -     char *buf = bootup_event_buf;
>> -     char *token;
>>
>>       d_tracer = tracing_init_dentry();
>>       if (!d_tracer)
>> @@ -1497,24 +1538,17 @@ static __init int event_trace_init(void)
>>       if (trace_define_common_fields())
>>               pr_warning("tracing: Failed to allocate common fields");
>>
>> +     /*
>> +      * Early initialization already enabled ftrace event.
>> +      * Now it's only necessary to create the event directory.
>> +      */
>>       for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
>> -             __trace_add_event_call(*call, NULL, &ftrace_event_id_fops,
>> -                                    &ftrace_enable_fops,
>> -                                    &ftrace_event_filter_fops,
>> -                                    &ftrace_event_format_fops);
>> -     }
>> -
>> -     while (true) {
>> -             token = strsep(&buf, ",");
>> -
>> -             if (!token)
>> -                     break;
>> -             if (!*token)
>> -                     continue;
>>
>> -             ret = ftrace_set_clr_event(token, 1);
>> -             if (ret)
>> -                     pr_warning("Failed to enable trace event: %s\n", token);
>> +             event_create_dir(*call, d_events,
>> +                              &ftrace_event_id_fops,
>> +                              &ftrace_enable_fops,
>> +                              &ftrace_event_filter_fops,
>> +                              &ftrace_event_format_fops);
>
> This changes how events are currently. If we fail to create the
> directory, we still keep the event. This can become confusing as events
> and the directories will not match anymore. A failure should be checked
> for, and if it happens, the event should be removed.
>

Thanks for your comments, I'll send a v2 addressing them.

Regarding the 'complete solution': to be able to capture events from
the very beggining...
Have you thought about this?
Could you give me a hint on how could I implement it?

Thanks a lot,
Ezequiel.
