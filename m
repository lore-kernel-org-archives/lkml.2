Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0JVSi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:38:28 -0400
Received: from kroah.org ([198.145.64.141]:45630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab0JVSiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:23 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:57 2010
Message-Id: <20101022183557.583172165@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [15/66] x86/amd-iommu: Work around S3 BIOS bug
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 4c894f47bb49284008073d351c0ddaac8860864e upstream.

This patch adds a workaround for an IOMMU BIOS problem to
the AMD IOMMU driver. The result of the bug is that the
IOMMU does not execute commands anymore when the system
comes out of the S3 state resulting in system failure. The
bug in the BIOS is that is does not restore certain hardware
specific registers correctly. This workaround reads out the
contents of these registers at boot time and restores them
on resume from S3. The workaround is limited to the specific
IOMMU chipset where this problem occurs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/amd_iommu_types.h |   15 +++++++++++++++
 arch/x86/kernel/amd_iommu_init.c       |   18 ++++++++++++++++++
 include/linux/pci_ids.h                |    3 +++
 3 files changed, 36 insertions(+)

--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -351,6 +351,15 @@ struct amd_iommu {
 
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
@@ -472,4 +481,10 @@ static inline void amd_iommu_stats_init(
 /* some function prototypes */
 extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
 
+static inline bool is_rd890_iommu(struct pci_dev *pdev)
+{
+	return (pdev->vendor == PCI_VENDOR_ID_ATI) &&
+	       (pdev->device == PCI_DEVICE_ID_RD890_IOMMU);
+}
+
 #endif /* _ASM_X86_AMD_IOMMU_TYPES_H */
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -622,6 +622,13 @@ static void __init init_iommu_from_pci(s
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
@@ -1093,6 +1100,16 @@ static void iommu_init_flags(struct amd_
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
@@ -1103,6 +1120,7 @@ static void enable_iommus(void)
 
 	for_each_iommu(iommu) {
 		iommu_disable(iommu);
+		iommu_apply_quirks(iommu);
 		iommu_init_flags(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
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
 


