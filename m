Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab1D2Uc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:32:56 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41675
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933816Ab1D2Uc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:32:29 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 10/18] Staging: hv: Get rid of struct hv_bus
Date: Fri, 29 Apr 2011 13:45:08 -0700
Message-Id: <1304109916-24874-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304109916-24874-1-git-send-email-kys@microsoft.com>
References: <1304109779-24819-1-git-send-email-kys@microsoft.com>
 <1304109916-24874-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of struct hv_bus. We will no longer be embedding
struct bus_type.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   33 +++++++++++++--------------------
 1 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 6cc01c2..872752a 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -45,11 +45,6 @@ static struct pci_dev *hv_pci_dev;
 static struct tasklet_struct msg_dpc;
 static struct tasklet_struct event_dpc;
 
-/* Main vmbus driver data structure */
-struct hv_bus {
-	struct bus_type bus;
-};
-
 unsigned int vmbus_loglevel = (ALL_MODULES << 16 | INFO_LVL);
 EXPORT_SYMBOL(vmbus_loglevel);
 	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
@@ -403,14 +398,14 @@ static void vmbus_device_release(struct device *device)
 }
 
 /* The one and only one */
-static struct hv_bus  hv_bus = {
-	.bus.name =		"vmbus",
-	.bus.match =		vmbus_match,
-	.bus.shutdown =		vmbus_shutdown,
-	.bus.remove =		vmbus_remove,
-	.bus.probe =		vmbus_probe,
-	.bus.uevent =		vmbus_uevent,
-	.bus.dev_attrs =	vmbus_device_attrs,
+static struct bus_type  hv_bus = {
+	.name =		"vmbus",
+	.match =		vmbus_match,
+	.shutdown =		vmbus_shutdown,
+	.remove =		vmbus_remove,
+	.probe =		vmbus_probe,
+	.uevent =		vmbus_uevent,
+	.dev_attrs =	vmbus_device_attrs,
 };
 
 static const char *driver_name = "hyperv";
@@ -548,14 +543,12 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 		goto cleanup;
 	}
 
-	hv_bus.bus.name = driver_name;
-
 	/* Initialize the bus context */
 	tasklet_init(&msg_dpc, vmbus_on_msg_dpc, 0);
 	tasklet_init(&event_dpc, vmbus_on_event, 0);
 
 	/* Now, register the bus  with LDM */
-	ret = bus_register(&hv_bus.bus);
+	ret = bus_register(&hv_bus);
 	if (ret) {
 		ret = -1;
 		goto cleanup;
@@ -570,7 +563,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 		pr_err("Unable to request IRQ %d\n",
 			   pdev->irq);
 
-		bus_unregister(&hv_bus.bus);
+		bus_unregister(&hv_bus);
 
 		ret = -1;
 		goto cleanup;
@@ -586,7 +579,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 	ret = vmbus_connect();
 	if (ret) {
 		free_irq(pdev->irq, pdev);
-		bus_unregister(&hv_bus.bus);
+		bus_unregister(&hv_bus);
 		goto cleanup;
 	}
 
@@ -616,7 +609,7 @@ int vmbus_child_driver_register(struct device_driver *drv)
 	pr_info("child driver registering - name %s\n", drv->name);
 
 	/* The child driver on this vmbus */
-	drv->bus = &hv_bus.bus;
+	drv->bus = &hv_bus;
 
 	ret = driver_register(drv);
 
@@ -686,7 +679,7 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 		     atomic_inc_return(&device_num));
 
 	/* The new device belongs to this bus */
-	child_device_obj->device.bus = &hv_bus.bus; /* device->dev.bus; */
+	child_device_obj->device.bus = &hv_bus; /* device->dev.bus; */
 	child_device_obj->device.parent = &hv_pci_dev->dev;
 	child_device_obj->device.release = vmbus_device_release;
 
-- 
1.7.4.1

