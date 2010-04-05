Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab0DEO03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:26:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38319 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab0DEO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:26:24 -0400
Message-ID: <4BB9F309.8070807@monstr.eu>
Date: Mon, 05 Apr 2010 16:26:17 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Fix ftrace_update_ftrace_func panic
References: <1270232979-12113-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1270232979-12113-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> The Microblaze dynamic ftrace code assumes a call ordering that is not met
> in all scenarios. Specifically, executing a command similar to:
> 
>   echo 105 > /sys/kernel/debug/tracing/set_ftrace_pid
> 
> before any other tracing-related commands results in a kernel panic:
> 
>   BUG: failure at arch/microblaze/kernel/ftrace.c:198/ftrace_update_ftrace_func()!
> 
> Recoding ftrace_update_ftrace_func() to use &ftrace_caller directly eliminates 
> the need to capture its address elsewhere (and thus rely on a particular call 
> sequence).

I would like to replicate this problem to see that there is. I am not 
able to reach this fault
Please copy & paste log with your commands.

Thanks,
Michal


> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
> --- a/arch/microblaze/kernel/ftrace.c	2010-04-02 13:10:54.000000000 -0500
> +++ b/arch/microblaze/kernel/ftrace.c	2010-04-02 13:13:29.000000000 -0500
> @@ -151,13 +151,10 @@ int ftrace_make_nop(struct module *mod,
>  	return ret;
>  }
>  
> -static int ret_addr; /* initialized as 0 by default */
> -
>  /* I believe that first is called ftrace_make_nop before this function */
>  int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
>  {
>  	int ret;
> -	ret_addr = addr; /* saving where the barrier jump is */
>  	pr_debug("%s: addr:0x%x, rec->ip: 0x%x, imm:0x%x\n",
>  		__func__, (unsigned int)addr, (unsigned int)rec->ip, imm);
>  	ret = ftrace_modify_code(rec->ip, imm);
> @@ -194,12 +191,9 @@ int ftrace_update_ftrace_func(ftrace_fun
>  	ret = ftrace_modify_code(ip, upper);
>  	ret += ftrace_modify_code(ip + 4, lower);
>  
> -	/* We just need to remove the rtsd r15, 8 by NOP */
> -	BUG_ON(!ret_addr);
> -	if (ret_addr)
> -		ret += ftrace_modify_code(ret_addr, MICROBLAZE_NOP);
> -	else
> -		ret = 1; /* fault */
> +	/* We just need to replace the rtsd r15, 8 with NOP */
> +	ret += ftrace_modify_code((unsigned long)&ftrace_caller,
> +				  MICROBLAZE_NOP);
>  
>  	/* All changes are done - lets do caches consistent */
>  	flush_icache();
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
