Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031269Ab2CAPJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 10:09:43 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:52340
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031193Ab2CAPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 10:09:41 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M07ORV-01-60S-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] iommu/amd: Split amd_iommu_init function
Date: Thu, 1 Mar 2012 16:09:28 +0100
Message-ID: <1330614568-23924-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware-initializtion part of the AMD IOMMU driver is
split out into a seperate function. This function can now be
called either from amd_iommu_init() itself or any other
place if the hardware needs to be ready earlier. This will
be used to implement interrupt remapping for AMD.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |  123 +++++++++++++++++++++++++--------------
 include/linux/amd-iommu.h      |    2 +-
 2 files changed, 80 insertions(+), 45 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index bdea288..75653da 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1424,10 +1424,40 @@ static struct syscore_ops amd_iommu_syscore_ops = {
 	.resume = amd_iommu_resume,
 };
 
+static void __init free_on_init_error(void)
+{
+	amd_iommu_uninit_devices();
+
+	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
+		   get_order(MAX_DOMAIN_ID/8));
+
+	free_pages((unsigned long)amd_iommu_rlookup_table,
+		   get_order(rlookup_table_size));
+
+	free_pages((unsigned long)amd_iommu_alias_table,
+		   get_order(alias_table_size));
+
+	free_pages((unsigned long)amd_iommu_dev_table,
+		   get_order(dev_table_size));
+
+	free_iommu_all();
+
+	free_unity_maps();
+
+#ifdef CONFIG_GART_IOMMU
+	/*
+	 * We failed to initialize the AMD IOMMU - try fallback to GART
+	 * if possible.
+	 */
+	gart_iommu_init();
+
+#endif
+}
+
 /*
- * This is the core init function for AMD IOMMU hardware in the system.
- * This function is called from the generic x86 DMA layer initialization
- * code.
+ * This is the hardware init function for AMD IOMMU in the system.
+ * This function is called either from amd_iommu_init or from the interrupt
+ * remapping setup code.
  *
  * This function basically parses the ACPI table for AMD IOMMU (IVRS)
  * three times:
@@ -1446,16 +1476,21 @@ static struct syscore_ops amd_iommu_syscore_ops = {
  *		remapping requirements parsed out of the ACPI table in
  *		this last pass.
  *
- * After that the hardware is initialized and ready to go. In the last
- * step we do some Linux specific things like registering the driver in
- * the dma_ops interface and initializing the suspend/resume support
- * functions. Finally it prints some information about AMD IOMMUs and
- * the driver state and enables the hardware.
+ * After everything is set up the IOMMUs are enabled and the necessary
+ * hotplug and suspend notifiers are registered.
  */
-static int __init amd_iommu_init(void)
+int __init amd_iommu_init_hardware(void)
 {
 	int i, ret = 0;
 
+	if (!amd_iommu_detected)
+		return -ENODEV;
+
+	if (amd_iommu_dev_table != NULL) {
+		/* Hardware already initialized */
+		return 0;
+	}
+
 	/*
 	 * First parse ACPI tables to find the largest Bus/Dev/Func
 	 * we need to handle. Upon this information the shared data
@@ -1472,9 +1507,8 @@ static int __init amd_iommu_init(void)
 	alias_table_size   = tbl_size(ALIAS_TABLE_ENTRY_SIZE);
 	rlookup_table_size = tbl_size(RLOOKUP_TABLE_ENTRY_SIZE);
 
-	ret = -ENOMEM;
-
 	/* Device table - directly used by all IOMMUs */
+	ret = -ENOMEM;
 	amd_iommu_dev_table = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 				      get_order(dev_table_size));
 	if (amd_iommu_dev_table == NULL)
@@ -1546,20 +1580,46 @@ static int __init amd_iommu_init(void)
 
 	enable_iommus();
 
+	amd_iommu_init_notifier();
+
+	register_syscore_ops(&amd_iommu_syscore_ops);
+
+out:
+	return ret;
+
+free:
+	free_on_init_error();
+
+	return ret;
+}
+
+/*
+ * This is the core init function for AMD IOMMU hardware in the system.
+ * This function is called from the generic x86 DMA layer initialization
+ * code.
+ *
+ * The function calls amd_iommu_init_hardware() to setup and enable the
+ * IOMMU hardware if this has not happened yet. After that the driver
+ * registers for the DMA-API and for the IOMMU-API as necessary.
+ */
+static int __init amd_iommu_init(void)
+{
+	int ret = 0;
+
+	ret = amd_iommu_init_hardware();
+	if (ret)
+		goto out;
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
 		ret = amd_iommu_init_dma_ops();
 
 	if (ret)
-		goto free_disable;
+		goto free;
 
 	amd_iommu_init_api();
 
-	amd_iommu_init_notifier();
-
-	register_syscore_ops(&amd_iommu_syscore_ops);
-
 	if (iommu_pass_through)
 		goto out;
 
@@ -1569,39 +1629,14 @@ static int __init amd_iommu_init(void)
 		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
 
 	x86_platform.iommu_shutdown = disable_iommus;
+
 out:
 	return ret;
 
-free_disable:
-	disable_iommus();
-
 free:
-	amd_iommu_uninit_devices();
-
-	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
-		   get_order(MAX_DOMAIN_ID/8));
-
-	free_pages((unsigned long)amd_iommu_rlookup_table,
-		   get_order(rlookup_table_size));
-
-	free_pages((unsigned long)amd_iommu_alias_table,
-		   get_order(alias_table_size));
-
-	free_pages((unsigned long)amd_iommu_dev_table,
-		   get_order(dev_table_size));
-
-	free_iommu_all();
-
-	free_unity_maps();
-
-#ifdef CONFIG_GART_IOMMU
-	/*
-	 * We failed to initialize the AMD IOMMU - try fallback to GART
-	 * if possible.
-	 */
-	gart_iommu_init();
+	disable_iommus();
 
-#endif
+	free_on_init_error();
 
 	goto out;
 }
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index ef00610..15f6b9e 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -28,7 +28,7 @@ struct task_struct;
 struct pci_dev;
 
 extern int amd_iommu_detect(void);
-
+extern int amd_iommu_init_hardware(void);
 
 /**
  * amd_iommu_enable_device_erratum() - Enable erratum workaround for device
-- 
1.7.5.4


