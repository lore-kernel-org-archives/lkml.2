Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab2EBUEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:04:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab2EBUEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:04:36 -0400
Date: Wed, 2 May 2012 13:04:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Preston Fick <pffick@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com
Subject: Re: [PATCH 2/3] usb: cp210x: Added in support to get and store part
 number
Message-ID: <20120502200430.GB25915@kroah.com>
References: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
 <1335845210-5147-2-git-send-email-preston.fick@silabs.com>
 <4FA00C49.7000105@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA00C49.7000105@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 08:16:09PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 01-05-2012 8:06, Preston Fick wrote:
> 
> >This change gets the part number of the device when the driver is loaded and
> >stores it in the private portion of the port structure. This addition will
> >allow for part specific functionality to be added to the driver if needed.
> 
> >Signed-off-by: Preston Fick<preston.fick@silabs.com>
> >---
> >  drivers/usb/serial/cp210x.c |   24 ++++++++++++++++++++++++
> >  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> >diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> >index e67ccf3..b3646b8 100644
> >--- a/drivers/usb/serial/cp210x.c
> >+++ b/drivers/usb/serial/cp210x.c
> [...]
> >@@ -862,6 +874,7 @@ static int cp210x_startup(struct usb_serial *serial)
> >  {
> >  	struct cp210x_port_private *port_priv;
> >  	int i;
> >+	unsigned int partNum;
> >
> >  	/* cp210x buffers behave strangely unless device is reset */
> >  	usb_reset_device(serial->dev);
> >@@ -876,6 +889,17 @@ static int cp210x_startup(struct usb_serial *serial)
> >  		    serial->interface->cur_altsetting->desc.bInterfaceNumber;
> >
> >  		usb_set_serial_port_data(serial->port[i], port_priv);
> >+
> >+		/* Get the 1-byte part number of the cp210x device */
> >+		usb_control_msg(serial->dev,
> 
>    This may involve DMA...
> 
> >+			usb_rcvctrlpipe(serial->dev, 0),
> >+			CP210X_VENDOR_SPECIFIC,
> >+			REQTYPE_DEVICE_TO_HOST,
> >+			CP210X_GET_PARTNUM,
> >+			port_priv->bInterfaceNumber,
> >+			&partNum, 1,
> 
>    You can't do DMA to a buffer situated on stack. You should
> kmalloc() the buffer.

You "must" kmalloc() the buffer, otherwise the driver will break on some
systems.

Sorry, I can't accept this patch because of this.  Please redo it.

greg k-h
