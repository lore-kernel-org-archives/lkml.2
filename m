Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2JVUCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:02:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55307 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2JVUCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:02:50 -0400
Message-ID: <5085A667.2000100@wwwdotorg.org>
Date: Mon, 22 Oct 2012 14:02:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] spi: tegra: add spi driver for SLINK controller
References: <1350557233-31234-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1350557233-31234-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 04:47 AM, Laxman Dewangan wrote:
> Tegra20/Tegra30 supports the spi interface through its SLINK
> controller. Add spi driver for SLINK controller.

> diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c

> +static inline void tegra_slink_writel(struct tegra_slink_data *tspi,
> +		unsigned long val, unsigned long reg)
> +{
> +	writel(val, tspi->base + reg);
> +
> +	/* Read back register to make sure that register writes completed */
> +	if (reg != SLINK_TX_FIFO)
> +		readl(tspi->base + SLINK_MAS_DATA);

Is that really necessary on every single write, or only for certain
specific operations? This seems rather heavy-weight.

> +static void tegra_slink_clear_status(struct tegra_slink_data *tspi)
> +{
> +	unsigned long val;
> +	unsigned long val_write = 0;
> +
> +	val = tegra_slink_readl(tspi, SLINK_STATUS);
> +
> +	/* Write 1 to clear status register */
> +	val_write = SLINK_RDY;
> +	val_write |= (val & SLINK_FIFO_ERROR);

Why not just always set SLINK_FIFO_ERROR; does it have to be set in the
write only if the status was previously asserted? If that is true, how
do you avoid a race condition where the bit gets set in SLINK_STATUS
after you read it but before you write to clear it?

> +	tegra_slink_writel(tspi, val_write, SLINK_STATUS);
> +}

> +static unsigned tegra_slink_calculate_curr_xfer_param(

> +	if (bits_per_word == 8 || bits_per_word == 16) {
> +		tspi->is_packed = 1;
> +		tspi->words_per_32bit = 32/bits_per_word;

Spaces required around all operators. Does this pass checkpatch? No:
total: 1405 errors, 11 warnings, 1418 lines checked

> +static unsigned tegra_slink_fill_tx_fifo_from_client_txbuf(

> +	if (tspi->is_packed) {
> +		nbytes = tspi->curr_dma_words * tspi->bytes_per_word;
> +		max_n_32bit = (min(nbytes,  tx_empty_count*4) - 1)/4 + 1;
> +		for (count = 0; count < max_n_32bit; ++count) {

Very minor almost irrelevant nit: count++ would be much more typical here.

> +			x = 0;
> +			for (i = 0; (i < 4) && nbytes; i++, nbytes--)
> +				x |= (*tx_buf++) << (i*8);
> +			tegra_slink_writel(tspi, x, SLINK_TX_FIFO);
> +		}
> +		written_words =  min(max_n_32bit * tspi->words_per_32bit,
> +					tspi->curr_dma_words);

The calculations here seem a little over-complex. Why not calculate the
FIFO space in words above, and just set written words based on that.
Something like:

fifo_words_left = tx_empty_count * spi->words_per_32bit;
written_words = min(fifo_words_left, tspi->curr_dma_words);
nbytes = written_words * spi->bytes_per_word;
max_n_32bit = (nbytes + 3) / 4;

Most likely a similar comment applies to all the other similar functions
for filling FIFOs and buffers.

In fact, I suspect you can completely get rid of the if (is_packed)
statement here by appropriately parameterising the code using variables
in *spi...

> +static unsigned int tegra_slink_read_rx_fifo_to_client_rxbuf(

> +		bits_per_word = t->bits_per_word ? t->bits_per_word :
> +						tspi->cur_spi->bits_per_word;

That logic is repeated a few times. Shouldn't there be a macro to avoid
cut/paste. Perhaps even in the SPI core rather than this driver.

> +		rx_mask = (1 << bits_per_word) - 1;
> +		for (count = 0; count < rx_full_count; ++count) {
> +			x = tegra_slink_readl(tspi, SLINK_RX_FIFO);
> +			x &= rx_mask;

I don't think you need that mask; the loop below only extracts bytes
that actually exist in the FIFO right?

> +			for (i = 0; (i < tspi->bytes_per_word); ++i)
> +				*rx_buf++ = (x >> (i*8)) & 0xFF;

> +static void tegra_slink_copy_client_txbuf_to_spi_txbuf(
> +		struct tegra_slink_data *tspi, struct spi_transfer *t)

Are there no cases where we can simply DMA straight into the client
buffer? I suppose it would be limited to cache-line-aligned
cache-line-size-aligned buffers which is probably unlikely in general:-(

> +static int tegra_slink_start_dma_based_transfer(
> +		struct tegra_slink_data *tspi, struct spi_transfer *t)

> +	/* Make sure that Rx and Tx fifo are empty */
> +	status = tegra_slink_readl(tspi, SLINK_STATUS);
> +	if ((status & SLINK_FIFO_EMPTY) != SLINK_FIFO_EMPTY)
> +		dev_err(tspi->dev,
> +			"Rx/Tx fifo are not empty status 0x%08lx\n", status);

Shouldn't this return an error, or drain the FIFO, or something?

> +static int tegra_slink_init_dma_param(struct tegra_slink_data *tspi,

> +	if (dma_to_memory) {
> +		dma_sconfig.src_addr = tspi->phys + SLINK_RX_FIFO;
> +		dma_sconfig.dst_addr = tspi->phys + SLINK_RX_FIFO;
> +	} else {
> +		dma_sconfig.src_addr = tspi->phys + SLINK_TX_FIFO;
> +		dma_sconfig.dst_addr = tspi->phys + SLINK_TX_FIFO;
> +	}

Surely each branch of that if should only initialize one of {src,dst}_addr?

> +static int tegra_slink_prepare_transfer(struct spi_master *master)
> +{
> +	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
> +
> +	pm_runtime_get_sync(tspi->dev);
> +	return 0;
> +}
> +
> +static int tegra_slink_unprepare_transfer(struct spi_master *master)
> +{
> +	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
> +
> +	pm_runtime_put_sync(tspi->dev);
> +	return 0;
> +}

Does this driver actually implement any runtime PM ops? I certainly
don't see any in struct dev_pm_ops tegra_slink_dev_pm_ops. Related, why
do tegra_slink_clk_{en,dis}able exist; shouldn't those functions be the
implementation of the runtime PM ops? Related, why are
tegra_slink_clk_{en,dis}able called all over the place, rather than
relying on runtime PM API calls, or tegra_slink_{,un}prepare_transfer
having been called?

> +static int tegra_slink_transfer_one_message(struct spi_master *master,
> +			struct spi_message *msg)
> +{
> +
> +	bool is_first_msg = true;

Unnecessary blank line there.

> +static irqreturn_t tegra_slink_isr_thread(int irq, void *context_data)

> +	if (!tspi->is_curr_dma_xfer) {
> +		handle_cpu_based_xfer(context_data);
> +		return IRQ_HANDLED;
> +	}

Minor nit: That implies the rest of the body of this function should be
in another function named handle_dma_based_xfer() for symmetry.

> +	/* Abort dmas if any error */
> +	if (tspi->cur_direction & DATA_DIR_TX) {
> +		if (tspi->tx_status) {
> +			dmaengine_terminate_all(tspi->tx_dma_chan);
> +			err += 1;
> +		} else {
> +			wait_status = wait_for_completion_interruptible_timeout(
> +				&tspi->tx_dma_complete, SLINK_DMA_TIMEOUT);
> +			if (wait_status <= 0) {
> +				dmaengine_terminate_all(tspi->tx_dma_chan);
> +				dev_err(tspi->dev, "TxDma Xfer failed\n");
> +				err += 1;
> +			}
> +		}
> +	}
> +
> +	if (tspi->cur_direction & DATA_DIR_RX) {
> +		if (tspi->rx_status) {
> +			dmaengine_terminate_all(tspi->rx_dma_chan);
> +			err += 2;
> +		} else {
> +			wait_status = wait_for_completion_interruptible_timeout(
> +				&tspi->rx_dma_complete, SLINK_DMA_TIMEOUT);
> +			if (wait_status <= 0) {
> +				dmaengine_terminate_all(tspi->rx_dma_chan);
> +				dev_err(tspi->dev, "RxDma Xfer failed\n");
> +				err += 2;
> +			}
> +		}
> +	}

So that all implies that we wait for the very first interrupt from the
SPI peripheral for a transfer, and then wait for the DMA controller to
complete all DMA (which would probably entail actually waiting for DMA
to drain the RX FIFO in the RX case). Does it make sense to simply
return from the ISR if not all conditions that we will wait on have
occurred, and so avoid blocking this ISR thread? I suppose since this
thread gets blocked rather than spinning, it's not a big deal though.

> +	spin_lock_irqsave(&tspi->lock, flags);
> +	if (err) {
> +		dev_err(tspi->dev,
> +			"DmaXfer: ERROR bit set 0x%x\n", tspi->status_reg);
> +		dev_err(tspi->dev,
> +			"DmaXfer 0x%08x:0x%08x:0x%08x\n", tspi->command_reg,
> +				tspi->command2_reg, tspi->dma_control_reg);
> +		tegra_periph_reset_assert(tspi->clk);
> +		udelay(2);
> +		tegra_periph_reset_deassert(tspi->clk);

Do we /have/ to reset the SPI block; can't we just disable it in the
control register, clear all status, and re-program it from scratch?

If at all possible, I would like to avoid introducing any new use of
tegra_periph_reset_{,de}assert, since that API has no standard subsystem
equivalent (or if it does, isn't hooked into the standard subsystem
yet), and hence means this driver relies on a header file currently in
arch/arm/mach-tegra/include/mach, and we need to move or delete all such
headers in order to support single zImage.

> +#ifdef CONFIG_OF

No need for this ifdef; Tegra always has CONFIG_OF enabled and always
boots using DT now in mainline.

> +static struct tegra_spi_platform_data *tegra_slink_parese_dt(

Typo, as thierry pointed out.

> +	prop = of_get_property(pdev->dev.of_node, "nvidia,dma-req-sel", NULL);
> +	if (prop)
> +		pdata->dma_req_sel = be32_to_cpup(prop);

At least, please lets use the standardize format for this, which is
<phandle select> not just <select>; see the I2S driver code. I thought
that's what the .dts patch you posted did...

> +	prop = of_get_property(pdev->dev.of_node, "spi_max_frequency", NULL);

Property names use - not _ as word separators. Isn't there a
standardized property for this? Yes, in fact it's spi-max-frequency
according to Documentation/devicetree/bindings/spi/spi-bus.txt.

Doesn't this function need to parse all the other standardized
properties from spi-bus.txt, or does the SPI core handle that?

> +const struct tegra_slink_chip_data tegra30_spi_cdata = {
> +	.cs_hold_time = true,
> +};
> +
> +#ifdef CONFIG_OF
> +const struct tegra_slink_chip_data tegra20_spi_cdata = {
> +	.cs_hold_time = false,
> +};

Again, no need for that ifdef. Why would the Tegra30 data be outside the
ifdef and the Tegra20 data be inside it anyway?

> +static int __devinit tegra_slink_probe(struct platform_device *pdev)

> +	if (!pdata && pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match = of_match_device(of_match_ptr(tegra_slink_of_match),
> +				&pdev->dev);
> +		if (!match) {
> +			dev_err(&pdev->dev, "Error: No device match found\n");
> +			return -ENODEV;
> +		}
> +		cdata = match->data;
> +		pdata = tegra_slink_parese_dt(pdev);
> +	} else {
> +		cdata = &tegra30_spi_cdata;
> +	}

That can be simplified since we know DT is enabled and used to boot, so
of_match_device() can always be called. The only conditional that's
needed is to check if explicit platform data was supplied to override
the DT.

> +	if (pdev->id != -1)
> +		master->bus_num = pdev->id;

That will never be the case, since we boot using DT.

> +	spi_irq = platform_get_irq(pdev, 0);
> +	if (unlikely(spi_irq < 0)) {

That should be <= or ==; 0 is an invalid IRQ. I imagine that
request_irq() checks that anyway, so you probably don't need to test it
here too.

> +	tspi->def_command_reg  = SLINK_M_S;
> +	tspi->def_command2_reg = SLINK_CS_ACTIVE_BETWEEN;
> +	tegra_slink_clk_enable(tspi);
> +	tegra_slink_writel(tspi, tspi->def_command_reg, SLINK_COMMAND);
> +	tegra_slink_writel(tspi, tspi->def_command2_reg, SLINK_COMMAND2);
> +	tegra_slink_clk_disable(tspi);
> +
> +	pm_runtime_enable(&pdev->dev);

There are register writes before that, so the runtime PM setup probably
should happen earlier. Also, once runtime PM is actually implemented,
you'll need to handle the case where kernel runtime PM support is
disabled. Check out tegra20_i2s.c for what I believe is the correct way
to handle this.


> +static int __devexit tegra_slink_remove(struct platform_device *pdev)
> +{
> +	struct spi_master	*master;
> +	struct tegra_slink_data	*tspi;
> +
> +	master = dev_get_drvdata(&pdev->dev);
> +	tspi = spi_master_get_devdata(master);

You can probably wrap those two assignments only the same line as the
declaration.

> +static const struct dev_pm_ops tegra_slink_dev_pm_ops = {
> +	.suspend = tegra_slink_suspend,
> +	.resume = tegra_slink_resume,
> +};
> +#define TEGRA_SPI_PM	(&tegra_slink_dev_pm_ops)
> +#else
> +#define TEGRA_SPI_PM	NULL
> +#endif
> +
> +static struct platform_driver tegra_slink_driver = {
> +	.driver = {
> +		.name =		"spi-tegra-slink",
> +		.owner =	THIS_MODULE,
> +		.pm =		&tegra_slink_dev_pm_ops,

Can't you use SET_SYSTEM_SLEEP_PM_OPS() to assign the ops, so you don't
have to #define TEGRA_SPI_PM (which you ended up not even using)?
