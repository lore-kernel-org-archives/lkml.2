Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab0IGRJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:09:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab0IGRJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:09:01 -0400
Subject: Re: [RFC][PATCH 13/19] perf: Per cpu-context rotation timer
From: Peter Zijlstra <peterz@infradead.org>
To: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100907165011.939993481@chello.nl>
References: <20100907164633.879932949@chello.nl>
	 <20100907165011.939993481@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Sep 2010 19:08:51 +0200
Message-ID: <1283879331.1930.1633.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 18:46 +0200, Peter Zijlstra wrote:
> +static enum hrtimer_restart perf_event_context_tick(struct hrtimer
> *timer)
>  {
> +       enum hrtimer_restart restart = HRTIMER_NORESTART;
>         struct perf_cpu_context *cpuctx;
>         struct perf_event_context *ctx;
>         int rotate = 0;
>  
> +       cpuctx = container_of(timer, struct perf_cpu_context, timer);
>  
> +       if (cpuctx->ctx.nr_events) {
> +               restart = HRTIMER_RESTART;
> +               if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
> +                       rotate = 1;
> +       }
>  
> +       ctx = current->perf_event_ctxp;
> +       if (ctx && ctx->nr_events) {
> +               restart = HRTIMER_RESTART;
> +               if (ctx->nr_events != ctx->nr_active)
> +                       rotate = 1;
> +       } 

Note to self, this is probably racy against pmu_rotate_start().
