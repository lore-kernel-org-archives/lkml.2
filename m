Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab1IHOEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:04:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40623
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933092Ab1IHODQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 07/25] Staging: hv: vmbus: Change the signature of struct hv_driver remove() function
Date: Thu,  8 Sep 2011 07:24:18 -0700
Message-Id: <1315491876-9554-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for leveraging the driver_data in  struct
hv_vmbus_device_id, change the signature of struct hv_driver remove() function.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c    |    3 ++-
 drivers/staging/hv/hv_util.c     |    3 ++-
 drivers/staging/hv/hyperv.h      |    2 +-
 drivers/staging/hv/netvsc_drv.c  |    3 ++-
 drivers/staging/hv/storvsc_drv.c |    3 ++-
 drivers/staging/hv/vmbus_drv.c   |    9 ++++++++-
 6 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 5ff8a03..d60f287 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -847,7 +847,8 @@ static int mousevsc_probe(struct hv_device *dev,
 	return 0;
 }
 
-static int mousevsc_remove(struct hv_device *dev)
+static int mousevsc_remove(struct hv_device *dev,
+				const struct hv_vmbus_device_id *dev_id)
 {
 	struct input_device_context *input_dev_ctx;
 	int ret;
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index d9460fdd..661631d 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -245,7 +245,8 @@ static int util_probe(struct hv_device *dev,
 	return 0;
 }
 
-static int util_remove(struct hv_device *dev)
+static int util_remove(struct hv_device *dev,
+			const struct hv_vmbus_device_id *dev_id)
 {
 	return 0;
 }
diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index caa3a7b..cf02ae1 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -811,7 +811,7 @@ struct hv_driver {
 	struct device_driver driver;
 
 	int (*probe)(struct hv_device *, const struct hv_vmbus_device_id *);
-	int (*remove)(struct hv_device *);
+	int (*remove)(struct hv_device *, const struct hv_vmbus_device_id *);
 	void (*shutdown)(struct hv_device *);
 
 };
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index d06cde2..d0189a3 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -384,7 +384,8 @@ out:
 	return ret;
 }
 
-static int netvsc_remove(struct hv_device *dev)
+static int netvsc_remove(struct hv_device *dev,
+			const struct hv_vmbus_device_id *dev_id)
 {
 	struct net_device *net = dev_get_drvdata(&dev->device);
 	struct net_device_context *ndev_ctx;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index e2c63e5..e5da758 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1021,7 +1021,8 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 }
 
 
-static int storvsc_remove(struct hv_device *dev)
+static int storvsc_remove(struct hv_device *dev,
+				const struct hv_vmbus_device_id *dev_id)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->device);
 	struct hv_host_device *host_dev =
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index c7df7f4..b9aeb76 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -329,12 +329,19 @@ static int vmbus_remove(struct device *child_device)
 	struct hv_driver *drv;
 
 	struct hv_device *dev = device_to_hv_device(child_device);
+	const struct hv_vmbus_device_id *dev_id;
 
 	if (child_device->driver) {
 		drv = drv_to_hv_drv(child_device->driver);
+		dev_id = drv->id_table;
+
+		for (; !is_null_guid(dev_id->guid); dev_id++)
+			if (!memcmp(&dev_id->guid, &dev->dev_type.b,
+					sizeof(uuid_le)))
+				break;
 
 		if (drv->remove) {
-			ret = drv->remove(dev);
+			ret = drv->remove(dev, dev_id);
 		} else {
 			pr_err("remove not set for driver %s\n",
 				dev_name(child_device));
-- 
1.7.4.1

