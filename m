Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1IWOXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:23:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41405 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1IWOXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:23:17 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=Ywaum0S5s4cA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=V3-2FqCaaBK9AZDFpw0A:9 a=6b_CGfRNH-esSdOCBMMA:7 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH 1/2] tracing: Kill uninitialized warning in
 trace_printk.c
From: Steven Rostedt <rostedt@goodmis.org>
To: penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1316787547-1971-1-git-send-email-penberg@cs.helsinki.fi>
References: <1316787547-1971-1-git-send-email-penberg@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 10:23:14 -0400
Message-ID: <1316787794.29966.190.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 17:19 +0300, penberg@cs.helsinki.fi wrote:
> From: Pekka Enberg <penberg@kernel.org>
> 
> This patch kill the following bogus warning issued by GCC by shuffling the code
> around:
> 
>     CC      fs/ext4/balloc.o
>   kernel/trace/trace_printk.c: In function ‘module_trace_bprintk_format_notify’:
>   kernel/trace/trace_printk.c:65:14: warning: ‘fmt’ may be used uninitialized in this function [-Wuninitialized]
>   kernel/trace/trace_printk.c:52:8: note: ‘fmt’ was declared here
> 

NAK, I have a fix I just posted yesterday ;)

https://lkml.org/lkml/2011/9/22/402

-- Steve

> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> ---
>  kernel/trace/trace_printk.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
> index 1f06468..25e34f5 100644
> --- a/kernel/trace/trace_printk.c
> +++ b/kernel/trace/trace_printk.c
> @@ -49,7 +49,7 @@ static
>  void hold_module_trace_bprintk_format(const char **start, const char **end)
>  {
>  	const char **iter;
> -	char *fmt;
> +	char *fmt = NULL;
>  
>  	mutex_lock(&btrace_mutex);
>  	for (iter = start; iter < end; iter++) {
> @@ -62,7 +62,7 @@ void hold_module_trace_bprintk_format(const char **start, const char **end)
>  		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
>  		if (tb_fmt)
>  			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
> -		if (tb_fmt && fmt) {
> +		if (fmt) {
>  			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
>  			strcpy(fmt, *iter);
>  			tb_fmt->fmt = fmt;


