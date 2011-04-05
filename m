Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1DENx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:53:57 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42395
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752867Ab1DENxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 05/22] Staging: hv: Use struct completion in struct storvsc_request_extension
Date: Tue,  5 Apr 2011 07:04:49 -0700
Message-Id: <1302012306-21277-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012306-21277-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
 <1302012306-21277-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the wait_queue mechanism for synchronization in
struct storvsc_request_extension and instead use completion
mechanism.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c     |   34 ++++++++++++----------------------
 drivers/staging/hv/storvsc_api.h |    3 +--
 drivers/staging/hv/storvsc_drv.c |   10 ++++------
 3 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 5cea331..8dc17b9 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -20,7 +20,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/wait.h>
+#include <linux/completion.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -107,7 +107,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	struct storvsc_device *stor_device;
 	struct storvsc_request_extension *request;
 	struct vstor_packet *vstor_packet;
-	int ret;
+	int ret, t;
 
 	stor_device = get_stor_device(device);
 	if (!stor_device) {
@@ -124,13 +124,12 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	 * channel
 	 */
 	memset(request, 0, sizeof(struct storvsc_request_extension));
-	init_waitqueue_head(&request->wait_event);
+	init_completion(&request->wait_event);
 	vstor_packet->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
 	DPRINT_INFO(STORVSC, "BEGIN_INITIALIZATION_OPERATION...");
 
-	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
@@ -142,14 +141,12 @@ static int stor_vsc_channel_init(struct hv_device *device)
 		goto cleanup;
 	}
 
-	wait_event_timeout(request->wait_event, request->wait_condition,
-			msecs_to_jiffies(1000));
-	if (request->wait_condition == 0) {
+	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
 
-
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
 	    vstor_packet->status != 0) {
 		DPRINT_ERR(STORVSC, "BEGIN_INITIALIZATION_OPERATION failed "
@@ -168,7 +165,6 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	vstor_packet->version.major_minor = VMSTOR_PROTOCOL_VERSION_CURRENT;
 	FILL_VMSTOR_REVISION(vstor_packet->version.revision);
 
-	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
@@ -180,9 +176,8 @@ static int stor_vsc_channel_init(struct hv_device *device)
 		goto cleanup;
 	}
 
-	wait_event_timeout(request->wait_event, request->wait_condition,
-			msecs_to_jiffies(1000));
-	if (request->wait_condition == 0) {
+	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
@@ -205,7 +200,6 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	vstor_packet->storage_channel_properties.port_number =
 					stor_device->port_number;
 
-	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
@@ -218,9 +212,8 @@ static int stor_vsc_channel_init(struct hv_device *device)
 		goto cleanup;
 	}
 
-	wait_event_timeout(request->wait_event, request->wait_condition,
-			msecs_to_jiffies(1000));
-	if (request->wait_condition == 0) {
+	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
@@ -248,7 +241,6 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
-	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
@@ -261,9 +253,8 @@ static int stor_vsc_channel_init(struct hv_device *device)
 		goto cleanup;
 	}
 
-	wait_event_timeout(request->wait_event, request->wait_condition,
-			msecs_to_jiffies(1000));
-	if (request->wait_condition == 0) {
+	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
@@ -397,8 +388,7 @@ static void stor_vsc_on_channel_callback(void *context)
 
 				memcpy(&request->vstor_packet, packet,
 				       sizeof(struct vstor_packet));
-				request->wait_condition = 1;
-				wake_up(&request->wait_event);
+				complete(&request->wait_event);
 			} else {
 				stor_vsc_on_receive(device,
 						(struct vstor_packet *)packet,
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 5c80cdb..cdef1c7 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -60,8 +60,7 @@ struct storvsc_request_extension {
 	struct hv_device *device;
 
 	/* Synchronize the request/response if needed */
-	int wait_condition;
-	wait_queue_head_t wait_event;
+	struct completion wait_event;
 
 	struct vstor_packet vstor_packet;
 };
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 268c607..c2a3a5b 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -231,7 +231,7 @@ static int stor_vsc_on_host_reset(struct hv_device *device)
 	struct storvsc_device *stor_device;
 	struct storvsc_request_extension *request;
 	struct vstor_packet *vstor_packet;
-	int ret;
+	int ret, t;
 
 	DPRINT_INFO(STORVSC, "resetting host adapter...");
 
@@ -245,13 +245,12 @@ static int stor_vsc_on_host_reset(struct hv_device *device)
 	request = &stor_device->reset_request;
 	vstor_packet = &request->vstor_packet;
 
-	init_waitqueue_head(&request->wait_event);
+	init_completion(&request->wait_event);
 
 	vstor_packet->operation = VSTOR_OPERATION_RESET_BUS;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 	vstor_packet->vm_srb.path_id = stor_device->path_id;
 
-	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)&stor_device->reset_request,
@@ -263,9 +262,8 @@ static int stor_vsc_on_host_reset(struct hv_device *device)
 		goto cleanup;
 	}
 
-	wait_event_timeout(request->wait_event, request->wait_condition,
-			msecs_to_jiffies(1000));
-	if (request->wait_condition == 0) {
+	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
-- 
1.7.4.1

