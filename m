Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab1FPNQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:16:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37655 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab1FPNQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:16:15 -0400
Date: Thu, 16 Jun 2011 07:16:13 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: Re: [PATCH 5/5] spi_dw_pci: Add runtime power management
Message-ID: <20110616131613.GF31534@ponder.secretlab.ca>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
 <1308158588-17249-6-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308158588-17249-6-git-send-email-dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:23:08AM -0700, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch adds runtime power management to the PCI variant of the
> designware SPI host controller driver.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Ditto here, can this be moved before the patch 3 rewrite?

g.

> ---
>  drivers/spi/spi-dw-pci.c |   59 +++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/spi/spi-dw.c     |    4 ++-
>  2 files changed, 61 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-dw-pci.c b/drivers/spi/spi-dw-pci.c
> index eb35fa5..d661c2a 100644
> --- a/drivers/spi/spi-dw-pci.c
> +++ b/drivers/spi/spi-dw-pci.c
> @@ -20,6 +20,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/pci.h>
>  #include <linux/slab.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/spi/spi.h>
>  
>  #include "spi-dw.h"
> @@ -91,6 +92,11 @@ static int __devinit spi_pci_probe(struct pci_dev *pdev,
>  
>  	/* PCI hook and SPI hook use the same drv data */
>  	pci_set_drvdata(pdev, dwpci);
> +
> +	pm_suspend_ignore_children(&pdev->dev, true);
> +	pm_runtime_put_noidle(&pdev->dev);
> +	pm_runtime_allow(&pdev->dev);
> +
>  	return 0;
>  
>  err_unmap:
> @@ -110,6 +116,9 @@ static void __devexit spi_pci_remove(struct pci_dev *pdev)
>  
>  	pci_set_drvdata(pdev, NULL);
>  	spi_dw_remove_host(&dwpci->dws);
> +	pm_runtime_forbid(&pdev->dev);
> +	pm_runtime_get_noresume(&pdev->dev);
> +
>  	iounmap(dwpci->dws.regs);
>  	pci_release_region(pdev, 0);
>  	kfree(dwpci);
> @@ -143,16 +152,61 @@ static int spi_resume(struct pci_dev *pdev)
>  		return ret;
>  	return spi_dw_resume_host(&dwpci->dws);
>  }
> +
> +static int spi_dw_pci_runtime_suspend(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
> +	int ret;
> +
> +	dev_dbg(dev, "PCI runtime suspend called\n");
> +
> +	ret = spi_dw_stop_queue(&dwpci->dws);
> +	if (ret == 0)
> +		spi_dw_enable(&dwpci->dws);
> +
> +	return ret;
> +}
> +
> +static int spi_dw_pci_runtime_resume(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
> +
> +	dev_dbg(dev, "pci_runtime_resume called\n");
> +	return spi_dw_resume_host(&dwpci->dws);
> +}
> +
> +static int spi_dw_pci_runtime_idle(struct device *dev)
> +{
> +	int err;
> +
> +	dev_dbg(dev, "pci_runtime_idle called\n");
> +
> +	err = pm_schedule_suspend(dev, 500);
> +	if (err != 0)
> +		return 0;
> +	return -EBUSY;
> +}
> +
>  #else
>  #define spi_suspend	NULL
>  #define spi_resume	NULL
> +#define spi_dw_pci_runtime_suspend NULL
> +#define spi_dw_pci_runtime_resume NULL
> +#define spi_dw_pci_runtime_idle NULL
>  #endif
>  
>  static const struct pci_device_id pci_ids[] __devinitdata = {
> -	/* Intel MID platform SPI controller 0 */
> +	/* Intel Moorestown platform SPI controller 0 */
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0800) },
>  	{},
>  };
> +static const struct dev_pm_ops dw_spi_pm_ops = {
> +	.runtime_suspend = spi_dw_pci_runtime_suspend,
> +	.runtime_resume = spi_dw_pci_runtime_resume,
> +	.runtime_idle = spi_dw_pci_runtime_idle,
> +};
>  
>  static struct pci_driver dw_spi_driver = {
>  	.name =		DRIVER_NAME,
> @@ -161,6 +215,9 @@ static struct pci_driver dw_spi_driver = {
>  	.remove =	__devexit_p(spi_pci_remove),
>  	.suspend =	spi_suspend,
>  	.resume	=	spi_resume,
> +	.driver	=	{
> +		.pm	= &dw_spi_pm_ops,
> +	}, 
>  };
>  
>  static int __init mrst_spi_init(void)
> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
> index 20f94fa..1210460 100644
> --- a/drivers/spi/spi-dw.c
> +++ b/drivers/spi/spi-dw.c
> @@ -22,6 +22,7 @@
>  #include <linux/highmem.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/spi/spi.h>
>  
>  #include "spi-dw.h"
> @@ -438,7 +439,7 @@ static void pump_messages(struct work_struct *work)
>  	struct slave_cfg *controller;
>  	int err = 0;
>  
> -
> +	pm_runtime_get_sync(dws->parent_dev);
>  	message = get_message(dws);
>  
>  	while (message && dws->run != QUEUE_STOPPED) {
> @@ -473,6 +474,7 @@ static void pump_messages(struct work_struct *work)
>  	}
>  	if (dws->run == QUEUE_STOPPED)
>  		drain_message_queue(dws);
> +	pm_runtime_put_sync(dws->parent_dev);
>  }
>  
>  /* spi_device use this to queue in their spi_msg */
> -- 
> 1.7.3.4
> 
> 
> ------------------------------------------------------------------------------
> EditLive Enterprise is the world's most technically advanced content
> authoring tool. Experience the power of Track Changes, Inline Image
> Editing and ensure content is compliant with Accessibility Checking.
> http://p.sf.net/sfu/ephox-dev2dev
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
