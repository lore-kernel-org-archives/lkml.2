Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1FGSoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:44:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42761 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab1FGSoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:44:13 -0400
Date: Tue, 7 Jun 2011 20:44:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110607184401.GA28225@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

 Thanks,

	Ingo

------------------>
Joerg Roedel (3):
      x86/amd-iommu: Fix 3 possible endless loops
      x86/amd-iommu: Use only per-device dma_ops
      x86/amd-iommu: Fix boot crash with hidden PCI devices


 arch/x86/kernel/amd_iommu.c      |   48 +++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/amd_iommu_init.c |    8 +++---
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index cd8cbeb..7c3a95e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -30,6 +30,7 @@
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/dma.h>
 #include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
@@ -154,6 +155,10 @@ static int iommu_init_device(struct device *dev)
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
 	if (pdev)
 		dev_data->alias = &pdev->dev;
+	else {
+		kfree(dev_data);
+		return -ENOTSUPP;
+	}
 
 	atomic_set(&dev_data->bind, 0);
 
@@ -163,6 +168,20 @@ static int iommu_init_device(struct device *dev)
 	return 0;
 }
 
+static void iommu_ignore_device(struct device *dev)
+{
+	u16 devid, alias;
+
+	devid = get_device_id(dev);
+	alias = amd_iommu_alias_table[devid];
+
+	memset(&amd_iommu_dev_table[devid], 0, sizeof(struct dev_table_entry));
+	memset(&amd_iommu_dev_table[alias], 0, sizeof(struct dev_table_entry));
+
+	amd_iommu_rlookup_table[devid] = NULL;
+	amd_iommu_rlookup_table[alias] = NULL;
+}
+
 static void iommu_uninit_device(struct device *dev)
 {
 	kfree(dev->archdata.iommu);
@@ -192,7 +211,9 @@ int __init amd_iommu_init_devices(void)
 			continue;
 
 		ret = iommu_init_device(&pdev->dev);
-		if (ret)
+		if (ret == -ENOTSUPP)
+			iommu_ignore_device(&pdev->dev);
+		else if (ret)
 			goto out_free;
 	}
 
@@ -2383,6 +2404,23 @@ static struct dma_map_ops amd_iommu_dma_ops = {
 	.dma_supported = amd_iommu_dma_supported,
 };
 
+static unsigned device_dma_ops_init(void)
+{
+	struct pci_dev *pdev = NULL;
+	unsigned unhandled = 0;
+
+	for_each_pci_dev(pdev) {
+		if (!check_device(&pdev->dev)) {
+			unhandled += 1;
+			continue;
+		}
+
+		pdev->dev.archdata.dma_ops = &amd_iommu_dma_ops;
+	}
+
+	return unhandled;
+}
+
 /*
  * The function which clues the AMD IOMMU driver into dma_ops.
  */
@@ -2395,7 +2433,7 @@ void __init amd_iommu_init_api(void)
 int __init amd_iommu_init_dma_ops(void)
 {
 	struct amd_iommu *iommu;
-	int ret;
+	int ret, unhandled;
 
 	/*
 	 * first allocate a default protection domain for every IOMMU we
@@ -2421,7 +2459,11 @@ int __init amd_iommu_init_dma_ops(void)
 	swiotlb = 0;
 
 	/* Make the driver finally visible to the drivers */
-	dma_ops = &amd_iommu_dma_ops;
+	unhandled = device_dma_ops_init();
+	if (unhandled && max_pfn > MAX_DMA32_PFN) {
+		/* There are unhandled devices - initialize swiotlb for them */
+		swiotlb = 1;
+	}
 
 	amd_iommu_stats_init();
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 9179c21..bfc8453 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -731,8 +731,8 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 {
 	u8 *p = (u8 *)h;
 	u8 *end = p, flags = 0;
-	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
-	u32 ext_flags = 0;
+	u16 devid = 0, devid_start = 0, devid_to = 0;
+	u32 dev_i, ext_flags = 0;
 	bool alias = false;
 	struct ivhd_entry *e;
 
@@ -887,7 +887,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 /* Initializes the device->iommu mapping for the driver */
 static int __init init_iommu_devices(struct amd_iommu *iommu)
 {
-	u16 i;
+	u32 i;
 
 	for (i = iommu->first_device; i <= iommu->last_device; ++i)
 		set_iommu_for_device(iommu, i);
@@ -1177,7 +1177,7 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
  */
 static void init_device_table(void)
 {
-	u16 devid;
+	u32 devid;
 
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
