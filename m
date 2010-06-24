Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0FXPVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:21:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:35687 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab0FXPVD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 24 Jun 2010 11:21:03 -0400
X-Greylist: delayed 1208 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2010 11:21:03 EDT
Message-Id: <4C238F6002000078000080CC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 24 Jun 2010 16:01:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <arozansk@redhat.com>, <mchehab@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix section mismatch from
	 pcibios_scan_specific_bus()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This so far non-__devinit function calling a __devinit one
(pci_scan_bus_on_node()) isn't correct, but since it is being exported
it also cannot itself be made __devinit unconditionally. Short of being
able to think of a better solution, and short of making the whole call
tree (reaching into the arch-independent part of the PCI subsystem)
non-__devinit, export the symbol only when HOTPLUG is enabled (which
is always the case for non-embedded configurations), use section
mismatch avoidance annotations for (knowing that __devinit functions
will not be discarded in) that case, and mark the symbol __devinit only
in the !HOTPLUG case.

Consequently, EDAC_I7CORE (consuming the export) then has to depend on
HOTPLUG.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Aristeu Sergio <arozansk@redhat.com>

---
 arch/x86/pci/legacy.c |   21 ++++++++++++++++++---
 drivers/edac/Kconfig  |    2 +-
 2 files changed, 19 insertions(+), 4 deletions(-)

--- linux-2.6.35-rc3/arch/x86/pci/legacy.c
+++ 2.6.35-rc3-x86-pci-legacy-sections/arch/x86/pci/legacy.c
@@ -36,7 +36,23 @@ int __init pci_legacy_init(void)
 	return 0;
 }
 
-void pcibios_scan_specific_bus(int busn)
+#ifdef CONFIG_HOTPLUG
+static void __ref
+#else
+static inline void
+#endif
+_pci_scan_bus_on_node(int busno, int node)
+{
+	pci_scan_bus_on_node(busno, &pci_root_ops, node);
+}
+
+#ifdef CONFIG_HOTPLUG
+EXPORT_SYMBOL_GPL(pcibios_scan_specific_bus);
+void
+#else
+void __devinit
+#endif
+pcibios_scan_specific_bus(int busn)
 {
 	int devfn;
 	long node;
@@ -51,12 +67,11 @@ void pcibios_scan_specific_bus(int busn)
 		    l != 0x0000 && l != 0xffff) {
 			DBG("Found device at %02x:%02x [%04x]\n", busn, devfn, l);
 			printk(KERN_INFO "PCI: Discovered peer bus %02x\n", busn);
-			pci_scan_bus_on_node(busn, &pci_root_ops, node);
+			_pci_scan_bus_on_node(busn, node);
 			return;
 		}
 	}
 }
-EXPORT_SYMBOL_GPL(pcibios_scan_specific_bus);
 
 int __init pci_subsys_init(void)
 {
--- linux-2.6.35-rc3/drivers/edac/Kconfig
+++ 2.6.35-rc3-x86-pci-legacy-sections/drivers/edac/Kconfig
@@ -171,7 +171,7 @@ config EDAC_I5400
 
 config EDAC_I7CORE
 	tristate "Intel i7 Core (Nehalem) processors"
-	depends on EDAC_MM_EDAC && PCI && X86
+	depends on EDAC_MM_EDAC && PCI && X86 && HOTPLUG
 	select EDAC_MCE
 	help
 	  Support for error detection and correction the Intel



