Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1KIQVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:21:52 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:38159
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752505Ab1KIQVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:21:51 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: mousevsc: Address Dmitry's review comments
Date: Wed,  9 Nov 2011 08:47:19 -0800
Message-Id: <1320857239-1621-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses most of Dimitry's last set of review comments. The comments
that have not been addressed yet are:

A) Making some structures constant and initializing them statically:
The low level ring buffer code uses  struct scatterlists and  for some
reason the behavior of dynamically allocated structures (as well as stack 
variables) is different when it comes to the following transformation:
VA ->Page->VA. For dynamically allocated data structures this transformation
gives us the original VA; while for module global data, this transformation
gives me a different VA. And so, I will not be able to make this change.

B) Dimitry was also concerned about the fact that this driver was using
calls typically made by the higher level hid drivers. This driver combines
the functionality of both a low level driver as well as the upper level hid
driver. Based on Jiri's input, I will address this issue.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   98 +++++++++++++++++------------------------
 1 files changed, 40 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 2c2e1b4..d503cbb 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -160,7 +160,7 @@ struct mousevsc_dev {
 };
 
 
-static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
+static struct mousevsc_dev *mousevsc_alloc_device(struct hv_device *device)
 {
 	struct mousevsc_dev *input_dev;
 
@@ -172,11 +172,12 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 	input_dev->device = device;
 	hv_set_drvdata(device, input_dev);
 	init_completion(&input_dev->wait_event);
+	input_dev->init_complete = false;
 
 	return input_dev;
 }
 
-static void free_input_device(struct mousevsc_dev *device)
+static void mousevsc_free_device(struct mousevsc_dev *device)
 {
 	kfree(device->hid_desc);
 	kfree(device->report_desc);
@@ -184,7 +185,6 @@ static void free_input_device(struct mousevsc_dev *device)
 	kfree(device);
 }
 
-
 static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 				struct synthhid_device_info *device_info)
 {
@@ -192,14 +192,12 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	struct hid_descriptor *desc;
 	struct mousevsc_prt_msg ack;
 
-	/* Assume success for now */
-	input_device->dev_info_status = 0;
-
-	memcpy(&input_device->hid_dev_info, &device_info->hid_dev_info,
-		sizeof(struct hv_input_dev_info));
+	input_device->dev_info_status = -ENOMEM;
 
+	input_device->hid_dev_info = device_info->hid_dev_info;
 	desc = &device_info->hid_descriptor;
-	WARN_ON(desc->bLength == 0);
+	if (desc->bLength == 0)
+		goto cleanup;
 
 	input_device->hid_desc = kzalloc(desc->bLength, GFP_ATOMIC);
 
@@ -209,13 +207,18 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	memcpy(input_device->hid_desc, desc, desc->bLength);
 
 	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
-	if (input_device->report_desc_size == 0)
+	if (input_device->report_desc_size == 0) {
+		input_device->dev_info_status = -EINVAL;
 		goto cleanup;
+	}
+
 	input_device->report_desc = kzalloc(input_device->report_desc_size,
 					  GFP_ATOMIC);
 
-	if (!input_device->report_desc)
+	if (!input_device->report_desc) {
+		input_device->dev_info_status = -ENOMEM;
 		goto cleanup;
+	}
 
 	memcpy(input_device->report_desc,
 	       ((unsigned char *)desc) + desc->bLength,
@@ -238,22 +241,14 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 			(unsigned long)&ack,
 			VM_PKT_DATA_INBAND,
 			VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0)
-		goto cleanup;
 
-	complete(&input_device->wait_event);
-
-	return;
+	if (!ret)
+		input_device->dev_info_status = 0;
 
 cleanup:
-	kfree(input_device->hid_desc);
-	input_device->hid_desc = NULL;
-
-	kfree(input_device->report_desc);
-	input_device->report_desc = NULL;
-
-	input_device->dev_info_status = -1;
 	complete(&input_device->wait_event);
+
+	return;
 }
 
 static void mousevsc_on_receive(struct hv_device *device,
@@ -270,7 +265,7 @@ static void mousevsc_on_receive(struct hv_device *device,
 	if (pipe_msg->type != PIPE_MESSAGE_DATA)
 		return;
 
-	hid_msg = (struct synthhid_msg *)&pipe_msg->data[0];
+	hid_msg = (struct synthhid_msg *)pipe_msg->data;
 
 	switch (hid_msg->header.type) {
 	case SYNTH_HID_PROTOCOL_RESPONSE:
@@ -300,11 +295,11 @@ static void mousevsc_on_receive(struct hv_device *device,
 		 * hid desc and report desc
 		 */
 		mousevsc_on_receive_device_info(input_dev,
-			(struct synthhid_device_info *)&pipe_msg->data[0]);
+			(struct synthhid_device_info *)pipe_msg->data);
 		break;
 	case SYNTH_HID_INPUT_REPORT:
 		input_report =
-			(struct synthhid_input_report *)&pipe_msg->data[0];
+			(struct synthhid_input_report *)pipe_msg->data;
 		if (!input_dev->init_complete)
 			break;
 		hid_input_report(input_dev->hid_device,
@@ -356,9 +351,7 @@ static void mousevsc_on_channel_callback(void *context)
 
 			default:
 				pr_err("unhandled packet type %d, tid %llx len %d\n",
-				   desc->type,
-				   req_id,
-				   bytes_recvd);
+					desc->type, req_id, bytes_recvd);
 				break;
 			}
 
@@ -388,12 +381,10 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	struct mousevsc_prt_msg *response;
 
 	request = &input_dev->protocol_req;
-
 	memset(request, 0, sizeof(struct mousevsc_prt_msg));
 
 	request->type = PIPE_MESSAGE_DATA;
 	request->size = sizeof(struct synthhid_protocol_request);
-
 	request->request.header.type = SYNTH_HID_PROTOCOL_REQUEST;
 	request->request.header.size = sizeof(unsigned int);
 	request->request.version_requested.version = SYNTHHID_INPUT_VERSION;
@@ -433,11 +424,9 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	 * We should have gotten the device attr, hid desc and report
 	 * desc at this point
 	 */
-	if (input_dev->dev_info_status)
-		ret = -ENOMEM;
+	ret = input_dev->dev_info_status;
 
 cleanup:
-
 	return ret;
 }
 
@@ -471,17 +460,15 @@ static struct hid_driver mousevsc_hid_driver;
 static int mousevsc_probe(struct hv_device *device,
 			const struct hv_vmbus_device_id *dev_id)
 {
-	int ret = 0;
+	int ret;
 	struct mousevsc_dev *input_dev;
 	struct hid_device *hid_dev;
 
-	input_dev = alloc_input_device(device);
+	input_dev = mousevsc_alloc_device(device);
 
 	if (!input_dev)
 		return -ENOMEM;
 
-	input_dev->init_complete = false;
-
 	ret = vmbus_open(device->channel,
 		INPUTVSC_SEND_RING_BUFFER_SIZE,
 		INPUTVSC_RECV_RING_BUFFER_SIZE,
@@ -491,15 +478,13 @@ static int mousevsc_probe(struct hv_device *device,
 		device
 		);
 
-	if (ret != 0) {
-		free_input_device(input_dev);
-		return ret;
-	}
+	if (ret)
+		goto probe_err0;
 
 	ret = mousevsc_connect_to_vsp(device);
 
-	if (ret != 0)
-		goto probe_err0;
+	if (ret)
+		goto probe_err1;
 
 	/* workaround SA-167 */
 	if (input_dev->report_desc[14] == 0x25)
@@ -508,7 +493,7 @@ static int mousevsc_probe(struct hv_device *device,
 	hid_dev = hid_allocate_device();
 	if (IS_ERR(hid_dev)) {
 		ret = PTR_ERR(hid_dev);
-		goto probe_err0;
+		goto probe_err1;
 	}
 
 	hid_dev->ll_driver = &mousevsc_ll_driver;
@@ -526,14 +511,14 @@ static int mousevsc_probe(struct hv_device *device,
 
 	if (ret) {
 		hid_err(hid_dev, "parse failed\n");
-		goto probe_err1;
+		goto probe_err2;
 	}
 
 	ret = hid_hw_start(hid_dev, HID_CONNECT_HIDINPUT | HID_CONNECT_HIDDEV);
 
 	if (ret) {
 		hid_err(hid_dev, "hw start failed\n");
-		goto probe_err1;
+		goto probe_err2;
 	}
 
 	input_dev->connected = true;
@@ -541,12 +526,15 @@ static int mousevsc_probe(struct hv_device *device,
 
 	return ret;
 
-probe_err1:
+probe_err2:
 	hid_destroy_device(hid_dev);
 
-probe_err0:
+probe_err1:
 	vmbus_close(device->channel);
-	free_input_device(input_dev);
+
+probe_err0:
+	mousevsc_free_device(input_dev);
+
 	return ret;
 }
 
@@ -556,14 +544,8 @@ static int mousevsc_remove(struct hv_device *dev)
 	struct mousevsc_dev *input_dev = hv_get_drvdata(dev);
 
 	vmbus_close(dev->channel);
-
-	if (input_dev->connected) {
-		hidinput_disconnect(input_dev->hid_device);
-		input_dev->connected = false;
-		hid_destroy_device(input_dev->hid_device);
-	}
-
-	free_input_device(input_dev);
+	hid_destroy_device(input_dev->hid_device);
+	mousevsc_free_device(input_dev);
 
 	return 0;
 }
-- 
1.7.4.1

