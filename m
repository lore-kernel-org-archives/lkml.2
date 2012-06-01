Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab2FAUAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:00:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35434 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759142Ab2FAUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:00:16 -0400
Message-ID: <4FC91F4A.4060706@wwwdotorg.org>
Date: Fri, 01 Jun 2012 14:00:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: dan.j.williams@intel.com, vinod.koul@intel.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V4 2/2] dma: tegra: add dmaengine based dma driver
References: <1337755542-16271-1-git-send-email-ldewangan@nvidia.com> <1337755542-16271-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1337755542-16271-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 12:45 AM, Laxman Dewangan wrote:
> Adding dmaengine based NVIDIA's Tegra APB DMA driver.
> This driver support the slave mode of data transfer from
> peripheral to memory and vice versa.
> The driver supports for the cyclic and non-cyclic mode
> of data transfer.

A few minor/nit-picky comments below. Apart from those,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>

> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig

> +config TEGRA20_APB_DMA
...
> +	help
> +	  Support for the NVIDIA Tegra20 APB DMA controller driver. The
> +	  dma controller is having multiple dma channel which can be

It would be nice if DMA was correctly capitalized everywhere, but I
guess I won't hold my ack for that.

> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c

Some of the register names don't exactly match the names in the TRM.
But, it's fairly obvious what the mapping is, so I won't hold my ack for
that.

> +static struct tegra_dma_desc *tegra_dma_desc_get(

> +	if (!list_empty(&tdc->free_dma_desc)) {
> +

Unnecessary blank line.

> +		/* Do not allocate if desc are waiting for ack */
> +		list_for_each_entry(dma_desc, &tdc->free_dma_desc, node) {
...
> +		}
> +	}

Doesn't list_for_each_entry() handle empty lists correctly? If so, you
can just remove the outer if(){} here, and in both loops in
tegra_dma_tx_status().

> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +
> +	/* Allocate dma desc */
> +	dma_desc = kzalloc(sizeof(*dma_desc), GFP_ATOMIC);
> +	if (!dma_desc) {
> +		dev_err(tdc2dev(tdc), "dma_desc alloc failed\n");
> +		return NULL;
> +	}
> +
> +	dma_async_tx_descriptor_init(&dma_desc->txd, &tdc->dma_chan);
> +	dma_desc->txd.tx_submit = tegra_dma_tx_submit;
> +	dma_desc->txd.flags = 0;
> +	return dma_desc;
> +}

> +static void tegra_dma_gloabl_pause(struct tegra_dma_channel *tdc,

s/gloabl/global/

> +static inline int get_bus_width(enum dma_slave_buswidth slave_bw)
...
> +	BUG_ON(!slave_bw);
...
> +	default:
> +		BUG();

Maybe just return errors in those 2 cases?

> +static int __devinit tegra_dma_probe(struct platform_device *pdev)
...
> +	tdma->dma_clk = clk_get(&pdev->dev, NULL);

Given this is going into 3.6, there's now devm_clk_get which you could
use. However, fixing this up can be done in a later patch if you want.

> +	/* Reset DMA controller */
> +	tegra_periph_reset_assert(tdma->dma_clk);
> +	tegra_periph_reset_deassert(tdma->dma_clk);

This happens inside clk_enable() the first time it is called, so it may
not really be necessary. It might negatively impact the conversion to
common clock which might be more difficult with these APIs being used.

Also, don't you need to sleep between those two calls?

> +err_pm_disable:
> +	pm_runtime_disable(&pdev->dev);

Don't you also need to cover the case where tegra_dma_runtime_resume()
was called, and you need to reverse that?
