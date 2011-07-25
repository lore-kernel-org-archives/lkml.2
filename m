Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1GYTng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:43:36 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33482 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1GYTne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:43:34 -0400
MIME-Version: 1.0
In-Reply-To: <1311618747.3526.32.camel@gandalf.stny.rr.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	<1311618747.3526.32.camel@gandalf.stny.rr.com>
Date: Mon, 25 Jul 2011 15:43:32 -0400
Message-ID: <CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Arnaud Lacombe <lacombar@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 25, 2011 at 2:32 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-07-18 at 17:40 +0800, stufever@gmail.com wrote:
>> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
>>
>> It's harmless but annyoing.
>>   kernel/trace/trace_printk.c: In function 'module_trace_bprintk_format_notify':
>>   kernel/trace/trace_printk.c:52: warning: 'fmt' may be used uninitialized in this function
>
> I prefer not to add this patch. Fix gcc. Actually some gcc's do not warn
> on this, others do. Here's the code that confuses gcc:
>
>                tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
>                if (tb_fmt)
>                        fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
>                if (tb_fmt && fmt) {
>                        list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
>                        strcpy(fmt, *iter);
>                        tb_fmt->fmt = fmt;
>                        *iter = tb_fmt->fmt;
>
>
> fmt will never be looked at if tb_fmt is NULL, and fmt is initialized if
> tb_fmt is not NULL.
>
Actually, we have a special uninitialized_var(x) macro to handle such
false positive. From include/linux/compiler-gcc.h:

/*
 * A trick to suppress uninitialized variable warning without generating any
 * code
 */
#define uninitialized_var(x) x = x

 - Arnaud

> -- Steve
>
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
>>
>> ---
>>  kernel/trace/trace_printk.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
>> index 1f06468..1a5fff8 100644
>> --- a/kernel/trace/trace_printk.c
>> +++ b/kernel/trace/trace_printk.c
>> @@ -49,7 +49,7 @@ static
>>  void hold_module_trace_bprintk_format(const char **start, const char **end)
>>  {
>>       const char **iter;
>> -     char *fmt;
>> +     char *fmt = NULL;
>>
>>       mutex_lock(&btrace_mutex);
>>       for (iter = start; iter < end; iter++) {
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
