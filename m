Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab2GXTmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:42:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51260 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab2GXTma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:42:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6781"; a="211717581"
Message-ID: <500EFAA4.40600@codeaurora.org>
Date: Tue, 24 Jul 2012 15:42:28 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [08/36] AArch64: Kernel booting and initialisation
References: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 01/-10/-28163 02:59 PM, Catalin Marinas wrote:
> The patch adds the kernel booting and the initial setup code.
> Documentation/aarch64/booting.txt describes the booting protocol on the
> AArch64 Linux kernel. This is subject to change following the work on
> boot standardisation, ACPI.

[...]

> diff --git a/Documentation/aarch64/booting.txt b/Documentation/aarch64/booting.txt
> new file mode 100644
> index 0000000..5268280
> --- /dev/null
> +++ b/Documentation/aarch64/booting.txt
> @@ -0,0 +1,139 @@

[...]

> +- Architected timers
> +  CNTFRQ must be programmed with the timer frequency.
> +  If entering the kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0)
> +  set where available.

After Marc Zyngier's virtual timer patches come in, will the latter
requirement only be strictly necessary for kernels wanting to do
virtualization?

[...]

> diff --git a/arch/aarch64/kernel/setup.c b/arch/aarch64/kernel/setup.c
> new file mode 100644
> index 0000000..9da03d5
> --- /dev/null
> +++ b/arch/aarch64/kernel/setup.c

[...]

> +static void __init setup_processor(void)
> +{
> +	struct proc_info_list *list;
> +
> +	/*
> +	 * locate processor in the list of supported processor
> +	 * types.  The linker builds this table for us from the
> +	 * entries in arch/arm/mm/proc-*.S
> +	 */

It looks like there's only arch/arm64/mm/proc.S at the moment.

> +	list = lookup_processor_type(read_cpuid_id());
> +	if (!list) {
> +		printk("CPU configuration botched (ID %08x), unable to continue.\n",
> +		       read_cpuid_id());
> +		while (1);
> +	}
> +
> +	cpu_name = list->cpu_name;
> +
> +	printk("CPU: %s [%08x] revision %d\n",
> +	       cpu_name, read_cpuid_id(), read_cpuid_id() & 15);
> +
> +	sprintf(init_utsname()->machine, "aarch64");
> +	elf_hwcap = 0;
> +
> +	cpu_proc_init();
> +}
> +
> +/*
> + * cpu_init - initialise one CPU.
> + *
> + * cpu_init sets up the per-CPU stacks.
> + */
> +void cpu_init(void)
> +{
> +}

It looks like the comment above is a holdover from the 32-bit code and
no longer applies. Perhaps you could replace it with a comment on where
stack pointer initialization is actually handled. Searching briefly, it
looks like it's done in __mmap_switched and __secondary_switched.

[...]

> +
> +/*
> + * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
> + * is_kdump_kernel() to determine if we are booting after a panic. Hence
> + * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
> + */

This comment doesn't seem relevant to the current version of the code.

[...]

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
