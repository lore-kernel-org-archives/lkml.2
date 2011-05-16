Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1EPVvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:51:32 -0400
Received: from trinity.fluff.org ([89.16.178.74]:35085 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab1EPVva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:51:30 -0400
Date: Mon, 16 May 2011 22:51:10 +0100
From: Ben Dooks <ben@trinity.fluff.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: simon@mungewell.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        OliverNeukumoliver@neukum.org
Subject: Re: [PATCH] input: Add Nintendo extension controller driver
Message-ID: <20110516215110.GE16731@trinity.fluff.org>
References: <20110516214608.17011.3075.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516214608.17011.3075.stgit@ponder>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 03:46:08PM -0600, Grant Likely wrote:
> This driver adds support for Nintendo Wiimote extension controllers
> directly attached to an i2c bus, such as when using an adaptor like
> the Wiichuck.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/input/joystick/Kconfig    |   13 +
>  drivers/input/joystick/Makefile   |    1 
>  drivers/input/joystick/wiichuck.c |  441 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 455 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/joystick/wiichuck.c
> 
> diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
> index 56eb471..5b7fba7 100644
> --- a/drivers/input/joystick/Kconfig
> +++ b/drivers/input/joystick/Kconfig
> @@ -193,6 +193,19 @@ config JOYSTICK_TWIDJOY
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called twidjoy.
>  
> +config JOYSTICK_WIICHUCK
> +	tristate "Nintendo Wiimote Extension connector on i2c bus"
> +	depends on I2C
> +	select INPUT_POLLDEV
> +	help
> +	  Say Y here if you have a Nintendo Wiimote extension connector
> +	  attached directly to an i2c bus, like the Sparcfun Wiichuck adapter
> +	  board.  This driver supports both the Nunchuck and the Classic
> +	  Controller extensions.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  modules will be called wiichuck.
> +
>  config JOYSTICK_ZHENHUA
>  	tristate "5-byte Zhenhua RC transmitter"
>  	select SERIO
> diff --git a/drivers/input/joystick/Makefile b/drivers/input/joystick/Makefile
> index 92dc0de..78466d6 100644
> --- a/drivers/input/joystick/Makefile
> +++ b/drivers/input/joystick/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_JOYSTICK_TMDC)		+= tmdc.o
>  obj-$(CONFIG_JOYSTICK_TURBOGRAFX)	+= turbografx.o
>  obj-$(CONFIG_JOYSTICK_TWIDJOY)		+= twidjoy.o
>  obj-$(CONFIG_JOYSTICK_WARRIOR)		+= warrior.o
> +obj-$(CONFIG_JOYSTICK_WIICHUCK)		+= wiichuck.o
>  obj-$(CONFIG_JOYSTICK_XPAD)		+= xpad.o
>  obj-$(CONFIG_JOYSTICK_ZHENHUA)		+= zhenhua.o
>  obj-$(CONFIG_JOYSTICK_WALKERA0701)	+= walkera0701.o
> diff --git a/drivers/input/joystick/wiichuck.c b/drivers/input/joystick/wiichuck.c
> new file mode 100644
> index 0000000..85a194f
> --- /dev/null
> +++ b/drivers/input/joystick/wiichuck.c
> @@ -0,0 +1,441 @@
> +/*
> + * i2c Wiichuck driver (Nintendo Wiimote accessory connector)
> + *
> + * This driver supports Nintendo Wiimote accessories like the Nunchuck and
> + * the Classic Controller connected to an i2c bus.
> + *
> + * Copyright (c) 2011 Secret Lab Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This driver uses the polled input device abstraction to implement an
> + * input driver for Nintendo expansion devices wired up to an i2c bus.
> + *
> + * A state machine implements the protocol handling.  It starts in the
> + * DISCONNECTED state initially and polls every second waiting for a
> + * device to get attached, and reading the device id when one does.
> + * If the device is recognized, then the polling period is bumped up
> + * to 50ms, and the state machine enters into a loop alternating
> + * between writing the data address (which triggers data capture) and
> + * reading the data block out of the device.  If at any time the
> + * device is disconnected, then it goes back to DISCONNECTED state and
> + * drops the polling frequency back down to 1 second.
> + *
> + * A callback is implemented for each supported devices, currently the
> + * Nunchuck and the Classic Controller.  Wii Motion Plus has yet to be
> + * added.
> + */
> +
> +#include <linux/cache.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/input.h>
> +#include <linux/input-polldev.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/slab.h>
> +
> +MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
> +MODULE_DESCRIPTION("Wiichuck (i2c Nintendo Wiimote accessory) driver");
> +MODULE_LICENSE("GPL");
> +
> +#define WIICHUCK_POLL_PERIOD	(1000)	/* 1 second */
> +#ifdef DEBUG
> +#define WIICHUCK_CAPTURE_PERIOD (500)	/* 1/2 second for debug */
> +#else
> +#define WIICHUCK_CAPTURE_PERIOD (100)	/* 100 milliseconds */
> +#endif /* DEBUG */
> +
> +enum wiichuck_state {
> +	WIICHUCK_STATE_DISCONNECTED = 0,
> +	WIICHUCK_STATE_DATA,
> +};
> +
> +struct wiichuck_device {
> +	struct input_polled_dev *poll_dev;
> +	struct i2c_client *i2c_client;
> +	int (*process)(struct wiichuck_device *wiichuck);
> +	enum wiichuck_state state;
> +
> +	/*
> +	 * DMA buffer, with padding to give it its own cache line so that
> +	 * the DMA streaming works on non-coherent architectures.
> +	 * Question: Is this the proper pattern, and is this really necessary?
> +	 */
> +	uint8_t pad1[L1_CACHE_BYTES];
> +	uint8_t buf[6];
> +	uint8_t pad2[L1_CACHE_BYTES];
> +};

I think there's an attribute to do this, starting with an __ defined
in the kernel.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

