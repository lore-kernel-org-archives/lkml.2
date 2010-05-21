Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0EUOEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:04:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0EUOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:04:08 -0400
X-Authority-Analysis: v=1.1 cv=ThiPuEJrAfM5PTlEgIT3cJp8+3pkHBIG3CaogqDGxqo= c=1 sm=0 a=GlzScWbaSrQA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=eny7JHEcgGa0sRBVpewA:9 a=0NCZbetE5_NMe95IMMgA:7 a=Ib8udGKMM4kRiix6dtjyZdmCcngA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
 track events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100521090710.473188012@chello.nl>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.473188012@chello.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 21 May 2010 10:04:03 -0400
Message-ID: <1274450643.26328.3749.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 11:02 +0200, Peter Zijlstra wrote:
> plain text document attachment (perf-trace-per-cpu-fold.patch)
> Avoid the swevent hash-table by using per-tracepoint hlists.
> 
> Also, avoid conditionals on the fast path by ordering with probe unregister
> so that we should never get on the callback path without the data being there.
> 

> -void perf_trace_disable(int event_id)
> +void perf_trace_destroy(struct perf_event *p_event)
>  {
> -	struct ftrace_event_call *event;
> +	struct ftrace_event_call *tp_event = p_event->tp_event;
> +	int i;
>  
> -	mutex_lock(&event_mutex);
> -	list_for_each_entry(event, &ftrace_events, list) {
> -		if (event->id == event_id) {
> -			perf_trace_event_disable(event);
> -			module_put(event->mod);
> -			break;
> +	if (--tp_event->perf_refcount > 0)
> +		return;
> +

You remove the event_mutex and then update the tp_event->perf_refcount
without any protection.

That tp_event->perf_refcount is global to the event not to the perf
event.

-- Steve

> +	tp_event->perf_event_disable(tp_event);
> +
> +	free_percpu(tp_event->perf_events);
> +	tp_event->perf_events = NULL;
> +
> +	if (!--total_ref_count) {
> +		for (i = 0; i < 4; i++) {
> +			free_percpu(perf_trace_buf[i]);
> +			perf_trace_buf[i] = NULL;
>  		}
>  	}
> -	mutex_unlock(&event_mutex);
>  }
>  


