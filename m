Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1BVIff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:35:35 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:56634 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1BVIfe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Tue, 22 Feb 2011 03:35:34 -0500
Message-Id: <4D638361020000780003315E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 22 Feb 2011 08:35:29 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <arozansk@redhat.com>, <mchehab@redhat.com>,
        "Michal Marek" <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2] x86/PCI: don't export a __devinit function
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporting a __devinit function (pcibios_scan_specific_bus()) isn't
correct. (Michal, any reason why modpost only warns about exported
__init functions?) Short of being able to think of a better solution,
and short of making the whole call tree (reaching into the arch-
independent part of the PCI subsystem) non-__devinit, export the
symbol only when HOTPLUG is enabled (which is always the case for non-
expert configurations), use section mismatch avoidance annotations for
that case (knowing that __devinit functions will not be discarded),
and mark the symbol __devinit only in the !HOTPLUG case.

Consequently, EDAC_I7CORE's use of that function then has to depend on
CONFIG_HOTPLUG. A fundamental question of course if whether this driver
has to use that function in the first place (i.e. whether it wouldn't
be better to just remove the export) - the problem it tries to address
happens on other systems too, but the PCI bus the devices in question
live on isn't necessarily bus 255. For the affected system I have, the
alternative approach is to set pcibios_last_bus from __pci_mmcfg_init()
based on the highest bus number on segment 0 being covered by MCFG.

v2: Rather than making the whole i7core_edac driver depend on HOTPLUG,
    make only the code using the symbol in question depend on this
    option (unless built into the kernel).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Aristeu Sergio <arozansk@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>

---
 arch/x86/pci/legacy.c      |   21 ++++++++++++++++++---
 drivers/edac/i7core_edac.c |    6 ++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

--- 2.6.38-rc6/arch/x86/pci/legacy.c
+++ 2.6.38-rc6-x86-pci-section-conflict/arch/x86/pci/legacy.c
@@ -36,7 +36,23 @@ int __init pci_legacy_init(void)
 	return 0;
 }
 
-void __devinit pcibios_scan_specific_bus(int busn)
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
@@ -51,12 +67,11 @@ void __devinit pcibios_scan_specific_bus
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
--- 2.6.38-rc6/drivers/edac/i7core_edac.c
+++ 2.6.38-rc6-x86-pci-section-conflict/drivers/edac/i7core_edac.c
@@ -1267,6 +1267,11 @@ static void i7core_put_all_devices(void)
 
 static void __init i7core_xeon_pci_fixup(const struct pci_id_table *table)
 {
+/*
+ * pcibios_scan_specific_bus() is __devinit and thus only exported when
+ * CONFIG_HOTPLUG is defined.
+ */
+#if !defined(MODULE) || defined(CONFIG_HOTPLUG)
 	struct pci_dev *pdev = NULL;
 	int i;
 
@@ -1284,6 +1289,7 @@ static void __init i7core_xeon_pci_fixup
 		pci_dev_put(pdev);
 		table++;
 	}
+#endif
 }
 
 static unsigned i7core_pci_lastbus(void)



