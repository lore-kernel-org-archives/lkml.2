Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab0GOPNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:13:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:40860 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933479Ab0GOPNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:13:21 -0400
Date: Thu, 15 Jul 2010 15:12:50 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stephan@letzte-bankreihe.de, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stephan@letzte-bankreihe.de, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <alpine.LFD.2.00.1007142134140.3321@localhost.localdomain>
References: <alpine.LFD.2.00.1007142134140.3321@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Force HPET readback_cmp for all ATI chipsets
Message-ID: <tip-08be97962bf338161325d4901642f956ce8c1adb@git.kernel.org>
Git-Commit-ID: 08be97962bf338161325d4901642f956ce8c1adb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Jul 2010 15:12:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08be97962bf338161325d4901642f956ce8c1adb
Gitweb:     http://git.kernel.org/tip/08be97962bf338161325d4901642f956ce8c1adb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 14 Jul 2010 21:36:27 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jul 2010 17:10:02 +0200

x86: Force HPET readback_cmp for all ATI chipsets

commit 30a564be (x86, hpet: Restrict read back to affected ATI
chipset) restricted the workaround for the HPET bug to SMX00
chipsets. This was reasonable as those were the only ones against
which we ever got a bug report.

Stephan Wolf reported now that this patch breaks his IXP400 based
machine. Though it's confirmed to work on other IXP400 based systems.

To error out on the safe side, we force the HPET readback workaround
for all ATI SMbus class chipsets.

Reported-by: Stephan Wolf <stephan@letzte-bankreihe.de>
LKML-Reference: <alpine.LFD.2.00.1007142134140.3321@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Stephan Wolf <stephan@letzte-bankreihe.de>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/early-quirks.c |   18 ++++++++++++++++++
 arch/x86/kernel/quirks.c       |    5 -----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index ebdb85c..e5cc7e8 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -18,6 +18,7 @@
 #include <asm/apic.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/hpet.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
@@ -191,6 +192,21 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 }
 #endif
 
+/*
+ * Force the read back of the CMP register in hpet_next_event()
+ * to work around the problem that the CMP register write seems to be
+ * delayed. See hpet_next_event() for details.
+ *
+ * We do this on all SMBUS incarnations for now until we have more
+ * information about the affected chipsets.
+ */
+static void __init ati_hpet_bugs(int num, int slot, int func)
+{
+#ifdef CONFIG_HPET_TIMER
+	hpet_readback_cmp = 1;
+#endif
+}
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -220,6 +236,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
+	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_hpet_bugs },
 	{}
 };
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index e72d3fc..939b9e9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -498,15 +498,10 @@ void force_hpet_resume(void)
  * See erratum #27 (Misinterpreted MSI Requests May Result in
  * Corrupted LPC DMA Data) in AMD Publication #46837,
  * "SB700 Family Product Errata", Rev. 1.0, March 2010.
- *
- * Also force the read back of the CMP register in hpet_next_event()
- * to work around the problem that the CMP register write seems to be
- * delayed. See hpet_next_event() for details.
  */
 static void force_disable_hpet_msi(struct pci_dev *unused)
 {
 	hpet_msi_disable = 1;
-	hpet_readback_cmp = 1;
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
