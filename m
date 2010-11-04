Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab0KDMr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 08:47:27 -0400
Received: from trinity.fluff.org ([89.16.178.74]:35633 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab0KDMr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 08:47:26 -0400
Date: Thu, 4 Nov 2010 12:47:24 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] i2c/busses: Add support for Diolan U2C-12 USB/I2C
	adapter
Message-ID: <20101104124724.GR21564@trinity.fluff.org>
References: <1288830389-13873-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288830389-13873-1-git-send-email-guenter.roeck@ericsson.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 05:26:29PM -0700, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> This is an usb-i2c adapter I am using to connect to i2c evaluation and test
> boards. Not sure if it is worth adding it into the kernel. If yes, I'll be
> happy to add myself as maintainer.
> 
>  drivers/i2c/busses/Kconfig          |   10 +
>  drivers/i2c/busses/Makefile         |    1 +
>  drivers/i2c/busses/i2c-diolan-u2c.c |  455 +++++++++++++++++++++++++++++++++++
>  3 files changed, 466 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-diolan-u2c.c
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 3a6321c..d73be36 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -640,6 +640,16 @@ config I2C_XILINX
>  
>  comment "External I2C/SMBus adapter drivers"
>  
> +config I2C_DIOLAN_U2C
> +	tristate "Diolan U2C-12 USB adapter"
> +	depends on USB
> +	help
> +	  If you say yes to this option, support will be included for Diolan
> +	  U2C-12, a USB to I2C interface.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called i2c-diolan-u2c.
> +
>  config I2C_PARPORT
>  	tristate "Parallel port adapter"
>  	depends on PARPORT
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 84cb16a..46315db 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -63,6 +63,7 @@ obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
>  obj-$(CONFIG_I2C_XILINX)	+= i2c-xiic.o
>  
>  # External I2C/SMBus adapter drivers
> +obj-$(CONFIG_I2C_DIOLAN_U2C)	+= i2c-diolan-u2c.o
>  obj-$(CONFIG_I2C_PARPORT)	+= i2c-parport.o
>  obj-$(CONFIG_I2C_PARPORT_LIGHT)	+= i2c-parport-light.o
>  obj-$(CONFIG_I2C_TAOS_EVM)	+= i2c-taos-evm.o
> diff --git a/drivers/i2c/busses/i2c-diolan-u2c.c b/drivers/i2c/busses/i2c-diolan-u2c.c
> new file mode 100644
> index 0000000..5f4fb74
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-diolan-u2c.c
> @@ -0,0 +1,455 @@
> +/*
> + * driver for the Diolan u2c-12 usb adapter
> + *
> + * Copyright (c) 2010 Ericsson AB
> + *
> + * Derived from:
> + *  i2c-tiny-usb.c
> + *  Copyright (C) 2006-2007 Till Harbaum (Till@Harbaum.org)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/usb.h>
> +#include <linux/i2c.h>
> +
> +#define USB_VENDOR_ID_DIOLAN		0x0abf
> +#define USB_DEVICE_ID_DIOLAN_U2C	0x3370
> +
> +#define DIOLAN_OUT_EP		0x02
> +#define DIOLAN_IN_EP		0x84
> +
> +/* commands via USB, must match command ids in the firmware */
> +#define CMD_I2C_READ		0x01
> +#define CMD_I2C_WRITE		0x02
> +#define CMD_I2C_SCAN		0x03	/* Returns list of detected devices */
> +#define CMD_I2C_RELEASE_SDA	0x04
> +#define CMD_I2C_RELEASE_SCL	0x05
> +#define CMD_I2C_DROP_SDA	0x06
> +#define CMD_I2C_DROP_SCL	0x07
> +#define CMD_I2C_READ_SDA	0x08
> +#define CMD_I2C_READ_SCL	0x09
> +#define CMD_GET_FW_VERSION	0x0a
> +#define CMD_GET_SERIAL		0x0b
> +#define CMD_I2C_START		0x0c
> +#define CMD_I2C_STOP		0x0d
> +#define CMD_I2C_REPEATED_START	0x0e
> +#define CMD_I2C_PUT_BYTE	0x0f
> +#define CMD_I2C_GET_BYTE	0x10
> +#define CMD_I2C_PUT_ACK		0x11
> +#define CMD_I2C_GET_ACK		0x12
> +#define CMD_I2C_PUT_BYTE_ACK	0x13
> +#define CMD_I2C_GET_BYTE_ACK	0x14
> +#define CMD_I2C_SET_SPEED	0x1b
> +#define CMD_I2C_GET_SPEED	0x1c
> +#define CMD_SET_CLOCK_SYNCH	0x24
> +#define CMD_GET_CLOCK_SYNCH	0x25
> +#define CMD_SET_CLOCK_SYNCH_TO	0x26
> +#define CMD_GET_CLOCK_SYNCH_TO	0x27
> +
> +#define RESP_OK			0x00
> +#define RESP_FAILED		0x01
> +#define RESP_BAD_MEMADDR	0x04
> +#define RESP_DATA_ERR		0x05
> +#define RESP_NOT_IMPLEMENTED	0x06
> +#define RESP_NACK		0x07
> +
> +#define U2C_I2C_FREQ_FAST	0	/* 400 kHz  */
> +#define U2C_I2C_FREQ_STD	1	/* 100 kHz  */
> +#define U2C_I2C_FREQ_83KHZ	2
> +#define U2C_I2C_FREQ_71KHZ	3
> +#define U2C_I2C_FREQ_62KHZ	4
> +#define U2C_I2C_FREQ_50KHZ	6
> +#define U2C_I2C_FREQ_25KHZ	16
> +#define U2C_I2C_FREQ_10KHZ	46
> +#define U2C_I2C_FREQ_5KHZ	96
> +#define U2C_I2C_FREQ_2KHZ	242
> +
> +#define DIOLAN_USB_TIMEOUT	100
> +
> +/* Structure to hold all of our device specific stuff */
> +struct i2c_diolan_u2c {
> +	struct usb_device *usb_dev;	/* the usb device for this device */
> +	struct usb_interface *interface;/* the interface for this device */
> +	struct i2c_adapter adapter;	/* i2c related things */
> +};
> +
> +/* usb layer */
> +
> +static int diolan_usb_transfer(struct i2c_adapter *adapter, u8 * obuffer,
> +			       int olen, u8 *ibuffer, int ilen)
> +{
> +	struct i2c_diolan_u2c *dev = adapter->algo_data;
> +	int ret = 0;
> +	int actual;
> +	unsigned char inbuffer[257];
> +
> +	if (olen) {
> +		ret = usb_bulk_msg(dev->usb_dev,
> +				   usb_sndbulkpipe(dev->usb_dev, DIOLAN_OUT_EP),
> +				   obuffer, olen, &actual, DIOLAN_USB_TIMEOUT);
> +	}
> +	if (!ret) {
> +		ret = usb_bulk_msg(dev->usb_dev,
> +				   usb_rcvbulkpipe(dev->usb_dev, DIOLAN_IN_EP),
> +				   inbuffer, sizeof(inbuffer), &actual,
> +				   DIOLAN_USB_TIMEOUT);
> +		if (ret == 0 && actual > 0) {
> +			ret = min(actual, ilen);
> +			switch (inbuffer[actual - 1]) {
> +			case RESP_NACK:
> +				ret = -EINVAL;
> +				goto abort;
> +			case RESP_OK:
> +				break;
> +			default:
> +				ret = -EIO;
> +				goto abort;
> +			}
> +			if (ret)
> +				memcpy(ibuffer, inbuffer, ret);
> +		}
> +	}
> +abort:
> +	return ret;
> +}
> +
> +/*
> + * Flush input queue.
> + * If we don't do this at startup and the controller has queued up
> + * messages which were not retrieved, it will stop responding
> + * at some point.
> + */
> +static void diolan_flush_input(struct usb_device *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < 10; i++) {
> +		int actual = 0;
> +		int ret;
> +		u8 inbuffer[257];
> +
> +		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, DIOLAN_IN_EP),
> +				   inbuffer, sizeof(inbuffer), &actual,
> +				   DIOLAN_USB_TIMEOUT);
> +		if (ret < 0 || actual == 0)
> +			break;
> +	}
> +}
> +
> +static int diolan_i2c_start(struct i2c_adapter *adapter)
> +{
> +	u8 buffer[1];
> +
> +	buffer[0] = CMD_I2C_START;
> +
> +	return diolan_usb_transfer(adapter, buffer, 1, buffer, 1);
> +}
> +
> +static int diolan_i2c_repeated_start(struct i2c_adapter *adapter)
> +{
> +	u8 buffer[1];

note, transfers to/from stack memory are not advised, esp. if this
involves the hardware dma-mapping the stack. Please move the buffer
to your private data.

> +	buffer[0] = CMD_I2C_REPEATED_START;
> +
> +	return diolan_usb_transfer(adapter, buffer, 1, buffer, 1);
> +}

why not doing something like

diolan_usb_cmd1(struct i2c_adapter *adapter, u8 command)
{
	struct i2c_diolan_u2c *dev = adapter->algo_data;	

	dev->buffer[0] = command;

	return diolan_usb_treansfer(adapter, dev->buffer, 1, dev->buffer, 1);
}

then a lot of these little transfer functions could be turned into much
smaller ones.

ie:

static int diolan_i2c_stop(struct i2c_adapter *adapter)
{
	return diolan_usb_cmd1(adapter, CMD_I2C_STOP);
}

> +static int diolan_i2c_stop(struct i2c_adapter *adapter)
> +{
> +	u8 buffer[1];
> +
> +	buffer[0] = CMD_I2C_STOP;
> +
> +	return diolan_usb_transfer(adapter, buffer, 1, buffer, 1);
> +}
> +
> +static int diolan_i2c_get_byte_ack(struct i2c_adapter *adapter, bool ack,
> +				   u8 *byte)
> +{
> +	u8 buffer[2];
> +	int rv;
> +
> +	buffer[0] = CMD_I2C_GET_BYTE_ACK;
> +	buffer[1] = ack;
> +
> +	rv = diolan_usb_transfer(adapter, buffer, 2, buffer, 2);
> +	if (rv > 0)
> +		*byte = buffer[0];
> +	else if (rv == 0)
> +		rv = -EIO;
> +
> +	return rv;
> +}

see notes about stack-mapping buffer.

> +static int diolan_i2c_put_byte_ack(struct i2c_adapter *adapter, u8 byte)
> +{
> +	u8 buffer[2];
> +
> +	buffer[0] = CMD_I2C_PUT_BYTE_ACK;
> +	buffer[1] = byte;
> +
> +	return diolan_usb_transfer(adapter, buffer, 2, buffer, 1);
> +}
> +
> +static int diolan_set_speed(struct i2c_adapter *adapter, u8 speed)
> +{
> +	u8 buffer[2];
> +
> +	buffer[0] = CMD_I2C_SET_SPEED;
> +	buffer[1] = speed;
> +
> +	return diolan_usb_transfer(adapter, buffer, 2, buffer, 1);
> +}

maybe roll-up the 2 byte transfers in the same was a one-byte.

> +static int diolan_fw_version(struct i2c_adapter *adapter)
> +{
> +	u8 buffer[3];
> +	int ret;
> +
> +	buffer[0] = CMD_GET_FW_VERSION;
> +	ret = diolan_usb_transfer(adapter, buffer, 1, buffer, 3);
> +	if (ret == 3)
> +		dev_info(&adapter->dev,
> +			 "Diolan U2C firmware version %d.%d\n",
> +			 buffer[0], buffer[1]);
> +	return ret;
> +}
> +
> +static int diolan_get_serial(struct i2c_adapter *adapter)
> +{
> +	u8 buffer[5];
> +	int ret;
> +
> +	buffer[0] = CMD_GET_SERIAL;
> +	ret = diolan_usb_transfer(adapter, buffer, 1, buffer, 5);
> +	if (ret == 5)
> +		dev_info(&adapter->dev,
> +			 "Diolan U2C serial number %d\n", *(u32 *) &buffer[0]);

*(u32 *) isn't nice, esp. as you're not going to know the endian-ness of
the host you are running on. suggest trying a explict le32 ot be32 get of
the data.

> +	return ret;
> +}

> +static int diolan_scan(struct i2c_adapter *adapter)
> +{
> +	u8 buffer[257];
> +	int i, ret;

suggest kmalloc() the buffer.

> +	buffer[0] = CMD_I2C_SCAN;
> +	ret = diolan_usb_transfer(adapter, buffer, 1, buffer, 257);
> +	if (ret > 0) {
> +		for (i = 0; i < ret - 1; i++) {
> +			if (buffer[i])
> +				dev_info(&adapter->dev,
> +					 "Found I2C device at address 0x%x\n",
> +					 buffer[i] >> 1);
> +		}
> +	}
> +	return ret;

do you really need to do this, we've already got a userspace i2cdetect
tool?

> +}
> +
> +/* i2c layer */
> +
> +static int usb_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs, int num)
> +{
> +	struct i2c_msg *pmsg;
> +	int i, j;
> +	int rc = 0;
> +
> +	rc = diolan_i2c_start(adapter);
> +	if (rc < 0)
> +		return rc;
> +
> +	for (i = 0; i < num; i++) {
> +		pmsg = &msgs[i];
> +		if (i) {
> +			rc = diolan_i2c_repeated_start(adapter);
> +			if (rc < 0)
> +				goto abort;
> +		}
> +		if (pmsg->flags & I2C_M_RD) {
> +			rc = diolan_i2c_put_byte_ack(adapter,
> +						((pmsg->addr & 0x7f) << 1) | 1);
> +			if (rc < 0)
> +				goto abort;
> +			for (j = 0; j < pmsg->len; j++) {
> +				u8 byte;
> +				bool ack = j < pmsg->len - 1;
> +
> +				/*
> +				 * Don't send NACK if this is the first byte
> +				 * of a SMBUS_BLOCK message.
> +				 */
> +				if (j == 0 && (pmsg->flags & I2C_M_RECV_LEN))
> +					ack = true;
> +
> +				rc = diolan_i2c_get_byte_ack(adapter, ack,
> +							     &byte);
> +				if (rc < 0)
> +					goto abort;
> +				/*
> +				 * Adjust count if first received byte is length
> +				 */
> +				if (j == 0 && (pmsg->flags & I2C_M_RECV_LEN)) {
> +					if (byte == 0
> +					    || byte > I2C_SMBUS_BLOCK_MAX) {
> +						rc = -EREMOTEIO;
> +						goto abort;
> +					}
> +					pmsg->len += byte;
> +				}
> +				pmsg->buf[j] = byte;
> +			}
> +		} else {
> +			rc = diolan_i2c_put_byte_ack(adapter,
> +						     (pmsg->addr & 0x7f) << 1);
> +			if (rc < 0)
> +				goto abort;
> +			for (j = 0; j < pmsg->len; j++) {
> +				rc = diolan_i2c_put_byte_ack(adapter,
> +							     pmsg->buf[j]);
> +				if (rc < 0)
> +					goto abort;
> +			}
> +		}
> +	}
> +abort:
> +	diolan_i2c_stop(adapter);
> +	return rc;
> +}
> +
> +/*
> + * Return list of supported functionality.
> + */
> +static u32 usb_func(struct i2c_adapter *a)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL |
> +	    I2C_FUNC_SMBUS_READ_BLOCK_DATA;
> +}

please make sure everything is prefixed with dio_ for nicer debugging.

> +static const struct i2c_algorithm usb_algorithm = {
> +	.master_xfer = usb_xfer,
> +	.functionality = usb_func,
> +};
> +
> +/* device layer */
> +
> +static struct usb_device_id i2c_diolan_u2c_table[] = {
> +	{USB_DEVICE(USB_VENDOR_ID_DIOLAN, USB_DEVICE_ID_DIOLAN_U2C)},

spaces between { and text please, same with }

> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(usb, i2c_diolan_u2c_table);
> +
> +static void i2c_diolan_u2c_free(struct i2c_diolan_u2c *dev)
> +{
> +	usb_put_dev(dev->usb_dev);
> +	kfree(dev);
> +}
> +
> +static int i2c_diolan_u2c_probe(struct usb_interface *interface,
> +				const struct usb_device_id *id)
> +{
> +	struct i2c_diolan_u2c *dev;
> +	int retval = -ENOMEM;
> +
> +	/* allocate memory for our device state and initialize it */
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (dev == NULL) {
> +		dev_err(&interface->dev, "Out of memory\n");
> +		goto error;
> +	}
> +
> +	dev->usb_dev = usb_get_dev(interface_to_usbdev(interface));
> +	dev->interface = interface;
> +
> +	/* save our data pointer in this interface device */
> +	usb_set_intfdata(interface, dev);
> +
> +	dev_info(&interface->dev,
> +		 "Diolan U2C at bus %03d address %03d\n",
> +		 dev->usb_dev->bus->busnum, dev->usb_dev->devnum);
> +
> +	/* setup i2c adapter description */
> +	dev->adapter.owner = THIS_MODULE;
> +	dev->adapter.class = I2C_CLASS_HWMON;
> +	dev->adapter.algo = &usb_algorithm;
> +	dev->adapter.algo_data = dev;
> +	snprintf(dev->adapter.name, sizeof(dev->adapter.name),
> +		 "i2c-u2c-usb at bus %03d device %03d",
> +		 dev->usb_dev->bus->busnum, dev->usb_dev->devnum);
> +
> +	dev->adapter.dev.parent = &dev->interface->dev;
> +
> +	diolan_flush_input(dev->usb_dev);
> +
> +	/* and finally attach to i2c layer */
> +	i2c_add_adapter(&dev->adapter);
> +
> +	diolan_fw_version(&dev->adapter);
> +
> +	retval = diolan_set_speed(&dev->adapter, U2C_I2C_FREQ_STD);
> +	if (retval < 0) {
> +		dev_err(&dev->adapter.dev,
> +			"failure %d setting I2C bus frequency\n", retval);
> +		goto error_del;
> +	}
> +	diolan_get_serial(&dev->adapter);
> +	diolan_scan(&dev->adapter);

do you really need to scan the bus on connection?

> +	dev_dbg(&dev->adapter.dev, "connected i2c-u2c-usb device\n");
> +
> +	return 0;
> +
> +error_del:
> +	i2c_del_adapter(&dev->adapter);
> +	i2c_diolan_u2c_free(dev);
> +error:
> +	return retval;
> +}
> +
> +static void i2c_diolan_u2c_disconnect(struct usb_interface *interface)
> +{
> +	struct i2c_diolan_u2c *dev = usb_get_intfdata(interface);
> +
> +	i2c_del_adapter(&dev->adapter);
> +	usb_set_intfdata(interface, NULL);
> +	i2c_diolan_u2c_free(dev);
> +
> +	dev_dbg(&interface->dev, "disconnected\n");
> +}
> +
> +static struct usb_driver i2c_diolan_u2c_driver = {
> +	.name = "i2c-u2c-usb",
> +	.probe = i2c_diolan_u2c_probe,
> +	.disconnect = i2c_diolan_u2c_disconnect,
> +	.id_table = i2c_diolan_u2c_table,
> +};
> +
> +static int __init usb_i2c_diolan_u2c_init(void)
> +{
> +	/* register this driver with the USB subsystem */
> +	return usb_register(&i2c_diolan_u2c_driver);
> +}
> +
> +static void __exit usb_i2c_diolan_u2c_exit(void)
> +{
> +	/* deregister this driver with the USB subsystem */
> +	usb_deregister(&i2c_diolan_u2c_driver);
> +}
> +
> +module_init(usb_i2c_diolan_u2c_init);
> +module_exit(usb_i2c_diolan_u2c_exit);
> +
> +/* ----- end of usb layer ------------------------------------------------ */
> +
> +MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
> +MODULE_DESCRIPTION("i2c-u2c-usb driver");
> +MODULE_LICENSE("GPL");

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

