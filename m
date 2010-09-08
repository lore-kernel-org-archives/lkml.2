Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0IHUfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:35:53 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1756 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0IHUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:35:47 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC PATCH 1/1] PCI: override BIOS/firmware resource allocation
Date: Wed, 8 Sep 2010 14:35:13 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20100908065958.GA27447@ram-laptop>
In-Reply-To: <20100908065958.GA27447@ram-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009081435.14209.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 08, 2010 12:59:58 am Ram Pai wrote:
> PCI: override BIOS/firmware resource allocation through command line parameters
> 
> git commit 977d17bb1749517b353874ccdc9b85abc7a58c2a
> released  and   reallocated  all resources when allocation of  any
> resource  of  any  type,   ioport and memory, failed. This  caused
> failure to reallocate fragile  io  port  resources, as reported in
> https://bugzilla.kernel.org/show_bug.cgi?id=15960
> 
> The problem was solved by reverting the commit, through
> git commit  769d9968e42c995eaaf61ac5583d998f32e0769a.
> 
> However reverting the original patch fails MMIO resource allocation
> for SRIOV PCI-Bars on some platforms. Especially on  platforms
> where the BIOS is unaware of SRIOV resource BARs.
> 
> The following code, an idea  proposed by Linus, allows the user
> to tailor the resource allocation for devices through kernel 
> command line parameter. Details of the idea can be found at
> http://marc.info/?l=linux-kernel&m=127846075028242&w=2

This changelog doesn't really tell me why we want this patch.
I see it has something to do with BARs of SR-IOV devices, but
otherwise, it's just low-level details about past history.

What specific problem are you solving?  Does this patch enable
us to assign resources to a device that previously had none?
A concrete example might help.

> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index f084af0..eec068f 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1961,6 +1961,21 @@ and is between 256 and 4096 characters. It is defined in the file
>  				PAGE_SIZE is used as alignment.
>  				PCI-PCI bridge can be specified, if resource
>  				windows need to be expanded.
> +		override=[off, conflict, always, <device>]
> +				off : Do not override BIOS/firmware allocations. This is the 
> +					default
> +				conflict : override BIOS/firmware allocations if conflicting
> +					or not allocated.
> +				always : override all BIOS/firmware allocations
> +				<device>: Format [<domain>:]<bus>:<slot>.<func>[; ...]
> +					override BIOS/firmware allocations of specified
> +					devices
> +
> +		clear=<device>
> +				<device>: Format [<domain>:]<bus>:<slot>.<func>[; ...]
> +					release BIOS/firmware allocations of specified
> +					devices. By default no allocations are cleared.

I object in principle to new kernel parameters that users might need
to use just to get their box to work.  How would a user know that he
might need this option?  Isn't it possible for the kernel to figure
that out automatically?

Bjorn

>  		ecrc=		Enable/disable PCIe ECRC (transaction layer
>  				end-to-end CRC checking).
>  				bios: Use BIOS/firmware settings. This is the
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 7fa3cbd..5676416 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2984,6 +2984,85 @@ void __weak pci_fixup_cardbus(struct pci_bus *bus)
>  }
>  EXPORT_SYMBOL(pci_fixup_cardbus);
>  
> +#define RESOURCE_RELEASE_PARAM_SIZE COMMAND_LINE_SIZE
> +static char __initdata resource_release_param[RESOURCE_RELEASE_PARAM_SIZE];
> +int pci_override=PCI_OVERRIDE_OFF;
> +
> +/*
> + * Return success if 'dev' is listed as one of the devices
> + * through the kernel command line
> + * pci=[override|clear]=device[;device]*
> + */
> +int __init is_pci_reset_device(struct pci_dev *dev)
> +{
> +	int seg, bus, slot, func, count;
> +	char *p;
> +
> +	p = resource_release_param;
> +	while (*p) {
> +		count = 0;
> +		if (sscanf(p, "%x:%x:%x.%x%n",
> +			&seg, &bus, &slot, &func, &count) != 4) {
> +			seg = 0;
> +			if (sscanf(p, "%x:%x.%x%n",
> +					&bus, &slot, &func, &count) != 3) {
> +				/* Invalid format */
> +				printk(KERN_ERR "PCI: Can't parse resource_alignment parameter: %s\n",
> +					p);
> +				return 0;
> +			}
> +		}
> +		p += count;
> +		if (seg == pci_domain_nr(dev->bus) &&
> +			bus == dev->bus->number &&
> +			slot == PCI_SLOT(dev->devfn) &&
> +			func == PCI_FUNC(dev->devfn)) {
> +			return 1;
> +		}
> +		if (*p != ';') {
> +			/* End of param or invalid format */
> +			return 0;
> +		}
> +		p++;
> +	}
> +	return 0;
> +}
> +
> +
> +static void __init pci_override_setup(const char *str, int override)
> +{
> +	if (override && !strncmp(str, "off", 3)) {
> +
> +		pci_override = PCI_OVERRIDE_OFF;
> +		printk(KERN_INFO "pci: do not override "
> +			"BIOS/uEFI allocations\n");
> +
> +	} else if (override && !strncmp(str, "conflict", 8)) {
> +
> +		pci_override = PCI_OVERRIDE_CONFLICT;
> +		printk(KERN_INFO "pci: reallocate BIOS/uEFI "
> +			"allocated resources on conflicts\n");
> +
> +	} else if (override && !strncmp(str, "always", 6)) {
> +
> +		pci_override =  PCI_OVERRIDE_ALWAYS;
> +		printk(KERN_INFO "pci: override all BIOS/uEFI allocations\n");
> +
> +	} else {
> +		int count=strlen(str);
> +
> +		pci_override = override ? PCI_OVERRIDE_DEVICE :
> +				PCI_CLEAR_DEVICE;
> +		if (count > RESOURCE_RELEASE_PARAM_SIZE - 1)
> +			count = RESOURCE_RELEASE_PARAM_SIZE - 1;
> +		strncpy(resource_release_param, str, count);
> +		resource_release_param[count] = '\0';
> +		printk(KERN_INFO "pci: %s BIOS/uEFI allocations for %s\n",
> +			 override ? "override" : "clear", resource_release_param);
> +	}
> +	return;
> +}
> +
>  static int __init pci_setup(char *str)
>  {
>  	while (str) {
> @@ -3010,6 +3089,10 @@ static int __init pci_setup(char *str)
>  				pci_hotplug_io_size = memparse(str + 9, &str);
>  			} else if (!strncmp(str, "hpmemsize=", 10)) {
>  				pci_hotplug_mem_size = memparse(str + 10, &str);
> +			} else if (!strncmp(str, "override=", 9)) {
> +				pci_override_setup(str + 9, 1);
> +			} else if (!strncmp(str, "clear=", 6)) {
> +				pci_override_setup(str + 6, 0);
>  			} else {
>  				printk(KERN_ERR "PCI: Unknown option `%s'\n",
>  						str);
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 66cb8f4..e215ee9 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -838,21 +838,195 @@ static void pci_bus_dump_resources(struct pci_bus *bus)
>  	}
>  }
>  
> +static void __init
> +__pci_dev_reset_resource(struct pci_dev *dev,
> +			struct resource_list_x *fail_head)
> +{
> +	int idx, start, end;
> +	struct resource *r;
> +	u16 class = dev->class >> 8;
> +
> +	if (class == PCI_CLASS_BRIDGE_PCI) {
> +		start=PCI_BRIDGE_RESOURCES;
> +		end=PCI_BRIDGE_RESOURCE_END+1;
> +	} else {
> +		start=0;
> +		end=PCI_NUM_RESOURCES;
> +	}
> +
> +	for (idx = start; idx < end; idx++) {
> +		r = &dev->resource[idx];
> +
> +		if (r->flags & IORESOURCE_PCI_FIXED)
> +			continue;
> +
> +		if ( idx == PCI_ROM_RESOURCE ||
> +		      r->flags & IORESOURCE_ROM_ENABLE)
> +		 	continue;		
> +
> +		if (fail_head)
> +			add_to_failed_list(fail_head, dev, r);
> +
> +		/* keep the old size */
> +		r->end = 0;
> +		r->start = 0;
> +		r->flags = 0;
> +	}
> +}
> +
> +/*
> + * reset the resource requirement of the device tree under 'dev'.
> + * Capture and add each resource's original requirement to the list 'head'
> + */
> +static void __init
> +pci_dev_reset_resource(struct pci_dev *dev,
> +			struct resource_list_x *head)
> +{
> +	u16 class = dev->class >> 8;
> +
> +	/* Don't touch classless devices or host bridges or ioapics.  */
> +	if (class == PCI_CLASS_NOT_DEFINED || class == PCI_CLASS_BRIDGE_HOST)
> +		return;
> +
> +	/* Don't touch ioapic devices already enabled by firmware */
> +	if (class == PCI_CLASS_SYSTEM_PIC) {
> +		u16 command;
> +		pci_read_config_word(dev, PCI_COMMAND, &command);
> +		if (command & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY))
> +			return;
> +	}
> +
> +	if (class == PCI_CLASS_BRIDGE_PCI) {
> +		struct pci_bus *bus = dev->subordinate;
> +		if (bus) {
> +			struct pci_dev *dev1;
> +			list_for_each_entry(dev1, &bus->devices, bus_list)
> +				pci_dev_reset_resource(dev1, head);
> +		}
> +	}
> +	__pci_dev_reset_resource(dev, head);
> +	return;
> +}
> +
> +
> +/*
> + * Reset the resource requirement of all devices under 'bus' that
> + * specified by the kernel parameter 'pci=[override|clear]=<device>[;<device>]*'
> + * Capture and add each resource's original requirement to the
> + * list 'head'
> + */
> +static void __init
> +pci_bus_reset_resource(struct pci_bus *bus,
> +			struct resource_list_x *head)
> +{
> +	struct pci_bus *b;
> +	struct pci_dev *dev;
> +
> +	if (bus->self && (pci_override == PCI_OVERRIDE_ALWAYS ||
> +				is_pci_reset_device(bus->self))) {
> +		pci_dev_reset_resource(bus->self, head);
> +		return;
> +	}
> +
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		if (is_pci_reset_device(dev)) {
> +			pci_dev_reset_resource(dev, head);
> +			continue;
> +		}
> +		if ((b = dev->subordinate))
> +			pci_bus_reset_resource(b, head);
> +	}
> +	return;
> +}
> +
> +/*
> + * Release all the resources in the list 'head'.
> + */
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
> +	}
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
> +
>  void __init
>  pci_assign_unassigned_resources(void)
>  {
>  	struct pci_bus *bus;
> +	int tried_times = 0;
> +	struct resource_list_x head;
> +
> +	head.next = NULL;
>  
> -	/* Depth first, calculate sizes and alignments of all
> -	   subordinate buses. */
>  	list_for_each_entry(bus, &pci_root_buses, node) {
> -		pci_bus_size_bridges(bus);
> +		if (pci_override == PCI_OVERRIDE_DEVICE ||
> +			  pci_override == PCI_OVERRIDE_ALWAYS) {
> +			pci_bus_reset_resource(bus, &head);
> +			pci_release_resources(&head);
> +		} else if (pci_override == PCI_CLEAR_DEVICE) {
> +			pci_bus_reset_resource(bus, NULL);
> +		}
>  	}
> -	/* Depth last, allocate resources and update the hardware. */
> -	list_for_each_entry(bus, &pci_root_buses, node) {
> -		pci_bus_assign_resources(bus);
> +
> +	do { /* loop at most 2 times */
> +		/* Depth first, calculate sizes and alignments of all
> +		   subordinate buses. */
> +		list_for_each_entry(bus, &pci_root_buses, node) {
> +			pci_bus_size_bridges(bus);
> +		}
> +
> +		/* Depth last, allocate resources and update the hardware. */
> +		list_for_each_entry(bus, &pci_root_buses, node) {
> +			__pci_bus_assign_resources(bus, &head);
> +		}
> +
> +		/* happily exit the loop if all devices are happy */
> +		if (!head.next)
> +			goto enable_and_dump;
> +
> +		/* dont' care if any device complained, unless asked to care */
> +		if (pci_override != PCI_OVERRIDE_CONFLICT) {
> +			free_failed_list(&head);
> +			goto enable_and_dump;
> +		}
> +
> +		printk(KERN_INFO "PCI: No. %d try to assign unassigned res\n",
> +				 tried_times);
> +
> +		pci_release_resources(&head);
> +
> +	} while (!tried_times++);
> +
> +enable_and_dump:
> +	/* Depth last, update the hardware. */
> +	list_for_each_entry(bus, &pci_root_buses, node)
>  		pci_enable_bridges(bus);
> -	}
>  
>  	/* dump the resource on buses */
>  	list_for_each_entry(bus, &pci_root_buses, node) {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index b1d1795..c001005 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1357,10 +1357,18 @@ extern u8 pci_cache_line_size;
>  extern unsigned long pci_hotplug_io_size;
>  extern unsigned long pci_hotplug_mem_size;
>  
> +extern int pci_override;
> +#define  PCI_OVERRIDE_OFF 	1
> +#define  PCI_OVERRIDE_CONFLICT	2
> +#define  PCI_OVERRIDE_ALWAYS 	3
> +#define  PCI_OVERRIDE_DEVICE 	4
> +#define  PCI_CLEAR_DEVICE 	5
> +
>  int pcibios_add_platform_entries(struct pci_dev *dev);
>  void pcibios_disable_device(struct pci_dev *dev);
>  int pcibios_set_pcie_reset_state(struct pci_dev *dev,
>  				 enum pcie_reset_state state);
> +int is_pci_reset_device(struct pci_dev *dev);
>  
>  #ifdef CONFIG_PCI_MMCONFIG
>  extern void __init pci_mmcfg_early_init(void);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
