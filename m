Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2GKNrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:47:49 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:20823
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757716Ab2GKNjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LD-01-AXE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/27] iommu/amd: Use acpi_get_table instead of acpi_table_parse
Date: Wed, 11 Jul 2012 15:38:49 +0200
Message-ID: <1342013952-10174-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easier to propagate errors while parsing the
IVRS table and makes the amd_iommu_init_err hack obsolete.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |  118 ++++++++++++++++++++++------------------
 1 file changed, 66 insertions(+), 52 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 1b3f699..de11b98 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -26,6 +26,8 @@
 #include <linux/msi.h>
 #include <linux/amd-iommu.h>
 #include <linux/export.h>
+#include <linux/acpi.h>
+#include <acpi/acpi.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -122,7 +124,7 @@ struct ivmd_header {
 
 bool amd_iommu_dump;
 
-static int __initdata amd_iommu_detected;
+static bool amd_iommu_detected;
 static bool __initdata amd_iommu_disabled;
 
 u16 amd_iommu_last_bdf;			/* largest PCI device id we have
@@ -149,11 +151,6 @@ bool amd_iommu_v2_present __read_mostly;
 bool amd_iommu_force_isolation __read_mostly;
 
 /*
- * The ACPI table parsing functions set this variable on an error
- */
-static int __initdata amd_iommu_init_err;
-
-/*
  * List of protection domains - used during resume
  */
 LIST_HEAD(amd_iommu_pd_list);
@@ -457,11 +454,9 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table)
 	 */
 	for (i = 0; i < table->length; ++i)
 		checksum += p[i];
-	if (checksum != 0) {
+	if (checksum != 0)
 		/* ACPI table corrupt */
-		amd_iommu_init_err = -ENODEV;
-		return 0;
-	}
+		return -ENODEV;
 
 	p += IVRS_HEADER_LENGTH;
 
@@ -1087,16 +1082,12 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 				    h->mmio_phys);
 
 			iommu = kzalloc(sizeof(struct amd_iommu), GFP_KERNEL);
-			if (iommu == NULL) {
-				amd_iommu_init_err = -ENOMEM;
-				return 0;
-			}
+			if (iommu == NULL)
+				return -ENOMEM;
 
 			ret = init_iommu_one(iommu, h);
-			if (ret) {
-				amd_iommu_init_err = ret;
-				return 0;
-			}
+			if (ret)
+				return ret;
 			break;
 		default:
 			break;
@@ -1477,9 +1468,15 @@ static void __init free_on_init_error(void)
  */
 int __init amd_iommu_init_hardware(void)
 {
+	struct acpi_table_header *ivrs_base;
+	acpi_size ivrs_size;
+	acpi_status status;
 	int i, ret = 0;
 
-	if (!amd_iommu_detected)
+	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
+		return -ENODEV;
+
+	if (amd_iommu_disabled || !amd_iommu_detected)
 		return -ENODEV;
 
 	if (amd_iommu_dev_table != NULL) {
@@ -1487,16 +1484,21 @@ int __init amd_iommu_init_hardware(void)
 		return 0;
 	}
 
+	status = acpi_get_table_with_size("IVRS", 0, &ivrs_base, &ivrs_size);
+	if (status == AE_NOT_FOUND)
+		return -ENODEV;
+	else if (ACPI_FAILURE(status)) {
+		const char *err = acpi_format_exception(status);
+		pr_err("AMD-Vi: IVRS table error: %s\n", err);
+		return -EINVAL;
+	}
+
 	/*
 	 * First parse ACPI tables to find the largest Bus/Dev/Func
 	 * we need to handle. Upon this information the shared data
 	 * structures for the IOMMUs in the system will be allocated
 	 */
-	if (acpi_table_parse("IVRS", find_last_devid_acpi) != 0)
-		return -ENODEV;
-
-	ret = amd_iommu_init_err;
-	if (ret)
+	if (find_last_devid_acpi(ivrs_base))
 		goto out;
 
 	dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE);
@@ -1553,22 +1555,13 @@ int __init amd_iommu_init_hardware(void)
 	 * now the data structures are allocated and basically initialized
 	 * start the real acpi table scan
 	 */
-	ret = -ENODEV;
-	if (acpi_table_parse("IVRS", init_iommu_all) != 0)
-		goto free;
-
-	if (amd_iommu_init_err) {
-		ret = amd_iommu_init_err;
-		goto free;
-	}
-
-	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
+	ret = init_iommu_all(ivrs_base);
+	if (ret)
 		goto free;
 
-	if (amd_iommu_init_err) {
-		ret = amd_iommu_init_err;
+	ret = init_memory_definitions(ivrs_base);
+	if (ret)
 		goto free;
-	}
 
 	ret = amd_iommu_init_devices();
 	if (ret)
@@ -1581,12 +1574,16 @@ int __init amd_iommu_init_hardware(void)
 	register_syscore_ops(&amd_iommu_syscore_ops);
 
 out:
+	/* Don't leak any ACPI memory */
+	early_acpi_os_unmap_memory((char __iomem *)ivrs_base, ivrs_size);
+	ivrs_base = NULL;
+
 	return ret;
 
 free:
 	free_on_init_error();
 
-	return ret;
+	goto out;
 }
 
 static int amd_iommu_enable_interrupts(void)
@@ -1604,6 +1601,26 @@ out:
 	return ret;
 }
 
+static bool detect_ivrs(void)
+{
+	struct acpi_table_header *ivrs_base;
+	acpi_size ivrs_size;
+	acpi_status status;
+
+	status = acpi_get_table_with_size("IVRS", 0, &ivrs_base, &ivrs_size);
+	if (status == AE_NOT_FOUND)
+		return false;
+	else if (ACPI_FAILURE(status)) {
+		const char *err = acpi_format_exception(status);
+		pr_err("AMD-Vi: IVRS table error: %s\n", err);
+		return false;
+	}
+
+	early_acpi_os_unmap_memory((char __iomem *)ivrs_base, ivrs_size);
+
+	return true;
+}
+
 /*
  * This is the core init function for AMD IOMMU hardware in the system.
  * This function is called from the generic x86 DMA layer initialization
@@ -1663,29 +1680,26 @@ free:
  * IOMMUs
  *
  ****************************************************************************/
-static int __init early_amd_iommu_detect(struct acpi_table_header *table)
-{
-	return 0;
-}
-
 int __init amd_iommu_detect(void)
 {
+
 	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
 		return -ENODEV;
 
 	if (amd_iommu_disabled)
 		return -ENODEV;
 
-	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
-		iommu_detected = 1;
-		amd_iommu_detected = 1;
-		x86_init.iommu.iommu_init = amd_iommu_init;
+	if (!detect_ivrs())
+		return -ENODEV;
 
-		/* Make sure ACS will be enabled */
-		pci_request_acs();
-		return 1;
-	}
-	return -ENODEV;
+	amd_iommu_detected = true;
+	iommu_detected = 1;
+	x86_init.iommu.iommu_init = amd_iommu_init;
+
+	/* Make sure ACS will be enabled */
+	pci_request_acs();
+
+	return 0;
 }
 
 /****************************************************************************
-- 
1.7.9.5


