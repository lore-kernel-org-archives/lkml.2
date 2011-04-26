Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1DZQJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:09:37 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33098
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754378Ab1DZQIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:08:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 14/25] Staging: hv: Properly handle errors in hv_pci_probe()
Date: Tue, 26 Apr 2011 09:20:31 -0700
Message-Id: <1303834842-5022-14-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834842-5022-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
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
index 248dc8a..a2acbce 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -54,6 +54,8 @@ EXPORT_SYMBOL(vmbus_loglevel);
 	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
 	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
 
+static int pci_probe_error;
+static struct completion probe_event;
 
 static void get_channel_info(struct hv_device *device,
 			     struct hv_device_info *info)
@@ -732,19 +734,19 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
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
@@ -767,7 +769,21 @@ static struct pci_driver hv_bus_driver = {
 
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

