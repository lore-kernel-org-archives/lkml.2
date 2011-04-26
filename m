Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1DZQNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:13:10 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:45471
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754122Ab1DZQIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:08:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 18/25] Staging: hv: Get rid of struct hv_bus
Date: Tue, 26 Apr 2011 09:20:35 -0700
Message-Id: <1303834842-5022-18-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834842-5022-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/vmbus_drv.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index a3a7741..515311c 100644
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
@@ -405,14 +400,14 @@ static void vmbus_device_release(struct device *device)
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
@@ -550,14 +545,14 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 		goto cleanup;
 	}
 
-	hv_bus.bus.name = driver_name;
+	hv_bus.name = driver_name;
 
 	/* Initialize the bus context */
 	tasklet_init(&msg_dpc, vmbus_on_msg_dpc, 0);
 	tasklet_init(&event_dpc, vmbus_on_event, 0);
 
 	/* Now, register the bus  with LDM */
-	ret = bus_register(&hv_bus.bus);
+	ret = bus_register(&hv_bus);
 	if (ret) {
 		ret = -1;
 		goto cleanup;
@@ -572,7 +567,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 		pr_err("Unable to request IRQ %d\n",
 			   pdev->irq);
 
-		bus_unregister(&hv_bus.bus);
+		bus_unregister(&hv_bus);
 
 		ret = -1;
 		goto cleanup;
@@ -588,7 +583,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 	ret = vmbus_connect();
 	if (ret) {
 		free_irq(pdev->irq, pdev);
-		bus_unregister(&hv_bus.bus);
+		bus_unregister(&hv_bus);
 		goto cleanup;
 	}
 
@@ -618,7 +613,7 @@ int vmbus_child_driver_register(struct device_driver *drv)
 	pr_info("child driver registering - name %s\n", drv->name);
 
 	/* The child driver on this vmbus */
-	drv->bus = &hv_bus.bus;
+	drv->bus = &hv_bus;
 
 	ret = driver_register(drv);
 
@@ -688,7 +683,7 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 		     atomic_inc_return(&device_num));
 
 	/* The new device belongs to this bus */
-	child_device_obj->device.bus = &hv_bus.bus; /* device->dev.bus; */
+	child_device_obj->device.bus = &hv_bus; /* device->dev.bus; */
 	child_device_obj->device.parent = &hv_pci_dev->dev;
 	child_device_obj->device.release = vmbus_device_release;
 
-- 
1.7.4.1

