Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0HZR7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:59:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19216 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0HZR7D (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 26 Aug 2010 13:59:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org
Subject: [PATCH 05/10] x86/swiotlb: Make SWIOTLB use IOMMU_INIT_* macros.
Date: Thu, 26 Aug 2010 13:58:00 -0400
Message-Id: <1282845485-8991-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We utilize the IOMMU_INIT macros to create this dependency:

       [pci_xen_swiotlb_detect]
                 |
       [pci_swiotlb_detect_override]
                 |
       [pci_swiotlb_detect_4gb]

And set the SWIOTLB IOMMU_INIT to utilize 'pci_swiotlb_init'
for .init and 'pci_swiotlb_late_init' for .late_init.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: x86@kernel.org
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index c7a72fa..a5ad584 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -10,7 +10,8 @@
 #include <asm/iommu.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
-
+#include <asm/xen/swiotlb-xen.h>
+#include <asm/iommu_table.h>
 int swiotlb __read_mostly;
 
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -55,6 +56,10 @@ int __init pci_swiotlb_detect_override(void)
 
 	return use_swiotlb;
 }
+IOMMU_INIT_FINISH(pci_swiotlb_detect_override,
+		  pci_xen_swiotlb_detect,
+		  pci_swiotlb_init,
+		  pci_swiotlb_late_init);
 
 /*
  * if 4GB or more detected (and iommu=off not set) return 1
@@ -69,6 +74,10 @@ int __init pci_swiotlb_detect_4gb(void)
 #endif
 	return swiotlb;
 }
+IOMMU_INIT(pci_swiotlb_detect_4gb,
+	   pci_swiotlb_detect_override,
+	   pci_swiotlb_init,
+	   pci_swiotlb_late_init);
 
 void __init pci_swiotlb_init(void)
 {
@@ -89,3 +98,4 @@ void __init pci_swiotlb_late_init(void)
 		swiotlb_print_info();
 	}
 }
+
-- 
1.7.0.1

