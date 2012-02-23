Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab2BWXIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:08:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38229 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab2BWXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:08:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.212.232 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Thu, 23 Feb 2012 15:08:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Preston Fick <pffick@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: cp210x: Update to support CP2105 and multiple
 interface devices
Message-ID: <20120223230813.GA7684@kroah.com>
References: <CAJbtUMHBDZB2N2xuyvrtRYs2zoThwV8L4YFxXEgorYSfnSuq+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJbtUMHBDZB2N2xuyvrtRYs2zoThwV8L4YFxXEgorYSfnSuq+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 04:03:56PM -0600, Preston Fick wrote:
> OS/Kernel version: GNU/Linux 3.3-rc4 (Mainline)

This isn't needed in the changelog.

> Description:

Neither was that line, just write the description :)

> This patch updates the cp210x driver to support CP210x multiple
> interface devices
> devices from Silicon Labs. The existing driver always sends control requests to
> interface 0, which is hardcoded in the usb_control_msg function calls. This only
> allows for single interface devices to be used, and causes a bug when
> using ports on
> an interface other than 0 in the multiple interface devices.
> 
> Here are the changes included in this patch:
> - Updated the device list to contain the Silicon Labs factory default
> VID/PID for multiple
> interface CP210x devices
> - Created a cp210x_port_private struct created for each port on
> startup, this struct
> holds the interface number
> - Added a cp210x_release function to clean up the cp210x_port_private memory
> created on startup
> - Modified usb_get_config and usb_set_config to get a pointer to the
> cp210x_port_private
> struct, and use the interface number there in the usb_control_message
> wIndex param

Odd formatting, what happened to your email client?  Just wrap at 72
colums and use plain text and all should be good.

But the big problem with this patch is:

> 
> Signed-off-by: Preston Fick <preston.fick@silabs.com>
> 
> ---
> 
> diff -uprN linux.vanilla//linux-3.3-rc4/drivers/usb/serial/cp210x.c
> linux.new//linux-3.3-rc4/drivers/usb/serial/cp210x.c
> --- linux.vanilla//linux-3.3-rc4/drivers/usb/serial/cp210x.c	2012-02-18
> 17:53:33.000000000 -0600

It's linewrapped and can't be applied :(

Also, there are some basic coding style issues in the patch, please
always run them through the scripts/checkpatch.pl tool before sending
them out so that I don't have to catch them when reviewing it.

Some basic comments on the patch:

> +++ linux.new//linux-3.3-rc4/drivers/usb/serial/cp210x.c	2012-02-23
> 14:43:29.703316401 -0600
> @@ -49,6 +49,7 @@ static int cp210x_tiocmset_port(struct u
>  		unsigned int, unsigned int);
>  static void cp210x_break_ctl(struct tty_struct *, int);
>  static int cp210x_startup(struct usb_serial *);
> +static void cp210x_release(struct usb_serial *);
>  static void cp210x_dtr_rts(struct usb_serial_port *p, int on);
> 
>  static bool debug;
> @@ -121,6 +122,8 @@ static const struct usb_device_id id_tab
>  	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
>  	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
>  	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
> +	{ USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs factory default */
> +	{ USB_DEVICE(0x10C4, 0xEA80) }, /* Silicon Labs factory default */
>  	{ USB_DEVICE(0x10C4, 0xEA71) }, /* Infinity GPS-MIC-1 Radio Monophone */
>  	{ USB_DEVICE(0x10C4, 0xF001) }, /* Elan Digital Systems USBscope50 */
>  	{ USB_DEVICE(0x10C4, 0xF002) }, /* Elan Digital Systems USBwave12 */
> @@ -147,6 +150,12 @@ static const struct usb_device_id id_tab
> 
>  MODULE_DEVICE_TABLE(usb, id_table);
> 
> +struct cp210x_port_private {
> +	/* loop back to the owner of this object */
> +	struct usb_serial_port	*port;

Why is this needed?  You always have the port, that's how you got this
structure pointer, right?

> +	__u8			bInterfaceNumber;
> +};
> +
>  static struct usb_driver cp210x_driver = {
>  	.name		= "cp210x",
>  	.probe		= usb_serial_probe,
> @@ -172,6 +181,7 @@ static struct usb_serial_driver cp210x_d
>  	.tiocmget 		= cp210x_tiocmget,
>  	.tiocmset		= cp210x_tiocmset,
>  	.attach			= cp210x_startup,
> +	.release		= cp210x_release,
>  	.dtr_rts		= cp210x_dtr_rts
>  };
> 
> @@ -259,9 +269,17 @@ static int cp210x_get_config(struct usb_
>  		unsigned int *data, int size)
>  {
>  	struct usb_serial *serial = port->serial;
> +	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
>  	__le32 *buf;
>  	int result, i, length;
> 
> +	/* Return a memory error if we cannot get the port_priv */
> +	if (!port_priv)

How could it be NULL?

> +	{
> +		dev_err(&port->dev, "%s - device couldn't retrieve private
> memory.\n", __func__);
> +		return -ENOMEM;

We didn't run out of memory, something worse happened here, right?

> +	}
> +
>  	/* Number of integers required to contain the array */
>  	length = (((size - 1) | 3) + 1)/4;
> 
> @@ -274,7 +292,7 @@ static int cp210x_get_config(struct usb_
>  	/* Issue the request, attempting to read 'size' bytes */
>  	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
>  				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
> -				0, buf, size, 300);
> +				port_priv->bInterfaceNumber, buf, size, 300);
> 
>  	/* Convert data into an array of integers */
>  	for (i = 0; i < length; i++)
> @@ -305,9 +323,17 @@ static int cp210x_set_config(struct usb_
>  		unsigned int *data, int size)
>  {
>  	struct usb_serial *serial = port->serial;
> +	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
>  	__le32 *buf;
>  	int result, i, length;
> 
> +	/* Return a memory error if we cannot get the port_priv */
> +	if (!port_priv)
> +	{
> +		dev_err(&port->dev, "%s - device couldn't retrieve private
> memory.\n", __func__);
> +		return -ENOMEM;
> +	}
> +
>  	/* Number of integers required to contain the array */
>  	length = (((size - 1) | 3) + 1)/4;
> 
> @@ -326,12 +352,12 @@ static int cp210x_set_config(struct usb_
>  		result = usb_control_msg(serial->dev,
>  				usb_sndctrlpipe(serial->dev, 0),
>  				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
> -				0, buf, size, 300);
> +				port_priv->bInterfaceNumber, buf, size, 300);
>  	} else {
>  		result = usb_control_msg(serial->dev,
>  				usb_sndctrlpipe(serial->dev, 0),
>  				request, REQTYPE_HOST_TO_DEVICE, data[0],
> -				0, NULL, 0, 300);
> +				port_priv->bInterfaceNumber, NULL, 0, 300);
>  	}
> 
>  	kfree(buf);
> @@ -842,11 +868,45 @@ static void cp210x_break_ctl (struct tty
> 
>  static int cp210x_startup(struct usb_serial *serial)
>  {
> +	struct cp210x_port_private *port_priv;
> +	int i;
> +
>  	/* cp210x buffers behave strangely unless device is reset */
>  	usb_reset_device(serial->dev);
> +
> +	for (i = 0; i < serial->num_ports; i++)
> +	{
> +		port_priv = kmalloc(sizeof(*port_priv), GFP_KERNEL);
> +		if (!port_priv)
> +			return -ENOMEM;
> +
> +		memset(port_priv, 0x00, sizeof(*port_priv));

Use kzalloc() instead of kmalloc() followed by memset(foo, 0x00, sizeof(*foo)).

> +		port_priv->port = serial->port[i];

You never use this pointer, so it can be removed, right?

Care to redo the patch based on the above review?

thanks,

greg k-h
