Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0LFU0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:26:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:7072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab0LFU0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:26:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,307,1288594800"; 
   d="scan'208";a="357841958"
Subject: Re: [patch 1/4] vt-d: quirk for masking vtd spec errors to
 platform error handling logic
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20101206092749.7f89f3fd@jbarnes-desktop>
References: <20101201062225.292364637@intel.com>
	 <20101201062244.365995600@intel.com>
	 <20101206092749.7f89f3fd@jbarnes-desktop>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 06 Dec 2010 12:26:30 -0800
Message-Id: <1291667190.2675.8.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 09:27 -0800, Jesse Barnes wrote:
> Can we make these registers and bits a bit more self-documenting (i.e.
> #defines for both, maybe along with other useful bit definitions for
> this reg)? Also, "error" is misspelled as "erorr" above. :)

Thanks for the review. Appended the updated patch. I haven't used
#defines for the pci-id's, as the first one (IOH) is used by several
chipsets and the second one is not named yet.

---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: vt-d: quirk for masking vtd spec errors to platform error handling logic

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
Cc: stable@kernel.org	[v2.6.32+]
---
 drivers/pci/quirks.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: tip/drivers/pci/quirks.c
===================================================================
--- tip.orig/drivers/pci/quirks.c
+++ tip/drivers/pci/quirks.c
@@ -2764,6 +2764,29 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RI
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


