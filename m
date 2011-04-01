Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab1DAVWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:22:34 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41176
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756452Ab1DAVVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:21:40 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, hjanssen@linuxonhyperv.com, haiyangz@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/5] staging: hv: Convert camel case members of struct mousevsc_dev to lower case
Date: Fri,  1 Apr 2011 14:32:13 -0700
Message-Id: <1301693534-14629-4-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301693534-14629-1-git-send-email-hjanssen@microsoft.com>
References: <1301693534-14629-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change camelcase members of struct mousevsc_dev to lower case in hv_mouse

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/hv_mouse.c |  127 +++++++++++++++++++++--------------------
 1 files changed, 65 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index ce88868..1edcdf7 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -167,23 +167,23 @@ struct  mousevsc_prt_msg {
  * Represents an mousevsc device
  */
 struct mousevsc_dev {
-	struct hv_device	*Device;
+	struct hv_device	*device;
 	/* 0 indicates the device is being destroyed */
-	atomic_t		RefCount;
-	int			NumOutstandingRequests;
-	unsigned char		bInitializeComplete;
-	struct mousevsc_prt_msg	ProtocolReq;
-	struct mousevsc_prt_msg	ProtocolResp;
+	atomic_t		ref_count;
+	int			num_outstanding_req;
+	unsigned char		init_complete;
+	struct mousevsc_prt_msg	protocol_req;
+	struct mousevsc_prt_msg	protocol_resp;
 	/* Synchronize the request/response if needed */
-	wait_queue_head_t	ProtocolWaitEvent;
-	wait_queue_head_t	DeviceInfoWaitEvent;
+	wait_queue_head_t	protocol_wait_event;
+	wait_queue_head_t	dev_info_wait_event;
 	int			protocol_wait_condition;
 	int			device_wait_condition;
-	int			DeviceInfoStatus;
+	int			dev_info_status;
 
-	struct hid_descriptor	*HidDesc;
-	unsigned char		*ReportDesc;
-	u32			ReportDescSize;
+	struct hid_descriptor	*hid_desc;
+	unsigned char		*report_desc;
+	u32			report_desc_size;
 	struct hv_input_dev_info hid_dev_info;
 };
 
@@ -213,9 +213,9 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 	 * Set to 2 to allow both inbound and outbound traffics
 	 * (ie get_input_device() and must_get_input_device()) to proceed.
 	 */
-	atomic_cmpxchg(&inputDevice->RefCount, 0, 2);
+	atomic_cmpxchg(&inputDevice->ref_count, 0, 2);
 
-	inputDevice->Device = device;
+	inputDevice->device = device;
 	device->ext = inputDevice;
 
 	return inputDevice;
@@ -223,7 +223,7 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 
 static void free_input_device(struct mousevsc_dev *device)
 {
-	WARN_ON(atomic_read(&device->RefCount) == 0);
+	WARN_ON(atomic_read(&device->ref_count) == 0);
 	kfree(device);
 }
 
@@ -242,11 +242,11 @@ static struct mousevsc_dev *get_input_device(struct hv_device *device)
  *	what the intention is...
  *
  *	printk(KERN_ERR "-------------------------> REFCOUNT = %d",
- *	       inputDevice->RefCount);
+ *	       inputDevice->ref_count);
  */
 
-	if (inputDevice && atomic_read(&inputDevice->RefCount) > 1)
-		atomic_inc(&inputDevice->RefCount);
+	if (inputDevice && atomic_read(&inputDevice->ref_count) > 1)
+		atomic_inc(&inputDevice->ref_count);
 	else
 		inputDevice = NULL;
 
@@ -262,8 +262,8 @@ static struct mousevsc_dev *must_get_input_device(struct hv_device *device)
 
 	inputDevice = (struct mousevsc_dev *)device->ext;
 
-	if (inputDevice && atomic_read(&inputDevice->RefCount))
-		atomic_inc(&inputDevice->RefCount);
+	if (inputDevice && atomic_read(&inputDevice->ref_count))
+		atomic_inc(&inputDevice->ref_count);
 	else
 		inputDevice = NULL;
 
@@ -276,7 +276,7 @@ static void put_input_device(struct hv_device *device)
 
 	inputDevice = (struct mousevsc_dev *)device->ext;
 
-	atomic_dec(&inputDevice->RefCount);
+	atomic_dec(&inputDevice->ref_count);
 }
 
 /*
@@ -289,7 +289,7 @@ static struct mousevsc_dev *release_input_device(struct hv_device *device)
 	inputDevice = (struct mousevsc_dev *)device->ext;
 
 	/* Busy wait until the ref drop to 2, then set it to 1  */
-	while (atomic_cmpxchg(&inputDevice->RefCount, 2, 1) != 2)
+	while (atomic_cmpxchg(&inputDevice->ref_count, 2, 1) != 2)
 		udelay(100);
 
 	return inputDevice;
@@ -305,7 +305,7 @@ static struct mousevsc_dev *final_release_input_device(struct hv_device *device)
 	inputDevice = (struct mousevsc_dev *)device->ext;
 
 	/* Busy wait until the ref drop to 1, then set it to 0  */
-	while (atomic_cmpxchg(&inputDevice->RefCount, 1, 0) != 1)
+	while (atomic_cmpxchg(&inputDevice->ref_count, 1, 0) != 1)
 		udelay(100);
 
 	device->ext = NULL;
@@ -326,7 +326,7 @@ static void mousevsc_on_send_completion(struct hv_device *device,
 
 	request = (void *)(unsigned long)packet->trans_id;
 
-	if (request == &inputDevice->ProtocolReq) {
+	if (request == &inputDevice->protocol_req) {
 		/* FIXME */
 		/* Shouldn't we be doing something here? */
 	}
@@ -342,7 +342,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	struct mousevsc_prt_msg ack;
 
 	/* Assume success for now */
-	input_device->DeviceInfoStatus = 0;
+	input_device->dev_info_status = 0;
 
 	/* Save the device attr */
 	memcpy(&input_device->hid_dev_info, &device_info->hid_dev_info,
@@ -352,27 +352,27 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	desc = &device_info->hid_descriptor;
 	WARN_ON(desc->bLength > 0);
 
-	input_device->HidDesc = kzalloc(desc->bLength, GFP_KERNEL);
+	input_device->hid_desc = kzalloc(desc->bLength, GFP_KERNEL);
 
-	if (!input_device->HidDesc) {
+	if (!input_device->hid_desc) {
 		pr_err("unable to allocate hid descriptor - size %d", desc->bLength);
 		goto Cleanup;
 	}
 
-	memcpy(input_device->HidDesc, desc, desc->bLength);
+	memcpy(input_device->hid_desc, desc, desc->bLength);
 
 	/* Save the report desc */
-	input_device->ReportDescSize = desc->desc[0].wDescriptorLength;
-	input_device->ReportDesc = kzalloc(input_device->ReportDescSize,
+	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
+	input_device->report_desc = kzalloc(input_device->report_desc_size,
 					  GFP_KERNEL);
 
-	if (!input_device->ReportDesc) {
+	if (!input_device->report_desc) {
 		pr_err("unable to allocate report descriptor - size %d",
-			   input_device->ReportDescSize);
+			   input_device->report_desc_size);
 		goto Cleanup;
 	}
 
-	memcpy(input_device->ReportDesc,
+	memcpy(input_device->report_desc,
 	       ((unsigned char *)desc) + desc->bLength,
 	       desc->desc[0].wDescriptorLength);
 
@@ -386,7 +386,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	ack.ack.header.size = 1;
 	ack.ack.reserved = 0;
 
-	ret = vmbus_sendpacket(input_device->Device->channel,
+	ret = vmbus_sendpacket(input_device->device->channel,
 			&ack,
 			sizeof(struct pipe_prt_msg) - sizeof(unsigned char) +
 			sizeof(struct synthhid_device_info_ack),
@@ -400,20 +400,20 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 	}
 
 	input_device->device_wait_condition = 1;
-	wake_up(&input_device->DeviceInfoWaitEvent);
+	wake_up(&input_device->dev_info_wait_event);
 
 	return;
 
 Cleanup:
-	kfree(input_device->HidDesc);
-	input_device->HidDesc = NULL;
+	kfree(input_device->hid_desc);
+	input_device->hid_desc = NULL;
 
-	kfree(input_device->ReportDesc);
-	input_device->ReportDesc = NULL;
+	kfree(input_device->report_desc);
+	input_device->report_desc = NULL;
 
-	input_device->DeviceInfoStatus = -1;
+	input_device->dev_info_status = -1;
 	input_device->device_wait_condition = 1;
-	wake_up(&input_device->DeviceInfoWaitEvent);
+	wake_up(&input_device->dev_info_wait_event);
 }
 
 static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
@@ -421,14 +421,14 @@ static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
 {
 	struct mousevsc_drv_obj *inputDriver;
 
-	if (!input_device->bInitializeComplete) {
+	if (!input_device->init_complete) {
 		pr_info("Initialization incomplete...ignoring input_report msg");
 		return;
 	}
 
-	inputDriver = (struct mousevsc_drv_obj *)input_device->Device->drv;
+	inputDriver = (struct mousevsc_drv_obj *)input_device->device->drv;
 
-	inputreport_callback(input_device->Device,
+	inputreport_callback(input_device->device,
 			     input_report->buffer,
 			     input_report->header.size);
 }
@@ -460,11 +460,11 @@ static void mousevsc_on_receive(struct hv_device *device,
 
 	switch (hidMsg->header.type) {
 	case SynthHidProtocolResponse:
-		memcpy(&inputDevice->ProtocolResp, pipeMsg,
+		memcpy(&inputDevice->protocol_resp, pipeMsg,
 		       pipeMsg->size + sizeof(struct pipe_prt_msg) -
 		       sizeof(unsigned char));
 		inputDevice->protocol_wait_condition = 1;
-		wake_up(&inputDevice->ProtocolWaitEvent);
+		wake_up(&inputDevice->protocol_wait_event);
 		break;
 
 	case SynthHidInitialDeviceInfo:
@@ -594,10 +594,10 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 		return -1;
 	}
 
-	init_waitqueue_head(&inputDevice->ProtocolWaitEvent);
-	init_waitqueue_head(&inputDevice->DeviceInfoWaitEvent);
+	init_waitqueue_head(&inputDevice->protocol_wait_event);
+	init_waitqueue_head(&inputDevice->dev_info_wait_event);
 
-	request = &inputDevice->ProtocolReq;
+	request = &inputDevice->protocol_req;
 
 	/*
 	 * Now, initiate the vsc/vsp initialization protocol on the open channel
@@ -626,13 +626,14 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	}
 
 	inputDevice->protocol_wait_condition = 0;
-	wait_event_timeout(inputDevice->ProtocolWaitEvent, inputDevice->protocol_wait_condition, msecs_to_jiffies(1000));
+	wait_event_timeout(inputDevice->protocol_wait_event,
+		inputDevice->protocol_wait_condition, msecs_to_jiffies(1000));
 	if (inputDevice->protocol_wait_condition == 0) {
 		ret = -ETIMEDOUT;
 		goto Cleanup;
 	}
 
-	response = &inputDevice->ProtocolResp;
+	response = &inputDevice->protocol_resp;
 
 	if (!response->response.approved) {
 		pr_err("synthhid protocol request failed (version %d)",
@@ -642,7 +643,8 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	}
 
 	inputDevice->device_wait_condition = 0;
-	wait_event_timeout(inputDevice->DeviceInfoWaitEvent, inputDevice->device_wait_condition, msecs_to_jiffies(1000));
+	wait_event_timeout(inputDevice->dev_info_wait_event,
+		inputDevice->device_wait_condition, msecs_to_jiffies(1000));
 	if (inputDevice->device_wait_condition == 0) {
 		ret = -ETIMEDOUT;
 		goto Cleanup;
@@ -652,7 +654,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	 * We should have gotten the device attr, hid desc and report
 	 * desc at this point
 	 */
-	if (!inputDevice->DeviceInfoStatus)
+	if (!inputDevice->dev_info_status)
 		pr_info("**** input channel up and running!! ****");
 	else
 		ret = -1;
@@ -678,7 +680,7 @@ static int mousevsc_on_device_add(struct hv_device *device,
 		goto Cleanup;
 	}
 
-	inputDevice->bInitializeComplete = false;
+	inputDevice->init_complete = false;
 
 	/* Open the channel */
 	ret = vmbus_open(device->channel,
@@ -708,7 +710,7 @@ static int mousevsc_on_device_add(struct hv_device *device,
 		return ret;
 	}
 
-	inputDriver = (struct mousevsc_drv_obj *)inputDevice->Device->drv;
+	inputDriver = (struct mousevsc_drv_obj *)inputDevice->device->drv;
 
 	dev_info.vendor = inputDevice->hid_dev_info.vendor;
 	dev_info.product = inputDevice->hid_dev_info.product;
@@ -720,13 +722,13 @@ static int mousevsc_on_device_add(struct hv_device *device,
 
 	/* Send the report desc back up */
 	/* workaround SA-167 */
-	if (inputDevice->ReportDesc[14] == 0x25)
-		inputDevice->ReportDesc[14] = 0x29;
+	if (inputDevice->report_desc[14] == 0x25)
+		inputDevice->report_desc[14] = 0x29;
 
-	reportdesc_callback(device, inputDevice->ReportDesc,
-			    inputDevice->ReportDescSize);
+	reportdesc_callback(device, inputDevice->report_desc,
+			    inputDevice->report_desc_size);
 
-	inputDevice->bInitializeComplete = true;
+	inputDevice->init_complete = true;
 
 Cleanup:
 	return ret;
@@ -749,8 +751,9 @@ static int mousevsc_on_device_remove(struct hv_device *device)
 	 *
 	 * so that outstanding requests can be completed.
 	 */
-	while (inputDevice->NumOutstandingRequests) {
-		pr_info("waiting for %d requests to complete...", inputDevice->NumOutstandingRequests);
+	while (inputDevice->num_outstanding_req) {
+		pr_info("waiting for %d requests to complete...",
+			inputDevice->num_outstanding_req);
 
 		udelay(100);
 	}
-- 
1.7.1

