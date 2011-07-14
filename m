Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1GNPdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:33:50 -0400
Received: from acsinet14.oracle.com ([141.146.126.236]:57016 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab1GNPdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:33:49 -0400
Message-ID: <4E1F0BC9.1040102@kernel.org>
Date: Thu, 14 Jul 2011 08:31:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Subject: [PATCH] x86, ioapic: Clean up ioapic/apic_id usage
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4E1F0BCE.0012,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While checking irte dump in dmesg, the print out is confused ioapic index
and real io apic id.

IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:00FF SQ:0 SVT:1)
IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:00FF SQ:0 SVT:1)

The system first ioapic id is 1.

While looking at the code, apic_id sometime is referred to index of ioapic, but
sometime is used for real apic id. and some even use apic for real apic id.
It is very confusing.

So try to limit apic_id to be real apic id for ioapic.
and use ioapic for ioapic index in the array.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |  186 ++++++++++++++++++++---------------------
 1 file changed, 94 insertions(+), 92 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -92,21 +92,21 @@ static struct ioapic {
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
-#define mpc_ioapic_ver(id)		ioapics[id].mp_config.apicver
+#define mpc_ioapic_ver(ioapic)		ioapics[ioapic].mp_config.apicver
 
-int mpc_ioapic_id(int id)
+int mpc_ioapic_id(int ioapic)
 {
-	return ioapics[id].mp_config.apicid;
+	return ioapics[ioapic].mp_config.apicid;
 }
 
-unsigned int mpc_ioapic_addr(int id)
+unsigned int mpc_ioapic_addr(int ioapic)
 {
-	return ioapics[id].mp_config.apicaddr;
+	return ioapics[ioapic].mp_config.apicaddr;
 }
 
-struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int id)
+struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic)
 {
-	return &ioapics[id].gsi_config;
+	return &ioapics[ioapic].gsi_config;
 }
 
 int nr_ioapics;
@@ -712,13 +712,13 @@ int restore_ioapic_entries(void)
 /*
  * Find the IRQ entry number of a certain pin.
  */
-static int find_irq_entry(int apic, int pin, int type)
+static int find_irq_entry(int ioapic, int pin, int type)
 {
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++)
 		if (mp_irqs[i].irqtype == type &&
-		    (mp_irqs[i].dstapic == mpc_ioapic_id(apic) ||
+		    (mp_irqs[i].dstapic == mpc_ioapic_id(ioapic) ||
 		     mp_irqs[i].dstapic == MP_APIC_ALL) &&
 		    mp_irqs[i].dstirq == pin)
 			return i;
@@ -758,10 +758,10 @@ static int __init find_isa_irq_apic(int
 			break;
 	}
 	if (i < mp_irq_entries) {
-		int apic;
-		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic)
-				return apic;
+		int ioapic;
+		for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
+			if (mpc_ioapic_id(ioapic) == mp_irqs[i].dstapic)
+				return ioapic;
 		}
 	}
 
@@ -977,7 +977,7 @@ static int pin_2_irq(int idx, int apic,
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 				struct io_apic_irq_attr *irq_attr)
 {
-	int apic, i, best_guess = -1;
+	int ioapic, i, best_guess = -1;
 
 	apic_printk(APIC_DEBUG,
 		    "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
@@ -990,8 +990,8 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
 
-		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic ||
+		for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
+			if (mpc_ioapic_id(ioapic) == mp_irqs[i].dstapic ||
 			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
 
@@ -999,13 +999,13 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 		    !mp_irqs[i].irqtype &&
 		    (bus == lbus) &&
 		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
+			int irq = pin_2_irq(i, ioapic, mp_irqs[i].dstirq);
 
-			if (!(apic || IO_APIC_IRQ(irq)))
+			if (!(ioapic || IO_APIC_IRQ(irq)))
 				continue;
 
 			if (pin == (mp_irqs[i].srcbusirq & 3)) {
-				set_io_apic_irq_attr(irq_attr, apic,
+				set_io_apic_irq_attr(irq_attr, ioapic,
 						     mp_irqs[i].dstirq,
 						     irq_trigger(i),
 						     irq_polarity(i));
@@ -1016,7 +1016,7 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 			 * best-guess fuzzy result for broken mptables.
 			 */
 			if (best_guess < 0) {
-				set_io_apic_irq_attr(irq_attr, apic,
+				set_io_apic_irq_attr(irq_attr, ioapic,
 						     mp_irqs[i].dstirq,
 						     irq_trigger(i),
 						     irq_polarity(i));
@@ -1255,7 +1255,7 @@ static void ioapic_register_intr(unsigne
 				      fasteoi ? "fasteoi" : "edge");
 }
 
-static int setup_ioapic_entry(int apic_id, int irq,
+static int setup_ioapic_entry(int ioapic, int irq,
 			      struct IO_APIC_route_entry *entry,
 			      unsigned int destination, int trigger,
 			      int polarity, int vector, int pin)
@@ -1266,6 +1266,7 @@ static int setup_ioapic_entry(int apic_i
 	memset(entry,0,sizeof(*entry));
 
 	if (intr_remapping_enabled) {
+		int apic_id = mpc_ioapic_id(ioapic);
 		struct intel_iommu *iommu = map_ioapic_to_ir(apic_id);
 		struct irte irte;
 		struct IR_IO_APIC_route_entry *ir_entry =
@@ -1301,7 +1302,7 @@ static int setup_ioapic_entry(int apic_i
 			"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
 			"Avail:%X Vector:%02X Dest:%08X "
 			"SID:%04X SQ:%X SVT:%X)\n",
-			apic_id, irte.present, irte.fpd, irte.dst_mode,
+			ioapic, irte.present, irte.fpd, irte.dst_mode,
 			irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
 			irte.avail, irte.vector, irte.dest_id,
 			irte.sid, irte.sq, irte.svt);
@@ -1324,7 +1325,7 @@ static int setup_ioapic_entry(int apic_i
 	return 0;
 }
 
-static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
+static void setup_ioapic_irq(int ioapic, int pin, unsigned int irq,
 			     struct irq_cfg *cfg, int trigger, int polarity)
 {
 	struct IO_APIC_route_entry entry;
@@ -1348,14 +1349,14 @@ static void setup_ioapic_irq(int apic_id
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i Dest:%d)\n",
-		    apic_id, mpc_ioapic_id(apic_id), pin, cfg->vector,
+		    ioapic, mpc_ioapic_id(ioapic), pin, cfg->vector,
 		    irq, trigger, polarity, dest);
 
 
-	if (setup_ioapic_entry(mpc_ioapic_id(apic_id), irq, &entry,
+	if (setup_ioapic_entry(ioapic, irq, &entry,
 			       dest, trigger, polarity, cfg->vector, pin)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mpc_ioapic_id(apic_id), pin);
+		       mpc_ioapic_id(ioapic), pin);
 		__clear_irq_vector(irq, cfg);
 		return;
 	}
@@ -1364,33 +1365,34 @@ static void setup_ioapic_irq(int apic_id
 	if (irq < legacy_pic->nr_legacy_irqs)
 		legacy_pic->mask(irq);
 
-	ioapic_write_entry(apic_id, pin, entry);
+	ioapic_write_entry(ioapic, pin, entry);
 }
 
-static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
+static bool __init io_apic_pin_not_connected(int idx, int ioapic, int pin)
 {
 	if (idx != -1)
 		return false;
 
-	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
-		    mpc_ioapic_id(apic_id), pin);
+	apic_printk(APIC_VERBOSE, KERN_DEBUG
+		    " ioapic %d pin %d not connected\n",
+		    mpc_ioapic_id(ioapic), pin);
 	return true;
 }
 
-static void __init __io_apic_setup_irqs(unsigned int apic_id)
+static void __init __io_apic_setup_irqs(unsigned int ioapic)
 {
 	int idx, node = cpu_to_node(0);
 	struct io_apic_irq_attr attr;
 	unsigned int pin, irq;
 
-	for (pin = 0; pin < ioapics[apic_id].nr_registers; pin++) {
-		idx = find_irq_entry(apic_id, pin, mp_INT);
-		if (io_apic_pin_not_connected(idx, apic_id, pin))
+	for (pin = 0; pin < ioapics[ioapic].nr_registers; pin++) {
+		idx = find_irq_entry(ioapic, pin, mp_INT);
+		if (io_apic_pin_not_connected(idx, ioapic, pin))
 			continue;
 
-		irq = pin_2_irq(idx, apic_id, pin);
+		irq = pin_2_irq(idx, ioapic, pin);
 
-		if ((apic_id > 0) && (irq > 16))
+		if ((ioapic > 0) && (irq > 16))
 			continue;
 
 		/*
@@ -1398,10 +1400,10 @@ static void __init __io_apic_setup_irqs(
 		 * installed and if it returns 1:
 		 */
 		if (apic->multi_timer_check &&
-		    apic->multi_timer_check(apic_id, irq))
+		    apic->multi_timer_check(ioapic, irq))
 			continue;
 
-		set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
+		set_io_apic_irq_attr(&attr, ioapic, pin, irq_trigger(idx),
 				     irq_polarity(idx));
 
 		io_apic_setup_irq_pin(irq, node, &attr);
@@ -1410,12 +1412,12 @@ static void __init __io_apic_setup_irqs(
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	unsigned int apic_id;
+	unsigned int ioapic;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
-		__io_apic_setup_irqs(apic_id);
+	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
+		__io_apic_setup_irqs(ioapic);
 }
 
 /*
@@ -1425,28 +1427,28 @@ static void __init setup_IO_APIC_irqs(vo
  */
 void setup_IO_APIC_irq_extra(u32 gsi)
 {
-	int apic_id = 0, pin, idx, irq, node = cpu_to_node(0);
+	int ioapic = 0, pin, idx, irq, node = cpu_to_node(0);
 	struct io_apic_irq_attr attr;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
 	 */
-	apic_id = mp_find_ioapic(gsi);
-	if (apic_id < 0)
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
 		return;
 
-	pin = mp_find_ioapic_pin(apic_id, gsi);
-	idx = find_irq_entry(apic_id, pin, mp_INT);
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+	idx = find_irq_entry(ioapic, pin, mp_INT);
 	if (idx == -1)
 		return;
 
-	irq = pin_2_irq(idx, apic_id, pin);
+	irq = pin_2_irq(idx, ioapic, pin);
 
 	/* Only handle the non legacy irqs on secondary ioapics */
-	if (apic_id == 0 || irq < NR_IRQS_LEGACY)
+	if (ioapic == 0 || irq < NR_IRQS_LEGACY)
 		return;
 
-	set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
+	set_io_apic_irq_attr(&attr, ioapic, pin, irq_trigger(idx),
 			     irq_polarity(idx));
 
 	io_apic_setup_irq_pin_once(irq, node, &attr);
@@ -1455,7 +1457,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 /*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
-static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
+static void __init setup_timer_IRQ0_pin(unsigned int ioapic, unsigned int pin,
 					int vector)
 {
 	struct IO_APIC_route_entry entry;
@@ -1487,13 +1489,13 @@ static void __init setup_timer_IRQ0_pin(
 	/*
 	 * Add it to the IO-APIC irq-routing table:
 	 */
-	ioapic_write_entry(apic_id, pin, entry);
+	ioapic_write_entry(ioapic, pin, entry);
 }
 
 
 __apicdebuginit(void) print_IO_APIC(void)
 {
-	int apic, i;
+	int ioapic, i;
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
 	union IO_APIC_reg_02 reg_02;
@@ -1513,19 +1515,19 @@ __apicdebuginit(void) print_IO_APIC(void
 	 */
 	printk(KERN_INFO "testing the IO APIC.......................\n");
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(apic, 0);
-	reg_01.raw = io_apic_read(apic, 1);
+	reg_00.raw = io_apic_read(ioapic, 0);
+	reg_01.raw = io_apic_read(ioapic, 1);
 	if (reg_01.bits.version >= 0x10)
-		reg_02.raw = io_apic_read(apic, 2);
+		reg_02.raw = io_apic_read(ioapic, 2);
 	if (reg_01.bits.version >= 0x20)
-		reg_03.raw = io_apic_read(apic, 3);
+		reg_03.raw = io_apic_read(ioapic, 3);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mpc_ioapic_id(apic));
+	printk(KERN_DEBUG "IO APIC #%d......\n", mpc_ioapic_id(ioapic));
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
@@ -1575,7 +1577,7 @@ __apicdebuginit(void) print_IO_APIC(void
 			struct IO_APIC_route_entry entry;
 			struct IR_IO_APIC_route_entry *ir_entry;
 
-			entry = ioapic_read_entry(apic, i);
+			entry = ioapic_read_entry(ioapic, i);
 			ir_entry = (struct IR_IO_APIC_route_entry *) &entry;
 			printk(KERN_DEBUG " %02x %04X ",
 				i,
@@ -1596,7 +1598,7 @@ __apicdebuginit(void) print_IO_APIC(void
 		} else {
 			struct IO_APIC_route_entry entry;
 
-			entry = ioapic_read_entry(apic, i);
+			entry = ioapic_read_entry(ioapic, i);
 			printk(KERN_DEBUG " %02x %02X  ",
 				i,
 				entry.dest
@@ -1953,7 +1955,7 @@ void __init setup_ioapic_ids_from_mpc_no
 {
 	union IO_APIC_reg_00 reg_00;
 	physid_mask_t phys_id_present_map;
-	int apic_id;
+	int ioapic;
 	int i;
 	unsigned char old_id;
 	unsigned long flags;
@@ -1967,21 +1969,21 @@ void __init setup_ioapic_ids_from_mpc_no
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
 	 */
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
+	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
 
 		/* Read the register 0 value */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic_id, 0);
+		reg_00.raw = io_apic_read(ioapic, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
-		old_id = mpc_ioapic_id(apic_id);
+		old_id = mpc_ioapic_id(ioapic);
 
-		if (mpc_ioapic_id(apic_id) >= get_physical_broadcast()) {
+		if (mpc_ioapic_id(ioapic) >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic_id, mpc_ioapic_id(apic_id));
+				ioapic, mpc_ioapic_id(ioapic));
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			ioapics[apic_id].mp_config.apicid = reg_00.bits.ID;
+			ioapics[ioapic].mp_config.apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -1990,9 +1992,9 @@ void __init setup_ioapic_ids_from_mpc_no
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (apic->check_apicid_used(&phys_id_present_map,
-					    mpc_ioapic_id(apic_id))) {
+					    mpc_ioapic_id(ioapic))) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic_id, mpc_ioapic_id(apic_id));
+				ioapic, mpc_ioapic_id(ioapic));
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -2001,14 +2003,14 @@ void __init setup_ioapic_ids_from_mpc_no
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			ioapics[apic_id].mp_config.apicid = i;
+			ioapics[ioapic].mp_config.apicid = i;
 		} else {
 			physid_mask_t tmp;
-			apic->apicid_to_cpu_present(mpc_ioapic_id(apic_id),
+			apic->apicid_to_cpu_present(mpc_ioapic_id(ioapic),
 						    &tmp);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mpc_ioapic_id(apic_id));
+					mpc_ioapic_id(ioapic));
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -2016,35 +2018,35 @@ void __init setup_ioapic_ids_from_mpc_no
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mpc_ioapic_id(apic_id))
+		if (old_id != mpc_ioapic_id(ioapic))
 			for (i = 0; i < mp_irq_entries; i++)
 				if (mp_irqs[i].dstapic == old_id)
 					mp_irqs[i].dstapic
-						= mpc_ioapic_id(apic_id);
+						= mpc_ioapic_id(ioapic);
 
 		/*
 		 * Update the ID register according to the right value
 		 * from the MPC table if they are different.
 		 */
-		if (mpc_ioapic_id(apic_id) == reg_00.bits.ID)
+		if (mpc_ioapic_id(ioapic) == reg_00.bits.ID)
 			continue;
 
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mpc_ioapic_id(apic_id));
+			mpc_ioapic_id(ioapic));
 
-		reg_00.bits.ID = mpc_ioapic_id(apic_id);
+		reg_00.bits.ID = mpc_ioapic_id(ioapic);
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		io_apic_write(apic_id, 0, reg_00.raw);
+		io_apic_write(ioapic, 0, reg_00.raw);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		/*
 		 * Sanity check
 		 */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic_id, 0);
+		reg_00.raw = io_apic_read(ioapic, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mpc_ioapic_id(apic_id))
+		if (reg_00.bits.ID != mpc_ioapic_id(ioapic))
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
@@ -2944,27 +2946,27 @@ static int __init io_apic_bug_finalize(v
 
 late_initcall(io_apic_bug_finalize);
 
-static void resume_ioapic_id(int ioapic_id)
+static void resume_ioapic_id(int ioapic)
 {
 	unsigned long flags;
 	union IO_APIC_reg_00 reg_00;
 
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(ioapic_id, 0);
-	if (reg_00.bits.ID != mpc_ioapic_id(ioapic_id)) {
-		reg_00.bits.ID = mpc_ioapic_id(ioapic_id);
-		io_apic_write(ioapic_id, 0, reg_00.raw);
+	reg_00.raw = io_apic_read(ioapic, 0);
+	if (reg_00.bits.ID != mpc_ioapic_id(ioapic)) {
+		reg_00.bits.ID = mpc_ioapic_id(ioapic);
+		io_apic_write(ioapic, 0, reg_00.raw);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void ioapic_resume(void)
 {
-	int ioapic_id;
+	int ioapic;
 
-	for (ioapic_id = nr_ioapics - 1; ioapic_id >= 0; ioapic_id--)
-		resume_ioapic_id(ioapic_id);
+	for (ioapic = nr_ioapics - 1; ioapic >= 0; ioapic--)
+		resume_ioapic_id(ioapic);
 
 	restore_ioapic_entries();
 }
@@ -3574,18 +3576,18 @@ io_apic_setup_irq_pin(unsigned int irq,
 int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 			       struct io_apic_irq_attr *attr)
 {
-	unsigned int id = attr->ioapic, pin = attr->ioapic_pin;
+	unsigned int ioapic = attr->ioapic, pin = attr->ioapic_pin;
 	int ret;
 
 	/* Avoid redundant programming */
-	if (test_bit(pin, ioapics[id].pin_programmed)) {
+	if (test_bit(pin, ioapics[ioapic].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
-			 mpc_ioapic_id(id), pin);
+			 mpc_ioapic_id(ioapic), pin);
 		return 0;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
 	if (!ret)
-		set_bit(pin, ioapics[id].pin_programmed);
+		set_bit(pin, ioapics[ioapic].pin_programmed);
 	return ret;
 }
 
