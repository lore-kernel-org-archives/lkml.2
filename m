Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab0I0IiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:38:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab0I0IiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:07 -0400
Message-ID: <4CA057EA.7000609@redhat.com>
Date: Mon, 27 Sep 2010 10:38:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: x86@kernel.org
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
References: <1284913699-14986-1-git-send-email-avi@redhat.com>
In-Reply-To: <1284913699-14986-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/19/2010 06:28 PM, Avi Kivity wrote:
> On machines without monitor/mwait we use an sti; hlt sequence to atomically
> enable interrupts and put the cpu to sleep.  The sequence uses the "interrupt
> shadow" property of the sti instruction: interrupts are enabled only after
> the instruction following sti has been executed.  This means an interrupt
> cannot happen in the middle of the sequence, which would leave us with
> the interrupt processed but the cpu halted.
>
> The interrupt shadow, however, can be broken by an nmi; the following
> sequence
>
>     sti
>       nmi ... iret
>       # interrupt shadow disabled
>       intr ... iret
>     hlt
>
> puts the cpu to sleep, even though the interrupt may need additional processing
> after the hlt (like scheduling a task).
>
> sti is explicitly documented not to force an interrupt shadow; though many
> processors do inhibit nmi immediately after sti.
>
> Avoid the race by checking, during an nmi, if we hit the safe halt sequence.
> If we did, increment the instruction pointer past the hlt instruction; this
> allows an immediately following interrupt to return to a safe place.
>
> Signed-off-by: Avi Kivity<avi@redhat.com>

Ping.

> ---
>   arch/x86/include/asm/irqflags.h |   18 +++++++++++++++++-
>   arch/x86/kernel/traps.c         |   14 ++++++++++++++
>   2 files changed, 31 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
> index 9e2b952..f412167 100644
> --- a/arch/x86/include/asm/irqflags.h
> +++ b/arch/x86/include/asm/irqflags.h
> @@ -44,9 +44,25 @@ static inline void native_irq_enable(void)
>   	asm volatile("sti": : :"memory");
>   }
>
> +extern void safe_halt_addr(void);
> +
>   static inline void native_safe_halt(void)
>   {
> -	asm volatile("sti; hlt": : :"memory");
> +	asm volatile("sti \n\t"
> +		     /*
> +		      * If NMI hits us here, it negates the interrupt shadow
> +		      * induced by STI.  So the NMI handler checks for
> +		      * safe_halt_addr and skips the hlt if it loses the
> +		      * interrupt shadow.
> +		      *
> +		      * If native_safe_halt() is ever instantiated more
> +		      * than once, this will fail to build, and we'll need
> +		      * a list of addresses in a special section.
> +		      */
> +		     ".globl safe_halt_addr \n\t"
> +		     "safe_halt_addr: \n\t"
> +		     "hlt"
> +		     : : :"memory");
>   }
>
>   static inline void native_halt(void)
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 60788de..f67da48 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -438,6 +438,20 @@ do_nmi(struct pt_regs *regs, long error_code)
>
>   	inc_irq_stat(__nmi_count);
>
> +	/*
> +	 * We hit in the middle of an sti; hlt instruction.  When we return,
> +	 * the interrupt shadow cast by sti will no longer be in effect; then,
> +	 * if an interrupt causes a wakeup, we won't notice it since the hlt
> +	 * will take effect and block the cpu.
> +	 *
> +	 * If we detect this situation, fix it by advancing the instruction
> +	 * pointer past the hlt instruction; if the interrupt doesn't happen,
> +	 * we'll spend a few cycles falling asleep again, but that's better
> +	 * than a missed wakeup.
> +	 */
> +	if (regs->cs == __KERNEL_CS&&  regs->ip == (ulong)safe_halt_addr)
> +		++regs->ip;
> +
>   	if (!ignore_nmis)
>   		default_do_nmi(regs);
>


-- 
error compiling committee.c: too many arguments to function

