Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1K1TSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:18:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41687 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1K1TSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:18:51 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Bwl9-wDNmxcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=q-z1TKzq93ajGum7SawA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 3/9] ftrace: Fix shutdown to disable calls properly
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
In-Reply-To: <1322417074-5834-4-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 14:18:48 -0500
Message-ID: <1322507928.17003.7.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-27 at 19:04 +0100, Jiri Olsa wrote:
> Each ftrace_startup call increases the call record's flag,
> so we need allways to decrease it when shutting down the
> ftrace_ops.

No, that's not how this works. I probably should comment this code
better, because it caused me to reread it too ;)

> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/ftrace.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index c6d0293..0ca0c0d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1744,8 +1744,7 @@ static void ftrace_shutdown(struct ftrace_ops *ops, int command)
>  	if (ops != &global_ops || !global_start_up)
>  		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
>  
> -	if (!ftrace_start_up)
> -		command |= FTRACE_DISABLE_CALLS;
> +	command |= FTRACE_DISABLE_CALLS;

FTRACE_DISABLE_CALLS will disable *all* functions for all tracers. If
you are tracing with ftrace and perf, and one calls this with
FTRACE_DISABLE_CALLS then both will no long be tracing anything.

When you call unregister_ftrace_function() it will disable the functions
that you have enabled by the ops.

Nacked-by: Steven Rostedt <rostedt@goodmis.org.

-- Steve


>  
>  	if (saved_ftrace_func != ftrace_trace_function) {
>  		saved_ftrace_func = ftrace_trace_function;


