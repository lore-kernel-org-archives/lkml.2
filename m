Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2KZWAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:00:33 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:43221
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837Ab2KZWAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:00:32 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1155h)
X-WSS-ID: 0ME47SQ-02-431-02
X-M-MSG: 
From: Steven Kinney <steven.kinney@amd.com>
To: Joerg Roedel <bhelgaas@google.com>
CC: Hiroshi DOYU <hdoyu@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Jiri Kosina <jkosina@suse.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        Steven Kinney <steven.kinney@amd.com>
Subject: [PATCH 1/1] iommuv2/amd: Enable Performance Counters On Family 15h Models 10h-1Fh
Date: Mon, 26 Nov 2012 16:00:25 -0600
Message-ID: <1353967225-18742-1-git-send-email-steven.kinney@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven L. Kinney" <steven.kinney@amd.com>

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


