Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1CRBFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 21:05:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:51965 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab1CRBFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 21:05:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="668522845"
Date: Fri, 18 Mar 2011 02:05:41 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 1/3] mfd: add a core driver for TI TPS61050/TPS61052
 chips
Message-ID: <20110318010540.GJ32172@sortiz-mobl>
References: <1299577241-31328-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299577241-31328-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Mar 08, 2011 at 10:40:41AM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The TPS61050/TPS61052 are boost converters, LED drivers, LED flash
> drivers and a simple GPIO pin chips.
Actualy, I had to fix some more stuff from this code:

> +int tps6105x_set(struct tps6105x *tps6105x, u8 reg, u8 value)
> +{
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&tps6105x->lock);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(tps6105x->client, reg, value);
> +	mutex_unlock(&tps6105x->lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +int tps6105x_get(struct tps6105x *tps6105x, u8 reg, u8 *buf)
> +{
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&tps6105x->lock);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_read_byte_data(tps6105x->client, reg);
> +	mutex_unlock(&tps6105x->lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	*buf = ret;
> +	return 0;
> +}
> +
> +/*
> + * Masks off the bits in the mask and sets the bits in the bitvalues
> + * parameter in one atomic operation
> + */
> +int tps6105x_mask_and_set(struct tps6105x *tps6105x, u8 reg,
> +			  u8 bitmask, u8 bitvalues)
> +{
> +	int ret;
> +	u8 regval;
> +
> +	ret = mutex_lock_interruptible(&tps6105x->lock);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_read_byte_data(tps6105x->client, reg);
> +	if (ret < 0)
> +		goto fail;
> +	regval = ret;
> +	regval = (~bitmask & regval) | (bitmask & bitvalues);
> +	ret = i2c_smbus_write_byte_data(tps6105x->client, reg, regval);
> +fail:
> +	mutex_unlock(&tps6105x->lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
Export the 3 above symbols for the regulator sub device to be able to build as
a module.

> +static int __devinit tps6105x_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct tps6105x			*tps6105x;
> +	struct tps6105x_platform_data	*pdata;
> +	int ret;
> +	int i;
> +
> +	tps6105x = kzalloc(sizeof(*tps6105x), GFP_KERNEL);
> +	if (!tps6105x)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, tps6105x);
> +	tps6105x->client = client;
> +	pdata = client->dev.platform_data;
> +	tps6105x->pdata = pdata;
> +	mutex_init(&tps6105x->lock);
> +
> +	ret = tps6105x_startup(tps6105x);
> +	if (ret) {
> +		dev_err(&client->dev, "chip initialization failed\n");
> +		goto fail;
> +	}
> +
> +	/* Set up and register the platform devices. */
> +	for (i = 0; i < ARRAY_SIZE(tps6105x_cells); i++) {
> +		/* One state holder for all drivers, this is simple */
> +		tps6105x_cells[i].driver_data = tps6105x;
driver_data has been replaced by mfd_data, and sub devices are supposed to
fetch it back with mfd_get_data(). I fixed the regulator driver as well,
please drop me a patch if it's not working as expected.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
