Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1ABH1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:27:42 -0500
Received: from mail.windriver.com ([147.11.1.11]:37223 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1ABH0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:26:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Len Brown <len.brown@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 210/260] intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang
Date: Sun,  2 Jan 2011 02:18:26 -0500
Message-Id: <1293952756-15010-211-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:59.0979 (UTC) FILETIME=[0648B3B0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

commit 4731fdcf6f7bdab3e369a3f844d4ea4d4017284d upstream.

When the Lenovo Ideapad S10-3 is booted with HT enabled,
it hits a boot hang in the intel_idle driver.

This occurs when entering ATM-C4 for the first time,
unless BM_STS is first cleared.

acpi_idle doesn't see this because it first checks
and clears BM_STS, but it would hit the same hang
if that check were disabled.

http://bugs.meego.com/show_bug.cgi?id=7093
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/634702

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/quirks.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c582935..4a120b7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -150,6 +150,26 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_2,	quirk_isa_d
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_3,	quirk_isa_dma_hangs);
 
 /*
+ * Intel NM10 "TigerPoint" LPC PM1a_STS.BM_STS must be clear
+ * for some HT machines to use C4 w/o hanging.
+ */
+static void __devinit quirk_tigerpoint_bm_sts(struct pci_dev *dev)
+{
+	u32 pmbase;
+	u16 pm1a;
+
+	pci_read_config_dword(dev, 0x40, &pmbase);
+	pmbase = pmbase & 0xff80;
+	pm1a = inw(pmbase);
+
+	if (pm1a & 0x10) {
+		dev_info(&dev->dev, FW_BUG "TigerPoint LPC.BM_STS cleared\n");
+		outw(0x10, pmbase);
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TGP_LPC, quirk_tigerpoint_bm_sts);
+
+/*
  *	Chipsets where PCI->PCI transfers vanish or hang
  */
 static void __devinit quirk_nopcipci(struct pci_dev *dev)
-- 
1.7.3.3

