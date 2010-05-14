Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0ENWVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:21:44 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:59757 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315Ab0ENWVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:21:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACNq7UtGGOJc/2dsb2JhbACeBXK+AIUQBA
Date: Fri, 14 May 2010 18:21:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 13/13 v3] tracing: Comment the use of event_mutex with
	trace event flags
Message-ID: <20100514222140.GA14234@Krystal>
References: <20100514192246.079025623@goodmis.org> <20100514192917.222882793@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100514192917.222882793@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:20:47 up 37 days,  8:14,  3 users,  load average: 0.30, 0.14,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The flags variable is protected by the event_mutex when modifying,
> but the event_mutex is not held when reading the variable.
> 
> This is due to the fact that the reads occur in critical sections where
> taking a mutex (or even a spinlock) is not wanted.
> 
> But the two flags that exist (enable and filter_active) have the code
> written as such to handle the reads to not need a lock.
> 
> The enable flag is used just to know if the event is enabled or not
> and its use is always under the event_mutex. Whether or not the event
> is actually enabled is really determined by the tracepoint being
> registered. The flag is just a way to let the code know if the tracepoint
> is registered.
> 
> The filter_active is different. It is read without the lock. If it
> is set, then the event probes jump to the filter code. There can be a
> slight mismatch between filters available and filter_active. If the flag is
> set but no filters are available, the code safely jumps to a filter nop.
> If the flag is not set and the filters are available, then the filters
> are skipped. This is acceptable since filters are usually set before
> tracing or they are set by humans, which would not notice the slight
> delay that this causes.
> 
> Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 5ac97a4..3578e90 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -169,7 +169,14 @@ struct ftrace_event_call {
>  	 *   bit 1:		enabled
>  	 *   bit 2:		filter_active
>  	 *
> -	 *  Must hold event_mutex to change.
> +	 * Changes to flags must hold the event_mutex.
> +	 *
> +	 * Note: Reads of flags do not hold the event_mutex since
> +	 * they occur in critical sections. But the way flags
> +	 * is currently used, these changes do no affect the code
> +	 * except that when a change is made, it may have a slight
> +	 * delay in propagating the changes to other CPUs due to
> +	 * cacheing and such.

cacheing -> caching ?

Besides this minor nit:

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

>  	 */
>  	unsigned int		flags;
>  
> -- 
> 1.7.0
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
