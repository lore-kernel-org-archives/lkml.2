Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2KZSKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:10:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:57425 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2KZSKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:10:45 -0500
Message-ID: <50B3B092.90605@linutronix.de>
Date: Mon, 26 Nov 2012 19:10:26 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
CC: oleg@redhat.com, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc: Move the single step enable code to a generic
 path
References: <20121126110007.6545.43875.stgit@suzukikp.in.ibm.com> <20121126110448.6545.90588.stgit@suzukikp.in.ibm.com>
In-Reply-To: <20121126110448.6545.90588.stgit@suzukikp.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 12:05 PM, Suzuki K. Poulose wrote:
> diff --git a/arch/powerpc/include/asm/probes.h b/arch/powerpc/include/asm/probes.h
> index 5f1e15b..836e9b9 100644
> --- a/arch/powerpc/include/asm/probes.h
> +++ b/arch/powerpc/include/asm/probes.h
> @@ -38,5 +38,34 @@ typedef u32 ppc_opcode_t;
>   #define is_trap(instr)		(IS_TW(instr) || IS_TWI(instr))
>   #endif /* CONFIG_PPC64 */
>
> +#ifdef CONFIG_PPC_ADV_DEBUG_REGS
> +#define MSR_SINGLESTEP	(MSR_DE)
> +#else
> +#define MSR_SINGLESTEP	(MSR_SE)
> +#endif
> +
> +/* Enable single stepping for the current task */
> +static inline void enable_single_step(struct pt_regs *regs)
> +{
> +
> +	/*
> +	 * We turn off async exceptions to ensure that the single step will
> +	 * be for the instruction we have the kprobe on, if we dont its
it is

> +	 * possible we'd get the single step reported for an exception handler
> +	 * like Decrementer or External Interrupt
> +	 */

Hmmm. The TRM for E400 says

|5.11.1 e500 Exception Priorities
|The following is a prioritized listing of e500 exceptions:
|   4. Critical input
|   5. Debug interrupt
|   6. External input
|   22. Decrementer

The list has been cut down a little. That means the debug interrupt
comes before external interrupt and before the decrement fires.

And if single step is what wakes you up then DBSR[ICMP] is set. Am I
missing something or is this FSL only not not book-e

>   #endif /* __KERNEL__ */
>   #endif	/* _ASM_POWERPC_PROBES_H */

Sebastian
