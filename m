Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab0LNBQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:16:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:41087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701Ab0LNBQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:16:21 -0500
Date: Tue, 14 Dec 2010 01:15:55 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        kaneshige.kenji@jp.fujitsu.com, indou.takao@jp.fujitsu.com,
        masbock@linux.vnet.ibm.com, chrisw@sous-sol.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kaneshige.kenji@jp.fujitsu.com, indou.takao@jp.fujitsu.com,
        masbock@linux.vnet.ibm.com, chrisw@sous-sol.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1291667190.2675.8.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1291667190.2675.8.camel@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, vt-d: Quirk for masking vtd spec errors to platform error handling logic
Message-ID: <tip-254e42006c893f45bca48f313536fcba12206418@git.kernel.org>
Git-Commit-ID: 254e42006c893f45bca48f313536fcba12206418
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 01:15:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  254e42006c893f45bca48f313536fcba12206418
Gitweb:     http://git.kernel.org/tip/254e42006c893f45bca48f313536fcba12206418
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 6 Dec 2010 12:26:30 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Dec 2010 16:51:51 -0800

x86, vt-d: Quirk for masking vtd spec errors to platform error handling logic

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
LKML-Reference: <1291667190.2675.8.camel@sbsiddha-MOBL3.sc.intel.com>
Cc: stable@kernel.org	[v2.6.32+]
Reported-by: Max Asbock <masbock@linux.vnet.ibm.com>
Reported-and-tested-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/pci/quirks.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6f9350c..36191ed 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2764,6 +2764,29 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_m
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
