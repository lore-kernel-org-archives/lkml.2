Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab1FWSJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:09:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:34606 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416Ab1FWRgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Maciej Szmigiero <mhej@o2.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 121/247] USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
Date: Thu, 23 Jun 2011 13:33:09 -0400
Message-Id: <1308850515-15242-62-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Szmigiero <mhej@o2.pl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/visor.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index fb7fc40..81fa4f9 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/cdc.h>
 #include "visor.h"
 
 /*
@@ -754,6 +755,17 @@ static int visor_probe(struct usb_serial *serial,
 
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
-- 
1.7.4.4

