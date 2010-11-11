Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab0KKAMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:12:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59781 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab0KKAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:12:24 -0500
Message-ID: <4CDB3538.4080605@cn.fujitsu.com>
Date: Thu, 11 Nov 2010 08:13:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing - fix recursive user stack trace
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com> <1289390172-9730-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1289390172-9730-3-git-send-email-jolsa@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-11 08:12:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-11 08:12:50,
	Serialize complete at 2010-11-11 08:12:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> The user stack trace can fault when examining the trace. Which
> would call the do_page_fault handler, which would trace again,
> which would do the user stack trace, which would fault and call
> do_page_fault again ...
> 
> Thus this is causing a recursive bug. We need to have a recursion
> detector here.
> 

I guess this is from what I reported to Redhat, triggered by
the ftrace stress test. ;)

This patch should be the first patch, otherwise you introduce
a regression. Though it merely a problem in this case, better
avoid it.

A nitpick below:

> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 82d9b81..0215e87 100644
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
> +	if (__get_cpu_var(user_stack_count))
> +		goto out;
> +
> +	__get_cpu_var(user_stack_count)++;
> +
> +
> +

redundant blank lines.

>  	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
>  					  sizeof(*entry), flags, pc);
>  	if (!event)
> @@ -1319,6 +1333,11 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
>  	save_stack_trace_user(&trace);
>  	if (!filter_check_discard(call, entry, buffer, event))
>  		ring_buffer_unlock_commit(buffer, event);
> +
> +	__get_cpu_var(user_stack_count)--;
> +
> + out:
> +	preempt_enable();
>  }
>  
>  #ifdef UNUSED
