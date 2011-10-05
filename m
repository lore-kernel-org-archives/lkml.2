Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872Ab1JETVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:21:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:34374 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab1JETVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:21:02 -0400
Date: Wed, 5 Oct 2011 21:20:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] x86, topology.c: Enable CPU0 online/offline
In-Reply-To: <1317832759-10223-7-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.LFD.2.02.1110052113370.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-7-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Fenghua Yu wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Enable CPU0 online/offline by setting up its sysfs control file. By default,
> this feature is disabled. You can enabled it by bsp_hotplug kernel option.
> 
> Resume from hibernate, standby, or suspend needs CPU0 online. According to
> arch/x86/kernel/topology.c, some PCI quirks(??) need CPU0 online as well. Anyone
> knows which PCI quirks depends on CPU0 online?
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  Documentation/kernel-parameters.txt |    7 +++++++
>  arch/x86/kernel/topology.c          |   22 +++++++++++++++-------
>  2 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 854ed5c..bf011ee 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1805,6 +1805,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
>  
> +	bsp_hotplug	[X86] BSP (aka CPU0) is hotpluggable.
> +			Suspend/resume depends on BSP. It's said some PCI
> +			quirks depend on BSP too. But not sure which quirks.

Right, not sure what breaks. Go ahead and watch your machine explode.

> +			If don't care the dependencies, you can turn on
> +			bsp_ hotplug. Suspend will fail if BSP is offlined and
> +			you need to online BSP before suspend/resume.

And you forgot poweroff and reboot, which have similar dependencies on
some machines. That whole low level ACPI stuff is sensitive.

> +
>  	nptcg=		[IA-64] Override max number of concurrent global TLB
>  			purges which is reported from either PAL_VM_SUMMARY or
>  			SAL PALO.
> diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
> index 8927486..ed2da5c 100644
> --- a/arch/x86/kernel/topology.c
> +++ b/arch/x86/kernel/topology.c
> @@ -34,18 +34,26 @@
>  static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> +
> +static int __init enable_bsp_hotplug(char *str)
> +{
> +	bsp_hotpluggable = 1;

And that variable is defined where? I know where in the following
patch, so it's clear that series was neither compiled step per step
nor booted.

> +	 * Suspend/resume depends on BSP. Certain PCI quirks (which PCI
> +	 * quirks??) require not to enable hotplug control for all CPU's.

Again, you dammit better make shure which quirks break when cpu0 is
offlined.

Thanks,

	tglx
