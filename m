Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2HUK5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:57:36 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:34383 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab2HUK5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:57:33 -0400
Date: Tue, 21 Aug 2012 13:53:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [RFC/PATCH 4/4] gpio: smscece: Add support for gpio IO expander
 feature
Message-ID: <20120821105333.GW10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-5-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Y6L//1es8ezVqBy"
Content-Disposition: inline
In-Reply-To: <1345545940-2232-5-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Y6L//1es8ezVqBy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 21, 2012 at 04:15:40PM +0530, Sourav Poddar wrote:
> smsc can be used as an gpio io expander device also. So adding
> support for configuring smsc pins as a gpio.
>=20
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
>  drivers/gpio/Kconfig        |    7 +
>  drivers/gpio/Makefile       |    1 +
>  drivers/gpio/gpio-smscece.c |  373 +++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 381 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/gpio-smscece.c
>=20
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index b16c8a7..e883929 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -444,6 +444,13 @@ config GPIO_ADP5588_IRQ
>  	  Say yes here to enable the adp5588 to be used as an interrupt
>  	  controller. It requires the driver to be built in the kernel.
> =20
> +config GPIO_SMSCECE
> +	tristate "SMSCECE 1099 I2C GPIO expander"
> +	depends on I2C
> +	help
> +	  This option enables support for 18 GPIOs found
> +	  on SMSC ECE 1099 GPIO Expanders.
> +
>  comment "PCI GPIO expanders:"
> =20
>  config GPIO_CS5535
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 153cace..7c803c5 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -12,6 +12,7 @@ obj-$(CONFIG_GPIO_74X164)	+=3D gpio-74x164.o
>  obj-$(CONFIG_GPIO_AB8500)	+=3D gpio-ab8500.o
>  obj-$(CONFIG_GPIO_ADP5520)	+=3D gpio-adp5520.o
>  obj-$(CONFIG_GPIO_ADP5588)	+=3D gpio-adp5588.o
> +obj-$(CONFIG_GPIO_SMSCECE)      +=3D gpio-smscece.o
>  obj-$(CONFIG_GPIO_AMD8111)	+=3D gpio-amd8111.o
>  obj-$(CONFIG_GPIO_ARIZONA)	+=3D gpio-arizona.o
>  obj-$(CONFIG_GPIO_BT8XX)	+=3D gpio-bt8xx.o
> diff --git a/drivers/gpio/gpio-smscece.c b/drivers/gpio/gpio-smscece.c
> new file mode 100644
> index 0000000..0cb0959
> --- /dev/null
> +++ b/drivers/gpio/gpio-smscece.c
> @@ -0,0 +1,373 @@
> +/*
> + * GPIO Chip driver for smsc
> + * SMSC I/O Expander and QWERTY Keypad Controller
> + *
> + * Copyright 2012 Texas Instruments Inc.
> + *
> + * Licensed under the GPL-2 or later.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqdomain.h>
> +#include <linux/irq.h>
> +#include <linux/mfd/smsc.h>
> +#include <linux/err.h>
> +
> +struct smsc_gpio {
> +	struct device *dev;
> +	struct smsc *smsc;
> +	struct gpio_chip gpio_chip;
> +	struct mutex lock;	/* protect cached dir, dat_out */
> +	/* protect serialized access to the interrupt controller bus */
> +	struct mutex irq_lock;
> +	unsigned gpio_start;
> +	int type;
> +	int flags;
> +	int irq;
> +	int irq_base;
> +	unsigned int gpio_base;
> +	unsigned int dat_out[5];
> +	unsigned int dir[5];
> +	unsigned int int_lvl[5];
> +	unsigned int int_en[5];
> +	unsigned int irq_mask[5];
> +	unsigned int irq_stat[5];
> +};
> +
> +static int smsc_gpio_get_value(struct gpio_chip *chip, unsigned off)
> +{
> +	struct smsc_gpio *sg =3D
> +		container_of(chip, struct smsc_gpio, gpio_chip);
> +	unsigned int get;
> +	return !!(smsc_read(sg->dev,
> +		(SMSC_GPIO_DATA_IN_START + SMSC_BANK(off)) & SMSC_BIT(off),
> +					&get));
> +}
> +
> +static void smsc_gpio_set_value(struct gpio_chip *chip,
> +			unsigned off, int val)
> +{
> +	unsigned bank, bit;
> +	struct smsc_gpio *sg =3D
> +		container_of(chip, struct smsc_gpio, gpio_chip);
> +
> +	bank =3D SMSC_BANK(off);
> +	bit =3D SMSC_BIT(off);
> +
> +	mutex_lock(&sg->lock);
> +	if (val)
> +		sg->dat_out[bank] |=3D bit;
> +	else
> +		sg->dat_out[bank] &=3D ~bit;
> +
> +	smsc_write(sg->dev, SMSC_GPIO_DATA_OUT_START + bank,
> +			   sg->dat_out[bank]);
> +	mutex_unlock(&sg->lock);
> +}
> +
> +static int smsc_gpio_direction_input(struct gpio_chip *chip, unsigned of=
f)
> +{
> +	unsigned int reg;
> +	struct smsc_gpio *sg =3D
> +	    container_of(chip, struct smsc_gpio, gpio_chip);
> +	int reg_dir;
> +
> +	mutex_lock(&sg->lock);
> +	reg_dir =3D SMSC_CFG_START + off;
> +	smsc_read(sg->dev, reg_dir, &reg);
> +	reg |=3D SMSC_GPIO_INPUT_LOW;
> +	mutex_unlock(&sg->lock);
> +
> +	return smsc_write(sg->dev, reg_dir, reg);
> +}
> +
> +static int smsc_gpio_direction_output(struct gpio_chip *chip,
> +					 unsigned off, int val)
> +{
> +	unsigned int reg;
> +	struct smsc_gpio *sg =3D
> +	    container_of(chip, struct smsc_gpio, gpio_chip);
> +	int reg_dir;
> +
> +	mutex_lock(&sg->lock);
> +	reg_dir =3D SMSC_CFG_START + off;
> +	smsc_read(sg->dev, reg_dir, &reg);
> +	reg |=3D SMSC_GPIO_OUTPUT_PP;
> +	mutex_unlock(&sg->lock);
> +
> +	return smsc_write(sg->dev, reg_dir, reg);
> +}
> +
> +static int smsc_gpio_to_irq(struct gpio_chip *chip, unsigned off)
> +{
> +	struct smsc_gpio *sg =3D
> +		container_of(chip, struct smsc_gpio, gpio_chip);
> +	return sg->irq_base + off;
> +}
> +
> +static void smsc_irq_bus_lock(struct irq_data *d)
> +{
> +	struct smsc_gpio *sg =3D irq_data_get_irq_chip_data(d);
> +
> +	mutex_lock(&sg->irq_lock);
> +}
> +
> +static void smsc_irq_bus_sync_unlock(struct irq_data *d)
> +{
> +	struct smsc_gpio *sg =3D irq_data_get_irq_chip_data(d);
> +	int i;
> +
> +	for (i =3D 0; i < SMSC_BANK(SMSC_MAXGPIO); i++)
> +		if (sg->int_en[i] ^ sg->irq_mask[i]) {
> +			sg->int_en[i] =3D sg->irq_mask[i];
> +			smsc_write(sg->dev, SMSC_GPIO_INT_MASK_START + i,
> +					   sg->int_en[i]);
> +		}
> +
> +	mutex_unlock(&sg->irq_lock);
> +}
> +
> +static void smsc_irq_mask(struct irq_data *d)
> +{
> +	struct smsc_gpio *sg =3D irq_data_get_irq_chip_data(d);
> +	unsigned gpio =3D d->irq - sg->irq_base;
> +
> +	sg->irq_mask[SMSC_BANK(gpio)] &=3D ~SMSC_BIT(gpio);
> +}
> +
> +static void smsc_irq_unmask(struct irq_data *d)
> +{
> +	struct smsc_gpio *sg =3D irq_data_get_irq_chip_data(d);
> +	unsigned gpio =3D d->irq - sg->irq_base;
> +
> +	sg->irq_mask[SMSC_BANK(gpio)] |=3D SMSC_BIT(gpio);
> +}
> +
> +static int smsc_irq_set_type(struct irq_data *d, unsigned int type)
> +{
> +	struct smsc_gpio *sg =3D irq_data_get_irq_chip_data(d);
> +	uint16_t gpio =3D d->irq - sg->irq_base;
> +	unsigned bank, bit;
> +
> +	if ((type & IRQ_TYPE_EDGE_BOTH)) {
> +		dev_err(sg->dev, "irq %d: unsupported type %d\n",
> +			d->irq, type);
> +		return -EINVAL;
> +	}
> +
> +	bank =3D SMSC_BANK(gpio);
> +	bit =3D SMSC_BIT(gpio);
> +
> +	if (type & IRQ_TYPE_LEVEL_HIGH)
> +		sg->int_lvl[bank] |=3D bit;
> +	else if (type & IRQ_TYPE_LEVEL_LOW)
> +		sg->int_lvl[bank] &=3D ~bit;
> +	else
> +		return -EINVAL;

this looks wrong. You could have a user who wants to trigger on both
HIGH and LOW levels, no ?

> +	smsc_gpio_direction_input(&sg->gpio_chip, gpio);
> +	smsc_write(sg->dev, SMSC_CFG_START + gpio,
> +			sg->int_lvl[bank]);
> +
> +	return 0;
> +}
> +
> +static struct irq_chip smsc_irq_chip =3D {
> +	.name			=3D "smsc",
> +	.irq_mask		=3D smsc_irq_mask,
> +	.irq_unmask		=3D smsc_irq_unmask,
> +	.irq_bus_lock		=3D smsc_irq_bus_lock,
> +	.irq_bus_sync_unlock	=3D smsc_irq_bus_sync_unlock,
> +	.irq_set_type		=3D smsc_irq_set_type,
> +};
> +
> +static int smsc_gpio_read_intstat(struct smsc_gpio *sg,
> +				unsigned int *buf, int i)
> +{
> +	int ret =3D smsc_read(sg->dev,
> +			SMSC_GPIO_INT_STAT_START + i, buf);
> +
> +	if (ret < 0)
> +		dev_err(sg->dev, "Read INT_STAT Error\n");
> +
> +	return ret;
> +}
> +
> +static irqreturn_t smsc_irq_handler(int irq, void *devid)
> +{
> +	struct smsc_gpio *sg =3D devid;
> +	unsigned int status, bank, pending;
> +	int ret;
> +	smsc_read(sg->dev, GRP_INT_STAT, &status);
> +
> +	if (!(status & SMSC_GPI_INT))
> +		goto out;
> +
> +	for (bank =3D 0; bank <=3D SMSC_BANK(SMSC_MAXGPIO);
> +		bank++) {
> +		pending =3D sg->irq_stat[bank] & sg->irq_mask[bank];
> +		ret =3D smsc_gpio_read_intstat(sg,
> +				&sg->irq_stat[bank], bank);
> +		if (ret < 0)
> +			memset(&sg->irq_stat[bank], 0,
> +				ARRAY_SIZE(sg->irq_stat));
> +
> +		while (pending) {
> +			unsigned long   bit =3D __ffs(pending);
> +			unsigned int    irq;
> +
> +			pending &=3D ~BIT(bit);
> +			irq =3D bit + sg->irq_base;
> +			handle_nested_irq(irq);
> +		}
> +	}
> +
> +out:
> +	smsc_write(sg->dev, GRP_INT_STAT, status); /* Status is W1C */
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int smsc_irq_setup(struct smsc_gpio *sg)
> +{
> +	unsigned gpio;
> +	int ret;
> +
> +	mutex_init(&sg->irq_lock);
> +
> +	for (gpio =3D 0; gpio < sg->gpio_chip.ngpio; gpio++) {
> +		int irq =3D gpio + sg->irq_base;
> +		irq_set_chip_data(irq, sg);
> +		irq_set_chip_and_handler(irq, &smsc_irq_chip,
> +				handle_level_irq);
> +		irq_set_nested_thread(irq, 1);
> +#ifdef CONFIG_ARM
> +		set_irq_flags(irq, IRQF_VALID);
> +#else
> +		irq_set_noprobe(irq);
> +#endif
> +	}
> +
> +	ret =3D request_threaded_irq(sg->irq, NULL,
> +			smsc_irq_handler, sg->flags,
> +			"smsc_gpio", sg);

would be nice to stick to devm_request_threaded_irq() like on the other
patch.

> +	if (ret) {
> +		dev_err(sg->dev, "failed to request irq %d\n",
> +			sg->irq);
> +	}
> +
> +	sg->gpio_chip.to_irq =3D smsc_gpio_to_irq;
> +
> +	return 0;
> +}
> +
> +static int __devinit smsc_gpio_probe(struct platform_device *pdev)
> +{
> +	struct smsc_gpio *sg;
> +	struct gpio_chip *gc;
> +	struct smsc *smsc =3D dev_get_drvdata(pdev->dev.parent);
> +	int ret, i, temp;
> +	struct device *dev =3D &pdev->dev;
> +	struct device_node *np =3D dev->of_node;
> +	int irq_base;
> +
> +	sg =3D devm_kzalloc(dev, sizeof(*sg), GFP_KERNEL);
> +	if (sg =3D=3D NULL) {
> +		dev_err(&pdev->dev, "failed to alloc memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	sg->irq =3D platform_get_irq(pdev, 0);
> +	if (np) {
> +		of_property_read_u32(np, "gpio,base", &temp);
> +		of_property_read_u32(np, "flags", &sg->flags);
> +	}
> +
> +	gc =3D &sg->gpio_chip;
> +	gc->direction_input =3D smsc_gpio_direction_input;
> +	gc->direction_output =3D smsc_gpio_direction_output;
> +	gc->get =3D smsc_gpio_get_value;
> +	gc->set =3D smsc_gpio_set_value;
> +	gc->can_sleep =3D 1;
> +
> +	gc->base =3D temp;
> +	gc->ngpio =3D SMSC_MAXGPIO;
> +	gc->owner =3D THIS_MODULE;
> +
> +	sg->smsc =3D smsc;
> +	sg->dev =3D dev;
> +	mutex_init(&sg->lock);
> +
> +	for (i =3D 0; i <=3D SMSC_BANK(SMSC_MAXGPIO); i++)
> +		smsc_read(sg->dev, SMSC_GPIO_DATA_OUT_START + i,
> +					&sg->dat_out[i]);
> +
> +	for (i =3D 0; i < SMSC_MAXGPIO; i++)
> +		smsc_read(sg->dev, SMSC_CFG_START + i, &sg->dir[i]);
> +
> +	irq_base =3D irq_alloc_descs(-1, 0, sg->gpio_chip.ngpio, 0);
> +	if (IS_ERR_VALUE(irq_base)) {
> +		dev_err(sg->dev, "Fail to allocate IRQ descs\n");
> +		return irq_base;
> +	}
> +	sg->irq_base =3D irq_base;
> +
> +	irq_domain_add_legacy(pdev->dev.of_node, sg->gpio_chip.ngpio,
> +		sg->irq_base, 0, &irq_domain_simple_ops, NULL);
> +
> +	ret =3D smsc_irq_setup(sg);
> +	if (ret)
> +		goto err;
> +
> +	ret =3D gpiochip_add(&sg->gpio_chip);
> +	if (ret)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	kfree(sg);

using devm_kzalloc(), not needed to free.

> +
> +	return ret;
> +}
> +
> +static int __devexit smsc_gpio_remove(struct platform_device *pdev)
> +{
> +	struct smsc_gpio *sg =3D dev_get_drvdata(&pdev->dev);
> +	int ret;
> +
> +	ret =3D gpiochip_remove(&sg->gpio_chip);
> +	if (ret) {
> +		dev_err(&pdev->dev, "gpiochip_remove failed %d\n", ret);
> +		return ret;
> +	}

this will leak the irq (please move to devm_request_threaded_irq).

It's also leaking irq_descs and irq_domain, you need to free those
resources by calling irq_domain_remove and irq_free_descs.

--=20
balbi

--/Y6L//1es8ezVqBy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2itAAoJEIaOsuA1yqRES44P/j2zYCjoPJ0a9hAdtDPcwImR
DdS+Z/ttn9/+Y/Bcmmok6xG2v9/9g5P9PoVevDFJOGI7zPxAuShNSmFXvISjBtiD
2J83wF88OrswBmGJaJ21EjIIo+6jwPqNJDkOKTOSaUN6RZCrBFrM3ku+NWbE8VVF
EJEF6rAOKlA17UL76X84nYL6gYW/Gz66ugVAGQEnHs/Dkr3xZ8WOTPtuEFCiVDtg
r5CC3ZTN/UE78ef0ydamHOI3qxIesOSj1f0hc+6VS1dbrQ0m+5Oo71u0gCTSJudg
yC7pd2XLHLiU14gYnOWkRvMu3sZ4bSi1L0cme2DPXn62XprrOJXXwRcfuCf8kDHE
GR3vMUxfbGVptdA5yO9Qjthi8pQq6mUpSehBiT8+nMbjpA0VrSjgzQknLoEH8ea6
ciLbhPzZURX+6S33LgYObvgY9ft85ZZnj7dOGDgX+WCU/SElNhvGmRXSSp7J49US
2o9XzM255pIupLmLnZ947xnv7CpG8vyzmiSC+fH1KpewwJRHH4C8TrF7tzAt0BQv
hjHpWa34iBb8Fx/935BWV0tftJhnxcEtjAztZjj/mtZ/z4VWcVXPKkn6F+wnEvm6
Yw1Aow3Ith4D2SLLdZYbiqs0qyc4sNiI7XeSEv6cH0tDndgLIlG89v6fWrojQVOV
QYr9+uV7jp77Dxg/9GSB
=VI2+
-----END PGP SIGNATURE-----

--/Y6L//1es8ezVqBy--
