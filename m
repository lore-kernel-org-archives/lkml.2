Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0IVVZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:25:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:56620 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab0IVVZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:25:23 -0400
Date: Wed, 22 Sep 2010 21:22:12 GMT
From: tip-bot for Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        simon@fire.lp0.eu, tglx@linutronix.de, hpa@linux.intel.com,
        bjorn.helgaas@hp.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        simon@fire.lp0.eu, tglx@linutronix.de, bjorn.helgaas@hp.com,
        hpa@linux.intel.com
In-Reply-To: <20100922201547.3197.33702.stgit@bob.kio>
References: <20100922201547.3197.33702.stgit@bob.kio>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pci] x86, pci: Ignore any PCI BARs that match an HPET we already know about
Message-ID: <tip-e72a6c8f7ac715a9cdb473afbc30743348d0a1e2@git.kernel.org>
Git-Commit-ID: e72a6c8f7ac715a9cdb473afbc30743348d0a1e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Sep 2010 21:22:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e72a6c8f7ac715a9cdb473afbc30743348d0a1e2
Gitweb:     http://git.kernel.org/tip/e72a6c8f7ac715a9cdb473afbc30743348d0a1e2
Author:     Bjorn Helgaas <bjorn.helgaas@hp.com>
AuthorDate: Wed, 22 Sep 2010 14:15:47 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Sep 2010 13:29:39 -0700

x86, pci: Ignore any PCI BARs that match an HPET we already know about

We often discover the HPET early, via the static ACPI HPET table,
before enumerating PCI devices.  If the HPET is implemented as a PCI
function, we will discover it again during PCI device enumeration.  We
must ignore the PCI function so we don't inadvertently move it out
from under the driver.

I think it's better to ignore *any* PCI BAR that matches a previously
discovered HPET; that way we don't need platform-specific knowledge,
and we won't have to add more quirks for future machines.

This is for a regression from 2.6.34, but the reporter has been
unable to test it yet.

[ hpa: if this fixes the regression, it should be promoted to x86/urgent ]

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=18482
Reported-by: Simon Arlott <simon@fire.lp0.eu>
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
LKML-Reference: <20100922201547.3197.33702.stgit@bob.kio>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/quirks.c |   21 +++++++++++++++++++++
 arch/x86/pci/fixup.c     |   28 ----------------------------
 2 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 939b9e9..99a7d4b 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -507,6 +507,27 @@ static void force_disable_hpet_msi(struct pci_dev *unused)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 			 force_disable_hpet_msi);
 
+static void disable_pci_hpet(struct pci_dev *dev)
+{
+	int i;
+
+	if (!hpet_address)
+		return;
+
+	for (i = 0; i < 6; i++) {
+		struct resource *res = &dev->resource[i];
+
+		if (resource_type(res) == IORESOURCE_MEM &&
+		    res->start == hpet_address) {
+			dev_info(&dev->dev, "BAR %d: %pR is an HPET we found earlier; ignoring this BAR\n",
+				 i, res);
+			res->flags = 0;
+			res->start = 0;
+			res->end = 0;
+		}
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, disable_pci_hpet);
 #endif
 
 #if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 6dd8955..08eba69 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -493,31 +493,3 @@ static void __devinit pci_siemens_interrupt_controller(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
 			  pci_siemens_interrupt_controller);
-
-/*
- * SB600: Disable BAR1 on device 14.0 to avoid HPET resources from
- * confusing the PCI engine:
- */
-static void sb600_disable_hpet_bar(struct pci_dev *dev)
-{
-	u8 val;
-
-	/*
-	 * The SB600 and SB700 both share the same device
-	 * ID, but the PM register 0x55 does something different
-	 * for the SB700, so make sure we are dealing with the
-	 * SB600 before touching the bit:
-	 */
-
-	pci_read_config_byte(dev, 0x08, &val);
-
-	if (val < 0x2F) {
-		outb(0x55, 0xCD6);
-		val = inb(0xCD7);
-
-		/* Set bit 7 in PM register 0x55 */
-		outb(0x55, 0xCD6);
-		outb(val | 0x80, 0xCD7);
-	}
-}
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);
