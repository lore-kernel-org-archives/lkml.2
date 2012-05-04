Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab2EDTuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:50:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33982 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759565Ab2EDTux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:50:53 -0400
MIME-Version: 1.0
In-Reply-To: <1336119221-21146-4-git-send-email-ying.huang@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <1336119221-21146-4-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 May 2012 13:50:30 -0600
Message-ID: <CAErSpo59RkMo_=8E4ki+f99yDrep5ZjRY5J1CdLoMFws+n_XuQ@mail.gmail.com>
Subject: Re: [RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
To: Huang Ying <ying.huang@intel.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 2:13 AM, Huang Ying <ying.huang@intel.com> wrote:
> From: Zheng Yan <zheng.z.yan@intel.com>
>
> This patch adds runtime PM support to PCIe port.  This is needed by
> PCIe D3cold support, where PCIe device in slot may be powered on/off
> by PCIe port.

I assume this works for integrated PCIe devices as well as those that
are plugged into a slot and can be physically removed -- maybe the
text "in slot" is superfluous?

> Because runtime suspend is broken for some chipset, a white list is
> used to enable runtime PM support for only chipset known to work.

A whitelist requires perpetual maintenance.  Every time a new working
chipset comes out, you have to update the whitelist.  That doesn't
seem right.

> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/pci/pci.c              |    9 +++++++++
>  drivers/pci/pcie/portdrv_pci.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+)
>
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1476,6 +1476,15 @@ bool pci_check_pme_status(struct pci_dev
>  */
>  static int pci_pme_wakeup(struct pci_dev *dev, void *pme_poll_reset)
>  {
> +       struct pci_dev *bridge = dev->bus->self;
> +
> +       /*
> +        * If bridge is in low power state, the configuration space of
> +        * subordinate devices may be not accessible
> +        */

This comment would make more sense as "If the upstream bridge is in a
low power state, the configuration space of this device is not
accessible."

> +       if (bridge && bridge->current_state != PCI_D0)
> +               return 0;
> +
>        if (pme_poll_reset && dev->pme_poll)
>                dev->pme_poll = false;
>
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
>  #include <linux/pm.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/init.h>
>  #include <linux/pcieport_if.h>
>  #include <linux/aer.h>
> @@ -99,6 +100,27 @@ static int pcie_port_resume_noirq(struct
>        return 0;
>  }
>
> +#ifdef CONFIG_PM_RUNTIME
> +static int pcie_port_runtime_suspend(struct device *dev)
> +{
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +
> +       pci_save_state(pdev);
> +       return 0;
> +}
> +
> +static int pcie_port_runtime_resume(struct device *dev)
> +{
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +
> +       pci_restore_state(pdev);
> +       return 0;
> +}
> +#else
> +#define pcie_port_runtime_suspend      NULL
> +#define pcie_port_runtime_resume       NULL
> +#endif
> +
>  static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>        .suspend        = pcie_port_device_suspend,
>        .resume         = pcie_port_device_resume,
> @@ -107,6 +129,8 @@ static const struct dev_pm_ops pcie_port
>        .poweroff       = pcie_port_device_suspend,
>        .restore        = pcie_port_device_resume,
>        .resume_noirq   = pcie_port_resume_noirq,
> +       .runtime_suspend = pcie_port_runtime_suspend,
> +       .runtime_resume = pcie_port_runtime_resume,
>  };
>
>  #define PCIE_PORTDRV_PM_OPS    (&pcie_portdrv_pm_ops)
> @@ -117,6 +141,18 @@ static const struct dev_pm_ops pcie_port
>  #endif /* !PM */
>
>  /*
> + * PCIe port runtime suspend is broken for some chipset, so use a
> + * white list to disable runtime PM for these chipset.

If you're *disabling* runtime PM for these chipsets, I'd call this a
blacklist (and a blacklist makes more sense to me from a maintenance
standpoint, because you only have to update it when new broken chips
are discovered).

> + */
> +static const struct pci_device_id port_runtime_pm_pci_ids[] = {
> +       { PCI_VDEVICE(INTEL, 0x1e10), },
> +       { PCI_VDEVICE(INTEL, 0x1e16), },
> +       { PCI_VDEVICE(INTEL, 0x1e18), },
> +       { PCI_VDEVICE(INTEL, 0x1e1c), },
> +       { /* end: all zeroes */ }
> +};
> +
> +/*
>  * pcie_portdrv_probe - Probe PCI-Express port devices
>  * @dev: PCI-Express port device being probed
>  *
> @@ -144,12 +180,16 @@ static int __devinit pcie_portdrv_probe(
>                return status;
>
>        pci_save_state(dev);
> +       if (pci_match_id(port_runtime_pm_pci_ids, dev))
> +               pm_runtime_put_noidle(&dev->dev);
>
>        return 0;
>  }
>
>  static void pcie_portdrv_remove(struct pci_dev *dev)
>  {
> +       if (pci_match_id(port_runtime_pm_pci_ids, dev))
> +               pm_runtime_get_noresume(&dev->dev);
>        pcie_port_device_remove(dev);
>        pci_disable_device(dev);
>  }
