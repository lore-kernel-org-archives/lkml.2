Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2FTS0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:26:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab2FTSYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:53 -0400
Message-Id: <20120620173040.182588665@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>
Subject: [ 07/20] USB: option: fix memory leak
In-Reply-To: <20120620173044.GA6910@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit b9c3aab315b51f81649a0d737c4c73783fbd8de0 upstream.

Fix memory leak introduced by commit 383cedc3bb435de7a2 ("USB: serial:
full autosuspend support for the option driver") which allocates
usb-serial data but never frees it.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -47,6 +47,7 @@
 /* Function prototypes */
 static int  option_probe(struct usb_serial *serial,
 			const struct usb_device_id *id);
+static void option_release(struct usb_serial *serial);
 static int option_send_setup(struct usb_serial_port *port);
 static void option_instat_callback(struct urb *urb);
 
@@ -1273,7 +1274,7 @@ static struct usb_serial_driver option_1
 	.ioctl             = usb_wwan_ioctl,
 	.attach            = usb_wwan_startup,
 	.disconnect        = usb_wwan_disconnect,
-	.release           = usb_wwan_release,
+	.release           = option_release,
 	.read_int_callback = option_instat_callback,
 #ifdef CONFIG_PM
 	.suspend           = usb_wwan_suspend,
@@ -1409,6 +1410,15 @@ static int option_probe(struct usb_seria
 	return 0;
 }
 
+static void option_release(struct usb_serial *serial)
+{
+	struct usb_wwan_intf_private *priv = usb_get_serial_data(serial);
+
+	usb_wwan_release(serial);
+
+	kfree(priv);
+}
+
 static void option_instat_callback(struct urb *urb)
 {
 	int err;


