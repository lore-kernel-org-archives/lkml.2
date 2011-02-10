Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1BJRqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:46:36 -0500
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:54314 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab1BJRqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:46:35 -0500
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: dilinger@queued.net
Subject: [PATCH] OLPC: Move CS5536-related constants to cs5535.h
Message-Id: <20110210171009.7D8399D401D@zog.reactivated.net>
Date: Thu, 10 Feb 2011 17:10:09 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=-l7EYOyYLekA:10 a=Op-mwl0xAAAA:8 a=7oiXwmBI1aQW3n1badgA:9 a=cLS-Oh1gylpJlPY6pe3spGo_6_kA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move these definitions into the relevant header file.
This was requested in the review of the upcoming XO-1 suspend/resume code.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/platform/olpc/olpc-xo1.c |   26 ++++++++------------------
 include/linux/cs5535.h            |   21 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index 1277756..a2210ca 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1.c
@@ -12,6 +12,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/cs5535.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -21,17 +22,6 @@
 
 #define DRV_NAME "olpc-xo1"
 
-/* PMC registers (PMS block) */
-#define PM_SCLK		0x10
-#define PM_IN_SLPCTL	0x20
-#define PM_WKXD		0x34
-#define PM_WKD		0x30
-#define PM_SSC		0x54
-
-/* PM registers (ACPI block) */
-#define PM1_CNT		0x08
-#define PM_GPE0_STS	0x18
-
 static unsigned long acpi_base;
 static unsigned long pms_base;
 
@@ -40,17 +30,17 @@ static void xo1_power_off(void)
 	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
 
 	/* Enable all of these controls with 0 delay */
-	outl(0x40000000, pms_base + PM_SCLK);
-	outl(0x40000000, pms_base + PM_IN_SLPCTL);
-	outl(0x40000000, pms_base + PM_WKXD);
-	outl(0x40000000, pms_base + PM_WKD);
+	outl(0x40000000, pms_base + CS5536_PM_SCLK);
+	outl(0x40000000, pms_base + CS5536_PM_IN_SLPCTL);
+	outl(0x40000000, pms_base + CS5536_PM_WKXD);
+	outl(0x40000000, pms_base + CS5536_PM_WKD);
 
 	/* Clear status bits (possibly unnecessary) */
-	outl(0x0002ffff, pms_base  + PM_SSC);
-	outl(0xffffffff, acpi_base + PM_GPE0_STS);
+	outl(0x0002ffff, pms_base  + CS5536_PM_SSC);
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
 
 	/* Write SLP_EN bit to start the machinery */
-	outl(0x00002000, acpi_base + PM1_CNT);
+	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
 }
 
 static int __devinit olpc_xo1_probe(struct platform_device *pdev)
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index 6fe2114..e46b8b0 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -49,6 +49,27 @@
 #define LBAR_ACPI_SIZE		0x40
 #define LBAR_PMS_SIZE		0x80
 
+/*
+ * PMC registers (PMS block)
+ * It is only safe to access these registers as dword accesses.
+ * See CS5536 Specification Update erratas 17 & 18
+ */
+#define CS5536_PM_SCLK		0x10
+#define CS5536_PM_IN_SLPCTL	0x20
+#define CS5536_PM_WKXD		0x34
+#define CS5536_PM_WKD		0x30
+#define CS5536_PM_SSC		0x54
+
+/*
+ * PM registers (ACPI block)
+ * It is only safe to access these registers as dword accesses.
+ * See CS5536 Specification Update erratas 17 & 18
+ */
+#define CS5536_PM1_STS		0x00
+#define CS5536_PM1_EN		0x02
+#define CS5536_PM1_CNT		0x08
+#define CS5536_PM_GPE0_STS	0x18
+
 /* VSA2 magic values */
 #define VSA_VRC_INDEX		0xAC1C
 #define VSA_VRC_DATA		0xAC1E
-- 
1.7.4

