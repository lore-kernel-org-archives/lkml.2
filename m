Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab2LKFs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 00:48:56 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35012 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2LKFsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 00:48:54 -0500
Message-ID: <50C6C930.90206@in.ibm.com>
Date: Tue, 11 Dec 2012 11:18:32 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: benh@kernel.crashing.org, Kumar Gala <galak@kernel.crashing.org>
CC: "Suzuki K. Poulose" <suzuki@in.ibm.com>, bigeasy@linutronix.de,
        oleg@redhat.com, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, anton@redhat.com, mingo@elte.hu
Subject: Re: [PATCH v2 1/4] kprobes/powerpc: Do not disable External interrupts
 during single step
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150720.7727.91582.stgit@suzukikp>
In-Reply-To: <20121203150720.7727.91582.stgit@suzukikp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121105-5490-0000-0000-000002A0F7A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 08:37 PM, Suzuki K. Poulose wrote:
> From: Suzuki K. Poulose <suzuki@in.ibm.com>
>
> External/Decrement exceptions have lower priority than the Debug Exception.
> So, we don't have to disable the External interrupts before a single step.
> However, on BookE, Critical Input Exception(CE) has higher priority than a
> Debug Exception. Hence we mask them.
>
> Signed-off-by: 	Suzuki K. Poulose <suzuki@in.ibm.com>
> Cc:		Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc:		Ananth N Mavinakaynahalli <ananth@in.ibm.com>
> Cc:		Kumar Gala <galak@kernel.crashing.org>
> Cc:		linuxppc-dev@ozlabs.org
> ---
>   arch/powerpc/kernel/kprobes.c |   10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
> index e88c643..4901b34 100644
> --- a/arch/powerpc/kernel/kprobes.c
> +++ b/arch/powerpc/kernel/kprobes.c
> @@ -104,13 +104,13 @@ void __kprobes arch_remove_kprobe(struct kprobe *p)
>
>   static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
>   {
> -	/* We turn off async exceptions to ensure that the single step will
> -	 * be for the instruction we have the kprobe on, if we dont its
> -	 * possible we'd get the single step reported for an exception handler
> -	 * like Decrementer or External Interrupt */
> -	regs->msr &= ~MSR_EE;
>   	regs->msr |= MSR_SINGLESTEP;
>   #ifdef CONFIG_PPC_ADV_DEBUG_REGS
> +	/*
> +	 * We turn off Critical Input Exception(CE) to ensure that the single
> +	 * step will be for the instruction we have the probe on; if we don't,
> +	 * it is possible we'd get the single step reported for CE.
> +	 */
>   	regs->msr &= ~MSR_CE;
>   	mtspr(SPRN_DBCR0, mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM);
>   #ifdef CONFIG_PPC_47x
>

Ben, Kumar,

Could you please review this patch ?


Thanks
Suzuki

