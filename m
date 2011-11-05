Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab1KEVNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 17:13:55 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:36684 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1KEVNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 17:13:53 -0400
Message-ID: <4EB5A705.4030008@linux.vnet.ibm.com>
Date: Sun, 06 Nov 2011 02:43:41 +0530
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
x-cbid: 11110521-8878-0000-0000-0000001F37C0
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

Any reason why you return 0 here? Most code I have seen similar to this,
return 1. I understand that anything declared using early_param() would
generate a warning if it returns non-zero, but I am not exactly sure
about how it behaves with __setup(). Kindly give this some thought.

> +}
> +
> +__setup("bsp_hotplug", enable_bsp_hotplug);
> +

Thanks,
Srivatsa S. Bhat

