Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab2HQK73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:59:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757817Ab2HQK71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:59:27 -0400
From: Jason Wang <jasowang@redhat.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH] hv: fail the probing immediately when we are not in hyperv platform
Date: Fri, 17 Aug 2012 18:52:43 +0800
Message-Id: <1345200763-48077-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We wait for about 5 seconds for the success of the hyperv registration even if
we were not in hyperv platform. This is suboptimal, so the patch check the cpuid
in the beginning of hv_acpi_init() instead of in vmbus_bus_init() to fail the
probing immediately.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/hv/hv.c        |   25 -------------------------
 drivers/hv/vmbus_drv.c |   25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 86f8885..a18ee5d 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -38,28 +38,6 @@ struct hv_context hv_context = {
 };
 
 /*
- * query_hypervisor_presence
- * - Query the cpuid for presence of windows hypervisor
- */
-static int query_hypervisor_presence(void)
-{
-	unsigned int eax;
-	unsigned int ebx;
-	unsigned int ecx;
-	unsigned int edx;
-	unsigned int op;
-
-	eax = 0;
-	ebx = 0;
-	ecx = 0;
-	edx = 0;
-	op = HVCPUID_VERSION_FEATURES;
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-
-	return ecx & HV_PRESENT_BIT;
-}
-
-/*
  * query_hypervisor_info - Get version info of the windows hypervisor
  */
 static int query_hypervisor_info(void)
@@ -159,9 +137,6 @@ int hv_init(void)
 	memset(hv_context.synic_message_page, 0,
 	       sizeof(void *) * NR_CPUS);
 
-	if (!query_hypervisor_presence())
-		goto cleanup;
-
 	max_leaf = query_hypervisor_info();
 
 	/* Write our OS info */
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4748086..a9192fd 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -753,10 +753,35 @@ static struct acpi_driver vmbus_acpi_driver = {
 	},
 };
 
+/*
+ * query_hypervisor_presence
+ * - Query the cpuid for presence of windows hypervisor
+ */
+static int query_hypervisor_presence(void)
+{
+	unsigned int eax;
+	unsigned int ebx;
+	unsigned int ecx;
+	unsigned int edx;
+	unsigned int op;
+
+	eax = 0;
+	ebx = 0;
+	ecx = 0;
+	edx = 0;
+	op = HVCPUID_VERSION_FEATURES;
+	cpuid(op, &eax, &ebx, &ecx, &edx);
+
+	return ecx & HV_PRESENT_BIT;
+}
+
 static int __init hv_acpi_init(void)
 {
 	int ret, t;
 
+	if (!query_hypervisor_presence())
+		return -ENODEV;
+
 	init_completion(&probe_event);
 
 	/*
-- 
1.7.1

