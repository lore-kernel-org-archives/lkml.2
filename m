Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1I2ScV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:32:21 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35719
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754394Ab1I2ScR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:17 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 07/24] Staging: hv: mousevsc: Use completion primitive to synchronize
Date: Thu, 29 Sep 2011 11:54:47 -0700
Message-Id: <1317322504-9788-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use completion primitive to synchronize.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   30 ++++++++++--------------------
 1 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 74faa26..ea9e1f3 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -162,10 +162,7 @@ struct mousevsc_dev {
 	struct mousevsc_prt_msg	protocol_req;
 	struct mousevsc_prt_msg	protocol_resp;
 	/* Synchronize the request/response if needed */
-	wait_queue_head_t	protocol_wait_event;
-	wait_queue_head_t	dev_info_wait_event;
-	int			protocol_wait_condition;
-	int			device_wait_condition;
+	struct completion	wait_event;
 	int			dev_info_status;
 
 	struct hid_descriptor	*hid_desc;
@@ -194,6 +191,7 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 
 	input_dev->device = device;
 	hv_set_drvdata(device, input_dev);
+	init_completion(&input_dev->wait_event);
 
 	return input_dev;
 }
@@ -379,8 +377,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 		goto cleanup;
 	}
 
-	input_device->device_wait_condition = 1;
-	wake_up(&input_device->dev_info_wait_event);
+	complete(&input_device->wait_event);
 
 	return;
 
@@ -392,8 +389,7 @@ cleanup:
 	input_device->report_desc = NULL;
 
 	input_device->dev_info_status = -1;
-	input_device->device_wait_condition = 1;
-	wake_up(&input_device->dev_info_wait_event);
+	complete(&input_device->wait_event);
 }
 
 static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
@@ -444,8 +440,7 @@ static void mousevsc_on_receive(struct hv_device *device,
 		memcpy(&input_dev->protocol_resp, pipe_msg,
 		       pipe_msg->size + sizeof(struct pipe_prt_msg) -
 		       sizeof(unsigned char));
-		input_dev->protocol_wait_condition = 1;
-		wake_up(&input_dev->protocol_wait_event);
+		complete(&input_dev->wait_event);
 		break;
 
 	case SynthHidInitialDeviceInfo:
@@ -565,6 +560,7 @@ static void mousevsc_on_channel_callback(void *context)
 static int mousevsc_connect_to_vsp(struct hv_device *device)
 {
 	int ret = 0;
+	int t;
 	struct mousevsc_dev *input_dev;
 	struct mousevsc_prt_msg *request;
 	struct mousevsc_prt_msg *response;
@@ -576,8 +572,6 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 		return -1;
 	}
 
-	init_waitqueue_head(&input_dev->protocol_wait_event);
-	init_waitqueue_head(&input_dev->dev_info_wait_event);
 
 	request = &input_dev->protocol_req;
 
@@ -607,10 +601,8 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 		goto cleanup;
 	}
 
-	input_dev->protocol_wait_condition = 0;
-	wait_event_timeout(input_dev->protocol_wait_event,
-		input_dev->protocol_wait_condition, msecs_to_jiffies(1000));
-	if (input_dev->protocol_wait_condition == 0) {
+	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
@@ -624,10 +616,8 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 		goto cleanup;
 	}
 
-	input_dev->device_wait_condition = 0;
-	wait_event_timeout(input_dev->dev_info_wait_event,
-		input_dev->device_wait_condition, msecs_to_jiffies(1000));
-	if (input_dev->device_wait_condition == 0) {
+	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
-- 
1.7.4.1

