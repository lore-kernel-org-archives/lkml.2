Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1LTTjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:39:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1LTTjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:39:11 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=IWQx1ipMXh4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=o2_tgM38Kur_7_Oqon0A:9 a=U54qH2rvtv5-tYZgsWcA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324409949.5916.78.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv2 02/10] ftrace: Change mcount call replacement logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Tue, 20 Dec 2011 14:39:09 -0500
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

Actually it has nothing to do with the global flag. The bug is just two
different ftrace_ops. As I can make the problem go either way (by
disabling the global_tracer I screwed up the stack_tracer). I was also
able to screw up the stack tracer with the function_profile_ops that
does not have the flag set either.

I was able to trigger this bug with just using the new stack_trace ops
and the function profiling ops. Neither of them have the global flag
set.


> is being unregistered, because all the functions stays enabled
> and thus inherrited by global_ops, like in following scenario:
> 
>   - set restricting global filter
>   - enable function trace
>   - register/unregister ftrace_ops with flags != FTRACE_OPS_FL_GLOBAL
>     and with no filter

The real problem is:

	- set restricting filter on one ftrace_ops
	- enable function tracing for that ftrace_ops
	- register/unregister another ftrace_ops with no filter
	- Now the first ftrace_ops has all the functions of the last

> 
> Now the global_ops will get by all the functions regardless the
> global_ops filter. So we need all functions that where enabled via
> this ftrace_ops and are not part of global filter to be disabled.
> 
> Note, currently if there are only global ftrace_ops registered,
> there's no filter hash check and the filter is represented only
> by enabled records.

This isn't totally true either, as function_profile_call has the same
issue. This bug does exist in mainline today. If you unconfigure
function graph tracing, then the function profiling uses function tracer
instead of function graph tracer to profile.

Here, I just reproduced it:

 # cd /debug/tracing/
 # echo schedule > set_ftrace_filter
 # echo 1 > function_profile_enabled
 # echo 0 > function_profile_enabled
 # cat set_ftrace_filter
schedule
 # cat trace
# tracer: function
#
# entries-in-buffer/entries-written: 87869/87869   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
     kworker/1:1-49    [001] d..2    13.258661: __rcu_read_unlock <-__schedule
     kworker/1:1-49    [001] d..2    13.258661: _raw_spin_lock <-__schedule
     kworker/1:1-49    [001] d..2    13.258661: add_preempt_count <-_raw_spin_lock
     kworker/1:1-49    [001] d..3    13.258662: put_prev_task_fair <-__schedule
     kworker/1:1-49    [001] d..3    13.258662: pick_next_task_fair <-pick_next_task
     kworker/1:1-49    [001] d..3    13.258662: pick_next_task_stop <-pick_next_task
     kworker/1:1-49    [001] d..3    13.258663: pick_next_task_rt <-pick_next_task
     kworker/1:1-49    [001] d..3    13.258663: pick_next_task_fair <-pick_next_task
     kworker/1:1-49    [001] d..3    13.258663: pick_next_task_idle <-pick_next_task
     kworker/1:1-49    [001] d..3    13.258664: sched_switch: prev_comm=kworker/1:1 prev_pid=49 prev_prio=120 prev_state=S ==> next_comm=kworker/0:0 next_pid=0 next_prio=120
     kworker/1:1-49    [001] d..3    13.258664: __switch_to <-__schedule
          <idle>-0     [001] ...1    13.258665: __schedule <-schedule
          <idle>-0     [001] ...1    13.258665: add_preempt_count <-__schedule
          <idle>-0     [001] ...2    13.258665: rcu_note_context_switch <-__schedule
          <idle>-0     [001] ...2    13.258665: rcu_utilization: Start context switch

I'll put this to the front of my patch queue and also add it to urgent.
I'll also rewrite your change log to remove the reference to the global
ops.

-- Steve

> 
> Changing the ftrace_shutdown logic to ensure the replacement
> is called for each ftrace_ops being unregistered.
> 
> Also changing FTRACE_ENABLE_CALLS into FTRACE_UPDATE_CALLS
> calls which seems more suitable now.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---


