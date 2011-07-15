Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1GOUVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 16:21:09 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47805
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751639Ab1GOUVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 16:21:07 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: vmbus: Don't wait indefinitely for IRQ resouces
Date: Fri, 15 Jul 2011 13:38:56 -0700
Message-Id: <1310762336-30795-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an attempt is made to load the vmbus driver on a non-Hyper-V platform,
the load operation will hang since we currently wait indefinitely to 
retrieve the IRQ information. This is done in the context of an acpi callback
context (which will obviously not happen when this driver is
loaded on a non-Hyper-V platform). This patch fixes the problem. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 433be51..b382829 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -702,7 +702,7 @@ static struct acpi_driver vmbus_acpi_driver = {
 
 static int __init hv_acpi_init(void)
 {
-	int ret;
+	int ret, t;
 
 	init_completion(&probe_event);
 
@@ -715,16 +715,25 @@ static int __init hv_acpi_init(void)
 	if (ret)
 		return ret;
 
-	wait_for_completion(&probe_event);
+	t = wait_for_completion_timeout(&probe_event, 5*HZ);
+	if (t == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
 
 	if (irq <= 0) {
-		acpi_bus_unregister_driver(&vmbus_acpi_driver);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto cleanup;
 	}
 
 	ret = vmbus_bus_init(irq);
 	if (ret)
-		acpi_bus_unregister_driver(&vmbus_acpi_driver);
+		goto cleanup;
+
+	return 0;
+
+cleanup:
+	acpi_bus_unregister_driver(&vmbus_acpi_driver);
 	return ret;
 }
 
-- 
1.7.4.1

