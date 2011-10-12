Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1JLHd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:33:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:64821 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1JLHd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:33:58 -0400
Message-ID: <4E9542BB.4070807@oracle.com>
Date: Wed, 12 Oct 2011 00:33:15 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] x86, ioapic: Split setup_ioapic_entry for interrupt remapped
 version
References: <4E1F0BC9.1040102@kernel.org> <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com> <4E29BEEA.4020600@kernel.org> <20110725072831.GB22518@elte.hu> <4E33334D.1030007@kernel.org>
In-Reply-To: <4E33334D.1030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E9542C9.0110:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo pointed out that setup_ioapic_entry is way too big now.

Try split into intr-remap related to setup_ir_ioapic_entry().

Also passing io_apic_irq_attr struct pointer instead of 5 parameters in those two
functions.

At last in setup_ir_ioapic_entry(), don't need to panic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |  147 +++++++++++++++++++++++------------------
 1 file changed, 84 insertions(+), 63 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1255,72 +1255,95 @@ static void ioapic_register_intr(unsigne
 				      fasteoi ? "fasteoi" : "edge");
 }
 
-static int setup_ioapic_entry(int apic_id, int irq,
-			      struct IO_APIC_route_entry *entry,
-			      unsigned int destination, int trigger,
-			      int polarity, int vector, int pin)
+
+static int setup_ir_ioapic_entry(int irq,
+			      struct IR_IO_APIC_route_entry *entry,
+			      unsigned int destination, int vector,
+			      struct io_apic_irq_attr *attr)
 {
-	/*
-	 * add it to the IO-APIC irq-routing table:
-	 */
-	memset(entry,0,sizeof(*entry));
+	int index;
+	struct irte irte;
+	int apic_id = mpc_ioapic_id(attr->ioapic);
+	struct intel_iommu *iommu = map_ioapic_to_ir(apic_id);
+
+	if (!iommu) {
+		pr_warn("No mapping iommu for ioapic %d\n", apic_id);
+		return -ENODEV;
+	}
 
-	if (intr_remapping_enabled) {
-		struct intel_iommu *iommu = map_ioapic_to_ir(apic_id);
-		struct irte irte;
-		struct IR_IO_APIC_route_entry *ir_entry =
-			(struct IR_IO_APIC_route_entry *) entry;
-		int index;
-
-		if (!iommu)
-			panic("No mapping iommu for ioapic %d\n", apic_id);
-
-		index = alloc_irte(iommu, irq, 1);
-		if (index < 0)
-			panic("Failed to allocate IRTE for ioapic %d\n", apic_id);
-
-		prepare_irte(&irte, vector, destination);
-
-		/* Set source-id of interrupt request */
-		set_ioapic_sid(&irte, apic_id);
-
-		modify_irte(irq, &irte);
-
-		ir_entry->index2 = (index >> 15) & 0x1;
-		ir_entry->zero = 0;
-		ir_entry->format = 1;
-		ir_entry->index = (index & 0x7fff);
-		/*
-		 * IO-APIC RTE will be configured with virtual vector.
-		 * irq handler will do the explicit EOI to the io-apic.
-		 */
-		ir_entry->vector = pin;
-
-		apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
-			"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
-			"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
-			"Avail:%X Vector:%02X Dest:%08X "
-			"SID:%04X SQ:%X SVT:%X)\n",
-			apic_id, irte.present, irte.fpd, irte.dst_mode,
-			irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
-			irte.avail, irte.vector, irte.dest_id,
-			irte.sid, irte.sq, irte.svt);
-	} else {
-		entry->delivery_mode = apic->irq_delivery_mode;
-		entry->dest_mode = apic->irq_dest_mode;
-		entry->dest = destination;
-		entry->vector = vector;
+	index = alloc_irte(iommu, irq, 1);
+	if (index < 0) {
+		pr_warn("Failed to allocate IRTE for ioapic %d\n", apic_id);
+		return -ENOMEM;
 	}
 
-	entry->mask = 0;				/* enable IRQ */
-	entry->trigger = trigger;
-	entry->polarity = polarity;
+	prepare_irte(&irte, vector, destination);
+
+	/* Set source-id of interrupt request */
+	set_ioapic_sid(&irte, apic_id);
+
+	modify_irte(irq, &irte);
+
+	apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
+		"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
+		"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
+		"Avail:%X Vector:%02X Dest:%08X "
+		"SID:%04X SQ:%X SVT:%X)\n",
+		apic_id, irte.present, irte.fpd, irte.dst_mode,
+		irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
+		irte.avail, irte.vector, irte.dest_id,
+		irte.sid, irte.sq, irte.svt);
+
+	memset(entry, 0, sizeof(*entry));
+
+	entry->index2	= (index >> 15) & 0x1;
+	entry->zero	= 0;
+	entry->format	= 1;
+	entry->index	= (index & 0x7fff);
+	/*
+	 * IO-APIC RTE will be configured with virtual vector.
+	 * irq handler will do the explicit EOI to the io-apic.
+	 */
+	entry->vector	= attr->ioapic_pin;
+	entry->mask	= 0;			/* enable IRQ */
+	entry->trigger	= attr->trigger;
+	entry->polarity	= attr->polarity;
 
 	/* Mask level triggered irqs.
 	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
 	 */
-	if (trigger)
+	if (attr->trigger)
+		entry->mask = 1;
+
+	return 0;
+}
+
+static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
+			       unsigned int destination, int vector,
+			       struct io_apic_irq_attr *attr)
+{
+	if (intr_remapping_enabled)
+		return setup_ir_ioapic_entry(irq,
+			 (struct IR_IO_APIC_route_entry *)entry,
+			 destination, vector, attr);
+
+	memset(entry, 0, sizeof(*entry));
+
+	entry->delivery_mode = apic->irq_delivery_mode;
+	entry->dest_mode     = apic->irq_dest_mode;
+	entry->dest	     = destination;
+	entry->vector	     = vector;
+	entry->mask	     = 0;			/* enable IRQ */
+	entry->trigger	     = attr->trigger;
+	entry->polarity	     = attr->polarity;
+
+	/*
+	 * Mask level triggered irqs.
+	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
+	 */
+	if (attr->trigger)
 		entry->mask = 1;
+
 	return 0;
 }
 
@@ -1351,13 +1374,11 @@ static void setup_ioapic_irq(unsigned in
 		    attr->ioapic, mpc_ioapic_id(attr->ioapic), attr->ioapic_pin,
 		    cfg->vector, irq, attr->trigger, attr->polarity, dest);
 
-
-	if (setup_ioapic_entry(mpc_ioapic_id(attr->ioapic), irq, &entry,
-			       dest, attr->trigger, attr->polarity, cfg->vector,
-			       attr->ioapic_pin)) {
-		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
+	if (setup_ioapic_entry(irq, &entry, dest, cfg->vector, attr)) {
+		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
+			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
 		__clear_irq_vector(irq, cfg);
+
 		return;
 	}
 
