Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1LTBhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:37:18 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:41947
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753327Ab1LTBhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:37:15 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275bhz2fh668h839h946h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EEFE68D.6040601@am.sony.com>
Date: Mon, 19 Dec 2011 17:36:13 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>
Subject: Re: [RFC PATCH v2 6/6] ARM: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW
 on pre-ARMv6 CPUs
References: <1324306673-4282-1-git-send-email-catalin.marinas@arm.com> <1324306673-4282-7-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1324306673-4282-7-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/11 06:57, Catalin Marinas wrote:
> This patch removes the __ARCH_WANT_INTERRUPTS_ON_CTXSW definition for
> ARMv5 and earlier processors. On such processors, the context switch
> requires a full cache flush. To avoid high interrupt latencies, this
> patch defers the mm switching to the post-lock switch hook if the
> interrupts are disabled.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Frank Rowand <frank.rowand@am.sony.com>
> ---
>  arch/arm/include/asm/mmu_context.h |   30 +++++++++++++++++++++++++-----
>  arch/arm/include/asm/system.h      |    9 ---------
>  2 files changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/include/asm/mmu_context.h b/arch/arm/include/asm/mmu_context.h
> index fd6eeba..4ac7809 100644
> --- a/arch/arm/include/asm/mmu_context.h
> +++ b/arch/arm/include/asm/mmu_context.h
> @@ -104,19 +104,39 @@ static inline void finish_arch_post_lock_switch(void)
>  
>  #else	/* !CONFIG_CPU_HAS_ASID */
>  
> +#ifdef CONFIG_MMU
> +
>  static inline void check_and_switch_context(struct mm_struct *mm,
>  					    struct task_struct *tsk)
>  {
> -#ifdef CONFIG_MMU
>  	if (unlikely(mm->context.kvm_seq != init_mm.context.kvm_seq))
>  		__check_kvm_seq(mm);
> -	cpu_switch_mm(mm->pgd, mm);
> -#endif
> +
> +	if (irqs_disabled())
> +		/*
> +		 * Defer the cpu_switch_mm() call and continue running with
> +		 * the old mm. Since we only support UP systems on non-ASID
> +		 * CPUs, the old mm will remain valid until the
> +		 * finish_arch_post_lock_switch() call.

It would be good to include in this comment the info from the patch header
that deferring the cpu_switch_mm() is to avoid high interrupt latencies.

I had applied all six patches so I could see what the end result looked
like, and reading the end result was asking myself why cpu_switch_mm() was
deferred for !CONFIG_CPU_HAS_ASID (since I was instead focusing on the
problem of calling __new_context() with IRQs disabled).  Then when I looked
at this patch in isolation, the patch header clearly answered the question for me.

> +		 */
> +		set_ti_thread_flag(task_thread_info(tsk), TIF_SWITCH_MM);
> +	else
> +		cpu_switch_mm(mm->pgd, mm);
>  }
>  
> -#define init_new_context(tsk,mm)	0
> +#define finish_arch_post_lock_switch \
> +	finish_arch_post_lock_switch
> +static inline void finish_arch_post_lock_switch(void)
> +{
> +	if (test_and_clear_thread_flag(TIF_SWITCH_MM)) {
> +		struct mm_struct *mm = current->mm;
> +		cpu_switch_mm(mm->pgd, mm);
> +	}
> +}
>  
> -#define finish_arch_post_lock_switch()	do { } while (0)
> +#endif	/* CONFIG_MMU */
> +
> +#define init_new_context(tsk,mm)	0
>  
>  #endif	/* CONFIG_CPU_HAS_ASID */
>  
> diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
> index 3daebde..ac7fade 100644
> --- a/arch/arm/include/asm/system.h
> +++ b/arch/arm/include/asm/system.h
> @@ -218,15 +218,6 @@ static inline void set_copro_access(unsigned int val)
>  }
>  
>  /*
> - * switch_mm() may do a full cache flush over the context switch,
> - * so enable interrupts over the context switch to avoid high
> - * latency.
> - */
> -#ifndef CONFIG_CPU_HAS_ASID
> -#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
> -#endif
> -
> -/*
>   * switch_to(prev, next) should switch from task `prev' to `next'
>   * `prev' will never be the same as `next'.  schedule() itself
>   * contains the memory barrier to tell GCC not to cache `current'.
> 
> 
> .
> 


