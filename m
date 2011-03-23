Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1CWSMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:12:08 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33141
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756429Ab1CWSLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:11:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 15/16] Staging: hv: Move the definition of the function stor_vsc_on_host_reset()
Date: Wed, 23 Mar 2011 10:50:33 -0700
Message-Id: <1300902635-1347-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902635-1347-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
 <1300902635-1347-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stor_vsc_on_host_reset() function is only used in storvsc_drv.c.
Move this function from storvsc.c to storvsc_drv.c

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c     |   56 ------------------------------------
 drivers/staging/hv/storvsc_drv.c |   59 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index c576e7b..6801e37 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -522,62 +522,6 @@ int stor_vsc_on_device_remove(struct hv_device *device)
 	return 0;
 }
 
-int stor_vsc_on_host_reset(struct hv_device *device)
-{
-	struct storvsc_device *stor_device;
-	struct storvsc_request_extension *request;
-	struct vstor_packet *vstor_packet;
-	int ret;
-
-	DPRINT_INFO(STORVSC, "resetting host adapter...");
-
-	stor_device = get_stor_device(device);
-	if (!stor_device) {
-		DPRINT_ERR(STORVSC, "unable to get stor device..."
-			   "device being destroyed?");
-		return -1;
-	}
-
-	request = &stor_device->reset_request;
-	vstor_packet = &request->vstor_packet;
-
-	init_waitqueue_head(&request->wait_event);
-
-	vstor_packet->operation = VSTOR_OPERATION_RESET_BUS;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
-	vstor_packet->vm_srb.path_id = stor_device->path_id;
-
-	request->wait_condition = 0;
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
-			       (unsigned long)&stor_device->reset_request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0) {
-		DPRINT_ERR(STORVSC, "Unable to send reset packet %p ret %d",
-			   vstor_packet, ret);
-		goto cleanup;
-	}
-
-	wait_event_timeout(request->wait_event, request->wait_condition,
-			msecs_to_jiffies(1000));
-	if (request->wait_condition == 0) {
-		ret = -ETIMEDOUT;
-		goto cleanup;
-	}
-
-	DPRINT_INFO(STORVSC, "host adapter reset completed");
-
-	/*
-	 * At this point, all outstanding requests in the adapter
-	 * should have been flushed out and return to us
-	 */
-
-cleanup:
-	put_stor_device(device);
-	return ret;
-}
-
 /*
  * stor_vsc_on_io_request - Callback to initiate an I/O request
  */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 2c51a07..e0a1195 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -36,6 +36,8 @@
 #include "version_info.h"
 #include "vmbus.h"
 #include "storvsc_api.h"
+#include "vstorage.h"
+#include "channel.h"
 
 
 static const char *g_driver_name = "storvsc";
@@ -230,6 +232,63 @@ static int storvsc_drv_init(void)
 	return ret;
 }
 
+
+int stor_vsc_on_host_reset(struct hv_device *device)
+{
+	struct storvsc_device *stor_device;
+	struct storvsc_request_extension *request;
+	struct vstor_packet *vstor_packet;
+	int ret;
+
+	DPRINT_INFO(STORVSC, "resetting host adapter...");
+
+	stor_device = get_stor_device(device);
+	if (!stor_device) {
+		DPRINT_ERR(STORVSC, "unable to get stor device..."
+			   "device being destroyed?");
+		return -1;
+	}
+
+	request = &stor_device->reset_request;
+	vstor_packet = &request->vstor_packet;
+
+	init_waitqueue_head(&request->wait_event);
+
+	vstor_packet->operation = VSTOR_OPERATION_RESET_BUS;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+	vstor_packet->vm_srb.path_id = stor_device->path_id;
+
+	request->wait_condition = 0;
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
+			       sizeof(struct vstor_packet),
+			       (unsigned long)&stor_device->reset_request,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+	if (ret != 0) {
+		DPRINT_ERR(STORVSC, "Unable to send reset packet %p ret %d",
+			   vstor_packet, ret);
+		goto cleanup;
+	}
+
+	wait_event_timeout(request->wait_event, request->wait_condition,
+			msecs_to_jiffies(1000));
+	if (request->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
+
+	DPRINT_INFO(STORVSC, "host adapter reset completed");
+
+	/*
+	 * At this point, all outstanding requests in the adapter
+	 * should have been flushed out and return to us
+	 */
+
+cleanup:
+	put_stor_device(device);
+	return ret;
+}
+
 static int storvsc_drv_exit_cb(struct device *dev, void *data)
 {
 	struct device **curr = (struct device **)data;
-- 
1.7.4.1

