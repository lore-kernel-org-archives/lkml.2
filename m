Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab2JROwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:52:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55544 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab2JROwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:52:19 -0400
Date: Thu, 18 Oct 2012 10:53:38 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: Re: [PATCH v4 1/7] uio: uio_pruss: replace private SRAM API with
 genalloc
Message-ID: <20121018145338.GA25164@beef>
References: <1349456686-22736-1-git-send-email-mporter@ti.com>
 <1349456686-22736-2-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349456686-22736-2-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 01:04:40PM -0400, Matt Porter wrote:
> Remove the use of the private DaVinci SRAM API in favor
> of genalloc. The pool to be used is provided by platform
> data.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>

Hans,

Any additional concerns on this patch? Sekhar is holding off on applying
parts 4,5,7 for davinci until this is accepted.

Thanks,
Matt

> ---
>  drivers/uio/Kconfig                     |    1 +
>  drivers/uio/uio_pruss.c                 |   24 +++++++++++++++++-------
>  include/linux/platform_data/uio_pruss.h |    3 ++-
>  3 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index 6f3ea9b..c48b938 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -97,6 +97,7 @@ config UIO_NETX
>  config UIO_PRUSS
>  	tristate "Texas Instruments PRUSS driver"
>  	depends on ARCH_DAVINCI_DA850
> +	select GENERIC_ALLOCATOR
>  	help
>  	  PRUSS driver for OMAPL138/DA850/AM18XX devices
>  	  PRUSS driver requires user space components, examples and user space
> diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
> index 33a7a27..f8738de 100644
> --- a/drivers/uio/uio_pruss.c
> +++ b/drivers/uio/uio_pruss.c
> @@ -25,7 +25,7 @@
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
> -#include <mach/sram.h>
> +#include <linux/genalloc.h>
>  
>  #define DRV_NAME "pruss_uio"
>  #define DRV_VERSION "1.0"
> @@ -65,10 +65,11 @@ struct uio_pruss_dev {
>  	dma_addr_t sram_paddr;
>  	dma_addr_t ddr_paddr;
>  	void __iomem *prussio_vaddr;
> -	void *sram_vaddr;
> +	unsigned long sram_vaddr;
>  	void *ddr_vaddr;
>  	unsigned int hostirq_start;
>  	unsigned int pintc_base;
> +	struct gen_pool *sram_pool;
>  };
>  
>  static irqreturn_t pruss_handler(int irq, struct uio_info *info)
> @@ -106,7 +107,9 @@ static void pruss_cleanup(struct platform_device *dev,
>  			gdev->ddr_paddr);
>  	}
>  	if (gdev->sram_vaddr)
> -		sram_free(gdev->sram_vaddr, sram_pool_sz);
> +		gen_pool_free(gdev->sram_pool,
> +			      gdev->sram_vaddr,
> +			      sram_pool_sz);
>  	kfree(gdev->info);
>  	clk_put(gdev->pruss_clk);
>  	kfree(gdev);
> @@ -152,10 +155,17 @@ static int __devinit pruss_probe(struct platform_device *dev)
>  		goto out_free;
>  	}
>  
> -	gdev->sram_vaddr = sram_alloc(sram_pool_sz, &(gdev->sram_paddr));
> -	if (!gdev->sram_vaddr) {
> -		dev_err(&dev->dev, "Could not allocate SRAM pool\n");
> -		goto out_free;
> +	if (pdata->sram_pool) {
> +		gdev->sram_pool = pdata->sram_pool;
> +		gdev->sram_vaddr =
> +			gen_pool_alloc(gdev->sram_pool, sram_pool_sz);
> +		if (!gdev->sram_vaddr) {
> +			dev_err(&dev->dev, "Could not allocate SRAM pool\n");
> +			goto out_free;
> +		}
> +		gdev->sram_paddr =
> +			gen_pool_virt_to_phys(gdev->sram_pool,
> +					      gdev->sram_vaddr);
>  	}
>  
>  	gdev->ddr_vaddr = dma_alloc_coherent(&dev->dev, extram_pool_sz,
> diff --git a/include/linux/platform_data/uio_pruss.h b/include/linux/platform_data/uio_pruss.h
> index f39140a..3d47d21 100644
> --- a/include/linux/platform_data/uio_pruss.h
> +++ b/include/linux/platform_data/uio_pruss.h
> @@ -20,6 +20,7 @@
>  
>  /* To configure the PRUSS INTC base offset for UIO driver */
>  struct uio_pruss_pdata {
> -	u32	pintc_base;
> +	u32		pintc_base;
> +	struct gen_pool *sram_pool;
>  };
>  #endif /* _UIO_PRUSS_H_ */
> -- 
> 1.7.9.5
> 
