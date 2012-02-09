Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2BIH6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:58:52 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:58826 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab2BIH6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:58:50 -0500
Date: Thu, 9 Feb 2012 09:58:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/3] pch_udc: Detecting VBUS through GPIO with interrupt
Message-ID: <20120209075842.GK1121@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328253259-9343-1-git-send-email-tomoya.rohm@gmail.com>
 <1328253259-9343-2-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gmhhrsDozM2n+uz5"
Content-Disposition: inline
In-Reply-To: <1328253259-9343-2-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gmhhrsDozM2n+uz5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 03, 2012 at 04:14:18PM +0900, Tomoya MORINAGA wrote:
> Problem:
>  pch_udc continues operation even if VBUS becomes Low.
>  pch_udc performs D+ pulling up before VBUS becomes High.
>  USB device should be controlled according to VBUS state.
>=20
> Root cause:
>  The current pch_udc is not always monitoring VBUS.
>=20
> Solution:
>  The change of VBUS is detected using an interrupt of GPIO.
>  If VBUS became Low, pch_udc handles 'disconnect'.
>  After VBUS became High, a pull improves D+, and pch_udc
>  handles 'connect'.
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> ---
>  drivers/usb/gadget/pch_udc.c |   85 ++++++++++++++++++++++++++++++++++++=
++++-
>  1 files changed, 82 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> index d77211c..942fe92 100644
> --- a/drivers/usb/gadget/pch_udc.c
> +++ b/drivers/usb/gadget/pch_udc.c
> @@ -306,11 +306,15 @@ struct pch_udc_ep {
>   * struct pch_vbus_gpio_data - Structure holding GPIO informaton
>   *					for detecting VBUS
>   * @port:		gpio port number
> + * @intr:		gpio interrupt number
>   * @irq_work_fall	Structure for WorkQueue
> + * @irq_work_rise	Structure for WorkQueue
>   */
>  struct pch_vbus_gpio_data {
>  	int			port;
> +	int			intr;
>  	struct work_struct	irq_work_fall;
> +	struct work_struct	irq_work_rise;
>  };
> =20
>  /**
> @@ -1296,8 +1300,10 @@ static void pch_vbus_gpio_work_fall(struct work_st=
ruct *irq_work)
>  				dev->driver->disconnect(
>  					&dev->gadget);
>  			}
> -			pch_udc_reconnect(dev);
> -			dev_dbg(&dev->pdev->dev, "VBUS fell");
> +			if (dev->vbus_gpio.intr)
> +				pch_udc_init(dev);
> +			else
> +				pch_udc_reconnect(dev);
>  			return;
>  		}
>  		vbus_saved =3D vbus;
> @@ -1306,6 +1312,57 @@ static void pch_vbus_gpio_work_fall(struct work_st=
ruct *irq_work)
>  }
> =20
>  /**
> + * pch_vbus_gpio_work_rise() - This API checks VBUS is High.
> + *                             If VBUS is High, connect is processed
> + * @irq_work:	Structure for WorkQueue
> + *
> + */
> +static void pch_vbus_gpio_work_rise(struct work_struct *irq_work)
> +{
> +	struct pch_vbus_gpio_data *vbus_gpio =3D container_of(irq_work,
> +		struct pch_vbus_gpio_data, irq_work_rise);
> +	struct pch_udc_dev *dev =3D
> +		container_of(vbus_gpio, struct pch_udc_dev, vbus_gpio);
> +	int vbus;
> +
> +	if (!dev->vbus_gpio.port)
> +		return;
> +
> +	mdelay(PCH_VBUS_INTERVAL);
> +	vbus =3D pch_vbus_gpio_get_value(dev);
> +
> +	if (vbus =3D=3D 1) {
> +		dev_dbg(&dev->pdev->dev, "VBUS rose");
> +		pch_udc_reconnect(dev);
> +		return;
> +	}
> +}
> +
> +/**
> + * pch_vbus_gpio_irq() - IRQ handler for GPIO intrerrupt for changing VB=
US
> + * @irq:	Interrupt request number
> + * @dev:	Reference to the device structure
> + *
> + * Return codes:
> + *	0: Success
> + *	-EINVAL: GPIO port is invalid or can't be initialized.
> + */
> +static irqreturn_t pch_vbus_gpio_irq(int irq, void *data)
> +{
> +	struct pch_udc_dev *dev =3D (struct pch_udc_dev *)data;
> +
> +	if (!dev->vbus_gpio.port || !dev->vbus_gpio.intr)
> +		return IRQ_NONE;
> +
> +	if (pch_vbus_gpio_get_value(dev))
> +		schedule_work(&dev->vbus_gpio.irq_work_rise);
> +	else
> +		schedule_work(&dev->vbus_gpio.irq_work_fall);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/**
>   * pch_vbus_gpio_init() - This API initializes GPIO port detecting VBUS.
>   * @dev:	Reference to the driver structure
>   * @vbus_gpio	Number of GPIO port to detect gpio
> @@ -1317,8 +1374,10 @@ static void pch_vbus_gpio_work_fall(struct work_st=
ruct *irq_work)
>  static int pch_vbus_gpio_init(struct pch_udc_dev *dev, int vbus_gpio_por=
t)
>  {
>  	int err;
> +	int irq_num =3D 0;
> =20
>  	dev->vbus_gpio.port =3D 0;
> +	dev->vbus_gpio.intr =3D 0;
> =20
>  	if (vbus_gpio_port <=3D -1)
>  		return -EINVAL;
> @@ -1341,6 +1400,21 @@ static int pch_vbus_gpio_init(struct pch_udc_dev *=
dev, int vbus_gpio_port)
>  	gpio_direction_input(vbus_gpio_port);
>  	INIT_WORK(&dev->vbus_gpio.irq_work_fall, pch_vbus_gpio_work_fall);
> =20
> +	irq_num =3D gpio_to_irq(vbus_gpio_port);
> +	if (irq_num > 0) {
> +		irq_set_irq_type(irq_num, IRQ_TYPE_EDGE_BOTH);
> +		err =3D request_irq(irq_num, pch_vbus_gpio_irq, 0,
> +			"vbus_detect", dev);
> +		if (!err) {
> +			dev->vbus_gpio.intr =3D irq_num;
> +			INIT_WORK(&dev->vbus_gpio.irq_work_rise,
> +				pch_vbus_gpio_work_rise);
> +		} else {
> +			pr_err("%s: can't request irq %d, err: %d\n",
> +				__func__, irq_num, err);
> +		}
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -1350,6 +1424,9 @@ static int pch_vbus_gpio_init(struct pch_udc_dev *d=
ev, int vbus_gpio_port)
>   */
>  static void pch_vbus_gpio_free(struct pch_udc_dev *dev)
>  {
> +	if (dev->vbus_gpio.intr)
> +		free_irq(dev->vbus_gpio.intr, dev);
> +
>  	if (dev->vbus_gpio.port)
>  		gpio_free(dev->vbus_gpio.port);
>  }
> @@ -2677,6 +2754,7 @@ static void pch_udc_dev_isr(struct pch_udc_dev *dev=
, u32 dev_intr)
>  			pch_udc_reconnect(dev);
>  		} else if ((dev->vbus_session =3D=3D 0)
>  			&& (vbus =3D=3D 1))
> +			&&!dev->vbus_gpio.intr)

This causes a compile error which I have fixed this time. Next time I
will silently drop the patch:

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index fb74cc8..a992084 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2753,8 +2753,8 @@ static void pch_udc_dev_isr(struct pch_udc_dev *dev, =
u32 dev_intr)
 			}
 			pch_udc_reconnect(dev);
 		} else if ((dev->vbus_session =3D=3D 0)
-			&& (vbus =3D=3D 1))
-			&&!dev->vbus_gpio.intr)
+			&& (vbus =3D=3D 1)
+			&& !dev->vbus_gpio.intr)
 			schedule_work(&dev->vbus_gpio.irq_work_fall);
=20
 		dev_dbg(&dev->pdev->dev, "USB_SUSPEND\n");

--=20
balbi

--gmhhrsDozM2n+uz5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM3yyAAoJEIaOsuA1yqREDvsP/0++e4HXs27cqZhT4LxJiA0o
R867YJVFYs0SZBOq/Vv6XNae27EUjy10rKevJgNiqZynMvNaUbZKqw4eSvmFb3Tt
/onB/RsZsqkP4iaiSgKqj7dSeUNwp9X89I7lqzqjDQUdcgIe/sTqLq5+Np4q9Hnw
qFw7vf2vZeZJlcYgAJiCEKlSn8ZSlVp/mLiVf3+KugqMqdhN3JOUTdXWVd47k2n3
dLqJzRnyg5zCDZN/WdtAGrH74shef0aU2/nNEzgHYOcSO9OoEYmWfFEOasWqV6CO
/ykXiOkHhn2p+/xHjUcDKm30yvPGy7U6fLNxGtL/ghdG2HAKiabhTaayRxZhRl7l
ufq5I0uPvDmKU9sJNB7lu6p9oR3L5W4BX/RAXWK8GLSwxC/e77YthvhJHLgDM01s
e6XKFE+K+xWYp5lKJ9itMs29YP/4HOKVL2hxzo/IMCq3qB3ZO7PUuB6yhIbcBwk/
ZqjAMu33U5Oa0Lwgo3x5D+yZntCBNIJ4ISv022TgMeTrd5BVsn1XIsyYSZvYg6vH
mOIWUynV7Jlp30mtumme9WdiWHDQbRaTzD6U7Hup2Of++6hx+/S7l7o+mAN4gt7C
LigzF319upAveWhEzwzD7Eq0tcqGdNqZKkBDQapNaCFZ9hvTvNYCmqQy+qFuJtU8
TZniWqCGgH9r0tCb+69a
=Tc6a
-----END PGP SIGNATURE-----

--gmhhrsDozM2n+uz5--
