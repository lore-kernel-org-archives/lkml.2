Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1KXMFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:05:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57166 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786Ab1KXMFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:05:45 -0500
Date: Thu, 24 Nov 2011 12:05:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v8
Message-ID: <20111124120541.GG8470@opensource.wolfsonmicro.com>
References: <1321607994.10344.20.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321607994.10344.20.camel@dhruva>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 02:49:54PM +0530, Ashish Jangam wrote:

There's still a few issues in here.  It'd be very much easier to review
this stuff if you split the patch down into smaller patches, for example
having the ADC, SPI and I2C as separate patches.  The bigger each
individual e-mail is the more work it is to review.

Please also try to fix whatever problems you're having posting patch
serieses - this claims to be patch 1/11 but it looked like only patches
numbered 1, 4 and 5 got posted and none of those were threaded together.

> +int da9052_adc_manual_read(struct da9052 *da9052, unsigned char channel)
> +{
> +	struct da9052_auxadc_req *req;
> +	int ret;
> +	unsigned short calc_data;
> +	unsigned short data;
> +	unsigned char mux_sel;
> +
> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;

This function sometimes returns errnos but at other times...

> +	ret = da9052_reg_read(da9052, DA9052_ADC_RES_H_REG);
> +	if (ret < 0)
> +		return IRQ_NONE;

...it returns irqreturn_t values.  In the above case I'd *really* expect
to see the error from the return passed back to the caller.  It also
looks like this error case returns with the auxadc_lock held which is
going to deadlock the next time someone tries to use the ADC - the same
problem exists for some other code.

> +int da9052_add_regulator_devices(struct da9052 *da9052,
> +				  struct da9052_pdata *pdata)
> +{
> +	struct platform_device *pdev;
> +	int i, ret;
> +
> +	for (i = 0; i < pdata->num_regulators; i++) {
> +		pdev = platform_device_alloc("da9052-regulator", i);
> +		if (!pdev)
> +			return -ENOMEM;
> +
> +		pdev->dev.parent = da9052->dev;
> +		ret = platform_device_add(pdev);
> +		if (ret) {
> +			platform_device_put(pdev);
> +			return ret;
> +		}

As I think has been previously said it's better style to unconditionally
register all the regulators the device has.  The core should cope fine
with missing platform data and this gives readback support for the
regulators that aren't software configured yet.

> +static struct mfd_cell __initdata da9052_subdev_info[] = {
> +	{"da9052-onkey", .resources = &da9052_onkey_resource,
> +	 .num_resources = 1},

Spaces around the { }.

> +	ret = request_threaded_irq(pdata->irq_base + 13,
> +				   NULL, da9052_auxadc_irq,

Should replace the magic number with a define.

> +	da9052_i2c->bustype = BUS_I2C;

bustype should be redundant now, it certianly doesn't seem to be
referred to in this patch.

> +/*
> + * Interrupt controller support for Dilaog DA9052 PMICs.

This looks very much like it could be replaced with regmap-irq.  The
code would be slightly less efficient due to the support for sparse
interrupt registers but it'd be less code.

> +static struct spi_driver da9053_ba_spi_driver = {
> +	.probe = da9052_spi_probe,
> +	.remove = __devexit_p(da9052_spi_remove),
> +	.driver = {
> +		.name = "da9053-ba",
> +		.bus = &spi_bus_type,
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static struct spi_driver da9053_bb_spi_driver = {

Use spi_device_id rather than registering multiple driver instances.
