Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2ACRqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:46:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55829 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2ACRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:46:49 -0500
Date: Tue, 3 Jan 2012 17:46:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, vinod.koul@intel.com, eric.miao@linaro.org,
        kernel@pengutronix.de, dan.j.williams@intel.com, shawn.guo@linaro.org
Subject: Re: [PATCH v2 2/2] dma/imx-sdma: add wmb before enable a channel
Message-ID: <20120103174639.GF2914@n2100.arm.linux.org.uk>
References: <1325428692-11473-1-git-send-email-richard.zhao@linaro.org> <1325428692-11473-3-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325428692-11473-3-git-send-email-richard.zhao@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 01, 2012 at 10:38:12PM +0800, Richard Zhao wrote:
> dma_alloc_coherent memory may be bufferable. We need to add
> nececcary memory barrier.
> 
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> ---
>  drivers/dma/imx-sdma.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index f8e87b5..9301bff 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -394,6 +394,7 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
>  
>  static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
>  {
> +	wmb();
>  	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);

Use writel().  That's what it's there for:

#ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
#define __iowmb()               wmb()
#endif
#define writel_relaxed(v,c)     ((void)__raw_writel((__force u32) \
                                        cpu_to_le32(v),__mem_pci(c)))
#define writel(v,c)             ({ __iowmb(); writel_relaxed(v,c); })
