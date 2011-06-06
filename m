Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab1FFWhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:37:51 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58089
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758204Ab1FFWfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 44/49] Staging: hv: vmbus: Cleanup error handling in vmbus_bus_init()
Date: Mon,  6 Jun 2011 15:50:08 -0700
Message-Id: <1307400613-13234-44-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup error handling in vmbus_bus_init().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index a3c99f1..be158be 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -535,7 +535,7 @@ static int vmbus_bus_init(int irq)
 	ret = hv_init();
 	if (ret != 0) {
 		pr_err("Unable to initialize the hypervisor - 0x%x\n", ret);
-		goto cleanup;
+		return ret;
 	}
 
 	/* Initialize the bus context */
@@ -544,10 +544,8 @@ static int vmbus_bus_init(int irq)
 
 	/* Now, register the bus  with LDM */
 	ret = bus_register(&hv_bus);
-	if (ret) {
-		ret = -1;
-		goto cleanup;
-	}
+	if (ret)
+		return ret;
 
 	/* Get the interrupt resource */
 	ret = request_irq(irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
@@ -559,8 +557,7 @@ static int vmbus_bus_init(int irq)
 
 		bus_unregister(&hv_bus);
 
-		ret = -1;
-		goto cleanup;
+		return ret;
 	}
 
 	vector = IRQ0_VECTOR + irq;
@@ -574,14 +571,13 @@ static int vmbus_bus_init(int irq)
 	if (ret) {
 		free_irq(irq, hv_acpi_dev);
 		bus_unregister(&hv_bus);
-		goto cleanup;
+		return ret;
 	}
 
 
 	vmbus_request_offers();
 
-cleanup:
-	return ret;
+	return 0;
 }
 
 /**
-- 
1.7.4.1

