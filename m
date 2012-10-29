Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2J2TOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:14:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45265 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2J2TOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:14:49 -0400
Message-ID: <508ED5A5.3000703@wwwdotorg.org>
Date: Mon, 29 Oct 2012 13:14:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2] spi: tegra: add spi driver for SLINK controller
References: <1351531104-1604-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1351531104-1604-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 11:18 AM, Laxman Dewangan wrote:
> Tegra20/Tegra30 supports the spi interface through its SLINK
> controller. Add spi driver for SLINK controller.

> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig

> +config SPI_TEGRA20_SLINK
> +	tristate "Nvidia Tegra20/Tegra30 SLINK Controller"
> +	depends on ARCH_TEGRA && TEGRA20_APB_DMA

I think it depends on DMAENGINE, not the specific driver now, doesn't it?

> +static unsigned tegra_slink_fill_tx_fifo_from_client_txbuf(
> +	struct tegra_slink_data *tspi, struct spi_transfer *t)

> +	if (tspi->is_packed) {
> +		fifo_words_left = tx_empty_count * tspi->words_per_32bit;
> +		written_words = min(fifo_words_left, tspi->curr_dma_words);
> +		nbytes = written_words * tspi->bytes_per_word;
> +		max_n_32bit = DIV_ROUND_UP(nbytes, 4);
> +		for (count = 0; count < max_n_32bit; count++) {
> +			x = 0;
> +			for (i = 0; (i < 4) && nbytes; i++, nbytes--)
> +				x |= (*tx_buf++) << (i*8);
> +			tegra_slink_writel(tspi, x, SLINK_TX_FIFO);
> +		}
> +	} else {
> +		max_n_32bit = min(tspi->curr_dma_words,  tx_empty_count);
> +		written_words = max_n_32bit;
> +		nbytes = written_words * tspi->bytes_per_word;
> +		for (count = 0; count < max_n_32bit; count++) {
> +			x = 0;
> +			for (i = 0; nbytes && (i < tspi->bytes_per_word);
> +							i++, nbytes--)
> +				x |= ((*tx_buf++) << i*8);
> +			tegra_slink_writel(tspi, x, SLINK_TX_FIFO);
> +		}
> +	}

The if and the else there are basically identical now. Can't the else
branch simply be replaced by the if branch? At most I think the
difference comes down to max_n_32bit v.s. fifo_words_left calculations
being slight different; everything else is the same.

I suppose this isn't a big deal though; we could clean it up later if
necessary.

> +static int tegra_slink_start_cpu_based_transfer(
> +		struct tegra_slink_data *tspi, struct spi_transfer *t)

> +	tspi->is_curr_dma_xfer = false;
> +	if (tspi->is_packed) {
> +		val |= SLINK_PACKED;
> +		tegra_slink_writel(tspi, val, SLINK_DMA_CTL);
> +		udelay(1);
> +		wmb();

Why the udelay() and wmb()?

> +static int tegra_slink_runtime_suspend(struct device *dev)
> +{
> +	struct spi_master *master = dev_get_drvdata(dev);
> +	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
> +
> +	tegra_slink_clk_unprepare(tspi);
> +	return 0;
> +}
> +
> +static int tegra_slink_runtime_resume(struct device *dev)
> +{
> +	struct spi_master *master = dev_get_drvdata(dev);
> +	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
> +
> +	return tegra_slink_clk_prepare(tspi);
> +}

Why not move the body of tegra_slink_clk_{un,prepare} inside those
functions, since they're only called from those functions?

> +MODULE_ALIAS("platform:tegra_slink-slink");

I think that's a typo.
