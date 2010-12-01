Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0LAG4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:56:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:5632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0LAG4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:56:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="863002225"
Message-Id: <20101201062244.365995600@intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 30 Nov 2010 22:22:26 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>, indou.takao@jp.fujitsu.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org
Subject: [patch 1/4] vt-d: quirk for masking vtd spec errors to platform error handling logic
References: <20101201062225.292364637@intel.com>
Content-Disposition: inline; filename=vtd_quirk_mask_spec_errors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On platforms with Intel 7500 chipset, there were some reports of system
hang/NMI's during kexec/kdump in the presence of interrupt-remapping enabled.

During kdump, there is a window where the devices might be still using old
kernel's interrupt information, while the kdump kernel is coming up. This can
cause vt-d faults as the interrupt configuration from the old kernel map to
null IRTE entries in the new kernel etc. (with out interrupt-remapping enabled,
we still have the same issue but in this case we will see benign spurious
interrupt hit the new kernel).

Based on platform config settings, these platforms seem to generate NMI/SMI
when a vt-d fault happens and there were reports that the resulting SMI causes
the  system to hang.

Fix it by masking vt-d spec defined errors to platform error reporting logic.
VT-d spec related errors are already handled by the VT-d OS code, so need to
report the same erorr through other channels.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org [v2.6.32+]
---
 drivers/pci/quirks.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: tip/drivers/pci/quirks.c
===================================================================
--- tip.orig/drivers/pci/quirks.c
+++ tip/drivers/pci/quirks.c
@@ -2764,6 +2764,26 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RI
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
 #endif /*CONFIG_MMC_RICOH_MMC*/
 
+#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
+/*
+ * This is a quirk for masking vt-d spec defined errors to platform error
+ * handling logic. With out this, platforms seem to generate NMI/SMI (based
+ * on the RAS config settings of the platform) when a vt-d fault happens and
+ * there were reports that the resulting SMI causes system to hang.
+ *
+ * VT-d spec related errors are already handled by the VT-d OS code, so no
+ * need to report the same erorr through other channels.
+ */
+static void vtd_mask_spec_errors(struct pci_dev *dev)
+{
+	u32 word;
+
+	pci_read_config_dword(dev, 0x1AC, &word);
+	pci_write_config_dword(dev, 0x1AC, word | (1 << 31));
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, vtd_mask_spec_errors);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3c28, vtd_mask_spec_errors);
+#endif
 
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)


