Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab1GOMxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 08:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1GOMxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 08:53:38 -0400
From: Stefan Assmann <sassmann@kpanic.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, jeremy@goop.org,
        mingo@redhat.com, tglx@linutronix.de, rostedt@goodmis.org,
        sassmann@kpanic.de
Subject: [PATCH] ACPI: fix CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
Date: Fri, 15 Jul 2011 14:52:30 +0200
Message-Id: <1310734350-15947-1-git-send-email-sassmann@kpanic.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following was observed by Steve Rostedt on 3.0.0-rc5
Backtrace:
irq 16: nobody cared (try booting with the "irqpoll" option)
Pid: 65, comm: irq/16-uhci_hcd Not tainted 3.0.0-rc5-test+ #94
Call Trace:
 [<ffffffff810aa643>] __report_bad_irq+0x37/0xc1
 [<ffffffff810aaa2d>] note_interrupt+0x14e/0x1c9
 [<ffffffff810a9a05>] ? irq_thread_fn+0x3c/0x3c
 [<ffffffff810a990e>] irq_thread+0xf6/0x1b1
 [<ffffffff810a9818>] ? irq_finalize_oneshot+0xb3/0xb3
 [<ffffffff8106b4d6>] kthread+0x9f/0xa7
 [<ffffffff814f1f04>] kernel_thread_helper+0x4/0x10
 [<ffffffff8103ca09>] ? finish_task_switch+0x7b/0xc0
 [<ffffffff814eac78>] ? retint_restore_args+0x13/0x13
 [<ffffffff8106b437>] ? __init_kthread_worker+0x5a/0x5a
 [<ffffffff814f1f00>] ? gs_change+0x13/0x13
handlers:
[<ffffffff810a912d>] irq_default_primary_handler threaded [<ffffffff8135eaa6>] usb_hcd_irq
[<ffffffff810a912d>] irq_default_primary_handler threaded [<ffffffff8135eaa6>] usb_hcd_irq
Disabling IRQ #16

The problem being that a device triggers boot interrupts (due to threaded
interrupt handling and masking of the IO-APIC), which are forwarded
to the PIRQ line of the device. These interrupts are not handled on the PIRQ
line because the interrupt handler is not present there.
This should have already been fixed by CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS.
However some parts of the quirk got lost in the ACPI merge. This is a resent of
the patch proposed in 2009.
See http://lkml.org/lkml/2009/9/7/192

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/pci_irq.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index f907cfb..7f9eba9 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -303,6 +303,61 @@ void acpi_pci_irq_del_prt(struct pci_bus *bus)
 /* --------------------------------------------------------------------------
                           PCI Interrupt Routing Support
    -------------------------------------------------------------------------- */
+#ifdef CONFIG_X86_IO_APIC
+extern int noioapicquirk;
+extern int noioapicreroute;
+
+static int bridge_has_boot_interrupt_variant(struct pci_bus *bus)
+{
+	struct pci_bus *bus_it;
+
+	for (bus_it = bus ; bus_it ; bus_it = bus_it->parent) {
+		if (!bus_it->self)
+			return 0;
+		if (bus_it->self->irq_reroute_variant)
+			return bus_it->self->irq_reroute_variant;
+	}
+	return 0;
+}
+
+/*
+ * Some chipsets (e.g. Intel 6700PXH) generate a legacy INTx when the IRQ
+ * entry in the chipset's IO-APIC is masked (as, e.g. the RT kernel does
+ * during interrupt handling). When this INTx generation cannot be disabled,
+ * we reroute these interrupts to their legacy equivalent to get rid of
+ * spurious interrupts.
+ */
+static int acpi_reroute_boot_interrupt(struct pci_dev *dev,
+				       struct acpi_prt_entry *entry)
+{
+	if (noioapicquirk || noioapicreroute) {
+		return 0;
+	} else {
+		switch (bridge_has_boot_interrupt_variant(dev->bus)) {
+		case 0:
+			/* no rerouting necessary */
+			return 0;
+		case INTEL_IRQ_REROUTE_VARIANT:
+			/*
+			 * Remap according to INTx routing table in 6700PXH
+			 * specs, intel order number 302628-002, section
+			 * 2.15.2. Other chipsets (80332, ...) have the same
+			 * mapping and are handled here as well.
+			 */
+			dev_info(&dev->dev, "PCI IRQ %d -> rerouted to legacy "
+				 "IRQ %d\n", entry->index,
+				 (entry->index % 4) + 16);
+			entry->index = (entry->index % 4) + 16;
+			return 1;
+		default:
+			dev_warn(&dev->dev, "Cannot reroute IRQ %d to legacy "
+				 "IRQ: unknown mapping\n", entry->index);
+			return -1;
+		}
+	}
+}
+#endif /* CONFIG_X86_IO_APIC */
+
 static struct acpi_prt_entry *acpi_pci_irq_lookup(struct pci_dev *dev, int pin)
 {
 	struct acpi_prt_entry *entry;
@@ -311,6 +366,9 @@ static struct acpi_prt_entry *acpi_pci_irq_lookup(struct pci_dev *dev, int pin)
 
 	entry = acpi_pci_irq_find_prt_entry(dev, pin);
 	if (entry) {
+#ifdef CONFIG_X86_IO_APIC
+		acpi_reroute_boot_interrupt(dev, entry);
+#endif /* CONFIG_X86_IO_APIC */
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Found %s[%c] _PRT entry\n",
 				  pci_name(dev), pin_name(pin)));
 		return entry;
-- 
1.7.4.4

