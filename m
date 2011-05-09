Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1EIWBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:01:30 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54196
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754921Ab1EIVor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:47 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 057/206] Staging: hv: Get rid of the forward declaration of storvsc_probe()
Date: Mon,  9 May 2011 14:55:39 -0700
Message-Id: <1304978288-22999-57-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |  143 +++++++++++++++++++-------------------
 1 files changed, 71 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 4d4226a..37bc4dd 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -766,8 +766,6 @@ retry_request:
 
 static DEF_SCSI_QCMD(storvsc_queuecommand)
 
-/* Static decl */
-static int storvsc_probe(struct hv_device *dev);
 
 /* The one and only one */
 static struct storvsc_driver g_storvsc_drv;
@@ -802,78 +800,9 @@ static struct scsi_host_template scsi_driver = {
 
 
 /*
- * storvsc_drv_init - StorVsc driver initialization.
- */
-static int storvsc_drv_init(void)
-{
-	int ret;
-	struct storvsc_driver *storvsc_drv_obj = &g_storvsc_drv;
-	struct hv_driver *drv = &g_storvsc_drv.base;
-
-	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
-
-	/* Callback to client driver to complete the initialization */
-	storvsc_initialize(&storvsc_drv_obj->base);
-
-	DPRINT_INFO(STORVSC_DRV,
-		    "max outstanding reqs %u",
-		    storvsc_drv_obj->max_outstanding_req_per_channel);
-
-	if (storvsc_drv_obj->max_outstanding_req_per_channel <
-	    STORVSC_MAX_IO_REQUESTS)
-		return -1;
-
-	drv->driver.name = storvsc_drv_obj->base.name;
-
-	drv->probe = storvsc_probe;
-	drv->remove = storvsc_remove;
-
-	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(&drv->driver);
-
-	return ret;
-}
-
-static int storvsc_drv_exit_cb(struct device *dev, void *data)
-{
-	struct device **curr = (struct device **)data;
-	*curr = dev;
-	return 1; /* stop iterating */
-}
-
-static void storvsc_drv_exit(void)
-{
-	struct storvsc_driver *storvsc_drv_obj = &g_storvsc_drv;
-	struct hv_driver *drv = &g_storvsc_drv.base;
-	struct device *current_dev = NULL;
-	int ret;
-
-	while (1) {
-		current_dev = NULL;
-
-		/* Get the device */
-		ret = driver_for_each_device(&drv->driver, NULL,
-					     (void *) &current_dev,
-					     storvsc_drv_exit_cb);
-
-
-		if (current_dev == NULL)
-			break;
-
-		/* Initiate removal from the top-down */
-		device_unregister(current_dev);
-	}
-
-	if (storvsc_drv_obj->base.cleanup)
-		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
-
-	vmbus_child_driver_unregister(&drv->driver);
-	return;
-}
-
-/*
  * storvsc_probe - Add a new device for this driver
  */
+
 static int storvsc_probe(struct hv_device *device)
 {
 	int ret;
@@ -944,6 +873,76 @@ static int storvsc_probe(struct hv_device *device)
 	return ret;
 }
 
+/*
+ * storvsc_drv_init - StorVsc driver initialization.
+ */
+static int storvsc_drv_init(void)
+{
+	int ret;
+	struct storvsc_driver *storvsc_drv_obj = &g_storvsc_drv;
+	struct hv_driver *drv = &g_storvsc_drv.base;
+
+	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
+
+	/* Callback to client driver to complete the initialization */
+	storvsc_initialize(&storvsc_drv_obj->base);
+
+	DPRINT_INFO(STORVSC_DRV,
+		    "max outstanding reqs %u",
+		    storvsc_drv_obj->max_outstanding_req_per_channel);
+
+	if (storvsc_drv_obj->max_outstanding_req_per_channel <
+	    STORVSC_MAX_IO_REQUESTS)
+		return -1;
+
+	drv->driver.name = storvsc_drv_obj->base.name;
+
+	drv->probe = storvsc_probe;
+	drv->remove = storvsc_remove;
+
+	/* The driver belongs to vmbus */
+	ret = vmbus_child_driver_register(&drv->driver);
+
+	return ret;
+}
+
+static int storvsc_drv_exit_cb(struct device *dev, void *data)
+{
+	struct device **curr = (struct device **)data;
+	*curr = dev;
+	return 1; /* stop iterating */
+}
+
+static void storvsc_drv_exit(void)
+{
+	struct storvsc_driver *storvsc_drv_obj = &g_storvsc_drv;
+	struct hv_driver *drv = &g_storvsc_drv.base;
+	struct device *current_dev = NULL;
+	int ret;
+
+	while (1) {
+		current_dev = NULL;
+
+		/* Get the device */
+		ret = driver_for_each_device(&drv->driver, NULL,
+					     (void *) &current_dev,
+					     storvsc_drv_exit_cb);
+
+
+		if (current_dev == NULL)
+			break;
+
+		/* Initiate removal from the top-down */
+		device_unregister(current_dev);
+	}
+
+	if (storvsc_drv_obj->base.cleanup)
+		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
+
+	vmbus_child_driver_unregister(&drv->driver);
+	return;
+}
+
 static int __init storvsc_init(void)
 {
 	int ret;
-- 
1.7.4.1

