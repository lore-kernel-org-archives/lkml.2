Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0I3XRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:49 -0400
Received: from www.tglx.de ([62.245.132.106]:52926 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab0I3XRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:46 -0400
Message-Id: <20100930221741.720879189@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:17:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 33/47] pci: Cleanup the irq_desc mess in msi
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=pci-cleanup-msi-irq-desc-mess.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handing down irq_desc to msi just so that msi can access
irq_desc.irq_data.msi_desc is a pretty stupid idea. The calling code
can hand down a pointer to msi_desc so msi code does not need to know
about the irq descriptor at all.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 drivers/pci/msi.c              |   24 +++++++++---------------
 include/linux/msi.h            |    8 ++++----
 3 files changed, 15 insertions(+), 21 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -3353,14 +3353,14 @@ static int set_msi_irq_affinity(unsigned
 
 	cfg = get_irq_desc_chip_data(desc);
 
-	get_cached_msi_msg_desc(desc, &msg);
+	__get_cached_msi_msg(desc->irq_data.msi_desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	write_msi_msg_desc(desc, &msg);
+	__write_msi_msg(desc->irq_data.msi_desc, &msg);
 
 	return 0;
 }
Index: linux-2.6-tip/drivers/pci/msi.c
===================================================================
--- linux-2.6-tip.orig/drivers/pci/msi.c
+++ linux-2.6-tip/drivers/pci/msi.c
@@ -193,10 +193,8 @@ void unmask_msi_irq(struct irq_data *dat
 	msi_set_mask_bit(data, 0);
 }
 
-void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
+void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
-	struct msi_desc *entry = get_irq_desc_msi(desc);
-
 	BUG_ON(entry->dev->current_state != PCI_D0);
 
 	if (entry->msi_attrib.is_msix) {
@@ -227,15 +225,13 @@ void read_msi_msg_desc(struct irq_desc *
 
 void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct msi_desc *entry = get_irq_msi(irq);
 
-	read_msi_msg_desc(desc, msg);
+	__read_msi_msg(entry, msg);
 }
 
-void get_cached_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
+void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
-	struct msi_desc *entry = get_irq_desc_msi(desc);
-
 	/* Assert that the cache is valid, assuming that
 	 * valid messages are not all-zeroes. */
 	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
@@ -246,15 +242,13 @@ void get_cached_msi_msg_desc(struct irq_
 
 void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct msi_desc *entry = get_irq_msi(irq);
 
-	get_cached_msi_msg_desc(desc, msg);
+	__get_cached_msi_msg(entry, msg);
 }
 
-void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
+void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
-	struct msi_desc *entry = get_irq_desc_msi(desc);
-
 	if (entry->dev->current_state != PCI_D0) {
 		/* Don't touch the hardware now */
 	} else if (entry->msi_attrib.is_msix) {
@@ -292,9 +286,9 @@ void write_msi_msg_desc(struct irq_desc 
 
 void write_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct msi_desc *entry = get_irq_msi(irq);
 
-	write_msi_msg_desc(desc, msg);
+	__write_msi_msg(entry, msg);
 }
 
 static void free_msi_irqs(struct pci_dev *dev)
Index: linux-2.6-tip/include/linux/msi.h
===================================================================
--- linux-2.6-tip.orig/include/linux/msi.h
+++ linux-2.6-tip/include/linux/msi.h
@@ -10,13 +10,13 @@ struct msi_msg {
 };
 
 /* Helper functions */
-struct irq_desc;
 struct irq_data;
+struct msi_desc;
 extern void mask_msi_irq(struct irq_data *data);
 extern void unmask_msi_irq(struct irq_data *data);
-extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
-extern void get_cached_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
-extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
+extern void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+extern void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+extern void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);


