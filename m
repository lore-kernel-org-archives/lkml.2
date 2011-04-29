Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab1D2UdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:33:00 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41663
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933810Ab1D2Uc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:32:29 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 06/18] Staging: hv: Properly handle errors in hv_pci_probe()
Date: Fri, 29 Apr 2011 13:45:04 -0700
Message-Id: <1304109916-24874-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304109916-24874-1-git-send-email-kys@microsoft.com>
References: <1304109779-24819-1-git-send-email-kys@microsoft.com>
 <1304109916-24874-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much of the vmbus driver initialization is done within the hv_pci_probe()
function. Properly handle errors in hv_pci_probe so that we can
appropriately deal with loading of the vmbus driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 5f88249..8663f64 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -54,6 +54,8 @@ EXPORT_SYMBOL(vmbus_loglevel);
 	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
 	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
 
+static int pci_probe_error;
+static struct completion probe_event;
 
 static void get_channel_info(struct hv_device *device,
 			     struct hv_device_info *info)
@@ -722,19 +724,19 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 static int __devinit hv_pci_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	int err;
-
 	hv_pci_dev = pdev;
 
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
+	pci_probe_error = pci_enable_device(pdev);
+	if (pci_probe_error)
+		goto probe_cleanup;
 
-	err = vmbus_bus_init(pdev);
-	if (err)
+	pci_probe_error = vmbus_bus_init(pdev);
+	if (pci_probe_error)
 		pci_disable_device(pdev);
 
-	return err;
+probe_cleanup:
+	complete(&probe_event);
+	return pci_probe_error;
 }
 
 /*
@@ -757,7 +759,21 @@ static struct pci_driver hv_bus_driver = {
 
 static int __init hv_pci_init(void)
 {
-	return pci_register_driver(&hv_bus_driver);
+	int ret;
+	init_completion(&probe_event);
+	ret = pci_register_driver(&hv_bus_driver);
+	if (ret)
+		return ret;
+	/*
+	 * All the vmbus initialization occurs within the
+	 * hv_pci_probe() function. Wait for hv_pci_probe()
+	 * to complete.
+	 */
+	wait_for_completion(&probe_event);
+
+	if (pci_probe_error)
+		pci_unregister_driver(&hv_bus_driver);
+	return pci_probe_error;
 }
 
 
-- 
1.7.4.1

