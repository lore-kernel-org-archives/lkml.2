Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0JSUQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:16:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42743 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab0JSUQl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 19 Oct 2010 16:16:41 -0400
Date: Tue, 19 Oct 2010 16:15:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Qing He <qing.he@intel.com>, Yunhong Jiang <yunhong.jiang@intel.com>,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH v4 03/10] xen: remap MSIs into pirqs when
 running as initial domain
Message-ID: <20101019201518.GA9727@dumpdata.com>
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
 <1287487038-6643-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287487038-6643-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
> +{
> +	int irq = -1;
> +	struct physdev_map_pirq map_irq;
> +	int rc;
> +	int pos;
> +	u32 table_offset, bir;
> +
> +	memset(&map_irq, 0, sizeof(map_irq));
> +	map_irq.domid = DOMID_SELF;
> +	map_irq.type = MAP_PIRQ_TYPE_MSI;
> +	map_irq.index = -1;
> +	map_irq.pirq = -1;
> +	map_irq.bus = dev->bus->number;
> +	map_irq.devfn = dev->devfn;
> +
> +	if (type == PCI_CAP_ID_MSIX) {
> +		pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
> +
> +		pci_read_config_dword(dev, msix_table_offset_reg(pos),
> +					&table_offset);
> +		bir = (u8)(table_offset & PCI_MSIX_FLAGS_BIRMASK);
> +
> +		map_irq.table_base = pci_resource_start(dev, bir);
> +		map_irq.entry_nr = msidesc->msi_attrib.entry_nr;
> +	}
> +
> +	spin_lock(&irq_mapping_update_lock);
> +
> +	irq = find_unbound_irq();
> +
> +	if (irq == -1)
> +		goto out;
> +
> +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
> +	if (rc) {
> +		printk(KERN_WARNING "xen map irq failed %d\n", rc);
> +
> +		dynamic_irq_cleanup(irq);

Looking at include/linux/irq.h, I see this commment:
 /*
330  * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and
331  * irq_free_desc instead.
332  */

So we should use irq_free_desc instead of dynamic_irq_cleanup.
(fyi, I didn't realize this until I started pulling in the sparse_irq
patchset).
> +
> +		irq = -1;
> +		goto out;
> +	}
> +	irq_info[irq] = mk_pirq_info(0, map_irq.pirq, 0, map_irq.index);
> +
> +	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
> +			handle_level_irq,
> +			(type == PCI_CAP_ID_MSIX) ? "msi-x":"msi");
> +
> +out:
> +	spin_unlock(&irq_mapping_update_lock);
> +	return irq;
> +}
> +#endif
> +
