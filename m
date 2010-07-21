Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0GULPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 07:15:47 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:60494 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab0GULPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 07:15:46 -0400
From: "Andrew Bird (Sphere Systems)" <ajb@spheresystems.co.uk>
Organization: Sphere Systems Ltd
To: linux-kernel@vger.kernel.org
Subject: Option.c blacklist not functioning as I expected
Date: Wed, 21 Jul 2010 12:15:40 +0100
User-Agent: KMail/1.13.3 (Linux/2.6.30.10-105.2.23.fc11.x86_64; KDE/4.4.3; x86_64; ; )
Cc: ajb@spheresystems.co.uk
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007211215.42008.ajb@spheresystems.co.uk>
X-Originating-Smarthost03-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,
     I wanted to blacklist a network interface that has class 0xff / subclass 
0xff from the Option usb serial driver for a couple of devices. The reason for 
doing this is I hope to get the usbnet driver running on interface 1. The 
'blacklist_info' in option.c looked like the way to go, but it doesn't seem to 
have the desired effect, I still get interface 1 bound. Interfaces 4 and 5 
aren't bound but I suspect it's because they are storage and not class 0xff.

Please can anyone show me what I'm missing?

Thanks,


Andrew

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e280ad8..f1ab07e 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -145,6 +145,8 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_E143D                   0x143D
 #define HUAWEI_PRODUCT_E143E                   0x143E
 #define HUAWEI_PRODUCT_E143F                   0x143F
+#define HUAWEI_PRODUCT_K4505                   0x1464
+#define HUAWEI_PRODUCT_K3765                   0x1465
 #define HUAWEI_PRODUCT_E14AC                   0x14AC
 
 #define QUANTA_VENDOR_ID                       0x0408
@@ -383,6 +385,14 @@ static const struct option_blacklist_info 
four_g_w14_blacklist = {
        .reason = OPTION_BLACKLIST_SENDSETUP
 };
 
+/* ignore net, cdrom, sdcard interfaces */
+static const u8 huawei_k3765_k4505_reserved_if[] = { 1, 4, 5};
+static const struct option_blacklist_info huawei_k3765_k4505_blacklist = {
+       .infolen = ARRAY_SIZE(huawei_k3765_k4505_reserved_if),
+       .ifaceinfo = huawei_k3765_k4505_reserved_if,
+       .reason = OPTION_BLACKLIST_RESERVED_IF
+};
+
 static const struct usb_device_id option_ids[] = {
        { USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
        { USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -480,6 +490,12 @@ static const struct usb_device_id option_ids[] = {
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 
HUAWEI_PRODUCT_E143D, 0xff, 0xff, 0xff) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 
HUAWEI_PRODUCT_E143E, 0xff, 0xff, 0xff) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 
HUAWEI_PRODUCT_E143F, 0xff, 0xff, 0xff) },
+       { USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505),
+         .driver_info = (kernel_ulong_t)&huawei_k3765_k4505_blacklist
+       },
+       { USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765),
+         .driver_info = (kernel_ulong_t)&huawei_k3765_k4505_blacklist
+       },
        { USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC) },
        { USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
        { USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) 
}, /* Novatel Merlin V640/XV620 */
