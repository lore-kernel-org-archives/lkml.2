Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934757Ab0KQMaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:30:02 -0500
Received: from canuck.infradead.org ([134.117.69.58]:48166 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab0KQMaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:30:00 -0500
Subject: Re: [patch] trace: Add user-space event tracing/injection
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101117120740.GA24972@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE38C53.8090606@kernel.org>  <20101117120740.GA24972@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 13:29:54 +0100
Message-ID: <1289996994.2109.731.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 13:07 +0100, Ingo Molnar wrote:

> Subject: trace: Add user-space event tracing/injection
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed Nov 17 10:11:53 CET 2010
> 
> This feature (suggested by Darren Hart and Pekka Engberg) allows user-space
> programs to print trace events in a very simple and self-contained way:
> 
>  #include <sys/prctl.h>
>  #include <string.h>
> 
>  #define PR_TASK_PERF_USER_TRACE 35
> 
>  int main(void)
>  {
>          char *msg = "Hello World!\n";
> 
>          prctl(PR_TASK_PERF_USER_TRACE, msg, strlen(msg));
> 
>          return 0;
>  }
> 
> These show up in 'trace' output as:
> 
>  $ trace report
>  #
>  # trace events of 'sleep 1':
>  #
>         testit/ 6006 ( 0.002 ms): <"Hello World!">
>         testit/ 6006 ( 0.002 ms): <"Hello World!">
> 
> Suggested-by: Darren Hart <dvhart@linux.intel.com>
> Suggested-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

I really dislike abusing prctl(), I understand your reasons, but it
still sucks.

Also, the naming doesn't work, you've implemented a trace event, that's
got nothing to do with perf, so the PR_TASK_PERF_ prefix is incorrect.


> Index: linux/include/linux/prctl.h
> ===================================================================
> --- linux.orig/include/linux/prctl.h
> +++ linux/include/linux/prctl.h
> @@ -102,4 +102,6 @@
>  
>  #define PR_MCE_KILL_GET 34
>  
> +#define PR_TASK_PERF_USER_TRACE			35
> +
>  #endif /* _LINUX_PRCTL_H */
> Index: linux/include/trace/events/user.h
> ===================================================================
> --- /dev/null
> +++ linux/include/trace/events/user.h
> @@ -0,0 +1,32 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM user
> +
> +#if !defined(_TRACE_USER_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_USER_H_
> +
> +#include <linux/tracepoint.h>
> +#include <linux/ftrace.h>
> +
> +TRACE_EVENT(user,
> +
> +	TP_PROTO(const char *message),
> +
> +	TP_ARGS(message),
> +
> +	TP_STRUCT__entry(
> +		__string(	message, message);
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(message, message);
> +	),
> +
> +	TP_printk("user %s", __get_str(message))
> +);
> +
> +#undef NO_DEV
> +
> +#endif /* _TRACE_USER_H_ */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> Index: linux/kernel/sys.c
> ===================================================================
> --- linux.orig/kernel/sys.c
> +++ linux/kernel/sys.c
> @@ -47,6 +47,11 @@
>  #include <asm/io.h>
>  #include <asm/unistd.h>
>  
> +#define MAX_USER_TRACE_SIZE 128
> +
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/user.h>
> +
>  #ifndef SET_UNALIGN_CTL
>  # define SET_UNALIGN_CTL(a,b)	(-EINVAL)
>  #endif
> @@ -1681,6 +1686,24 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
>  		case PR_TASK_PERF_EVENTS_ENABLE:
>  			error = perf_event_task_enable();
>  			break;
> +		/*
> +		 * Inject a trace event into the current tracing context:
> +		 */
> +		case PR_TASK_PERF_USER_TRACE:
> +		{
> +			void __user *uevent_ptr = (void *)arg2;
> +			char kstring[MAX_USER_TRACE_SIZE+1];
> +			unsigned long uevent_len = arg3;
> +
> +			if (uevent_len > MAX_USER_TRACE_SIZE)
> +				return -EINVAL;
> +			if (copy_from_user(kstring, uevent_ptr, uevent_len))
> +				return -EFAULT;
> +			kstring[uevent_len] = 0;
> +
> +			trace_user(kstring);
> +			return 0;
> +		}
>  		case PR_GET_TIMERSLACK:
>  			error = current->timer_slack_ns;
>  			break;

