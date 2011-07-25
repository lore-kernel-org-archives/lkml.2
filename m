Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1GYScb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:32:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1GYSc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:32:29 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=wp_X8QvuP7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=f-csgJdLAAAA:8 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=mxIEEkRNw8LwrN2NXMoA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=CMowB-bsPn0A:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=wjELVD8ZSfORFmav:21 a=1g9maXXAAJDbkw4l:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Steven Rostedt <rostedt@goodmis.org>
To: stufever@gmail.com
Cc: linux-kernel@vger.kernel.org, Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 14:32:27 -0400
Message-ID: <1311618747.3526.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 17:40 +0800, stufever@gmail.com wrote:
> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> 
> It's harmless but annyoing.
>   kernel/trace/trace_printk.c: In function 'module_trace_bprintk_format_notify':
>   kernel/trace/trace_printk.c:52: warning: 'fmt' may be used uninitialized in this function

I prefer not to add this patch. Fix gcc. Actually some gcc's do not warn
on this, others do. Here's the code that confuses gcc:

		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
		if (tb_fmt)
			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
		if (tb_fmt && fmt) {
			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
			strcpy(fmt, *iter);
			tb_fmt->fmt = fmt;
			*iter = tb_fmt->fmt;


fmt will never be looked at if tb_fmt is NULL, and fmt is initialized if
tb_fmt is not NULL.

-- Steve

> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> 
> ---
>  kernel/trace/trace_printk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
> index 1f06468..1a5fff8 100644
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


