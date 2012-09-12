Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2ILDi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:38:28 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37703 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2ILDi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <1347410070.10751.28.camel@gandalf.local.home>
References: <1347134489-15380-1-git-send-email-elezegarcia@gmail.com>
	<1347410070.10751.28.camel@gandalf.local.home>
Date: Wed, 12 Sep 2012 00:38:25 -0300
Message-ID: <CALF0-+UR0BVMwv7b7On6JeUm27v52C0++D=7m5RZS0AYugVvow@mail.gmail.com>
Subject: Re: [PATCH v3] trace: Move trace event enable from fs_initcall to core_initcall
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        tim.bird@am.sony.com, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 9:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2012-09-08 at 17:01 -0300, Ezequiel Garcia wrote:
>> This patch splits trace event initialization in two stages:
>>  * ftrace enable
>>  * sysfs event entry creation
>>
>> This allows to capture trace events from an earlier point
>> by using 'trace_event' kernel parameter and is important
>> to trace boot-up allocations.
>>
>> Note that, in order to enable events at core_initcall,
>> it's necessary to move init_ftrace_syscalls() from
>> core_initcall to early_initcall.
>
> Found another issue...
>
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> ---
>> Changes from v1:
>>   * Rework code as requested by Steven.
>>
>> Changes from v2:
>>   * Move init_ftrace_syscalls() to early_initcall,
>>     so syscalls self-test pass.
>>
>>  kernel/trace/trace_events.c   |  104 +++++++++++++++++++++++++++-------------
>>  kernel/trace/trace_syscalls.c |    2 +-
>>  2 files changed, 71 insertions(+), 35 deletions(-)
>>
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 29111da..4eaf86e 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -1199,6 +1199,31 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
>>       return 0;
>>  }
>>
>> +static void event_remove(struct ftrace_event_call *call)
>> +{
>> +     ftrace_event_enable_disable(call, 0);
>> +     if (call->event.funcs)
>> +             __unregister_ftrace_event(&call->event);
>> +     list_del(&call->list);
>> +}
>> +
>> +static int event_init(struct ftrace_event_call *call)
>> +{
>> +     int ret = 0;
>> +
>> +     if (WARN_ON(!call->name))
>> +             return -EINVAL;
>> +
>> +     if (call->class->raw_init) {
>> +             ret = call->class->raw_init(call);
>
> If raw_init() returns a failure, we skip this event.
>
>> +             if (ret < 0 && ret != -ENOSYS)
>> +                     pr_warn("Could not initialize trace events/%s\n",
>> +                             call->name);
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>>  static int
>>  __trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
>>                      const struct file_operations *id,
>> @@ -1209,19 +1234,9 @@ __trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
>>       struct dentry *d_events;
>>       int ret;
>>
>> -     /* The linker may leave blanks */
>> -     if (!call->name)
>> -             return -EINVAL;
>> -
>> -     if (call->class->raw_init) {
>> -             ret = call->class->raw_init(call);
>> -             if (ret < 0) {
>> -                     if (ret != -ENOSYS)
>> -                             pr_warning("Could not initialize trace events/%s\n",
>> -                                        call->name);
>> -                     return ret;
>> -             }
>> -     }
>> +     ret = event_init(call);
>> +     if (ret < 0)
>> +             return ret;
>>
>>       d_events = event_trace_events_dir();
>>       if (!d_events)
>> @@ -1272,13 +1287,10 @@ static void remove_subsystem_dir(const char *name)
>>   */
>>  static void __trace_remove_event_call(struct ftrace_event_call *call)
>>  {
>> -     ftrace_event_enable_disable(call, 0);
>> -     if (call->event.funcs)
>> -             __unregister_ftrace_event(&call->event);
>> -     debugfs_remove_recursive(call->dir);
>> -     list_del(&call->list);
>> +     event_remove(call);
>>       trace_destroy_fields(call);
>>       destroy_preds(call);
>> +     debugfs_remove_recursive(call->dir);
>>       remove_subsystem_dir(call->class->system);
>>  }
>>
>> @@ -1450,6 +1462,36 @@ static __init int setup_trace_event(char *str)
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
>> +             ret = event_init(call);
>> +             if (!ret)
>> +                     list_add(&call->list, &ftrace_events);
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
>> +                     pr_warn("Failed to enable trace event: %s\n", token);
>> +     }
>> +     return 0;
>> +}
>> +
>>  static __init int event_trace_init(void)
>>  {
>>       struct ftrace_event_call **call;
>> @@ -1457,8 +1499,6 @@ static __init int event_trace_init(void)
>>       struct dentry *entry;
>>       struct dentry *d_events;
>>       int ret;
>> -     char *buf = bootup_event_buf;
>> -     char *token;
>>
>>       d_tracer = tracing_init_dentry();
>>       if (!d_tracer)
>> @@ -1497,24 +1537,19 @@ static __init int event_trace_init(void)
>>       if (trace_define_common_fields())
>>               pr_warning("tracing: Failed to allocate common fields");
>>
>> +     /*
>> +      * Early initialization already enabled ftrace event.
>> +      * Now it's only necessary to create the event directory.
>> +      */
>>       for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
>> -             __trace_add_event_call(*call, NULL, &ftrace_event_id_fops,
>
> Here, __trace_add_event_call() did the checks and did not create a
> directory on raw_init() failure. But now there's no check, and we are
> having events being created that should not be.
>

Mmmm... I see.

>> +
>> +             ret = event_create_dir(*call, d_events,
>> +                                    &ftrace_event_id_fops,
>>                                      &ftrace_enable_fops,
>>                                      &ftrace_event_filter_fops,
>>                                      &ftrace_event_format_fops);
>
> I found this out when there was errors in trace-cmd reading format
> files. Looking into it, I found several syscalls that are not mapped to
> a syscall_nr being created.
>
> One solution would be to add another flag to the ftrace_event_call
> structure, that notes the event has failed to initialize. Or better yet,
> add a flag that just says that it was initialized. Then here we can skip
> those events that do not have that flag set.
>

Ok. I'll re-send.

Thanks!
Ezequiel.
