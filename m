Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab2FOW6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:58:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:50280 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758184Ab2FOW6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:58:34 -0400
Message-ID: <1339801070.9220.211.camel@pasglop>
Subject: Re: [PATCH] devicetree: add helper inline for retrieving a node's
 full name
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 16 Jun 2012 08:57:50 +1000
In-Reply-To: <1339782625-28192-1-git-send-email-grant.likely@secretlab.ca>
References: <1339782625-28192-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 11:50 -0600, Grant Likely wrote:
> The pattern (np ? np->full_name : "<none>") is rather common in the
> kernel, but can also make for quite long lines.  This patch adds a new
> inline function, of_node_full_name() so that the test for a valid node
> pointer doesn't need to be open coded at all call sites.

s/of_node_full_name/of_node_path ?

Cheers,
Ben.

> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/microblaze/pci/pci-common.c       |    6 ++----
>  arch/powerpc/kernel/pci-common.c       |    6 ++----
>  arch/powerpc/kernel/vio.c              |    5 ++---
>  arch/powerpc/platforms/cell/iommu.c    |    3 +--
>  arch/powerpc/platforms/pseries/iommu.c |    2 +-
>  arch/sparc/kernel/of_device_64.c       |    2 +-
>  drivers/of/base.c                      |    2 +-
>  drivers/of/irq.c                       |    2 +-
>  include/linux/of.h                     |   10 ++++++++++
>  kernel/irq/irqdomain.c                 |    8 ++++----
>  10 files changed, 25 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
> index ed22bfc..ca8f6e7 100644
> --- a/arch/microblaze/pci/pci-common.c
> +++ b/arch/microblaze/pci/pci-common.c
> @@ -249,8 +249,7 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
>  	} else {
>  		pr_debug(" Got one, spec %d cells (0x%08x 0x%08x...) on %s\n",
>  			 oirq.size, oirq.specifier[0], oirq.specifier[1],
> -			 oirq.controller ? oirq.controller->full_name :
> -			 "<default>");
> +			 of_node_full_name(oirq.controller));
>  
>  		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
>  					     oirq.size);
> @@ -1493,8 +1492,7 @@ static void __devinit pcibios_scan_phb(struct pci_controller *hose)
>  	struct pci_bus *bus;
>  	struct device_node *node = hose->dn;
>  
> -	pr_debug("PCI: Scanning PHB %s\n",
> -		 node ? node->full_name : "<NO NAME>");
> +	pr_debug("PCI: Scanning PHB %s\n", of_node_full_name(node));
>  
>  	pcibios_setup_phb_resources(hose, &resources);
>  
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index 8e78e93..886c254 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -248,8 +248,7 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
>  	} else {
>  		pr_debug(" Got one, spec %d cells (0x%08x 0x%08x...) on %s\n",
>  			 oirq.size, oirq.specifier[0], oirq.specifier[1],
> -			 oirq.controller ? oirq.controller->full_name :
> -			 "<default>");
> +			 of_node_full_name(oirq.controller));
>  
>  		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
>  					     oirq.size);
> @@ -1628,8 +1627,7 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
>  	struct device_node *node = hose->dn;
>  	int mode;
>  
> -	pr_debug("PCI: Scanning PHB %s\n",
> -		 node ? node->full_name : "<NO NAME>");
> +	pr_debug("PCI: Scanning PHB %s\n", of_node_full_name(node));
>  
>  	/* Get some IO space for the new PHB */
>  	pcibios_setup_phb_io_space(hose);
> diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
> index cb87301..63f72ed 100644
> --- a/arch/powerpc/kernel/vio.c
> +++ b/arch/powerpc/kernel/vio.c
> @@ -1296,8 +1296,7 @@ static void __devinit vio_dev_release(struct device *dev)
>  	struct iommu_table *tbl = get_iommu_table_base(dev);
>  
>  	if (tbl)
> -		iommu_free_table(tbl, dev->of_node ?
> -			dev->of_node->full_name : dev_name(dev));
> +		iommu_free_table(tbl, of_node_full_name(dev->of_node));
>  	of_node_put(dev->of_node);
>  	kfree(to_vio_dev(dev));
>  }
> @@ -1509,7 +1508,7 @@ static ssize_t devspec_show(struct device *dev,
>  {
>  	struct device_node *of_node = dev->of_node;
>  
> -	return sprintf(buf, "%s\n", of_node ? of_node->full_name : "none");
> +	return sprintf(buf, "%s\n", of_node_full_name(of_node));
>  }
>  
>  static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
> diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
> index b9f509a..b673200 100644
> --- a/arch/powerpc/platforms/cell/iommu.c
> +++ b/arch/powerpc/platforms/cell/iommu.c
> @@ -552,8 +552,7 @@ static struct iommu_table *cell_get_iommu_table(struct device *dev)
>  	iommu = cell_iommu_for_node(dev_to_node(dev));
>  	if (iommu == NULL || list_empty(&iommu->windows)) {
>  		printk(KERN_ERR "iommu: missing iommu for %s (node %d)\n",
> -		       dev->of_node ? dev->of_node->full_name : "?",
> -		       dev_to_node(dev));
> +		       of_node_full_name(dev->of_node), dev_to_node(dev));
>  		return NULL;
>  	}
>  	window = list_entry(iommu->windows.next, struct iommu_window, list);
> diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
> index 0915b1a..aab5fbc 100644
> --- a/arch/powerpc/platforms/pseries/iommu.c
> +++ b/arch/powerpc/platforms/pseries/iommu.c
> @@ -1051,7 +1051,7 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
>  	if (!pdn || !PCI_DN(pdn)) {
>  		printk(KERN_WARNING "pci_dma_dev_setup_pSeriesLP: "
>  		       "no DMA window found for pci dev=%s dn=%s\n",
> -				 pci_name(dev), dn? dn->full_name : "<null>");
> +				 pci_name(dev), of_node_full_name(dn));
>  		return;
>  	}
>  	pr_debug("  parent is %s\n", pdn->full_name);
> diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
> index 7a3be6f..7bbdc26 100644
> --- a/arch/sparc/kernel/of_device_64.c
> +++ b/arch/sparc/kernel/of_device_64.c
> @@ -580,7 +580,7 @@ static unsigned int __init build_one_device_irq(struct platform_device *op,
>  				printk("%s: Apply [%s:%x] imap --> [%s:%x]\n",
>  				       op->dev.of_node->full_name,
>  				       pp->full_name, this_orig_irq,
> -				       (iret ? iret->full_name : "NULL"), irq);
> +				       of_node_full_name(iret), irq);
>  
>  			if (!iret)
>  				break;
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index d9bfd49..9282d4c 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1173,7 +1173,7 @@ static void of_alias_add(struct alias_prop *ap, struct device_node *np,
>  	ap->stem[stem_len] = 0;
>  	list_add_tail(&ap->link, &aliases_lookup);
>  	pr_debug("adding DT alias:%s: stem=%s id=%i node=%s\n",
> -		 ap->alias, ap->stem, ap->id, np ? np->full_name : NULL);
> +		 ap->alias, ap->stem, ap->id, of_node_full_name(np));
>  }
>  
>  /**
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 9cf0060..ff8ab7b 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -255,7 +255,7 @@ int of_irq_map_raw(struct device_node *parent, const __be32 *intspec,
>  
>  	skiplevel:
>  		/* Iterate again with new parent */
> -		pr_debug(" -> new parent: %s\n", newpar ? newpar->full_name : "<>");
> +		pr_debug(" -> new parent: %s\n", of_node_full_name(newpar));
>  		of_node_put(ipar);
>  		ipar = newpar;
>  		newpar = NULL;
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 2ec1083..1012377 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -163,6 +163,11 @@ static inline int of_node_to_nid(struct device_node *np) { return -1; }
>  #define of_node_to_nid of_node_to_nid
>  #endif
>  
> +static inline const char* of_node_full_name(struct device_node *np)
> +{
> +	return np ? np->full_name : "<no-node>";
> +}
> +
>  extern struct device_node *of_find_node_by_name(struct device_node *from,
>  	const char *name);
>  #define for_each_node_by_name(dn, name) \
> @@ -303,6 +308,11 @@ const char *of_prop_next_string(struct property *prop, const char *cur);
>  
>  #else /* CONFIG_OF */
>  
> +static inline const char* of_node_full_name(struct device_node *np)
> +{
> +	return "<no-node>";
> +}
> +
>  static inline bool of_have_populated_dt(void)
>  {
>  	return false;
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 41c1564..38c5eb8 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -448,7 +448,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  	}
>  
>  	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
> -		hwirq, domain->of_node ? domain->of_node->full_name : "null", virq);
> +		hwirq, of_node_full_name(domain->of_node), virq);
>  
>  	return virq;
>  }
> @@ -477,7 +477,7 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
>  			return intspec[0];
>  #endif
>  		pr_warning("no irq domain found for %s !\n",
> -			   controller->full_name);
> +			   of_node_full_name(controller));
>  		return 0;
>  	}
>  
> @@ -725,8 +725,8 @@ static int virq_debug_show(struct seq_file *m, void *private)
>  			data = irq_desc_get_chip_data(desc);
>  			seq_printf(m, data ? "0x%p  " : "  %p  ", data);
>  
> -			if (desc->irq_data.domain && desc->irq_data.domain->of_node)
> -				p = desc->irq_data.domain->of_node->full_name;
> +			if (desc->irq_data.domain)
> +				p = of_node_full_name(desc->irq_data.domain->of_node);
>  			else
>  				p = none;
>  			seq_printf(m, "%s\n", p);


