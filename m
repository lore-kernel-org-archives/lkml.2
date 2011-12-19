Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1LSTDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:03:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40666 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1LSTDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:03:03 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=IWQx1ipMXh4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=zvItQ80SajiScnOKr0wA:9 a=pUxhFZX9HkmEko7BiO4A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324321380.5916.26.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv2 02/10] ftrace: Change mcount call replacement logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Mon, 19 Dec 2011 14:03:00 -0500
In-Reply-To: <1323105776-26961-3-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 18:22 +0100, Jiri Olsa wrote:
> The current logic of updating calls is to do the mcount replacement
> only when ftrace_ops is being registered. When ftrace_ops is being
> unregistered then only in case it was the last registered ftrace_ops,
> all calls are disabled.
> 
> This is an issue when ftrace_ops without FTRACE_OPS_FL_GLOBAL flag
> is being unregistered, because all the functions stays enabled
> and thus inherrited by global_ops, like in following scenario:
> 
>   - set restricting global filter
>   - enable function trace
>   - register/unregister ftrace_ops with flags != FTRACE_OPS_FL_GLOBAL
>     and with no filter

I don't see this problem. I just changed stack_tracer to have its own
filter (I've been wanting to do that for a long time, so when I saw this
email, I decided it's a good time to implement it).

Here's what I did:

# echo schedule > set_ftrace_filter
# cat set_ftrace_filter
schedule
# cat enabled_functions
schedule (1)
# echo 1 > /proc/sys/kernel/stack_tracer_enabled
# cat enabled_functions
do_one_initcall (1)
match_dev_by_uuid (1)
name_to_dev_t (1)
idle_notifier_unregister (1)
idle_notifier_register (1)
start_thread_common.constprop.6 (1)
enter_idle (1)
exit_idle (1)
cpu_idle (1)
__show_regs (1)
release_thread (1)
[...]
_cond_resched (1)
preempt_schedule_irq (1)
schedule (2)
io_schedule (1)
yield_to (1)
yield (1)

// note that schedule is (2)

# echo 0 > /proc/sys/kernel/stack_tracer_enabled
# cat enabled_functions
schedule (1)


> 
> Now the global_ops will get by all the functions regardless the
> global_ops filter. So we need all functions that where enabled via
> this ftrace_ops and are not part of global filter to be disabled.

The global functions are not at issue here. What do you see?

Maybe I fixed something as I'm using the latest tip/perf/core. Note, I
can send you the stack_tracer patch if you want to take a look at this
example. I need to clean it up too.

> 
> Note, currently if there are only global ftrace_ops registered,
> there's no filter hash check and the filter is represented only
> by enabled records.
> 
> Changing the ftrace_shutdown logic to ensure the replacement
> is called for each ftrace_ops being unregistered.
> 
> Also changing FTRACE_ENABLE_CALLS into FTRACE_UPDATE_CALLS
> calls which seems more suitable now.

I still think this patch is wrong. What's the problem you are seeing?

-- Steve


