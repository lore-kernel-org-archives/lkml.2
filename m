Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1BBAvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:51:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:23328 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab1BBApD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505186"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: suresh.b.siddha@intel.com, ak@linux.intel.com, chrisw@sous-sol.org,
        kaneshige.kenji@jp.fujitsu.com, hpa@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [93/139] x86, vt-d: Quirk for masking vtd spec errors to platform error handling logic
Message-Id: <20110202004451.1AD033E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 254e42006c893f45bca48f313536fcba12206418 upstream.

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
report the same error through other channels.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1291667190.2675.8.camel@sbsiddha-MOBL3.sc.intel.com>
Reported-by: Max Asbock <masbock@linux.vnet.ibm.com>
Reported-and-tested-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: linux-2.6.35.y/drivers/pci/quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/quirks.c
+++ linux-2.6.35.y/drivers/pci/quirks.c
@@ -2678,6 +2678,29 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RI
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
 #endif /*CONFIG_MMC_RICOH_MMC*/
 
+#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
+#define VTUNCERRMSK_REG	0x1ac
+#define VTD_MSK_SPEC_ERRORS	(1 << 31)
+/*
+ * This is a quirk for masking vt-d spec defined errors to platform error
+ * handling logic. With out this, platforms using Intel 7500, 5500 chipsets
+ * (and the derivative chipsets like X58 etc) seem to generate NMI/SMI (based
+ * on the RAS config settings of the platform) when a vt-d fault happens.
+ * The resulting SMI caused the system to hang.
+ *
+ * VT-d spec related errors are already handled by the VT-d OS code, so no
+ * need to report the same error through other channels.
+ */
+static void vtd_mask_spec_errors(struct pci_dev *dev)
+{
+	u32 word;
+
+	pci_read_config_dword(dev, VTUNCERRMSK_REG, &word);
+	pci_write_config_dword(dev, VTUNCERRMSK_REG, word | VTD_MSK_SPEC_ERRORS);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, vtd_mask_spec_errors);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3c28, vtd_mask_spec_errors);
+#endif
 
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
