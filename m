Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1BEVlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 16:41:35 -0500
Received: from moh2-ve3.go2.pl ([193.17.41.208]:55450 "EHLO moh2-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab1BEVle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 16:41:34 -0500
Message-ID: <4D4DC400.2040302@o2.pl>
Date: Sat, 05 Feb 2011 22:41:20 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101204 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Johan Hovold <jhovold@gmail.com>, Joe Perches <joe@perches.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [USB]Add Samsung SGH-I500/Android modem ID switch to visor driver
References: <4D4D9F37.4010201@o2.pl> <20110205192831.GA334@suse.de>
In-Reply-To: <20110205192831.GA334@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 60
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version of patch which autodetects devices with ACM class.
Tested on Galaxy Spica.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 15a5d89..e1c4527 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/cdc.h>
 #include "visor.h"
 
 /*
@@ -479,6 +480,15 @@ static int visor_probe(struct usb_serial *serial,
 
 	dbg("%s", __func__);
 
+	/* some Samsung Android phones in modem mode have the same ID */
+	/* as SPH-I500, but they are ACM devices, so dont bind to them */
+	if ((id->idVendor == SAMSUNG_VENDOR_ID) &&
+		(id->idProduct == SAMSUNG_SPH_I500_ID) &&
+		(serial->dev->descriptor.bDeviceClass == USB_CLASS_COMM) &&
+		(serial->dev->descriptor.bDeviceSubClass ==
+			USB_CDC_SUBCLASS_ACM))
+		return -ENODEV;
+
 	if (serial->dev->actconfig->desc.bConfigurationValue != 1) {
 		dev_err(&serial->dev->dev, "active config #%d != 1 ??\n",
 			serial->dev->actconfig->desc.bConfigurationValue);

