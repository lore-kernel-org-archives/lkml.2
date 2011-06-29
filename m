Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1F2DUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 23:20:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54306 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751645Ab1F2DUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 23:20:40 -0400
Date: Tue, 28 Jun 2011 20:20:35 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: arnd@arndb.de, sameo@openedhand.com, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/11] MFD: DA9052 MFD core module v1
Message-ID: <20110629032033.GC22472@opensource.wolfsonmicro.com>
References: <1309270609.376.226.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309270609.376.226.camel@L-0532.kpit.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 07:46:49PM +0530, ashishj3 wrote:

> +static int da9052_add_subdevs(struct da9052 *da9052)
> +{
> +	struct da9052_pdata *pdata = da9052->dev->platform_data;
> +	int ret;
> +
> +	static struct mfd_cell __initdata da9052_subdev_info[] = {
> +		{"da9052-onkey", .resources = &da9052_onkey_resource,
> +		 .num_resources = 1},

It seems a bit odd that this is embedded into the function?

> +		{"da9052-gpio", .resources = NULL, .num_resources = 0},

No need to explicitly initialize static data to zero.

> +int da9052_device_init(struct da9052 *da9052)
> +{
> +	struct da9052_pdata *pdata = da9052->dev->platform_data;
> +	int ret;
> +
> +	mutex_init(&da9052->io_lock);
> +	mutex_init(&da9052->auxadc_lock);
> +	pdata->init(da9052);

This will crash if no init() function is provided which seems wrong,
especially when I'd expect people wouldn't have any need to use such a
callback normally.

> +
> +	ret  = da9052_add_subdevs(da9052);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = da9052_irq_init(da9052, pdata);
> +	if (ret != 0)
> +		return ret;
> +
> +	return 0;
> +}

This doesn't remove things it added when it failed.

> +	for (raddr = reg ; raddr < reg + bytes; raddr++) {
> +		raddr = (raddr << 1);
> +
> +		spi_message_init(&message);
> +		memset(&xfer, 0, sizeof(xfer));
> +
> +		xfer.len = 2;
> +		xfer.tx_buf = da9052->spi_tx_buf;
> +		xfer.rx_buf = da9052->spi_rx_buf;
> +
> +		da9052->spi_tx_buf[0] = raddr;
> +		da9052->spi_tx_buf[1] = *val++;
> +
> +		spi_message_add_tail(&xfer, &message);
> +
> +		spi_sync(da9052->spi_dev, &message);
> +	}

This looks like an open coded spi_write().

> +	for (raddr = reg ; raddr < reg + bytes; raddr++) {
> +		reg = ((raddr << 1) | da9052->rw_pol);
> +
> +		spi_message_init(&message);
> +		memset(&xfer, 0, sizeof(xfer));
> +
> +		xfer.len = 2;
> +		xfer.tx_buf = da9052->spi_tx_buf;
> +		xfer.rx_buf = da9052->spi_rx_buf;
> +
> +		da9052->spi_tx_buf[0] = raddr;
> +		da9052->spi_tx_buf[1] = 0xff;
> +
> +		da9052->spi_rx_buf[0] = 0;
> +		da9052->spi_rx_buf[1] = 0;
> +
> +		spi_message_add_tail(&xfer, &message);
> +
> +		ret = spi_sync(da9052->spi_dev, &message);
> +
> +		if (ret == 0) {
> +			*val = da9052->spi_rx_buf[1];
> +			val++;
> +			return 0;
> +		}

This looks like an open coded spi_write_then_read(), or even better
spi_w8r8().

> +	da9052_spi->spi_tx_buf = kmalloc(2, GFP_KERNEL | GFP_DMA);
> +	if (!da9052_spi->spi_tx_buf) {
> +		ret = -ENOMEM;
> +		goto err_spi_rx_buf;
> +	}

It would be better to just allocate the array as part of the structure,
a separate allocation just uses more memory for both the pointer and the
blocks that are used for the allocation.

> +static struct spi_driver da9052_spi_driver = {
> +	.probe = da9052_spi_probe,
> +	.remove = __devexit_p(da9052_spi_remove),
> +	. driver = {
> +		.name = "da9052_spi",

Why the _spi?

> index 0000000..c005a28
> --- /dev/null
> +++ b/include/linux/mfd/da9052/da9052.h

> +static const int32_t tbat_lookup[255] = {

This shouldn't be in a header file.  If it needs to be shared between
multiple modules define it in one place and add the prototype in the
header file.
