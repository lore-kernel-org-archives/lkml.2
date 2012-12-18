Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2LRPca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:32:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2629 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab2LRPc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:32:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 18 Dec 2012 07:32:25 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "robherring2@gmail.com" <robherring2@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob@landley.net" <rob@landley.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 18 Dec 2012 16:32:21 +0100
Subject: Re: [PATCH 4/4] ARM: tegra: Set SCU base address dynamically from DT
Thread-Topic: [PATCH 4/4] ARM: tegra: Set SCU base address dynamically from
 DT
Thread-Index: Ac3dNN/NouGb3LuwS3iKlY38S/e3Bw==
Message-ID: <20121218.173221.624266793051846341.hdoyu@nvidia.com>
References: <20121218.112129.1344593225772728837.hdoyu@nvidia.com><50D073BC.3040607@gmail.com><20121218.171546.377156145440622681.hdoyu@nvidia.com>
In-Reply-To: <20121218.171546.377156145440622681.hdoyu@nvidia.com>
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

Hiroshi Doyu <hdoyu@nvidia.com> wrote @ Tue, 18 Dec 2012 17:15:46 +0200 (EET):

> Rob Herring <robherring2@gmail.com> wrote @ Tue, 18 Dec 2012 14:46:36 +0100:
> 
> > On 12/18/2012 03:21 AM, Hiroshi Doyu wrote:
> > > Hi Rob,
> > > 
> > > Rob Herring <robherring2@gmail.com> wrote @ Mon, 17 Dec 2012 15:00:46 +0100:
> > > 
> > >> On 12/17/2012 12:18 AM, Hiroshi Doyu wrote:
> > >>> Set Snoop Control Unit(SCU) register base address dynamically from DT.
> > >>>
> > >>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > >>> ---
> > >>>  arch/arm/mach-tegra/platsmp.c |   23 ++++++++++++++++++++---
> > >>>  1 file changed, 20 insertions(+), 3 deletions(-)
> > >>>
> > >>> diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
> > >>> index 1b926df..45c0b79 100644
> > >>> --- a/arch/arm/mach-tegra/platsmp.c
> > >>> +++ b/arch/arm/mach-tegra/platsmp.c
> > >>> @@ -18,6 +18,8 @@
> > >>>  #include <linux/jiffies.h>
> > >>>  #include <linux/smp.h>
> > >>>  #include <linux/io.h>
> > >>> +#include <linux/of.h>
> > >>> +#include <linux/of_address.h>
> > >>>  
> > >>>  #include <asm/cacheflush.h>
> > >>>  #include <asm/hardware/gic.h>
> > >>> @@ -36,7 +38,7 @@
> > >>>  
> > >>>  extern void tegra_secondary_startup(void);
> > >>>  
> > >>> -static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
> > >>> +static void __iomem *scu_base;
> > >>>  
> > >>>  #define EVP_CPU_RESET_VECTOR \
> > >>>  	(IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE) + 0x100)
> > >>> @@ -143,14 +145,28 @@ done:
> > >>>  	return status;
> > >>>  }
> > >>>  
> > >>> +static const struct of_device_id cortex_a9_scu_match[] __initconst = {
> > >>> +	{ .compatible = "arm,cortex-a9-scu", },
> > >>> +	{}
> > >>> +};
> > >>> +
> > >>>  /*
> > >>>   * Initialise the CPU possible map early - this describes the CPUs
> > >>>   * which may be present or become present in the system.
> > >>>   */
> > >>>  static void __init tegra_smp_init_cpus(void)
> > >>>  {
> > >>> -	unsigned int i, ncores = scu_get_core_count(scu_base);
> > >>> +	struct device_node *np;
> > >>> +	unsigned int i, ncores = 1;
> > >>> +
> > >>> +	np = of_find_matching_node(NULL, cortex_a9_scu_match);
> > >>> +	if (!np)
> > >>> +		return;
> > >>> +	scu_base = of_iomap(np, 0);
> > >>
> > >> Did you actually test this? Unless something changed, ioremap does not
> > >> work this early. The only reason to have it mapped this early is to get
> > >> the core count, but that doesn't work on A15 or A7. So we really need to
> > >> get core count/mask in a standard way. At least some work to get core
> > >> count from DT went into 3.8.
> > >>
> > >> BTW, you can get the scu address on the A9 by reading cp15 register:
> > >>
> > >> 	/* Get SCU base */
> > >> 	asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (base));
> > >>
> > >> It's still probably good to have the DT node, but the reg property can
> > >> be optional in this case.
> > > 
> > > I'm simply wondering, if the above cp15 works with Cortex-A9, do we
> > > still need SCU DT node? At least from Cortex-A15 TRM, it seems that
> > > SCU is tighly integrated into CPU core and it doesn't have any user
> > > control. So Cortex-A15 doesn't seem to need to configure SCU. For
> > > Cortex-A7, I haven't yet found S/W configurable register definitions
> > > in TRM. So if neither of A15/A7 need SCU base, would the above cp15
> > > intructions be enough?
> > 
> > The A15/A7 still have the register for the other peripherals like the
> > GIC, but there are no SCU registers or other way to get a core count
> > from the h/w.
> > 
> > The DT node could be used to determine if you have an SCU or not. I just
> > used the cpu node compatible value to determine that.
> 
> Taking a look at A15 TRM again, it seems that A15 can get number of
> processors via(*1):
> 
>   asm("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
> 
> At least, A15 is ok without SCU/DT to get the number of processors. I
> haven't found the above instruction in A7, but is there any way to get
> the number of core in A7?

L2CTLR can be used to detect # of cores for A7 as well:

http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0464e/BABBACEE.html

> If both A15/A7 can get # of CPU cores via coprocessor instruction,
> what others should we take care of with DT node?
> 
> *1: http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0438e/BABBACEE.html
> 
> > >> We need to move away from having the DT matching code within the
> > >> platforms. This should all be moved to the scu code in a scu_of_init
> > >> function that could be called from common code.
> > > 
> > > True if SCU DT node is still necessary.
> > 
> > Well, reading the cp15 register and mapping the registers could be
> > common code independent of DT. I'm not sure if there are non-A9
> > implementations of the SCU which don't have the cp15 register.
> 
> 
