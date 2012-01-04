Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab2ADCct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:32:49 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:10956
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756340Ab2ADCcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:32:08 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 4 Jan 2012 10:31:58 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Richard Zhao <richard.zhao@linaro.org>, <patches@linaro.org>,
        <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <eric.miao@linaro.org>, <kernel@pengutronix.de>,
        <dan.j.williams@intel.com>, <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] dma/imx-sdma: add wmb before enable a channel
Message-ID: <20120104023157.GJ2414@b20223-02.ap.freescale.net>
References: <1325428692-11473-1-git-send-email-richard.zhao@linaro.org>
 <1325428692-11473-3-git-send-email-richard.zhao@linaro.org>
 <20120103174639.GF2914@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120103174639.GF2914@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 05:46:39PM +0000, Russell King - ARM Linux wrote:
> On Sun, Jan 01, 2012 at 10:38:12PM +0800, Richard Zhao wrote:
> > dma_alloc_coherent memory may be bufferable. We need to add
> > nececcary memory barrier.
> > 
> > Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> > ---
> >  drivers/dma/imx-sdma.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> > index f8e87b5..9301bff 100644
> > --- a/drivers/dma/imx-sdma.c
> > +++ b/drivers/dma/imx-sdma.c
> > @@ -394,6 +394,7 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
> >  
> >  static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
> >  {
> > +	wmb();
> >  	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
> 
> Use writel().  That's what it's there for:
> 
> #ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
> #define __iowmb()               wmb()
> #endif
> #define writel_relaxed(v,c)     ((void)__raw_writel((__force u32) \
>                                         cpu_to_le32(v),__mem_pci(c)))
> #define writel(v,c)             ({ __iowmb(); writel_relaxed(v,c); })
Why does writel always call wmb? ioremap memory needs mb too?
Isn't it supposed to be when there's prior touch of dma memory? 

Thanks
Richard
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

