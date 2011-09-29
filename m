Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1I3BVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:21:32 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40234
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751961Ab1I3BVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:21:30 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 08/24] Staging: hv: mousevsc: Cleanup and properly implement reportdesc_callback()
Date: Thu, 29 Sep 2011 11:54:48 -0700
Message-Id: <1317322504-9788-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup and properly implement reportdesc_callback(); properly allocate the 
hid_device and properly initialize the hid device structure.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   56 +++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index ea9e1f3..8d94aef 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -646,56 +646,45 @@ static void mousevsc_hid_close(struct hid_device *hid)
 {
 }
 
+static struct hid_ll_driver mousevsc_ll_driver = {
+	.open = mousevsc_hid_open,
+	.close = mousevsc_hid_close,
+};
+
+static struct hid_driver mousevsc_hid_driver;
+
 static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
 {
 	struct hid_device *hid_dev;
 	struct mousevsc_dev *input_device = hv_get_drvdata(dev);
 
-	/* hid_debug = -1; */
-	hid_dev = kmalloc(sizeof(struct hid_device), GFP_KERNEL);
+	hid_dev = hid_allocate_device();
+	if (IS_ERR(hid_dev))
+		return;
+
+	hid_dev->ll_driver = &mousevsc_ll_driver;
+	hid_dev->driver = &mousevsc_hid_driver;
 
 	if (hid_parse_report(hid_dev, packet, len)) {
 		DPRINT_INFO(INPUTVSC_DRV, "Unable to call hd_parse_report");
 		return;
 	}
 
-	if (hid_dev) {
-		DPRINT_INFO(INPUTVSC_DRV, "hid_device created");
-
-		hid_dev->ll_driver->open  = mousevsc_hid_open;
-		hid_dev->ll_driver->close = mousevsc_hid_close;
+	hid_dev->bus = BUS_VIRTUAL;
+	hid_dev->vendor = input_device->hid_dev_info.vendor;
+	hid_dev->product = input_device->hid_dev_info.product;
+	hid_dev->version = input_device->hid_dev_info.version;
 
-		hid_dev->bus = BUS_VIRTUAL;
-		hid_dev->vendor = input_device->hid_dev_info.vendor;
-		hid_dev->product = input_device->hid_dev_info.product;
-		hid_dev->version = input_device->hid_dev_info.version;
-		hid_dev->dev = dev->device;
+	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
 
-		sprintf(hid_dev->name, "%s",
-			"Microsoft Vmbus HID-compliant Mouse");
+	if (!hidinput_connect(hid_dev, 0)) {
+		hid_dev->claimed |= HID_CLAIMED_INPUT;
 
-		/*
-		 * HJ Do we want to call it with a 0
-		 */
-		if (!hidinput_connect(hid_dev, 0)) {
-			hid_dev->claimed |= HID_CLAIMED_INPUT;
-
-			input_device->connected = 1;
-
-			DPRINT_INFO(INPUTVSC_DRV,
-				     "HID device claimed by input\n");
-		}
-
-		if (!hid_dev->claimed) {
-			DPRINT_ERR(INPUTVSC_DRV,
-				    "HID device not claimed by "
-				    "input or hiddev\n");
-		}
+		input_device->connected = 1;
 
-		input_device->hid_device = hid_dev;
 	}
 
-	kfree(hid_dev);
+	input_device->hid_device = hid_dev;
 }
 
 static int mousevsc_on_device_add(struct hv_device *device,
@@ -825,6 +814,7 @@ static int mousevsc_remove(struct hv_device *dev)
 	if (input_dev->connected) {
 		hidinput_disconnect(input_dev->hid_device);
 		input_dev->connected = 0;
+		hid_destroy_device(input_dev->hid_device);
 	}
 
 	/*
-- 
1.7.4.1

