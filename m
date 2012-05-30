Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2E3FLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:11:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab2E3FLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:11:01 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 7/7] iommu: Remove group_mf
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com,
        alex.williamson@redhat.com
Date: Tue, 29 May 2012 23:10:48 -0600
Message-ID: <20120530051047.1543.55022.stgit@bling.home>
In-Reply-To: <20120530045150.1543.73660.stgit@bling.home>
References: <20120530045150.1543.73660.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iommu=group_mf is really no longer needed with the addition of ACS
support in IOMMU drivers creating groups.  Most multifunction devices
will now be grouped already.  If a device has gone to the trouble of
exposing ACS, trust that it works.  We can use the device specific ACS
function for fixing devices we trust individually.  This largely
reverts bcb71abe.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/kernel-parameters.txt |    1 -
 arch/ia64/include/asm/iommu.h       |    2 --
 arch/ia64/kernel/pci-dma.c          |    1 -
 arch/x86/include/asm/iommu.h        |    1 -
 arch/x86/kernel/pci-dma.c           |   11 -----------
 drivers/iommu/amd_iommu.c           |    5 -----
 drivers/iommu/intel-iommu.c         |    5 -----
 7 files changed, 26 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 0ea6d04..1e38ef3 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1128,7 +1128,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 		forcesac
 		soft
 		pt		[x86, IA-64]
-		group_mf	[x86, IA-64]
 
 
 	io7=		[HW] IO7 for Marvel based alpha systems
diff --git a/arch/ia64/include/asm/iommu.h b/arch/ia64/include/asm/iommu.h
index b6a809f..105c93b 100644
--- a/arch/ia64/include/asm/iommu.h
+++ b/arch/ia64/include/asm/iommu.h
@@ -11,12 +11,10 @@ extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
 extern int iommu_pass_through;
 extern int iommu_detected;
-extern int iommu_group_mf;
 #else
 #define iommu_pass_through	(0)
 #define no_iommu		(1)
 #define iommu_detected		(0)
-#define iommu_group_mf		(0)
 #endif
 extern void iommu_dma_init(void);
 extern void machvec_init(const char *name);
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index 7cdc89b..1ddcfe5 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -32,7 +32,6 @@ int force_iommu __read_mostly;
 #endif
 
 int iommu_pass_through;
-int iommu_group_mf;
 
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index dffc38e..345c99c 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -5,7 +5,6 @@ extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int iommu_pass_through;
-extern int iommu_group_mf;
 
 /* 10 seconds */
 #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 62c9457..ac8f823 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -45,15 +45,6 @@ int iommu_detected __read_mostly = 0;
  */
 int iommu_pass_through __read_mostly;
 
-/*
- * Group multi-function PCI devices into a single device-group for the
- * iommu_device_group interface.  This tells the iommu driver to pretend
- * it cannot distinguish between functions of a device, exposing only one
- * group for the device.  Useful for disallowing use of individual PCI
- * functions from userspace drivers.
- */
-int iommu_group_mf __read_mostly;
-
 extern struct iommu_table_entry __iommu_table[], __iommu_table_end[];
 
 /* Dummy device used for NULL arguments (normally ISA). */
@@ -193,8 +184,6 @@ static __init int iommu_setup(char *p)
 #endif
 		if (!strncmp(p, "pt", 2))
 			iommu_pass_through = 1;
-		if (!strncmp(p, "group_mf", 8))
-			iommu_group_mf = 1;
 
 		gart_parse_options(p);
 
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 9b2e2c9..4a37785 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -288,11 +288,6 @@ static int iommu_init_device(struct device *dev)
 	} else
 		dma_pdev = pdev;
 
-	if (!pdev->is_virtfn && PCI_FUNC(pdev->devfn) && iommu_group_mf &&
-	    pdev->hdr_type == PCI_HEADER_TYPE_NORMAL)
-		dma_pdev = pci_get_slot(pdev->bus,
-					PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
-
 	dma_pdev = pci_dma_source(dma_pdev);
 
 	if (dma_pdev->multifunction &&
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c26d21b..76ce3bb 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4113,11 +4113,6 @@ static int intel_iommu_add_device(struct device *dev)
 			dma_pdev = bridge;
 	}
 
-	if (!pdev->is_virtfn && PCI_FUNC(pdev->devfn) && iommu_group_mf &&
-	    pdev->hdr_type == PCI_HEADER_TYPE_NORMAL)
-		dma_pdev = pci_get_slot(pdev->bus,
-					PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
-
 	dma_pdev = pci_dma_source(dma_pdev);
 
 	if (dma_pdev->multifunction &&

