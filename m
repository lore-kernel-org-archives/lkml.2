Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2CXExo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 00:53:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44172 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab2CXExn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 00:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+jqyFAzpTs+JeemD7wpSgW0hmECMSPMsaZtQ7zLgn+ebXSJFQ@mail.gmail.com>
References: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
	<1332531400.23924.71.camel@gandalf.stny.rr.com>
	<CA+jqyFAzpTs+JeemD7wpSgW0hmECMSPMsaZtQ7zLgn+ebXSJFQ@mail.gmail.com>
Date: Sat, 24 Mar 2012 10:23:42 +0530
Message-ID: <CA+jqyFC6ZNOaGBTPc7s7EoTsJBUn6Z+43H0At_YmQ7gsUiP4eA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
From: Rajesh Bhagat <rajesh.lnx@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Just to add to it, This problem occurs only in case when same tracer
is enabled again i.e. function on function.
In other case code does not hit below code, and anyways
tracing_reset_online_cpus and trace->init is called to reset the
trace.

>>> -   if (t == current_trace)
>>> +   if (t == current_trace) {
>>> +       tracing_reset_online_cpus(tr);
>>>         goto out;
>>> +   }

My point is, this issue is specific to a situation i.e. same tracer
set again, hence making resetting the trace not a very obvious choice.

Please comment.

-Rajesh

On Sat, Mar 24, 2012 at 9:47 AM, Rajesh Bhagat <rajesh.lnx@gmail.com> wrote:
> Hi Steven,
>
> Thanks for the reply.
>
> I was wondering, why would a user reset the trace __explicitly__
> without even using it.
> That is why i created a patch for it.
>
>>> /debug/tracing # echo function > current_tracer
>>> /debug/tracing # cat trace <------ Not performed
>>> /debug/tracing # echo schedule > set_ftrace_filter
>>> /debug/tracing # echo function > current_trace
>>> /debug/tracing # cat trace <------- Only this is performed
>
> - Rajesh
>
> On Sat, Mar 24, 2012 at 1:06 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Wed, 2012-03-21 at 11:22 +0530, Rajesh Bhagat wrote:
>>> >From 60ec8a88ba671fa0b424f7b4467dba3ea8a2a2c8 Mon Sep 17 00:00:00 2001
>>> From: Rajesh Bhagat <rajesh.lnx@gmail.com>
>>> Date: Tue, 20 Mar 2012 10:35:59 +0530
>>> Subject: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
>>>
>>> This patch resets the trace_array using tracing_reset_online_cpus, if same
>>> tracer is set again instead of just returning from funtion tracing_set_tracer.
>>>
>>> problem description
>>> -------------------
>>> once function tracer is set, set_ftrace_filter not working.
>>> /debug/tracing # echo function > current_tracer
>>> /debug/tracing # echo schedule > set_ftrace_filter
>>> /debug/tracing # echo function > current_tracer
>>
>> Sorry no. The correct way you want to do this is:
>>
>> /debug/tracing # echo > trace
>>
>> That will reset the buffer for you and give you the desired result.
>>
>> -- Steve
>>
>>
>>
>>> /debug/tracing #  cat trace
>>> # tracer: function
>>> #
>>> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>>> #              | |       |          |         |
>>>           <idle>-0     [000]    21.997778: irq_enter <-handle_IRQ
>>>           <idle>-0     [000]    21.997785: idle_cpu <-irq_enter
>>>           <idle>-0     [000]    21.997794: local_bh_disable <-irq_enter
>>>           <idle>-0     [000]    21.997800: tick_check_idle <-irq_enter
>>>           <idle>-0     [000]    21.997807:
>>> tick_check_oneshot_broadcast <-tick_check_idle
>>>           <idle>-0     [000]    21.997814: _local_bh_enable <-irq_enter
>>>
>>> After applying this patch, only filtered functions are traced.
>>>
>>> Signed-off-by: Rajesh Bhagat <rajesh.lnx@gmail.com>
>>> ---
>>>  kernel/trace/trace.c |    4 +++-
>>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>>> index a3f1bc5..f4fb190 100644
>>> --- a/kernel/trace/trace.c
>>> +++ b/kernel/trace/trace.c
>>> @@ -3058,8 +3058,10 @@ static int tracing_set_tracer(const char *buf)
>>>         ret = -EINVAL;
>>>         goto out;
>>>     }
>>> -   if (t == current_trace)
>>> +   if (t == current_trace) {
>>> +       tracing_reset_online_cpus(tr);
>>>         goto out;
>>> +   }
>>>
>>>     trace_branch_disable();
>>>     if (current_trace && current_trace->reset)
>>
>>
