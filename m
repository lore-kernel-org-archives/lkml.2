Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab1IHOHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:07:46 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33726
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933075Ab1IHODO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:14 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 05/25] Staging: hv: vmbus: Change the signature of struct hv_driver probe function
Date: Thu,  8 Sep 2011 07:24:16 -0700
Message-Id: <1315491876-9554-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to leveraging the driver_data field in struct
hv_vmbus_device_id, change the signature of struct hv_driver probe function.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c    |    3 ++-
 drivers/staging/hv/hv_util.c     |    3 ++-
 drivers/staging/hv/hyperv.h      |    2 +-
 drivers/staging/hv/netvsc_drv.c  |    3 ++-
 drivers/staging/hv/storvsc_drv.c |    3 ++-
 drivers/staging/hv/vmbus_drv.c   |    8 +++++++-
 6 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index dbb04ee..5ff8a03 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -823,7 +823,8 @@ static int mousevsc_on_device_remove(struct hv_device *device)
 }
 
 
-static int mousevsc_probe(struct hv_device *dev)
+static int mousevsc_probe(struct hv_device *dev,
+			const struct hv_vmbus_device_id *dev_id)
 {
 	int ret = 0;
 
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index 6039217..d9460fdd 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -239,7 +239,8 @@ static void heartbeat_onchannelcallback(void *context)
  * The devices managed by the util driver don't need any additional
  * setup.
  */
-static int util_probe(struct hv_device *dev)
+static int util_probe(struct hv_device *dev,
+			const struct hv_vmbus_device_id *dev_id)
 {
 	return 0;
 }
diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index c249811..caa3a7b 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -810,7 +810,7 @@ struct hv_driver {
 
 	struct device_driver driver;
 
-	int (*probe)(struct hv_device *);
+	int (*probe)(struct hv_device *, const struct hv_vmbus_device_id *);
 	int (*remove)(struct hv_device *);
 	void (*shutdown)(struct hv_device *);
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 30b9c80..d06cde2 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -329,7 +329,8 @@ static void netvsc_send_garp(struct work_struct *w)
 }
 
 
-static int netvsc_probe(struct hv_device *dev)
+static int netvsc_probe(struct hv_device *dev,
+			const struct hv_vmbus_device_id *dev_id)
 {
 	struct net_device *net = NULL;
 	struct net_device_context *net_device_ctx;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index b0c4e56..fff1e5b 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1380,7 +1380,8 @@ MODULE_DEVICE_TABLE(vmbus, id_table);
  * storvsc_probe - Add a new device for this driver
  */
 
-static int storvsc_probe(struct hv_device *device)
+static int storvsc_probe(struct hv_device *device,
+			const struct hv_vmbus_device_id *dev_id)
 {
 	int ret;
 	struct Scsi_Host *host;
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 375e451..c7df7f4 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -299,9 +299,15 @@ static int vmbus_probe(struct device *child_device)
 	struct hv_driver *drv =
 			drv_to_hv_drv(child_device->driver);
 	struct hv_device *dev = device_to_hv_device(child_device);
+	const struct hv_vmbus_device_id *dev_id = drv->id_table;
+
+	for (; !is_null_guid(dev_id->guid); dev_id++)
+		if (!memcmp(&dev_id->guid, &dev->dev_type.b,
+				sizeof(uuid_le)))
+			break;
 
 	if (drv->probe) {
-		ret = drv->probe(dev);
+		ret = drv->probe(dev, dev_id);
 		if (ret != 0)
 			pr_err("probe failed for device %s (%d)\n",
 			       dev_name(child_device), ret);
-- 
1.7.4.1

