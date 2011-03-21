Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab1CUXdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:33:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:36849 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab1CUXdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:33:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,222,1299484800"; 
   d="scan'208";a="406096137"
From: "Zhao, Yu" <yu.zhao@intel.com>
To: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
CC: "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Tue, 22 Mar 2011 07:33:31 +0800
Subject: RE: [46/78] PCI: remove quirk for pre-production systems
Thread-Topic: [46/78] PCI: remove quirk for pre-production systems
Thread-Index: AcvoHkGEfAuys6x3Rxqc3D713h05vQAAdkAw
Message-ID: <F0B985DC7CF4974ABCD947B7FAF9C5A4B492D469@pgsmsx507.gar.corp.intel.com>
References: <20110321230346.GA14681@kroah.com>
 <20110321230326.450195228@clark.kroah.org>
In-Reply-To: <20110321230326.450195228@clark.kroah.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
I am quite sure that the Zhao Yu you want to send email to is not me. So would you please check email address and let the right man receive it?

Thanks,

Leo, Zhao


-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Tuesday, March 22, 2011 7:02 AM
To: linux-kernel@vger.kernel.org; stable@kernel.org
Cc: stable-review@kernel.org; torvalds@linux-foundation.org; akpm@linux-foundation.org; alan@lxorguk.ukuu.org.uk; Brandeburg, Jesse; Zhao, Yu; Jesse Barnes
Subject: [46/78] PCI: remove quirk for pre-production systems

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2618,58 +2618,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
 
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
 /* Allow manual resource allocation for PCI hotplug bridges
  * via pci=hpmemsize=nnM and pci=hpiosize=nnM parameters. For
  * some PCI-PCI hotplug bridges, like PLX 6254 (former HINT HB6),


