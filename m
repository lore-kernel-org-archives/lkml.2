Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab2INKIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:08:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52038 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab2INKIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:08:13 -0400
Date: Fri, 14 Sep 2012 12:08:06 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>, Jean Delvare <khali@linux-fr.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/4] i2c: introduce i2c-cbus driver
Message-ID: <20120914100806.GC2630@pengutronix.de>
References: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
 <1346703805-31598-2-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <1346703805-31598-2-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 03, 2012 at 11:23:22PM +0300, Aaro Koskinen wrote:
> Add i2c driver to enable access to devices behind CBUS on Nokia Internet
> Tablets.
>=20
> The patch also adds CBUS I2C configuration for N8x0 which is one of the
> users of this driver.
>=20
> Cc: linux-i2c@vger.kernel.org
> Acked-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

OK, I found the short paragrahp about CBUS in the I2C spec, so I2C might
be an appropriate place. Still, before deciding if it should rather be
in the core directory, I still have a few questions.

Also, does anybody know of a generic bit-banging implementation in the
kernel which could be used here?

Jean: I'd appreciate your general opinion here, too.

> diff --git a/drivers/i2c/busses/i2c-cbus.c b/drivers/i2c/busses/i2c-cbus.c
> new file mode 100644
> index 0000000..bacf2a9
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-cbus.c
> @@ -0,0 +1,369 @@
> +/*
> + * CBUS I2C driver for Nokia Internet Tablets.
> + *
> + * Copyright (C) 2004-2010 Nokia Corporation
> + *
> + * Based on code written by Juha Yrj=F6l=E4, David Weinehall, Mikko Ylin=
en and
> + * Felipe Balbi. Converted to I2C driver by Aaro Koskinen.
> + *
> + * This file is subject to the terms and conditions of the GNU General
> + * Public License. See the file "COPYING" in the main directory of this
> + * archive for more details.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/i2c.h>
> +#include <linux/gpio.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
> +#include <linux/i2c-cbus.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +
> +struct cbus_host {
> +	/* host lock */
> +	spinlock_t	lock;
> +
> +	struct device	*dev;
> +
> +	int		clk_gpio;
> +	int		dat_gpio;
> +	int		sel_gpio;
> +};
> +
> +/**
> + * cbus_send_bit - sends one bit over the bus
> + * @host: the host we're using
> + * @bit: one bit of information to send
> + * @input: whether to set data pin as input after sending
> + */
> +static int cbus_send_bit(struct cbus_host *host, unsigned bit,
> +		unsigned input)
> +{
> +	int ret =3D 0;
> +
> +	gpio_set_value(host->dat_gpio, bit ? 1 : 0);
> +	gpio_set_value(host->clk_gpio, 1);
> +
> +	/* The data bit is read on the rising edge of CLK */

This comment doesn't belong to the if-block, or?

> +	if (input)
> +		ret =3D gpio_direction_input(host->dat_gpio);

No minimum delay for the signal to be on the bus?

> +
> +	gpio_set_value(host->clk_gpio, 0);
> +
> +	return ret;
> +}
> +
> +/**
> + * cbus_send_data - sends @len amount of data over the bus
> + * @host: the host we're using
> + * @data: the data to send
> + * @len: size of the transfer
> + * @input: whether to set data pin as input after sending
> + */
> +static int cbus_send_data(struct cbus_host *host, unsigned data, unsigne=
d len,
> +		unsigned input)
> +{
> +	int ret =3D 0;
> +	int i;
> +
> +	for (i =3D len; i > 0; i--) {
> +		ret =3D cbus_send_bit(host, data & (1 << (i - 1)),
> +				input && (i =3D=3D 1));
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +/**
> + * cbus_receive_bit - receives one bit from the bus
> + * @host: the host we're using
> + */
> +static int cbus_receive_bit(struct cbus_host *host)
> +{
> +	int ret;
> +
> +	gpio_set_value(host->clk_gpio, 1);

No delays to ensure the signal has stabilized?

> +	ret =3D gpio_get_value(host->dat_gpio);
> +	if (ret < 0)
> +		goto out;
> +	gpio_set_value(host->clk_gpio, 0);
> +
> +out:
> +	return ret;
> +}
> +
> +/**
> + * cbus_receive_word - receives 16-bit word from the bus
> + * @host: the host we're using
> + */
> +static int cbus_receive_word(struct cbus_host *host)
> +{
> +	int ret =3D 0;
> +	int i;
> +
> +	for (i =3D 16; i > 0; i--) {
> +		int bit =3D cbus_receive_bit(host);
> +
> +		if (bit < 0)
> +			goto out;
> +
> +		if (bit)
> +			ret |=3D 1 << (i - 1);
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +/**
> + * cbus_transfer - transfers data over the bus
> + * @host: the host we're using
> + * @rw: read/write flag
> + * @dev: device address
> + * @reg: register address
> + * @data: if @rw =3D=3D I2C_SBUS_WRITE data to send otherwise 0
> + */
> +static int cbus_transfer(struct cbus_host *host, char rw, unsigned dev,
> +			 unsigned reg, unsigned data)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	/* We don't want interrupts disturbing our transfer */
> +	spin_lock_irqsave(&host->lock, flags);
> +
> +	/* Reset state and start of transfer, SEL stays down during transfer */
> +	gpio_set_value(host->sel_gpio, 0);
> +
> +	/* Set the DAT pin to output */
> +	gpio_direction_output(host->dat_gpio, 1);
> +
> +	/* Send the device address */
> +	ret =3D cbus_send_data(host, dev, 3, 0);

Is the device address always 3 bit? From the (admittetly sparse) I2C
spec, I'd assume to be 7?

> +	if (ret < 0) {
> +		dev_dbg(host->dev, "failed sending device addr\n");
> +		goto out;
> +	}
> +
> +	/* Send the rw flag */
> +	ret =3D cbus_send_bit(host, rw =3D=3D I2C_SMBUS_READ, 0);
> +	if (ret < 0) {
> +		dev_dbg(host->dev, "failed sending read/write flag\n");
> +		goto out;
> +	}
> +
> +	/* Send the device address */

Comment is wrong.

> +	ret =3D cbus_send_data(host, reg, 5, rw =3D=3D I2C_SMBUS_READ);

Is reg always 5 bit?

> +	if (ret < 0) {
> +		dev_dbg(host->dev, "failed sending register addr\n");
> +		goto out;
> +	}
> +
> +	if (rw =3D=3D I2C_SMBUS_WRITE) {
> +		ret =3D cbus_send_data(host, data, 16, 0);
> +		if (ret < 0) {
> +			dev_dbg(host->dev, "failed sending data\n");
> +			goto out;
> +		}
> +	} else {

What about setting dat to input here and drop the parameter from
cbus_data_send()?

> +		gpio_set_value(host->clk_gpio, 1);
> +
> +		ret =3D cbus_receive_word(host);
> +		if (ret < 0) {
> +			dev_dbg(host->dev, "failed receiving data\n");
> +			goto out;
> +		}
> +	}
> +
> +	/* Indicate end of transfer, SEL goes up until next transfer */
> +	gpio_set_value(host->sel_gpio, 1);
> +	gpio_set_value(host->clk_gpio, 1);
> +	gpio_set_value(host->clk_gpio, 0);
> +
> +out:
> +	spin_unlock_irqrestore(&host->lock, flags);
> +
> +	return ret;
> +}
> +
> +static int cbus_i2c_smbus_xfer(struct i2c_adapter	*adapter,
> +			       u16			addr,
> +			       unsigned short		flags,
> +			       char			read_write,
> +			       u8			command,
> +			       int			size,
> +			       union i2c_smbus_data	*data)
> +{
> +	struct cbus_host *chost =3D i2c_get_adapdata(adapter);
> +	int ret;
> +
> +	if (size !=3D I2C_SMBUS_WORD_DATA)
> +		return -EINVAL;
> +
> +	ret =3D cbus_transfer(chost, read_write =3D=3D I2C_SMBUS_READ, addr,
> +			    command, data->word);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (read_write =3D=3D I2C_SMBUS_READ)
> +		data->word =3D ret;
> +
> +	return 0;
> +}
> +
> +static u32 cbus_i2c_func(struct i2c_adapter *adapter)
> +{
> +	return I2C_FUNC_SMBUS_READ_WORD_DATA | I2C_FUNC_SMBUS_WRITE_WORD_DATA;
> +}
> +
> +static const struct i2c_algorithm cbus_i2c_algo =3D {
> +	.smbus_xfer	=3D cbus_i2c_smbus_xfer,
> +	.functionality	=3D cbus_i2c_func,
> +};
> +
> +static int cbus_i2c_remove(struct platform_device *pdev)
> +{
> +	struct i2c_adapter *adapter =3D platform_get_drvdata(pdev);
> +	struct cbus_host *chost =3D i2c_get_adapdata(adapter);
> +	int ret;
> +
> +	ret =3D i2c_del_adapter(adapter);
> +	if (ret)
> +		return ret;
> +	gpio_free(chost->clk_gpio);
> +	gpio_free(chost->dat_gpio);
> +	gpio_free(chost->sel_gpio);
> +	kfree(chost);
> +	kfree(adapter);

Please use devm_gpio_* and devm_kzalloc_*

> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +
> +static int cbus_i2c_probe(struct platform_device *pdev)
> +{
> +	struct i2c_adapter *adapter;
> +	struct cbus_host *chost;
> +	struct gpio gpios[3];
> +	int ret;
> +
> +	adapter =3D kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
> +	if (!adapter) {
> +		ret =3D -ENOMEM;
> +		goto error;
> +	}
> +
> +	chost =3D kzalloc(sizeof(*chost), GFP_KERNEL);
> +	if (!chost) {
> +		ret =3D -ENOMEM;
> +		goto error_mem;
> +	}
> +
> +	if (pdev->dev.of_node) {
> +		struct device_node *dnode =3D pdev->dev.of_node;
> +		if (of_gpio_count(dnode) !=3D 3) {
> +			ret =3D -ENODEV;
> +			goto error_mem;
> +		}
> +		chost->clk_gpio =3D of_get_gpio(dnode, 0);
> +		chost->dat_gpio =3D of_get_gpio(dnode, 1);
> +		chost->sel_gpio =3D of_get_gpio(dnode, 2);
> +	} else if (pdev->dev.platform_data) {
> +		struct i2c_cbus_platform_data *pdata =3D pdev->dev.platform_data;
> +		chost->clk_gpio =3D pdata->clk_gpio;
> +		chost->dat_gpio =3D pdata->dat_gpio;
> +		chost->sel_gpio =3D pdata->sel_gpio;
> +	} else {
> +		ret =3D -ENODEV;
> +		goto error_mem;
> +	}
> +
> +	adapter->owner		=3D THIS_MODULE;
> +	adapter->class		=3D I2C_CLASS_HWMON;
> +	adapter->dev.parent	=3D &pdev->dev;
> +	adapter->nr		=3D pdev->id;
> +	adapter->timeout	=3D HZ;
> +	adapter->algo		=3D &cbus_i2c_algo;
> +	strlcpy(adapter->name, "CBUS I2C adapter", sizeof(adapter->name));
> +
> +	spin_lock_init(&chost->lock);
> +	chost->dev =3D &pdev->dev;
> +
> +	gpios[0].gpio  =3D chost->clk_gpio;
> +	gpios[0].flags =3D GPIOF_OUT_INIT_LOW;
> +	gpios[0].label =3D "CBUS clk";
> +
> +	gpios[1].gpio  =3D chost->dat_gpio;
> +	gpios[1].flags =3D GPIOF_IN;
> +	gpios[1].label =3D "CBUS data";
> +
> +	gpios[2].gpio  =3D chost->sel_gpio;
> +	gpios[2].flags =3D GPIOF_OUT_INIT_HIGH;
> +	gpios[2].label =3D "CBUS sel";
> +
> +	ret =3D gpio_request_array(gpios, ARRAY_SIZE(gpios));
> +	if (ret)
> +		goto error_gpio;
> +
> +	gpio_set_value(chost->clk_gpio, 1);
> +	gpio_set_value(chost->clk_gpio, 0);

What is that pulse needed for?

> +
> +	i2c_set_adapdata(adapter, chost);
> +	platform_set_drvdata(pdev, adapter);
> +
> +	ret =3D i2c_add_numbered_adapter(adapter);
> +	if (ret)
> +		goto error_i2c;
> +
> +	return 0;
> +
> +error_i2c:
> +	gpio_free_array(gpios, ARRAY_SIZE(gpios));
> +error_gpio:
> +	kfree(chost);
> +error_mem:
> +	kfree(adapter);
> +error:
> +	return ret;
> +}
> +
> +#if defined(CONFIG_OF)
> +static const struct of_device_id i2c_cbus_dt_ids[] =3D {
> +	{ .compatible =3D "i2c-cbus", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, i2c_cbus_dt_ids);
> +#endif
> +
> +static struct platform_driver cbus_i2c_driver =3D {
> +	.probe	=3D cbus_i2c_probe,
> +	.remove	=3D cbus_i2c_remove,
> +	.driver	=3D {
> +		.owner	=3D THIS_MODULE,
> +		.name	=3D "i2c-cbus",
> +	},
> +};
> +module_platform_driver(cbus_i2c_driver);
> +
> +MODULE_ALIAS("platform:i2c-cbus");
> +MODULE_DESCRIPTION("CBUS I2C driver");
> +MODULE_AUTHOR("Juha Yrj=F6l=E4");
> +MODULE_AUTHOR("David Weinehall");
> +MODULE_AUTHOR("Mikko Ylinen");
> +MODULE_AUTHOR("Felipe Balbi");
> +MODULE_AUTHOR("Aaro Koskinen <aaro.koskinen@iki.fi>");
> +MODULE_LICENSE("GPL");

So much for now.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlBTAgYACgkQD27XaX1/VRtqOwCfY1ZxcvrEozDjqhuJLbeKZxGr
et4AnA+F3x5FRZPUiEvdlQnDg0ek9g+f
=TYZ0
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
