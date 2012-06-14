Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2FNSmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:42:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2FNSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:42:09 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=S7kPoNjUNpsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8 a=p0KW7_TzbLtLuldPJIgA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=UTB_XpHje0EA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339699326.13377.243.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] perf script: format regression due to libtraceevent
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Date: Thu, 14 Jun 2012 14:42:06 -0400
In-Reply-To: <1339698977-68962-1-git-send-email-dsahern@gmail.com>
References: <1339698977-68962-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 12:36 -0600, David Ahern wrote:
> Consider the commands:
>     perf record -e sched:sched_switch -fo /tmp/perf.data  -a -- sleep 1
>     perf script -i /tmp/perf.data
> 
> In v3.4 the output has the form (lines wrapped here)
>     perf 29214 [005] 821043.582596: sched_switch:
> prev_comm=perf prev_pid=29214 prev_prio=120
> prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120
> 
> In 3.5 that same line has become:
>     perf 29214 [005] 821043.582596: sched_switch:
> <...>-29214 [005]     0.000000000: sched_switch:
> prev_comm=perf prev_pid=29214 prev_prio=120
> prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120
> 
> Note the duplicates in the output -- pid, cpu, event name. With
> this patch the v3.4 output is restored:
>     perf 29214 [005] 821043.582596: sched_switch:
> prev_comm=perf prev_pid=29214 prev_prio=120
> prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120
> 
> v3:
> Remove that pesky newline too. Output now matches v3.4 (pre-libtracevent).
> 
> v2:
> Change print_trace_event function local to perf per Steve's comments.
> 
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/trace-event-parse.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index df2fddb..5dd3b5e 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -198,9 +198,8 @@ void print_trace_event(int cpu, void *data, int size)
>  	record.data = data;
>  
>  	trace_seq_init(&s);
> -	pevent_print_event(pevent, &s, &record);
> +	pevent_event_info(&s, event, &record);
>  	trace_seq_do_printf(&s);
> -	printf("\n");
>  }
>  
>  void print_event(int cpu, void *data, int size, unsigned long long nsecs,


