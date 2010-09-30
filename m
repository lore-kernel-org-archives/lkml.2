Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0I3Piv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:38:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab0I3Pit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:38:49 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, joerg.roedel@amd.com, jbarnes@virtuousgeek.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] pci: Reenable the AMD IOMMU if it's mysteriously vanished over suspend
Date: Thu, 30 Sep 2010 11:38:28 -0400
Message-Id: <1285861108-24122-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
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
Let's make sure that it gets turned back on.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/pci/quirks.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 89ed181..dcf9832 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2695,6 +2695,39 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832,
 #endif /*CONFIG_MMC_RICOH_MMC*/
 
 
+#ifdef CONFIG_AMD_IOMMU
+
+/* Some AMD BIOSes fail to reenable the iommu on resume */
+
+static void amd_iommu_reenable(struct pci_dev *dev)
+{
+	u32 ioc_feature_control;
+	struct pci_dev *iommu;
+
+	iommu = pci_get_device(PCI_VENDOR_ID_ATI, 0x5a23, NULL);
+
+	if (!iommu)
+		return;
+
+	/* Select Northbridge indirect register 0x75 and enable writing */
+	pci_write_config_dword(dev, 0x60, 0x75 | (1 << 7));
+	pci_read_config_dword(dev, 0x64, &ioc_feature_control);
+
+	/* Enable the iommu if it's vanished */
+	if (!(ioc_feature_control & 0x1))
+		pci_write_config_dword(dev, 0x64, ioc_feature_control | 1);
+
+	/* Disable writing again */
+	pci_write_config_dword(dev, 0x60, 0x75);
+
+	pci_dev_put(iommu);
+}
+
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, 0x5a10, amd_iommu_reenable);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, 0x5a12, amd_iommu_reenable);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, 0x5a13, amd_iommu_reenable);
+#endif
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
-- 
1.7.3

