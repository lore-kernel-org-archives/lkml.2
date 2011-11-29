Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1K2HYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:24:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:6294 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab1K2HYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:24:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,590,1315206000"; 
   d="scan'208";a="96397595"
Message-ID: <4ED488A3.2000508@linux.intel.com>
Date: Tue, 29 Nov 2011 15:24:19 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: hpa@zytor.com, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add IRQ context simulation in module mce-inject
References: <4ec2fc2492784d824@agluck-desktop.sc.intel.com>
In-Reply-To: <4ec2fc2492784d824@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/11/16 7:56, Luck, Tony 写道:
> mce-inject provides a mechanism to simulate errors so that test
> scripts can check for correct operation of the kernel without
> requiring any specialized hardware to create rare events.
>
> The existing code can simulate events in normal process context
> and also in NMI context - but not in IRQ context. This patch
> fills that gap.
>
> Signed-off-by: Chen Gong<gong.chen@linux.intel.com>
> Acked-by: Tony Luck<tony.luck@intel.com>
>
> ---
> [Re-wrote the commit comment - Chen Gong's original text is below,
>   in case I missed any critical aspect - Tony]
> module mce-inject is an interface which is used by user space app
> such as mce-inject. According to it one can inject all kinds of
> error combinations into the kernel. In this way, one can check
> error condition coverage in the kernel. To satisify this needs,
> module mce-inject must simulate enough scenarios such as process
> context, IRQ context, even NMI context, to ensure related kernel
> codes are strong and reliable. In current implementation, IRQ
> context hasn't been simulated. This patch is for this purpose.
>
>   arch/x86/include/asm/mce.h              |    9 ++++---
>   arch/x86/kernel/cpu/mcheck/mce-inject.c |   34 +++++++++++++++++++++++++++---
>   2 files changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index c9321f3..312d770 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -50,10 +50,11 @@
>   #define MCJ_CTX_MASK		3
>   #define MCJ_CTX(flags)		((flags)&  MCJ_CTX_MASK)
>   #define MCJ_CTX_RANDOM		0    /* inject context: random */
> -#define MCJ_CTX_PROCESS		1    /* inject context: process */
> -#define MCJ_CTX_IRQ		2    /* inject context: IRQ */
> -#define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
> -#define MCJ_EXCEPTION		8    /* raise as exception */
> +#define MCJ_CTX_PROCESS		0x1  /* inject context: process */
> +#define MCJ_CTX_IRQ		0x2  /* inject context: IRQ */
> +#define MCJ_NMI_BROADCAST	0x4  /* do NMI broadcasting */
> +#define MCJ_EXCEPTION		0x8  /* raise as exception */
> +#define MCJ_IRQ_BRAODCAST	0x10 /* do IRQ broadcasting */
>
>   /* Fields are zero when not available */
>   struct mce {
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> index 6199232..505461e 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> @@ -17,6 +17,7 @@
>   #include<linux/kernel.h>
>   #include<linux/string.h>
>   #include<linux/fs.h>
> +#include<linux/preempt.h>
>   #include<linux/smp.h>
>   #include<linux/notifier.h>
>   #include<linux/kdebug.h>
> @@ -92,6 +93,18 @@ static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
>   	return NMI_HANDLED;
>   }
>
> +static void mce_irq_ipi(void *info)
> +{
> +	int cpu = smp_processor_id();
> +	struct mce *m =&__get_cpu_var(injectm);
> +
> +	if (cpumask_test_cpu(cpu, mce_inject_cpumask)&&
> +			m->inject_flags&  MCJ_EXCEPTION) {
> +		cpumask_clear_cpu(cpu, mce_inject_cpumask);
> +		raise_exception(m, NULL);
> +	}
> +}
> +
>   /* Inject mce on current CPU */
>   static int raise_local(void)
>   {
> @@ -139,9 +152,10 @@ static void raise_mce(struct mce *m)
>   		return;
>
>   #ifdef CONFIG_X86_LOCAL_APIC
> -	if (m->inject_flags&  MCJ_NMI_BROADCAST) {
> +	if (m->inject_flags&  (MCJ_IRQ_BRAODCAST | MCJ_NMI_BROADCAST)) {
>   		unsigned long start;
>   		int cpu;
> +
>   		get_online_cpus();
>   		cpumask_copy(mce_inject_cpumask, cpu_online_mask);
>   		cpumask_clear_cpu(get_cpu(), mce_inject_cpumask);
> @@ -151,13 +165,25 @@ static void raise_mce(struct mce *m)
>   			    MCJ_CTX(mcpu->inject_flags) != MCJ_CTX_RANDOM)
>   				cpumask_clear_cpu(cpu, mce_inject_cpumask);
>   		}
> -		if (!cpumask_empty(mce_inject_cpumask))
> -			apic->send_IPI_mask(mce_inject_cpumask, NMI_VECTOR);
> +		if (!cpumask_empty(mce_inject_cpumask)) {
> +			if (m->inject_flags&  MCJ_IRQ_BRAODCAST) {
> +				/*
> +				 * don't wait because mce_irq_ipi is necessary
> +				 * to be sync with following raise_local
> +				 */
> +				preempt_disable();
> +				smp_call_function_many(mce_inject_cpumask,
> +					mce_irq_ipi, NULL, 0);
> +				preempt_enable();
> +			} else if (m->inject_flags&  MCJ_NMI_BROADCAST)
> +				apic->send_IPI_mask(mce_inject_cpumask,
> +						NMI_VECTOR);
> +		}
>   		start = jiffies;
>   		while (!cpumask_empty(mce_inject_cpumask)) {
>   			if (!time_before(jiffies, start + 2*HZ)) {
>   				printk(KERN_ERR
> -				"Timeout waiting for mce inject NMI %lx\n",
> +				"Timeout waiting for mce inject %lx\n",
>   					*cpumask_bits(mce_inject_cpumask));
>   				break;
>   			}

Hi, would you please help to merge this patch into -x86 tree? If you miss it.
Thx in advance!
