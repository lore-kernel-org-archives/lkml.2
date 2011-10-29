Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab1J2Xto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:49:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60791 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab1J2XtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:14 -0400
Date: Sat, 29 Oct 2011 14:07:09 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OMAP: SPI: Correct the error path
Message-ID: <20111029120709.GF22592@ponder.secretlab.ca>
References: <1319802259-16565-1-git-send-email-shubhrajyoti@ti.com>
 <1319802259-16565-4-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319802259-16565-4-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 05:14:19PM +0530, Shubhrajyoti D wrote:
> Currently McSPI driver doesnt follow correct failure fallback steps
> attempting to correct the same.
> Also
> -  label names changed  to give meaningful names.
> - Setting the driver data to NULL in remove
> 
> Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Applied for v3.3, thanks.

g.

> ---
>  drivers/spi/spi-omap2-mcspi.c |   32 ++++++++++++++++++++------------
>  1 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 6875a0b..abe2fee 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -1115,13 +1115,13 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
>  	mcspi->wq = alloc_workqueue(wq_name, WQ_MEM_RECLAIM, 1);
>  	if (mcspi->wq == NULL) {
>  		status = -ENOMEM;
> -		goto err1;
> +		goto free_master;
>  	}
>  
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (r == NULL) {
>  		status = -ENODEV;
> -		goto err1;
> +		goto free_master;
>  	}
>  	r->start += pdata->regs_offset;
>  	r->end += pdata->regs_offset;
> @@ -1129,14 +1129,14 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
>  	if (!request_mem_region(r->start, resource_size(r),
>  				dev_name(&pdev->dev))) {
>  		status = -EBUSY;
> -		goto err1;
> +		goto free_master;
>  	}
>  
>  	mcspi->base = ioremap(r->start, resource_size(r));
>  	if (!mcspi->base) {
>  		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
>  		status = -ENOMEM;
> -		goto err2;
> +		goto release_region;
>  	}
>  
>  	mcspi->dev = &pdev->dev;
> @@ -1151,7 +1151,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
>  			GFP_KERNEL);
>  
>  	if (mcspi->dma_channels == NULL)
> -		goto err2;
> +		goto unmap_io;
>  
>  	for (i = 0; i < master->num_chipselect; i++) {
>  		char dma_ch_name[14];
> @@ -1181,26 +1181,33 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
>  		mcspi->dma_channels[i].dma_tx_sync_dev = dma_res->start;
>  	}
>  
> +	if (status < 0)
> +		goto dma_chnl_free;
> +
>  	pm_runtime_enable(&pdev->dev);
>  
>  	if (status || omap2_mcspi_master_setup(mcspi) < 0)
> -		goto err3;
> +		goto disable_pm;
>  
>  	status = spi_register_master(master);
>  	if (status < 0)
> -		goto err4;
> +		goto err_spi_register;
>  
>  	return status;
>  
> -err4:
> +err_spi_register:
>  	spi_master_put(master);
> -err3:
> +disable_pm:
>  	pm_runtime_disable(&pdev->dev);
> +dma_chnl_free:
>  	kfree(mcspi->dma_channels);
> -err2:
> -	release_mem_region(r->start, resource_size(r));
> +unmap_io:
>  	iounmap(mcspi->base);
> -err1:
> +release_region:
> +	release_mem_region(r->start, resource_size(r));
> +free_master:
> +	kfree(master);
> +	platform_set_drvdata(pdev, NULL);
>  	return status;
>  }
>  
> @@ -1226,6 +1233,7 @@ static int __exit omap2_mcspi_remove(struct platform_device *pdev)
>  	iounmap(base);
>  	kfree(dma_channels);
>  	destroy_workqueue(mcspi->wq);
> +	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;
>  }
> -- 
> 1.7.1
> 
> 
> ------------------------------------------------------------------------------
> The demand for IT networking professionals continues to grow, and the
> demand for specialized networking skills is growing even more rapidly.
> Take a complimentary Learning@Cisco Self-Assessment and learn 
> about Cisco certifications, training, and career opportunities. 
> http://p.sf.net/sfu/cisco-dev2dev
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
