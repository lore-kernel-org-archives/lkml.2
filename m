Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab0HIPB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:01:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36742 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab0HIPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:01:12 -0400
Date: Mon, 09 Aug 2010 17:02:31 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv7 6/8] USB: gadget: g_multi: moved strings handling code to
 composite
In-reply-to: <e37b282da3898486df3fc33cbb1de5e1b6bc26c3.1281365237.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <dadbebba90720630077702d19240acca9fdb2182.1281365237.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1281365237.git.m.nazarewicz@samsung.com>
 <49ebe5a39e05aa55a19d33a2141736d215873f86.1281365237.git.m.nazarewicz@samsung.com>
 <b4fe56570ecb77ec6acbab4502f7ad87b72885e1.1281365237.git.m.nazarewicz@samsung.com>
 <9219d2c4e7b60f2ad1455b6c702604e84ef90e1b.1281365237.git.m.nazarewicz@samsung.com>
 <fd2e70a236743436c0c2e88eb3b32e4564571e32.1281365237.git.m.nazarewicz@samsung.com>
 <e37b282da3898486df3fc33cbb1de5e1b6bc26c3.1281365237.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some of the string registration from the
Multifunction Composite Gadget as composite layer can handle
the iManufacturer and iProduct for us.

This also adds the "needs_serial" so that composite layer will
issue a warning if user space fails to provide the iSerialNumber
module parameter.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/multi.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 36d67a3..ca51661 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -121,8 +121,6 @@ static const struct usb_descriptor_header *otg_desc[] = {
 
 
 enum {
-	MULTI_STRING_MANUFACTURER_IDX,
-	MULTI_STRING_PRODUCT_IDX,
 #ifdef CONFIG_USB_G_MULTI_RNDIS
 	MULTI_STRING_RNDIS_CONFIG_IDX,
 #endif
@@ -131,11 +129,7 @@ enum {
 #endif
 };
 
-static char manufacturer[50];
-
 static struct usb_string strings_dev[] = {
-	[MULTI_STRING_MANUFACTURER_IDX].s = manufacturer,
-	[MULTI_STRING_PRODUCT_IDX].s      = DRIVER_DESC,
 #ifdef CONFIG_USB_G_MULTI_RNDIS
 	[MULTI_STRING_RNDIS_CONFIG_IDX].s = "Multifunction with RNDIS",
 #endif
@@ -314,20 +308,11 @@ static int __ref multi_bind(struct usb_composite_dev *cdev)
 		device_desc.bcdDevice = cpu_to_le16(0x0300 | 0x0099);
 	}
 
-	/* allocate string descriptor numbers */
-	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
-	         init_utsname()->sysname, init_utsname()->release,
-	         gadget->name);
-
+	/* allocate string IDs */
 	status = usb_string_ids_tab(cdev, strings_dev);
 	if (unlikely(status < 0))
 		goto fail2;
 
-	device_desc.iManufacturer =
-		strings_dev[MULTI_STRING_MANUFACTURER_IDX].id;
-	device_desc.iProduct      =
-		strings_dev[MULTI_STRING_PRODUCT_IDX].id;
-
 	/* register configurations */
 	status = rndis_config_register(cdev);
 	if (unlikely(status < 0))
@@ -370,6 +355,8 @@ static struct usb_composite_driver multi_driver = {
 	.strings	= dev_strings,
 	.bind		= multi_bind,
 	.unbind		= __exit_p(multi_unbind),
+	.iProduct	= DRIVER_DESC,
+	.needs_serial	= 1,
 };
 
 
-- 
1.7.1

