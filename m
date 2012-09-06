Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab2IFS6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:58:43 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52479 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab2IFS6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:58:39 -0400
Date: Thu, 6 Sep 2012 20:59:38 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Kurt Van Dijck <kurt.van.dijck@eia.be>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH] can: rename LED trigger name on netdev renames
Message-ID: <20120906185938.GA4043@gmail.com>
References: <20120904071128.GB416@vandijck-laurijssen.be>
 <1346750951-10451-1-git-send-email-kurt.van.dijck@eia.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346750951-10451-1-git-send-email-kurt.van.dijck@eia.be>
X-Operating-System: Linux balto-eee 3.6.0-rc4-balto-eee-00111-g8edc602-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kurt,

thanks for the patch!

On Tue, Sep 04, 2012 at 11:29:11AM +0200, Kurt Van Dijck wrote:
> The LED trigger name for CAN devices is based on the initial
> CAN device name, but does never change. The LED trigger name
> is not guaranteed to be unique in case of hotplugging CAN devices.
> 
> This patch tries to address this problem by modifying the
> LED trigger name according to the CAN device name when
> the latter changes.

That's an ideal solution, and I like the notifier implementation, but I
see a couple of problems with it.

> This patch is meant as illustration only.
> In case of VCAN device rename, a segmentation fault will occur.
> 
> Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
> ---
>  drivers/net/can/led.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
> index eaa14ac..f62f908 100644
> --- a/drivers/net/can/led.c
> +++ b/drivers/net/can/led.c
> @@ -12,6 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/netdevice.h>
>  #include <linux/can/dev.h>
> +#include <linux/if_arp.h>
>  
>  #include <linux/can/led.h>
>  
> @@ -87,3 +88,59 @@ void devm_can_led_init(struct net_device *netdev)
>  	devres_add(&netdev->dev, res);
>  }
>  EXPORT_SYMBOL_GPL(devm_can_led_init);
> +
> +/*
> + * NETDEV rename notifier to rename the associated led triggers too
> + */
> +static int can_led_notifier(struct notifier_block *nb, unsigned long msg,
> +			void *data)
> +{
> +	struct net_device *netdev = (struct net_device *)data;
> +	struct can_priv *priv = netdev_priv(netdev);
> +	int busy = 0;
> +
> +	if (!net_eq(dev_net(netdev), &init_net))
> +		return NOTIFY_DONE;
> +
> +	if (netdev->type != ARPHRD_CAN)
> +		return NOTIFY_DONE;
> +
> +	if (msg != NETDEV_CHANGENAME)
> +		return NOTIFY_DONE;

That's the main problem, which I also got stuck into when I did my first
can-led implementation.  As LED structures are in netdev's private data,
you can only use it if your driver is based on the can-dev API, and
there are no way to be sure of that if you get outside driver's code
itself.

This would give problems with vcan, slcan, and probabily other
non-mainlined drivers.

Is there any way to register a notifier which fires only for devices
registered with devm_can_led_init?

> +	read_lock(&priv->tx_led_trig->leddev_list_lock);
> +	if (!list_empty(&priv->tx_led_trig->led_cdevs))
> +		++busy;
> +	read_unlock(&priv->tx_led_trig->leddev_list_lock);
> +	read_lock(&priv->rx_led_trig->leddev_list_lock);
> +	if (!list_empty(&priv->rx_led_trig->led_cdevs))
> +		++busy;
> +	read_unlock(&priv->rx_led_trig->leddev_list_lock);
> +
> +	if (busy)
> +		return notifier_from_errno(-EBUSY);

As we were discussing in the other thread, I don't think that this is
necessary.

> +	snprintf(priv->tx_led_trig_name, sizeof(priv->tx_led_trig_name),
> +		 "%s-tx", netdev->name);
> +	snprintf(priv->rx_led_trig_name, sizeof(priv->rx_led_trig_name),
> +		 "%s-rx", netdev->name);

I'm afraid that this is going to race against other code using trigger
name, so that's probabily needs a down_write(&led_cdev->trigger_lock),
which is a bit of a problem beacause that's static in led-triggers.c.

> +	return NOTIFY_DONE;
> +}
> +
> +/* notifier block for netdevice event */
> +static struct notifier_block can_netdev_notifier __read_mostly = {
> +	.notifier_call = can_led_notifier,
> +};
> +
> +static __init int can_led_init(void)
> +{
> +	return register_netdevice_notifier(&can_netdev_notifier);
> +}
> +
> +static __exit void can_led_exit(void)
> +{
> +	unregister_netdevice_notifier(&can_netdev_notifier);
> +}
> +
> +module_init(can_led_init);
> +module_exit(can_led_exit);

This breaks the driver when built as a module, as led.c is actually
linked together with can-dev.  The solution is to get it on a module by
its own or just to call init/exit functions from can_dev.

Besides those points I like the idea of renaming the trigger if we can
find a clean way to do that, so I'll try to look at those point further
in the weekend.

Fabio
