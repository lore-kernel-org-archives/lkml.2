Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1FYRm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 13:42:56 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:61867 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778Ab1FYRmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 13:42:52 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de,
        Daniel Drake <dsd@laptop.org>
Subject: [PATCH v3 02/11] x86, olpc: Move CS5536-related constants to cs5535.h
Date: Sat, 25 Jun 2011 17:34:09 +0100
Message-Id: <1309019658-1712-3-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309019658-1712-1-git-send-email-dsd@laptop.org>
References: <1309019658-1712-1-git-send-email-dsd@laptop.org>
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=Oj0W9hJGQlwA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=In_Hgl4hAAAA:8 a=mCWTS24Azi9qZ2CYigQA:9 a=d4CUUju0HPYA:10 a=ro211Ng2IWAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move these definitions into the relevant header file.
This was requested in the review of the upcoming XO-1 suspend/resume code.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/platform/olpc/olpc-xo1.c |   26 ++++++++------------------
 include/linux/cs5535.h            |   21 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index ab81fb2..a63e948 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1.c
@@ -12,6 +12,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/cs5535.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -22,17 +23,6 @@
 
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
 
@@ -41,17 +31,17 @@ static void xo1_power_off(void)
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
1.7.5.4

