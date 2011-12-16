Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766Ab1LPU5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:57:32 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:3564 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752411Ab1LPU5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:57:24 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275bhz2fh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4EEBB07D.2070905@am.sony.com>
Date: Fri, 16 Dec 2011 12:56:29 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rowand, Frank" <Frank_Rowand@sonyusa.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH] PREEMPT_RT_FULL: ARM context switch needs IRQs enabled
References: <4EEAB90D.3050504@am.sony.com>
In-Reply-To: <4EEAB90D.3050504@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/11 19:20, Frank Rowand wrote:
> 
> ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
> (application specific ID). The number of ASIDs is limited to 256 and
> the allocation algorithm requires IPIs when all the ASIDs have been
> used.  The IPIs require interrupts enabled during context switch for
> deadlock avoidance.
> 
> The RT patch mm-protect-activate-switch-mm.patch disables irqs around
> activate_mm() and switch_mm(), which are the portion of the ARMv6
> context switch that require interrupts enabled.
> 
> The solution for the ARMv6 processors could be to _not_ disable irqs.
> A more conservative solution is to provide the same environment that
> the scheduler provides, that is preempt_disable().  This is more
> resilient for possible future changes to the ARM context switch code
> that is not aware of the RT patches.
> 
> This patch will conflict slightly with Catalin's patch set to remove
> __ARCH_WANT_INTERRUPTS_ON_CTXSW, when that is accepted:
> 
>    http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01893.html
> 
> When Catalin's patch set is accepted, this RT patch will need to reverse
> the change in patch 6 to arch/arm/include/asm/system.h:
> 
>    -#ifndef CONFIG_CPU_HAS_ASID
>    -#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
>    -#endif
> 
> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
> 
> ---
>  fs/exec.c        |    8 	8 +	0 -	0 !
>  mm/mmu_context.c |    8 	8 +	0 -	0 !
>  2 files changed, 16 insertions(+)
> 
> Index: b/fs/exec.c
> ===================================================================
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -837,12 +837,20 @@ static int exec_mmap(struct mm_struct *m
>  		}
>  	}
>  	task_lock(tsk);
> +#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW

Self critique...  I really, really dislike this ifdef because it will
fail silently if the includes are changed and as a result the include file that
defines __ARCH_WANT_INTERRUPTS_ON_CTXSW (arch/arm/include/asm/system.h) is not
included.

Does anyone have any brilliant ideas for an alternative approach?

-Frank

