Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0KETGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:06:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:46571 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab0KETFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:05:40 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: stern@rowland.harvard.edu
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [RFC PATCH 2/5] usb-serial-console: try to poll the hcd vs dropping data
Date: Fri,  5 Nov 2010 14:05:03 -0500
Message-Id: <1288983906-31129-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288983906-31129-2-git-send-email-jason.wessel@windriver.com>
References: <1288983906-31129-1-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Nov 2010 19:05:16.0651 (UTC) FILETIME=[61F9D3B0:01CB7D1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to solve the problem that printk data is dropped
because there are too many outstanding transmit urb's while trying to
execute printk's to a console.  You can observe this by booting a
kernel with a serial console and cross checking the dmesg output with
what you received on the console or doing something like
"echo t > /proc/sysrq-trigger".

This patch takes the route of forcibly polling the hcd device to drain
the urb queue in order to initiate the bulk write call backs.

A few millisecond penalty will get incurred to allow the hcd
controller to complete a write urb, else the console data is thrown
away.  Even with any kind of delay, the latency is still lower than
using a traditional serial port uart due to the fact that there are
bigger buffer for use with the USB serial console kfifo
implementation.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/serial/console.c |   42 +++++++++++++++++++++++++++---------------
 1 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 1ee6b2a..b09832f 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -197,13 +197,37 @@ static int usb_console_setup(struct console *co, char *options)
 	return retval;
 }
 
+static void usb_do_console_write(struct usb_serial *serial,
+				 struct usb_serial_port *port,
+				 const char *buf, unsigned count)
+{
+	int retval;
+	int loops = 100;
+try_again:
+	/* pass on to the driver specific version of this function if
+	   it is available */
+	if (serial->type->write)
+		retval = serial->type->write(NULL, port, buf, count);
+	else
+		retval = usb_serial_generic_write(NULL, port, buf, count);
+	if (retval < count && retval >= 0 && loops--) {
+		/* poll the hcd device because the queue is full */
+		count -= retval;
+		buf += retval;
+		udelay(100);
+		usb_poll_irq(serial->dev);
+		usb_poll_irq_schedule_flush();
+		goto try_again;
+	}
+	dbg("%s - return value : %d", __func__, retval);
+}
+
 static void usb_console_write(struct console *co,
 					const char *buf, unsigned count)
 {
 	static struct usbcons_info *info = &usbcons_info;
 	struct usb_serial_port *port = info->port;
 	struct usb_serial *serial;
-	int retval = -ENODEV;
 
 	if (!port || port->serial->dev->state == USB_STATE_NOTATTACHED)
 		return;
@@ -230,23 +254,11 @@ static void usb_console_write(struct console *co,
 				break;
 			}
 		}
-		/* pass on to the driver specific version of this function if
-		   it is available */
-		if (serial->type->write)
-			retval = serial->type->write(NULL, port, buf, i);
-		else
-			retval = usb_serial_generic_write(NULL, port, buf, i);
-		dbg("%s - return value : %d", __func__, retval);
+		usb_do_console_write(serial, port, buf, i);
 		if (lf) {
 			/* append CR after LF */
 			unsigned char cr = 13;
-			if (serial->type->write)
-				retval = serial->type->write(NULL,
-								port, &cr, 1);
-			else
-				retval = usb_serial_generic_write(NULL,
-								port, &cr, 1);
-			dbg("%s - return value : %d", __func__, retval);
+			usb_do_console_write(serial, port, &cr, 1);
 		}
 		buf += i;
 		count -= i;
-- 
1.6.3.3

