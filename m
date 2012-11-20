Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2KTBSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:18:22 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:57569 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2KTBSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:18:20 -0500
Message-ID: <50AADA51.7020101@ozlabs.ru>
Date: Tue, 20 Nov 2012 12:18:09 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: added DSCR support to ptrace
References: <1350281910-5238-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1350281910-5238-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 15/10/12 17:18, Alexey Kardashevskiy wrote:
> The DSCR (aka Data Stream Control Register) is supported on some
> server PowerPC chips and allow some control over the prefetch
> of data streams.
>
> The kernel already supports DSCR value per thread but there is also
> a need in a ability to change it from an external process for
> the specific pid.
>
> The patch adds new register index PT_DSCR (index=44) which can be
> set/get by:
>    ptrace(PTRACE_POKEUSER, traced_process, PT_DSCR << 3, dscr);
>    dscr = ptrace(PTRACE_PEEKUSER, traced_process, PT_DSCR << 3, NULL);
>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>   arch/powerpc/include/asm/ptrace.h |    3 ++-
>   arch/powerpc/kernel/ptrace.c      |   16 ++++++++++++++++
>   2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
> index 84cc784..946c556 100644
> --- a/arch/powerpc/include/asm/ptrace.h
> +++ b/arch/powerpc/include/asm/ptrace.h
> @@ -276,7 +276,8 @@ static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
>   #define PT_DAR	41
>   #define PT_DSISR 42
>   #define PT_RESULT 43
> -#define PT_REGS_COUNT 44
> +#define PT_DSCR 44
> +#define PT_REGS_COUNT 45
>
>   #define PT_FPR0	48	/* each FP reg occupies 2 slots in this space */
>
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 8d8e028..4798acf 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -179,6 +179,17 @@ static int set_user_msr(struct task_struct *task, unsigned long msr)
>   	return 0;
>   }
>
> +static unsigned long get_user_dscr(struct task_struct *task)
> +{
> +	return task->thread.dscr;
> +}
> +
> +static int set_user_dscr(struct task_struct *task, unsigned long dscr)
> +{
> +	task->thread.dscr = dscr;
> +	return 0;
> +}
> +
>   /*
>    * We prevent mucking around with the reserved area of trap
>    * which are used internally by the kernel.
> @@ -200,6 +211,9 @@ unsigned long ptrace_get_reg(struct task_struct *task, int regno)
>   	if (regno == PT_MSR)
>   		return get_user_msr(task);
>
> +	if (regno == PT_DSCR)
> +		return get_user_dscr(task);
> +
>   	if (regno < (sizeof(struct pt_regs) / sizeof(unsigned long)))
>   		return ((unsigned long *)task->thread.regs)[regno];
>
> @@ -218,6 +232,8 @@ int ptrace_put_reg(struct task_struct *task, int regno, unsigned long data)
>   		return set_user_msr(task, data);
>   	if (regno == PT_TRAP)
>   		return set_user_trap(task, data);
> +	if (regno == PT_DSCR)
> +		return set_user_dscr(task, data);
>
>   	if (regno <= PT_MAX_PUT_REG) {
>   		((unsigned long *)task->thread.regs)[regno] = data;
>


-- 
Alexey
