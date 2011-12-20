Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1LTSQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:16:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64596 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1LTSQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:16:38 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=-kHMGH7muIIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=FOH2dFAWAAAA:8 a=meVymXHHAAAA:8 a=7d_E57ReAAAA:8 a=JfrnYn6hAAAA:8 a=6rqHouBjAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=msOK4M5rsb9eDSluDLEA:9 a=PUjeQqilurYA:10 a=npO87R0EFmwA:10 a=jeBq3FmKZ4MA:10 a=D6-X0JM3zdQA:10 a=3Rfx1nUSh_UA:10 a=TAmEwCHjoHMA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324404995.5916.66.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/2] tracing, sched: Add a new tracepoint for sleeptime
From: Steven Rostedt <rostedt@goodmis.org>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Dec 2011 13:16:35 -0500
In-Reply-To: <1324404558-353-3-git-send-email-asharma@fb.com>
References: <1324404558-353-1-git-send-email-asharma@fb.com>
	 <1324404558-353-3-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 10:09 -0800, Arun Sharma wrote:
> If CONFIG_SCHEDSTATS is defined, the kernel maintains
> information about how long the task was sleeping or
> in the case of iowait, blocking in the kernel before
> getting woken up.
> 
> Note: this information is only provided for sched_fair.
> Other scheduling classes may choose to provide this in
> the future.
> 
> Note: the delay includes the time spent on the runqueue
> as well.
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/trace/events/sched.h |   48 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/core.c          |    1 +
>  2 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 959ff18..5189220 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -363,6 +363,54 @@ TRACE_EVENT(sched_stat_runtime,
>  			(unsigned long long)__entry->vruntime)
>  );
>  
> +#ifdef CREATE_TRACE_POINTS

Why the #ifdef? a static inline is fine to keep in the open. If nothing
uses it, then it just wont be used or defined.

-- Steve

> +static inline u64 trace_get_sleeptime(struct task_struct *tsk) 
> +{
> +#ifdef CONFIG_SCHEDSTATS
> +	u64 block, sleep;
> +
> +	block = tsk->se.statistics.block_start;
> +	sleep = tsk->se.statistics.sleep_start;
> +
> +	return block ? block : sleep ? sleep : 0;
> +#else
> +	return 0;
> +#endif
> +}
> +#endif
> +
> +

