Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1I2Sdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:33:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35835
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755197Ab1I2ScT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:19 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 19/24] Staging: hv: mousevsc: Get rid of ref_count state in struct mousevsc_dev
Date: Thu, 29 Sep 2011 11:54:59 -0700
Message-Id: <1317322504-9788-19-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now get rid of the machinery for managing the life-cycle of the mousevsc_dev
as this is not needed.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   54 ++--------------------------------------
 1 files changed, 3 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 317d2be..e57e0b4 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -155,8 +155,6 @@ struct  mousevsc_prt_msg {
  */
 struct mousevsc_dev {
 	struct hv_device	*device;
-	/* 0 indicates the device is being destroyed */
-	atomic_t		ref_count;
 	unsigned char		init_complete;
 	struct mousevsc_prt_msg	protocol_req;
 	struct mousevsc_prt_msg	protocol_resp;
@@ -182,12 +180,6 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 	if (!input_dev)
 		return NULL;
 
-	/*
-	 * Set to 2 to allow both inbound and outbound traffics
-	 * (ie get_input_device() and must_get_input_device()) to proceed.
-	 */
-	atomic_set(&input_dev->ref_count, 2);
-
 	input_dev->device = device;
 	hv_set_drvdata(device, input_dev);
 	init_completion(&input_dev->wait_event);
@@ -203,32 +195,6 @@ static void free_input_device(struct mousevsc_dev *device)
 	kfree(device);
 }
 
-/*
- * Get the inputdevice object iff exists and its refcount > 0
- */
-static struct mousevsc_dev *must_get_input_device(struct hv_device *device)
-{
-	struct mousevsc_dev *input_dev;
-
-	input_dev = hv_get_drvdata(device);
-
-	if (input_dev && atomic_read(&input_dev->ref_count))
-		atomic_inc(&input_dev->ref_count);
-	else
-		input_dev = NULL;
-
-	return input_dev;
-}
-
-static void put_input_device(struct hv_device *device)
-{
-	struct mousevsc_dev *input_dev;
-
-	input_dev = hv_get_drvdata(device);
-
-	atomic_dec(&input_dev->ref_count);
-}
-
 
 static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
 				struct synthhid_device_info *device_info)
@@ -325,19 +291,13 @@ static void mousevsc_on_receive(struct hv_device *device,
 {
 	struct pipe_prt_msg *pipe_msg;
 	struct synthhid_msg *hid_msg;
-	struct mousevsc_dev *input_dev;
-
-	input_dev = must_get_input_device(device);
-	if (!input_dev)
-		return;
+	struct mousevsc_dev *input_dev = hv_get_drvdata(device);
 
 	pipe_msg = (struct pipe_prt_msg *)((unsigned long)packet +
 						(packet->offset8 << 3));
 
-	if (pipe_msg->type != PipeMessageData) {
-		put_input_device(device);
-		return ;
-	}
+	if (pipe_msg->type != PipeMessageData)
+		return;
 
 	hid_msg = (struct synthhid_msg *)&pipe_msg->data[0];
 
@@ -370,7 +330,6 @@ static void mousevsc_on_receive(struct hv_device *device,
 		break;
 	}
 
-	put_input_device(device);
 }
 
 static void mousevsc_on_channel_callback(void *context)
@@ -378,7 +337,6 @@ static void mousevsc_on_channel_callback(void *context)
 	const int packetSize = 0x100;
 	int ret = 0;
 	struct hv_device *device = (struct hv_device *)context;
-	struct mousevsc_dev *input_dev;
 
 	u32 bytes_recvd;
 	u64 req_id;
@@ -387,10 +345,6 @@ static void mousevsc_on_channel_callback(void *context)
 	unsigned char	*buffer = packet;
 	int	bufferlen = packetSize;
 
-	input_dev = must_get_input_device(device);
-
-	if (!input_dev)
-		return;
 
 	do {
 		ret = vmbus_recvpacket_raw(device->channel, buffer,
@@ -452,8 +406,6 @@ static void mousevsc_on_channel_callback(void *context)
 		}
 	} while (1);
 
-	put_input_device(device);
-
 	return;
 }
 
-- 
1.7.4.1

