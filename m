Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab2EDTjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:39:10 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53787 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759536Ab2EDTjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:39:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
Date: Fri, 4 May 2012 21:43:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <1336119221-21146-4-git-send-email-ying.huang@intel.com>
In-Reply-To: <1336119221-21146-4-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205042143.54364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 04, 2012, Huang Ying wrote:
> From: Zheng Yan <zheng.z.yan@intel.com>
> 
> This patch adds runtime PM support to PCIe port.  This is needed by
> PCIe D3cold support, where PCIe device in slot may be powered on/off
> by PCIe port.
> 
> Because runtime suspend is broken for some chipset, a white list is
> used to enable runtime PM support for only chipset known to work.
> 
> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/pci/pci.c              |    9 +++++++++
>  drivers/pci/pcie/portdrv_pci.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+)
> 
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1476,6 +1476,15 @@ bool pci_check_pme_status(struct pci_dev
>   */
>  static int pci_pme_wakeup(struct pci_dev *dev, void *pme_poll_reset)
>  {
> +	struct pci_dev *bridge = dev->bus->self;
> +
> +	/*
> +	 * If bridge is in low power state, the configuration space of
> +	 * subordinate devices may be not accessible

Please also say in the comment _when_ this is possible.  That's far from
obvious, because the runtime PM framework generally ensures that parents are
resumed before the children, so the comment should describe the particular
scenario leading to this situation.

> +	 */
> +	if (bridge && bridge->current_state != PCI_D0)
> +		return 0;
> +
>  	if (pme_poll_reset && dev->pme_poll)
>  		dev->pme_poll = false;
>  
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
>  #include <linux/pm.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/init.h>
>  #include <linux/pcieport_if.h>
>  #include <linux/aer.h>
> @@ -99,6 +100,27 @@ static int pcie_port_resume_noirq(struct
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME
> +static int pcie_port_runtime_suspend(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +

A comment explaining why this is needed here would be welcome.

> +	pci_save_state(pdev);
> +	return 0;
> +}
> +
> +static int pcie_port_runtime_resume(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	pci_restore_state(pdev);
> +	return 0;
> +}
> +#else
> +#define pcie_port_runtime_suspend	NULL
> +#define pcie_port_runtime_resume	NULL
> +#endif
> +
>  static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>  	.suspend	= pcie_port_device_suspend,
>  	.resume		= pcie_port_device_resume,
> @@ -107,6 +129,8 @@ static const struct dev_pm_ops pcie_port
>  	.poweroff	= pcie_port_device_suspend,
>  	.restore	= pcie_port_device_resume,
>  	.resume_noirq	= pcie_port_resume_noirq,
> +	.runtime_suspend = pcie_port_runtime_suspend,
> +	.runtime_resume = pcie_port_runtime_resume,
>  };
>  
>  #define PCIE_PORTDRV_PM_OPS	(&pcie_portdrv_pm_ops)
> @@ -117,6 +141,18 @@ static const struct dev_pm_ops pcie_port
>  #endif /* !PM */
>  
>  /*
> + * PCIe port runtime suspend is broken for some chipset, so use a
> + * white list to disable runtime PM for these chipset.
> + */
> +static const struct pci_device_id port_runtime_pm_pci_ids[] = {
> +	{ PCI_VDEVICE(INTEL, 0x1e10), },
> +	{ PCI_VDEVICE(INTEL, 0x1e16), },
> +	{ PCI_VDEVICE(INTEL, 0x1e18), },
> +	{ PCI_VDEVICE(INTEL, 0x1e1c), },
> +	{ /* end: all zeroes */ }
> +};
> +
> +/*
>   * pcie_portdrv_probe - Probe PCI-Express port devices
>   * @dev: PCI-Express port device being probed
>   *
> @@ -144,12 +180,16 @@ static int __devinit pcie_portdrv_probe(
>  		return status;
>  
>  	pci_save_state(dev);
> +	if (pci_match_id(port_runtime_pm_pci_ids, dev))
> +		pm_runtime_put_noidle(&dev->dev);
>  
>  	return 0;
>  }
>  
>  static void pcie_portdrv_remove(struct pci_dev *dev)
>  {
> +	if (pci_match_id(port_runtime_pm_pci_ids, dev))
> +		pm_runtime_get_noresume(&dev->dev);
>  	pcie_port_device_remove(dev);
>  	pci_disable_device(dev);
>  }

Thanks,
Rafael
