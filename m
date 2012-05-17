Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab2EQUy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:54:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53437 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918Ab2EQUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:54:24 -0400
Message-ID: <4FB5657C.1010902@wwwdotorg.org>
Date: Thu, 17 May 2012 14:54:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: dan.j.williams@intel.com, vinod.koul@intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V3 2/2] dma: tegra: add dmaengine based dma driver
References: <1336734044-14275-1-git-send-email-ldewangan@nvidia.com> <1336734044-14275-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1336734044-14275-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 05:00 AM, Laxman Dewangan wrote:
> Adding dmaengine based NVIDIA's Tegra APB DMA driver.
> This driver support the slave mode of data transfer from
> peripheral to memory and vice versa.
> The driver supports for the cyclic and non-cyclic mode
> of data transfer.

> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig

> +config TEGRA_DMA

Could we name this TEGRA20_APB_DMA

Rational being: Include the version number so that if there's ever a
newer version that requires a new driver, we won't have to rename this.
Also, there is an AHB DMA engine too, even if it's quite unlikely we'll
ever write a driver for it.

> +	  Support for the NVIDIA Tegra DMA controller driver. The DMA
                                      ^

Similarly, probably best to insert the word "APB" here.

> diff --git a/drivers/dma/tegra_dma.c b/drivers/dma/tegra_dma.c

Can we name this tegra20-apb-dma.c for similar reasons?

> +#define GEN_ENABLE			BIT(31)
...
> +#define CSR_ENB				BIT(31)
> +#define CSR_IE_EOC			BIT(30)
> +#define CSR_HOLD			BIT(29)
...

It looks like there are still quite a few macros that aren't namespaced
(prefixed with TEGRA_APBDMA). I don't care too much about this since
they're inside this one file, but I think this is something Vinod wanted
you to fix?

> +struct tegra_dma_channel {
...
> +	/* Different lists for managing the requests */
> +	struct list_head	free_sg_req;
> +	struct list_head	pending_sg_req;
> +	struct list_head	free_dma_desc;
> +	struct list_head	wait_ack_dma_desc;
> +	struct list_head	cb_desc;
...
> +static int tegra_dma_allocate_desc(struct tegra_dma_channel *tdc,
> +		int ndma_desc, int nsg_req)

The queue management here seems a lot more complex than other drivers I
briefly looked at, which don't (a) allocate multiple descriptors at once
or (b) maintain a pool of free descriptors. I guess if this all works
it's fine, but it sure makes it harder for me to understand the driver
and review it. I'd personally love to have seen a much simpler driver
and then add these optimizations later if they prove worthwhile.

(As an aside, it seems like if this descriptor management logic is
worthwhile, it should be part of the dmaengine core, not individual drivers)

> +static irqreturn_t tegra_dma_isr(int irq, void *dev_id)
...
> +	if (status & STATUS_ISE_EOC) {
> +		tdc_write(tdc, TEGRA_APBDMA_CHAN_STATUS, status);
> +		if (!list_empty(&tdc->cb_desc)) {

Given that the tasklet is just running the completion callbacks, is this
condition really an error? Can't you just add some more entries onto the
tail of the list of callbacks for the tasklet?

> +			dev_err(tdc2dev(tdc),
> +				"Int before tasklet handled, Stopping DMA\n");
> +			tegra_dma_stop(tdc);
> +			tdc->isr_handler(tdc, true);
> +			tegra_dma_abort_all(tdc);
> +			/* Schedule tasklet to make callback */
> +			tasklet_schedule(&tdc->tasklet);
> +			goto end;
> +		}
> +		tdc->isr_handler(tdc, false);
> +		tasklet_schedule(&tdc->tasklet);
> +	} else {
> +		dev_info(tdc2dev(tdc),
> +			"Interrupt already handled status 0x%08lx\n", status);

Shouldn't this cause IRQ_NONE to be returned?

> +	}
> +
> +end:
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return IRQ_HANDLED;
> +}

> +static void tegra_dma_terminate_all(struct dma_chan *dc)
> +{

> +	if (!tdc->busy)
> +		goto skip_dma_stop;
> +
> +	/* Pause DMA before checking the queue status */
> +	tegra_dma_pause(tdc, true);
> +
> +	status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
> +	if (status & STATUS_ISE_EOC) {
> +		dev_dbg(tdc2dev(tdc), "%s():handling isr\n", __func__);
> +		tdc->isr_handler(tdc, true);
> +		status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
> +	}

In the termination case, do we really need to run the isr handler?
Presumably since the DMA is being aborted, the caller doesn't really
care about getting the absolute latest up-to-date information, so the
fact that something completed within the last
EGRA_APBDMA_BURST_COMPLETE_TIME micro-seconds isn't something it's worth
determining?

> +static int __devinit tegra_dma_probe(struct platform_device *pdev)

> +	tdma->dma_clk = clk_get(&pdev->dev, NULL);

Since this won't be applied until 3.6, I think you can use
devm_clk_get() here.

> +static int tegra_dma_suspend_noirq(struct device *dev)

Why do we need to implement the _noirq variants for system
suspend/resume? In the mainline kernel, the existence of deferred probe
most likely means we don't need to use _noirq any more.

> +static struct platform_driver tegra_dmac_driver = {
> +	.driver = {
> +		.name	= "tegra30-apbdma",

Probably better be tegra20-apbdma, since that's the first chip this
driver supports.

> +static int __init tegra_dmac_init(void)
> +{
> +	return platform_driver_register(&tegra_dmac_driver);
> +}
> +arch_initcall_sync(tegra_dmac_init);

Can we make this a module_init() instead of an arch_initcall?

> +static void __exit tegra_dmac_exit(void)
> +{
> +	platform_driver_unregister(&tegra_dmac_driver);
> +}
> +module_exit(tegra_dmac_exit);

If so, the above 11 lines can be replaced with:

module_platform_driver(tegra_dmac_driver);

Overall, I haven't reviewed the driver's interaction with dmaengine too
much since I'm not familiar with dmaengine. I think Vinod has been
covering those aspects fine. However, I did try to follow the DMA HW
programming, and I think it does avoid the problems we were trying to
solve in the existing APB DMA driver, perhaps mainly because dmaengine
doesn't expose quite as many functions to client code.

So overall, aside from the comments above, this looks good.
