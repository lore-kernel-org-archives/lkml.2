Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0JYLLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:11:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62143 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab0JYLLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eolLuQoGs85U91gJ8J0zLgjHxDslKK9XbVSfeMxPzQgnmClR+9kaoWi0H5TBUMTAmr
         VdkdY61ucEO2dyynTqe14OLLc0GXCzRB7XkE7JhZSRqZBDWNR+qxM32o+wOAEYF4mZNk
         PUoSsw4oQ2+6CCIoS1icV8HzcPF5AU0ded3UY=
Date: Mon, 25 Oct 2010 13:11:26 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alon Ziv <alon+git@nolaviz.org>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] opticon: use generic code where possible
Message-ID: <20101025111126.GA4046@localhost>
References: <1287859409-13810-1-git-send-email-alon-git@nolaviz.org>
 <1287859409-13810-3-git-send-email-alon-git@nolaviz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287859409-13810-3-git-send-email-alon-git@nolaviz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alon, 

Some comments follow below.

On Sat, Oct 23, 2010 at 08:43:29PM +0200, Alon Ziv wrote:
> Use usb_serial_generic_XXX instead of custom code (wherever possible).
> Both code size and private data are reduced considerably.
> 
> Signed-off-by: Alon Ziv <alon-git@nolaviz.org>
> ---
>  drivers/usb/serial/opticon.c |  411 +++++-------------------------------------
>  1 files changed, 44 insertions(+), 367 deletions(-)
> 
> diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
> index eda1f92..f7dd851 100644
> --- a/drivers/usb/serial/opticon.c
> +++ b/drivers/usb/serial/opticon.c
> @@ -31,54 +31,19 @@ MODULE_DEVICE_TABLE(usb, id_table);
>  
>  /* This structure holds all of the individual device information */
>  struct opticon_private {
> -	struct usb_device *udev;
> -	struct usb_serial *serial;
> -	struct usb_serial_port *port;
> -	unsigned char *bulk_in_buffer;
> -	struct urb *bulk_read_urb;
> -	int buffer_size;
> -	u8 bulk_address;
> -	spinlock_t lock;	/* protects the following flags */
> -	bool throttled;
> -	bool actually_throttled;
>  	bool rts;
> -	int outstanding_urbs;
>  };
>  
>  /* max number of write urbs in flight */
>  #define URB_UPPER_LIMIT	4

This one is no longer needed.

> -static void opticon_bulk_callback(struct urb *urb)
> +static void opticon_process_read_urb(struct urb *urb)
>  {
> -	struct opticon_private *priv = urb->context;
> +	struct usb_serial_port *port = urb->context;
> +	struct opticon_private *priv = usb_get_serial_data(port->serial);
>  	unsigned char *data = urb->transfer_buffer;
> -	struct usb_serial_port *port = priv->port;
> -	int status = urb->status;
> -	struct tty_struct *tty;
> -	int result;
>  	int data_length;
> -
> -	dbg("%s - port %d", __func__, port->number);
> -
> -	switch (status) {
> -	case 0:
> -		/* success */
> -		break;
> -	case -ECONNRESET:
> -	case -ENOENT:
> -	case -ESHUTDOWN:
> -		/* this urb is terminated, clean up */
> -		dbg("%s - urb shutting down with status: %d",
> -		    __func__, status);
> -		return;
> -	default:
> -		dbg("%s - nonzero urb status received: %d",
> -		    __func__, status);
> -		goto exit;
> -	}
> -
> -	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length,
> -			      data);
> +	struct tty_struct *tty;
>  
>  	if (urb->actual_length > 2) {
>  		data_length = urb->actual_length - 2;
> @@ -87,10 +52,10 @@ static void opticon_bulk_callback(struct urb *urb)
>  		 * Data from the device comes with a 2 byte header:
>  		 *
>  		 * <0x00><0x00>data...
> -		 * 	This is real data to be sent to the tty layer
> -		 * <0x00><0x01)level
> -		 * 	This is a RTS level change, the third byte is the RTS
> -		 * 	value (0 for low, 1 for high).
> +		 *	This is real data to be sent to the tty layer
> +		 * <0x00><0x01>level
> +		 *	This is a RTS level change, the third byte is the RTS
> +		 *	value (0 for low, 1 for high).
>  		 */
>  		if ((data[0] == 0x00) && (data[1] == 0x00)) {
>  			/* real data, send it to the tty layer */
> @@ -108,269 +73,71 @@ static void opticon_bulk_callback(struct urb *urb)
>  				else
>  					priv->rts = true;
>  			} else {
> -				dev_dbg(&priv->udev->dev,
> +				dev_dbg(&port->dev,
>  					"Unknown data packet received from the device:"
>  					" %2x %2x\n",
>  					data[0], data[1]);
>  			}
>  		}
>  	} else {
> -		dev_dbg(&priv->udev->dev,
> +		dev_dbg(&port->dev,
>  			"Improper amount of data received from the device, "
>  			"%d bytes", urb->actual_length);
>  	}
> -
> -exit:
> -	spin_lock(&priv->lock);
> -
> -	/* Continue trying to always read if we should */
> -	if (!priv->throttled) {
> -		usb_fill_bulk_urb(priv->bulk_read_urb, priv->udev,
> -				  usb_rcvbulkpipe(priv->udev,
> -						  priv->bulk_address),
> -				  priv->bulk_in_buffer, priv->buffer_size,
> -				  opticon_bulk_callback, priv);
> -		result = usb_submit_urb(priv->bulk_read_urb, GFP_ATOMIC);
> -		if (result)
> -			dev_err(&port->dev,
> -			    "%s - failed resubmitting read urb, error %d\n",
> -							__func__, result);
> -	} else
> -		priv->actually_throttled = true;
> -	spin_unlock(&priv->lock);
> -}
> -
> -static int opticon_open(struct tty_struct *tty, struct usb_serial_port *port)
> -{
> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
> -	unsigned long flags;
> -	int result = 0;
> -
> -	dbg("%s - port %d", __func__, port->number);
> -
> -	spin_lock_irqsave(&priv->lock, flags);
> -	priv->throttled = false;
> -	priv->actually_throttled = false;
> -	priv->port = port;
> -	spin_unlock_irqrestore(&priv->lock, flags);
> -
> -	/* Start reading from the device */
> -	usb_fill_bulk_urb(priv->bulk_read_urb, priv->udev,
> -			  usb_rcvbulkpipe(priv->udev,
> -					  priv->bulk_address),
> -			  priv->bulk_in_buffer, priv->buffer_size,
> -			  opticon_bulk_callback, priv);
> -	result = usb_submit_urb(priv->bulk_read_urb, GFP_KERNEL);
> -	if (result)
> -		dev_err(&port->dev,
> -			"%s - failed resubmitting read urb, error %d\n",
> -			__func__, result);
> -	return result;
> -}
> -
> -static void opticon_close(struct usb_serial_port *port)
> -{
> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
> -
> -	dbg("%s - port %d", __func__, port->number);
> -
> -	/* shutdown our urbs */
> -	usb_kill_urb(priv->bulk_read_urb);
> -}
> -
> -static void opticon_write_bulk_callback(struct urb *urb)
> -{
> -	struct opticon_private *priv = urb->context;
> -	int status = urb->status;
> -	unsigned long flags;
> -
> -	/* free up the transfer buffer, as usb_free_urb() does not do this */
> -	kfree(urb->transfer_buffer);
> -
> -	/* setup packet may be set if we're using it for writing */
> -	kfree(urb->setup_packet);
> -
> -	if (status)
> -		dbg("%s - nonzero write bulk status received: %d",
> -		    __func__, status);
> -
> -	spin_lock_irqsave(&priv->lock, flags);
> -	--priv->outstanding_urbs;
> -	spin_unlock_irqrestore(&priv->lock, flags);
> -
> -	usb_serial_port_softint(priv->port);
>  }
>  
>  static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
>  			 const unsigned char *buf, int count)
>  {
> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
> -	struct usb_serial *serial = port->serial;
> -	struct urb *urb;
> -	unsigned char *buffer;
> -	unsigned long flags;
> -	int status;
> -
>  	dbg("%s - port %d", __func__, port->number);
>  
> -	spin_lock_irqsave(&priv->lock, flags);
> -	if (priv->outstanding_urbs > URB_UPPER_LIMIT) {
> -		spin_unlock_irqrestore(&priv->lock, flags);
> -		dbg("%s - write limit hit", __func__);
> -		return 0;
> -	}
> -	priv->outstanding_urbs++;
> -	spin_unlock_irqrestore(&priv->lock, flags);
> -
> -	buffer = kmalloc(count, GFP_ATOMIC);
> -	if (!buffer) {
> -		dev_err(&port->dev, "out of memory\n");
> -		count = -ENOMEM;
> -		goto error_no_buffer;
> -	}
> -
> -	urb = usb_alloc_urb(0, GFP_ATOMIC);
> -	if (!urb) {
> -		dev_err(&port->dev, "no more free urbs\n");
> -		count = -ENOMEM;
> -		goto error_no_urb;
> -	}
> -
> -	memcpy(buffer, buf, count);
> -
> -	usb_serial_debug_data(debug, &port->dev, __func__, count, buffer);
> -
> -	if (port->bulk_out_endpointAddress) {
> -		usb_fill_bulk_urb(urb, serial->dev,
> -				  usb_sndbulkpipe(serial->dev,
> -						  port->bulk_out_endpointAddress),
> -				  buffer, count, opticon_write_bulk_callback, priv);
> -	} else {
> -		struct usb_ctrlrequest *dr;
> -
> -		dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
> -		if (!dr)
> -			return -ENOMEM;
> -
> -		dr->bRequestType = USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT;
> -		dr->bRequest = 0x01;
> -		dr->wValue = 0;
> -		dr->wIndex = 0;
> -		dr->wLength = cpu_to_le16(count);
> -
> -		usb_fill_control_urb(urb, serial->dev,
> -			usb_sndctrlpipe(serial->dev, 0),
> -			(unsigned char *)dr, buffer, count,
> -			opticon_write_bulk_callback, priv);
> -	}
> -
> -	/* send it down the pipe */
> -	status = usb_submit_urb(urb, GFP_ATOMIC);
> -	if (status) {
> -		dev_err(&port->dev,
> -		   "%s - usb_submit_urb(write bulk) failed with status = %d\n",
> -							__func__, status);
> -		count = status;
> -		goto error;
> -	}
> -
> -	/* we are done with this urb, so let the host driver
> -	 * really free it when it is finished with it */
> -	usb_free_urb(urb);
> -
> -	return count;
> -error:
> -	usb_free_urb(urb);
> -error_no_urb:
> -	kfree(buffer);
> -error_no_buffer:
> -	spin_lock_irqsave(&priv->lock, flags);
> -	--priv->outstanding_urbs;
> -	spin_unlock_irqrestore(&priv->lock, flags);
> -	return count;
> +	if (port->bulk_out_endpointAddress)
> +		return usb_serial_generic_write(tty, port, buf, count);
> +	else
> +		return usb_control_msg(port->serial->dev,
> +				usb_sndctrlpipe(port->serial->dev, 0),
> +				0x01,
> +				USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT,
> +				0, 0,
> +				(void *)buf, count, 100);

Here it seems you're turning write into a blocking function if you have
no bulk-out end-point. I'm not sure that is desired.

>  }
>  
>  static int opticon_write_room(struct tty_struct *tty)
>  {
>  	struct usb_serial_port *port = tty->driver_data;
> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
> -	unsigned long flags;
> -
> -	dbg("%s - port %d", __func__, port->number);
> -
> -	/*
> -	 * We really can take almost anything the user throws at us
> -	 * but let's pick a nice big number to tell the tty
> -	 * layer that we have lots of free space, unless we don't.
> -	 */
> -	spin_lock_irqsave(&priv->lock, flags);
> -	if (priv->outstanding_urbs > URB_UPPER_LIMIT * 2 / 3) {
> -		spin_unlock_irqrestore(&priv->lock, flags);
> -		dbg("%s - write limit hit", __func__);
> -		return 0;
> -	}
> -	spin_unlock_irqrestore(&priv->lock, flags);
> -
> -	return 2048;
> +	if (port->bulk_out_endpointAddress)
> +		return usb_serial_generic_write_room(tty);
> +	else
> +		return 64;

Why limit to 64b in the no-bulk-out case when driver used to report and
use 2048b (which matches tty-layers partitioning)?

>  }
>  
>  static void opticon_throttle(struct tty_struct *tty)
>  {
> -	struct usb_serial_port *port = tty->driver_data;
> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
> -	unsigned long flags;
> -
> -	dbg("%s - port %d", __func__, port->number);
> -	spin_lock_irqsave(&priv->lock, flags);
> -	priv->throttled = true;
> -	spin_unlock_irqrestore(&priv->lock, flags);
> +	usb_serial_generic_throttle(tty);
>  }

You should remove this function and set the throttle field to
usb_serial_generic_throttle in opticon_device instead.

>  static void opticon_unthrottle(struct tty_struct *tty)
>  {
> -	struct usb_serial_port *port = tty->driver_data;
> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
> -	unsigned long flags;
> -	int result, was_throttled;
> -
> -	dbg("%s - port %d", __func__, port->number);
> -
> -	spin_lock_irqsave(&priv->lock, flags);
> -	priv->throttled = false;
> -	was_throttled = priv->actually_throttled;
> -	priv->actually_throttled = false;
> -	spin_unlock_irqrestore(&priv->lock, flags);
> -
> -	priv->bulk_read_urb->dev = port->serial->dev;
> -	if (was_throttled) {
> -		result = usb_submit_urb(priv->bulk_read_urb, GFP_ATOMIC);
> -		if (result)
> -			dev_err(&port->dev,
> -				"%s - failed submitting read urb, error %d\n",
> -							__func__, result);
> -	}
> +	usb_serial_generic_unthrottle(tty);
>  }

You should remove this function and set the unthrottle field in
opticon_device instead.
  
>  static int opticon_tiocmget(struct tty_struct *tty, struct file *file)
>  {
>  	struct usb_serial_port *port = tty->driver_data;
>  	struct opticon_private *priv = usb_get_serial_data(port->serial);
> -	unsigned long flags;
>  	int result = 0;
>  
>  	dbg("%s - port %d", __func__, port->number);
>  
> -	spin_lock_irqsave(&priv->lock, flags);
>  	if (priv->rts)
>  		result = TIOCM_RTS;
> -	spin_unlock_irqrestore(&priv->lock, flags);
>  
>  	dbg("%s - %x", __func__, result);
>  	return result;
>  }

Locking no longer needed?

> -static int get_serial_info(struct opticon_private *priv,
> +static int get_serial_info(struct usb_serial_port *port,
>  			   struct serial_struct __user *serial)
>  {
>  	struct serial_struct tmp;
> @@ -382,9 +149,7 @@ static int get_serial_info(struct opticon_private *priv,
>  
>  	/* fake emulate a 16550 uart to make userspace code happy */
>  	tmp.type		= PORT_16550A;
> -	tmp.line		= priv->serial->minor;
> -	tmp.port		= 0;
> -	tmp.irq			= 0;
> +	tmp.line		= port->serial->minor;
>  	tmp.flags		= ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ;
>  	tmp.xmit_fifo_size	= 1024;
>  	tmp.baud_base		= 9600;
> @@ -400,26 +165,27 @@ static int opticon_ioctl(struct tty_struct *tty, struct file *file,
>  			 unsigned int cmd, unsigned long arg)
>  {
>  	struct usb_serial_port *port = tty->driver_data;
> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
>  
>  	dbg("%s - port %d, cmd = 0x%x", __func__, port->number, cmd);
>  
>  	switch (cmd) {
>  	case TIOCGSERIAL:
> -		return get_serial_info(priv,
> +		return get_serial_info(port,
>  				       (struct serial_struct __user *)arg);
>  	}
>  
>  	return -ENOIOCTLCMD;
>  }
>  
> -static int opticon_startup(struct usb_serial *serial)
> +static int opticon_attach(struct usb_serial *serial)
>  {
>  	struct opticon_private *priv;
> -	struct usb_host_interface *intf;
> -	int i;
> -	int retval = -ENOMEM;
> -	bool bulk_in_found = false;
> +
> +	if (serial->num_bulk_in != 1 || serial->num_bulk_out > 1) {
> +		dev_err(&serial->dev->dev,
> +			"Error - the proper endpoints were not found!\n");
> +		return -EINVAL;
> +	}
>  
>  	/* create our private serial structure */
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> @@ -427,70 +193,9 @@ static int opticon_startup(struct usb_serial *serial)
>  		dev_err(&serial->dev->dev, "%s - Out of memory\n", __func__);
>  		return -ENOMEM;
>  	}
> -	spin_lock_init(&priv->lock);
> -	priv->serial = serial;
> -	priv->port = serial->port[0];
> -	priv->udev = serial->dev;
> -
> -	/* find our bulk endpoint */
> -	intf = serial->interface->altsetting;
> -	for (i = 0; i < intf->desc.bNumEndpoints; ++i) {
> -		struct usb_endpoint_descriptor *endpoint;
> -
> -		endpoint = &intf->endpoint[i].desc;
> -		if (!usb_endpoint_is_bulk_in(endpoint))
> -			continue;
> -
> -		priv->bulk_read_urb = usb_alloc_urb(0, GFP_KERNEL);
> -		if (!priv->bulk_read_urb) {
> -			dev_err(&priv->udev->dev, "out of memory\n");
> -			goto error;
> -		}
> -
> -		priv->buffer_size = le16_to_cpu(endpoint->wMaxPacketSize) * 2;
> -		priv->bulk_in_buffer = kmalloc(priv->buffer_size, GFP_KERNEL);
> -		if (!priv->bulk_in_buffer) {
> -			dev_err(&priv->udev->dev, "out of memory\n");
> -			goto error;
> -		}
> -
> -		priv->bulk_address = endpoint->bEndpointAddress;
> -
> -		/* set up our bulk urb */
> -		usb_fill_bulk_urb(priv->bulk_read_urb, priv->udev,
> -				  usb_rcvbulkpipe(priv->udev,
> -						  endpoint->bEndpointAddress),
> -				  priv->bulk_in_buffer, priv->buffer_size,
> -				  opticon_bulk_callback, priv);
> -
> -		bulk_in_found = true;
> -		break;
> -		}
> -
> -	if (!bulk_in_found) {
> -		dev_err(&priv->udev->dev,
> -			"Error - the proper endpoints were not found!\n");
> -		goto error;
> -	}
>  
>  	usb_set_serial_data(serial, priv);
>  	return 0;
> -
> -error:
> -	usb_free_urb(priv->bulk_read_urb);
> -	kfree(priv->bulk_in_buffer);
> -	kfree(priv);
> -	return retval;
> -}
> -
> -static void opticon_disconnect(struct usb_serial *serial)
> -{
> -	struct opticon_private *priv = usb_get_serial_data(serial);
> -
> -	dbg("%s", __func__);
> -
> -	usb_kill_urb(priv->bulk_read_urb);
> -	usb_free_urb(priv->bulk_read_urb);
>  }
>  
>  static void opticon_release(struct usb_serial *serial)
> @@ -499,44 +204,17 @@ static void opticon_release(struct usb_serial *serial)
>  
>  	dbg("%s", __func__);
>  
> -	kfree(priv->bulk_in_buffer);
>  	kfree(priv);
>  }
>  
> -static int opticon_suspend(struct usb_interface *intf, pm_message_t message)
> -{
> -	struct usb_serial *serial = usb_get_intfdata(intf);
> -	struct opticon_private *priv = usb_get_serial_data(serial);
> -
> -	usb_kill_urb(priv->bulk_read_urb);
> -	return 0;
> -}
> -
> -static int opticon_resume(struct usb_interface *intf)
> -{
> -	struct usb_serial *serial = usb_get_intfdata(intf);
> -	struct opticon_private *priv = usb_get_serial_data(serial);
> -	struct usb_serial_port *port = serial->port[0];
> -	int result;
> -
> -	mutex_lock(&port->port.mutex);
> -	/* This is protected by the port mutex against close/open */
> -	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
> -		result = usb_submit_urb(priv->bulk_read_urb, GFP_NOIO);
> -	else
> -		result = 0;
> -	mutex_unlock(&port->port.mutex);
> -	return result;
> -}
> -
>  static struct usb_driver opticon_driver = {
>  	.name =		"opticon",
>  	.probe =	usb_serial_probe,
>  	.disconnect =	usb_serial_disconnect,
> -	.suspend =	opticon_suspend,
> -	.resume =	opticon_resume,
> +	.suspend =	usb_serial_suspend,
> +	.resume =	usb_serial_resume,
>  	.id_table =	id_table,
> -	.no_dynamic_id = 	1,
> +	.no_dynamic_id =	1,
>  };
>  
>  static struct usb_serial_driver opticon_device = {
> @@ -545,16 +223,15 @@ static struct usb_serial_driver opticon_device = {
>  		.name =		"opticon",
>  	},
>  	.id_table =		id_table,
> -	.usb_driver = 		&opticon_driver,
> +	.usb_driver =		&opticon_driver,
>  	.num_ports =		1,
> -	.attach =		opticon_startup,
> -	.open =			opticon_open,
> -	.close =		opticon_close,
> +	.bulk_out_size =	1024,

This is a fairly large value. Have you made any benchmarking to
determine it? 256b have otherwise proven to be a good trade-off value
for several drivers. (In particular, having a too large buffer size
implied a great penalty on some embedded system I used for
benchmarking.)

> +	.attach =		opticon_attach,
>  	.write =		opticon_write,
> -	.write_room = 		opticon_write_room,
> -	.disconnect =		opticon_disconnect,
> +	.write_room =		opticon_write_room,
> +	.process_read_urb =	opticon_process_read_urb,
>  	.release =		opticon_release,
> -	.throttle = 		opticon_throttle,
> +	.throttle =		opticon_throttle,
>  	.unthrottle =		opticon_unthrottle,
>  	.ioctl =		opticon_ioctl,
>  	.tiocmget =		opticon_tiocmget,

Johan
