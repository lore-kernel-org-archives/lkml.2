Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2LTLWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:22:24 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5352 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2LTLWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:22:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 20 Dec 2012 03:19:10 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "olof@lixom.net" <olof@lixom.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 20 Dec 2012 12:21:36 +0100
Subject: Re: [PATCH 3/9] ARM: tegra: # of CPU cores detection w/ & w/o
 HAVE_ARM_SCU
Thread-Topic: [PATCH 3/9] ARM: tegra: # of CPU cores detection w/ & w/o
 HAVE_ARM_SCU
Thread-Index: Ac3epC0DxhYC0RTfSv2egeg09FC5vw==
Message-ID: <20121220.132136.1599315430686323669.hdoyu@nvidia.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com><1355996654-6579-4-git-send-email-hdoyu@nvidia.com><20121220100625.GB24693@arwen.pp.htv.fi>
In-Reply-To: <20121220100625.GB24693@arwen.pp.htv.fi>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <balbi@ti.com> wrote @ Thu, 20 Dec 2012 11:06:25 +0100:
...
> > @@ -149,7 +154,26 @@ done:
> >   */
> >  static void __init tegra_smp_init_cpus(void)
> >  {
> > -	unsigned int i, ncores = scu_get_core_count(scu_base);
> > +	unsigned int i, cpu_id, ncores;
> > +	u32 l2ctlr;
> > +	phys_addr_t pa;
> > +
> > +	cpu_id = read_cpuid(CPUID_ID) & CPU_MASK;
> > +	switch (cpu_id) {
> > +	case CPU_CORTEX_A15:
> > +		asm("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
> > +		ncores = ((l2ctlr >> 24) & 3) + 1;
> > +		break;
> > +	case CPU_CORTEX_A9:
> > +		/* Get SCU physical base */
> > +		asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (pa));
> > +		scu_base = IO_ADDRESS(pa);
> > +		ncores = scu_get_core_count(scu_base);
> > +		break;
> > +	default:
> > +		BUG();
> 
> instead of bugging out, how about setting ncores to 1 instead ?

Maybe that would be useful in the case of adding new ARM core in the
future.
