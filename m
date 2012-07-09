Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2GIVgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:36:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab2GIVgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:36:42 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 5/8] MIPS/PCI: Move final fixup quirks from __init to
	__devinit
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, ralf@linux-mips.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 15:36:27 -0600
Message-ID: <20120709213627.8975.4902.stgit@amt.stowe>
In-Reply-To: <20120709213554.8975.60552.stgit@amt.stowe>
References: <20120709213554.8975.60552.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI subsystem's final fixups are executed once during boot, after the
pci-device is found.  As long as the system does not support hot-plug,
specifying __init is fine.

With hot-plug, either physically based hot-plug events or pseudo hot-plug
events such as "echo 1 > /sys/bus/pci/rescan", it is possible to remove a
PCI bus during run time and have it rediscovered which will require the
call of the fixups again in order for the device to function properly.

This patch prepares specific quirk(s) for use with hot-plug events.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/mips/mti-malta/malta-pci.c |    2 +-
 arch/mips/pci/ops-tx4927.c      |    2 +-
 arch/mips/txx9/generic/pci.c    |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mti-malta/malta-pci.c b/arch/mips/mti-malta/malta-pci.c
index bf80921..b663402 100644
--- a/arch/mips/mti-malta/malta-pci.c
+++ b/arch/mips/mti-malta/malta-pci.c
@@ -253,7 +253,7 @@ void __init mips_pcibios_init(void)
 }
 
 /* Enable PCI 2.1 compatibility in PIIX4 */
-static void __init quirk_dlcsetup(struct pci_dev *dev)
+static void __devinit quirk_dlcsetup(struct pci_dev *dev)
 {
 	u8 odlc, ndlc;
 	(void) pci_read_config_byte(dev, 0x82, &odlc);
diff --git a/arch/mips/pci/ops-tx4927.c b/arch/mips/pci/ops-tx4927.c
index a1e7e6d..bc13e29 100644
--- a/arch/mips/pci/ops-tx4927.c
+++ b/arch/mips/pci/ops-tx4927.c
@@ -495,7 +495,7 @@ irqreturn_t tx4927_pcierr_interrupt(int irq, void *dev_id)
 }
 
 #ifdef CONFIG_TOSHIBA_FPCIB0
-static void __init tx4927_quirk_slc90e66_bridge(struct pci_dev *dev)
+static void __devinit tx4927_quirk_slc90e66_bridge(struct pci_dev *dev)
 {
 	struct tx4927_pcic_reg __iomem *pcicptr = pci_bus_to_pcicptr(dev->bus);
 
diff --git a/arch/mips/txx9/generic/pci.c b/arch/mips/txx9/generic/pci.c
index 682efb0..ce1ee50 100644
--- a/arch/mips/txx9/generic/pci.c
+++ b/arch/mips/txx9/generic/pci.c
@@ -256,7 +256,7 @@ static irqreturn_t i8259_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __init
+static int __devinit
 txx9_i8259_irq_setup(int irq)
 {
 	int err;
@@ -269,7 +269,7 @@ txx9_i8259_irq_setup(int irq)
 	return err;
 }
 
-static void __init quirk_slc90e66_bridge(struct pci_dev *dev)
+static void __devinit quirk_slc90e66_bridge(struct pci_dev *dev)
 {
 	int irq;	/* PCI/ISA Bridge interrupt */
 	u8 reg_64;

