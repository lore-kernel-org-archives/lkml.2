Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1GZNtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:49:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52349 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1GZNtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:49:16 -0400
Subject: Re: [PATCH 2/3] dmaengine: at_hdmac: improve power management
 routines
From: Vinod Koul <vkoul@infradead.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <4E2DDAEA.6050809@atmel.com>
References: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
	 <e8b0dceb5995556214d03477662f4ff7caf734e1.1309259835.git.nicolas.ferre@atmel.com>
	 <1310005222.20150.23.camel@psiaudioba-mobl1>  <4E2DDAEA.6050809@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Tue, 26 Jul 2011 16:21:54 +0530
Message-ID: <1311677514.24316.6.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 23:06 +0200, Nicolas Ferre wrote:
> On 07/07/2011 04:20 AM, Vinod Koul wrote:
> > On Tue, 2011-06-28 at 13:17 +0200, Nicolas Ferre wrote:
> >> Save/restore dma controller state across a suspend-resume sequence.
> >> The prepare() function will wait for the non-cyclic channels to become idle.
> >> It also deals with cyclic operations with the start at next period while
> >> resuming.
> >>
> >> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
> >> Signed-off-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>
> >> ---
> >>   drivers/dma/at_hdmac.c      |   88 ++++++++++++++++++++++++++++++++++++++++++-
> >>   drivers/dma/at_hdmac_regs.h |    7 +++
> >>   2 files changed, 94 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> >> index fd87b96..7096adb 100644
> >> --- a/drivers/dma/at_hdmac.c
> >> +++ b/drivers/dma/at_hdmac.c
> >> @@ -1385,27 +1385,113 @@ static void at_dma_shutdown(struct platform_device *pdev)
> >>   	clk_disable(atdma->clk);
> >>   }
> >>
> >> +static int at_dma_prepare(struct device *dev)
> >> +{
> >> +	struct platform_device *pdev = to_platform_device(dev);
> >> +	struct at_dma *atdma = platform_get_drvdata(pdev);
> >> +	struct dma_chan *chan, *_chan;
> >> +
> >> +	list_for_each_entry_safe(chan, _chan,&atdma->dma_common.channels,
> >> +			device_node) {
> >> +		struct at_dma_chan *atchan = to_at_dma_chan(chan);
> >> +		/* wait for transaction completion (except in cyclic case) */
> >> +		if (atc_chan_is_enabled(atchan)&&
> >> +			!test_bit(ATC_IS_CYCLIC,&atchan->status))
> >> +			return -EAGAIN;
> > pls fix indent here
> 
> Fixed by replacement of test_bit() with a wrapper in a patch to come (as 
> you suggest hereafter).
> 
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static void atc_suspend_cyclic(struct at_dma_chan *atchan)
> >> +{
> >> +	struct dma_chan	*chan =&atchan->chan_common;
> >> +
> >> +	/* Channel should be paused by user
> >> +	 * do it anyway even if it is not done already */
> >> +	if (!test_bit(ATC_IS_PAUSED,&atchan->status)) {
> >> +		dev_warn(chan2dev(chan),
> >> +		"cyclic channel not paused, should be done by channel user\n");
> >> +		atc_control(chan, DMA_PAUSE, 0);
> >> +	}
> >> +
> >> +	/* now preserve additional data for cyclic operations */
> >> +	/* next descriptor address in the cyclic list */
> >> +	atchan->save_dscr = channel_readl(atchan, DSCR);
> >> +
> >> +	vdbg_dump_regs(atchan);
> >> +}
> >> +
> >>   static int at_dma_suspend_noirq(struct device *dev)
> >>   {
> >>   	struct platform_device *pdev = to_platform_device(dev);
> >>   	struct at_dma *atdma = platform_get_drvdata(pdev);
> >> +	struct dma_chan *chan, *_chan;
> >>
> >> -	at_dma_off(platform_get_drvdata(pdev));
> >> +	/* preserve data */
> >> +	list_for_each_entry_safe(chan, _chan,&atdma->dma_common.channels,
> >> +			device_node) {
> >> +		struct at_dma_chan *atchan = to_at_dma_chan(chan);
> >> +
> >> +		if (test_bit(ATC_IS_CYCLIC,&atchan->status))
> >> +			atc_suspend_cyclic(atchan);
> >> +		atchan->save_cfg = channel_readl(atchan, CFG);
> >> +	}
> >> +	atdma->save_imr = dma_readl(atdma, EBCIMR);
> >> +
> >> +	/* disable DMA controller */
> >> +	at_dma_off(atdma);
> >>   	clk_disable(atdma->clk);
> >>   	return 0;
> >>   }
> >>
> >> +static void atc_resume_cyclic(struct at_dma_chan *atchan)
> >> +{
> >> +	struct at_dma	*atdma = to_at_dma(atchan->chan_common.device);
> >> +
> >> +	/* restore channel status for cyclic descriptors list:
> >> +	 * next descriptor in the cyclic list at the time of suspend */
> >> +	channel_writel(atchan, SADDR, 0);
> >> +	channel_writel(atchan, DADDR, 0);
> >> +	channel_writel(atchan, CTRLA, 0);
> >> +	channel_writel(atchan, CTRLB, 0);
> >> +	channel_writel(atchan, DSCR, atchan->save_dscr);
> >> +	dma_writel(atdma, CHER, atchan->mask);
> >> +
> >> +	/* channel pause status should be removed by channel user
> >> +	 * We cannot take the initiative to do it here */
> >> +
> >> +	vdbg_dump_regs(atchan);
> >> +}
> >> +
> >>   static int at_dma_resume_noirq(struct device *dev)
> >>   {
> >>   	struct platform_device *pdev = to_platform_device(dev);
> >>   	struct at_dma *atdma = platform_get_drvdata(pdev);
> >> +	struct dma_chan *chan, *_chan;
> >>
> >> +	/* bring back DMA controller */
> >>   	clk_enable(atdma->clk);
> >>   	dma_writel(atdma, EN, AT_DMA_ENABLE);
> >> +
> >> +	/* clear any pending interrupt */
> >> +	while (dma_readl(atdma, EBCISR))
> >> +		cpu_relax();
> >> +
> >> +	/* restore saved data */
> >> +	dma_writel(atdma, EBCIER, atdma->save_imr);
> >> +	list_for_each_entry_safe(chan, _chan,&atdma->dma_common.channels,
> >> +			device_node) {
> >> +		struct at_dma_chan *atchan = to_at_dma_chan(chan);
> >> +
> >> +		channel_writel(atchan, CFG, atchan->save_cfg);
> >> +		if (test_bit(ATC_IS_CYCLIC,&atchan->status))
> >> +			atc_resume_cyclic(atchan);
> > This testing on bits seems to be reused few times how about wrapping it
> > up in a routine?
> 
> True: I write a little patch for this and the "PAUSE" state. I send a 
> patch for this now:
> dmaengine: at_hdmac: add wrappers for testing channel state
> So can you:
> 1/ queue 1/3 and 2/3 of this patch series
> 2/ queue the following patch named
> "dmaengine: at_hdmac: add wrappers for testing channel state"
> on top of that
> 
> 3/ drop the patch 3/3 of this series: it certainly have to be reworked 
> with all slave config infrastructure implementation in the at_hdmac driver.
The indent needs to be fixed before I can apply this one, sorry but
error introduced in one patch cannot be fixed in next, it is not
supposed to work that way

-- 
~Vinod Koul
Intel Corp.

