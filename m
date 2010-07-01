Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0GAJ0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:26:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51244 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0GAJ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:26:16 -0400
Message-ID: <4C2C5F44.7010006@cn.fujitsu.com>
Date: Thu, 01 Jul 2010 17:26:28 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing: shrink max latency ringbuffer if unnecessary
References: <20100630120419.391D.A69D9226@jp.fujitsu.com> <1277948436.25782.5.camel@gandalf.stny.rr.com> <20100701104554.DA2D.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100701104554.DA2D.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  kernel/trace/trace.c              |   39 ++++++++++++++++++++++++++++++------
>  kernel/trace/trace.h              |    1 +
>  kernel/trace/trace_irqsoff.c      |    3 ++
>  kernel/trace/trace_sched_wakeup.c |    2 +
>  4 files changed, 38 insertions(+), 7 deletions(-)
> 

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com


> -
> +	if (current_trace && current_trace->use_max_tr) {
> +		/*
> +		 * We don't free the ring buffer. instead, resize it because
> +		 * The max_tr ring buffer has some state (e.g. ring->clock) and
> +		 * we want preserve it.
> +		 */
> +		ring_buffer_resize(max_tr.buffer, 1);
> +		max_tr.entries = 1;
> +	}
>  	destroy_trace_option_files(topts);
>  
>  	current_trace = t;
>  
>  	topts = create_trace_option_files(current_trace);

I think we can skip the two resize when current_trace->use_max_tr==1 && t->use_max_tr==1

> +	if (current_trace->use_max_tr) {
> +		ret = ring_buffer_resize(max_tr.buffer, global_trace.entries);
> +		if (ret < 0)
> +			goto out;
> +		max_tr.entries = global_trace.entries;
> +	}
>  
>  	if (t->init) {
>  		ret = tracer_init(t, tr);

Does we need to shrink it when tracer_init() fails?
Although tracer_init() hardly fails, and there is no bad effect even we don't shrink it.
