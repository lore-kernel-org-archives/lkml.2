Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0FKIFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 04:05:23 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:36768 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0FKIFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 04:05:16 -0400
X-AuditID: b753bd60-a6a3dba000006d9b-7f-4c11edb4fe65
Message-ID: <4C11EDAF.4010600@hitachi.com>
Date: Fri, 11 Jun 2010 17:02:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH][GIT PULL][v2.6.35] perf/tracing: Fix regression of perf
 losing kprobe events
References: <1276217919.28329.6.camel@gandalf.stny.rr.com>
In-Reply-To: <1276217919.28329.6.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> Steven Rostedt (1):
>       perf/tracing: Fix regression of perf losing kprobe events
> 
> ----
>  kernel/trace/trace_event_perf.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> ---------------------------
> commit a8fb2608053547bc3152ea61a5ec7cdfce5d942c
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Thu Jun 10 14:53:16 2010 -0400
> 
>     perf/tracing: Fix regression of perf losing kprobe events
>     
>     With the addition of the code to shrink the kernel tracepoint
>     infrastructure, we lost kprobes being traced by perf. The reason
>     is that I tested if the "tp_event->class->perf_probe" existed before
>     enabling it. This prevents "ftrace only" events (like the function
>     trace events) from being enabled by perf.
>     
>     Unfortunately, kprobe events do not use perf_probe. This causes
>     kprobes to be missed by perf. To fix this, we add the test to
>     see if "tp_event->class->reg" exists as well as perf_probe.
>     
>     Normal trace events have only "perf_probe" but no "reg" function,
>     and kprobes and syscalls have the "reg" but no "perf_probe".
>     The ftrace unique events do not have either, so this is a valid
>     test. If a kprobe or syscall is not to be probed by perf, the
>     "reg" function is called anyway, and will return a failure and
>     prevent perf from probing it.
>     
>     Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>     Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Thank you for fixing,

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>


> 
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index e6f6588..8a2b73f 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -96,7 +96,9 @@ int perf_trace_init(struct perf_event *p_event)
>  	mutex_lock(&event_mutex);
>  	list_for_each_entry(tp_event, &ftrace_events, list) {
>  		if (tp_event->event.type == event_id &&
> -		    tp_event->class && tp_event->class->perf_probe &&
> +		    tp_event->class &&
> +		    (tp_event->class->perf_probe ||
> +		     tp_event->class->reg) &&
>  		    try_module_get(tp_event->mod)) {
>  			ret = perf_trace_event_init(tp_event, p_event);
>  			break;
> 
> 
> 
> 


