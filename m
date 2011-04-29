Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946Ab1D2VIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:08:10 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41477
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757956Ab1D2VII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:08:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 08/18] Staging: hv: Make msg_dpc a stand alone variable
Date: Fri, 29 Apr 2011 13:45:06 -0700
Message-Id: <1304109916-24874-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304109916-24874-1-git-send-email-kys@microsoft.com>
References: <1304109779-24819-1-git-send-email-kys@microsoft.com>
 <1304109916-24874-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for cleaning up (getting rid of) of the hv_bus structure,
make msg_dpc a stand alone variable.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 4106dd3..38bfff0 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -42,10 +42,11 @@
 
 static struct pci_dev *hv_pci_dev;
 
+static struct tasklet_struct msg_dpc;
+
 /* Main vmbus driver data structure */
 struct hv_bus {
 	struct bus_type bus;
-	struct tasklet_struct msg_dpc;
 	struct tasklet_struct event_dpc;
 };
 
@@ -515,7 +516,7 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	/* Schedules a dpc if necessary */
 	if (ret > 0) {
 		if (test_bit(0, (unsigned long *)&ret))
-			tasklet_schedule(&hv_bus.msg_dpc);
+			tasklet_schedule(&msg_dpc);
 
 		if (test_bit(1, (unsigned long *)&ret))
 			tasklet_schedule(&hv_bus.event_dpc);
@@ -550,7 +551,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 	hv_bus.bus.name = driver_name;
 
 	/* Initialize the bus context */
-	tasklet_init(&hv_bus.msg_dpc, vmbus_on_msg_dpc, 0);
+	tasklet_init(&msg_dpc, vmbus_on_msg_dpc, 0);
 	tasklet_init(&hv_bus.event_dpc, vmbus_on_event, 0);
 
 	/* Now, register the bus  with LDM */
-- 
1.7.4.1

