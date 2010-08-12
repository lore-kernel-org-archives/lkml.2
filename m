Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab0HLPow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:44:52 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36476 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760236Ab0HLPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:42:21 -0400
Date: Thu, 12 Aug 2010 17:43:49 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv8 06/13] USB: gadget: g_multi: moved strings handling code to
 composite
In-reply-to: <4addd8199cfd6a2aa582904cd6efa01bc77a5290.1281625724.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <9737a711d395932c8803511ba581722d46be5292.1281625724.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1281625724.git.m.nazarewicz@samsung.com>
 <76f0f5732bfbbb36d50baf05ecdd12bec3396275.1281625724.git.m.nazarewicz@samsung.com>
 <313ee18ecf53fb8f1c040656b697de869f0c0856.1281625724.git.m.nazarewicz@samsung.com>
 <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com>
 <f2f6babb8b593d5c6f6141604bd647658d59f124.1281625724.git.m.nazarewicz@samsung.com>
 <4addd8199cfd6a2aa582904cd6efa01bc77a5290.1281625724.git.m.nazarewicz@samsung.com>
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

