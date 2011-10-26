Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1JZAXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 20:23:31 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:60802
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753344Ab1JZAXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 20:23:30 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        dmitry.torokhov@gmail.com, joe@perches.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 3/6] Staging: hv: mousevsc: Inline the code for reportdesc_callback()
Date: Tue, 25 Oct 2011 17:19:49 -0700
Message-Id: <1319588392-9982-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319588392-9982-1-git-send-email-kys@microsoft.com>
References: <1319588311-9935-1-git-send-email-kys@microsoft.com>
 <1319588392-9982-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline the code for reportdesc_callback() as this function is called from
mousevsc_probe(). As part of this, cleanup the code in reportdesc_callback().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   93 +++++++++++++++++++++++-----------------
 1 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 0a5676c..ed071b8 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -451,54 +451,34 @@ static int mousevsc_hid_open(struct hid_device *hid)
 	return 0;
 }
 
+static int mousevsc_hid_start(struct hid_device *hid)
+{
+	return 0;
+}
+
 static void mousevsc_hid_close(struct hid_device *hid)
 {
 }
 
+static void mousevsc_hid_stop(struct hid_device *hid)
+{
+}
+
 static struct hid_ll_driver mousevsc_ll_driver = {
 	.open = mousevsc_hid_open,
 	.close = mousevsc_hid_close,
+	.start = mousevsc_hid_start,
+	.stop = mousevsc_hid_stop,
 };
 
 static struct hid_driver mousevsc_hid_driver;
 
-static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
-{
-	struct hid_device *hid_dev;
-	struct mousevsc_dev *input_device = hv_get_drvdata(dev);
-
-	hid_dev = hid_allocate_device();
-	if (IS_ERR(hid_dev))
-		return;
-
-	hid_dev->ll_driver = &mousevsc_ll_driver;
-	hid_dev->driver = &mousevsc_hid_driver;
-
-	if (hid_parse_report(hid_dev, packet, len))
-		return;
-
-	hid_dev->bus = BUS_VIRTUAL;
-	hid_dev->vendor = input_device->hid_dev_info.vendor;
-	hid_dev->product = input_device->hid_dev_info.product;
-	hid_dev->version = input_device->hid_dev_info.version;
-
-	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
-
-	if (!hidinput_connect(hid_dev, 0)) {
-		hid_dev->claimed |= HID_CLAIMED_INPUT;
-
-		input_device->connected = true;
-
-	}
-
-	input_device->hid_device = hid_dev;
-}
-
 static int mousevsc_probe(struct hv_device *device,
 			const struct hv_vmbus_device_id *dev_id)
 {
 	int ret = 0;
 	struct mousevsc_dev *input_dev;
+	struct hid_device *hid_dev;
 
 	input_dev = alloc_input_device(device);
 
@@ -524,23 +504,56 @@ static int mousevsc_probe(struct hv_device *device,
 
 	ret = mousevsc_connect_to_vsp(device);
 
-	if (ret != 0) {
-		vmbus_close(device->channel);
-		free_input_device(input_dev);
-		return ret;
-	}
-
+	if (ret != 0)
+		goto probe_err0;
 
 	/* workaround SA-167 */
 	if (input_dev->report_desc[14] == 0x25)
 		input_dev->report_desc[14] = 0x29;
 
-	reportdesc_callback(device, input_dev->report_desc,
-			    input_dev->report_desc_size);
+	hid_dev = hid_allocate_device();
+	if (IS_ERR(hid_dev)) {
+		ret = PTR_ERR(hid_dev);
+		goto probe_err0;
+	}
+
+	hid_dev->ll_driver = &mousevsc_ll_driver;
+	hid_dev->driver = &mousevsc_hid_driver;
+	hid_dev->bus = BUS_VIRTUAL;
+	hid_dev->vendor = input_dev->hid_dev_info.vendor;
+	hid_dev->product = input_dev->hid_dev_info.product;
+	hid_dev->version = input_dev->hid_dev_info.version;
+	input_dev->hid_device = hid_dev;
+
+	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
+
+	ret = hid_parse_report(hid_dev, input_dev->report_desc,
+				input_dev->report_desc_size);
+
+	if (ret) {
+		hid_err(hid_dev, "parse failed\n");
+		goto probe_err1;
+	}
+
+	ret = hid_hw_start(hid_dev, HID_CONNECT_HIDINPUT | HID_CONNECT_HIDDEV);
 
+	if (ret) {
+		hid_err(hid_dev, "hw start failed\n");
+		goto probe_err1;
+	}
+
+	input_dev->connected = true;
 	input_dev->init_complete = true;
 
 	return ret;
+
+probe_err1:
+	hid_destroy_device(hid_dev);
+
+probe_err0:
+	vmbus_close(device->channel);
+	free_input_device(input_dev);
+	return ret;
 }
 
 
-- 
1.7.4.1

