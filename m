Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2HAJhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:37:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48048 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab2HAJhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:37:03 -0400
Message-ID: <5018F8B3.6080404@pengutronix.de>
Date: Wed, 01 Aug 2012 11:36:51 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v4] can: add tx/rx LED trigger support
References: <5017C8E4.4020003@pengutronix.de> <1343772338-1526-1-git-send-email-fabio.baltieri@gmail.com>
In-Reply-To: <1343772338-1526-1-git-send-email-fabio.baltieri@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4A0B50B27E71E08B0D7459C5"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4A0B50B27E71E08B0D7459C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/01/2012 12:05 AM, Fabio Baltieri wrote:
> This patch implements the functions to add two LED triggers, named
> <ifname>-tx and <ifname>-rx, to a canbus device driver.
>=20
> Triggers are called from specific handlers by each CAN device driver an=
d
> can be disabled altogether with a Kconfig option.
>=20
> The implementation keeps the LED on when the interface is UP and blinks=

> the LED on network activity at a configurable rate.
>=20
> This only supports can-dev based drivers, as it uses some support field=

> in the can_priv structure.
>=20
> Supported drivers should call can_led_init() and can_led_event() as
> needed.
>=20
> Cleanup is handled automatically by devres, so no *_exit function is
> needed.
>=20
> Supported events are:
> - CAN_LED_EVENT_OPEN: turn on tx/rx LEDs
> - CAN_LED_EVENT_STOP: turn off tx/rx LEDs
> - CAN_LED_EVENT_TX: trigger tx LED blink
> - CAN_LED_EVENT_RX: trigger tx LED blink
>=20
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> ---
>=20
> Hi!
>=20
> So, here is the v4.
>=20
> Changes against v3:
> - add a netdev_err message in kasprintf error path
> - implement a devres_alloc release function to de-allocate strings and =
trigger
> - can_led_exit is now unneeded and gone
>=20
> Is that what you had in mind Marc?

Yes, that's it. Can you add a devm_ prefix to can_led_init() please.

> I like the devres implementation, as callers don't have to care about e=
xit
> function anymore... still it looks like a bit of an hack to me.

No :)

> Also, I made an initial version with the four pointers in a separate ca=
n_led
> struct to be allocated as a payload of devres_alloc - but I think this =
one
> looks cleaner and is more cache-friendly.

If you allocate the 4 pointers in a separate struct you only save 3
points, as you need the pointer to the struct anyways.

> What you think about this?

Looks good. See comment inline,

Marc

>  drivers/net/can/Kconfig  |  12 ++++++
>  drivers/net/can/Makefile |   2 +
>  drivers/net/can/led.c    | 102 +++++++++++++++++++++++++++++++++++++++=
++++++++
>  include/linux/can/dev.h  |   8 ++++
>  include/linux/can/led.h  |  34 ++++++++++++++++
>  5 files changed, 158 insertions(+)
>  create mode 100644 drivers/net/can/led.c
>  create mode 100644 include/linux/can/led.h
>=20
> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> index bb709fd..19dec19 100644
> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -54,6 +54,18 @@ config CAN_CALC_BITTIMING
>  	  arguments "tq", "prop_seg", "phase_seg1", "phase_seg2" and "sjw".
>  	  If unsure, say Y.
> =20
> +config CAN_LEDS
> +	bool "Enable LED triggers for Netlink based drivers"
> +	depends on CAN_DEV
> +	depends on LEDS_CLASS
> +	select LEDS_TRIGGERS
> +	---help---
> +	  This option adds two LED triggers for packet receive and transmit
> +	  events on each supported CAN device.
> +
> +	  Say Y here if you are working on a system with led-class supported
> +	  LEDs and you want to use them as canbus activity indicators.
> +
>  config CAN_AT91
>  	tristate "Atmel AT91 onchip CAN controller"
>  	depends on CAN_DEV && (ARCH_AT91SAM9263 || ARCH_AT91SAM9X5)
> diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
> index 938be37..24ee98b 100644
> --- a/drivers/net/can/Makefile
> +++ b/drivers/net/can/Makefile
> @@ -8,6 +8,8 @@ obj-$(CONFIG_CAN_SLCAN)		+=3D slcan.o
>  obj-$(CONFIG_CAN_DEV)		+=3D can-dev.o
>  can-dev-y			:=3D dev.o
> =20
> +can-dev-$(CONFIG_CAN_LEDS)	+=3D led.o
> +
>  obj-y				+=3D usb/
>  obj-y				+=3D softing/
> =20
> diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
> new file mode 100644
> index 0000000..4fa8a47
> --- /dev/null
> +++ b/drivers/net/can/led.c
> @@ -0,0 +1,102 @@
> +/*
> + * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/netdevice.h>
> +#include <linux/can/dev.h>
> +
> +#include <linux/can/led.h>
> +
> +static unsigned long led_delay =3D 50;
> +module_param(led_delay, ulong, 0644);
> +MODULE_PARM_DESC(led_delay,
> +		"blink delay time for activity leds (msecs, default: 50).");
> +
> +/*
> + * Trigger a LED event in response to a CAN device event
> + */
> +void can_led_event(struct net_device *netdev, enum can_led_event event=
)
> +{
> +	struct can_priv *priv =3D netdev_priv(netdev);
> +
> +	switch (event) {
> +	case CAN_LED_EVENT_OPEN:
> +		led_trigger_event(priv->tx_led_trig, LED_FULL);
> +		led_trigger_event(priv->rx_led_trig, LED_FULL);
> +		break;
> +	case CAN_LED_EVENT_STOP:
> +		led_trigger_event(priv->tx_led_trig, LED_OFF);
> +		led_trigger_event(priv->rx_led_trig, LED_OFF);
> +		break;
> +	case CAN_LED_EVENT_TX:
> +		if (led_delay)
> +			led_trigger_blink_oneshot(priv->tx_led_trig,
> +						  &led_delay, &led_delay, 1);
> +		break;
> +	case CAN_LED_EVENT_RX:
> +		if (led_delay)
> +			led_trigger_blink_oneshot(priv->rx_led_trig,
> +						  &led_delay, &led_delay, 1);
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(can_led_event);
> +
> +static void can_led_release(struct device *gendev, void *res)
> +{
> +	struct can_priv *priv =3D netdev_priv(to_net_dev(gendev));
> +
> +	led_trigger_unregister_simple(priv->tx_led_trig);
> +	led_trigger_unregister_simple(priv->rx_led_trig);
> +
> +	kfree(priv->tx_led_trig_name);
> +	kfree(priv->rx_led_trig_name);
> +}
> +
> +/*
> + * Register CAN LED triggers for a CAN device
> + *
> + * This is normally called from a driver's probe function
> + */
> +void can_led_init(struct net_device *netdev)
> +{
> +	struct can_priv *priv =3D netdev_priv(netdev);
> +	void *res;
> +
> +	res =3D devres_alloc(can_led_release, 0, GFP_KERNEL);
                                            ^
I'm not really sure if this is working. For example, pinctrl [1]
allocates a double pointer here. The res pointer here and in
can_led_release simply points to invalid memory. But as long as you
don't dereference it, it should work.

[1] http://lxr.free-electrons.com/source/drivers/pinctrl/core.c#L862

> +	if (!res)
> +		goto err_out;
> +
> +	priv->tx_led_trig_name =3D kasprintf(GFP_KERNEL, "%s-tx", netdev->nam=
e);
> +	if (!priv->tx_led_trig_name)
> +		goto err_out;
> +
> +	priv->rx_led_trig_name =3D kasprintf(GFP_KERNEL, "%s-rx", netdev->nam=
e);
> +	if (!priv->rx_led_trig_name)
> +		goto err_out_rx;
> +
> +	led_trigger_register_simple(priv->tx_led_trig_name,
> +				    &priv->tx_led_trig);
> +	led_trigger_register_simple(priv->rx_led_trig_name,
> +				    &priv->rx_led_trig);
> +
> +	devres_add(&netdev->dev, res);
> +
> +	return;
> +
> +err_out_rx:
> +	kfree(priv->tx_led_trig_name);
> +	priv->tx_led_trig_name =3D NULL;
> +err_out:
> +	netdev_err(netdev, "cannot register LED triggers\n");
> +	devres_free(res);
> +}
> +EXPORT_SYMBOL_GPL(can_led_init);

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig4A0B50B27E71E08B0D7459C5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAY+LcACgkQjTAFq1RaXHP3uACfUOv0b96GRmd/8xIw6Xn9K/8j
QykAn00jXoL3LHESWnCOe3/QA8nd8+JM
=tHCu
-----END PGP SIGNATURE-----

--------------enig4A0B50B27E71E08B0D7459C5--
