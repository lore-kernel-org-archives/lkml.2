Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966400Ab2EOSsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:48:50 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965807Ab2EOSst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:48:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH -v3 1/2] PCIe: Add runtime PM support to PCIe port
Date: Tue, 15 May 2012 20:53:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1337065211-19525-1-git-send-email-ying.huang@intel.com> <1337065211-19525-2-git-send-email-ying.huang@intel.com>
In-Reply-To: <1337065211-19525-2-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205152053.44885.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 15, 2012, Huang Ying wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> This patch adds runtime PM support to PCIe port.  This is needed by
> PCIe D3cold support, where PCIe device without ACPI node may be
> powered on/off by PCIe port.
> 
> Because runtime suspend is broken for some chipsets, a black list is
> used to disable runtime PM support for these chipsets.
> 
> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> ---
>  drivers/pci/pci.c              |   10 ++++++++++
>  drivers/pci/pcie/portdrv_pci.c |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1517,6 +1517,16 @@ static void pci_pme_list_scan(struct wor
>  	if (!list_empty(&pci_pme_list)) {
>  		list_for_each_entry_safe(pme_dev, n, &pci_pme_list, list) {
>  			if (pme_dev->dev->pme_poll) {
> +				struct pci_dev *bridge;
> +
> +				bridge = pme_dev->dev->bus->self;
> +				/*
> +				 * If bridge is in low power state, the
> +				 * configuration space of subordinate devices
> +				 * may be not accessible
> +				 */
> +				if (bridge && bridge->current_state != PCI_D0)
> +					continue;
>  				pci_pme_wakeup(pme_dev->dev, NULL);
>  			} else {
>  				list_del(&pme_dev->list);
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
> @@ -99,6 +100,21 @@ static int pcie_port_resume_noirq(struct
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME
> +static int pcie_port_runtime_suspend(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static int pcie_port_runtime_resume(struct device *dev)
> +{
> +	return 0;
> +}

Do we need those empty definitions?  If so, it might be just one
function.

The patch looks good otherwise.

Thanks,
Rafael


> +#else
> +#define pcie_port_runtime_suspend	NULL
> +#define pcie_port_runtime_resume	NULL
> +#endif
> +
>  static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>  	.suspend	= pcie_port_device_suspend,
>  	.resume		= pcie_port_device_resume,
> @@ -107,6 +123,8 @@ static const struct dev_pm_ops pcie_port
>  	.poweroff	= pcie_port_device_suspend,
>  	.restore	= pcie_port_device_resume,
>  	.resume_noirq	= pcie_port_resume_noirq,
> +	.runtime_suspend = pcie_port_runtime_suspend,
> +	.runtime_resume = pcie_port_runtime_resume,
>  };
>  
>  #define PCIE_PORTDRV_PM_OPS	(&pcie_portdrv_pm_ops)
> @@ -117,6 +135,14 @@ static const struct dev_pm_ops pcie_port
>  #endif /* !PM */
>  
>  /*
> + * PCIe port runtime suspend is broken for some chipsets, so use a
> + * black list to disable runtime PM for these chipsets.
> + */
> +static const struct pci_device_id port_runtime_pm_black_list[] = {
> +	{ /* end: all zeroes */ }
> +};
> +
> +/*
>   * pcie_portdrv_probe - Probe PCI-Express port devices
>   * @dev: PCI-Express port device being probed
>   *
> @@ -144,12 +170,16 @@ static int __devinit pcie_portdrv_probe(
>  		return status;
>  
>  	pci_save_state(dev);
> +	if (!pci_match_id(port_runtime_pm_black_list, dev))
> +		pm_runtime_put_noidle(&dev->dev);
>  
>  	return 0;
>  }
>  
>  static void pcie_portdrv_remove(struct pci_dev *dev)
>  {
> +	if (!pci_match_id(port_runtime_pm_black_list, dev))
> +		pm_runtime_get_noresume(&dev->dev);
>  	pcie_port_device_remove(dev);
>  	pci_disable_device(dev);
>  }
> 
> 

