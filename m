Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0JUMo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:44:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57720 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab0JUMoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:44:55 -0400
Date: Thu, 21 Oct 2010 14:44:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] iommu changes for v2.6.37
Message-ID: <20101021124441.GA31558@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-iommu-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (3):
      x86, GART: Remove superfluous AMD64_GARTEN
      x86, GART: Disable GART table walk probes
      AGP: Warn when GATT memory cannot be set to UC

Joerg Roedel (1):
      x86/amd-iommu: Update copyright headers

Matthew Garrett (1):
      x86/amd-iommu: Reenable AMD IOMMU if it's mysteriously vanished over suspend


 arch/x86/include/asm/amd_iommu.h       |    2 +-
 arch/x86/include/asm/amd_iommu_proto.h |    2 +-
 arch/x86/include/asm/amd_iommu_types.h |   23 ++++--
 arch/x86/include/asm/gart.h            |   15 ++++-
 arch/x86/kernel/amd_iommu.c            |    2 +-
 arch/x86/kernel/amd_iommu_init.c       |  124 ++++++++++++++++++++++++++++----
 arch/x86/kernel/aperture_64.c          |   18 +++--
 arch/x86/kernel/pci-gart_64.c          |    2 +-
 drivers/char/agp/amd64-agp.c           |    4 +-
 drivers/char/agp/generic.c             |    4 +-
 10 files changed, 158 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index 5af2982..f16a2ca 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index cb03037..916bc81 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2009-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 0861618..e3509fc 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
@@ -416,13 +416,22 @@ struct amd_iommu {
 	struct dma_ops_domain *default_dom;
 
 	/*
-	 * This array is required to work around a potential BIOS bug.
-	 * The BIOS may miss to restore parts of the PCI configuration
-	 * space when the system resumes from S3. The result is that the
-	 * IOMMU does not execute commands anymore which leads to system
-	 * failure.
+	 * We can't rely on the BIOS to restore all values on reinit, so we
+	 * need to stash them
 	 */
-	u32 cache_cfg[4];
+
+	/* The iommu BAR */
+	u32 stored_addr_lo;
+	u32 stored_addr_hi;
+
+	/*
+	 * Each iommu has 6 l1s, each of which is documented as having 0x12
+	 * registers
+	 */
+	u32 stored_l1[6][0x12];
+
+	/* The l2 indirect registers */
+	u32 stored_l2[0x83];
 };
 
 /*
diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 4ac5b0f..bf357f9 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -17,6 +17,7 @@ extern int fix_aperture;
 #define GARTEN		(1<<0)
 #define DISGARTCPU	(1<<4)
 #define DISGARTIO	(1<<5)
+#define DISTLBWALKPRB	(1<<6)
 
 /* GART cache control register bits. */
 #define INVGART		(1<<0)
@@ -27,7 +28,6 @@ extern int fix_aperture;
 #define AMD64_GARTAPERTUREBASE	0x94
 #define AMD64_GARTTABLEBASE	0x98
 #define AMD64_GARTCACHECTL	0x9c
-#define AMD64_GARTEN		(1<<0)
 
 #ifdef CONFIG_GART_IOMMU
 extern int gart_iommu_aperture;
@@ -57,6 +57,19 @@ static inline void gart_iommu_hole_init(void)
 
 extern int agp_amd64_init(void);
 
+static inline void gart_set_size_and_enable(struct pci_dev *dev, u32 order)
+{
+	u32 ctl;
+
+	/*
+	 * Don't enable translation but enable GART IO and CPU accesses.
+	 * Also, set DISTLBWALKPRB since GART tables memory is UC.
+	 */
+	ctl = DISTLBWALKPRB | order << 1;
+
+	pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
+}
+
 static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
 {
 	u32 tmp, ctl;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 679b645..d2fdb08 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 5a170cb..3cb482e 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
@@ -194,6 +194,39 @@ static inline unsigned long tbl_size(int entry_size)
 	return 1UL << shift;
 }
 
+/* Access to l1 and l2 indexed register spaces */
+
+static u32 iommu_read_l1(struct amd_iommu *iommu, u16 l1, u8 address)
+{
+	u32 val;
+
+	pci_write_config_dword(iommu->dev, 0xf8, (address | l1 << 16));
+	pci_read_config_dword(iommu->dev, 0xfc, &val);
+	return val;
+}
+
+static void iommu_write_l1(struct amd_iommu *iommu, u16 l1, u8 address, u32 val)
+{
+	pci_write_config_dword(iommu->dev, 0xf8, (address | l1 << 16 | 1 << 31));
+	pci_write_config_dword(iommu->dev, 0xfc, val);
+	pci_write_config_dword(iommu->dev, 0xf8, (address | l1 << 16));
+}
+
+static u32 iommu_read_l2(struct amd_iommu *iommu, u8 address)
+{
+	u32 val;
+
+	pci_write_config_dword(iommu->dev, 0xf0, address);
+	pci_read_config_dword(iommu->dev, 0xf4, &val);
+	return val;
+}
+
+static void iommu_write_l2(struct amd_iommu *iommu, u8 address, u32 val)
+{
+	pci_write_config_dword(iommu->dev, 0xf0, (address | 1 << 8));
+	pci_write_config_dword(iommu->dev, 0xf4, val);
+}
+
 /****************************************************************************
  *
  * AMD IOMMU MMIO register space handling functions
@@ -619,6 +652,7 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
 	u32 range, misc;
+	int i, j;
 
 	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_CAP_HDR_OFFSET,
 			      &iommu->cap);
@@ -633,12 +667,29 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 					MMIO_GET_LD(range));
 	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
 
-	if (is_rd890_iommu(iommu->dev)) {
-		pci_read_config_dword(iommu->dev, 0xf0, &iommu->cache_cfg[0]);
-		pci_read_config_dword(iommu->dev, 0xf4, &iommu->cache_cfg[1]);
-		pci_read_config_dword(iommu->dev, 0xf8, &iommu->cache_cfg[2]);
-		pci_read_config_dword(iommu->dev, 0xfc, &iommu->cache_cfg[3]);
-	}
+	if (!is_rd890_iommu(iommu->dev))
+		return;
+
+	/*
+	 * Some rd890 systems may not be fully reconfigured by the BIOS, so
+	 * it's necessary for us to store this information so it can be
+	 * reprogrammed on resume
+	 */
+
+	pci_read_config_dword(iommu->dev, iommu->cap_ptr + 4,
+			      &iommu->stored_addr_lo);
+	pci_read_config_dword(iommu->dev, iommu->cap_ptr + 8,
+			      &iommu->stored_addr_hi);
+
+	/* Low bit locks writes to configuration space */
+	iommu->stored_addr_lo &= ~1;
+
+	for (i = 0; i < 6; i++)
+		for (j = 0; j < 0x12; j++)
+			iommu->stored_l1[i][j] = iommu_read_l1(iommu, i, j);
+
+	for (i = 0; i < 0x83; i++)
+		iommu->stored_l2[i] = iommu_read_l2(iommu, i);
 }
 
 /*
@@ -1127,14 +1178,53 @@ static void iommu_init_flags(struct amd_iommu *iommu)
 	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
 }
 
-static void iommu_apply_quirks(struct amd_iommu *iommu)
+static void iommu_apply_resume_quirks(struct amd_iommu *iommu)
 {
-	if (is_rd890_iommu(iommu->dev)) {
-		pci_write_config_dword(iommu->dev, 0xf0, iommu->cache_cfg[0]);
-		pci_write_config_dword(iommu->dev, 0xf4, iommu->cache_cfg[1]);
-		pci_write_config_dword(iommu->dev, 0xf8, iommu->cache_cfg[2]);
-		pci_write_config_dword(iommu->dev, 0xfc, iommu->cache_cfg[3]);
-	}
+	int i, j;
+	u32 ioc_feature_control;
+	struct pci_dev *pdev = NULL;
+
+	/* RD890 BIOSes may not have completely reconfigured the iommu */
+	if (!is_rd890_iommu(iommu->dev))
+		return;
+
+	/*
+	 * First, we need to ensure that the iommu is enabled. This is
+	 * controlled by a register in the northbridge
+	 */
+	pdev = pci_get_bus_and_slot(iommu->dev->bus->number, PCI_DEVFN(0, 0));
+
+	if (!pdev)
+		return;
+
+	/* Select Northbridge indirect register 0x75 and enable writing */
+	pci_write_config_dword(pdev, 0x60, 0x75 | (1 << 7));
+	pci_read_config_dword(pdev, 0x64, &ioc_feature_control);
+
+	/* Enable the iommu */
+	if (!(ioc_feature_control & 0x1))
+		pci_write_config_dword(pdev, 0x64, ioc_feature_control | 1);
+
+	pci_dev_put(pdev);
+
+	/* Restore the iommu BAR */
+	pci_write_config_dword(iommu->dev, iommu->cap_ptr + 4,
+			       iommu->stored_addr_lo);
+	pci_write_config_dword(iommu->dev, iommu->cap_ptr + 8,
+			       iommu->stored_addr_hi);
+
+	/* Restore the l1 indirect regs for each of the 6 l1s */
+	for (i = 0; i < 6; i++)
+		for (j = 0; j < 0x12; j++)
+			iommu_write_l1(iommu, i, j, iommu->stored_l1[i][j]);
+
+	/* Restore the l2 indirect regs */
+	for (i = 0; i < 0x83; i++)
+		iommu_write_l2(iommu, i, iommu->stored_l2[i]);
+
+	/* Lock PCI setup registers */
+	pci_write_config_dword(iommu->dev, iommu->cap_ptr + 4,
+			       iommu->stored_addr_lo | 1);
 }
 
 /*
@@ -1147,7 +1237,6 @@ static void enable_iommus(void)
 
 	for_each_iommu(iommu) {
 		iommu_disable(iommu);
-		iommu_apply_quirks(iommu);
 		iommu_init_flags(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
@@ -1173,6 +1262,11 @@ static void disable_iommus(void)
 
 static int amd_iommu_resume(struct sys_device *dev)
 {
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu)
+		iommu_apply_resume_quirks(iommu);
+
 	/* re-load the hardware */
 	enable_iommus();
 
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index a2e0caf..c9cb173 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -307,7 +307,7 @@ void __init early_gart_iommu_check(void)
 				continue;
 
 			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
-			aper_enabled = ctl & AMD64_GARTEN;
+			aper_enabled = ctl & GARTEN;
 			aper_order = (ctl >> 1) & 7;
 			aper_size = (32 * 1024 * 1024) << aper_order;
 			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
@@ -362,7 +362,7 @@ void __init early_gart_iommu_check(void)
 				continue;
 
 			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
-			ctl &= ~AMD64_GARTEN;
+			ctl &= ~GARTEN;
 			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
 		}
 	}
@@ -505,8 +505,13 @@ out:
 
 	/* Fix up the north bridges */
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
-		int bus;
-		int dev_base, dev_limit;
+		int bus, dev_base, dev_limit;
+
+		/*
+		 * Don't enable translation yet but enable GART IO and CPU
+		 * accesses and set DISTLBWALKPRB since GART table memory is UC.
+		 */
+		u32 ctl = DISTLBWALKPRB | aper_order << 1;
 
 		bus = bus_dev_ranges[i].bus;
 		dev_base = bus_dev_ranges[i].dev_base;
@@ -515,10 +520,7 @@ out:
 			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
 				continue;
 
-			/* Don't enable translation yet. That is done later.
-			   Assume this BIOS didn't initialise the GART so
-			   just overwrite all previous bits */
-			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
 			write_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE, aper_alloc >> 25);
 		}
 	}
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 0f7f130..6015ee1 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -601,7 +601,7 @@ static void gart_fixup_northbridges(struct sys_device *dev)
 		 * Don't enable translations just yet.  That is the next
 		 * step.  Restore the pre-suspend aperture settings.
 		 */
-		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, aperture_order << 1);
+		gart_set_size_and_enable(dev, aperture_order);
 		pci_write_config_dword(dev, AMD64_GARTAPERTUREBASE, aperture_alloc >> 25);
 	}
 }
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 70312da..564808a 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -199,7 +199,7 @@ static void amd64_cleanup(void)
 		struct pci_dev *dev = k8_northbridges[i];
 		/* disable gart translation */
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &tmp);
-		tmp &= ~AMD64_GARTEN;
+		tmp &= ~GARTEN;
 		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, tmp);
 	}
 }
@@ -313,7 +313,7 @@ static __devinit int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp,
 	if (order < 0 || !agp_aperture_valid(aper, (32*1024*1024)<<order))
 		return -1;
 
-	pci_write_config_dword(nb, AMD64_GARTAPERTURECTL, order << 1);
+	gart_set_size_and_enable(nb, order);
 	pci_write_config_dword(nb, AMD64_GARTAPERTUREBASE, aper >> 25);
 
 	return 0;
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index d2abf51..64255ce 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -984,7 +984,9 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 
 	bridge->driver->cache_flush();
 #ifdef CONFIG_X86
-	set_memory_uc((unsigned long)table, 1 << page_order);
+	if (set_memory_uc((unsigned long)table, 1 << page_order))
+		printk(KERN_WARNING "Could not set GATT table memory to UC!");
+
 	bridge->gatt_table = (void *)table;
 #else
 	bridge->gatt_table = ioremap_nocache(virt_to_phys(table),
