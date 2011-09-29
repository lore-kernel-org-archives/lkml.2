Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab1I2Sej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:34:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35784
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754537Ab1I2ScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:18 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 11/24] Staging: hv: mousevsc: Get rid of unnecessary pr_* calls
Date: Thu, 29 Sep 2011 11:54:51 -0700
Message-Id: <1317322504-9788-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of unnecessary pr_* calls.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   64 +++++++----------------------------------
 1 files changed, 11 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index fc1f3e6..57bc4a3 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -294,10 +294,8 @@ static void mousevsc_on_send_completion(struct hv_device *device,
 	void *request;
 
 	input_dev = must_get_input_device(device);
-	if (!input_dev) {
-		pr_err("unable to get input device...device being destroyed?");
+	if (!input_dev)
 		return;
-	}
 
 	request = (void *)(unsigned long)packet->trans_id;
 
@@ -329,11 +327,8 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 
 	input_device->hid_desc = kzalloc(desc->bLength, GFP_ATOMIC);
 
-	if (!input_device->hid_desc) {
-		pr_err("unable to allocate hid descriptor - size %d",
-			 desc->bLength);
+	if (!input_device->hid_desc)
 		goto cleanup;
-	}
 
 	memcpy(input_device->hid_desc, desc, desc->bLength);
 
@@ -344,11 +339,8 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	input_device->report_desc = kzalloc(input_device->report_desc_size,
 					  GFP_ATOMIC);
 
-	if (!input_device->report_desc) {
-		pr_err("unable to allocate report descriptor - size %d",
-			   input_device->report_desc_size);
+	if (!input_device->report_desc)
 		goto cleanup;
-	}
 
 	memcpy(input_device->report_desc,
 	       ((unsigned char *)desc) + desc->bLength,
@@ -371,11 +363,8 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 			(unsigned long)&ack,
 			VM_PKT_DATA_INBAND,
 			VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0) {
-		pr_err("unable to send synthhid device info ack - ret %d",
-			   ret);
+	if (ret != 0)
 		goto cleanup;
-	}
 
 	complete(&input_device->wait_event);
 
@@ -397,10 +386,8 @@ static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
 {
 	struct hv_driver *input_drv;
 
-	if (!input_device->init_complete) {
-		pr_info("Initialization incomplete...ignoring input_report msg");
+	if (!input_device->init_complete)
 		return;
-	}
 
 	input_drv = drv_to_hv_drv(input_device->device->device.driver);
 
@@ -418,17 +405,13 @@ static void mousevsc_on_receive(struct hv_device *device,
 	struct mousevsc_dev *input_dev;
 
 	input_dev = must_get_input_device(device);
-	if (!input_dev) {
-		pr_err("unable to get input device...device being destroyed?");
+	if (!input_dev)
 		return;
-	}
 
 	pipe_msg = (struct pipe_prt_msg *)((unsigned long)packet +
 						(packet->offset8 << 3));
 
 	if (pipe_msg->type != PipeMessageData) {
-		pr_err("unknown pipe msg type - type %d len %d",
-			   pipe_msg->type, pipe_msg->size);
 		put_input_device(device);
 		return ;
 	}
@@ -483,10 +466,8 @@ static void mousevsc_on_channel_callback(void *context)
 
 	input_dev = must_get_input_device(device);
 
-	if (!input_dev) {
-		pr_err("unable to get input device...device being destroyed?");
+	if (!input_dev)
 		return;
-	}
 
 	do {
 		ret = vmbus_recvpacket_raw(device->channel, buffer,
@@ -545,8 +526,6 @@ static void mousevsc_on_channel_callback(void *context)
 				bufferlen = packetSize;
 
 				/* Try again next time around */
-				pr_err("unable to allocate buffer of size %d!",
-				       bytes_recvd);
 				break;
 			}
 		}
@@ -567,10 +546,8 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 
 	input_dev = get_input_device(device);
 
-	if (!input_dev) {
-		pr_err("unable to get input device...device being destroyed?");
+	if (!input_dev)
 		return -ENODEV;
-	}
 
 
 	request = &input_dev->protocol_req;
@@ -587,7 +564,6 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	request->request.header.size = sizeof(unsigned int);
 	request->request.version_requested.version = SYNTHHID_INPUT_VERSION;
 
-	pr_info("synthhid protocol request...");
 
 	ret = vmbus_sendpacket(device->channel, request,
 				sizeof(struct pipe_prt_msg) -
@@ -596,10 +572,8 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 				(unsigned long)request,
 				VM_PKT_DATA_INBAND,
 				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0) {
-		pr_err("unable to send synthhid protocol request.");
+	if (ret != 0)
 		goto cleanup;
-	}
 
 	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
 	if (t == 0) {
@@ -626,9 +600,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	 * We should have gotten the device attr, hid desc and report
 	 * desc at this point
 	 */
-	if (!input_dev->dev_info_status)
-		pr_info("**** input channel up and running!! ****");
-	else
+	if (input_dev->dev_info_status)
 		ret = -ENOMEM;
 
 cleanup:
@@ -710,18 +682,14 @@ static int mousevsc_on_device_add(struct hv_device *device,
 		);
 
 	if (ret != 0) {
-		pr_err("unable to open channel: %d", ret);
 		free_input_device(input_dev);
 		return ret;
 	}
 
-	pr_info("InputVsc channel open: %d", ret);
 
 	ret = mousevsc_connect_to_vsp(device);
 
 	if (ret != 0) {
-		pr_err("unable to connect channel: %d", ret);
-
 		vmbus_close(device->channel);
 		free_input_device(input_dev);
 		return ret;
@@ -749,8 +717,6 @@ static int mousevsc_on_device_remove(struct hv_device *device)
 	struct mousevsc_dev *input_dev;
 	int ret = 0;
 
-	pr_info("disabling input device (%p)...",
-		    hv_get_drvdata(device));
 
 	input_dev = release_input_device(device);
 
@@ -761,19 +727,11 @@ static int mousevsc_on_device_remove(struct hv_device *device)
 	 *
 	 * so that outstanding requests can be completed.
 	 */
-	while (input_dev->num_outstanding_req) {
-		pr_info("waiting for %d requests to complete...",
-			input_dev->num_outstanding_req);
-
+	while (input_dev->num_outstanding_req)
 		udelay(100);
-	}
-
-	pr_info("removing input device (%p)...", hv_get_drvdata(device));
 
 	input_dev = final_release_input_device(device);
 
-	pr_info("input device (%p) safe to remove", input_dev);
-
 	/* Close the channel */
 	vmbus_close(device->channel);
 
-- 
1.7.4.1

