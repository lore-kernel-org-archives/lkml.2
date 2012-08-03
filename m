Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2HCLrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 07:47:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab2HCLq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 07:46:58 -0400
Date: Fri, 3 Aug 2012 07:46:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, hbabu@us.ibm.com,
        ishii.hironobu@jp.fujitsu.com, martin.wilck@ts.fujitsu.com
Subject: Re: [RFC][PATCH] Reset PCIe devices to address DMA problem on kdump
 with iommu
Message-ID: <20120803114643.GA28330@redhat.com>
References: <501BB4EF.7080909@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501BB4EF.7080909@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 08:24:31PM +0900, Takao Indoh wrote:
> Hi all,
> 
> This patch adds kernel parameter "reset_pcie_devices" which resets PCIe
> devices at boot time to address DMA problem on kdump with iommu. When
> this parameter is specified, a hot reset is triggered on each PCIe root
> port and downstream port to reset its downstream endpoint.

Hi Takao,

Why not use existing "reset_devices" parameter instead of introducing
a new one?

Thanks
Vivek

> 
> Background:
> A kdump problem about DMA has been discussed for a long time. That is,
> when a kernel is switched to the kdump kernel DMA derived from first
> kernel affects second kernel. Recently this problem surfaces when iommu
> is used for PCI passthrough on KVM guest. In the case of the machine I
> use, when intel_iommu=on is specified, DMAR error is detected in kdump
> kernel and PCI SERR is also detected. Finally kdump fails because some
> devices does not work correctly.
> 
> The root cause is that ongoing DMA from first kernel causes DMAR fault
> because page table of DMAR is initialized while kdump kernel is booting
> up. Therefore to address this problem DMA needs to be stopped before DMAR
> is initialized at kdump kernel boot time. By this patch, PCIe devices
> are reset by hot reset and its DMA is stopped when reset_pcie_devices is
> specified. One problem of this solution is that VGA is reset and the
> monitor blacks out when the link between the port and VGA controller was
> reset. So this patch does not reset the port whose child endpoint is VGA
> device.
> 
> Any comments would be appreciated.
> 
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> ---
>  Documentation/kernel-parameters.txt |    4 +
>  drivers/pci/quirks.c                |   59 ++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index e714a02..e694e9f 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2489,6 +2489,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	reset_devices	[KNL] Force drivers to reset the underlying device
>  			during initialization.
>  
> +	reset_pcie_devices
> +			[PCIE] Reset PCIe endpoint at boot time by sending a
> +			hot reset to root port and downstream port
> +
>  	resume=		[SWSUSP]
>  			Specify the partition device for software suspend
>  			Format:
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 5155317..7f7fc02 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -32,6 +32,65 @@
>  #include "pci.h"
>  
>  /*
> + * Reset PCIe endpoint by sending a hot reset to root port and downstream port
> + */
> +unsigned int reset_pcie_devices;
> +EXPORT_SYMBOL(reset_pcie_devices);
> +static int __init set_reset_pcie_devices(char *str)
> +{
> +	reset_pcie_devices = 1;
> +	return 1;
> +}
> +__setup("reset_pcie_devices", set_reset_pcie_devices);
> +
> +static void __devinit quirk_pcie_device_reset(struct pci_dev *dev)
> +{
> +	struct pci_bus *subordinate;
> +	struct pci_dev *child;
> +	u16 ctrl;
> +
> +	if (!reset_pcie_devices || !pci_is_pcie(dev) || !dev->subordinate ||
> +	    ((dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT) &&
> +	     (dev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM)))
> +		return;
> +
> +	subordinate = dev->subordinate;
> +	list_for_each_entry(child, &subordinate->devices, bus_list) {
> +		if ((child->pcie_type == PCI_EXP_TYPE_UPSTREAM) ||
> +		    (child->pcie_type == PCI_EXP_TYPE_PCI_BRIDGE) ||
> +		    ((child->class >> 16) == PCI_BASE_CLASS_DISPLAY))
> +		/* Don't reset switch, bridge, VGA device */
> +		return;
> +	}
> +
> +	dev_info(&dev->dev, "Reset Secondary bus\n");
> +
> +	list_for_each_entry(child, &subordinate->devices, bus_list) {
> +		dev_info(&child->dev, "save state\n");
> +		pci_save_state(child);
> +	}
> +
> +	/* Assert Secondary Bus Reset */
> +	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
> +	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
> +	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
> +
> +	msleep(2);
> +
> +	/* De-assert Secondary Bus Reset */
> +	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
> +	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
> +
> +	msleep(200);
> +
> +	list_for_each_entry(child, &subordinate->devices, bus_list) {
> +		dev_info(&child->dev, "restore state\n");
> +		pci_restore_state(child);
> +	}
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_pcie_device_reset);
> +
> +/*
>   * Decoding should be disabled for a PCI device during BAR sizing to avoid
>   * conflict. But doing so may cause problems on host bridge and perhaps other
>   * key system devices. For devices that need to have mmio decoding always-on,
