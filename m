Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab2I1MYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:24:22 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:49146
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757666Ab2I1MYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27S9-01-LKV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/16] iommu/amd: Check if IOAPIC information is correct
Date: Fri, 28 Sep 2012 14:23:54 +0200
Message-ID: <1348835046-3262-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the IOAPIC information provided in the IVRS table is
not correct or not complete the system may not boot at all
when interrupt remapping is enabled. So check if this
information is correct and print out a firmware bug message
when it is not.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/Kconfig          |    2 +-
 drivers/iommu/amd_iommu_init.c |   27 ++++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 9f69b56..e39f9db 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -42,7 +42,7 @@ config AMD_IOMMU
 	select PCI_PRI
 	select PCI_PASID
 	select IOMMU_API
-	depends on X86_64 && PCI && ACPI
+	depends on X86_64 && PCI && ACPI && X86_IO_APIC
 	---help---
 	  With this option you can enable support for AMD IOMMU hardware in
 	  your system. An IOMMU is a hardware component which provides
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index db100c5..3f0b68f 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -33,6 +33,7 @@
 #include <asm/gart.h>
 #include <asm/x86_init.h>
 #include <asm/iommu_table.h>
+#include <asm/io_apic.h>
 
 #include "amd_iommu_proto.h"
 #include "amd_iommu_types.h"
@@ -1572,6 +1573,23 @@ static void __init free_on_init_error(void)
 #endif
 }
 
+static bool __init check_ioapic_information(void)
+{
+	int idx;
+
+	for (idx = 0; idx < nr_ioapics; ++idx) {
+		int id = mpc_ioapic_id(idx);
+
+		if (get_ioapic_devid(id) < 0) {
+			pr_err(FW_BUG "AMD-Vi: IO-APIC[%d] not in IVRS table\n", id);
+			pr_err("AMD-Vi: Disabling interrupt remapping due to BIOS Bug\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
 /*
  * This is the hardware init function for AMD IOMMU in the system.
  * This function is called either from amd_iommu_init or from the interrupt
@@ -1658,9 +1676,6 @@ static int __init early_amd_iommu_init(void)
 	if (amd_iommu_pd_alloc_bitmap == NULL)
 		goto out;
 
-	/* init the device table */
-	init_device_table();
-
 	/*
 	 * let all alias entries point to itself
 	 */
@@ -1683,6 +1698,9 @@ static int __init early_amd_iommu_init(void)
 	if (ret)
 		goto out;
 
+	if (amd_iommu_irq_remap)
+		amd_iommu_irq_remap = check_ioapic_information();
+
 	if (amd_iommu_irq_remap) {
 		/*
 		 * Interrupt remapping enabled, create kmem_cache for the
@@ -1706,6 +1724,9 @@ static int __init early_amd_iommu_init(void)
 	if (ret)
 		goto out;
 
+	/* init the device table */
+	init_device_table();
+
 out:
 	/* Don't leak any ACPI memory */
 	early_acpi_os_unmap_memory((char __iomem *)ivrs_base, ivrs_size);
-- 
1.7.9.5


