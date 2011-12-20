Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1LTNXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 08:23:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47966 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab1LTNXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 08:23:21 -0500
Date: Tue, 20 Dec 2011 13:23:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3 v2] sound/soc/lapis: add platform driver for ML7213
 IOH I2S
Message-ID: <20111220132314.GQ2866@opensource.wolfsonmicro.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
 <1324349144-12784-3-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324349144-12784-3-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 11:45:44AM +0900, Tomoya MORINAGA wrote:

> +static int ignore_overrun = 1;
> +module_param(ignore_overrun, int, 0444);
> +MODULE_PARM_DESC(ignore_overrun, "ignore RX overruns (default=0)");

This shouldn't be a driver specific thing, and if we were to have such a
feature a module parameter doesn't seem like a great way of doing it.

> +/*****************************************************************************
> + *	I2S HAL (Hardware Abstruction Layer)
> + *****************************************************************************/

Please follow the kernel coding style in terms of comments.

> +static void ioh_i2s_enable_interrupts(int ch, enum dma_data_direction dir)
> +{
> +	unsigned int intr_lines;
> +
> +	if (dir)
> +		intr_lines = 1 << (I2S_IMASK_RX_BIT_START + ch);
> +
> +	else
> +		intr_lines = 1 << (I2S_IMASK_TX_BIT_START + ch);

I'd expect a switch statement corresponding to the enum, not an if
statement.

> +static void ioh_i2s_disable_interrupts(int ch, enum dma_data_direction dir)
> +{
> +	unsigned int intr_lines;
> +
> +	/*intr_lines&=I2S_ALL_INTERRUPT_BITS; */
> +	intr_lines = ioread32(i2s_data->iobase + I2SIMASK_OFFSET);

What's this commented out code for?  Also as a coding style thing
you should have a space between /* and the text in the comment (this
applies throughout the driver).

> +	/*disable interrupts for specified channel */
> +	if (dir)
> +		intr_lines |= 1 << (I2S_IMASK_RX_BIT_START + ch);
> +	else
> +		intr_lines |= 1 << (I2S_IMASK_TX_BIT_START + ch);
> +
> +	/*Mask the specific interrupt bits */
> +	iowrite32(intr_lines, i2s_data->iobase + I2SIMASK_OFFSET);

What ensures that this read/modify/write cycle can't race with another
caller?

> +/* Clear interrupt status */
> +static void ioh_i2s_clear_tx_sts_ir(int ch)
> +{
> +	int offset = ch * 0x800;
> +
> +	iowrite32(I2S_TX_FINT | I2S_TX_AFINT | I2S_TX_EINT | I2S_TX_AEINT,
> +		i2s_data->iobase + I2SISTTX_OFFSET + offset);
> +}

This appears to unconditionally acknowledge all interrupts, generally
you should only acknowledge interrupts that have been handled.
Otherwise it's possible that interrupts may be dropped if they're
flagged between the status read and acknowledgement write.

> +/*****************************************************************************
> + *	I2S Middle ware
> + *****************************************************************************/

I'm really not convinced of the value of these layers, reading the code
it really feels incredibly verbose in comparison with what I'd expect
from such a driver and I can't help that think that a lot of this
verbosity is down to muddling through these abstraction layers.

> +static bool filter(struct dma_chan *chan, void *slave)

This needs a better name.  It's not namespaced and it's not clear what
it's filtering.

> +static struct dma_chan *ioh_request_dma_channel(
> +		   int ch, struct ioh_i2s_dma *dma, enum dma_data_direction dir)
> +{
> +	dma_cap_mask_t mask;
> +	struct dma_chan *chan;
> +	struct pci_dev *dma_dev;
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_SLAVE, mask);
> +
> +	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(0, 1)); /* Get DMA's dev
> +								information */
> +
> +	if (dir == DMA_FROM_DEVICE) { /* Rx */

switch statement to select between multiple options in the enum.  This
applies throughout the code.

> +static void
> +ioh_i2s_write(struct snd_pcm_substream *substream, const void *data, int len)
> +{
> +	int rem1;
> +	int rem2;

What is this supposed to do?  There's an awful lot of it, and it looks
like it's supposed to be rewriting the data format for some reason which
isn't something that a driver ought to be doing (apart from anything
else it does rather defeat the point of DMA).

> +static void ioh_i2s_configure_i2s_regs(int ch, enum ioh_direction dir)
> +{
> +	int offset = ch * 0x800;

You should have a function to map the channel into a number.

> +
> +	if (dir) {
> +		/* Rx register */
> +		iowrite32(I2S_AFULL_THRESH / 2,
> +			  i2s_data->iobase + I2SAFRX_OFFSET + offset);
> +		iowrite32(0x1F, i2s_data->iobase + I2SAERX_OFFSET + offset);
> +		iowrite32(0x1F, i2s_data->iobase + I2SMSKRX_OFFSET + offset);
> +		iowrite32(0xC, i2s_data->iobase + I2SISTRX_OFFSET + offset);

Lots of magic numbers here and given that the function is called just
"configure" it's not clear what the intended purpose is.  This needs to
be clarified.

> +		/* Rx configuration */
> +		if (atomic_read(&dma->rx_busy)) {
> +			dev_err(i2s_data->dev, "rx i2s%dalready opened\n", ch);

...

> +	} else {
> +		/* Tx configuration */
> +		if (atomic_read(&dma->tx_busy)) {

There's a *lot* of duplicate code in the driver for TX and RX, it should
be possible to abstract out much more common code.

> +static void i2s_tx_almost_empty_ir(int ch)
> +{
> +	struct dma_async_tx_descriptor *desc;
> +	int num;
> +	int tx_comp_index;
> +	struct ioh_i2s_dma *dma = &dmadata[ch];
> +	struct scatterlist *sg = dma->sg_tx_p;
> +	void *cb_ch;
> +
> +	dev_dbg(i2s_data->dev, "%s: data_head=%p data_complete=%p\n", __func__,
> +		dma->tx_data_head, dma->tx_complete);
> +
> +	num = ((int)dma->tx_avail) / (I2S_AEMPTY_THRESH * 4);

That case looks *very* suspect.

> +	tx_comp_index = (((int)(dma->tx_complete - dma->tx_head))) /\
> +			(I2S_AEMPTY_THRESH * 4);

There is very rarely any need for line continuations outside of macros.

> +static inline void ioh_i2s_interrupt_sub_tx(int ch)
> +{
> +	unsigned int status;
> +	int offset = ch * 0x800;
> +
> +	status = ioread32(i2s_data->iobase + I2SISTTX_OFFSET + offset);
> +	if (status & I2S_TX_EINT)
> +		i2s_tx_empty_ir(ch);
> +	if (status & I2S_TX_AEINT)
> +		i2s_tx_almost_empty_ir(ch);

Given that all you're doing is logging just open code the log message.

> +	default:
> +		return -1;

Return error codes, you EPERM almost certainly isn't the error you meant
to report.

> +static int ioh_i2s_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	int ret;
> +
> +	ioh_i2s_save_reg_conf(pdev);

You should be doing this in ASoC suspend/resume callbacks, not in PCI
ones.
