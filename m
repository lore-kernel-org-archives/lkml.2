Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937799Ab0CPLBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:01:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:42872 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S937732Ab0CPLBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:01:36 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/CiMcnxeLChHTMAQFsGEkNcFKUMidfxRlNgZgU27
	PxfKHYccgdDvZO
Date: Tue, 16 Mar 2010 12:01:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: mx1-camera: compile fix
In-Reply-To: <1268733172-17059-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1003161129460.5123@axis700.grange>
References: <Pine.LNX.4.64.1003121057090.4385@axis700.grange>
 <1268733172-17059-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010, Uwe Kleine-König wrote:

> This is a regression of
> 
> 	7d58289 (mx1: prefix SOC specific defines with MX1_ and deprecate old names)
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h |    4 +++-
>  drivers/media/video/mx1_camera.c             |    8 +++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h b/arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h
> index 07be8ad..d25a65f 100644
> --- a/arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h
> +++ b/arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h
> @@ -31,7 +31,9 @@
>  #define DMA_MODE_WRITE		1
>  #define DMA_MODE_MASK		1
>  
> -#define DMA_BASE IO_ADDRESS(DMA_BASE_ADDR)
> +#define MX1_DMA_REG(offset)	MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR + offset)

Here offset must be in parenthesis - plus is not the lowest-prio 
operation, so, someone might well call MX1_DMA_REG(x << 1), which is also 
almost what you do below, and this is a header...

> +#define MX1_DMA_CCR(x)		MX1_DMA_REG(0x8c + ((x) << 6))
> +#define MX1_DMA_DIMR		MX1_DMA_REG(0x08)

Why don't we also take comments to these registers - I promise, I won't 
complain about > 80 characters;)

>  
>  #define IMX_DMA_MEMSIZE_32	(0 << 4)
>  #define IMX_DMA_MEMSIZE_8	(1 << 4)
> diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
> index c167cc3..aa81acd 100644
> --- a/drivers/media/video/mx1_camera.c
> +++ b/drivers/media/video/mx1_camera.c
> @@ -48,8 +48,6 @@
>  /*
>   * CSI registers
>   */
> -#define DMA_CCR(x)	(0x8c + ((x) << 6))	/* Control Registers */
> -#define DMA_DIMR	0x08			/* Interrupt mask Register */
>  #define CSICR1		0x00			/* CSI Control Register 1 */
>  #define CSISR		0x08			/* CSI Status Register */
>  #define CSIRXR		0x10			/* CSI RxFIFO Register */
> @@ -783,7 +781,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
>  			       pcdev);
>  
>  	imx_dma_config_channel(pcdev->dma_chan, IMX_DMA_TYPE_FIFO,
> -			       IMX_DMA_MEMSIZE_32, DMA_REQ_CSI_R, 0);
> +			       IMX_DMA_MEMSIZE_32, MX1_DMA_REQ_CSI_R, 0);
>  	/* burst length : 16 words = 64 bytes */
>  	imx_dma_config_burstlen(pcdev->dma_chan, 0);
>  
> @@ -797,8 +795,8 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
>  	set_fiq_handler(&mx1_camera_sof_fiq_start, &mx1_camera_sof_fiq_end -
>  						   &mx1_camera_sof_fiq_start);
>  
> -	regs.ARM_r8 = DMA_BASE + DMA_DIMR;
> -	regs.ARM_r9 = DMA_BASE + DMA_CCR(pcdev->dma_chan);
> +	regs.ARM_r8 = (long)MX1_DMA_DIMR;
> +	regs.ARM_r9 = (long)MX1_DMA_CCR(pcdev->dma_chan);
>  	regs.ARM_r10 = (long)pcdev->base + CSICR1;
>  	regs.ARM_fp = (long)pcdev->base + CSISR;
>  	regs.ARM_sp = 1 << pcdev->dma_chan;

Yes, I think, that looks good now. Just correct the above issues and I'll 
ack it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
