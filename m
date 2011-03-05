Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355Ab1CEBUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:20:07 -0500
Received: from kroah.org ([198.145.64.141]:50096 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760072Ab1CEA7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:59:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:34 2011
Message-Id: <20110305005634.918430289@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maciej Szmigiero <mhej@o2.pl>
Subject: [03/73] USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maciej Szmigiero <mhej@o2.pl>

commit acb52cb1613e1d3c8a8c650717cc51965c60d7d4 upstream.

[USB]Add Samsung SGH-I500/Android modem ID switch to visor driver

Samsung decided to reuse USB ID of its old CDMA phone SGH-I500 for the
modem part of some of their Android phones. At least Galaxy Spica
is affected.

This modem needs ACM driver and does not work with visor driver which
binds the conflicting ID for SGH-I500.
Because SGH-I500 is pretty an old hardware its best to add switch to
visor
driver in cause somebody still wants to use that phone with Linux.

Note that this is needed only when using the Android phone as modem,
not in USB storage or ADB mode.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/visor.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/cdc.h>
 #include "visor.h"
 
 /*
@@ -479,6 +480,17 @@ static int visor_probe(struct usb_serial
 
 	dbg("%s", __func__);
 
+	/*
+	 * some Samsung Android phones in modem mode have the same ID
+	 * as SPH-I500, but they are ACM devices, so dont bind to them
+	 */
+	if (id->idVendor == SAMSUNG_VENDOR_ID &&
+		id->idProduct == SAMSUNG_SPH_I500_ID &&
+		serial->dev->descriptor.bDeviceClass == USB_CLASS_COMM &&
+		serial->dev->descriptor.bDeviceSubClass ==
+			USB_CDC_SUBCLASS_ACM)
+		return -ENODEV;
+
 	if (serial->dev->actconfig->desc.bConfigurationValue != 1) {
 		dev_err(&serial->dev->dev, "active config #%d != 1 ??\n",
 			serial->dev->actconfig->desc.bConfigurationValue);


