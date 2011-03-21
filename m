Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1CUXNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:13:55 -0400
Received: from kroah.org ([198.145.64.141]:49027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999Ab1CUXNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:52 2011
Message-Id: <20110321231052.897716407@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yu Zhao <yu.zhao@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [21/44] PCI: remove quirk for pre-production systems
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Brandeburg, Jesse <jesse.brandeburg@intel.com>

commit b99af4b002e4908d1a5cdaf424529bdf1dc69768 upstream.

Revert commit 7eb93b175d4de9438a4b0af3a94a112cb5266944
Author: Yu Zhao <yu.zhao@intel.com>
Date:   Fri Apr 3 15:18:11 2009 +0800

    PCI: SR-IOV quirk for Intel 82576 NIC

    If BIOS doesn't allocate resources for the SR-IOV BARs, zero the Flash
    BAR and program the SR-IOV BARs to use the old Flash Memory Space.

    Please refer to Intel 82576 Gigabit Ethernet Controller Datasheet
    section 7.9.2.14.2 for details.
    http://download.intel.com/design/network/datashts/82576_Datasheet.pdf

    Signed-off-by: Yu Zhao <yu.zhao@intel.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

This quirk was added before SR-IOV was in production and now all machines that
originally had this issue alreayd have bios updates to correct the issue. The
quirk itself is no longer needed and in fact causes bugs if run.  Remove it.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Yu Zhao <yu.zhao@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |   52 ---------------------------------------------------
 1 file changed, 52 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2495,58 +2495,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
 
 #endif /* CONFIG_PCI_MSI */
 
-#ifdef CONFIG_PCI_IOV
-
-/*
- * For Intel 82576 SR-IOV NIC, if BIOS doesn't allocate resources for the
- * SR-IOV BARs, zero the Flash BAR and program the SR-IOV BARs to use the
- * old Flash Memory Space.
- */
-static void __devinit quirk_i82576_sriov(struct pci_dev *dev)
-{
-	int pos, flags;
-	u32 bar, start, size;
-
-	if (PAGE_SIZE > 0x10000)
-		return;
-
-	flags = pci_resource_flags(dev, 0);
-	if ((flags & PCI_BASE_ADDRESS_SPACE) !=
-			PCI_BASE_ADDRESS_SPACE_MEMORY ||
-	    (flags & PCI_BASE_ADDRESS_MEM_TYPE_MASK) !=
-			PCI_BASE_ADDRESS_MEM_TYPE_32)
-		return;
-
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_SRIOV);
-	if (!pos)
-		return;
-
-	pci_read_config_dword(dev, pos + PCI_SRIOV_BAR, &bar);
-	if (bar & PCI_BASE_ADDRESS_MEM_MASK)
-		return;
-
-	start = pci_resource_start(dev, 1);
-	size = pci_resource_len(dev, 1);
-	if (!start || size != 0x400000 || start & (size - 1))
-		return;
-
-	pci_resource_flags(dev, 1) = 0;
-	pci_write_config_dword(dev, PCI_BASE_ADDRESS_1, 0);
-	pci_write_config_dword(dev, pos + PCI_SRIOV_BAR, start);
-	pci_write_config_dword(dev, pos + PCI_SRIOV_BAR + 12, start + size / 2);
-
-	dev_info(&dev->dev, "use Flash Memory Space for SR-IOV BARs\n");
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10c9, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10e6, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10e7, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10e8, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x150a, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x150d, quirk_i82576_sriov);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1518, quirk_i82576_sriov);
-
-#endif	/* CONFIG_PCI_IOV */
-
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {


