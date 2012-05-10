Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2EJAhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:37:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55661 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab2EJAhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:37:23 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi/omap: cleanup probe/remove routines
To: Hannu Heikkinen <hannuxx@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Kevin Hilman <khilman@deeprootsystems.com>
Cc: tony@atomide.com
In-Reply-To: <1336567438-6715-1-git-send-email-hannuxx@iki.fi>
References: <1336567438-6715-1-git-send-email-hannuxx@iki.fi>
Date: Wed, 09 May 2012 18:37:20 -0600
Message-Id: <20120510003720.2F90C3E08F4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 May 2012 15:43:58 +0300, Hannu Heikkinen <hannuxx@iki.fi> wrote:
> Cleanup probe and remove routines, use devm_* functions for
> managing resources.
> 
> Also, in under free_master label, change use of kfree() into
> spi_master_put().

Patch does not apply to my current spi/next branch[1].

[1]git://git.secretlab.ca/git/linux-2.6 spi/next

While I'm thinking about it; Kevin, how do you want me handling OMAP
spi patches.  Do you want to pick them up, test them and send me a git
branch to pull like with gpio?  Or can I just pick them up?

g.

> 
> CC: grant.likely@secretlab.ca
> CC: tony@atomide.com
> Signed-off-by: Hannu Heikkinen <hannuxx@iki.fi>
> ---
>  drivers/spi/spi-omap2-mcspi.c |   27 ++++++---------------------
>  1 file changed, 6 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index bb9274c..392efce 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -1166,17 +1166,12 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
>  	r->start += regs_offset;
>  	r->end += regs_offset;
>  	mcspi->phys = r->start;
> -	if (!request_mem_region(r->start, resource_size(r),
> -				dev_name(&pdev->dev))) {
> -		status = -EBUSY;
> -		goto free_master;
> -	}
>  
> -	mcspi->base = ioremap(r->start, resource_size(r));
> +	mcspi->base = devm_request_and_ioremap(&pdev->dev, r);
>  	if (!mcspi->base) {
> -		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
> -		status = -ENOMEM;
> -		goto release_region;
> +		dev_dbg(&pdev->dev, "can't request mem and ioremap MCSPI\n");
> +		status =  -ENOMEM;
> +		goto free_master;
>  	}
>  
>  	mcspi->dev = &pdev->dev;
> @@ -1191,7 +1186,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
>  			GFP_KERNEL);
>  
>  	if (mcspi->dma_channels == NULL)
> -		goto unmap_io;
> +		goto free_master;
>  
>  	for (i = 0; i < master->num_chipselect; i++) {
>  		char dma_ch_name[14];
> @@ -1241,12 +1236,8 @@ disable_pm:
>  	pm_runtime_disable(&pdev->dev);
>  dma_chnl_free:
>  	kfree(mcspi->dma_channels);
> -unmap_io:
> -	iounmap(mcspi->base);
> -release_region:
> -	release_mem_region(r->start, resource_size(r));
>  free_master:
> -	kfree(master);
> +	spi_master_put(master);
>  	platform_set_drvdata(pdev, NULL);
>  	return status;
>  }
> @@ -1256,8 +1247,6 @@ static int __exit omap2_mcspi_remove(struct platform_device *pdev)
>  	struct spi_master	*master;
>  	struct omap2_mcspi	*mcspi;
>  	struct omap2_mcspi_dma	*dma_channels;
> -	struct resource		*r;
> -	void __iomem *base;
>  
>  	master = dev_get_drvdata(&pdev->dev);
>  	mcspi = spi_master_get_devdata(master);
> @@ -1265,12 +1254,8 @@ static int __exit omap2_mcspi_remove(struct platform_device *pdev)
>  
>  	omap2_mcspi_disable_clocks(mcspi);
>  	pm_runtime_disable(&pdev->dev);
> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(r->start, resource_size(r));
>  
> -	base = mcspi->base;
>  	spi_unregister_master(master);
> -	iounmap(base);
>  	kfree(dma_channels);
>  	destroy_workqueue(mcspi->wq);
>  	platform_set_drvdata(pdev, NULL);
> -- 
> 1.7.10
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
