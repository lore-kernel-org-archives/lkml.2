Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2KMRZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:25:51 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35108 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2KMRZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:25:49 -0500
Message-ID: <50A28299.6080809@wwwdotorg.org>
Date: Tue, 13 Nov 2012 10:25:45 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH] spi: tegra: add spi driver for sflash controller
References: <1352782854-25351-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1352782854-25351-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 10:00 PM, Laxman Dewangan wrote:
> Nvidia's Tegra20 have the SPI (SFLASH) controller to
> interface with spi flash device which is used for system
> boot. Add the spi driver for this controller.

> diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c

> +static void tegra_sflash_clear_status(struct tegra_sflash_data *tsd)
> +{
> +	unsigned long val;
> +	unsigned long val_write = 0;
> +
> +	val = tegra_sflash_readl(tsd, SPI_STATUS);

Why the read of the unused value. Is this to flush earlier bus
transactions, or just left over? If for bus flushing, a comment would be
useful.

> +	/* Write 1 to clear status register */
> +	val_write = SPI_RDY | SPI_FIFO_ERROR;
> +	tegra_sflash_writel(tsd, val_write, SPI_STATUS);
> +}

> +static irqreturn_t handle_cpu_based_xfer(struct tegra_sflash_data *tsd)
> +{
> +	struct spi_transfer *t = tsd->curr_xfer;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tsd->lock, flags);
> +	if (tsd->tx_status ||  tsd->rx_status ||

Nit: double-space after first || above.

> +static struct tegra_spi_platform_data *tegra_sflash_parse_dt(
> +		struct platform_device *pdev)

> +	prop = of_get_property(np, "spi-max-frequency", NULL);
> +	if (prop)
> +		pdata->spi_max_frequency = be32_to_cpup(prop);

Perhaps use of_property_read_u32()?

> +static int __devinit tegra_sflash_probe(struct platform_device *pdev)

> +	tsd->clk = devm_clk_get(&pdev->dev, "spi");
> +	if (IS_ERR(tsd->clk)) {
> +		dev_err(&pdev->dev, "can not get clock\n");
> +		ret = PTR_ERR(tsd->clk);
> +		goto exit_free_irq;
> +	}
> +
> +
> +	tsd->spi_max_frequency = pdata->spi_max_frequency;

Nit: Double blank-line there.

> +static int tegra_sflash_resume(struct device *dev)
> +{
> +	struct spi_master *master = dev_get_drvdata(dev);
> +	struct tegra_sflash_data *tsd = spi_master_get_devdata(master);
> +	int ret;
> +
> +	ret = pm_runtime_get_sync(dev);
> +	if (ret < 0) {
> +		dev_err(dev, "pm runtime failed, e = %d\n", ret);
> +		return ret;
> +	}
> +	tegra_sflash_writel(tsd, tsd->command_reg, SPI_COMMAND);
> +	pm_runtime_put(dev);

Can we avoid this whole function simply by programming SPI_COMMAND at
the start of each transaction? That seems simpler. I assume that
shouldn't e.g. leave any chip-selects in some bad state, or at least if
it does, that shouldn't be a problem, because before the driver probes()
at kernel boot, SPI_COMMAND won't have been programmed either.

Aside from that,

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

Thanks.
