Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0IWOpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:45:30 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:36167 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab0IWOp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:45:28 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bh8275dhz32i87h2a8h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L97FMA-01-70U-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 2/3] x86/amd-iommu: Work around S3 BIOS bug
Date: Thu, 23 Sep 2010 16:44:48 +0200
Message-ID: <1285253089-4570-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
References: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a workaround for an IOMMU BIOS problem to
the AMD IOMMU driver. The result of the bug is that the
IOMMU does not execute commands anymore when the system
comes out of the S3 state resulting in system failure. The
bug in the BIOS is that is does not restore certain hardware
specific registers correctly. This workaround reads out the
contents of these registers at boot time and restores them
on resume from S3. The workaround is limited to the specific
IOMMU chipset where this problem occurs.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_proto.h |    6 ++++++
 arch/x86/include/asm/amd_iommu_types.h |    9 +++++++++
 arch/x86/kernel/amd_iommu_init.c       |   18 ++++++++++++++++++
 include/linux/pci_ids.h                |    3 +++
 4 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index d2544f1..cb03037 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -38,4 +38,10 @@ static inline void amd_iommu_stats_init(void) { }
 
 #endif /* !CONFIG_AMD_IOMMU_STATS */
 
+static inline bool is_rd890_iommu(struct pci_dev *pdev)
+{
+	return (pdev->vendor == PCI_VENDOR_ID_ATI) &&
+	       (pdev->device == PCI_DEVICE_ID_RD890_IOMMU);
+}
+
 #endif /* _ASM_X86_AMD_IOMMU_PROTO_H  */
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index ef2d5cd..0861618 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -414,6 +414,15 @@ struct amd_iommu {
 
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
+
+	/*
+	 * This array is required to work around a potential BIOS bug.
+	 * The BIOS may miss to restore parts of the PCI configuration
+	 * space when the system resumes from S3. The result is that the
+	 * IOMMU does not execute commands anymore which leads to system
+	 * failure.
+	 */
+	u32 cache_cfg[4];
 };
 
 /*
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 85e9817..5a170cb 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -632,6 +632,13 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
 					MMIO_GET_LD(range));
 	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
+
+	if (is_rd890_iommu(iommu->dev)) {
+		pci_read_config_dword(iommu->dev, 0xf0, &iommu->cache_cfg[0]);
+		pci_read_config_dword(iommu->dev, 0xf4, &iommu->cache_cfg[1]);
+		pci_read_config_dword(iommu->dev, 0xf8, &iommu->cache_cfg[2]);
+		pci_read_config_dword(iommu->dev, 0xfc, &iommu->cache_cfg[3]);
+	}
 }
 
 /*
@@ -1120,6 +1127,16 @@ static void iommu_init_flags(struct amd_iommu *iommu)
 	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
 }
 
+static void iommu_apply_quirks(struct amd_iommu *iommu)
+{
+	if (is_rd890_iommu(iommu->dev)) {
+		pci_write_config_dword(iommu->dev, 0xf0, iommu->cache_cfg[0]);
+		pci_write_config_dword(iommu->dev, 0xf4, iommu->cache_cfg[1]);
+		pci_write_config_dword(iommu->dev, 0xf8, iommu->cache_cfg[2]);
+		pci_write_config_dword(iommu->dev, 0xfc, iommu->cache_cfg[3]);
+	}
+}
+
 /*
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized
@@ -1130,6 +1147,7 @@ static void enable_iommus(void)
 
 	for_each_iommu(iommu) {
 		iommu_disable(iommu);
+		iommu_apply_quirks(iommu);
 		iommu_init_flags(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 10d3330..570fdde 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -393,6 +393,9 @@
 #define PCI_DEVICE_ID_VLSI_82C147	0x0105
 #define PCI_DEVICE_ID_VLSI_VAS96011	0x0702
 
+/* AMD RD890 Chipset */
+#define PCI_DEVICE_ID_RD890_IOMMU	0x5a23
+
 #define PCI_VENDOR_ID_ADL		0x1005
 #define PCI_DEVICE_ID_ADL_2301		0x2301
 
-- 
1.7.0.4


