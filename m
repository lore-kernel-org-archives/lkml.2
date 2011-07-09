Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1GIXMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 19:12:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:39121 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab1GIXMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 19:12:16 -0400
Subject: Re: [PATCH] powerpc: convert to generic pci_*_flags
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linuxppc-dev@lists.infradead.org, Rob Herring <rob.herring@calxeda.com>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        nico@fluxnic.net, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Arnd Bergmann <arnd@arndb.de>, monstr@monstr.eu, linuxram@us.ibm.com
In-Reply-To: <1310178084-21774-1-git-send-email-robherring2@gmail.com>
References: <1310178084-21774-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 09:11:38 +1000
Message-ID: <1310253098.8267.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 21:21 -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This converts powerpc to use generic pci_set/add/has_flags functions from
> asm-generic/pci-bridge.h.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Cc: Paul Mackerras <paulus@samba.org>
> ---
> Compiled on 86xx and G5.
> 
> This is part of a ARM PCI clean-up which moves the microblaze pci flags
> functions to asm-generic/pci-bridge.h.

Just make sure that goes into -next early before a merge window so I get
a chance to catch any mistake on one of our odd platforms.

Cheers,
Ben.

>  arch/powerpc/include/asm/pci-bridge.h      |   50 +---------------------------
>  arch/powerpc/include/asm/pci.h             |    2 +-
>  arch/powerpc/kernel/pci-common.c           |   22 ++++++------
>  arch/powerpc/kernel/pci_32.c               |    2 +-
>  arch/powerpc/kernel/pci_64.c               |    4 +-
>  arch/powerpc/kernel/rtas_pci.c             |    2 +-
>  arch/powerpc/platforms/40x/ep405.c         |    2 +-
>  arch/powerpc/platforms/40x/ppc40x_simple.c |    2 +-
>  arch/powerpc/platforms/40x/walnut.c        |    2 +-
>  arch/powerpc/platforms/44x/canyonlands.c   |    2 +-
>  arch/powerpc/platforms/44x/ebony.c         |    2 +-
>  arch/powerpc/platforms/44x/ppc44x_simple.c |    2 +-
>  arch/powerpc/platforms/44x/sam440ep.c      |    2 +-
>  arch/powerpc/platforms/52xx/mpc52xx_pci.c  |    2 +-
>  arch/powerpc/platforms/82xx/pq2.c          |    2 +-
>  arch/powerpc/platforms/chrp/pci.c          |    2 +-
>  arch/powerpc/platforms/powermac/pci.c      |    6 ++--
>  arch/powerpc/sysdev/fsl_pci.c              |    4 +-
>  arch/powerpc/sysdev/grackle.c              |    2 +-
>  arch/powerpc/sysdev/ppc4xx_pci.c           |    2 +-
>  20 files changed, 34 insertions(+), 82 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
> index b90dbf8..8a9cb9f 100644
> --- a/arch/powerpc/include/asm/pci-bridge.h
> +++ b/arch/powerpc/include/asm/pci-bridge.h
> @@ -10,58 +10,10 @@
>  #include <linux/pci.h>
>  #include <linux/list.h>
>  #include <linux/ioport.h>
> +#include <asm-generic/pci-bridge.h>
>  
>  struct device_node;
>  
> -enum {
> -	/* Force re-assigning all resources (ignore firmware
> -	 * setup completely)
> -	 */
> -	PPC_PCI_REASSIGN_ALL_RSRC	= 0x00000001,
> -
> -	/* Re-assign all bus numbers */
> -	PPC_PCI_REASSIGN_ALL_BUS	= 0x00000002,
> -
> -	/* Do not try to assign, just use existing setup */
> -	PPC_PCI_PROBE_ONLY		= 0x00000004,
> -
> -	/* Don't bother with ISA alignment unless the bridge has
> -	 * ISA forwarding enabled
> -	 */
> -	PPC_PCI_CAN_SKIP_ISA_ALIGN	= 0x00000008,
> -
> -	/* Enable domain numbers in /proc */
> -	PPC_PCI_ENABLE_PROC_DOMAINS	= 0x00000010,
> -	/* ... except for domain 0 */
> -	PPC_PCI_COMPAT_DOMAIN_0		= 0x00000020,
> -};
> -#ifdef CONFIG_PCI
> -extern unsigned int ppc_pci_flags;
> -
> -static inline void ppc_pci_set_flags(int flags)
> -{
> -	ppc_pci_flags = flags;
> -}
> -
> -static inline void ppc_pci_add_flags(int flags)
> -{
> -	ppc_pci_flags |= flags;
> -}
> -
> -static inline int ppc_pci_has_flag(int flag)
> -{
> -	return (ppc_pci_flags & flag);
> -}
> -#else
> -static inline void ppc_pci_set_flags(int flags) { }
> -static inline void ppc_pci_add_flags(int flags) { }
> -static inline int ppc_pci_has_flag(int flag)
> -{
> -	return 0;
> -}
> -#endif
> -
> -
>  /*
>   * Structure of a PCI controller (host bridge)
>   */
> diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
> index 7d77909..b9a40fa 100644
> --- a/arch/powerpc/include/asm/pci.h
> +++ b/arch/powerpc/include/asm/pci.h
> @@ -44,7 +44,7 @@ struct pci_dev;
>   * bus numbers (don't do that on ppc64 yet !)
>   */
>  #define pcibios_assign_all_busses() \
> -	(ppc_pci_has_flag(PPC_PCI_REASSIGN_ALL_BUS))
> +	(pci_has_flag(PCI_REASSIGN_ALL_BUS))
>  
>  static inline void pcibios_set_master(struct pci_dev *dev)
>  {
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index 893af2a..4b9ae67 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -50,7 +50,7 @@ static int global_phb_number;		/* Global phb counter */
>  resource_size_t isa_mem_base;
>  
>  /* Default PCI flags is 0 on ppc32, modified at boot on ppc64 */
> -unsigned int ppc_pci_flags = 0;
> +unsigned int pci_flags = 0;
>  
> 
>  static struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
> @@ -842,9 +842,9 @@ int pci_proc_domain(struct pci_bus *bus)
>  {
>  	struct pci_controller *hose = pci_bus_to_host(bus);
>  
> -	if (!(ppc_pci_flags & PPC_PCI_ENABLE_PROC_DOMAINS))
> +	if (!pci_has_flag(PCI_ENABLE_PROC_DOMAINS))
>  		return 0;
> -	if (ppc_pci_flags & PPC_PCI_COMPAT_DOMAIN_0)
> +	if (pci_has_flag(PCI_COMPAT_DOMAIN_0))
>  		return hose->global_number != 0;
>  	return 1;
>  }
> @@ -920,13 +920,13 @@ static void __devinit pcibios_fixup_resources(struct pci_dev *dev)
>  		struct resource *res = dev->resource + i;
>  		if (!res->flags)
>  			continue;
> -		/* On platforms that have PPC_PCI_PROBE_ONLY set, we don't
> +		/* On platforms that have PCI_PROBE_ONLY set, we don't
>  		 * consider 0 as an unassigned BAR value. It's technically
>  		 * a valid value, but linux doesn't like it... so when we can
>  		 * re-assign things, we do so, but if we can't, we keep it
>  		 * around and hope for the best...
>  		 */
> -		if (res->start == 0 && !(ppc_pci_flags & PPC_PCI_PROBE_ONLY)) {
> +		if (res->start == 0 && !pci_has_flag(PCI_PROBE_ONLY)) {
>  			pr_debug("PCI:%s Resource %d %016llx-%016llx [%x] is unassigned\n",
>  				 pci_name(dev), i,
>  				 (unsigned long long)res->start,
> @@ -973,7 +973,7 @@ static int __devinit pcibios_uninitialized_bridge_resource(struct pci_bus *bus,
>  	int i;
>  
>  	/* We don't do anything if PCI_PROBE_ONLY is set */
> -	if (ppc_pci_flags & PPC_PCI_PROBE_ONLY)
> +	if (pci_has_flag(PCI_PROBE_ONLY))
>  		return 0;
>  
>  	/* Job is a bit different between memory and IO */
> @@ -1146,7 +1146,7 @@ void __devinit pci_fixup_cardbus(struct pci_bus *bus)
>  
>  static int skip_isa_ioresource_align(struct pci_dev *dev)
>  {
> -	if ((ppc_pci_flags & PPC_PCI_CAN_SKIP_ISA_ALIGN) &&
> +	if (pci_has_flag(PCI_CAN_SKIP_ISA_ALIGN) &&
>  	    !(dev->bus->bridge_ctl & PCI_BRIDGE_CTL_ISA))
>  		return 1;
>  	return 0;
> @@ -1274,7 +1274,7 @@ void pcibios_allocate_bus_resources(struct pci_bus *bus)
>  			 * and as such ensure proper re-allocation
>  			 * later.
>  			 */
> -			if (ppc_pci_flags & PPC_PCI_REASSIGN_ALL_RSRC)
> +			if (pci_has_flag(PCI_REASSIGN_ALL_RSRC))
>  				goto clear_resource;
>  			pr = pci_find_parent_resource(bus->self, res);
>  			if (pr == res) {
> @@ -1459,7 +1459,7 @@ void __init pcibios_resource_survey(void)
>  	list_for_each_entry(b, &pci_root_buses, node)
>  		pcibios_allocate_bus_resources(b);
>  
> -	if (!(ppc_pci_flags & PPC_PCI_REASSIGN_ALL_RSRC)) {
> +	if (!pci_has_flag(PCI_REASSIGN_ALL_RSRC)) {
>  		pcibios_allocate_resources(0);
>  		pcibios_allocate_resources(1);
>  	}
> @@ -1468,7 +1468,7 @@ void __init pcibios_resource_survey(void)
>  	 * the low IO area and the VGA memory area if they intersect the
>  	 * bus available resources to avoid allocating things on top of them
>  	 */
> -	if (!(ppc_pci_flags & PPC_PCI_PROBE_ONLY)) {
> +	if (!pci_has_flag(PCI_PROBE_ONLY)) {
>  		list_for_each_entry(b, &pci_root_buses, node)
>  			pcibios_reserve_legacy_regions(b);
>  	}
> @@ -1476,7 +1476,7 @@ void __init pcibios_resource_survey(void)
>  	/* Now, if the platform didn't decide to blindly trust the firmware,
>  	 * we proceed to assigning things that were left unassigned
>  	 */
> -	if (!(ppc_pci_flags & PPC_PCI_PROBE_ONLY)) {
> +	if (!pci_has_flag(PCI_PROBE_ONLY)) {
>  		pr_debug("PCI: Assigning unassigned resources...\n");
>  		pci_assign_unassigned_resources();
>  	}
> diff --git a/arch/powerpc/kernel/pci_32.c b/arch/powerpc/kernel/pci_32.c
> index bedb370..b1959bf 100644
> --- a/arch/powerpc/kernel/pci_32.c
> +++ b/arch/powerpc/kernel/pci_32.c
> @@ -373,7 +373,7 @@ static int __init pcibios_init(void)
>  
>  	printk(KERN_INFO "PCI: Probing PCI hardware\n");
>  
> -	if (ppc_pci_flags & PPC_PCI_REASSIGN_ALL_BUS)
> +	if (pci_has_flag(PCI_REASSIGN_ALL_BUS))
>  		pci_assign_all_buses = 1;
>  
>  	/* Scan all of the recorded PCI controllers.  */
> diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
> index fc6452b..ab34046 100644
> --- a/arch/powerpc/kernel/pci_64.c
> +++ b/arch/powerpc/kernel/pci_64.c
> @@ -55,12 +55,12 @@ static int __init pcibios_init(void)
>  	ppc_md.phys_mem_access_prot = pci_phys_mem_access_prot;
>  
>  	if (pci_probe_only)
> -		ppc_pci_flags |= PPC_PCI_PROBE_ONLY;
> +		pci_add_flags(PCI_PROBE_ONLY);
>  
>  	/* On ppc64, we always enable PCI domains and we keep domain 0
>  	 * backward compatible in /proc for video cards
>  	 */
> -	ppc_pci_flags |= PPC_PCI_ENABLE_PROC_DOMAINS | PPC_PCI_COMPAT_DOMAIN_0;
> +	pci_add_flags(PCI_ENABLE_PROC_DOMAINS | PCI_COMPAT_DOMAIN_0);
>  
>  	/* Scan all of the recorded PCI controllers.  */
>  	list_for_each_entry_safe(hose, tmp, &hose_list, list_node) {
> diff --git a/arch/powerpc/kernel/rtas_pci.c b/arch/powerpc/kernel/rtas_pci.c
> index 54e66da..6cd8f01 100644
> --- a/arch/powerpc/kernel/rtas_pci.c
> +++ b/arch/powerpc/kernel/rtas_pci.c
> @@ -291,7 +291,7 @@ void __init find_and_init_phbs(void)
>  		prop = of_get_property(of_chosen,
>  				"linux,pci-assign-all-buses", NULL);
>  		if (prop && *prop)
> -			ppc_pci_flags |= PPC_PCI_REASSIGN_ALL_BUS;
> +			pci_add_flags(PCI_REASSIGN_ALL_BUS);
>  #endif /* CONFIG_PPC32 */
>  	}
>  }
> diff --git a/arch/powerpc/platforms/40x/ep405.c b/arch/powerpc/platforms/40x/ep405.c
> index 4058fd1..b0389bb 100644
> --- a/arch/powerpc/platforms/40x/ep405.c
> +++ b/arch/powerpc/platforms/40x/ep405.c
> @@ -100,7 +100,7 @@ static void __init ep405_setup_arch(void)
>  	/* Find & init the BCSR CPLD */
>  	ep405_init_bcsr();
>  
> -	ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
> +	pci_set_flags(PCI_REASSIGN_ALL_RSRC);
>  }
>  
>  static int __init ep405_probe(void)
> diff --git a/arch/powerpc/platforms/40x/ppc40x_simple.c b/arch/powerpc/platforms/40x/ppc40x_simple.c
> index 2521d93..e8dd5c5 100644
> --- a/arch/powerpc/platforms/40x/ppc40x_simple.c
> +++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
> @@ -61,7 +61,7 @@ static const char *board[] __initdata = {
>  static int __init ppc40x_probe(void)
>  {
>  	if (of_flat_dt_match(of_get_flat_dt_root(), board)) {
> -		ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
> +		pci_set_flags(PCI_REASSIGN_ALL_RSRC);
>  		return 1;
>  	}
>  
> diff --git a/arch/powerpc/platforms/40x/walnut.c b/arch/powerpc/platforms/40x/walnut.c
> index 335df91..8b691df 100644
> --- a/arch/powerpc/platforms/40x/walnut.c
> +++ b/arch/powerpc/platforms/40x/walnut.c
> @@ -51,7 +51,7 @@ static int __init walnut_probe(void)
>  	if (!of_flat_dt_is_compatible(root, "ibm,walnut"))
>  		return 0;
>  
> -	ppc_pci_flags = PPC_PCI_REASSIGN_ALL_RSRC;
> +	pci_set_flags(PCI_REASSIGN_ALL_RSRC);
>  
>  	return 1;
>  }
> diff --git a/arch/powerpc/platforms/44x/canyonlands.c b/arch/powerpc/platforms/44x/canyonlands.c
> index afc5e8e..e300dd4 100644
> --- a/arch/powerpc/platforms/44x/canyonlands.c
> +++ b/arch/powerpc/platforms/44x/canyonlands.c
> @@ -55,7 +55,7 @@ static int __init ppc460ex_probe(void)
>  {
>  	unsigned long root = of_get_flat_dt_root();
>  	if (of_flat_dt_is_compatible(root, "amcc,canyonlands")) {
> -		ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
> +		pci_set_flags(PCI_REASSIGN_ALL_RSRC);
>  		return 1;
>  		}
>  	return 0;
> diff --git a/arch/powerpc/platforms/44x/ebony.c b/arch/powerpc/platforms/44x/ebony.c
> index 88b9117..6a4232b 100644
> --- a/arch/powerpc/platforms/44x/ebony.c
> +++ b/arch/powerpc/platforms/44x/ebony.c
> @@ -54,7 +54,7 @@ static int __init ebony_probe(void)
>  	if (!of_flat_dt_is_compatible(root, "ibm,ebony"))
>  		return 0;
>  
> -	ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
> +	pci_set_flags(PCI_REASSIGN_ALL_RSRC);
>  
>  	return 1;
>  }
> diff --git a/arch/powerpc/platforms/44x/ppc44x_simple.c b/arch/powerpc/platforms/44x/ppc44x_simple.c
> index c81c19c..8d22027 100644
> --- a/arch/powerpc/platforms/44x/ppc44x_simple.c
> +++ b/arch/powerpc/platforms/44x/ppc44x_simple.c
> @@ -72,7 +72,7 @@ static int __init ppc44x_probe(void)
>  
>  	for (i = 0; i < ARRAY_SIZE(board); i++) {
>  		if (of_flat_dt_is_compatible(root, board[i])) {
> -			ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
> +			pci_set_flags(PCI_REASSIGN_ALL_RSRC);
>  			return 1;
>  		}
>  	}
> diff --git a/arch/powerpc/platforms/44x/sam440ep.c b/arch/powerpc/platforms/44x/sam440ep.c
> index a78e8eb..9e09b83 100644
> --- a/arch/powerpc/platforms/44x/sam440ep.c
> +++ b/arch/powerpc/platforms/44x/sam440ep.c
> @@ -51,7 +51,7 @@ static int __init sam440ep_probe(void)
>  	if (!of_flat_dt_is_compatible(root, "acube,sam440ep"))
>  		return 0;
>  
> -	ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
> +	pci_set_flags(PCI_REASSIGN_ALL_RSRC);
>  
>  	return 1;
>  }
> diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pci.c b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
> index da110bd..82051bd 100644
> --- a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
> +++ b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
> @@ -371,7 +371,7 @@ mpc52xx_add_bridge(struct device_node *node)
>  
>  	pr_debug("Adding MPC52xx PCI host bridge %s\n", node->full_name);
>  
> -	ppc_pci_add_flags(PPC_PCI_REASSIGN_ALL_BUS);
> +	pci_add_flags(PCI_REASSIGN_ALL_BUS);
>  
>  	if (of_address_to_resource(node, 0, &rsrc) != 0) {
>  		printk(KERN_ERR "Can't get %s resources\n", node->full_name);
> diff --git a/arch/powerpc/platforms/82xx/pq2.c b/arch/powerpc/platforms/82xx/pq2.c
> index 9761a59..d111b02 100644
> --- a/arch/powerpc/platforms/82xx/pq2.c
> +++ b/arch/powerpc/platforms/82xx/pq2.c
> @@ -53,7 +53,7 @@ static void __init pq2_pci_add_bridge(struct device_node *np)
>  	if (of_address_to_resource(np, 0, &r) || r.end - r.start < 0x10b)
>  		goto err;
>  
> -	ppc_pci_add_flags(PPC_PCI_REASSIGN_ALL_BUS);
> +	pci_add_flags(PCI_REASSIGN_ALL_BUS);
>  
>  	hose = pcibios_alloc_controller(np);
>  	if (!hose)
> diff --git a/arch/powerpc/platforms/chrp/pci.c b/arch/powerpc/platforms/chrp/pci.c
> index 8f67a39..f3376fa 100644
> --- a/arch/powerpc/platforms/chrp/pci.c
> +++ b/arch/powerpc/platforms/chrp/pci.c
> @@ -199,7 +199,7 @@ static void __init setup_peg2(struct pci_controller *hose, struct device_node *d
>  		printk ("RTAS supporting Pegasos OF not found, please upgrade"
>  			" your firmware\n");
>  	}
> -	ppc_pci_add_flags(PPC_PCI_REASSIGN_ALL_BUS);
> +	pci_add_flags(PCI_REASSIGN_ALL_BUS);
>  	/* keep the reference to the root node */
>  }
>  
> diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
> index f33e08d..c291afd 100644
> --- a/arch/powerpc/platforms/powermac/pci.c
> +++ b/arch/powerpc/platforms/powermac/pci.c
> @@ -731,7 +731,7 @@ static void __init setup_bandit(struct pci_controller *hose,
>  static int __init setup_uninorth(struct pci_controller *hose,
>  				 struct resource *addr)
>  {
> -	ppc_pci_add_flags(PPC_PCI_REASSIGN_ALL_BUS);
> +	pci_add_flags(PCI_REASSIGN_ALL_BUS);
>  	has_uninorth = 1;
>  	hose->ops = &macrisc_pci_ops;
>  	hose->cfg_addr = ioremap(addr->start + 0x800000, 0x1000);
> @@ -998,7 +998,7 @@ void __init pmac_pci_init(void)
>  	struct device_node *np, *root;
>  	struct device_node *ht = NULL;
>  
> -	ppc_pci_set_flags(PPC_PCI_CAN_SKIP_ISA_ALIGN);
> +	pci_set_flags(PCI_CAN_SKIP_ISA_ALIGN);
>  
>  	root = of_find_node_by_path("/");
>  	if (root == NULL) {
> @@ -1057,7 +1057,7 @@ void __init pmac_pci_init(void)
>  	 * some offset between bus number and domains for now when we
>  	 * assign all busses should help for now
>  	 */
> -	if (ppc_pci_has_flag(PPC_PCI_REASSIGN_ALL_BUS))
> +	if (pci_has_flag(PCI_REASSIGN_ALL_BUS))
>  		pcibios_assign_bus_offset = 0x10;
>  #endif
>  }
> diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> index 68ca929..31f99ec7 100644
> --- a/arch/powerpc/sysdev/fsl_pci.c
> +++ b/arch/powerpc/sysdev/fsl_pci.c
> @@ -343,7 +343,7 @@ int __init fsl_add_bridge(struct device_node *dev, int is_primary)
>  		printk(KERN_WARNING "Can't get bus-range for %s, assume"
>  			" bus 0\n", dev->full_name);
>  
> -	ppc_pci_add_flags(PPC_PCI_REASSIGN_ALL_BUS);
> +	pci_add_flags(PCI_REASSIGN_ALL_BUS);
>  	hose = pcibios_alloc_controller(dev);
>  	if (!hose)
>  		return -ENOMEM;
> @@ -679,7 +679,7 @@ int __init mpc83xx_add_bridge(struct device_node *dev)
>  		       " bus 0\n", dev->full_name);
>  	}
>  
> -	ppc_pci_add_flags(PPC_PCI_REASSIGN_ALL_BUS);
> +	pci_add_flags(PCI_REASSIGN_ALL_BUS);
>  	hose = pcibios_alloc_controller(dev);
>  	if (!hose)
>  		return -ENOMEM;
> diff --git a/arch/powerpc/sysdev/grackle.c b/arch/powerpc/sysdev/grackle.c
> index cf27df6..08abe91 100644
> --- a/arch/powerpc/sysdev/grackle.c
> +++ b/arch/powerpc/sysdev/grackle.c
> @@ -57,7 +57,7 @@ void __init setup_grackle(struct pci_controller *hose)
>  {
>  	setup_indirect_pci(hose, 0xfec00000, 0xfee00000, 0);
>  	if (of_machine_is_compatible("PowerMac1,1"))
> -		ppc_pci_add_flags(PPC_PCI_REASSIGN_ALL_BUS);
> +		pci_add_flags(PCI_REASSIGN_ALL_BUS);
>  	if (of_machine_is_compatible("AAPL,PowerBook1998"))
>  		grackle_set_loop_snoop(hose, 1);
>  #if 0	/* Disabled for now, HW problems ??? */
> diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
> index 156aa7d..9c067fa 100644
> --- a/arch/powerpc/sysdev/ppc4xx_pci.c
> +++ b/arch/powerpc/sysdev/ppc4xx_pci.c
> @@ -1960,7 +1960,7 @@ static int __init ppc4xx_pci_find_bridges(void)
>  {
>  	struct device_node *np;
>  
> -	ppc_pci_flags |= PPC_PCI_ENABLE_PROC_DOMAINS | PPC_PCI_COMPAT_DOMAIN_0;
> +	pci_add_flags(PCI_ENABLE_PROC_DOMAINS | PCI_COMPAT_DOMAIN_0);
>  
>  #ifdef CONFIG_PPC4xx_PCI_EXPRESS
>  	for_each_compatible_node(np, NULL, "ibm,plb-pciex")


