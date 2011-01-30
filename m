Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1A3SZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 13:25:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38697 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab1A3SZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 13:25:58 -0500
Date: Sun, 30 Jan 2011 19:25:40 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joachim Eastwood <manabian@gmail.com>
Cc: rpurdie@rpsys.net, riku.voipio@iki.fi, linux-kernel@vger.kernel.org,
        joachim.eastwood@jotron.com
Subject: Re: [leds-pca9532] Add gpio capability
Message-ID: <20110130182540.GA12801@pengutronix.de>
References: <AANLkTimHqDGtY3rTzB_xr9f_-pd7Sf084G8vOGghdKhh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <AANLkTimHqDGtY3rTzB_xr9f_-pd7Sf084G8vOGghdKhh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> Since it is a bug to call get/set value on unrequested gpio's the
> check for PCA9532_TYPE_GPIO could be removed from
> pca9532_gpio_get_value/pca9532_gpio_set_value functions. But I have
> kept it for this posting.

If you keep it, you could print a warning maybe. Or just remove the check.

> -------------------------------------------------------------------
>     [leds-pca9532] Add gpio capability
>=20
>     Pins not used for leds can now be used as gpio by setting pin type as
>     PCA9532_TYPE_GPIO and defining a gpio_base in platform data.
>=20
>     Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>

Some Kconfig-magic is missing. Iff that feature is used, then it depends on
GENERIC_GPIO.

>=20
> diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
> index afac338..b036fa5 100644
> --- a/drivers/leds/leds-pca9532.c
> +++ b/drivers/leds/leds-pca9532.c
> @@ -19,7 +19,9 @@
>  #include <linux/mutex.h>
>  #include <linux/workqueue.h>
>  #include <linux/leds-pca9532.h>
> +#include <linux/gpio.h>
>=20
> +#define PCA9532_REG_INPUT(i) ((i)/8)
>  #define PCA9532_REG_PSC(i) (0x2+(i)*2)
>  #define PCA9532_REG_PWM(i) (0x3+(i)*2)
>  #define PCA9532_REG_LS0  0x6
> @@ -34,6 +36,7 @@ struct pca9532_data {
>  	struct mutex update_lock;
>  	struct input_dev *idev;
>  	struct work_struct work;
> +	struct gpio_chip gpio;
>  	u8 pwm[2];
>  	u8 psc[2];
>  };
> @@ -200,16 +203,58 @@ static void pca9532_led_work(struct work_struct *wo=
rk)
>  	pca9532_setled(led);
>  }
>=20
> -static void pca9532_destroy_devices(struct pca9532_data *data, int n_dev=
s)
> +static int pca9532_gpio_request_pin(struct gpio_chip *gc, unsigned off)

Nitpick: maybe 'offset' as variable name? I first thought 'off' was a
description of the state.

>  {
> -	int i =3D n_devs;
> +	struct pca9532_data *data =3D container_of(gc, struct pca9532_data, gpi=
o);
> +	struct pca9532_led *led =3D &data->leds[off];
> +
> +	if (led->type =3D=3D PCA9532_TYPE_GPIO)
> +		return 0;
> +
> +	return -EINVAL;

-EBUSY? The value is valid, just the pin is used already.

> +}
> +
> +static void pca9532_gpio_set_value(struct gpio_chip *gc, unsigned off, i=
nt val)
> +{
> +	struct pca9532_data *data =3D container_of(gc, struct pca9532_data, gpi=
o);
> +	struct pca9532_led *led =3D &data->leds[off];
> +
> +	if (led->type =3D=3D PCA9532_TYPE_GPIO) {
> +		if (val)
> +			led->state =3D PCA9532_ON;
> +		else
> +			led->state =3D PCA9532_OFF;
> +
> +		pca9532_setled(led);
> +	}
> +}
> +
> +static int pca9532_gpio_get_value(struct gpio_chip *gc, unsigned off)
> +{
> +	struct pca9532_data *data =3D container_of(gc, struct pca9532_data, gpi=
o);
> +	struct pca9532_led *led =3D &data->leds[off];
> +	unsigned char reg;
> +
> +	if (led->type =3D=3D PCA9532_TYPE_GPIO) {
> +		reg =3D i2c_smbus_read_byte_data(data->client,
> +						PCA9532_REG_INPUT(off));
> +		return !!(reg & (1<<(off % 8)));

Spaces around operators.

> +	}
> +
> +	return -1;

According to gpio.txt, you should return 0 here (there are no errorcodes).

> +}
> +
> +static int pca9532_destroy_devices(struct pca9532_data *data, int n_devs)
> +{
> +	int err, i =3D n_devs;
>=20
>  	if (!data)
> -		return;
> +		return -EINVAL;
>=20
>  	while (--i >=3D 0) {
>  		switch (data->leds[i].type) {
>  		case PCA9532_TYPE_NONE:
> +		case PCA9532_TYPE_GPIO:
>  			break;
>  		case PCA9532_TYPE_LED:
>  			led_classdev_unregister(&data->leds[i].ldev);
> @@ -224,12 +269,24 @@ static void pca9532_destroy_devices(struct
> pca9532_data *data, int n_devs)
>  			break;
>  		}
>  	}
> +
> +	if (data->gpio.dev) {
> +		err =3D gpiochip_remove(&data->gpio);
> +		if (err) {
> +			dev_err(&data->client->dev, "%s failed, %d\n",
> +						"gpiochip_remove()", err);
> +			return err;
> +		}
> +	}
> +
> +	return 0;
>  }
>=20
>  static int pca9532_configure(struct i2c_client *client,
>  	struct pca9532_data *data, struct pca9532_platform_data *pdata)
>  {
>  	int i, err =3D 0;
> +	int gpios =3D 0;
>=20
>  	for (i =3D 0; i < 2; i++)	{
>  		data->pwm[i] =3D pdata->pwm[i];
> @@ -249,6 +306,9 @@ static int pca9532_configure(struct i2c_client *clien=
t,
>  		switch (led->type) {
>  		case PCA9532_TYPE_NONE:
>  			break;
> +		case PCA9532_TYPE_GPIO:
> +			gpios++;
> +			break;
>  		case PCA9532_TYPE_LED:
>  			led->state =3D pled->state;
>  			led->name =3D pled->name;
> @@ -297,6 +357,30 @@ static int pca9532_configure(struct i2c_client *clie=
nt,
>  			break;
>  		}
>  	}
> +
> +	if (gpios) {
> +		data->gpio.label =3D "gpio-pca9532";
> +		data->gpio.set =3D pca9532_gpio_set_value;
> +		data->gpio.get =3D pca9532_gpio_get_value;
> +		data->gpio.request =3D pca9532_gpio_request_pin;
> +		data->gpio.can_sleep =3D 1;
> +		data->gpio.base =3D pdata->gpio_base;
> +		data->gpio.ngpio =3D 16;
> +		data->gpio.dev =3D &client->dev;
> +		data->gpio.owner =3D THIS_MODULE;

I'd assume that you also need to define a direction_output-function which a=
lways
returns success?

> +
> +		err =3D gpiochip_add(&data->gpio);
> +		if (err) {
> +			/* Use data->gpio.dev as a flag for freeing gpiochip */
> +			data->gpio.dev =3D NULL;
> +			dev_info(&client->dev, "could not add gpiochip\n");

dev_warning?

> +		} else {
> +			dev_info(&client->dev, "gpios %i...%i\n",
> +				data->gpio.base, data->gpio.base +
> +				data->gpio.ngpio - 1);
> +		}
> +	}
> +
>  	return 0;
>=20
>  exit:
> @@ -337,7 +421,12 @@ static int pca9532_probe(struct i2c_client *client,
>  static int pca9532_remove(struct i2c_client *client)
>  {
>  	struct pca9532_data *data =3D i2c_get_clientdata(client);
> -	pca9532_destroy_devices(data, 16);
> +	int err;
> +
> +	err =3D pca9532_destroy_devices(data, 16);
> +	if (err)
> +		return err;
> +
>  	kfree(data);
>  	return 0;
>  }
> diff --git a/include/linux/leds-pca9532.h b/include/linux/leds-pca9532.h
> index f158eb1..b8d6fff 100644
> --- a/include/linux/leds-pca9532.h
> +++ b/include/linux/leds-pca9532.h
> @@ -25,7 +25,7 @@ enum pca9532_state {
>  };
>=20
>  enum pca9532_type { PCA9532_TYPE_NONE, PCA9532_TYPE_LED,
> -	PCA9532_TYPE_N2100_BEEP };
> +	PCA9532_TYPE_N2100_BEEP, PCA9532_TYPE_GPIO };
>=20
>  struct pca9532_led {
>  	u8 id;
> @@ -41,6 +41,7 @@ struct pca9532_platform_data {
>  	struct pca9532_led leds[16];
>  	u8 pwm[2];
>  	u8 psc[2];
> +	int gpio_base;
>  };
>=20
>  #endif /* __LINUX_PCA9532_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1FrSQACgkQD27XaX1/VRuX9gCeKh2ziR3X4HXliqg4wO7+Ridy
Q/4AnjhnVzNKHI6o0n1HEhaxuhWmhzn4
=iqBP
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
