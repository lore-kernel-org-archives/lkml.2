Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2G3VSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 17:18:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41290 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2G3VSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 17:18:03 -0400
Message-ID: <5016FA01.5000109@pengutronix.de>
Date: Mon, 30 Jul 2012 23:17:53 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v3 1/2] can: add tx/rx LED trigger support
References: <1343676041-29572-1-git-send-email-fabio.baltieri@gmail.com>
In-Reply-To: <1343676041-29572-1-git-send-email-fabio.baltieri@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9A3F57BDC9B48FE14A6A0DAA"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9A3F57BDC9B48FE14A6A0DAA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/30/2012 09:20 PM, Fabio Baltieri wrote:
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
> Supported drivers should call can_led_init(), can_led_exit() and
> can_led_event() as needed.
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
> Hi all!
>=20
> This is the v3 of my CAN LED trigger patch.  It's a major refactoring o=
f the v2
> that was discussed about three months ago concluding with the idea that=

> implementing the oneshot triggering code in the LED framework would be =
a better
> solution.
>=20
> This is the old thread for reference:
> http://marc.info/?l=3Dlinux-can&m=3D133521499002898&w=3D2
>=20
> So, generic oneshot trigger code is now merged in mainline (see 5bb629c=
), and
> these are the changes in the v3:
>=20
> - use the new led_trigger_blink_oneshot() function for LED triggering
> - use kasprintf() and led_trigger_{un}register_simple for LED allocatio=
n
> - add some usage note in the comments
>=20
> The resulting code is quite simple now and - I think - a bit less intru=
sive.
> Still, I hope on some feedback from the community as I don't have that =
much
> hardware to test it - this version has been tested mainly on an x86 wit=
h a
> custom usb-can interface.
>=20
> In 2/2 there is a sample implementation for the flexcan driver, which i=
s
> basically unchanged from the old version.
>=20
> Any comments?
> Fabio

Looks quite clean now. Can you provide a devm implementation, too?

Marc
>=20
>  drivers/net/can/Kconfig  | 12 ++++++
>  drivers/net/can/Makefile |  2 +
>  drivers/net/can/led.c    | 99 ++++++++++++++++++++++++++++++++++++++++=
++++++++
>  include/linux/can/dev.h  |  8 ++++
>  include/linux/can/led.h  | 38 +++++++++++++++++++
>  5 files changed, 159 insertions(+)
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
> index 0000000..68c4f30
> --- /dev/null
> +++ b/drivers/net/can/led.c
> @@ -0,0 +1,99 @@
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
> +/*
> + * Register CAN LED triggers for a CAN device
> + *
> + * This is normally called from a driver's probe function
> + */
> +void can_led_init(struct net_device *netdev)
> +{
> +	struct can_priv *priv =3D netdev_priv(netdev);
> +
> +	priv->tx_led_trig_name =3D kasprintf(GFP_KERNEL, "%s-tx", netdev->nam=
e);
> +	if (!priv->tx_led_trig_name)
> +		goto tx_led_failed;
> +
> +	priv->rx_led_trig_name =3D kasprintf(GFP_KERNEL, "%s-rx", netdev->nam=
e);
> +	if (!priv->rx_led_trig_name)
> +		goto rx_led_failed;
> +
> +	led_trigger_register_simple(priv->tx_led_trig_name,
> +				    &priv->tx_led_trig);
> +	led_trigger_register_simple(priv->rx_led_trig_name,
> +				    &priv->rx_led_trig);
> +
> +	return;
> +
> +rx_led_failed:
> +	kfree(priv->tx_led_trig_name);
> +	priv->tx_led_trig_name =3D NULL;
> +tx_led_failed:
> +	return;
> +}
> +EXPORT_SYMBOL_GPL(can_led_init);

Can you provide a devm implementation for can_led?

> +
> +/*
> + * Unregister CAN LED triggers for a CAN device
> + *
> + * This is normally called from a driver's remove function
> + */
> +void can_led_exit(struct net_device *netdev)
> +{
> +	struct can_priv *priv =3D netdev_priv(netdev);
> +
> +	led_trigger_unregister_simple(priv->tx_led_trig);
> +	led_trigger_unregister_simple(priv->rx_led_trig);
> +
> +	kfree(priv->tx_led_trig_name);
> +	kfree(priv->rx_led_trig_name);
> +}
> +EXPORT_SYMBOL_GPL(can_led_exit);
> diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
> index 2b2fc34..167b04a 100644
> --- a/include/linux/can/dev.h
> +++ b/include/linux/can/dev.h
> @@ -16,6 +16,7 @@
>  #include <linux/can.h>
>  #include <linux/can/netlink.h>
>  #include <linux/can/error.h>
> +#include <linux/can/led.h>
> =20
>  /*
>   * CAN mode
> @@ -52,6 +53,13 @@ struct can_priv {
> =20
>  	unsigned int echo_skb_max;
>  	struct sk_buff **echo_skb;
> +
> +#ifdef CONFIG_CAN_LEDS
> +	struct led_trigger *tx_led_trig;
> +	char *tx_led_trig_name;
> +	struct led_trigger *rx_led_trig;
> +	char *rx_led_trig_name;
> +#endif
>  };
> =20
>  /*
> diff --git a/include/linux/can/led.h b/include/linux/can/led.h
> new file mode 100644
> index 0000000..274c7fd
> --- /dev/null
> +++ b/include/linux/can/led.h
> @@ -0,0 +1,38 @@
> +/*
> + * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef CAN_LED_H
> +#define CAN_LED_H
> +
> +#include <linux/leds.h>
> +
> +enum can_led_event {
> +	CAN_LED_EVENT_OPEN,
> +	CAN_LED_EVENT_STOP,
> +	CAN_LED_EVENT_TX,
> +	CAN_LED_EVENT_RX,
> +};
> +
> +#ifdef CONFIG_CAN_LEDS
> +void can_led_event(struct net_device *netdev, enum can_led_event event=
);
> +void can_led_init(struct net_device *netdev);
> +void can_led_exit(struct net_device *netdev);
> +#else
> +static inline void can_led_event(struct net_device *netdev,
> +				 enum can_led_event event)
> +{
> +}
> +static inline void can_led_init(struct net_device *netdev)
> +{
> +}
> +static inline void can_led_exit(struct net_device *netdev)
> +{
> +}
> +#endif
> +
> +#endif
>=20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig9A3F57BDC9B48FE14A6A0DAA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAW+gUACgkQjTAFq1RaXHNmXQCZAdedgcxlMpYsJ1W2eMphS1xL
WfMAnArfKsLLTSZsqjqckaFSPM2t+qJp
=bmS7
-----END PGP SIGNATURE-----

--------------enig9A3F57BDC9B48FE14A6A0DAA--
