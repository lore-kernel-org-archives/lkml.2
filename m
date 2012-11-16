Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2KPXU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 18:20:28 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:49173
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805Ab2KPXUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 18:20:25 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzc85fhzz1de0h1202h1d1ah1d2ahzzz2dh668h839hd25hd2bhf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh162dh1631h34h1155h)
X-WSS-ID: 0MDLSTV-02-3SD-02
X-M-MSG: 
Date: Fri, 16 Nov 2012 17:20:18 -0600
From: Steven Kinney <steven.kinney@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <joerg.roedel@amd.com>
CC: <bhelgaas@google.com>, <sebastian@breakpoint.cc>, <myron.stowe@redhat.com>,
        <hdoyu@nvidia.com>, <swarren@wwwdotorg.org>, <jkosina@suse.cz>,
        <kgene.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <steven.kinney@amd.com>
Subject: Re-send the AMD IOMMUv2 performance counter patched and PCI quirk.
  Sorry for the noise.
Message-ID: <20121116232018.GA24141@skinney-Trinity>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

Resending previous AMD IOMMUv2 patches due to improper extension on second
patch.

--X1bOJ3K7DJ5YkBrT
Content-Type: text/x-diff; charset="us-ascii";
	name="0001-iommuv2-amd-add-quirk-for-15h-models-10h-1Fh.patch"
Content-Disposition: attachment;
	filename="0001-iommuv2-amd-add-quirk-for-15h-models-10h-1Fh.patch"
Content-Description: 0001-iommuv2-amd-add-quirk-for-15h-models-10h-1Fh.patch

>From 760e18a02c0bb7eb5f5e3ebc192d43931f4c753b Mon Sep 17 00:00:00 2001
From: "Steven L. Kinney" <steven.kinney@amd.com>
Date: Fri, 16 Nov 2012 15:27:47 -0600
Subject: [PATCH] iommuv2/amd: Add quirk for AMD 15H_M10 IOMMUv2 Performance
 Counters

Add AMD PCI device definition that will identify devices that relate to the
IOMMUv2 PC PCI quirk added for potential non-enable by BIOS.

On AMD family 15h models 10h-1Fh BIOS may not enable performance counters in
IOMMUv2's EFR.  Add a quirk to enable the counters when this happens.

Signed-off-by: Steven L. Kinney <steven.kinney@amd.com>
---
 arch/x86/kernel/quirks.c |   17 +++++++++++++++++
 include/linux/pci_ids.h  |    2 ++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 1b27de5..9ea518b 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -567,3 +567,20 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
 			quirk_amd_nb_node);
 
 #endif
+
+#if defined(CONFIG_PCI) && defined(CONFIG_AMD_IOMMU_V2_PC)
+
+static void amd_force_iommu_v2_pc(struct pci_dev *dev)
+{
+	u32 val;
+
+	pci_read_config_dword(dev, 0x70, &val);
+	val |= (1<<9);
+	pci_write_config_dword(dev, 0x70, val);
+	dev_printk(KERN_DEBUG, &dev->dev, "Enabled IOMMUv2 PC\n");
+}
+
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_IOMMU,
+			amd_force_iommu_v2_pc);
+
+#endif
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9d36b82..70e20a3 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -396,6 +396,8 @@
 /* AMD RD890 Chipset */
 #define PCI_DEVICE_ID_RD890_IOMMU	0x5a23
 
+#define PCI_DEVICE_ID_AMD_15H_M10H_IOMMU	0x1419
+
 #define PCI_VENDOR_ID_ADL		0x1005
 #define PCI_DEVICE_ID_ADL_2301		0x2301
 
-- 
1.7.9.5


--X1bOJ3K7DJ5YkBrT
Content-Type: text/x-diff; charset="us-ascii"; name=
	"0002-iommuv2-amd-enable-performance-counters-on-family-15h-models-10h-1Fh.patch"
Content-Disposition: attachment; filename=
	"0002-iommuv2-amd-enable-performance-counters-on-family-15h-models-10h-1Fh.patch"
Content-Description: 0002-iommuv2-amd-enable-performance-counters-on-family-15h-models-10h-1Fh.patch

>From c51e45b34dd7075e9adc28fc1c00baecd07161db Mon Sep 17 00:00:00 2001
From: "Steven L. Kinney" <steven.kinney@amd.com>
Date: Fri, 16 Nov 2012 15:47:14 -0600
Subject: [PATCH] iommuv2/amd: Enable Performance Counters On Family 15h
 Models 10h-1Fh

Add Kernel configuration selection for AMD IOMMUv2 performance counters.

Add a check that will determine the configuration of the AMD IOMMUv2
performance counter(s) and extend the IOMMUv2 MMIO Region to account for the
additional PC register bank.

Add maximum IOMMUv2 bank/counter members to the amd_iommu structure that will
hold the relevant data concerning the available PC bank and counter resources.

Add code to iommu_init_pci that will check for IOMMUv2 PC HW support and
populate the max banks and counters into the amd_iommu structure.

Add exported functionality that will allow external drivers to obtain IOMMUv2
PC bank/counter resource information and manage the IOMMUv2 PC measurment
configuration.  Bank and counter assignment is managed outside of this driver;
for example, within a perf IOMMUv2 PMU realization.

Signed-off-by: Steven L. Kinney <steven.kinney@amd.com>
---
 drivers/iommu/Kconfig           |   10 +++++
 drivers/iommu/amd_iommu_init.c  |   86 +++++++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_types.h |   13 +++++-
 3 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e39f9db..d732e31 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -73,6 +73,16 @@ config AMD_IOMMU_V2
 	  hardware. Select this option if you want to use devices that support
 	  the PCI PRI and PASID interface.
 
+# AMD IOMMUv2 Performance Counter support
+config AMD_IOMMU_V2_PC
+	bool "AMD IOMMUv2 Performance Counters (EXPERIMENTAL)"
+	depends on AMD_IOMMU_V2
+	---help---
+	  This option enables support for AMD IOMMUv2 Performance Counters.
+	  Select this option if you want to enable IOMMUv2 Performance
+	  Counters support.
+	  If unsure, say N.
+
 # Intel IOMMU support
 config DMAR_TABLE
 	bool
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 81837b0..d3243af 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1145,6 +1145,20 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
 		amd_iommu_np_cache = true;
 
+#ifdef CONFIG_AMD_IOMMU_V2_PC
+	if (iommu_feature(iommu, FEATURE_PC)) {
+		u32 val;
+		dev_printk(KERN_DEBUG, &iommu->dev->dev,
+			   "AMD-Vi: IOMMUv2 perf counters supported\n");
+		val = readl(iommu->mmio_base + MMIO_CNTR_CONF_OFFSET);
+		iommu->max_banks = (u8) ((val >> 12) & 0x3f);
+		iommu->max_counters = (u8) ((val >> 7) & 0xf);
+		dev_printk(KERN_DEBUG, &iommu->dev->dev,
+			   "AMD-Vi: %d counter banks, %d counters each\n",
+			   iommu->max_banks, iommu->max_counters);
+	}
+#endif
+
 	if (is_rd890_iommu(iommu->dev)) {
 		int i, j;
 
@@ -2076,3 +2090,75 @@ bool amd_iommu_v2_supported(void)
 	return amd_iommu_v2_present;
 }
 EXPORT_SYMBOL(amd_iommu_v2_supported);
+
+#ifdef CONFIG_AMD_IOMMU_V2_PC
+/****************************************************************************
+ *
+ * IOMMUv2 EFR Performance Counter support functionality. This code allows
+ * access to the IOMMUv2 PC functionality.
+ *
+ ****************************************************************************/
+
+u8 amd_iommu_v2_get_max_pc_banks(u16 devid)
+{
+	struct amd_iommu *iommu;
+
+	/* locate the iommu governing the devid */
+	iommu = amd_iommu_rlookup_table[devid];
+
+	if (iommu)
+		return iommu->max_banks;
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL(amd_iommu_v2_get_max_pc_banks);
+
+u8 amd_iommu_v2_get_max_pc_counters(u16 devid)
+{
+	struct amd_iommu *iommu;
+
+	/* locate the iommu governing the devid */
+	iommu = amd_iommu_rlookup_table[devid];
+
+	if (iommu)
+		return iommu->max_counters;
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL(amd_iommu_v2_get_max_pc_counters);
+
+int amd_iommu_v2_get_set_pc_reg_val(u16 devid, u8 bank, u8 cntr, u8 fxn,
+				    long long *value, is_write)
+{
+	struct amd_iommu *iommu;
+	u32 offset;
+	u32 max_offset_lim;
+
+	/* locate the iommu associated with the device ID */
+	iommu = amd_iommu_rlookup_table[devid];
+	if (iommu == NULL)
+		return -ENODEV;
+
+	/* check for valid iommu pc register indexing */
+	if (fxn < 0 || fxn > 0x28 || (fxn & 7))
+		return -ENODEV;
+
+	offset = (u32)(((0x40|bank) << 12) | (cntr << 8) | fxn);
+
+	/* limit the offset to the hw defined mmio region aperture */
+	max_offset_lim = (u32)(((0x40|iommu->max_banks) << 12) |
+				(iommu->max_counters << 8) | 0x28);
+	if ((offset < IOMMU_V2_PC_REG_OFFSET) ||
+	    (offset > max_offset_lim))
+		return -EINVAL;
+
+	if (is_write)
+		*value = readl(iommu->mmio_base + offset);
+	else
+		writel((u32)*value, iommu->mmio_base + offset);
+
+	return 0;
+}
+EXPORT_SYMBOL(amd_iommu_v2_get_set_pc_reg_val);
+#endif
+
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index c9aa3d0..6dc1f68 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -38,7 +38,12 @@
 #define RLOOKUP_TABLE_ENTRY_SIZE	(sizeof(void *))
 
 /* Length of the MMIO region for the AMD IOMMU */
+#ifdef CONFIG_AMD_IOMMU_V2_PC
+#define MMIO_REGION_LENGTH       0x80000
+#define IOMMU_V2_PC_REG_OFFSET	 0x40000
+#else
 #define MMIO_REGION_LENGTH       0x4000
+#endif
 
 /* Capability offsets used by the driver */
 #define MMIO_CAP_HDR_OFFSET	0x00
@@ -77,7 +82,7 @@
 #define MMIO_STATUS_OFFSET	0x2020
 #define MMIO_PPR_HEAD_OFFSET	0x2030
 #define MMIO_PPR_TAIL_OFFSET	0x2038
-
+#define MMIO_CNTR_CONF_OFFSET	0x4000
 
 /* Extended Feature Bits */
 #define FEATURE_PREFETCH	(1ULL<<0)
@@ -584,6 +589,12 @@ struct amd_iommu {
 
 	/* The l2 indirect registers */
 	u32 stored_l2[0x83];
+
+#ifdef CONFIG_AMD_IOMMU_V2_PC
+	/* The maximum PC banks and counters/bank (PCSup=1) */
+	u8 max_banks;
+	u8 max_counters;
+#endif
 };
 
 struct devid_map {
-- 
1.7.9.5


--X1bOJ3K7DJ5YkBrT--
