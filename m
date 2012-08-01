Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2HAK2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:28:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43436 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2HAK2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:28:42 -0400
Date: Wed, 1 Aug 2012 12:30:32 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v4] can: add tx/rx LED trigger support
Message-ID: <20120801103032.GA1385@gmail.com>
References: <5017C8E4.4020003@pengutronix.de>
 <1343772338-1526-1-git-send-email-fabio.baltieri@gmail.com>
 <5018F8B3.6080404@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5018F8B3.6080404@pengutronix.de>
X-Operating-System: Linux balto-eee 3.5.0-balto-eee-08206-g03ac383-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 11:36:51AM +0200, Marc Kleine-Budde wrote:
> On 08/01/2012 12:05 AM, Fabio Baltieri wrote:
> > This patch implements the functions to add two LED triggers, named
> > <ifname>-tx and <ifname>-rx, to a canbus device driver.
> > 
> > Triggers are called from specific handlers by each CAN device driver and
> > can be disabled altogether with a Kconfig option.
> > 
> > The implementation keeps the LED on when the interface is UP and blinks
> > the LED on network activity at a configurable rate.
> > 
> > This only supports can-dev based drivers, as it uses some support field
> > in the can_priv structure.
> > 
> > Supported drivers should call can_led_init() and can_led_event() as
> > needed.
> > 
> > Cleanup is handled automatically by devres, so no *_exit function is
> > needed.
> > 
> > Supported events are:
> > - CAN_LED_EVENT_OPEN: turn on tx/rx LEDs
> > - CAN_LED_EVENT_STOP: turn off tx/rx LEDs
> > - CAN_LED_EVENT_TX: trigger tx LED blink
> > - CAN_LED_EVENT_RX: trigger tx LED blink
> > 
> > Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> > Cc: Wolfgang Grandegger <wg@grandegger.com>
> > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> > ---
> > 
> > Hi!
> > 
> > So, here is the v4.
> > 
> > Changes against v3:
> > - add a netdev_err message in kasprintf error path
> > - implement a devres_alloc release function to de-allocate strings and trigger
> > - can_led_exit is now unneeded and gone
> > 
> > Is that what you had in mind Marc?
> 
> Yes, that's it. Can you add a devm_ prefix to can_led_init() please.

Okay.

> 
> > I like the devres implementation, as callers don't have to care about exit
> > function anymore... still it looks like a bit of an hack to me.
> 
> No :)

Fair enough :)

> > Also, I made an initial version with the four pointers in a separate can_led
> > struct to be allocated as a payload of devres_alloc - but I think this one
> > looks cleaner and is more cache-friendly.
> 
> If you allocate the 4 pointers in a separate struct you only save 3
> points, as you need the pointer to the struct anyways.
> 
> > What you think about this?
> 
> Looks good. See comment inline,
> 
> Marc
> 
> > +/*
> > + * Register CAN LED triggers for a CAN device
> > + *
> > + * This is normally called from a driver's probe function
> > + */
> > +void can_led_init(struct net_device *netdev)
> > +{
> > +	struct can_priv *priv = netdev_priv(netdev);
> > +	void *res;
> > +
> > +	res = devres_alloc(can_led_release, 0, GFP_KERNEL);
>                                             ^
> I'm not really sure if this is working. For example, pinctrl [1]
> allocates a double pointer here. The res pointer here and in
> can_led_release simply points to invalid memory. But as long as you
> don't dereference it, it should work.
> 
> [1] http://lxr.free-electrons.com/source/drivers/pinctrl/core.c#L862

Actually that's also used by libata-core (not in lxr yet) and dma-mapping:

http://lxr.free-electrons.com/source/drivers/base/dma-mapping.c#L193

actually, res should point at the end of some internal devres structure,
and is only used as return value in this case.

Of course, in this case the release function can only use the struct
device pointer.

I've run some fail test and ftraced the whole thing and it seems to work
pretty good!  I'll send a v5 with the rename later.

Thanks,
Fabio
