Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0JMMfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:35:53 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:41565
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102Ab0JMMfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:35:37 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0LA8AYZ-02-SBR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] x86/amd-iommu: Reenable AMD IOMMU if it's mysteriously vanished over suspend
Date: Wed, 13 Oct 2010 14:36:03 +0200
Message-ID: <1286973364-17077-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286973364-17077-1-git-send-email-joerg.roedel@amd.com>
References: <1286973364-17077-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

AMD's reference BIOS code had a bug that could result in the
firmware failing to reenable the iommu on resume. It
transpires that this causes certain less than desirable
behaviour when it comes to PCI accesses, to whit them ending
up somewhere near Bristol when the more desirable outcome
was Edinburgh. Sadness ensues, perhaps along with filesystem
corruption.  Let's make sure that it gets turned back on,
and that we restore its configuration so decisions it makes
bear some resemblance to those made by reasonable people
rather than crack-addled lemurs who spent all your DMA on
Thunderbird.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   21 ++++--
 arch/x86/kernel/amd_iommu_init.c       |  122 ++++++++++++++++++++++++++++----
 2 files changed, 123 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 0861618..bdd20c8 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
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
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 5a170cb..44710d8 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
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
 
-- 
1.7.0.4


