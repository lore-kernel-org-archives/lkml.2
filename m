Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1E3Cm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:42:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:43738 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab1E3Cm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:42:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,290,1304319600"; 
   d="scan'208";a="3768233"
Subject: Re: [PATCH 2/3] introduce intel_rapl driver
From: Zhang Rui <rui.zhang@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "acme@redhat.com" <acme@redhat.com>,
        "Lin, Ming M" <ming.m.lin@intel.com>, "Brown, Len" <lenb@kernel.org>
In-Reply-To: <20110526084815.adee4fb1.randy.dunlap@oracle.com>
References: <1306398857.2207.157.camel@rui>
	 <20110526084815.adee4fb1.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 10:40:31 +0800
Message-ID: <1306723231.32738.36.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2011-05-26 at 23:48 +0800, Randy Dunlap wrote:
> On Thu, 26 May 2011 16:34:17 +0800 Zhang Rui wrote:
> 
> > 
> > Introduce Intel RAPL driver.
> > 
> > RAPL (running average power limit) is a new feature which provides mechanisms
> > to enforce power consumption limit, on some new processors.
> > 
> > RAPL provides MSRs reporting the total amount of energy consumed
> > by the package/core/uncore/dram.
> > Further more, by using RAPL, OS can set a power bugdet in a certain time window,
> > and let Hardware to throttle the processor P/T-state to meet this enery limitation.
> > 
> > Currently, we don't have the plan to support the RAPL power control,
> > but we do want to export the package/core/uncore/dram power consumption
> > information via perf tool first.
> 
> Hi,
> 
> What's an uncore?
> 
According to the Intel SDM, besides the Package and DRAM power domains,
RAPL defines another two power domains, AKA, PP0/PP1, PP0 refers to the
processor cores and PP1 refers to the power plane of a specific device
in the uncore.
Maybe "uncore" is kind of misleading, but using "PP0/PP1" doesn't mean
anything to users.

> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/platform/x86/Kconfig      |    8 
> >  drivers/platform/x86/Makefile     |    1 
> >  drivers/platform/x86/intel_rapl.c |  368 ++++++++++++++++++++++++++++++++++++++
> >  include/linux/perf_event.h        |    4 
> >  4 files changed, 381 insertions(+)
> > 
> > Index: linux-2.6/drivers/platform/x86/Kconfig
> > ===================================================================
> > --- linux-2.6.orig/drivers/platform/x86/Kconfig
> > +++ linux-2.6/drivers/platform/x86/Kconfig
> > @@ -753,4 +753,12 @@ config SAMSUNG_LAPTOP
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called samsung-laptop.
> >  
> > +config INTEL_RAPL
> > +	tristate "Intel RAPL Support"
> > +	depends on X86
> > +	default y
> > +	---help---
> > +	  RAPL, AKA, Running Average Power Limit provides mechanisms to enforce
> 
> 	  RAPL (Running Average Power Limit) provides mechanisms to enforce
> 
> > +	  power consumption limit.
> > +
> >  endif # X86_PLATFORM_DEVICES
> 
> > Index: linux-2.6/drivers/platform/x86/intel_rapl.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/drivers/platform/x86/intel_rapl.c
> > @@ -0,0 +1,368 @@
> 
> [snip]
> 
> > +/* show the energy status, in Jelous */
> 
> Is that Joules?  or what?
> 
Oh. right, it's Joules.

> > +static int rapl_read_energy(struct rapl_domain *domain)
> > +{
> > +	u64 value;
> > +	u32 msr = domain->msrs.status;
> > +
> > +	rdmsrl(msr, value);
> > +	return rapl_unit_xlate(ENERGY_UNIT, value, 0);
> > +}
> 
> [snip]
> 
> > +static int __init intel_rapl_init(void)
> > +{
> > +	enum rapl_domain_id id;
> > +
> > +	/*
> > +	 * RAPL features are only supported on processors have a CPUID
> > +	 * signature with DisplayFamily_DisplayModel of 06_2AH, 06_2DH
> > +	 */
> > +	if (boot_cpu_data.x86 != 0x06)
> > +		return -ENODEV;
> > +
> > +	if (boot_cpu_data.x86_model == 0x2A)
> > +		rapl_domains[RAPL_DOMAIN_PP1].valid = 1;
> > +	else if (boot_cpu_data.x86_model == 0x2D)
> > +		rapl_domains[RAPL_DOMAIN_DRAM].valid = 1;
> > +	else
> > +		return -ENODEV;
> > +
> > +	if (rapl_check_unit())
> > +		return -ENODEV;
> > +
> > +	for(id = 0; id < RAPL_DOMAIN_MAX; id++)
> 
> space after "for"
> 
> > +		if (rapl_domains[id].valid)
> > +			perf_pmu_register(&(rapl_domains[id].pmu), rapl_domains[id].pmu.name, PERF_TYPE_SOFTWARE);
> > +	return 0;
> > +}
> > +
> > +static void __exit intel_rapl_exit(void)
> > +{
> > +	enum rapl_domain_id id;
> > +
> > +	for(id = 0; id < RAPL_DOMAIN_MAX; id++)
> 
> ditto
> 
will fix them in the next version.

thanks,
rui

> > +		if (rapl_domains[id].valid)
> > +			perf_pmu_unregister(&(rapl_domains[id].pmu));
> > +}
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


