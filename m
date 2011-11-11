Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1KKSYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 13:24:12 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:37898 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1KKSYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 13:24:10 -0500
Date: Fri, 11 Nov 2011 13:23:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v3 1/7] x86/topology.c: Support functions for BSP
 online/offline
Message-ID: <20111111182328.GA8615@phenom.dumpdata.com>
References: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
 <1320885257-16647-2-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320885257-16647-2-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4EBD682D.0006,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 04:34:11PM -0800, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> By default, BSP can't be hotpluggable because bsp_hotpluggable is 0. Kernel
> parameter bsp_hotplug can enable BSP hotplug feature.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/topology.c |   24 +++++++++++++++++-------
>  1 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
> index 76ee977..a3fc939 100644
> --- a/arch/x86/kernel/topology.c
> +++ b/arch/x86/kernel/topology.c
> @@ -35,18 +35,28 @@
>  static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> +
> +static int bsp_hotpluggable;

__read_mostly

> +
> +static int __init enable_bsp_hotplug(char *str)
> +{
> +	bsp_hotpluggable = 1;
> +	return 1;
> +}
> +
> +__setup("bsp_hotplug", enable_bsp_hotplug);
> +
>  int __ref arch_register_cpu(int num)
>  {
>  	/*
> -	 * CPU0 cannot be offlined due to several
> -	 * restrictions and assumptions in kernel. This basically
> -	 * doesn't add a control file, one cannot attempt to offline
> -	 * BSP.
> +	 * Resume from suspend/hibernate depends on BSP. PIC interrupts depend
> +	 * on BSP.
>  	 *
> -	 * Also certain PCI quirks require not to enable hotplug control
> -	 * for all CPU's.
> +	 * If the BSP depencies are under control, one can tell kernel to
> +	 * enable BSP hotplug. This basically adds a control file and
> +	 * one can attempt to offline BSP.
>  	 */
> -	if (num)
> +	if (num || bsp_hotpluggable)
>  		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
>  
>  	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
> -- 
> 1.6.0.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
