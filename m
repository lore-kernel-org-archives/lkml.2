Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140Ab1J3PXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 11:23:33 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35683 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1J3PXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 11:23:32 -0400
Message-ID: <4EAD6BED.6040004@linux.vnet.ibm.com>
Date: Sun, 30 Oct 2011 20:53:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@gmail.com>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] ahci_platform: add suspend & resume support
References: <20111030142122.560216e2@ustc>
In-Reply-To: <20111030142122.560216e2@ustc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding linux-pm mailing list to CC, since this is PM related.

On 10/30/2011 11:51 AM, JiSheng Zhang wrote:
> 
> Signed-off-by: JiSheng Zhang <jszhang3@gmail.com>
> ---
>  drivers/ata/ahci_platform.c |   54 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 54 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index c03277d..60ff9eb 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -202,12 +202,66 @@ static int __devexit ahci_remove(struct platform_device *pdev)
>  	return 0;
>  }
> 
> +#ifdef CONFIG_PM
> +static int ahci_suspend(struct platform_device *pdev, pm_message_t mesg)
> +{
> +	struct ata_host *host = dev_get_drvdata(&pdev->dev);
> +	struct ahci_host_priv *hpriv = host->private_data;
> +	void __iomem *mmio = hpriv->mmio;
> +	u32 ctl;
> +
> +	if (mesg.event & PM_EVENT_SLEEP) {
> +		/* AHCI spec rev1.1 section 8.3.3:
> +		 * Software must disable interrupts prior to requesting a
> +		 * transition of the HBA to D3 state.
> +		 */
> +		ctl = readl(mmio + HOST_CTL);
> +		ctl &= ~HOST_IRQ_EN;
> +		writel(ctl, mmio + HOST_CTL);
> +		readl(mmio + HOST_CTL); /* flush */
> +	}
> +
> +	return ata_host_suspend(host, mesg);
> +}
> +
> +static int ahci_resume(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ahci_platform_data *pdata = dev->platform_data;
> +	struct ata_host *host = dev_get_drvdata(dev);
> +	struct ahci_host_priv *hpriv = host->private_data;
> +	int rc;
> +
> +	if (pdata && pdata->init) {
> +		rc = pdata->init(dev, hpriv->mmio);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
> +		rc = ahci_reset_controller(host);
> +		if (rc)
> +			return rc;
> +
> +		ahci_init_controller(host);
> +	}
> +
> +	ata_host_resume(host);
> +
> +	return 0;
> +}
> +#endif
> +
>  static struct platform_driver ahci_driver = {
>  	.remove = __devexit_p(ahci_remove),
>  	.driver = {
>  		.name = "ahci",
>  		.owner = THIS_MODULE,
>  	},
> +#ifdef CONFIG_PM
> +	.suspend = ahci_suspend,
> +	.resume = ahci_resume,
> +#endif
>  	.id_table	= ahci_devtype,
>  };
> 


-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
