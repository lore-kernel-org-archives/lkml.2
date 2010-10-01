Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab0JAOCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:02:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab0JAOCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:02:07 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, joerg.roedel@amd.com, x86@kernel.org,
        jbarnes@virtuousgeek.org, Matthew Garrett <mjg@redhat.com>,
        stable@kernel.org
Subject: [PATCH] x86: Reenable the AMD IOMMU if it's mysteriously vanished over suspend
Date: Fri,  1 Oct 2010 10:01:23 -0400
Message-Id: <1285941683-7445-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD's reference BIOS code had a bug that could result in the firmware
failing to reenable the iommu on resume. It transpires that this causes
certain less than desirable behaviour when it comes to PCI accesses, to
whit them ending up somewhere near Bristol when the more desirable outcome
was Edinburgh. Sadness ensues, perhaps along with filesystem corruption.
Let's make sure that it gets turned back on, and that we restore its
configuration so decisions it makes bear some resemblance to those made by
reasonable people rather than crack-addled lemurs who spent all your DMA
on Thunderbird.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: stable@kernel.org
---

Turns out that PCI resume is too late for this, so incorporate it all into
the sysdev resume code in the driver

 arch/x86/include/asm/amd_iommu_types.h |   21 ++++--
 arch/x86/kernel/amd_iommu_init.c       |  134 +++++++++++++++++++++++++++++---
 2 files changed, 137 insertions(+), 18 deletions(-)

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
index 5a170cb..7ce2936 100644
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
@@ -633,12 +667,27 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
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
+	pci_read_config_dword(iommu->dev, 0x44, &iommu->stored_addr_lo);
+	pci_read_config_dword(iommu->dev, 0x48, &iommu->stored_addr_hi);
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
@@ -1129,12 +1178,69 @@ static void iommu_init_flags(struct amd_iommu *iommu)
 
 static void iommu_apply_quirks(struct amd_iommu *iommu)
 {
-	if (is_rd890_iommu(iommu->dev)) {
-		pci_write_config_dword(iommu->dev, 0xf0, iommu->cache_cfg[0]);
-		pci_write_config_dword(iommu->dev, 0xf4, iommu->cache_cfg[1]);
-		pci_write_config_dword(iommu->dev, 0xf8, iommu->cache_cfg[2]);
-		pci_write_config_dword(iommu->dev, 0xfc, iommu->cache_cfg[3]);
+	int i, j;
+	u32 ioc_feature_control;
+	struct pci_dev *pdev = NULL;
+	int device_id;
+
+	/* RD890 BIOSes may not have completely reconfigured the iommu */
+	if (!is_rd890_iommu(iommu->dev))
+		return;
+
+	/*
+	 * First, we need to ensure that the iommu is enabled. This is
+	 * controlled by a register in the northbridge
+	 */
+	device_id = 0x5a10;
+	pdev = pci_get_device(PCI_VENDOR_ID_ATI, device_id, NULL);
+
+	if (!pdev) {
+		device_id = 0x5a12;
+		pdev = pci_get_device(PCI_VENDOR_ID_ATI, device_id, NULL);
 	}
+
+	if (!pdev) {
+		device_id = 0x5a13;
+		pdev = pci_get_device(PCI_VENDOR_ID_ATI, device_id, NULL);
+	}
+
+	if (!pdev)
+		return;
+
+	/* There may be one iommu per bus, so find the appropriate bridge */
+	while (pdev && (pdev->bus->number != iommu->dev->bus->number)) {
+		pci_dev_put(pdev);
+		pdev = pci_get_device(PCI_VENDOR_ID_ATI, device_id, pdev);
+	}
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
+	pci_write_config_dword(iommu->dev, 0x44, iommu->stored_addr_lo);
+	pci_write_config_dword(iommu->dev, 0x48, iommu->stored_addr_hi);
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
+	pci_write_config_dword(iommu->dev, 0x44, iommu->stored_addr_lo | 1);
 }
 
 /*
@@ -1147,7 +1253,6 @@ static void enable_iommus(void)
 
 	for_each_iommu(iommu) {
 		iommu_disable(iommu);
-		iommu_apply_quirks(iommu);
 		iommu_init_flags(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
@@ -1173,6 +1278,11 @@ static void disable_iommus(void)
 
 static int amd_iommu_resume(struct sys_device *dev)
 {
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu)
+		iommu_apply_quirks(iommu);
+
 	/* re-load the hardware */
 	enable_iommus();
 
-- 
1.7.3

