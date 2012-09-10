Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2IJSjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:39:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62881 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab2IJSjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:39:37 -0400
Date: Mon, 10 Sep 2012 20:40:50 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v3] can: rename LED trigger name on netdev renames
Message-ID: <20120910184049.GD2006@gmail.com>
References: <20120907071934.GB37685@macbook.local>
 <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910142827.GB11000@vandijck-laurijssen.be>
 <504E30AE.50201@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504E30AE.50201@hartkopp.net>
X-Operating-System: Linux balto-eee 3.6.0-rc3-balto-eee-00468-g15b91d3
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 08:25:50PM +0200, Oliver Hartkopp wrote:
> On 10.09.2012 16:28, Kurt Van Dijck wrote:
> > Fabio,
> > 
> > I followed all your contribution to this patch.

Thanks!

> > diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> > index 6c1e704..55ad320 100644
> > --- a/drivers/net/can/dev.c
> > +++ b/drivers/net/can/dev.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/can.h>
> >  #include <linux/can/dev.h>
> >  #include <linux/can/netlink.h>
> > +#include <linux/can/led.h>
> >  #include <net/rtnetlink.h>
> >  
> >  #define MOD_DESC "CAN device driver interface"
> > @@ -811,6 +812,10 @@ static __init int can_dev_init(void)
> >  {
> >  	int err;
> >  
> > +	can_led_notifier_init();
> > +
> > +	can_led_notifier_init();
> > +
> 
> 
> two times?
> 
> >  	err = rtnl_link_register(&can_link_ops);
> >  	if (!err)
> >  		printk(KERN_INFO MOD_DESC "\n");
> > @@ -822,6 +827,8 @@ module_init(can_dev_init);
> >  static __exit void can_dev_exit(void)
> >  {
> >  	rtnl_link_unregister(&can_link_ops);
> > +
> > +	can_led_notifier_exit();
> >  }
> >  module_exit(can_dev_exit);
> >  
> > diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
> > index eaa14ac..1663b28 100644
> > --- a/drivers/net/can/led.c
> > +++ b/drivers/net/can/led.c
> > @@ -1,5 +1,6 @@
> >  /*
> >   * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
> > + * Copyright 2012, Kurt Van Dijck <kurt.van.dijck@eia.be>
> >   *
> >   * This program is free software; you can redistribute it and/or modify
> >   * it under the terms of the GNU General Public License version 2 as
> > @@ -87,3 +88,39 @@ void devm_can_led_init(struct net_device *netdev)
> >  	devres_add(&netdev->dev, res);
> >  }
> >  EXPORT_SYMBOL_GPL(devm_can_led_init);
> > +
> > +/*
> > + * NETDEV rename notifier to rename the associated led triggers too
> > + */
> > +static int can_led_notifier(struct notifier_block *nb, unsigned long msg,
> > +			void *data)
> > +{
> > +	struct net_device *netdev = data;
> > +	struct can_priv *priv = safe_candev_priv(netdev);
> > +	char name[CAN_LED_NAME_SZ];
> > +
> 
> 
> What about
> 
> if (!priv)
> 	return NOTIFY_DONE;
> 
> :-)
> 
> You created that nice function but you are accessing priv->tx_led_trig below
> without checking the output of save_candev_priv() ...

Also, I noticed you removed the namespace check... wasn't it needed?
(just asking, I have no idea).

> > +	if (msg == NETDEV_CHANGENAME) {
> > +		snprintf(name, sizeof(name), "%s-tx", netdev->name);
> > +		led_trigger_rename_static(name, priv->tx_led_trig);
> > +        

whitespaces here? (checkpatch)

Fabio

> > +		snprintf(name, sizeof(name), "%s-rx", netdev->name);
> > +		led_trigger_rename_static(name, priv->rx_led_trig);
> > +	}
> > +
> > +	return NOTIFY_DONE;
> > +}
> > +
> > +/* notifier block for netdevice event */
> > +static struct notifier_block can_netdev_notifier __read_mostly = {
> > +	.notifier_call = can_led_notifier,
> > +};
> > +
> > +int __init can_led_notifier_init(void)
> > +{
> > +	return register_netdevice_notifier(&can_netdev_notifier);
> > +}
> > +
> > +void __exit can_led_notifier_exit(void)
> > +{
> > +	unregister_netdevice_notifier(&can_netdev_notifier);
> > +}
> > diff --git a/include/linux/can/led.h b/include/linux/can/led.h
> > index 12d5549..9c1167b 100644
> > --- a/include/linux/can/led.h
> > +++ b/include/linux/can/led.h
> > @@ -26,6 +26,8 @@ enum can_led_event {
> >  
> >  void can_led_event(struct net_device *netdev, enum can_led_event event);
> >  void devm_can_led_init(struct net_device *netdev);
> > +int __init can_led_notifier_init(void);
> > +void __exit can_led_notifier_exit(void);
> >  
> >  #else
> >  
> > @@ -36,6 +38,13 @@ static inline void can_led_event(struct net_device *netdev,
> >  static inline void devm_can_led_init(struct net_device *netdev)
> >  {
> >  }
> > +static inline int can_led_notifier_init(void)
> > +{
> > +	return 0;
> > +}
> > +static inline void can_led_notifier_exit(void)
> > +{
> > +}
> >  
> >  #endif

-- 
Fabio Baltieri
