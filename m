Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab2IQLYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:24:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55429 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab2IQLYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:24:10 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, Greg Ungerer <gerg@uclinux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 2/2] PCI: Provide a default pcibios_update_irq()
Date: Mon, 17 Sep 2012 13:22:54 +0200
Message-Id: <1347880974-13615-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347880974-13615-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347880974-13615-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:NUiyNRXCLpLU54zzRebEnGKZG334sFWr2heirloIyGn
 Iu/D32iAzingKJNjwkboqkHyLx/q4UjhwRLei8PZhxVnSa7mdR
 FIhVLgLooTM9240izmpG034vA3w6HQDtmWqUfZ2k7St4EZh4BN
 cBxDyWAGjWlzuFDG5hp6ifHvwly5juS7NuJQQB9oVGMFt4abFb
 6eExTi2vbZfVxqTRFhdO1lXq2JohO62n80Njb59PxNRcM7mzeg
 6FjJpjGwe3dtUVGouJuhy6lvZldEmmXLbs5xb/38ctNzy//vyh
 nnji7uK1UxT9aQaIro5x9FwGsC9UogE60IfU6wkaa2sWOf57AA
 eA9VfG72wLOYte1Jj9evl3eMIb62x9/jfF2ba4n8ipPJ47GteN
 U/Mtm37aLQyy5jlKghZFhfA0vDm95eFVoLaRYx6G1gN9j2B0PY
 LvvlU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures implement this in exactly the same way. Instead of
having each architecture duplicate this function, provide a single
implementation in the core and make it a weak symbol so that it can be
overridden on architectures where it is required.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Note: ARM and Unicore32 did use a debug_pci variable to check whether or
not to output a debug message in pcibios_update_irq(). SPARC/LEON checks
for CONFIG_PCI_DEBUG instead. I've adopted the SPARC variant in this
patch. I assumed that in the interest of unification this would be a
good compromise. If not, please let me know.

Also, SPARC64 had an empty pcibios_update_irq(). I've opted to drop it
in favour of the default implementation, which just writes a single byte
in the device's configuration space. I assumed that this should still
work but perhaps was just not used on SPARC64. If this is known to break
SPARC64 I can keep the noop implementation.

Changes in v2:
- drop __devinit annotation
- use dev_dbg()

 arch/alpha/kernel/pci.c      | 6 ------
 arch/arm/kernel/bios32.c     | 9 ---------
 arch/ia64/pci/pci.c          | 8 --------
 arch/m68k/kernel/pcibios.c   | 5 -----
 arch/mips/pci/pci.c          | 6 ------
 arch/sh/drivers/pci/pci.c    | 5 -----
 arch/sparc/kernel/leon_pci.c | 9 ---------
 arch/sparc/kernel/pci.c      | 4 ----
 arch/tile/kernel/pci.c       | 8 --------
 arch/tile/kernel/pci_gx.c    | 8 --------
 arch/unicore32/kernel/pci.c  | 8 --------
 arch/x86/pci/visws.c         | 5 -----
 arch/xtensa/kernel/pci.c     | 8 --------
 drivers/pci/setup-irq.c      | 5 +++++
 14 files changed, 5 insertions(+), 89 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index 920392f..ef75714 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -256,12 +256,6 @@ pcibios_fixup_bus(struct pci_bus *bus)
 	}
 }
 
-void
-pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
 int
 pcibios_enable_device(struct pci_dev *dev, int mask)
 {
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 0174fe6..9cf16b8 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -270,15 +270,6 @@ static void __devinit pci_fixup_it8152(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8152, pci_fixup_it8152);
 
-
-
-void pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	if (debug_pci)
-		printk("PCI: Assigning IRQ %02d to %s\n", irq, pci_name(dev));
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
 /*
  * If the bus contains any of these devices, then we must not turn on
  * parity checking of any kind.  Currently this is CyberPro 20x0 only.
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 27db6a8..a7ebe94 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -461,14 +461,6 @@ void pcibios_set_master (struct pci_dev *dev)
 	/* No special bus mastering setup handling */
 }
 
-void
-pcibios_update_irq (struct pci_dev *dev, int irq)
-{
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-
-	/* ??? FIXME -- record old value for shutdown.  */
-}
-
 int
 pcibios_enable_device (struct pci_dev *dev, int mask)
 {
diff --git a/arch/m68k/kernel/pcibios.c b/arch/m68k/kernel/pcibios.c
index b2988aa..73fa0b5 100644
--- a/arch/m68k/kernel/pcibios.c
+++ b/arch/m68k/kernel/pcibios.c
@@ -87,11 +87,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return 0;
 }
 
-void pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
 void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 64f0419..04e35bc 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -313,12 +313,6 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 	}
 }
 
-void
-pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
 #ifdef CONFIG_HOTPLUG
 EXPORT_SYMBOL(PCIBIOS_MIN_IO);
 EXPORT_SYMBOL(PCIBIOS_MIN_MEM);
diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index 1bd3e08..a7e078f 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -192,11 +192,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return pci_enable_resources(dev, mask);
 }
 
-void pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
 static void __init
 pcibios_bus_report_status_early(struct pci_channel *hose,
 				int top_bus, int current_bus,
diff --git a/arch/sparc/kernel/leon_pci.c b/arch/sparc/kernel/leon_pci.c
index 404621b..fc05211 100644
--- a/arch/sparc/kernel/leon_pci.c
+++ b/arch/sparc/kernel/leon_pci.c
@@ -102,15 +102,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return pci_enable_resources(dev, mask);
 }
 
-void pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-#ifdef CONFIG_PCI_DEBUG
-	printk(KERN_DEBUG "LEONPCI: Assigning IRQ %02d to %s\n", irq,
-		pci_name(dev));
-#endif
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
 /* in/out routines taken from pcic.c
  *
  * This probably belongs here rather than ioport.c because
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 065b88c..acc8c83 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -622,10 +622,6 @@ void __devinit pcibios_fixup_bus(struct pci_bus *pbus)
 {
 }
 
-void pcibios_update_irq(struct pci_dev *pdev, int irq)
-{
-}
-
 resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 6245bba..dbdab34 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -404,14 +404,6 @@ void pcibios_set_master(struct pci_dev *dev)
 }
 
 /*
- * This is called from the generic Linux layer.
- */
-void pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
-/*
  * Enable memory and/or address decoding, as appropriate, for the
  * device described by the 'dev' struct.
  *
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 5faad0b..2ba6d05 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -1034,14 +1034,6 @@ char __devinit *pcibios_setup(char *str)
 }
 
 /*
- * This is called from the generic Linux layer.
- */
-void pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
-/*
  * Enable memory address decoding, as appropriate, for the
  * device described by the 'dev' struct. The I/O decoding
  * is disabled, though the TILE-Gx supports I/O addressing.
diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
index c07ecc5..b0056f6 100644
--- a/arch/unicore32/kernel/pci.c
+++ b/arch/unicore32/kernel/pci.c
@@ -154,14 +154,6 @@ void __init puv3_pci_adjust_zones(unsigned long *zone_size,
 	zhole_size[0] = 0;
 }
 
-void pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	if (debug_pci)
-		printk(KERN_DEBUG "PCI: Assigning IRQ %02d to %s\n",
-				irq, pci_name(dev));
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
 /*
  * If the bus contains any of these devices, then we must not turn on
  * parity checking of any kind.
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 9d736e7..3e6d2a6 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -62,11 +62,6 @@ out:
 	return irq;
 }
 
-void pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
 int __init pci_visws_init(void)
 {
 	pcibios_enable_irq = &pci_visws_enable_irq;
diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index 6f9b40c..54354de 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -210,14 +210,6 @@ void pcibios_set_master(struct pci_dev *dev)
 	/* No special bus mastering setup handling */
 }
 
-/* the next one is stolen from the alpha port... */
-
-void
-pcibios_update_irq(struct pci_dev *dev, int irq)
-{
-	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
-}
-
 int pcibios_enable_device(struct pci_dev *dev, int mask)
 {
 	u16 cmd, old_cmd;
diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
index 270ae7b..3d61ce3 100644
--- a/drivers/pci/setup-irq.c
+++ b/drivers/pci/setup-irq.c
@@ -17,6 +17,11 @@
 #include <linux/ioport.h>
 #include <linux/cache.h>
 
+void __weak pcibios_update_irq(struct pci_dev *dev, int irq)
+{
+	dev_dbg(&dev->dev, "Assigning IRQ %02d\n", irq);
+	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
+}
 
 static void
 pdev_fixup_irq(struct pci_dev *dev,
-- 
1.7.12

