Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab0KLPVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:21:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60651 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab0KLPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:21:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ag2hhhV9jN3/MJF+vH2BHLtmrgfEzoCQaTe8wQLZ2oaEzBJGsM1AJnWVYvKrLjQitB
         PKISSX0qE7cDFmu3suupe/j4lC8BFnFj/8BVRlHPHbUCBT7GVUN4b3nHMLQDGrssCPzb
         8vibA/80KUcC8O+l5TVcNWqHUHnQhfbtSOsHI=
Subject: Re: [PATCH 3/3] tracing: Fix recursive user stack trace
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <20101112151223.183540991@goodmis.org>
References: <20101112151045.672405637@goodmis.org>
	 <20101112151223.183540991@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 16:21:11 +0100
Message-ID: <1289575271.3185.256.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 10:10 -0500, Steven Rostedt a écrit :
> pièce jointe document texte brut
> (0003-tracing-Fix-recursive-user-stack-trace.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The user stack trace can fault when examining the trace. Which
> would call the do_page_fault handler, which would trace again,
> which would do the user stack trace, which would fault and call
> do_page_fault again ...
> 
> Thus this is causing a recursive bug. We need to have a recursion
> detector here.
> 
> [ Resubmitted by Jiri Olsa ]
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> LKML-Reference: <1289390172-9730-3-git-send-email-jolsa@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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

	if (__this_cpu_read(user_stack_count))
		goto out;

> +	__get_cpu_var(user_stack_count)++;

	__this_cpu_inc(user_stack_count);

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
> +	__get_cpu_var(user_stack_count)--;
	__this_cpu_dec(user_stack_count);

> +
> + out:
> +	preempt_enable();
>  }
>  
>  #ifdef UNUSED


