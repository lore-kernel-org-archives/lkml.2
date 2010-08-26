Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab0HZR7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:59:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20939 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab0HZR7f (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 26 Aug 2010 13:59:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Len Brown <len.brown@intel.com>, Chris Wright <chrisw@sous-sol.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/10] x86/VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_* macros.
Date: Thu, 26 Aug 2010 13:58:04 -0400
Message-Id: <1282845485-8991-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We utilize the IOMMU_INIT macros to create this dependency:

               [null]
                 |
       [pci_xen_swiotlb_detect]
                 |
       [pci_swiotlb_detect_override]
                 |
       [pci_swiotlb_detect_4gb]
                 |
         +-------+--------+---------------------+
        /                  \                     \
[detect_calgary]    [gart_iommu_hole_init]   [detect_intel_iommu]
                            |
                    [amd_iommu_detect]

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Woodhouse <David.Woodhouse@intel.com>
CC: Len Brown <len.brown@intel.com>
CC: Chris Wright <chrisw@sous-sol.org>
CC: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/dmar.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 5fa64ea..4ef56a0 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -36,6 +36,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <asm/iommu_table.h>
 
 #define PREFIX "DMAR: "
 
@@ -724,7 +725,7 @@ int __init detect_intel_iommu(void)
 	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
 
-	return (ret ? 1 : -ENODEV);
+	return ret ? 1 : -ENODEV;
 }
 
 
@@ -1457,3 +1458,4 @@ int __init dmar_ir_support(void)
 		return 0;
 	return dmar->flags & 0x1;
 }
+IOMMU_INIT_POST(detect_intel_iommu);
-- 
1.7.0.1

