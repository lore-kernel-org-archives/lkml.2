Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab1LOTuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:50:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60139 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1LOTuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:50:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC][PATCH 1/4] ahci: port legacy pm interface to struct dev_pm_ops
Date: Thu, 15 Dec 2011 20:53:10 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
References: <1323954769-3918-1-git-send-email-ming.m.lin@intel.com> <1323954769-3918-2-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1323954769-3918-2-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201112152053.10535.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 15, 2011, Lin Ming wrote:
> So we can add runtime pm callbacks later.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/ata/ahci.c |   61 +++++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 41 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index cf26222..c745603 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -84,8 +84,9 @@ static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
>  static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
>  				unsigned long deadline);
>  #ifdef CONFIG_PM
> -static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
> -static int ahci_pci_device_resume(struct pci_dev *pdev);
> +static int ahci_pci_device_suspend(struct device *dev);
> +static int ahci_pci_device_hibernate(struct device *dev);
> +static int ahci_pci_device_resume(struct device *dev);
>  #endif
>  
>  static struct scsi_host_template ahci_sht = {
> @@ -400,6 +401,11 @@ static const struct pci_device_id ahci_pci_tbl[] = {
>  	{ }	/* terminate list */
>  };
>  
> +static struct dev_pm_ops ahci_pci_pm_ops = {
> +	.suspend		= ahci_pci_device_suspend,
> +	.resume			= ahci_pci_device_resume,
> +	.poweroff		= ahci_pci_device_hibernate,
> +};

So seem to have forgotten about .restore().  Please define it at least or
resume from hibernation will be broken.

Also, are .freeze() and .thaw() callbacks really unnecessary?

Rafael


>  static struct pci_driver ahci_pci_driver = {
>  	.name			= DRV_NAME,
> @@ -407,8 +413,9 @@ static struct pci_driver ahci_pci_driver = {
>  	.probe			= ahci_init_one,
>  	.remove			= ata_pci_remove_one,
>  #ifdef CONFIG_PM
> -	.suspend		= ahci_pci_device_suspend,
> -	.resume			= ahci_pci_device_resume,
> +	.driver			= {
> +		.pm = &ahci_pci_pm_ops
> +	},
>  #endif
>  };
>  
> @@ -567,37 +574,51 @@ static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
>  }
>  
>  #ifdef CONFIG_PM
> -static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
> +static int ahci_pci_device_suspend_common(struct pci_dev *pdev, pm_message_t mesg)
>  {
>  	struct ata_host *host = dev_get_drvdata(&pdev->dev);
>  	struct ahci_host_priv *hpriv = host->private_data;
>  	void __iomem *mmio = hpriv->mmio;
>  	u32 ctl;
>  
> -	if (mesg.event & PM_EVENT_SUSPEND &&
> -	    hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
> +	/* AHCI spec rev1.1 section 8.3.3:
> +	 * Software must disable interrupts prior to requesting a
> +	 * transition of the HBA to D3 state.
> +	 */
> +	ctl = readl(mmio + HOST_CTL);
> +	ctl &= ~HOST_IRQ_EN;
> +	writel(ctl, mmio + HOST_CTL);
> +	readl(mmio + HOST_CTL); /* flush */
> +
> +	return ata_pci_device_suspend(pdev, mesg);
> +}
> +
> +static int ahci_pci_device_suspend(struct device *dev)
> +{
> +	struct ata_host *host = dev_get_drvdata(dev);
> +	struct ahci_host_priv *hpriv = host->private_data;
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	if (hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
>  		dev_err(&pdev->dev,
>  			"BIOS update required for suspend/resume\n");
>  		return -EIO;
>  	}
>  
> -	if (mesg.event & PM_EVENT_SLEEP) {
> -		/* AHCI spec rev1.1 section 8.3.3:
> -		 * Software must disable interrupts prior to requesting a
> -		 * transition of the HBA to D3 state.
> -		 */
> -		ctl = readl(mmio + HOST_CTL);
> -		ctl &= ~HOST_IRQ_EN;
> -		writel(ctl, mmio + HOST_CTL);
> -		readl(mmio + HOST_CTL); /* flush */
> -	}
> +	return ahci_pci_device_suspend_common(pdev, PMSG_SUSPEND);
> +}
>  
> -	return ata_pci_device_suspend(pdev, mesg);
> +static int ahci_pci_device_hibernate(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	return ahci_pci_device_suspend_common(pdev, PMSG_HIBERNATE);
>  }
>  
> -static int ahci_pci_device_resume(struct pci_dev *pdev)
> +static int ahci_pci_device_resume(struct device *dev)
>  {
> -	struct ata_host *host = dev_get_drvdata(&pdev->dev);
> +	struct ata_host *host = dev_get_drvdata(dev);
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	int rc;
>  
>  	rc = ata_pci_device_do_resume(pdev);
> 

