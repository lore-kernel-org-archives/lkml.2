Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0HZR7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:59:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20120 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0HZR7R (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 26 Aug 2010 13:59:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org
Subject: [PATCH 04/10] x86/swiotlb: Simplify SWIOTLB pci_swiotlb_detect routine.
Date: Thu, 26 Aug 2010 13:57:59 -0400
Message-Id: <1282845485-8991-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 'pci_swiotlb_detect' we used to do two different things:
 a). If user provided 'iommu=soft' or 'swiotlb=force' we
     would set swiotlb=1 and return 1 (and forcing pci-dma.c
     to call pci_swiotlb_init() immediately).
 b). If 4GB or more would be detected and if user did not specify
     iommu=off, we would set 'swiotlb=1' and return whatever 'a)'
     figured out.

We simplify this by splitting a) and b) in two different routines.

CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: x86@kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/iommu_table.h |    4 ++--
 arch/x86/include/asm/swiotlb.h     |   13 +++++++++++--
 arch/x86/kernel/pci-dma.c          |    4 +++-
 arch/x86/kernel/pci-swiotlb.c      |   33 +++++++++++++++++++++++++++------
 4 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index 2124e3e..df55a78 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -64,10 +64,10 @@ struct iommu_table_entry {
  * to stop detecting the other IOMMUs after yours has been detected.
  */
 #define IOMMU_INIT_POST(_detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect,  0, 0, 0)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 0)
 
 #define IOMMU_INIT_POST_FINISH(detect)					\
-	__IOMMU_INIT(_detect, pci_swiotlb_detect,  0, 0, 1)
+	__IOMMU_INIT(_detect, pci_swiotlb_detect_4gb,  0, 0, 1)
 
 /*
  * A more sophisticated version of IOMMU_INIT. This variant requires:
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index 8085277..977f176 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -5,17 +5,26 @@
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
-extern int __init pci_swiotlb_detect(void);
+extern int __init pci_swiotlb_detect_override(void);
+extern int __init pci_swiotlb_detect_4gb(void);
 extern void __init pci_swiotlb_init(void);
+extern void __init pci_swiotlb_late_init(void);
 #else
 #define swiotlb 0
-static inline int pci_swiotlb_detect(void)
+static inline int pci_swiotlb_detect_override(void)
+{
+	return 0;
+}
+static inline int pci_swiotlb_detect_4gb(void)
 {
 	return 0;
 }
 static inline void pci_swiotlb_init(void)
 {
 }
+static inline void pci_swiotlb_late_init(void)
+{
+}
 #endif
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 9f07cfc..1b3beb5 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -133,9 +133,11 @@ void __init pci_iommu_alloc(void)
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 
-	if (pci_xen_swiotlb_detect() || pci_swiotlb_detect())
+	if (pci_xen_swiotlb_detect() || pci_swiotlb_detect_override())
 		goto out;
 
+	pci_swiotlb_detect_4gb();
+
 	gart_iommu_hole_init();
 
 	detect_calgary();
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index a5bc528..c7a72fa 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -41,24 +41,33 @@ static struct dma_map_ops swiotlb_dma_ops = {
 };
 
 /*
- * pci_swiotlb_detect - set swiotlb to 1 if necessary
+ * pci_swiotlb_detect_override - set swiotlb to 1 if necessary
  *
  * This returns non-zero if we are forced to use swiotlb (by the boot
  * option).
  */
-int __init pci_swiotlb_detect(void)
+int __init pci_swiotlb_detect_override(void)
 {
 	int use_swiotlb = swiotlb | swiotlb_force;
 
+	if (swiotlb_force)
+		swiotlb = 1;
+
+	return use_swiotlb;
+}
+
+/*
+ * if 4GB or more detected (and iommu=off not set) return 1
+ * and set swiotlb to 1.
+ */
+int __init pci_swiotlb_detect_4gb(void)
+{
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
 	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
 		swiotlb = 1;
 #endif
-	if (swiotlb_force)
-		swiotlb = 1;
-
-	return use_swiotlb;
+	return swiotlb;
 }
 
 void __init pci_swiotlb_init(void)
@@ -68,3 +77,15 @@ void __init pci_swiotlb_init(void)
 		dma_ops = &swiotlb_dma_ops;
 	}
 }
+
+void __init pci_swiotlb_late_init(void)
+{
+	/* An IOMMU turned us off. */
+	if (!swiotlb)
+		swiotlb_free();
+	else {
+		printk(KERN_INFO "PCI-DMA: "
+		       "Using software bounce buffering for IO (SWIOTLB)\n");
+		swiotlb_print_info();
+	}
+}
-- 
1.7.0.1

