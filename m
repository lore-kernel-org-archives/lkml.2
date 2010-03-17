Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0CQJJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:09:09 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:36802 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0CQJJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hKjnD/uV3jDOsZYQ6B1Ut2iVPbkzxZSNEbfTfxe0uJwAyReWh6bNCxFVvWAzGh+eTo
         t/dMUmywJ1VYrLi7QSoJdctF0HEsZKKKwd0sPVDcPjtZMjhpgpmkZq0QfSrL1E/0cgNV
         gqkG/qYtDOPrEOv3UnR425hu++Jx08mXgvjh0=
Date: Wed, 17 Mar 2010 10:08:58 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 4/5] usb-hcd,usb-console: poll hcd device to force usb
 console writes
Message-ID: <20100317090858.GB18570@localhost>
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-2-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-3-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-4-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-5-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268773546-12457-5-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 16, 2010 at 04:05:45PM -0500, Jason Wessel wrote:
> This patch tries to solve the problem that data is lost because there
> are too many outstanding transmit urb's while trying to execute
> printk's to a console.  The same is true if you try something like
> "echo t > /proc/sysrq-trigger".
> 
> This patch takes the route of forcibly polling the hcd device to drain
> the urb queue in order to initiate the bulk write call backs.  This
> only happens if the device is a usb serial console device that sets
> the max_in_flight_urbs to a non zero value in the serial device
> structure.

Why do you need to use max_in_flight_urbs for this? Shouldn't any usb
serial device be able to use the polling mode? 

Currently the parameter is only used by usb_debug to limit the number of
outstanding urbs for the generic multi-urb write implementation. But now
you're adding a second meaning to the variable and use it as a flag
when you set it to -1 for pl2303 (which uses a fifo-implementation) or
URB_UPPER_LIMIT for ftdi_sio (you could simply have used -1 here as
well). If there are drivers that definitely should not use the polling
mode, it seems to me a new flag such as console_poll (or
no_console_poll) would be more appropriate.

That is, either always poll if a console or if necessary poll only if
serial->type->console_poll is set (or no_console_poll isn't).


There are a few more comments below.


> A few millisecond penalty will get incurred to allow the hcd controller
> to complete a write urb, else the console data is thrown away.
> 
> The max_in_flight_urbs was reduced in the usb_debug driver because it
> is highly desired to push things out to the console in a timely
> fashion and there is no need to have a queue that large for the
> interrupt driven mode of operation when used through the tty
> interface.
> 
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Alan Cox <alan@linux.intel.com>
> CC: Alan Stern <stern@rowland.harvard.edu>
> CC: Oliver Neukum <oliver@neukum.org>
> CC: linux-usb@vger.kernel.org
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  drivers/usb/core/hcd.c         |   10 +++++++++
>  drivers/usb/serial/console.c   |   42 +++++++++++++++++++++++++--------------
>  drivers/usb/serial/ftdi_sio.c  |    7 +++--
>  drivers/usb/serial/pl2303.c    |    6 +++-
>  drivers/usb/serial/usb_debug.c |    2 +-
>  include/linux/usb.h            |    3 ++
>  6 files changed, 49 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 2f8cedd..dd710d7 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2271,6 +2271,16 @@ usb_hcd_platform_shutdown(struct platform_device* dev)
>  }
>  EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
>  
> +void
> +usb_poll_irq(struct usb_device *udev)
> +{
> +	struct usb_hcd *hcd;
> +
> +	hcd = bus_to_hcd(udev->bus);
> +	usb_hcd_irq(0, hcd);
> +}
> +EXPORT_SYMBOL_GPL(usb_poll_irq);
> +
>  /*-------------------------------------------------------------------------*/
>  
>  #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
> diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
> index 1ee6b2a..b6b96ff 100644
> --- a/drivers/usb/serial/console.c
> +++ b/drivers/usb/serial/console.c
> @@ -197,13 +197,37 @@ static int usb_console_setup(struct console *co, char *options)
>  	return retval;
>  }
>  
> +static void usb_do_console_write(struct usb_serial *serial,
> +				 struct usb_serial_port *port,
> +				 const char *buf, unsigned count)
> +{
> +	int retval;
> +	int loops = 100;
> +try_again:
> +	/* pass on to the driver specific version of this function if
> +	   it is available */
> +	if (serial->type->write)
> +		retval = serial->type->write(NULL, port, buf, count);
> +	else
> +		retval = usb_serial_generic_write(NULL, port, buf, count);
> +	if (retval < count && retval >= 0 &&
> +	    serial->type->max_in_flight_urbs != 0 && loops--) {
> +		/* poll the hcd device because the queue is full */
> +		count -= retval;
> +		buf += retval;
> +		udelay(100);
> +		usb_poll_irq(serial->dev);
> +		goto try_again;
> +	}
> +	dbg("%s - return value : %d", __func__, retval);
> +}
> +
>  static void usb_console_write(struct console *co,
>  					const char *buf, unsigned count)
>  {
>  	static struct usbcons_info *info = &usbcons_info;
>  	struct usb_serial_port *port = info->port;
>  	struct usb_serial *serial;
> -	int retval = -ENODEV;
>  
>  	if (!port || port->serial->dev->state == USB_STATE_NOTATTACHED)
>  		return;
> @@ -230,23 +254,11 @@ static void usb_console_write(struct console *co,
>  				break;
>  			}
>  		}
> -		/* pass on to the driver specific version of this function if
> -		   it is available */
> -		if (serial->type->write)
> -			retval = serial->type->write(NULL, port, buf, i);
> -		else
> -			retval = usb_serial_generic_write(NULL, port, buf, i);
> -		dbg("%s - return value : %d", __func__, retval);
> +		usb_do_console_write(serial, port, buf, i);
>  		if (lf) {
>  			/* append CR after LF */
>  			unsigned char cr = 13;
> -			if (serial->type->write)
> -				retval = serial->type->write(NULL,
> -								port, &cr, 1);
> -			else
> -				retval = usb_serial_generic_write(NULL,
> -								port, &cr, 1);
> -			dbg("%s - return value : %d", __func__, retval);
> +			usb_do_console_write(serial, port, &cr, 1);
>  		}
>  		buf += i;
>  		count -= i;
> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> index 95ec748..c7f559c 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -53,6 +53,9 @@
>  #define DRIVER_AUTHOR "Greg Kroah-Hartman <greg@kroah.com>, Bill Ryder <bryder@sgi.com>, Kuba Ober <kuba@mareimbrium.org>, Andreas Mohr"
>  #define DRIVER_DESC "USB FTDI Serial Converters Driver"
>  
> +/* number of outstanding urbs to prevent userspace DoS from happening */
> +#define URB_UPPER_LIMIT	42
> +
>  static int debug;
>  static __u16 vendor = FTDI_VID;
>  static __u16 product;
> @@ -838,6 +841,7 @@ static struct usb_serial_driver ftdi_sio_device = {
>  	.ioctl =		ftdi_ioctl,
>  	.set_termios =		ftdi_set_termios,
>  	.break_ctl =		ftdi_break_ctl,
> +	.max_in_flight_urbs =	URB_UPPER_LIMIT,

Here max_in_flight_urbs is simply used as a flag (could have used -1
here as well).

>  };
>  
>  
> @@ -848,9 +852,6 @@ static struct usb_serial_driver ftdi_sio_device = {
>  #define HIGH 1
>  #define LOW 0
>  
> -/* number of outstanding urbs to prevent userspace DoS from happening */
> -#define URB_UPPER_LIMIT	42
> -
>  /*
>   * ***************************************************************************
>   * Utility functions
> diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
> index 1891cfb..2615fe1 100644
> --- a/drivers/usb/serial/pl2303.c
> +++ b/drivers/usb/serial/pl2303.c
> @@ -453,8 +453,9 @@ static void pl2303_send(struct usb_serial_port *port)
>  	port->write_urb->transfer_buffer_length = count;
>  	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
>  	if (result) {
> -		dev_err(&port->dev, "%s - failed submitting write urb,"
> -			" error %d\n", __func__, result);
> +		if (!(port->port.console))
> +			dev_err(&port->dev, "%s - failed submitting write urb,"
> +				" error %d\n", __func__, result);

Why do you treat pl2303 different from all other drivers (including
ftdi_sio and usb_debug) which all report error when submitting an urb
failed? Is this crucial to not get locked up in some recursion?

>  		priv->write_urb_in_use = 0;
>  		/* TODO: reschedule pl2303_send */
>  	}
> @@ -1185,6 +1186,7 @@ static struct usb_serial_driver pl2303_device = {
>  	.chars_in_buffer =	pl2303_chars_in_buffer,
>  	.attach =		pl2303_startup,
>  	.release =		pl2303_release,
> +	.max_in_flight_urbs =	-1,
>  };

Here max_in_flight_urbs is again used as a flag in a way that is
unrelated to its original meaning as pl2303 does not uses the generic
multi-urb writes but rather a custom fifo and a single urb.

>  static int __init pl2303_init(void)
> diff --git a/drivers/usb/serial/usb_debug.c b/drivers/usb/serial/usb_debug.c
> index 252cc2d..4a04552 100644
> --- a/drivers/usb/serial/usb_debug.c
> +++ b/drivers/usb/serial/usb_debug.c
> @@ -15,7 +15,7 @@
>  #include <linux/usb.h>
>  #include <linux/usb/serial.h>
>  
> -#define URB_DEBUG_MAX_IN_FLIGHT_URBS	4000
> +#define URB_DEBUG_MAX_IN_FLIGHT_URBS	42
>  #define USB_DEBUG_MAX_PACKET_SIZE	8
>  #define USB_DEBUG_BRK_SIZE		8
>  static char USB_DEBUG_BRK[USB_DEBUG_BRK_SIZE] = {
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 8c9f053..a7d6cf7 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -569,6 +569,9 @@ static inline void usb_mark_last_busy(struct usb_device *udev)
>  
>  /*-------------------------------------------------------------------------*/
>  
> +/* for polling the hcd device */
> +extern void usb_poll_irq(struct usb_device *udev);
> +
>  /* for drivers using iso endpoints */
>  extern int usb_get_current_frame_number(struct usb_device *usb_dev);

Regards,
Johan

