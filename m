Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab2GEMjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:39:42 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:59780
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356Ab2GEMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPM-02-6NV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/28] iommu/amd: Check if IOAPIC information is correct
Date: Thu, 5 Jul 2012 14:36:35 +0200
Message-ID: <1341491808-23083-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
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
 drivers/iommu/amd_iommu_init.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 9dc0ebc..ed4e690 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1578,6 +1578,23 @@ static void __init free_on_init_error(void)
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
@@ -1664,9 +1681,6 @@ static int __init early_amd_iommu_init(void)
 	if (amd_iommu_pd_alloc_bitmap == NULL)
 		goto out;
 
-	/* init the device table */
-	init_device_table();
-
 	/*
 	 * let all alias entries point to itself
 	 */
@@ -1689,6 +1703,9 @@ static int __init early_amd_iommu_init(void)
 	if (ret)
 		goto out;
 
+	if (amd_iommu_irq_remap)
+		amd_iommu_irq_remap = check_ioapic_information();
+
 	if (amd_iommu_irq_remap) {
 		/*
 		 * Interrupt remapping enabled, create kmem_cache for the
@@ -1712,6 +1729,9 @@ static int __init early_amd_iommu_init(void)
 	if (ret)
 		goto out;
 
+	/* init the device table */
+	init_device_table();
+
 out:
 	/* Don't leak any ACPI memory */
 	early_acpi_os_unmap_memory((char *)ivrs_base, ivrs_size);
-- 
1.7.9.5


