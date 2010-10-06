Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab0JFXig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:38:36 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:36876 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756707Ab0JFXie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 19:38:34 -0400
Date: Wed, 6 Oct 2010 17:39:53 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 PATCH 1/1] PCI: override BIOS/firmware resource
 allocation
Message-ID: <20101006233953.GB16280@helgaas.com>
References: <20101006225834.GE2945@ram-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006225834.GE2945@ram-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 03:58:34PM -0700, Ram Pai wrote:
>         PCI: override BIOS/firmware memory resource allocation
> 		through command line parameters
> 
> 	Platforms that are unaware of  SRIOV  BARs  fail to allocate MMIO
> 	resources  to SRIOV PCIe  devices. Hence  on  such  platforms the
> 	OS fails to  enable  SRIOV.
> 	Some  platforms  where  BIOS/uEFI resource   allocations  conflict
> 	the conflicting devices are disabled.
> 
> 	Ideally we  would  want  the  OS  to detect and fix automatically
> 	such problems and conflicts.  However previous  attempts to do so
> 	have led to regression on legacy platforms.

I'm sorry to be a nay-sayer, but I think we just haven't tried hard
enough.  Our ACPI/PCI/e820 resource management is not well integrated,
and I suspect if we straightened that out, we could avoid some of the
regressions we saw with previous attempts.

My fear is that we'll add this parameter, which is a relatively easy fix
for you.  Later we'll realize that telling users to boot with this or
that parameter, depending on what system they have and how they way to
use it, is not a sustainable strategy.  Then somebody else will be left
with the hard work of figuring out how to make Linux smart enough to do
it automatically.

Bjorn

> 	The  following patch provides the ability to override the BIOS
> 	allocations  using    user-hints   provided   through   kernel
> 	command-line parameters.
> 
> 	The patch is based upon an idea by Linus, details of which can
> 	be found at
> 	http://marc.info/?l=linux-kernel&m=127846075028242&w=2
> 
> 	Change log:
> 	    PCI Bridge window reset is done early just after
> 		early_dump_pci_devices() (Suggested by Yinghai)
> 	    command line parameters processing is moved from pci_setup() to
> 	      	pcibios_setup()   	 (Suggested by Yinghai)
>     
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 8dd7248..99ee10e 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1961,6 +1961,18 @@ and is between 256 and 4096 characters. It is defined in the file
>  				PAGE_SIZE is used as alignment.
>  				PCI-PCI bridge can be specified, if resource
>  				windows need to be expanded.
> +             	override=[off, conflict, always, <device>]
> +                             	off : Do not override BIOS/firmware memory resource
> +					allocations. This is the default.
> +                             	conflict : override BIOS/firmware memory resource
> +					allocations if conflicting or not allocated.
> +                             	always : override all BIOS/firmware memory resource
> +					allocations.
> +                             	<device>: Format [<domain>:]<bus>:<slot>.<func>[; ...]
> +                                     override BIOS/firmware memory resource allocations
> +				     of specified devices. If the device is a bridge
> +				     override allocations of all devices under the
> +				     bridge.
>  		ecrc=		Enable/disable PCIe ECRC (transaction layer
>  				end-to-end CRC checking).
>  				bios: Use BIOS/firmware settings. This is the
> diff --git a/arch/x86/include/asm/pci-direct.h b/arch/x86/include/asm/pci-direct.h
> index b1e7a45..3a2c439 100644
> --- a/arch/x86/include/asm/pci-direct.h
> +++ b/arch/x86/include/asm/pci-direct.h
> @@ -18,4 +18,5 @@ extern int early_pci_allowed(void);
>  extern unsigned int pci_early_dump_regs;
>  extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
>  extern void early_dump_pci_devices(void);
> +extern void early_reset_pci_devices(void);
>  #endif /* _ASM_X86_PCI_DIRECT_H */
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index c3a4fbb..956d7ac 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -855,6 +855,7 @@ void __init setup_arch(char **cmdline_p)
>  	if (pci_early_dump_regs)
>  		early_dump_pci_devices();
>  #endif
> +	early_reset_pci_devices();
>  
>  	finish_e820_parsing();
>  
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index a0772af..b26f782 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -453,6 +453,66 @@ int __init pcibios_init(void)
>  	return 0;
>  }
>  
> +#define RESOURCE_RELEASE_PARAM_SIZE 256
> +static char __initdata resource_release_param[RESOURCE_RELEASE_PARAM_SIZE] = {0};
> +int pci_override=PCI_OVERRIDE_OFF;
> +
> +char *next_pci_device(int *bus, int *slot, int *func, char *p)
> +{
> +	int seg, count;
> +
> +	if ( !p )
> +		p = resource_release_param;
> +
> +	if ( !*p )
> +		return NULL;
> +
> +	count = 0;
> +	if (sscanf(p, "%x:%x:%x.%x%n",
> +		&seg, bus, slot, func, &count) != 4) {
> +		seg = 0;
> +		if (sscanf(p, "%x:%x.%x%n",
> +				bus, slot, func, &count) != 3) {
> +			/* Invalid format */
> +			printk(KERN_ERR "PCI: Can't parse resource_alignment parameter: %s\n",
> +				p);
> +			return NULL;
> +		}
> +	}
> +	p += count;
> +	if (!*p)
> +		return p;
> +	if (*p == ';')
> +		return ++p;
> +	return NULL;
> +}
> +
> +
> +void pci_override_setup(const char *str, int override)
> +{
> +	int count;
> +	if (override && !strncmp(str, "off", 3)) {
> +		pci_override = PCI_OVERRIDE_OFF;
> +		printk(KERN_INFO "pci: do not override BIOS/uEFI memory allocations\n");
> +	} else if (override && !strncmp(str, "conflict", 8)) {
> +		pci_override = PCI_OVERRIDE_CONFLICT;
> +		printk(KERN_INFO "pci: reallocate BIOS/uEFI allocated memory resource conflicts\n");
> +	} else if (override && !strncmp(str, "always", 6)) {
> +		pci_override =  PCI_OVERRIDE_ALWAYS;
> +		printk(KERN_INFO "pci: override all BIOS/uEFI memory resource allocations\n");
> +	} else {
> +		pci_override =  PCI_OVERRIDE_DEVICE;
> +		count=strlen(str);
> +		if (count > RESOURCE_RELEASE_PARAM_SIZE - 1)
> +			count = RESOURCE_RELEASE_PARAM_SIZE - 1;
> +		strncpy(resource_release_param, str, count);
> +		resource_release_param[count] = '\0';
> +		printk(KERN_INFO "pci: override BIOS/uEFI memory allocations for %s\n",
> +			   resource_release_param);
> +	}
> +	return;
> +}
> +
>  char * __devinit  pcibios_setup(char *str)
>  {
>  	if (!strcmp(str, "off")) {
> @@ -558,6 +618,9 @@ char * __devinit  pcibios_setup(char *str)
>  		if (noioapicreroute != -1)
>  			noioapicreroute = 1;
>  		return NULL;
> +	} else if (!strncmp(str, "override=", 9)) {
> +		pci_override_setup(str + 9, 1);
> +		return NULL;
>  	}
>  	return str;
>  }
> diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
> index d1067d5..7a30a87 100644
> --- a/arch/x86/pci/early.c
> +++ b/arch/x86/pci/early.c
> @@ -109,3 +109,101 @@ void early_dump_pci_devices(void)
>  		}
>  	}
>  }
> +
> +static void __reset_bridge_window(u8 bus, u8 slot, u8 func)
> +{
> +	/* reset mem resources */
> +	write_pci_config_16(bus, slot, func, PCI_MEMORY_BASE, 0x00);
> +
> +	/* reset pref mem resources */
> +	write_pci_config(bus, slot, func, PCI_PREF_LIMIT_UPPER32, 0x00);
> +	write_pci_config(bus, slot, func, PCI_PREF_MEMORY_BASE, 0x00);
> +	write_pci_config(bus, slot, func, PCI_PREF_BASE_UPPER32, 0x00);
> +	write_pci_config(bus, slot, func, PCI_PREF_LIMIT_UPPER32, 0x00);
> +}
> +
> +
> +int find_parent_bridge(u8 *bus, u8 *slot, u8 *func, u8 secondary_bus)
> +{
> +   u8 tbus, tslot, tfunc;
> +	for (tbus = secondary_bus-1; tbus >= 0; tbus--) {
> + 	 for (tslot = 0; tslot < 32; tslot++) {
> +	  for (tfunc = 0; tfunc < 8; tfunc++) {
> +		if (0xffffffff == read_pci_config(tbus,
> +			    tslot, tfunc, PCI_CLASS_REVISION))
> +			continue;
> +
> +		if (read_pci_config_byte(tbus, tslot, tfunc,
> +			PCI_HEADER_TYPE) != PCI_HEADER_TYPE_BRIDGE)
> +			continue;
> +
> +		if (secondary_bus == read_pci_config_byte(tbus,
> +			  tslot, tfunc, PCI_SECONDARY_BUS)) {
> +			*bus=tbus;
> +			*slot=tslot;
> +			*func=tfunc;
> +			return 1;
> +		}
> +	  }
> +         }
> +	}
> +	return 0;
> +}
> +
> +void reset_bridge_window(u8 bus, u8 slot, u8 func)
> +{
> +	u8 tbus, tslot, tfunc;
> +	if (read_pci_config_byte(bus, slot, func, PCI_HEADER_TYPE) ==
> +			PCI_HEADER_TYPE_BRIDGE) {
> +		__reset_bridge_window(bus, slot, func);
> +	} else if (find_parent_bridge(&tbus, &tslot, &tfunc, bus))
> +		__reset_bridge_window(tbus, tslot, tfunc);
> +	return;
> +}
> +
> +void reset_topmost_bridges(void)
> +{
> +	u8 slot, func;
> +
> +	/* topmost bridges as assumed to be on bus 0. good assumption? */
> +	for (slot = 0; slot < 32; slot++) {
> +	 for (func = 0; func < 8; func++) {
> +		if (0xffffffff == read_pci_config(0, slot, func, PCI_CLASS_REVISION))
> +			continue;
> +
> +		if (read_pci_config_byte(0, slot, func, PCI_HEADER_TYPE) ==
> +				PCI_HEADER_TYPE_BRIDGE) {
> +			__reset_bridge_window(0, slot, func);
> +		}
> +	 }
> +	}
> +	return;
> +}
> +
> +extern char * next_pci_device(int *bus, int *slot, int *func, char *pr);
> +extern int pci_override;
> +
> +void early_reset_pci_devices(void)
> +{
> +	unsigned bus, slot, func;
> +	char *ptr=NULL;
> +
> +	if (!early_pci_allowed())
> +		return;
> +
> +	if ( pci_override == PCI_OVERRIDE_OFF )
> +		return;
> +
> +	if ( pci_override == PCI_OVERRIDE_ALWAYS ) {
> +		reset_topmost_bridges();
> +		return;
> +	}
> +
> +	while((ptr = next_pci_device(&bus, &slot, &func, ptr))) {
> +		if (0xffffffff == read_pci_config(bus, slot,
> +				func, PCI_CLASS_REVISION))
> +			continue;
> +		reset_bridge_window(bus, slot, func);
> +	}
> +	return;
> +}
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 66cb8f4..981e701 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -768,6 +768,7 @@ static void pci_bridge_release_resources(struct pci_bus *bus,
>  	}
>  }
>  
> +
>  enum release_type {
>  	leaf_only,
>  	whole_subtree,
> @@ -808,6 +809,7 @@ static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
>  		pci_bridge_release_resources(bus, type);
>  }
>  
> +
>  static void pci_bus_dump_res(struct pci_bus *bus)
>  {
>  	struct resource *res;
> @@ -838,26 +840,78 @@ static void pci_bus_dump_resources(struct pci_bus *bus)
>  	}
>  }
>  
> +static void __init
> +pci_release_resources(struct resource_list_x *head)
> +{
> +	struct resource_list_x *list;
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +	enum release_type rel_type = whole_subtree;
> +	/*
> +	 * Try to release leaf bridge's resources that doesn't fit resource of
> +	 * child device under that bridge
> +	 */
> +	for (list = head->next; list;) {
> +		struct pci_bus *bus =  list->dev->bus;
> +		pci_bus_release_bridge_resources(bus, list->flags & type_mask,
> +						  rel_type);
> +		list = list->next;
> + 	}
> +	/* restore size and flags */
> +	for (list = head->next; list;) {
> +		struct resource *res = list->res;
> +
> +		res->start = list->start;
> +		res->end = list->end;
> +		res->flags = list->flags;
> +		if (list->dev->subordinate)
> +			res->flags = 0;
> +
> +		list = list->next;
> +	}
> +	free_failed_list(head);
> +}
> +
>  void __init
>  pci_assign_unassigned_resources(void)
>  {
>  	struct pci_bus *bus;
> +	int tried_times = 0;
> +	struct resource_list_x head;
> +
> + 	head.next = NULL;
> +	do { /* loop at most 2 times */
> +		/* Depth first, calculate sizes and alignments of all
> +		   subordinate buses. */
> +		list_for_each_entry(bus, &pci_root_buses, node) {
> +			pci_bus_size_bridges(bus);
> +		}
> +		/* Depth last, allocate resources and update the hardware. */
> +		list_for_each_entry(bus, &pci_root_buses, node) {
> +			__pci_bus_assign_resources(bus, &head);
> +		}
> +		/* any device complain? */
> +		if (!head.next)
> +			goto enable_and_dump;
> +
> +		/* do we care if any device complained? */
> +		if (pci_override != PCI_OVERRIDE_CONFLICT) {
> +			free_failed_list(&head);
> +			goto enable_and_dump;
> +		}
> +		printk(KERN_INFO "PCI: No. %d try to assign unassigned res\n",
> +			tried_times+1);
>  
> -	/* Depth first, calculate sizes and alignments of all
> -	   subordinate buses. */
> -	list_for_each_entry(bus, &pci_root_buses, node) {
> -		pci_bus_size_bridges(bus);
> -	}
> -	/* Depth last, allocate resources and update the hardware. */
> -	list_for_each_entry(bus, &pci_root_buses, node) {
> -		pci_bus_assign_resources(bus);
> +		pci_release_resources(&head);
> +	} while (!tried_times++);
> +
> +enable_and_dump:
> +	list_for_each_entry(bus, &pci_root_buses, node)
>  		pci_enable_bridges(bus);
> -	}
>  
>  	/* dump the resource on buses */
> -	list_for_each_entry(bus, &pci_root_buses, node) {
> +	list_for_each_entry(bus, &pci_root_buses, node)
>  		pci_bus_dump_resources(bus);
> -	}
>  }
>  
>  void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index c8d95e3..3449297 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1360,6 +1360,12 @@ extern u8 pci_cache_line_size;
>  extern unsigned long pci_hotplug_io_size;
>  extern unsigned long pci_hotplug_mem_size;
>  
> +extern int pci_override;
> +#define  PCI_OVERRIDE_OFF	     1
> +#define  PCI_OVERRIDE_CONFLICT	     2
> +#define  PCI_OVERRIDE_ALWAYS	     3
> +#define  PCI_OVERRIDE_DEVICE	     4
> +
>  int pcibios_add_platform_entries(struct pci_dev *dev);
>  void pcibios_disable_device(struct pci_dev *dev);
>  int pcibios_set_pcie_reset_state(struct pci_dev *dev,
