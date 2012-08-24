Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab2HXFKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 01:10:31 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:51471 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987Ab2HXFKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 01:10:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EALILN1Btgn7O/2dsb2JhbABFhgO0ToEIgiABAQQBIwQnCCMFCwsYAgImAgIUDRAIJAgLHQSHXQMGCgemVokuDYlOgSGJBGOFfzJgA5QBgVKBFYl5hQeCZQ
Date: Fri, 24 Aug 2012 07:10:16 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120824051016.GB1718@vandijck-laurijssen.be>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
References: <50191EA5.1040303@pengutronix.de>
 <1343845298-2065-1-git-send-email-fabio.baltieri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343845298-2065-1-git-send-email-fabio.baltieri@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I find the CAN led triggers an interesting thing.

And then, this scenario fell crossed my mind:
Imagine I do:
[insert CAN device: can0]
$ ip link set can0 name helga
[insert another CAN device: again 'can0']

Registering 'can0-tx' led trigger will fail for the second CAN device,
since that led trigger name is already reserved for CAN device 'helga'.

I'm not sure how to fix such.
If 'rx' & 'tx' may be combined, reusing the netdev name may be possible?
Just wild thinking ...

Kind regards,
Kurt

On Wed, Aug 01, 2012 at 08:21:38PM +0200, Fabio Baltieri wrote:
> This patch implements the functions to add two LED triggers, named
> <ifname>-tx and <ifname>-rx, to a canbus device driver.
> 
> Triggers are called from specific handlers by each CAN device driver and
> can be disabled altogether with a Kconfig option.
> 
> The implementation keeps the LED on when the interface is UP and blinks
> the LED on network activity at a configurable rate.
> 
> This only supports can-dev based drivers, as it uses some support field
> in the can_priv structure.
> 
> Supported drivers should call devm_can_led_init() and can_led_event() as
> needed.
> 
> Cleanup is handled automatically by devres, so no *_exit function is
> needed.
> 
> Supported events are:
> - CAN_LED_EVENT_OPEN: turn on tx/rx LEDs
> - CAN_LED_EVENT_STOP: turn off tx/rx LEDs
> - CAN_LED_EVENT_TX: trigger tx LED blink
> - CAN_LED_EVENT_RX: trigger tx LED blink
> 
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> ---
> 
> Hi all,
> 
> so, v6, change trigger names for fixed size allocation capped to (IFNAMSIZ + 4)
> and removed kasprintf as suggested by Oliver (thanks!).
> 
> This also has the side effect of reducing the error path to just one check to
> devres_alloc return value... nice!
> 
> I've put CAN_LED_NAME_SZ definition with the active function declaration,
> but used sizeof(priv->tx_led_trig_name) as snprintf length argument in the
> code, as it looks cleaner to me.
> 
> I'm not reposting the flexcan patch as it's not affected by the change.
> 
> Fabio
> 
>  drivers/net/can/Kconfig  | 12 +++++++
>  drivers/net/can/Makefile |  2 ++
>  drivers/net/can/led.c    | 89 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/can/dev.h  |  8 +++++
>  include/linux/can/led.h  | 42 +++++++++++++++++++++++
>  5 files changed, 153 insertions(+)
>  create mode 100644 drivers/net/can/led.c
>  create mode 100644 include/linux/can/led.h
> 
> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> index bb709fd..19dec19 100644
> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -54,6 +54,18 @@ config CAN_CALC_BITTIMING
>  	  arguments "tq", "prop_seg", "phase_seg1", "phase_seg2" and "sjw".
>  	  If unsure, say Y.
>  
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
> @@ -8,6 +8,8 @@ obj-$(CONFIG_CAN_SLCAN)		+= slcan.o
>  obj-$(CONFIG_CAN_DEV)		+= can-dev.o
>  can-dev-y			:= dev.o
>  
> +can-dev-$(CONFIG_CAN_LEDS)	+= led.o
> +
>  obj-y				+= usb/
>  obj-y				+= softing/
>  
> diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
> new file mode 100644
> index 0000000..eaa14ac
> --- /dev/null
> +++ b/drivers/net/can/led.c
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
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
> +static unsigned long led_delay = 50;
> +module_param(led_delay, ulong, 0644);
> +MODULE_PARM_DESC(led_delay,
> +		"blink delay time for activity leds (msecs, default: 50).");
> +
> +/*
> + * Trigger a LED event in response to a CAN device event
> + */
> +void can_led_event(struct net_device *netdev, enum can_led_event event)
> +{
> +	struct can_priv *priv = netdev_priv(netdev);
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
> +	struct can_priv *priv = netdev_priv(to_net_dev(gendev));
> +
> +	led_trigger_unregister_simple(priv->tx_led_trig);
> +	led_trigger_unregister_simple(priv->rx_led_trig);
> +}
> +
> +/*
> + * Register CAN LED triggers for a CAN device
> + *
> + * This is normally called from a driver's probe function
> + */
> +void devm_can_led_init(struct net_device *netdev)
> +{
> +	struct can_priv *priv = netdev_priv(netdev);
> +	void *res;
> +
> +	res = devres_alloc(can_led_release, 0, GFP_KERNEL);
> +	if (!res) {
> +		netdev_err(netdev, "cannot register LED triggers\n");
> +		return;
> +	}
> +
> +	snprintf(priv->tx_led_trig_name, sizeof(priv->tx_led_trig_name),
> +		 "%s-tx", netdev->name);
> +	snprintf(priv->rx_led_trig_name, sizeof(priv->rx_led_trig_name),
> +		 "%s-rx", netdev->name);
> +
> +	led_trigger_register_simple(priv->tx_led_trig_name,
> +				    &priv->tx_led_trig);
> +	led_trigger_register_simple(priv->rx_led_trig_name,
> +				    &priv->rx_led_trig);
> +
> +	devres_add(&netdev->dev, res);
> +}
> +EXPORT_SYMBOL_GPL(devm_can_led_init);
> diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
> index 2b2fc34..7747d9b 100644
> --- a/include/linux/can/dev.h
> +++ b/include/linux/can/dev.h
> @@ -16,6 +16,7 @@
>  #include <linux/can.h>
>  #include <linux/can/netlink.h>
>  #include <linux/can/error.h>
> +#include <linux/can/led.h>
>  
>  /*
>   * CAN mode
> @@ -52,6 +53,13 @@ struct can_priv {
>  
>  	unsigned int echo_skb_max;
>  	struct sk_buff **echo_skb;
> +
> +#ifdef CONFIG_CAN_LEDS
> +	struct led_trigger *tx_led_trig;
> +	char tx_led_trig_name[CAN_LED_NAME_SZ];
> +	struct led_trigger *rx_led_trig;
> +	char rx_led_trig_name[CAN_LED_NAME_SZ];
> +#endif
>  };
>  
>  /*
> diff --git a/include/linux/can/led.h b/include/linux/can/led.h
> new file mode 100644
> index 0000000..12d5549
> --- /dev/null
> +++ b/include/linux/can/led.h
> @@ -0,0 +1,42 @@
> +/*
> + * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef CAN_LED_H
> +#define CAN_LED_H
> +
> +#include <linux/if.h>
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
> +
> +/* keep space for interface name + "-tx"/"-rx" suffix and null terminator */
> +#define CAN_LED_NAME_SZ (IFNAMSIZ + 4)
> +
> +void can_led_event(struct net_device *netdev, enum can_led_event event);
> +void devm_can_led_init(struct net_device *netdev);
> +
> +#else
> +
> +static inline void can_led_event(struct net_device *netdev,
> +				 enum can_led_event event)
> +{
> +}
> +static inline void devm_can_led_init(struct net_device *netdev)
> +{
> +}
> +
> +#endif
> +
> +#endif
> -- 
> 1.7.11.rc1.9.gf623ca1.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-can" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Kurt Van Dijck
GRAMMER EiA ELECTRONICS
http://www.eia.be
kurt.van.dijck@eia.be
+32-38708534
