Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab1I2ScU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:32:20 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35708
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754076Ab1I2ScR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:17 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 02/24] Staging: hv: mousevsc: Get rid of the struct input_device_context
Date: Thu, 29 Sep 2011 11:54:42 -0700
Message-Id: <1317322504-9788-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The state maintained in struct input_device_context can easily be included
in the struct mousevsc_dev structure. Simplify the code by consolidating
the state.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   51 ++++++++++------------------------------
 1 files changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 44a2b23..69eb00e 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -172,15 +172,11 @@ struct mousevsc_dev {
 	unsigned char		*report_desc;
 	u32			report_desc_size;
 	struct hv_input_dev_info hid_dev_info;
-};
-
-struct input_device_context {
-	struct hv_device	*device_ctx;
-	struct hid_device	*hid_device;
-	struct hv_input_dev_info device_info;
 	int			connected;
+	struct hid_device       *hid_device;
 };
 
+
 static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *input_dev;
@@ -402,7 +398,6 @@ static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
 				struct synthhid_input_report *input_report)
 {
 	struct hv_driver *input_drv;
-	struct input_device_context *input_dev_ctx;
 
 	if (!input_device->init_complete) {
 		pr_info("Initialization incomplete...ignoring input_report msg");
@@ -411,9 +406,8 @@ static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
 
 	input_drv = drv_to_hv_drv(input_device->device->device.driver);
 
-	input_dev_ctx = dev_get_drvdata(&input_device->device->device);
 
-	hid_input_report(input_dev_ctx->hid_device,
+	hid_input_report(input_device->hid_device,
 			      HID_INPUT_REPORT, input_report->buffer, input_report->header.size, 1);
 
 }
@@ -662,9 +656,8 @@ static void mousevsc_hid_close(struct hid_device *hid)
 
 static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
 {
-	struct input_device_context *input_device_ctx =
-		dev_get_drvdata(&dev->device);
 	struct hid_device *hid_dev;
+	struct mousevsc_dev *input_device = hv_get_drvdata(dev);
 
 	/* hid_debug = -1; */
 	hid_dev = kmalloc(sizeof(struct hid_device), GFP_KERNEL);
@@ -681,9 +674,9 @@ static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
 		hid_dev->ll_driver->close = mousevsc_hid_close;
 
 		hid_dev->bus = BUS_VIRTUAL;
-		hid_dev->vendor = input_device_ctx->device_info.vendor;
-		hid_dev->product = input_device_ctx->device_info.product;
-		hid_dev->version = input_device_ctx->device_info.version;
+		hid_dev->vendor = input_device->hid_dev_info.vendor;
+		hid_dev->product = input_device->hid_dev_info.product;
+		hid_dev->version = input_device->hid_dev_info.version;
 		hid_dev->dev = dev->device;
 
 		sprintf(hid_dev->name, "%s",
@@ -695,7 +688,7 @@ static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
 		if (!hidinput_connect(hid_dev, 0)) {
 			hid_dev->claimed |= HID_CLAIMED_INPUT;
 
-			input_device_ctx->connected = 1;
+			input_device->connected = 1;
 
 			DPRINT_INFO(INPUTVSC_DRV,
 				     "HID device claimed by input\n");
@@ -707,7 +700,7 @@ static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
 				    "input or hiddev\n");
 		}
 
-		input_device_ctx->hid_device = hid_dev;
+		input_device->hid_device = hid_dev;
 	}
 
 	kfree(hid_dev);
@@ -719,8 +712,6 @@ static int mousevsc_on_device_add(struct hv_device *device,
 	int ret = 0;
 	struct mousevsc_dev *input_dev;
 	struct hv_driver *input_drv;
-	struct hv_input_dev_info dev_info;
-	struct input_device_context *input_device_ctx;
 
 	input_dev = alloc_input_device(device);
 
@@ -761,14 +752,7 @@ static int mousevsc_on_device_add(struct hv_device *device,
 
 	input_drv = drv_to_hv_drv(input_dev->device->device.driver);
 
-	dev_info.vendor = input_dev->hid_dev_info.vendor;
-	dev_info.product = input_dev->hid_dev_info.product;
-	dev_info.version = input_dev->hid_dev_info.version;
 
-	/* Send the device info back up */
-	input_device_ctx = dev_get_drvdata(&device->device);
-	memcpy(&input_device_ctx->device_info, &dev_info,
-	       sizeof(struct hv_input_dev_info));
 
 	/* Send the report desc back up */
 	/* workaround SA-167 */
@@ -828,12 +812,6 @@ static int mousevsc_probe(struct hv_device *dev,
 {
 	int ret = 0;
 
-	struct input_device_context *input_dev_ctx;
-
-	input_dev_ctx = kmalloc(sizeof(struct input_device_context),
-				GFP_KERNEL);
-
-	dev_set_drvdata(&dev->device, input_dev_ctx);
 
 	/* Call to the vsc driver to add the device */
 	ret = mousevsc_on_device_add(dev, NULL);
@@ -849,13 +827,12 @@ static int mousevsc_probe(struct hv_device *dev,
 
 static int mousevsc_remove(struct hv_device *dev)
 {
-	struct input_device_context *input_dev_ctx;
+	struct mousevsc_dev *input_dev = hv_get_drvdata(dev);
 	int ret;
 
-	input_dev_ctx = dev_get_drvdata(&dev->device);
-	if (input_dev_ctx->connected) {
-		hidinput_disconnect(input_dev_ctx->hid_device);
-		input_dev_ctx->connected = 0;
+	if (input_dev->connected) {
+		hidinput_disconnect(input_dev->hid_device);
+		input_dev->connected = 0;
 	}
 
 	/*
@@ -868,8 +845,6 @@ static int mousevsc_remove(struct hv_device *dev)
 			   "unable to remove vsc device (ret %d)", ret);
 	}
 
-	kfree(input_dev_ctx);
-
 	return ret;
 }
 
-- 
1.7.4.1

