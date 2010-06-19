Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0FSDYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 23:24:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39586 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0FSDYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 23:24:50 -0400
X-Authority-Analysis: v=1.1 cv=CgZcVGhTQjO/Ps/WuM8OsaKfzS+Ps8TRNnlzkE3q20U= c=1 sm=0 a=aUrcRhM0H-cA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=NSoQ8D5cw0FRVz2B-Z4A:9 a=1eMW7bsRqe01f6b4qIgA:7 a=bVe1KGBDNZQUu9WScBfuBFUDGtsA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 06/13] jump label v9: move ftrace_dyn_arch_init to
 common code
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org,
       Abhishek Sagar <sagar.abhishek@gmail.com>
In-Reply-To: <f634fd6470edf471c88923b1af7cdc7f41b67723.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
	 <f634fd6470edf471c88923b1af7cdc7f41b67723.1276116186.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 18 Jun 2010 23:24:38 -0400
Message-ID: <1276917879.27873.18.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> Move Steve's code for finding the best 5-byte no-op from ftrace.c to alternative.c.
> The idea is that other consumers (in this case jump label) want to make use of
> that code. I've created a global: 'char ideal_nop[5]', that is setup during
> setup_arch that can be used.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 0d88ce9..1a1cc47 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2749,20 +2749,9 @@ extern unsigned long __stop_mcount_loc[];
>  
>  void __init ftrace_init(void)
>  {
> -	unsigned long count, addr, flags;
> +	unsigned long count;
>  	int ret;
>  
> -	/* Keep the ftrace pointer to the stub */
> -	addr = (unsigned long)ftrace_stub;
> -
> -	local_irq_save(flags);
> -	ftrace_dyn_arch_init(&addr);
> -	local_irq_restore(flags);
> -
> -	/* ftrace_dyn_arch_init places the return code in addr */
> -	if (addr)
> -		goto failed;
> -
>  	count = __stop_mcount_loc - __start_mcount_loc;
>  
>  	ret = ftrace_dyn_table_alloc(count);

Um, you just removed the ftrace arch specific setup call for dynamic
ftrace. Although, I'm thinking this may not be needed since all archs
currently have just a stub. With the exception of ARM which seems to
call a "ftrace_mcount_set()" that git grep can not find.

Thus, if you remove this, then remove it from all archs.

-- Steve


