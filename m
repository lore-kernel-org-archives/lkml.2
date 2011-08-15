Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1HOVwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:52:21 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:57475
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752966Ab1HOVwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:52:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 7/8] Staging: hv: vmbus: Fix a bug in error handling in vmbus_bus_init()
Date: Mon, 15 Aug 2011 15:12:06 -0700
Message-Id: <1313446327-10650-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313446327-10650-1-git-send-email-kys@microsoft.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
 <1313446327-10650-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in error handling in vmbus_bus_init().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index f20ab9a..0b0bff3 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -463,8 +463,10 @@ static int vmbus_bus_init(int irq)
 	tasklet_init(&event_dpc, vmbus_on_event, 0);
 
 	ret = bus_register(&hv_bus);
-	if (ret)
+	if (ret) {
+		hv_cleanup();
 		return ret;
+	}
 
 	ret = request_irq(irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
 			driver_name, hv_acpi_dev);
@@ -473,6 +475,7 @@ static int vmbus_bus_init(int irq)
 		pr_err("Unable to request IRQ %d\n",
 			   irq);
 
+		hv_cleanup();
 		bus_unregister(&hv_bus);
 
 		return ret;
@@ -487,6 +490,7 @@ static int vmbus_bus_init(int irq)
 	on_each_cpu(hv_synic_init, (void *)&vector, 1);
 	ret = vmbus_connect();
 	if (ret) {
+		hv_cleanup();
 		free_irq(irq, hv_acpi_dev);
 		bus_unregister(&hv_bus);
 		return ret;
-- 
1.7.4.1

