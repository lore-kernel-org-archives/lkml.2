Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1BETEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:04:30 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:59640 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab1BETE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:04:29 -0500
X-Greylist: delayed 4678 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Feb 2011 14:04:28 EST
Message-ID: <4D4D9F37.4010201@o2.pl>
Date: Sat, 05 Feb 2011 20:04:23 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101204 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [USB]Add Samsung SGH-I500/Android modem ID switch to visor driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 69
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[USB]Add Samsung SGH-I500/Android modem ID switch to visor driver

Samsung decided to reuse USB ID of its old CDMA phone SGH-I500 for the
modem part of some of their Android phones. At least Galaxy Spica
is affected.

This modem needs ACM driver and does not work with visor driver which
binds the conflicting ID for SGH-I500.
Because SGH-I500 is pretty an old hardware its best to add switch to visor
driver in cause somebody still wants to use that phone with Linux.

Note that this is needed only when using the Android phone as modem,
not in USB storage or ADB mode.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 15a5d89..5e56ab3 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -52,6 +52,7 @@ static int palm_os_4_probe(struct usb_serial *serial,
 
 /* Parameters that may be passed into the module. */
 static int debug;
+static int enable_i500;
 static __u16 vendor;
 static __u16 product;
 
@@ -479,6 +480,10 @@ static int visor_probe(struct usb_serial *serial,
 
 	dbg("%s", __func__);
 
+	if ((!enable_i500) && (id->idVendor == SAMSUNG_VENDOR_ID) &&
+		(id->idProduct == SAMSUNG_SPH_I500_ID))
+		return -ENODEV;
+
 	if (serial->dev->actconfig->desc.bConfigurationValue != 1) {
 		dev_err(&serial->dev->dev, "active config #%d != 1 ??\n",
 			serial->dev->actconfig->desc.bConfigurationValue);
@@ -718,6 +723,11 @@ MODULE_LICENSE("GPL");
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug enabled or not");
 
+module_param(enable_i500, bool, S_IRUGO);
+MODULE_PARM_DESC(enable_i500, "Enable support for Samsung SPH-I500. "
+				"Causes USBID conflict with modem in Samsung "
+				"Android phones");
+
 module_param(vendor, ushort, 0);
 MODULE_PARM_DESC(vendor, "User specified vendor ID");
 module_param(product, ushort, 0);


