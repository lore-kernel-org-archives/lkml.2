Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab0DBMui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:50:38 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50253 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab0DBMub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:50:31 -0400
Date: Fri, 2 Apr 2010 14:50:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>,
       Christopher Heiny <cheiny@synaptics.com>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <wmanson@synaptics.com>
Subject: Re: [RFC PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
Message-ID: <20100402145025.0265a074@hyperion.delvare>
In-Reply-To: <1269310058-10894-2-git-send-email-cheiny@synaptics.com>
References: <1269310058-10894-1-git-send-email-cheiny@synaptics.com>
	<1269310058-10894-2-git-send-email-cheiny@synaptics.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

Sorry for the delay. Here finally come my comments on your code. I'm
only commenting on the i2c side of things.

On Mon, 22 Mar 2010 19:07:38 -0700, Christopher Heiny wrote:
> Initial driver for Synaptics touchscreens using RMI4 protocol.
> 
> Signed-off-by: William Manson <WManson@synaptics.com>
> Signed-off-by: Allie Xiong <axiong@synaptics.com>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
> ---
> 
>  drivers/input/touchscreen/Kconfig            |   13 +
>  drivers/input/touchscreen/Makefile           |    1 +
>  drivers/input/touchscreen/rmi.h              |  196 ++++++++
>  drivers/input/touchscreen/rmi_app_touchpad.c |  355 +++++++++++++++
>  drivers/input/touchscreen/rmi_core.c         |  632 ++++++++++++++++++++++++++
>  drivers/input/touchscreen/rmi_core.h         |   57 +++
>  drivers/input/touchscreen/rmi_function_11.c  |  352 ++++++++++++++
>  drivers/input/touchscreen/rmi_function_11.h  |   39 ++
>  drivers/input/touchscreen/rmi_functions.h    |  109 +++++
>  drivers/input/touchscreen/rmi_i2c.h          |   54 +++
>  drivers/input/touchscreen/rmi_i2c_gta01.c    |  122 +++++
>  drivers/input/touchscreen/rmi_phys_i2c.c     |  545 ++++++++++++++++++++++
>  12 files changed, 2475 insertions(+), 0 deletions(-)
> 
> (...)
> diff --git a/drivers/input/touchscreen/rmi_i2c.h b/drivers/input/touchscreen/rmi_i2c.h
> new file mode 100755
> index 0000000..69b3317
> --- /dev/null
> +++ b/drivers/input/touchscreen/rmi_i2c.h
> @@ -0,0 +1,54 @@
> +/**
> + *
> + * Synaptics RMI over I2C Physical Layer Driver Header File.
> + * Copyright (c) 2007-2009 Synaptics Incorporated
> + *
> + */
> +/*
> + * This file is licensed under the GPL2 license.
> + *
> + *#############################################################################
> + * GPL
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> + * for more details.
> + *
> + *#############################################################################
> + */
> +
> +#ifndef _RMI_I2C_H
> +#define _RMI_I2C_H
> +
> +/* Platform-specific configuration data.
> + * This structure is used by the platform-specific driver to designate
> + * specific information about the hardware.  A platform client may supply
> + * an array of these to the rmi_phys_i2c driver.
> + */
> +struct rmi_i2c_clientdata {

This name is unfortunate. "client data" usually refers to run-time
state data of an i2c client. For configuration data, we rather use the
terms "platform data" or "setup data".

> +	/* The seven-bit i2c address of the device. */
> +	int i2c_address;

This is already included in the i2c client struct itself, so you
shouldn't have to carry it.

> +	/* The number of the irq.  Set to zero if polling is required. */
> +	int irq;
> +	/* The type of the irq (e.g., IRQF_TRIGGER_FALLING).Only valid if irq != 0 */
> +	int irq_type;
> +	/* Function used to query the state of the attention line.  It always
> +	* returns 1 for "active" regardless of the polarity of the attention line.
> +	*/
> +	int (*get_attention)(void);
> +};
> +
> +/* Descriptor structure.
> + * Describes the number of i2c devices on the bus that speak RMI.
> + */
> +struct rmi_i2c_data {
> +	int num_clients;
> +	struct rmi_i2c_clientdata *clientdata;
> +};
> +
> +#endif
> (...)
> diff --git a/drivers/input/touchscreen/rmi_phys_i2c.c b/drivers/input/touchscreen/rmi_phys_i2c.c
> new file mode 100755
> index 0000000..620ccef
> --- /dev/null
> +++ b/drivers/input/touchscreen/rmi_phys_i2c.c
> @@ -0,0 +1,545 @@
> +/**
> + *
> + * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
> + * Copyright (c) 2007-2009, Synaptics Incorporated
> + *
> + */
> +/*
> + * This file is licensed under the GPL2 license.
> + *
> + *#############################################################################
> + * GPL
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> + * for more details.
> + *
> + *#############################################################################
> + */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include "rmi_i2c.h"
> +#include "rmi.h"
> +
> +#define DRIVER_NAME "rmi4_i2c"
> +
> +/* Used to lock access to the page address.
> + */
> +static DEFINE_MUTEX(page_mutex);

It would seem better, performance-wise, to make this a per-device mutex.

> +
> +
> +static const struct i2c_device_id rmi_i2c_id_table[] = {
> +	{ DRIVER_NAME, 0 },

This is incorrect. What goes in device ID tables is _device_ names, nor
_driver_ names. It might be the same string, but you don't want to use
the driver symbol.

> +	{ },
> +};
> +MODULE_DEVICE_TABLE(i2c, rmi_i2c_id_table);
> +
> +
> +/*
> + * This is the data kept on a per instance (client) basis.  This data is
> + * always accessible by using the container_of() macro of the various elements
> + * inside.
> + */
> +struct instance_data {
> +	int instance_no;
> +	int irq;
> +	struct rmi_phys_driver rpd;
> +	struct i2c_client i2cclient;

You don't need a copy of the i2c client in your own structure. It is
allocated by the i2c core, if you need a reference to it, then just
store a pointer thereto.

This is the only blocker point in your driver as far as I am concerned.
All my other comments are minor things.

> +	int page;
> +	int (*get_attention)(void);
> +};
> +
> +/*
> + * RMI devices have 16-bit addressing, but some of the physical
> + * implementations (like SMBus) only have 8-bit addressing.  So RMI implements
> + * a page address at 0xff of every page so we can reliable page addresses
> + * every 256 registers.  This function sets the page.
> + *
> + * The page_mutex lock must be held when this function is entered.
> + *
> + * param[in] id TBD
> + * param[in] page The new page address.
> + * returns zero on success, non-zero on failure.
> + */
> +int
> +rmi_set_page(struct instance_data *id, unsigned int page)
> +{
> +	char txbuf[2];
> +	int retval;
> +	txbuf[0] = 0xff;
> +	txbuf[1] = page;
> +	retval = i2c_master_send(&id->i2cclient, txbuf, 2);
> +	if (retval != 2) {
> +		printk(KERN_ERR "rmi_i2c: Set page fail: %d\n", retval);
> +	} else {
> +		retval = 0;
> +		id->page = page;
> +	}

This works, but I would encourage you to use i2c_smbus_write_byte_data
instead, as it is more portable.

> +	return retval;
> +}
> +
> +/*
> + * Read a single register through i2c.
> + *
> + * param[in] pd TBD
> + * param[in] address The address at which to start the data read.
> + * param[out] valp Pointer to the buffer where the data will be stored.
> + * returns xero upon success (with the byte read in valp), non-zero upon error.
> + */
> +static int
> +rmi_i2c_read(struct rmi_phys_driver *pd, unsigned short address, char *valp)
> +{
> +	struct instance_data *id = container_of(pd, struct instance_data, rpd);
> +	char txbuf[2];
> +	int retval = 0;
> +	int retry_count = 0;
> +
> +	/* Can't have anyone else changing the page behind our backs */
> +	mutex_lock(&page_mutex);
> +
> +	if (((address >> 8) & 0xff) != id->page) {
> +		/* Switch pages */
> +		retval = rmi_set_page(id, ((address >> 8) & 0xff));
> +		if (retval) {
> +			goto exit;
> +		}
> +	}
> +
> +retry:
> +	txbuf[0] = address & 0xff;
> +	retval = i2c_master_send(&id->i2cclient, txbuf, 1);
> +
> +	if (retval != 1) {
> +		printk(KERN_ERR "rmi_i2c.rmi_i2c_read: Write fail: %d\n",
> +			retval);
> +		goto exit;
> +	}
> +	retval = i2c_master_recv(&id->i2cclient, txbuf, 1);

Using i2c_smbus_read_byte_data() would look better, be more portable,
faster and more robust, if your device supports I2C repeated-start.

> +
> +	if (retval != 1) {
> +		if (++retry_count == 5) {
> +			printk(KERN_ERR "rmi_i2c.rmi_i2c_read: "
> +				"Read of 0x%04x fail: %d\n", address, retval);
> +		} else {
> +			mdelay(10);
> +			rmi_set_page(id, ((address >> 8) & 0xff));
> +			goto retry;
> +		}
> +	} else {
> +		retval = 0;
> +		*valp = txbuf[0];
> +	}
> +exit:
> +	mutex_unlock(&page_mutex);
> +	return retval;
> +}
> +
> +/*
> + * Same as rmi_i2c_read, except that multiple bytes are allowed to be read.
> + *
> + * param[in] pd TBD
> + * param[in] address The address at which to start the data read.
> + * param[out] valp Pointer to the buffer where the data will be stored.  This
> + *  buffer must be at least size bytes long.
> + * param[in] size The number of bytes to be read.
> + * returns zero upon success (with the byte read in valp), non-zero upon error.
> + *
> + */
> +static int
> +rmi_i2c_read_multiple(struct rmi_phys_driver *pd, unsigned short address,
> +	char *valp, int size)
> +{
> +	struct instance_data *id = container_of(pd, struct instance_data, rpd);
> +	char txbuf[2];
> +	int retval = 0;
> +	int retry_count = 0;
> +
> +	/* Can't have anyone else changing the page behind our backs */
> +	mutex_lock(&page_mutex);
> +
> +	if (((address >> 8) & 0xff) != id->page) {
> +		/* Switch pages */
> +		retval = rmi_set_page(id, ((address >> 8) & 0xff));
> +		if (retval) {
> +			goto exit;
> +		}
> +	}
> +
> +retry:
> +	txbuf[0] = address & 0xff;
> +	retval = i2c_master_send(&id->i2cclient, txbuf, 1);
> +
> +	if (retval != 1) {
> +		printk(KERN_ERR "rmi_i2c.rmi_i2c_read: Write fail: %d\n",
> +			retval);
> +		goto exit;
> +	}
> +	retval = i2c_master_recv(&id->i2cclient, valp, size);

Likewise, i2c_smbus_read_i2c_block_data() would be better, if you never
need to read more than 32 bytes at once. If you need to, then
i2c_transfer() would still be better than i2c_master_send +
i2c_master_recv, as you avoid the downtime between the 2 messages on
the bus.

> +
> +	if (retval != size) {
> +		if (++retry_count == 5) {
> +			printk(KERN_ERR "rmi_2ic.rmi_i2c_read_multiple: "
> +				"Read of 0x%04x size %d fail: %d\n",
> +				address, size, retval);
> +		} else {
> +			mdelay(10);
> +			rmi_set_page(id, ((address >> 8) & 0xff));
> +			goto retry;
> +		}
> +	} else {
> +		retval = 0;
> +	}
> +exit:
> +	mutex_unlock(&page_mutex);
> +	return retval;
> +}
> +
> +
> +/*
> + * Write a single register through i2c.
> + * You can write multiple registers at once, but I made the functions for that
> + * seperate for performance reasons.  Writing multiple requires allocation and
> + * freeing.
> + *
> + * param[in] pd TBD
> + * param[in] address The address at which to start the write.
> + * param[in] data The data to be written.
> + * returns one upon success, something else upon error.
> + */
> +static int
> +rmi_i2c_write(struct rmi_phys_driver *pd, unsigned short address, char data)
> +{
> +	struct instance_data *id = container_of(pd, struct instance_data, rpd);
> +	unsigned char txbuf[2];
> +	int retval = 0;
> +
> +	/* Can't have anyone else changing the page behind our backs */
> +	mutex_lock(&page_mutex);
> +
> +	if (((address >> 8) & 0xff) != id->page) {
> +		/* Switch pages */
> +		retval = rmi_set_page(id, ((address >> 8) & 0xff));
> +		if (retval) {
> +			goto exit;
> +		}
> +	}
> +
> +	txbuf[0] = address & 0xff;
> +	txbuf[1] = data;
> +	retval = i2c_master_send(&id->i2cclient, txbuf, 2);

Could be implemented using i2c_smbus_write_data_byte().

> +
> +	if (retval != 2) {
> +		printk(KERN_ERR "rmi_i2c.rmi_i2c_write: Write fail: %d\n",
> +			retval);
> +		goto exit; /* Leave this in case we add code below */
> +	}
> +exit:
> +	mutex_unlock(&page_mutex);
> +	return retval;
> +}
> +
> +/*
> + * Write multiple registers.
> + *
> + * param[in] pd TBD
> + * param[in] address The address at which to start the write.
> + * param[in] valp A pointer to a buffer containing the data to be written.
> + * param[in] size The number of bytes to write.
> + * returns one upon success, something else upon error.
> + */
> +static int
> +rmi_i2c_write_multiple(struct rmi_phys_driver *pd, unsigned short address,
> +	char *valp, int size)
> +{
> +	struct instance_data *id = container_of(pd, struct instance_data, rpd);
> +	unsigned char *txbuf;
> +	unsigned char txbuf_most[16];
> +	int retval = 0;
> +
> +	if (size < 15) {

Whould be <= 15, if I'm not mistaken. Using <= sizeof(txbuf_most) + 1
would be better.

> +		/* Avoid an allocation if we can help it. */
> +		txbuf = txbuf_most;
> +	} else {
> +		txbuf = kmalloc(size + 1, GFP_KERNEL);
> +		if (!txbuf)
> +			return -ENOMEM;
> +	}
> +
> +	/* Yes, it stinks here that we have to copy the buffer */

If you were using i2c_smbus_write_i2c_block_data(), you wouldn't have
to. Unless you must write more than 32 bytes sometimes? In that case,
it's indeed not an option.

> +	{
> +		int i;
> +		for (i = 0; i < size; i++) {
> +			txbuf[i + 1] = valp[i];
> +		}
> +	}

If you keep that code, please just define "i" earlier in your function
to save the extra indentation, it's bad coding practice.

> +
> +	/* Can't have anyone else changing the page behind our backs */
> +	mutex_lock(&page_mutex);
> +
> +	if (((address >> 8) & 0xff) != id->page) {
> +		/* Switch pages */
> +		retval = rmi_set_page(id, ((address >> 8) & 0xff));
> +		if (retval) {
> +			goto exit;
> +		}
> +	}
> +
> +	txbuf[0] = address & 0xff;
> +	retval = i2c_master_send(&id->i2cclient, txbuf, size + 1);
> +
> +	if (retval != 1) {
> +		printk(KERN_ERR "rmi_i2c.rmi_i2c_read: Write fail: %d\n", retval);

That's what you get when hard-coding function names in log messages ;)
You'd rather use %s and __func__, so you don't get it wrong.

> +		goto exit;
> +	}
> +exit:
> +	mutex_unlock(&page_mutex);
> +	if (txbuf != txbuf_most)
> +		kfree(txbuf);
> +	return retval;
> +}

I am curious why your read functions have a retry mechanism and your
write functions do not?

> +
> +/*
> + * Get the state of the attention line.
> + * This function returns 1 for an active attention regardless of the
> + * polarity of the ATTN signal.  If the get_attention function of the instance
> + * is not available (probably because ATTN is not implemented), then it always
> + * returns inactive.
> + */
> +static int
> +rmi_i2c_get_attention(struct rmi_phys_driver *rpd)
> +{
> +	struct instance_data *id = container_of(rpd, struct instance_data, rpd);
> +	if (id->get_attention) {
> +		return id->get_attention();
> +	} else {
> +		return 0; /* return inactive */
> +	}
> +}

This function has nothing i2c-specific, so I'm curious why it is there.

> +
> +/*
> + * This is the Interrupt Service Routine.  It just notifies the application
> + * layer that attention is required.
> + */
> +static irqreturn_t
> +i2c_attn_isr(int irq, void *info)
> +{
> +	struct instance_data *id = info;
> +	disable_irq(id->irq);
> +	if (id->rpd.attention) {
> +		id->rpd.attention(&id->rpd, id->instance_no);
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * The Driver probe function - will allocate and initialize the instance data and
> + * request the irq and set the instance data as the clients clientdta then

Typo: clientdata.

> + * register the physical driver which will do a scan of the RMI4 Physical Device Table
> + * and enumerate any RMI4 functions that have data sources associated with them.
> + *
> + */
> +static int
> +rmi_i2c_probe(struct i2c_client *client, const struct i2c_device_id *dev_id)
> +{
> +	struct instance_data *id;
> +	int retval = 0;
> +	int i;
> +	int numclients = 0;

Useless initialization.

> +	struct rmi_i2c_data *rmii2cdata;
> +	struct rmi_i2c_clientdata *clientdata;
> +
> +	pr_debug("Probing i2c RMI device\n");
> +
> +	/* Allocate and initialize the instance data for this client */
> +	id = kzalloc(sizeof(*id) * 2, GFP_KERNEL);

Why * 2?

> +	if (!id) {
> +		printk(KERN_ERR "rmi_i2c_probe: Out of memory trying to allocate instance_data.\n");
> +		return -ENOMEM;
> +	}
> +
> +	id->rpd.name           = DRIVER_NAME;
> +	id->rpd.write          = rmi_i2c_write;
> +	id->rpd.read           = rmi_i2c_read;
> +	id->rpd.write_multiple = rmi_i2c_write_multiple;
> +	id->rpd.read_multiple  = rmi_i2c_read_multiple;
> +	id->rpd.get_attention  = rmi_i2c_get_attention;
> +	id->rpd.module         = THIS_MODULE;
> +	id->page               = 0xffff;    /* So we set the page correctly the first time */
> +
> +	rmii2cdata = ((struct rmi_i2c_data *)(client->dev.platform_data));

platform_data is void* so no cast is needed.

> +	numclients = rmii2cdata->num_clients;
> +	/* Loop through the client data and locate the one that was found */

Now I am confused. Instead of attaching the proper platform data to
each I2C device, you have a single object with all the platform data
for all devices in it, and you pass that big object as the platform
data of all devices, and they have to find out which part is meant for
them? This is odd. What's the point of doing that? Why don't you just
set the platform data pointer to the right subset of data for every
device?

> +	for (i = 0; i < numclients; i++) {
> +		clientdata = &(rmii2cdata->clientdata[i]);
> +		if (client->addr == clientdata->i2c_address) {
> +			id->instance_no = i;
> +			id->get_attention = clientdata->get_attention;
> +
> +			/*
> +			* Determine if we need to poll (inefficient) or use interrupts.
> +			*/
> +			if (clientdata->irq) {
> +				int irqtype;
> +
> +				id->irq = clientdata->irq;
> +				switch (clientdata->irq_type) {
> +				case IORESOURCE_IRQ_HIGHEDGE:
> +					irqtype = IRQF_TRIGGER_RISING;
> +					break;
> +				case IORESOURCE_IRQ_LOWEDGE:
> +					irqtype = IRQF_TRIGGER_FALLING;
> +					break;
> +				case IORESOURCE_IRQ_HIGHLEVEL:
> +					irqtype = IRQF_TRIGGER_HIGH;
> +					break;
> +				case IORESOURCE_IRQ_LOWLEVEL:
> +					irqtype = IRQF_TRIGGER_LOW;
> +					break;
> +				default:
> +					printk(KERN_WARNING "rmi_i2c_probe: Invalid IRQ flags in "
> +						"platform data\n");
> +					kfree(id);
> +					return -ENXIO;
> +				}
> +
> +				retval = request_irq(id->irq, i2c_attn_isr, irqtype, "rmi_i2c", id);
> +				if (retval) {
> +					printk(KERN_WARNING "rmi_i2c_probe: Unable to get attn "
> +						"irq %d.  Reverting to polling.\n", id->irq);
> +					id->rpd.polling_required = true;
> +				} else {
> +					pr_debug("rmi_i2c_probe: got irq\n");
> +					id->rpd.polling_required = false;
> +				}
> +			} else {
> +				id->rpd.polling_required = true;
> +				printk(KERN_INFO "rmi_i2c_probe: No IRQ info given. "
> +					"Polling required.\n");
> +			}
> +		}
> +	}

What if no matching device has been found at this point? You shouldn't
continue.

> +
> +	/* Store the instance data in the i2c_client - we need to do this prior to calling
> +	*  register_physical_driver since it may use the read, write finctions.
> +	*/
> +	i2c_set_clientdata(client, id);
> +
> +	/* Register physical driver - this will call the detect function that will then
> +	*  scan the device and determine the supported RMI4 functions.
> +	*/
> +	retval = rmi_register_phys_driver(&id->rpd);
> +	if (retval) {
> +		printk(KERN_ERR "rmi_i2c_probe : Failed to Register %s phys driver\n", id->rpd.name);
> +		i2c_set_clientdata(client, NULL);
> +		if (id->irq) {
> +			free_irq(id->irq, id);

If id->irq is set but you failed to request the irq (request_irq()
failed), you're freeing an irq you never got. Not good. You should only
set id->irq after you successfully requested the irq.

> +		}
> +		kfree(id);
> +		return retval;
> +	}
> +
> +	pr_debug("rmi_i2c_probe : Successfully Registered %s phys driver\n", id->rpd.name);
> +
> +	return retval;
> +}
> +
> +/*
> + * The Driver remove function.  We tear down the instance data and unregister the phys driver
> + * in this call.
> + */
> +static int
> +rmi_i2c_remove(struct i2c_client *client)
> +{
> +	struct instance_data *id = i2c_get_clientdata(client);
> +
> +	pr_debug("Unregistering phys driver %s\n", id->rpd.name);

Please use dev_dbg(&client->dev, ...) instead, everywhere. This makes
it much easier to find out who is sending the message. Same for all the
rest of your code, BTW: dev_warn() is preferred pr_warning(), etc.

> +
> +	rmi_unregister_phys_driver(&id->rpd);
> +
> +	pr_debug("Unregistered phys driver %s\n", id->rpd.name);
> +
> +	if (id->irq) {
> +		free_irq(id->irq, id);

Same problem here.

> +	}
> +
> +	kfree(id);
> +	pr_debug("remove successful\n");
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int
> +rmi_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	/* Touch sleep mode */
> +	return 0;
> +}
> +
> +static int
> +rmi_i2c_resume(struct i2c_client *client)
> +{
> +	/* Re-initialize upon resume */
> +	return 0;
> +}
> +#else
> +#define rmi_i2c_suspend	NULL
> +#define rmi_i2c_resume	NULL
> +#endif
> +
> +/*
> + * This structure tells the i2c subsystem about us.
> + *
> + * TODO: we should add .suspend and .resume fns.
> + *
> + */
> +static struct i2c_driver rmi_i2c_driver = {
> +	.probe		= rmi_i2c_probe,
> +	.remove		= rmi_i2c_remove,
> +	.suspend	= rmi_i2c_suspend,
> +	.resume		= rmi_i2c_resume,
> +	.driver = {
> +		.name  = DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +	.id_table	= rmi_i2c_id_table,
> +};
> +
> +/*
> + * Register ourselves with i2c Chip Driver.
> + *
> + */
> +static int __init rmi_phys_i2c_init(void)
> +{
> +	if (RMI_ALLOC_STATS) {
> +		pr_debug("Allocation Stats Enabled\n");
> +	}

I'd much prefer:

#if RMI_ALLOC_STATS
	pr_debug("Allocation Stats Enabled\n");
#endif

for consistency with the rest of the use cases. I'm also unsure why you
print this here rather than in rmi_core_init(), given that this is
nothing i2c-specific.

> +
> +	return i2c_add_driver(&rmi_i2c_driver);
> +}
> +
> +/*
> + * Un-register ourselves from the i2c Chip Driver.
> + *
> + */
> +static void __exit rmi_phys_i2c_exit(void)
> +{
> +	i2c_del_driver(&rmi_i2c_driver);
> +}
> +
> +
> +module_init(rmi_phys_i2c_init);
> +module_exit(rmi_phys_i2c_exit);
> +
> +MODULE_AUTHOR("Synaptics, Inc.");
> +MODULE_DESCRIPTION("RMI4 Driver I2C Physical Layer");
> +MODULE_LICENSE("GPL");

This is it. Hope it was helpful.

-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
