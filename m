Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab2JDVQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:16:49 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44231 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab2JDVQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:16:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michal Nazarewicz <mina86@mina86.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 02/56] usb: gadget: initialize the strings in tcm_usb_gadget properly
Date: Thu,  4 Oct 2012 14:15:23 -0700
Message-Id: <20121004211152.383235155@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 18786da4853017d983ff6911648543ca617c12d1 upstream.

I have no idea what I've been thinking while I was doing this in the first
place. Now the strings are initialized properly and reported by lsusb.

Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/tcm_usb_gadget.c |   33 ++++++++++++++++++++-------------
 drivers/usb/gadget/tcm_usb_gadget.h |   14 ++++++++------
 2 files changed, 28 insertions(+), 19 deletions(-)

--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1977,7 +1977,6 @@ static struct usb_interface_descriptor b
 	.bInterfaceClass =      USB_CLASS_MASS_STORAGE,
 	.bInterfaceSubClass =   USB_SC_SCSI,
 	.bInterfaceProtocol =   USB_PR_BULK,
-	.iInterface =           USB_G_STR_INT_UAS,
 };
 
 static struct usb_interface_descriptor uasp_intf_desc = {
@@ -1988,7 +1987,6 @@ static struct usb_interface_descriptor u
 	.bInterfaceClass =	USB_CLASS_MASS_STORAGE,
 	.bInterfaceSubClass =	USB_SC_SCSI,
 	.bInterfaceProtocol =	USB_PR_UAS,
-	.iInterface =		USB_G_STR_INT_BBB,
 };
 
 static struct usb_endpoint_descriptor uasp_bi_desc = {
@@ -2209,20 +2207,16 @@ static struct usb_device_descriptor usbg
 	.bDeviceClass =		USB_CLASS_PER_INTERFACE,
 	.idVendor =		cpu_to_le16(UAS_VENDOR_ID),
 	.idProduct =		cpu_to_le16(UAS_PRODUCT_ID),
-	.iManufacturer =	USB_G_STR_MANUFACTOR,
-	.iProduct =		USB_G_STR_PRODUCT,
-	.iSerialNumber =	USB_G_STR_SERIAL,
-
 	.bNumConfigurations =   1,
 };
 
 static struct usb_string	usbg_us_strings[] = {
-	{ USB_G_STR_MANUFACTOR,	"Target Manufactor"},
-	{ USB_G_STR_PRODUCT,	"Target Product"},
-	{ USB_G_STR_SERIAL,	"000000000001"},
-	{ USB_G_STR_CONFIG,	"default config"},
-	{ USB_G_STR_INT_UAS,	"USB Attached SCSI"},
-	{ USB_G_STR_INT_BBB,	"Bulk Only Transport"},
+	[USB_G_STR_MANUFACTOR].s	= "Target Manufactor",
+	[USB_G_STR_PRODUCT].s		= "Target Product",
+	[USB_G_STR_SERIAL].s		= "000000000001",
+	[USB_G_STR_CONFIG].s		= "default config",
+	[USB_G_STR_INT_UAS].s		= "USB Attached SCSI",
+	[USB_G_STR_INT_BBB].s		= "Bulk Only Transport",
 	{ },
 };
 
@@ -2244,7 +2238,6 @@ static int guas_unbind(struct usb_compos
 static struct usb_configuration usbg_config_driver = {
 	.label                  = "Linux Target",
 	.bConfigurationValue    = 1,
-	.iConfiguration		= USB_G_STR_CONFIG,
 	.bmAttributes           = USB_CONFIG_ATT_SELFPOWER,
 };
 
@@ -2417,6 +2410,9 @@ static int usbg_cfg_bind(struct usb_conf
 	fu->function.disable = usbg_disable;
 	fu->tpg = the_only_tpg_I_currently_have;
 
+	bot_intf_desc.iInterface = usbg_us_strings[USB_G_STR_INT_BBB].id;
+	uasp_intf_desc.iInterface = usbg_us_strings[USB_G_STR_INT_UAS].id;
+
 	ret = usb_add_function(c, &fu->function);
 	if (ret)
 		goto err;
@@ -2431,6 +2427,17 @@ static int usb_target_bind(struct usb_co
 {
 	int ret;
 
+	ret = usb_string_ids_tab(cdev, usbg_us_strings);
+	if (ret)
+		return ret;
+
+	usbg_device_desc.iManufacturer =
+		usbg_us_strings[USB_G_STR_MANUFACTOR].id;
+	usbg_device_desc.iProduct = usbg_us_strings[USB_G_STR_PRODUCT].id;
+	usbg_device_desc.iSerialNumber = usbg_us_strings[USB_G_STR_SERIAL].id;
+	usbg_config_driver.iConfiguration =
+		usbg_us_strings[USB_G_STR_CONFIG].id;
+
 	ret = usb_add_config(cdev, &usbg_config_driver,
 			usbg_cfg_bind);
 	return 0;
--- a/drivers/usb/gadget/tcm_usb_gadget.h
+++ b/drivers/usb/gadget/tcm_usb_gadget.h
@@ -16,12 +16,14 @@
 #define UASP_SS_EP_COMP_LOG_STREAMS 4
 #define UASP_SS_EP_COMP_NUM_STREAMS (1 << UASP_SS_EP_COMP_LOG_STREAMS)
 
-#define USB_G_STR_MANUFACTOR    1
-#define USB_G_STR_PRODUCT       2
-#define USB_G_STR_SERIAL        3
-#define USB_G_STR_CONFIG        4
-#define USB_G_STR_INT_UAS       5
-#define USB_G_STR_INT_BBB       6
+enum {
+	USB_G_STR_MANUFACTOR,
+	USB_G_STR_PRODUCT,
+	USB_G_STR_SERIAL,
+	USB_G_STR_CONFIG,
+	USB_G_STR_INT_UAS,
+	USB_G_STR_INT_BBB,
+};
 
 #define USB_G_ALT_INT_BBB       0
 #define USB_G_ALT_INT_UAS       1


