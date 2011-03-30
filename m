Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab1C3Vll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:41:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:61791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933565Ab1C3VIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237540"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mhej@o2.pl, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [142/275] USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
Message-Id: <20110330210623.386BC3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/visor.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/visor.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/visor.c	2011-03-29 22:51:10.292459811 -0700
+++ linux-2.6.35.y/drivers/usb/serial/visor.c	2011-03-29 23:03:01.228268742 -0700
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/cdc.h>
 #include "visor.h"
 
 /*
@@ -479,6 +480,17 @@
 
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
