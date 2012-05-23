Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab2EWSKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:10:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760677Ab2EWSJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:09:52 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, matt.fleming@intel.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] x86: Handle broken Broadcom UEFI driver on Apple hardware
Date: Wed, 23 May 2012 14:08:46 -0400
Message-Id: <1337796526-3649-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1337796526-3649-1-git-send-email-mjg@redhat.com>
References: <1337796526-3649-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Broadcom driver in some UEFI Apple systems will continue DMAing into
RAM even after we've exited the firmware. Simply turning off the busmaster
bits results in the hardware hanging, so instead we put it in D3.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/kernel/early-quirks.c |   48 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index dcf4bcf..9c243c0 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -200,6 +200,52 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 }
 #endif
 
+/*
+ * Some Apple systems leave the Broadcom wifi hardware DMAing after
+ * leaving the firmware. We're still safe at this point since boot
+ * services regions are reserved, so we can quiesce the hardware by
+ * putting it in D3 and let it be safely brought back up again later
+ */
+static void __init apple_bcm_bug(int num, int slot, int func)
+{
+	u16 pm_state, subvendor;
+	u8 id, pm = 0, pos = PCI_CAPABILITY_LIST;
+	int ttl = 48;
+
+	subvendor = read_pci_config_16(num, slot, func,
+				       PCI_SUBSYSTEM_VENDOR_ID);
+
+	if (subvendor != PCI_VENDOR_ID_APPLE)
+		return;
+
+	while (ttl--) {
+		pos = read_pci_config_byte(num, slot, func, pos);
+		if (pos < 0x40)
+			break;
+
+		pos &= ~3;
+
+		id = read_pci_config_byte(num, slot, func, pos);
+		if (id == 0xff)
+			break;
+
+		if (id == PCI_CAP_ID_PM) {
+			pm = pos;
+			break;
+		}
+		pos += 1;
+	}
+
+	if (pm) {
+		pm_state = read_pci_config_16(num, slot, func,
+					      pm + PCI_PM_CTRL);
+		pm_state &= ~PCI_PM_CTRL_STATE_MASK;
+		pm_state |= 0x3;
+		write_pci_config_16(num, slot, func, pm + PCI_PM_CTRL,
+				    pm_state);
+	}
+}
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -226,6 +272,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
+	{ PCI_VENDOR_ID_BROADCOM, PCI_ANY_ID,
+	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_bcm_bug },
 	{}
 };
 
-- 
1.7.10.2

