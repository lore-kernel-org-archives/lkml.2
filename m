Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2KPPK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:10:58 -0500
Received: from mail1.windriver.com ([147.11.146.13]:43786 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2KPPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:10:57 -0500
Message-ID: <50A656E2.707@windriver.com>
Date: Fri, 16 Nov 2012 10:08:18 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        "Huang Shijie" <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, "Matt Porter" <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "Javier Martin" <javier.martin@vista-silicon.com>,
        <kernel@pengutronix.de>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v6 3/4] media: coda: use genalloc API
References: <1353061817-3207-1-git-send-email-p.zabel@pengutronix.de> <1353061817-3207-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1353061817-3207-4-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-11-16 05:30 AM, Philipp Zabel wrote:
> This patch depends on "genalloc: add a global pool list,
> allow to find pools by phys address", which provides the
> of_get_named_gen_pool function.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/Kconfig |    3 +--
>  drivers/media/platform/coda.c  |   47 ++++++++++++++++++++++++++++------------
>  2 files changed, 34 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 181c768..09d45c6 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -130,10 +130,9 @@ if V4L_MEM2MEM_DRIVERS
>  
>  config VIDEO_CODA
>  	tristate "Chips&Media Coda multi-standard codec IP"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
> +	depends on VIDEO_DEV && VIDEO_V4L2

What was the logic for reducing the dependency scope here?
Your commit log doesn't mention that at all, and when I see
things like that, I predict allyesconfig build failures,
unless there is a similar dependency elsewhere that isn't
visible in just the context of this patch alone.

P.
--

>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
> -	select IRAM_ALLOC if SOC_IMX53
>  	---help---
>  	   Coda is a range of video codec IPs that supports
>  	   H.264, MPEG-4, and other video formats.
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index cd04ae2..f17b659 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -14,6 +14,7 @@
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/firmware.h>
> +#include <linux/genalloc.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/irq.h>
> @@ -24,7 +25,6 @@
>  #include <linux/videodev2.h>
>  #include <linux/of.h>
>  
> -#include <mach/iram.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> @@ -43,6 +43,7 @@
>  #define CODA7_WORK_BUF_SIZE	(512 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
>  #define CODA_PARA_BUF_SIZE	(10 * 1024)
>  #define CODA_ISRAM_SIZE	(2048 * 2)
> +#define CODADX6_IRAM_SIZE	0xb000
>  #define CODA7_IRAM_SIZE		0x14000 /* 81920 bytes */
>  
>  #define CODA_MAX_FRAMEBUFFERS	2
> @@ -128,7 +129,10 @@ struct coda_dev {
>  
>  	struct coda_aux_buf	codebuf;
>  	struct coda_aux_buf	workbuf;
> +	struct gen_pool		*iram_pool;
> +	long unsigned int	iram_vaddr;
>  	long unsigned int	iram_paddr;
> +	unsigned long		iram_size;
>  
>  	spinlock_t		irqlock;
>  	struct mutex		dev_mutex;
> @@ -1958,6 +1962,22 @@ static int __devinit coda_probe(struct platform_device *pdev)
>  		return -ENOENT;
>  	}
>  
> +	/* Without device tree, get SRAM paddr from second memory resource */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (res != NULL)
> +		dev->iram_pool = gen_pool_find_by_phys(res->start);
> +#ifdef CONFIG_OF
> +	if (!dev->iram_pool) {
> +		struct device_node *np = pdev->dev.of_node;
> +
> +		dev->iram_pool = of_get_named_gen_pool(np, "iram", 0);
> +	}
> +#endif
> +	if (!dev->iram_pool) {
> +		dev_err(&pdev->dev, "iram pool not available\n");
> +		return -ENOMEM;
> +	}
> +
>  	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>  	if (ret)
>  		return ret;
> @@ -1992,18 +2012,17 @@ static int __devinit coda_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	if (dev->devtype->product == CODA_DX6) {
> -		dev->iram_paddr = 0xffff4c00;
> -	} else {
> -		void __iomem *iram_vaddr;
> -
> -		iram_vaddr = iram_alloc(CODA7_IRAM_SIZE,
> -					&dev->iram_paddr);
> -		if (!iram_vaddr) {
> -			dev_err(&pdev->dev, "unable to alloc iram\n");
> -			return -ENOMEM;
> -		}
> +	if (dev->devtype->product == CODA_DX6)
> +		dev->iram_size = CODADX6_IRAM_SIZE;
> +	else
> +		dev->iram_size = CODA7_IRAM_SIZE;
> +	dev->iram_vaddr = gen_pool_alloc(dev->iram_pool, dev->iram_size);
> +	if (!dev->iram_vaddr) {
> +		dev_err(&pdev->dev, "unable to alloc iram\n");
> +		return -ENOMEM;
>  	}
> +	dev->iram_paddr = gen_pool_virt_to_phys(dev->iram_pool,
> +						dev->iram_vaddr);
>  
>  	platform_set_drvdata(pdev, dev);
>  
> @@ -2020,8 +2039,8 @@ static int coda_remove(struct platform_device *pdev)
>  	if (dev->alloc_ctx)
>  		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>  	v4l2_device_unregister(&dev->v4l2_dev);
> -	if (dev->iram_paddr)
> -		iram_free(dev->iram_paddr, CODA7_IRAM_SIZE);
> +	if (dev->iram_vaddr)
> +		gen_pool_free(dev->iram_pool, dev->iram_vaddr, dev->iram_size);
>  	if (dev->codebuf.vaddr)
>  		dma_free_coherent(&pdev->dev, dev->codebuf.size,
>  				  &dev->codebuf.vaddr, dev->codebuf.paddr);
> 
