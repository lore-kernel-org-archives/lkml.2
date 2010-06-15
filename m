Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab0FOUwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:52:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab0FOUwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:52:37 -0400
X-Authority-Analysis: v=1.1 cv=w1shWbTWTAfAQ6jIUag4hBIbd8wqGnfzh/ne7nEp+Po= c=1 sm=0 a=JzHsGVqNTC4A:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=DfNHnWVPAAAA:8 a=lbOMpYSq-iLWNoPaIvoA:9 a=k6SBIJzDHDRpfZ5QrZQA:7 a=MFaw_K8LkwLcxCJKDRGNeIQX2ckA:4 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=lBRciGGoxdUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: use correct string size for snprintf
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Jiri Olsa <jolsa@redhat.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1276619355-18116-1-git-send-email-chase.douglas@canonical.com>
References: <1276619355-18116-1-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 15 Jun 2010 16:52:35 -0400
Message-ID: <1276635155.3556.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 12:29 -0400, Chase Douglas wrote:
> The nsecs_str string is a local variable defined as:
> 
> char nsecs_str[5];
> 
> It is possible for the snprintf call to use a size value larger than the
> size of the string. This should not cause a buffer overrun as it is
> written now due to the maximum size of the string format. However, this
> change makes it correct. By making the size correct we guard against
> potential future changes that could actually cause a buffer overrun.
> 
> Cc: stable@kernel.org

I see that because nsecs_str is based off of nsecs_rem which is the
remainder of a division of a 1000, that it wont ever be more than 4 in
length. For this, I'll remove the "Cc: stable" part and queue it for 36.
No urgent need for now.

But I still think it should be added, just because it looks to fragile
to have what is in the kernel now.

Thanks!

-- Steve

> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---
>  kernel/trace/trace_functions_graph.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 79f4bac..73d6bd1 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -641,7 +641,8 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
>  
>  	/* Print nsecs (we don't want to exceed 7 numbers) */
>  	if (len < 7) {
> -		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
> +		snprintf(nsecs_str, min(sizeof(nsecs_str), 8 - len), "%03lu",
> +			 nsecs_rem);
>  		ret = trace_seq_printf(s, ".%s", nsecs_str);
>  		if (!ret)
>  			return TRACE_TYPE_PARTIAL_LINE;


