Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab2CWTgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:36:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8523 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2CWTgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:36:41 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wBLf1-ka6lYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=jQoND8bKIZ5rnDiqy54A:9 a=NkYwO1ZN8uvHiay6MRIA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332531400.23924.71.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
From: Steven Rostedt <rostedt@goodmis.org>
To: Rajesh Bhagat <rajesh.lnx@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Mar 2012 15:36:40 -0400
In-Reply-To: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
References: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 11:22 +0530, Rajesh Bhagat wrote:
> >From 60ec8a88ba671fa0b424f7b4467dba3ea8a2a2c8 Mon Sep 17 00:00:00 2001
> From: Rajesh Bhagat <rajesh.lnx@gmail.com>
> Date: Tue, 20 Mar 2012 10:35:59 +0530
> Subject: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
> 
> This patch resets the trace_array using tracing_reset_online_cpus, if same
> tracer is set again instead of just returning from funtion tracing_set_tracer.
> 
> problem description
> -------------------
> once function tracer is set, set_ftrace_filter not working.
> /debug/tracing # echo function > current_tracer
> /debug/tracing # echo schedule > set_ftrace_filter
> /debug/tracing # echo function > current_tracer

Sorry no. The correct way you want to do this is:

/debug/tracing # echo > trace

That will reset the buffer for you and give you the desired result.

-- Steve



> /debug/tracing #  cat trace
> # tracer: function
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>           <idle>-0     [000]    21.997778: irq_enter <-handle_IRQ
>           <idle>-0     [000]    21.997785: idle_cpu <-irq_enter
>           <idle>-0     [000]    21.997794: local_bh_disable <-irq_enter
>           <idle>-0     [000]    21.997800: tick_check_idle <-irq_enter
>           <idle>-0     [000]    21.997807:
> tick_check_oneshot_broadcast <-tick_check_idle
>           <idle>-0     [000]    21.997814: _local_bh_enable <-irq_enter
> 
> After applying this patch, only filtered functions are traced.
> 
> Signed-off-by: Rajesh Bhagat <rajesh.lnx@gmail.com>
> ---
>  kernel/trace/trace.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a3f1bc5..f4fb190 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3058,8 +3058,10 @@ static int tracing_set_tracer(const char *buf)
>         ret = -EINVAL;
>         goto out;
>     }
> -   if (t == current_trace)
> +   if (t == current_trace) {
> +       tracing_reset_online_cpus(tr);
>         goto out;
> +   }
> 
>     trace_branch_disable();
>     if (current_trace && current_trace->reset)


