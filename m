Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab1DKJc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:32:27 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:50240 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755287Ab1DKJcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:32:14 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJHEHK-02-1FI-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] x86/amd-iommu: Add extended feature detection
Date: Mon, 11 Apr 2011 11:32:03 +0200
Message-ID: <1302514324-14717-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302514324-14717-1-git-send-email-joerg.roedel@amd.com>
References: <1302514324-14717-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds detection of the extended features of an
AMD IOMMU. The available features are printed to dmesg on
boot.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_proto.h |    8 ++++++++
 arch/x86/include/asm/amd_iommu_types.h |   17 +++++++++++++++++
 arch/x86/kernel/amd_iommu.c            |    2 +-
 arch/x86/kernel/amd_iommu_init.c       |   26 +++++++++++++++++++++++---
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index 1223c0f..30d1594 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -42,4 +42,12 @@ static inline bool is_rd890_iommu(struct pci_dev *pdev)
 	       (pdev->device == PCI_DEVICE_ID_RD890_IOMMU);
 }
 
+static inline bool iommu_feature(struct amd_iommu *iommu, u64 f)
+{
+	if (!(iommu->cap & (1 << IOMMU_CAP_EFR)))
+		return false;
+
+	return !!(iommu->features & f);
+}
+
 #endif /* _ASM_X86_AMD_IOMMU_PROTO_H  */
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 878ae00..5c24e46 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -68,12 +68,25 @@
 #define MMIO_CONTROL_OFFSET     0x0018
 #define MMIO_EXCL_BASE_OFFSET   0x0020
 #define MMIO_EXCL_LIMIT_OFFSET  0x0028
+#define MMIO_EXT_FEATURES	0x0030
 #define MMIO_CMD_HEAD_OFFSET	0x2000
 #define MMIO_CMD_TAIL_OFFSET	0x2008
 #define MMIO_EVT_HEAD_OFFSET	0x2010
 #define MMIO_EVT_TAIL_OFFSET	0x2018
 #define MMIO_STATUS_OFFSET	0x2020
 
+
+/* Extended Feature Bits */
+#define FEATURE_PREFETCH	(1ULL<<0)
+#define FEATURE_PPR		(1ULL<<1)
+#define FEATURE_X2APIC		(1ULL<<2)
+#define FEATURE_NX		(1ULL<<3)
+#define FEATURE_GT		(1ULL<<4)
+#define FEATURE_IA		(1ULL<<6)
+#define FEATURE_GA		(1ULL<<7)
+#define FEATURE_HE		(1ULL<<8)
+#define FEATURE_PC		(1ULL<<9)
+
 /* MMIO status bits */
 #define MMIO_STATUS_COM_WAIT_INT_MASK	0x04
 
@@ -227,6 +240,7 @@
 /* IOMMU capabilities */
 #define IOMMU_CAP_IOTLB   24
 #define IOMMU_CAP_NPCACHE 26
+#define IOMMU_CAP_EFR     27
 
 #define MAX_DOMAIN_ID 65536
 
@@ -371,6 +385,9 @@ struct amd_iommu {
 	/* flags read from acpi table */
 	u8 acpi_flags;
 
+	/* Extended features */
+	u64 features;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index bcf58ea..d609610 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -29,8 +29,8 @@
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
-#include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
+#include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu.h>
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8848dda..4a78e22 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -25,8 +25,8 @@
 #include <linux/interrupt.h>
 #include <linux/msi.h>
 #include <asm/pci-direct.h>
-#include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
+#include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -299,9 +299,23 @@ static void iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 /* Function to enable the hardware */
 static void iommu_enable(struct amd_iommu *iommu)
 {
-	printk(KERN_INFO "AMD-Vi: Enabling IOMMU at %s cap 0x%hx\n",
+	static const char * const feat_str[] = {
+		"PreF", "PPR", "X2APIC", "NX", "GT", "[5]",
+		"IA", "GA", "HE", "PC", NULL
+	};
+	int i;
+
+	printk(KERN_INFO "AMD-Vi: Enabling IOMMU at %s cap 0x%hx",
 	       dev_name(&iommu->dev->dev), iommu->cap_ptr);
 
+	if (iommu->cap & (1 << IOMMU_CAP_EFR)) {
+		printk(KERN_CONT " extended features: ");
+		for (i = 0; feat_str[i]; ++i)
+			if (iommu_feature(iommu, (1ULL << i)))
+				printk(KERN_CONT " %s", feat_str[i]);
+	}
+	printk(KERN_CONT "\n");
+
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
@@ -657,7 +671,7 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
 static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
-	u32 range, misc;
+	u32 range, misc, low, high;
 	int i, j;
 
 	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_CAP_HDR_OFFSET,
@@ -673,6 +687,12 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 					MMIO_GET_LD(range));
 	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
 
+	/* read extended feature bits */
+	low  = readl(iommu->mmio_base + MMIO_EXT_FEATURES);
+	high = readl(iommu->mmio_base + MMIO_EXT_FEATURES + 4);
+
+	iommu->features = ((u64)high << 32) | low;
+
 	if (!is_rd890_iommu(iommu->dev))
 		return;
 
-- 
1.7.1


