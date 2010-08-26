Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0HZR7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:59:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20746 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab0HZR72 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 26 Aug 2010 13:59:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 08/10] x86/GART/AMD-VI: Make AMD GART and IOMMU use IOMMU_INIT_* macros.
Date: Thu, 26 Aug 2010 13:58:03 -0400
Message-Id: <1282845485-8991-9-git-send-email-konrad.wilk@oracle.com>
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
         +-------+--------+
        /                  \
[detect_calgary]    [gart_iommu_hole_init]
                            |
                    [amd_iommu_detect]

Meaning that 'amd_iommu_detect' will be called after
'gart_iommu_hole_init'.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Joerg Roedel <joerg.roedel@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 +++++++-
 arch/x86/kernel/pci-gart_64.c    |    2 ++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 0b9e2dc..3ca6728 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -31,7 +31,7 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/x86_init.h>
-
+#include <asm/iommu_table.h>
 /*
  * definitions for the ACPI scanning code
  */
@@ -1430,3 +1430,9 @@ static int __init parse_amd_iommu_options(char *str)
 
 __setup("amd_iommu_dump", parse_amd_iommu_dump);
 __setup("amd_iommu=", parse_amd_iommu_options);
+
+IOMMU_INIT_FINISH(amd_iommu_detect,
+		  gart_iommu_hole_init,
+		  0,
+		  0);
+
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 0f7f130..de9734b 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -41,6 +41,7 @@
 #include <asm/dma.h>
 #include <asm/k8.h>
 #include <asm/x86_init.h>
+#include <asm/iommu_table.h>
 
 static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
 static unsigned long iommu_size;	/* size of remapping area bytes */
@@ -896,3 +897,4 @@ void __init gart_parse_options(char *p)
 		}
 	}
 }
+IOMMU_INIT_POST(gart_iommu_hole_init);
-- 
1.7.0.1

