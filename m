Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0KPSXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:23:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52082 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0KPSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:23:51 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=F78WVyrEZB8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=3b4ukNjGJYhu7dSKLkIA:9 a=oF0ldojOskcqDm4_wdkA:7 a=stxjCHl2d7mbq7ctYFP-ZXgN-V0A:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] tracing: Fix recursive user stack trace
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <1289617069.12418.575.camel@gandalf.stny.rr.com>
References: <1289617069.12418.575.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 16 Nov 2010 13:23:49 -0500
Message-ID: <1289931829.30543.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 21:57 -0500, Steven Rostedt wrote:
> Ingo,
> 
> This also includes the two other patches I submitted previously.
> I just rebased the third patch with Eric's recommendation.
> 
> Please pull the latest tip/perf/urgent-3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent-3
> 
> 
> Steven Rostedt (1):
>       tracing: Fix recursive user stack trace

ping?

I did run this through several tests with ktest.pl, and it looks pretty
solid.

-- Steve

> 
> ----
>  kernel/trace/trace.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> ---------------------------
> commit 91e86e560d0b3ce4c5fc64fd2bbb99f856a30a4e
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Wed Nov 10 12:56:12 2010 +0100
> 
>     tracing: Fix recursive user stack trace
>     
>     The user stack trace can fault when examining the trace. Which
>     would call the do_page_fault handler, which would trace again,
>     which would do the user stack trace, which would fault and call
>     do_page_fault again ...
>     
>     Thus this is causing a recursive bug. We need to have a recursion
>     detector here.
>     
>     [ Resubmitted by Jiri Olsa ]
>     
>     [ Eric Dumazet recommended using __this_cpu_* instead of __get_cpu_* ]
>     
>     Cc: Eric Dumazet <eric.dumazet@gmail.com>
>     Signed-off-by: Jiri Olsa <jolsa@redhat.com>
>     LKML-Reference: <1289390172-9730-3-git-send-email-jolsa@redhat.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 82d9b81..ee6a733 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1284,6 +1284,8 @@ void trace_dump_stack(void)
>  	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
>  }
>  
> +static DEFINE_PER_CPU(int, user_stack_count);
> +
>  void
>  ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
>  {
> @@ -1302,6 +1304,18 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
>  	if (unlikely(in_nmi()))
>  		return;
>  
> +	/*
> +	 * prevent recursion, since the user stack tracing may
> +	 * trigger other kernel events.
> +	 */
> +	preempt_disable();
> +	if (__this_cpu_read(user_stack_count))
> +		goto out;
> +
> +	__this_cpu_inc(user_stack_count);
> +
> +
> +
>  	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
>  					  sizeof(*entry), flags, pc);
>  	if (!event)
> @@ -1319,6 +1333,11 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
>  	save_stack_trace_user(&trace);
>  	if (!filter_check_discard(call, entry, buffer, event))
>  		ring_buffer_unlock_commit(buffer, event);
> +
> +	__this_cpu_dec(user_stack_count);
> +
> + out:
> +	preempt_enable();
>  }
>  
>  #ifdef UNUSED
> 


