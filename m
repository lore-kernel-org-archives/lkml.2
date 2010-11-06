Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0KFSj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:39:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58470 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751654Ab0KFSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:39:55 -0400
Date: Sat, 6 Nov 2010 14:39:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [RFC PATCH 2/5] usb-serial-console: try to poll the hcd vs
 dropping data
In-Reply-To: <1288983906-31129-3-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1011061432410.28403-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010, Jason Wessel wrote:

> This patch tries to solve the problem that printk data is dropped
> because there are too many outstanding transmit urb's while trying to
> execute printk's to a console.  You can observe this by booting a
> kernel with a serial console and cross checking the dmesg output with
> what you received on the console or doing something like
> "echo t > /proc/sysrq-trigger".
> 
> This patch takes the route of forcibly polling the hcd device to drain
> the urb queue in order to initiate the bulk write call backs.
> 
> A few millisecond penalty will get incurred to allow the hcd
> controller to complete a write urb, else the console data is thrown
> away.  Even with any kind of delay, the latency is still lower than
> using a traditional serial port uart due to the fact that there are
> bigger buffer for use with the USB serial console kfifo
> implementation.

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
> +	if (retval < count && retval >= 0 && loops--) {
> +		/* poll the hcd device because the queue is full */

In fact you can call the poll routine on every iteration.  Only the 
udelay needs to wait for the queue to be full.

> +		count -= retval;
> +		buf += retval;
> +		udelay(100);
> +		usb_poll_irq(serial->dev);
> +		usb_poll_irq_schedule_flush();

I don't understand this at all.  What's the point of adding the whole
delayed_usb_complete_queue mechanism if you flush the queue as soon as
some URBs are added to it?  Why not just let them complete normally
during the usb_poll_irq call?

I thought the whole idea was that you didn't want extraneous URBs to 
complete while the KDB debugger was running.  This means that you 
shouldn't call usb_poll_irq_schedule_flush until the debugger is ready 
to go back to running the main kernel.

Alan Stern

