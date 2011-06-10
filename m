Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1FJSXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:23:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757901Ab1FJSXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:23:46 -0400
Date: Fri, 10 Jun 2011 14:23:44 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ping Cheng <pinglinux@gmail.com>
Subject: [PATCH] wacom: use only one interface with DTU-2231
Message-ID: <20110610182344.GB5510@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Wacom DTU-2231 tablet has two interfaces on its default configuration and
both have HID class, leading to the creation of two input devices
instead of one. Only the first one is used, so filter out the second.

index 08ba5ad..41ae3c6 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -15,6 +15,7 @@
 #include "wacom_wac.h"
 #include "wacom.h"
 #include <linux/input/mt.h>
+#include <linux/hid.h>
 
 /* resolution for penabled devices */
 #define WACOM_PL_RES		20
@@ -1483,6 +1484,11 @@ static const struct wacom_features wacom_features_0x6004 =
 	USB_DEVICE(USB_VENDOR_ID_WACOM, prod),			\
 	.driver_info = (kernel_ulong_t)&wacom_features_##prod
 
+#define USB_DEVICE_DETAILED(prod, class, sub, proto)			\
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_WACOM, prod, class, \
+				      sub, proto),			\
+	.driver_info = (kernel_ulong_t)&wacom_features_##prod
+
 #define USB_DEVICE_LENOVO(prod)					\
 	USB_DEVICE(USB_VENDOR_ID_LENOVO, prod),			\
 	.driver_info = (kernel_ulong_t)&wacom_features_##prod
@@ -1545,7 +1551,13 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0xC5) },
 	{ USB_DEVICE_WACOM(0xC6) },
 	{ USB_DEVICE_WACOM(0xC7) },
-	{ USB_DEVICE_WACOM(0xCE) },
+	/*
+	 * DTU-2231 has two interfaces on the same configuration, only one is
+ 	 * used
+ 	 */
+	{ USB_DEVICE_DETAILED(0xCE, USB_CLASS_HID,
+			      USB_INTERFACE_SUBCLASS_BOOT,
+			      USB_INTERFACE_PROTOCOL_MOUSE) },
 	{ USB_DEVICE_WACOM(0xD0) },
 	{ USB_DEVICE_WACOM(0xD1) },
 	{ USB_DEVICE_WACOM(0xD2) },
