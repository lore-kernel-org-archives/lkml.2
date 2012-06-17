Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab2FQSgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:36:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50208 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758093Ab2FQSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:38 -0400
Message-Id: <20120617175949.277072292@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 55/69] USB: option: fix memory leak
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit b9c3aab315b51f81649a0d737c4c73783fbd8de0 upstream.

Fix memory leak introduced by commit 383cedc3bb435de7a2 ("USB: serial:
full autosuspend support for the option driver") which allocates
usb-serial data but never frees it.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 9c2f7b2..d12ee2f 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -47,6 +47,7 @@
 /* Function prototypes */
 static int  option_probe(struct usb_serial *serial,
 			const struct usb_device_id *id);
+static void option_release(struct usb_serial *serial);
 static int option_send_setup(struct usb_serial_port *port);
 static void option_instat_callback(struct urb *urb);
 
@@ -1251,7 +1252,7 @@ static struct usb_serial_driver option_1port_device = {
 	.ioctl             = usb_wwan_ioctl,
 	.attach            = usb_wwan_startup,
 	.disconnect        = usb_wwan_disconnect,
-	.release           = usb_wwan_release,
+	.release           = option_release,
 	.read_int_callback = option_instat_callback,
 #ifdef CONFIG_PM
 	.suspend           = usb_wwan_suspend,
@@ -1333,6 +1334,15 @@ static int option_probe(struct usb_serial *serial,
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


