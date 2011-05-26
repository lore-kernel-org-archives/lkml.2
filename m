Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab1EZPtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:49:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18192 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1EZPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:49:32 -0400
Date: Thu, 26 May 2011 08:48:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        "Brown, Len" <lenb@kernel.org>
Subject: Re: [PATCH 2/3] introduce intel_rapl driver
Message-Id: <20110526084815.adee4fb1.randy.dunlap@oracle.com>
In-Reply-To: <1306398857.2207.157.camel@rui>
References: <1306398857.2207.157.camel@rui>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DDE7651.0157:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 16:34:17 +0800 Zhang Rui wrote:

> 
> Introduce Intel RAPL driver.
> 
> RAPL (running average power limit) is a new feature which provides mechanisms
> to enforce power consumption limit, on some new processors.
> 
> RAPL provides MSRs reporting the total amount of energy consumed
> by the package/core/uncore/dram.
> Further more, by using RAPL, OS can set a power bugdet in a certain time window,
> and let Hardware to throttle the processor P/T-state to meet this enery limitation.
> 
> Currently, we don't have the plan to support the RAPL power control,
> but we do want to export the package/core/uncore/dram power consumption
> information via perf tool first.

Hi,

What's an uncore?

> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/platform/x86/Kconfig      |    8 
>  drivers/platform/x86/Makefile     |    1 
>  drivers/platform/x86/intel_rapl.c |  368 ++++++++++++++++++++++++++++++++++++++
>  include/linux/perf_event.h        |    4 
>  4 files changed, 381 insertions(+)
> 
> Index: linux-2.6/drivers/platform/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/platform/x86/Kconfig
> +++ linux-2.6/drivers/platform/x86/Kconfig
> @@ -753,4 +753,12 @@ config SAMSUNG_LAPTOP
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called samsung-laptop.
>  
> +config INTEL_RAPL
> +	tristate "Intel RAPL Support"
> +	depends on X86
> +	default y
> +	---help---
> +	  RAPL, AKA, Running Average Power Limit provides mechanisms to enforce

	  RAPL (Running Average Power Limit) provides mechanisms to enforce

> +	  power consumption limit.
> +
>  endif # X86_PLATFORM_DEVICES

> Index: linux-2.6/drivers/platform/x86/intel_rapl.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/platform/x86/intel_rapl.c
> @@ -0,0 +1,368 @@

[snip]

> +/* show the energy status, in Jelous */

Is that Joules?  or what?

> +static int rapl_read_energy(struct rapl_domain *domain)
> +{
> +	u64 value;
> +	u32 msr = domain->msrs.status;
> +
> +	rdmsrl(msr, value);
> +	return rapl_unit_xlate(ENERGY_UNIT, value, 0);
> +}

[snip]

> +static int __init intel_rapl_init(void)
> +{
> +	enum rapl_domain_id id;
> +
> +	/*
> +	 * RAPL features are only supported on processors have a CPUID
> +	 * signature with DisplayFamily_DisplayModel of 06_2AH, 06_2DH
> +	 */
> +	if (boot_cpu_data.x86 != 0x06)
> +		return -ENODEV;
> +
> +	if (boot_cpu_data.x86_model == 0x2A)
> +		rapl_domains[RAPL_DOMAIN_PP1].valid = 1;
> +	else if (boot_cpu_data.x86_model == 0x2D)
> +		rapl_domains[RAPL_DOMAIN_DRAM].valid = 1;
> +	else
> +		return -ENODEV;
> +
> +	if (rapl_check_unit())
> +		return -ENODEV;
> +
> +	for(id = 0; id < RAPL_DOMAIN_MAX; id++)

space after "for"

> +		if (rapl_domains[id].valid)
> +			perf_pmu_register(&(rapl_domains[id].pmu), rapl_domains[id].pmu.name, PERF_TYPE_SOFTWARE);
> +	return 0;
> +}
> +
> +static void __exit intel_rapl_exit(void)
> +{
> +	enum rapl_domain_id id;
> +
> +	for(id = 0; id < RAPL_DOMAIN_MAX; id++)

ditto

> +		if (rapl_domains[id].valid)
> +			perf_pmu_unregister(&(rapl_domains[id].pmu));
> +}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
