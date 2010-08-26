Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0HZR7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:59:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20807 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0HZR7b (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 26 Aug 2010 13:59:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: [PATCH 10/10] x86/iommu: Utilize the IOMMU_INIT macros functionality.
Date: Thu, 26 Aug 2010 13:58:05 -0400
Message-Id: <1282845485-8991-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We remove all of the sub-platform detection/init routines and instead
use on the .iommu_table array of structs to call the .early_init if
.detect returned a positive value. Also we can stop detecting other
IOMMUs if the IOMMU used the _FINISH type macro. During the
'pci_iommu_init' stage, we call .init for the second-stage
initialization if it was defined. Currently only SWIOTLB has this
defined and it used to de-allocate the SWIOTLB if the other detected
IOMMUs have deemed it unnecessary to use SWIOTLB.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/pci-dma.c |   46 ++++++++++++++++++++------------------------
 1 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1b3beb5..9ea999a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -11,9 +11,8 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
-#include <asm/amd_iommu.h>
 #include <asm/x86_init.h>
-#include <asm/xen/swiotlb-xen.h>
+#include <asm/iommu_table.h>
 
 static int forbid_dac __read_mostly;
 
@@ -45,6 +44,8 @@ int iommu_detected __read_mostly = 0;
  */
 int iommu_pass_through __read_mostly;
 
+extern struct iommu_table_entry __iommu_table[], __iommu_table_end[];
+
 /* Dummy device used for NULL arguments (normally ISA). */
 struct device x86_dma_fallback_dev = {
 	.init_name = "fallback device",
@@ -130,28 +131,24 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
+	struct iommu_table_entry *p;
+
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 
-	if (pci_xen_swiotlb_detect() || pci_swiotlb_detect_override())
-		goto out;
-
-	pci_swiotlb_detect_4gb();
-
-	gart_iommu_hole_init();
-
-	detect_calgary();
-
-	detect_intel_iommu();
+	sort_iommu_table(__iommu_table, __iommu_table_end);
+	check_iommu_entries(__iommu_table, __iommu_table_end);
 
-	/* needs to be called after gart_iommu_hole_init */
-	amd_iommu_detect();
-out:
-	pci_xen_swiotlb_init();
-
-	pci_swiotlb_init();
+	for (p = __iommu_table; p < __iommu_table_end; p++) {
+		if (p && p->detect && p->detect() > 0) {
+			p->flags |= IOMMU_DETECTED;
+			if (p->early_init)
+				p->early_init();
+			if (p->flags & IOMMU_FINISH_IF_DETECTED)
+				break;
+		}
+	}
 }
-
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t flag)
 {
@@ -294,6 +291,7 @@ EXPORT_SYMBOL(dma_supported);
 
 static int __init pci_iommu_init(void)
 {
+	struct iommu_table_entry *p;
 	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
 
 #ifdef CONFIG_PCI
@@ -301,12 +299,10 @@ static int __init pci_iommu_init(void)
 #endif
 	x86_init.iommu.iommu_init();
 
-	if (swiotlb || xen_swiotlb) {
-		printk(KERN_INFO "PCI-DMA: "
-		       "Using software bounce buffering for IO (SWIOTLB)\n");
-		swiotlb_print_info();
-	} else
-		swiotlb_free();
+	for (p = __iommu_table; p < __iommu_table_end; p++) {
+		if (p && (p->flags & IOMMU_DETECTED) && p->late_init)
+			p->late_init();
+	}
 
 	return 0;
 }
-- 
1.7.0.1

