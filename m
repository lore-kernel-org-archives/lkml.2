Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab1CXE3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 00:29:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab1CXE3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 00:29:02 -0400
Date: Wed, 23 Mar 2011 22:28:58 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, sameo@linux.intel.com
Subject: Re: [PATCH 1/5] mmc: sdhci: make sdhci-esdhc-imx driver self
 registered
Message-ID: <20110324042858.GD27881@ponder.secretlab.ca>
References: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
 <1300694823-8300-2-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300694823-8300-2-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 04:06:59PM +0800, Shawn Guo wrote:
> The patch turns the common stuff to in sdhci-pltfm.c into functions,
> and add sdhci-esdhc-imx its own .probe and .remove which in turn call
> into the common functions, so that sdhci-esdhc-imx driver registers
> itself and keep all sdhci-esdhc-imx specific things like
> sdhci_esdhc_imx_pdata away from sdhci-pltfm.c which is common.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Hi Shawn,

Thanks for all this work, I think it is the right thing to do.  A few
relatively minor comments below, but otherwise I like it.

g.

> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c |   98 +++++++++++++++++++++++++++++-------
>  drivers/mmc/host/sdhci-pltfm.c     |   84 +++++++++++++++++++++++++++++--
>  drivers/mmc/host/sdhci-pltfm.h     |   11 ++++-

I think this patch should be split in 2.  One patch to refactor
edhci-pltfm* to create the common utility functions, and one patch to
convert the imx driver.

>  3 files changed, 169 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index 9b82910..6585620 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -100,15 +100,39 @@ static unsigned int esdhc_pltfm_get_min_clock(struct sdhci_host *host)
>  	return clk_get_rate(pltfm_host->clk) / 256 / 16;
>  }
>  
> -static int esdhc_pltfm_init(struct sdhci_host *host, struct sdhci_pltfm_data *pdata)
> +static struct sdhci_ops sdhci_esdhc_ops = {
> +	.read_w = esdhc_readw_le,
> +	.write_w = esdhc_writew_le,
> +	.write_b = esdhc_writeb_le,
> +	.set_clock = esdhc_set_clock,
> +	.get_max_clock = esdhc_pltfm_get_max_clock,
> +	.get_min_clock = esdhc_pltfm_get_min_clock,
> +};
> +
> +static struct sdhci_pltfm_data sdhci_esdhc_imx_pdata = {
> +	.quirks = ESDHC_DEFAULT_QUIRKS | SDHCI_QUIRK_BROKEN_ADMA,
> +	/* ADMA has issues. Might be fixable */
> +	.ops = &sdhci_esdhc_ops,
> +};
> +
> +static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
>  {
> -	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct sdhci_pltfm_host *pltfm_host;
> +	struct sdhci_host *host;
>  	struct clk *clk;
> +	int ret;
> +
> +	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_imx_pdata);

Nice!  I like that this adds type checking to the passing of the
sdhci_pltfm_data pointer.

> +	if (!host)
> +		return -ENOMEM;
> +
> +	pltfm_host = sdhci_priv(host);
>  
>  	clk = clk_get(mmc_dev(host->mmc), NULL);
>  	if (IS_ERR(clk)) {
>  		dev_err(mmc_dev(host->mmc), "clk err\n");
> -		return PTR_ERR(clk);
> +		ret = PTR_ERR(clk);
> +		goto err_clk_get;
>  	}
>  	clk_enable(clk);
>  	pltfm_host->clk = clk;
> @@ -120,30 +144,68 @@ static int esdhc_pltfm_init(struct sdhci_host *host, struct sdhci_pltfm_data *pd
>  	if (cpu_is_mx25() || cpu_is_mx35())
>  		host->quirks |= SDHCI_QUIRK_NO_MULTIBLOCK;
>  
> +	ret = sdhci_add_host(host);
> +	if (ret)
> +		goto err_add_host;
> +
>  	return 0;
> +
> +err_add_host:
> +	clk_disable(pltfm_host->clk);
> +	clk_put(pltfm_host->clk);
> +err_clk_get:
> +	sdhci_pltfm_free(pdev);
> +	return ret;
>  }
>  
> -static void esdhc_pltfm_exit(struct sdhci_host *host)
> +static int __devexit sdhci_esdhc_imx_remove(struct platform_device *pdev)
>  {
> +	struct sdhci_host *host = platform_get_drvdata(pdev);
>  	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	int dead = 0;
> +	u32 scratch;
> +
> +	dead = 0;
> +	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
> +	if (scratch == (u32)-1)
> +		dead = 1;
> +
> +	sdhci_remove_host(host, dead);
>  
>  	clk_disable(pltfm_host->clk);
>  	clk_put(pltfm_host->clk);
> +
> +	sdhci_pltfm_free(pdev);
> +
> +	return 0;
>  }
>  
> -static struct sdhci_ops sdhci_esdhc_ops = {
> -	.read_w = esdhc_readw_le,
> -	.write_w = esdhc_writew_le,
> -	.write_b = esdhc_writeb_le,
> -	.set_clock = esdhc_set_clock,
> -	.get_max_clock = esdhc_pltfm_get_max_clock,
> -	.get_min_clock = esdhc_pltfm_get_min_clock,
> +static struct platform_driver sdhci_esdhc_imx_driver = {
> +	.driver		= {
> +		.name	= "sdhci-esdhc-imx",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= sdhci_esdhc_imx_probe,
> +	.remove		= __devexit_p(sdhci_esdhc_imx_remove),
> +#ifdef CONFIG_PM
> +	.suspend	= sdhci_pltfm_suspend,
> +	.resume		= sdhci_pltfm_resume,
> +#endif
>  };
>  
> -struct sdhci_pltfm_data sdhci_esdhc_imx_pdata = {
> -	.quirks = ESDHC_DEFAULT_QUIRKS | SDHCI_QUIRK_BROKEN_ADMA,
> -	/* ADMA has issues. Might be fixable */
> -	.ops = &sdhci_esdhc_ops,
> -	.init = esdhc_pltfm_init,
> -	.exit = esdhc_pltfm_exit,
> -};
> +static int __init sdhci_esdhc_imx_init(void)
> +{
> +	return platform_driver_register(&sdhci_esdhc_imx_driver);
> +}
> +
> +static void __exit sdhci_esdhc_imx_exit(void)
> +{
> +	platform_driver_unregister(&sdhci_esdhc_imx_driver);
> +}
> +
> +module_init(sdhci_esdhc_imx_init);
> +module_exit(sdhci_esdhc_imx_exit);

Typically, I like to see module_init() and module_exit() immediately
adjacent to the functions they register.

> +
> +MODULE_DESCRIPTION("SDHCI driver for i.MX eSDHC");
> +MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
> index ccc04ac..38b8cb4 100644
> --- a/drivers/mmc/host/sdhci-pltfm.c
> +++ b/drivers/mmc/host/sdhci-pltfm.c
> @@ -44,6 +44,83 @@
>  static struct sdhci_ops sdhci_pltfm_ops = {
>  };
>  
> +struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
> +				    struct sdhci_pltfm_data *pdata)

Since there is no chance of *pdata being passed via the
pdev->dev.platform_data pointer (there aren't any users in mainline of
that feature) then I would take the opportunity to rename this
parameter and structure to eliminate any confusion.  'struct
sdhci_pltfm' would be sufficient I think.

> +{
> +	struct sdhci_host *host;
> +	struct sdhci_pltfm_host *pltfm_host;
> +	struct resource *iomem;
> +	int ret;
> +
> +	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!iomem) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	if (resource_size(iomem) < 0x100)
> +		dev_err(&pdev->dev, "Invalid iomem size!\n");
> +
> +	/* Some PCI-based MFD need the parent here */
> +	if (pdev->dev.parent != &platform_bus)
> +		host = sdhci_alloc_host(pdev->dev.parent, sizeof(*pltfm_host));
> +	else
> +		host = sdhci_alloc_host(&pdev->dev, sizeof(*pltfm_host));
> +
> +	if (IS_ERR(host)) {
> +		ret = PTR_ERR(host);
> +		goto err;
> +	}
> +
> +	pltfm_host = sdhci_priv(host);
> +
> +	host->hw_name = "SDHCI";
> +	if (pdata && pdata->ops)
> +		host->ops = pdata->ops;
> +	else
> +		host->ops = &sdhci_pltfm_ops;
> +	if (pdata)
> +		host->quirks = pdata->quirks;
> +	host->irq = platform_get_irq(pdev, 0);
> +
> +	if (!request_mem_region(iomem->start, resource_size(iomem),
> +		mmc_hostname(host->mmc))) {
> +		dev_err(&pdev->dev, "cannot request region\n");
> +		ret = -EBUSY;
> +		goto err_request;
> +	}
> +
> +	host->ioaddr = ioremap(iomem->start, resource_size(iomem));
> +	if (!host->ioaddr) {
> +		dev_err(&pdev->dev, "failed to remap registers\n");
> +		ret = -ENOMEM;
> +		goto err_remap;
> +	}
> +
> +	platform_set_drvdata(pdev, host);
> +
> +	return host;
> +
> +err_remap:
> +	release_mem_region(iomem->start, resource_size(iomem));
> +err_request:
> +	sdhci_free_host(host);
> +err:
> +	pr_err("%s failed %d\n", __func__, ret);
> +	return NULL;
> +}

Since the bulk of this function is a direct clone of the
body of sdhci_pltfm_probe(), this patch should also modify
sdhci_pltfm_probe() to use the new utility function.  That will also
make it clearer to readers that this new block is simply a refactor of
the old.

> +
> +void sdhci_pltfm_free(struct platform_device *pdev)
> +{
> +	struct sdhci_host *host = platform_get_drvdata(pdev);
> +	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	iounmap(host->ioaddr);
> +	release_mem_region(iomem->start, resource_size(iomem));
> +	sdhci_free_host(host);
> +	platform_set_drvdata(pdev, NULL);
> +}

Ditto here for sdhci_pltfm_remove()

> +
>  /*****************************************************************************\
>   *                                                                           *
>   * Device probing/removal                                                    *
> @@ -198,9 +275,6 @@ static const struct platform_device_id sdhci_pltfm_ids[] = {
>  #ifdef CONFIG_MMC_SDHCI_CNS3XXX
>  	{ "sdhci-cns3xxx", (kernel_ulong_t)&sdhci_cns3xxx_pdata },
>  #endif
> -#ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
> -	{ "sdhci-esdhc-imx", (kernel_ulong_t)&sdhci_esdhc_imx_pdata },
> -#endif
>  #ifdef CONFIG_MMC_SDHCI_DOVE
>  	{ "sdhci-dove", (kernel_ulong_t)&sdhci_dove_pdata },
>  #endif
> @@ -212,14 +286,14 @@ static const struct platform_device_id sdhci_pltfm_ids[] = {
>  MODULE_DEVICE_TABLE(platform, sdhci_pltfm_ids);
>  
>  #ifdef CONFIG_PM
> -static int sdhci_pltfm_suspend(struct platform_device *dev, pm_message_t state)
> +int sdhci_pltfm_suspend(struct platform_device *dev, pm_message_t state)
>  {
>  	struct sdhci_host *host = platform_get_drvdata(dev);
>  
>  	return sdhci_suspend_host(host, state);
>  }
>  
> -static int sdhci_pltfm_resume(struct platform_device *dev)
> +int sdhci_pltfm_resume(struct platform_device *dev)
>  {
>  	struct sdhci_host *host = platform_get_drvdata(dev);
>  
> diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
> index c67523d..8357eba 100644
> --- a/drivers/mmc/host/sdhci-pltfm.h
> +++ b/drivers/mmc/host/sdhci-pltfm.h
> @@ -13,6 +13,7 @@
>  
>  #include <linux/clk.h>
>  #include <linux/types.h>
> +#include <linux/platform_device.h>
>  #include <linux/mmc/sdhci-pltfm.h>
>  
>  struct sdhci_pltfm_host {
> @@ -21,9 +22,17 @@ struct sdhci_pltfm_host {
>  };
>  
>  extern struct sdhci_pltfm_data sdhci_cns3xxx_pdata;
> -extern struct sdhci_pltfm_data sdhci_esdhc_imx_pdata;
>  extern struct sdhci_pltfm_data sdhci_dove_pdata;
>  extern struct sdhci_pltfm_data sdhci_tegra_pdata;
>  extern struct sdhci_pltfm_data sdhci_tegra_dt_pdata;
>  
> +struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
> +				    struct sdhci_pltfm_data *pdata);
> +void sdhci_pltfm_free(struct platform_device *pdev);
> +
> +#ifdef CONFIG_PM
> +int sdhci_pltfm_suspend(struct platform_device *dev, pm_message_t state);
> +int sdhci_pltfm_resume(struct platform_device *dev);
> +#endif
> +
>  #endif /* _DRIVERS_MMC_SDHCI_PLTFM_H */
> -- 
> 1.7.1
> 
