Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1HZAJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:09:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38083 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1HZAJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:09:02 -0400
Date: Thu, 25 Aug 2011 20:08:56 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Laura Abbott <lauraa@codeaurora.org>
cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] process: change from __backtrace to dump_stack in
 show_regs
In-Reply-To: <1314316057-8282-1-git-send-email-lauraa@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1108252007361.20358@xanadu.home>
References: <1314316057-8282-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, Laura Abbott wrote:

> Currently, show_regs calls __backtrace which does
> nothing if CONFIG_FRAME_POINTER is not set. Switch to
> dump_stack which handles both CONFIG_FRAME_POINTER and
> CONFIG_ARM_UNWIND correctly.
> 
> __backtrace is now superseded by dump_stack in general
> and show_regs was the last caller so remove __backtrace
> as well.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>


> ---
>  arch/arm/include/asm/system.h |    1 -
>  arch/arm/kernel/armksyms.c    |    3 ---
>  arch/arm/kernel/process.c     |    2 +-
>  arch/arm/lib/backtrace.S      |    6 ------
>  4 files changed, 1 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
> index 832888d..4fc2edd 100644
> --- a/arch/arm/include/asm/system.h
> +++ b/arch/arm/include/asm/system.h
> @@ -97,7 +97,6 @@ void hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int,
>  #define xchg(ptr,x) \
>  	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
>  
> -extern asmlinkage void __backtrace(void);
>  extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
>  
>  struct mm_struct;
> diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
> index aeef960..8e3c6f1 100644
> --- a/arch/arm/kernel/armksyms.c
> +++ b/arch/arm/kernel/armksyms.c
> @@ -49,9 +49,6 @@ extern void __aeabi_ulcmp(void);
>  
>  extern void fpundefinstr(void);
>  
> -
> -EXPORT_SYMBOL(__backtrace);
> -
>  	/* platform dependent support */
>  EXPORT_SYMBOL(__udelay);
>  EXPORT_SYMBOL(__const_udelay);
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 1a347f4..fd08140 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -319,7 +319,7 @@ void show_regs(struct pt_regs * regs)
>  	printk("\n");
>  	printk("Pid: %d, comm: %20s\n", task_pid_nr(current), current->comm);
>  	__show_regs(regs);
> -	__backtrace();
> +	dump_stack();
>  }
>  
>  ATOMIC_NOTIFIER_HEAD(thread_notify_head);
> diff --git a/arch/arm/lib/backtrace.S b/arch/arm/lib/backtrace.S
> index a673297..cd07b58 100644
> --- a/arch/arm/lib/backtrace.S
> +++ b/arch/arm/lib/backtrace.S
> @@ -22,15 +22,10 @@
>  #define mask	r7
>  #define offset	r8
>  
> -ENTRY(__backtrace)
> -		mov	r1, #0x10
> -		mov	r0, fp
> -
>  ENTRY(c_backtrace)
>  
>  #if !defined(CONFIG_FRAME_POINTER) || !defined(CONFIG_PRINTK)
>  		mov	pc, lr
> -ENDPROC(__backtrace)
>  ENDPROC(c_backtrace)
>  #else
>  		stmfd	sp!, {r4 - r8, lr}	@ Save an extra register so we have a location...
> @@ -107,7 +102,6 @@ for_each_frame:	tst	frame, mask		@ Check for address exceptions
>  		mov	r1, frame
>  		bl	printk
>  no_frame:	ldmfd	sp!, {r4 - r8, pc}
> -ENDPROC(__backtrace)
>  ENDPROC(c_backtrace)
>  		
>  		.pushsection __ex_table,"a"
> -- 
> 1.7.3.3
> 
