Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2GEMn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:43:28 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:6076 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932530Ab2GEMhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPG-02-6NJ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/28] iommu/amd: Convert iommu initialization to state machine
Date: Thu, 5 Jul 2012 14:36:31 +0200
Message-ID: <1341491808-23083-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This step makes it very easy to keep track about the current
intialization state of the iommu driver. With this change we
can initialize the IOMMU hardware to a point where it can
remap interrupts and later resume the initializion to enable
dma remapping.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |  174 +++++++++++++++++++++++++---------------
 1 file changed, 109 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 0afd89c..8d1780c 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -193,7 +193,23 @@ static u32 rlookup_table_size;	/* size if the rlookup table */
  */
 extern void iommu_flush_all_caches(struct amd_iommu *iommu);
 
+enum iommu_init_state {
+	IOMMU_START_STATE,
+	IOMMU_IVRS_DETECTED,
+	IOMMU_ACPI_FINISHED,
+	IOMMU_ENABLED,
+	IOMMU_PCI_INIT,
+	IOMMU_INTERRUPTS_EN,
+	IOMMU_DMA_OPS,
+	IOMMU_INITIALIZED,
+	IOMMU_NOT_FOUND,
+	IOMMU_INIT_ERROR,
+};
+
+enum iommu_init_state init_state = IOMMU_START_STATE;
+
 static int amd_iommu_enable_interrupts(void);
+static int __init iommu_go_to_state(enum iommu_init_state state);
 
 static inline void update_last_devid(u16 devid)
 {
@@ -1107,7 +1123,7 @@ static void print_iommu_info(void)
 	}
 }
 
-static int amd_iommu_init_pci(void)
+static int __init amd_iommu_init_pci(void)
 {
 	struct amd_iommu *iommu;
 	int ret = 0;
@@ -1396,9 +1412,6 @@ static void early_enable_iommus(void)
 		iommu_enable(iommu);
 		iommu_flush_all_caches(iommu);
 	}
-
-	x86_platform.iommu_shutdown = disable_iommus;
-
 }
 
 static void enable_iommus_v2(void)
@@ -1522,11 +1535,6 @@ static int __init early_amd_iommu_init(void)
 	if (!amd_iommu_detected)
 		return -ENODEV;
 
-	if (amd_iommu_dev_table != NULL) {
-		/* Hardware already initialized */
-		return 0;
-	}
-
 	status = acpi_get_table_with_size("IVRS", 0, &ivrs_base, &ivrs_size);
 	if (status == AE_NOT_FOUND)
 		return -ENODEV;
@@ -1541,7 +1549,8 @@ static int __init early_amd_iommu_init(void)
 	 * we need to handle. Upon this information the shared data
 	 * structures for the IOMMUs in the system will be allocated
 	 */
-	if (find_last_devid_acpi(ivrs_base))
+	ret = find_last_devid_acpi(ivrs_base);
+	if (ret)
 		goto out;
 
 	dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE);
@@ -1562,20 +1571,20 @@ static int __init early_amd_iommu_init(void)
 	amd_iommu_alias_table = (void *)__get_free_pages(GFP_KERNEL,
 			get_order(alias_table_size));
 	if (amd_iommu_alias_table == NULL)
-		goto free;
+		goto out;
 
 	/* IOMMU rlookup table - find the IOMMU for a specific device */
 	amd_iommu_rlookup_table = (void *)__get_free_pages(
 			GFP_KERNEL | __GFP_ZERO,
 			get_order(rlookup_table_size));
 	if (amd_iommu_rlookup_table == NULL)
-		goto free;
+		goto out;
 
 	amd_iommu_pd_alloc_bitmap = (void *)__get_free_pages(
 					    GFP_KERNEL | __GFP_ZERO,
 					    get_order(MAX_DOMAIN_ID/8));
 	if (amd_iommu_pd_alloc_bitmap == NULL)
-		goto free;
+		goto out;
 
 	/* init the device table */
 	init_device_table();
@@ -1600,11 +1609,11 @@ static int __init early_amd_iommu_init(void)
 	 */
 	ret = init_iommu_all(ivrs_base);
 	if (ret)
-		goto free;
+		goto out;
 
 	ret = init_memory_definitions(ivrs_base);
 	if (ret)
-		goto free;
+		goto out;
 
 out:
 	/* Don't leak any ACPI memory */
@@ -1612,30 +1621,6 @@ out:
 	ivrs_base = NULL;
 
 	return ret;
-
-free:
-	free_on_init_error();
-
-	goto out;
-}
-
-int amd_iommu_init_hardware(void)
-{
-	int ret = 0;
-
-	ret = early_amd_iommu_init();
-	if (ret)
-		return ret;
-
-	ret = amd_iommu_init_pci();
-	if (ret)
-		return ret;
-
-	enable_iommus();
-
-	register_syscore_ops(&amd_iommu_syscore_ops);
-
-	return ret;
 }
 
 static int amd_iommu_enable_interrupts(void)
@@ -1692,42 +1677,99 @@ static int amd_iommu_init_dma(void)
 	return 0;
 }
 
-/*
- * This is the core init function for AMD IOMMU hardware in the system.
- * This function is called from the generic x86 DMA layer initialization
- * code.
+/****************************************************************************
  *
- * The function calls amd_iommu_init_hardware() to setup and enable the
- * IOMMU hardware if this has not happened yet. After that the driver
- * registers for the DMA-API and for the IOMMU-API as necessary.
- */
-static int __init amd_iommu_init(void)
+ * AMD IOMMU Initialization State Machine
+ *
+ ****************************************************************************/
+
+static int __init state_next(void)
 {
 	int ret = 0;
 
-	ret = amd_iommu_init_hardware();
-	if (ret)
-		goto out;
+	switch (init_state) {
+	case IOMMU_START_STATE:
+		if (!detect_ivrs()) {
+			init_state	= IOMMU_NOT_FOUND;
+			ret		= -ENODEV;
+		} else {
+			init_state	= IOMMU_IVRS_DETECTED;
+		}
+		break;
+	case IOMMU_IVRS_DETECTED:
+		ret = early_amd_iommu_init();
+		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_ACPI_FINISHED;
+		break;
+	case IOMMU_ACPI_FINISHED:
+		early_enable_iommus();
+		register_syscore_ops(&amd_iommu_syscore_ops);
+		x86_platform.iommu_shutdown = disable_iommus;
+		init_state = IOMMU_ENABLED;
+		break;
+	case IOMMU_ENABLED:
+		ret = amd_iommu_init_pci();
+		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_PCI_INIT;
+		enable_iommus_v2();
+		break;
+	case IOMMU_PCI_INIT:
+		ret = amd_iommu_enable_interrupts();
+		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_INTERRUPTS_EN;
+		break;
+	case IOMMU_INTERRUPTS_EN:
+		ret = amd_iommu_init_dma();
+		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_DMA_OPS;
+		break;
+	case IOMMU_DMA_OPS:
+		init_state = IOMMU_INITIALIZED;
+		break;
+	case IOMMU_INITIALIZED:
+		/* Nothing to do */
+		break;
+	case IOMMU_NOT_FOUND:
+	case IOMMU_INIT_ERROR:
+		/* Error states => do nothing */
+		ret = -EINVAL;
+		break;
+	default:
+		/* Unknown state */
+		BUG();
+	}
 
-	ret = amd_iommu_enable_interrupts();
-	if (ret)
-		goto free;
+	return ret;
+}
 
-	ret = amd_iommu_init_dma();
-	if (ret)
-		goto free;
+static int __init iommu_go_to_state(enum iommu_init_state state)
+{
+	int ret = 0;
 
-	amd_iommu_init_api();
+	while (init_state != state) {
+		ret = state_next();
+		if (init_state == IOMMU_NOT_FOUND ||
+		    init_state == IOMMU_INIT_ERROR)
+			break;
+	}
 
-out:
 	return ret;
+}
 
-free:
-	disable_iommus();
 
-	free_on_init_error();
 
-	goto out;
+/*
+ * This is the core init function for AMD IOMMU hardware in the system.
+ * This function is called from the generic x86 DMA layer initialization
+ * code.
+ */
+static int __init amd_iommu_init(void)
+{
+	int ret;
+
+	ret = iommu_go_to_state(IOMMU_INITIALIZED);
+	if (ret) {
+		disable_iommus();
+		free_on_init_error();
+	}
+
+	return ret;
 }
 
 /****************************************************************************
@@ -1739,6 +1781,7 @@ free:
  ****************************************************************************/
 int __init amd_iommu_detect(void)
 {
+	int ret;
 
 	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
 		return -ENODEV;
@@ -1746,8 +1789,9 @@ int __init amd_iommu_detect(void)
 	if (amd_iommu_disabled)
 		return -ENODEV;
 
-	if (!detect_ivrs())
-		return -ENODEV;
+	ret = iommu_go_to_state(IOMMU_IVRS_DETECTED);
+	if (ret)
+		return ret;
 
 	amd_iommu_detected = true;
 	iommu_detected = 1;
-- 
1.7.9.5


