Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1COWSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:18:47 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33520
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752297Ab1COWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:18:21 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 08/12] Staging: hv: Get rid of the forward declaration for vmbus_remove
Date: Tue, 15 Mar 2011 15:03:40 -0700
Message-Id: <1300226624-27004-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1300226624-27004-8-git-send-email-kys@microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
 <1300226624-27004-4-git-send-email-kys@microsoft.com>
 <1300226624-27004-5-git-send-email-kys@microsoft.com>
 <1300226624-27004-6-git-send-email-kys@microsoft.com>
 <1300226624-27004-7-git-send-email-kys@microsoft.com>
 <1300226624-27004-8-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of vmbus_remove by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   59 +++++++++++++++++++--------------------
 1 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 8153a4d..3feed10 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -47,7 +47,6 @@ struct hv_bus {
 	struct tasklet_struct event_dpc;
 };
 
-static int vmbus_remove(struct device *device);
 static void vmbus_shutdown(struct device *device);
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id);
@@ -248,6 +247,35 @@ static int vmbus_probe(struct device *child_device)
 	return ret;
 }
 
+/*
+ * vmbus_remove - Remove a vmbus device
+ */
+static int vmbus_remove(struct device *child_device)
+{
+	int ret;
+	struct hv_driver *drv;
+
+
+	if (child_device->driver) {
+		drv = drv_to_hv_drv(child_device->driver);
+
+		/*
+		 * Let the specific open-source driver handles the removal if
+		 * it can
+		 */
+		if (drv->driver.remove) {
+			ret = drv->driver.remove(child_device);
+		} else {
+			DPRINT_ERR(VMBUS_DRV,
+				   "remove() method not set for driver - %s",
+				   child_device->driver->name);
+			ret = -1;
+		}
+	}
+
+	return 0;
+}
+
 /* The one and only one */
 static struct hv_bus  hv_bus = {
 	.bus.name =		"vmbus",
@@ -777,35 +805,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 }
 
 /*
- * vmbus_remove - Remove a vmbus device
- */
-static int vmbus_remove(struct device *child_device)
-{
-	int ret;
-	struct hv_driver *drv;
-
-
-	if (child_device->driver) {
-		drv = drv_to_hv_drv(child_device->driver);
-
-		/*
-		 * Let the specific open-source driver handles the removal if
-		 * it can
-		 */
-		if (drv->driver.remove) {
-			ret = drv->driver.remove(child_device);
-		} else {
-			DPRINT_ERR(VMBUS_DRV,
-				   "remove() method not set for driver - %s",
-				   child_device->driver->name);
-			ret = -1;
-		}
-	}
-
-	return 0;
-}
-
-/*
  * vmbus_shutdown - Shutdown a vmbus device
  */
 static void vmbus_shutdown(struct device *child_device)
-- 
1.5.5.6

