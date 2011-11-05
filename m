Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab1KELBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 07:01:44 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43481 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1KELBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 07:01:42 -0400
Message-ID: <4EB5178C.7010703@linux.vnet.ibm.com>
Date: Sat, 05 Nov 2011 16:31:32 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 7/9] x86/topology.c: Support functions for BSP online/offline
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com> <1320444241-834-8-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1320444241-834-8-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110501-5140-0000-0000-00000029FD72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2011 03:33 AM, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> By default, BSP can't be hotpluggable because bsp_hotpluggable is 0. Kernel
> parameter bsp_hotplug can enable BSP hotplug feature.
> 
> arch_cpu_maps_update_begin() and arch_cpu_maps_update_done() locks/unlocks
> pm_mutex. This solves cpu maps race condition between BSP online check during
> hibernate/suspend and BSP online/offline operations.
> 
> arch_state_check() checks if BSP is still the first online CPU.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/topology.c |   44 +++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 37 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
> index 8927486..287d7b6 100644
> --- a/arch/x86/kernel/topology.c
> +++ b/arch/x86/kernel/topology.c
> @@ -29,23 +29,53 @@
>  #include <linux/mmzone.h>
>  #include <linux/init.h>
>  #include <linux/smp.h>
> +#include <linux/suspend.h>
>  #include <asm/cpu.h>
> 
>  static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> +
> +static int bsp_hotpluggable;
> +
> +static int __init enable_bsp_hotplug(char *str)
> +{
> +	bsp_hotpluggable = 1;
> +	return 0;
> +}
> +
> +__setup("bsp_hotplug", enable_bsp_hotplug);
> +
> +void arch_cpu_maps_update_begin(void)
> +{
> +	lock_system_sleep();
> +}
> +
> +void arch_cpu_maps_update_done(void)
> +{
> +	unlock_system_sleep();
> +}
> +
> +int arch_state_check(void)
> +{
> +	if (cpumask_first(cpu_online_mask) != 0) {
> +		printk(KERN_WARNING "No CPU0.\n");

How about a better warning, perhaps like "CPU0 is offline"
or something like that?

> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
>  int __ref arch_register_cpu(int num)
>  {
>  	/*
> -	 * CPU0 cannot be offlined due to several
> -	 * restrictions and assumptions in kernel. This basically
> -	 * doesn't add a control file, one cannot attempt to offline
> -	 * BSP.
> +	 * Suspend/resume depends on BSP. PIC interrupts depend on BSP.
>  	 *
> -	 * Also certain PCI quirks require not to enable hotplug control
> -	 * for all CPU's.
> +	 * If the BSP depencies are under control, tell kernel to
> +	 * enable BSP hotplug. This basically adds a control file and
> +	 * one can attempt to offline BSP.
>  	 */
> -	if (num)
> +	if (num || bsp_hotpluggable)
>  		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
> 
>  	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);

Thanks,
Srivatsa S. Bhat

