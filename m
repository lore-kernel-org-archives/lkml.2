Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2LAOYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:24:18 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41340
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 22/28] Drivers: hv: Manage event tasklets on per-cpu basis
Date: Sat,  1 Dec 2012 06:46:53 -0800
Message-Id: <1354373219-31374-22-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can potentially take vmbus interrupts on any CPU, make the
tasklets per-CPU.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv.c           |   12 ++++++++++++
 drivers/hv/hyperv_vmbus.h |    6 ++++++
 drivers/hv/vmbus_drv.c    |    4 +---
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index e989c6fd..363532a 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -27,6 +27,7 @@
 #include <linux/vmalloc.h>
 #include <linux/hyperv.h>
 #include <linux/version.h>
+#include <linux/interrupt.h>
 #include <asm/hyperv.h>
 #include "hyperv_vmbus.h"
 
@@ -137,6 +138,8 @@ int hv_init(void)
 	       sizeof(void *) * NR_CPUS);
 	memset(hv_context.vp_index, 0,
 	       sizeof(int) * NR_CPUS);
+	memset(hv_context.event_dpc, 0,
+	       sizeof(void *) * NR_CPUS);
 
 	max_leaf = query_hypervisor_info();
 
@@ -285,6 +288,15 @@ void hv_synic_init(void *irqarg)
 	/* Check the version */
 	rdmsrl(HV_X64_MSR_SVERSION, version);
 
+	hv_context.event_dpc[cpu] = (struct tasklet_struct *)
+					kmalloc(sizeof(struct tasklet_struct),
+						GFP_ATOMIC);
+	if (hv_context.event_dpc[cpu] == NULL) {
+		pr_err("Unable to allocate event dpc\n");
+		goto cleanup;
+	}
+	tasklet_init(hv_context.event_dpc[cpu], vmbus_on_event, cpu);
+
 	hv_context.synic_message_page[cpu] =
 		(void *)get_zeroed_page(GFP_ATOMIC);
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 9135a6f..becb106 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -504,6 +504,12 @@ struct hv_context {
 	 * Linux cpuid 'a'.
 	 */
 	u32 vp_index[NR_CPUS];
+	/*
+	 * Starting with win8, we can take channel interrupts on any CPU;
+	 * we will manage the tasklet that handles events on a per CPU
+	 * basis.
+	 */
+	struct tasklet_struct *event_dpc[NR_CPUS];
 };
 
 extern struct hv_context hv_context;
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4c92337..6e4f857 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -41,7 +41,6 @@
 static struct acpi_device  *hv_acpi_dev;
 
 static struct tasklet_struct msg_dpc;
-static struct tasklet_struct event_dpc;
 static struct completion probe_event;
 static int irq;
 
@@ -483,7 +482,7 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	}
 
 	if (handled)
-		tasklet_schedule(&event_dpc);
+		tasklet_schedule(hv_context.event_dpc[cpu]);
 
 
 	page_addr = hv_context.synic_message_page[cpu];
@@ -523,7 +522,6 @@ static int vmbus_bus_init(int irq)
 	}
 
 	tasklet_init(&msg_dpc, vmbus_on_msg_dpc, 0);
-	tasklet_init(&event_dpc, vmbus_on_event, 0);
 
 	ret = bus_register(&hv_bus);
 	if (ret)
-- 
1.7.4.1

