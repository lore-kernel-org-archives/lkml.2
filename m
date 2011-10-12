Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab1JLHeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:34:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:65038 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab1JLHe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:34:28 -0400
Message-ID: <4E9542DC.3090509@oracle.com>
Date: Wed, 12 Oct 2011 00:33:48 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] x86, ioapic: Clean up ioapic/apic_id usage
References: <4E1F0BC9.1040102@kernel.org> <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com> <4E29BEEA.4020600@kernel.org> <20110725072831.GB22518@elte.hu> <4E33334D.1030007@kernel.org>
In-Reply-To: <4E33334D.1030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090202.4E9542E8.0035,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at the code, apic_id sometime is referred to index of ioapic, but
sometime is used for phys apic id. and some even use apic for real apic id.
It is very confusing.

So try to limit apic_id or ioapic_id to be real apic id for ioapic.
and use ioapic_idx for ioapic index in the array.

-v2: according to Ingo, to use ioapic_idx instead of ioapic

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |  194 ++++++++++++++++++++---------------------
 1 file changed, 97 insertions(+), 97 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -92,21 +92,21 @@ static struct ioapic {
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
-#define mpc_ioapic_ver(id)		ioapics[id].mp_config.apicver
+#define mpc_ioapic_ver(ioapic_idx)	ioapics[ioapic_idx].mp_config.apicver
 
-int mpc_ioapic_id(int id)
+int mpc_ioapic_id(int ioapic_idx)
 {
-	return ioapics[id].mp_config.apicid;
+	return ioapics[ioapic_idx].mp_config.apicid;
 }
 
-unsigned int mpc_ioapic_addr(int id)
+unsigned int mpc_ioapic_addr(int ioapic_idx)
 {
-	return ioapics[id].mp_config.apicaddr;
+	return ioapics[ioapic_idx].mp_config.apicaddr;
 }
 
-struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int id)
+struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
 {
-	return &ioapics[id].gsi_config;
+	return &ioapics[ioapic_idx].gsi_config;
 }
 
 int nr_ioapics;
@@ -712,13 +712,13 @@ int restore_ioapic_entries(void)
 /*
  * Find the IRQ entry number of a certain pin.
  */
-static int find_irq_entry(int apic, int pin, int type)
+static int find_irq_entry(int ioapic_idx, int pin, int type)
 {
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++)
 		if (mp_irqs[i].irqtype == type &&
-		    (mp_irqs[i].dstapic == mpc_ioapic_id(apic) ||
+		    (mp_irqs[i].dstapic == mpc_ioapic_id(ioapic_idx) ||
 		     mp_irqs[i].dstapic == MP_APIC_ALL) &&
 		    mp_irqs[i].dstirq == pin)
 			return i;
@@ -757,12 +757,13 @@ static int __init find_isa_irq_apic(int
 		    (mp_irqs[i].srcbusirq == irq))
 			break;
 	}
+
 	if (i < mp_irq_entries) {
-		int apic;
-		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic)
-				return apic;
-		}
+		int ioapic_idx;
+
+		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic)
+				return ioapic_idx;
 	}
 
 	return -1;
@@ -977,7 +978,7 @@ static int pin_2_irq(int idx, int apic,
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 				struct io_apic_irq_attr *irq_attr)
 {
-	int apic, i, best_guess = -1;
+	int ioapic_idx, i, best_guess = -1;
 
 	apic_printk(APIC_DEBUG,
 		    "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
@@ -990,8 +991,8 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
 
-		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic ||
+		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic ||
 			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
 
@@ -999,13 +1000,13 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 		    !mp_irqs[i].irqtype &&
 		    (bus == lbus) &&
 		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
+			int irq = pin_2_irq(i, ioapic_idx, mp_irqs[i].dstirq);
 
-			if (!(apic || IO_APIC_IRQ(irq)))
+			if (!(ioapic_idx || IO_APIC_IRQ(irq)))
 				continue;
 
 			if (pin == (mp_irqs[i].srcbusirq & 3)) {
-				set_io_apic_irq_attr(irq_attr, apic,
+				set_io_apic_irq_attr(irq_attr, ioapic_idx,
 						     mp_irqs[i].dstirq,
 						     irq_trigger(i),
 						     irq_polarity(i));
@@ -1016,7 +1017,7 @@ int IO_APIC_get_PCI_irq_vector(int bus,
 			 * best-guess fuzzy result for broken mptables.
 			 */
 			if (best_guess < 0) {
-				set_io_apic_irq_attr(irq_attr, apic,
+				set_io_apic_irq_attr(irq_attr, ioapic_idx,
 						     mp_irqs[i].dstirq,
 						     irq_trigger(i),
 						     irq_polarity(i));
@@ -1263,24 +1264,24 @@ static int setup_ir_ioapic_entry(int irq
 {
 	int index;
 	struct irte irte;
-	int apic_id = mpc_ioapic_id(attr->ioapic);
-	struct intel_iommu *iommu = map_ioapic_to_ir(apic_id);
+	int ioapic_id = mpc_ioapic_id(attr->ioapic);
+	struct intel_iommu *iommu = map_ioapic_to_ir(ioapic_id);
 
 	if (!iommu) {
-		pr_warn("No mapping iommu for ioapic %d\n", apic_id);
+		pr_warn("No mapping iommu for ioapic %d\n", ioapic_id);
 		return -ENODEV;
 	}
 
 	index = alloc_irte(iommu, irq, 1);
 	if (index < 0) {
-		pr_warn("Failed to allocate IRTE for ioapic %d\n", apic_id);
+		pr_warn("Failed to allocate IRTE for ioapic %d\n", ioapic_id);
 		return -ENOMEM;
 	}
 
 	prepare_irte(&irte, vector, destination);
 
 	/* Set source-id of interrupt request */
-	set_ioapic_sid(&irte, apic_id);
+	set_ioapic_sid(&irte, ioapic_id);
 
 	modify_irte(irq, &irte);
 
@@ -1389,30 +1390,30 @@ static void setup_ioapic_irq(unsigned in
 	ioapic_write_entry(attr->ioapic, attr->ioapic_pin, entry);
 }
 
-static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
+static bool __init io_apic_pin_not_connected(int idx, int ioapic_idx, int pin)
 {
 	if (idx != -1)
 		return false;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
-		    mpc_ioapic_id(apic_id), pin);
+		    mpc_ioapic_id(ioapic_idx), pin);
 	return true;
 }
 
-static void __init __io_apic_setup_irqs(unsigned int apic_id)
+static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
 {
 	int idx, node = cpu_to_node(0);
 	struct io_apic_irq_attr attr;
 	unsigned int pin, irq;
 
-	for (pin = 0; pin < ioapics[apic_id].nr_registers; pin++) {
-		idx = find_irq_entry(apic_id, pin, mp_INT);
-		if (io_apic_pin_not_connected(idx, apic_id, pin))
+	for (pin = 0; pin < ioapics[ioapic_idx].nr_registers; pin++) {
+		idx = find_irq_entry(ioapic_idx, pin, mp_INT);
+		if (io_apic_pin_not_connected(idx, ioapic_idx, pin))
 			continue;
 
-		irq = pin_2_irq(idx, apic_id, pin);
+		irq = pin_2_irq(idx, ioapic_idx, pin);
 
-		if ((apic_id > 0) && (irq > 16))
+		if ((ioapic_idx > 0) && (irq > 16))
 			continue;
 
 		/*
@@ -1420,10 +1421,10 @@ static void __init __io_apic_setup_irqs(
 		 * installed and if it returns 1:
 		 */
 		if (apic->multi_timer_check &&
-		    apic->multi_timer_check(apic_id, irq))
+		    apic->multi_timer_check(ioapic_idx, irq))
 			continue;
 
-		set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
+		set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
 				     irq_polarity(idx));
 
 		io_apic_setup_irq_pin(irq, node, &attr);
@@ -1432,12 +1433,12 @@ static void __init __io_apic_setup_irqs(
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	unsigned int apic_id;
+	unsigned int ioapic_idx;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
-		__io_apic_setup_irqs(apic_id);
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		__io_apic_setup_irqs(ioapic_idx);
 }
 
 /*
@@ -1447,28 +1448,28 @@ static void __init setup_IO_APIC_irqs(vo
  */
 void setup_IO_APIC_irq_extra(u32 gsi)
 {
-	int apic_id = 0, pin, idx, irq, node = cpu_to_node(0);
+	int ioapic_idx = 0, pin, idx, irq, node = cpu_to_node(0);
 	struct io_apic_irq_attr attr;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
 	 */
-	apic_id = mp_find_ioapic(gsi);
-	if (apic_id < 0)
+	ioapic_idx = mp_find_ioapic(gsi);
+	if (ioapic_idx < 0)
 		return;
 
-	pin = mp_find_ioapic_pin(apic_id, gsi);
-	idx = find_irq_entry(apic_id, pin, mp_INT);
+	pin = mp_find_ioapic_pin(ioapic_idx, gsi);
+	idx = find_irq_entry(ioapic_idx, pin, mp_INT);
 	if (idx == -1)
 		return;
 
-	irq = pin_2_irq(idx, apic_id, pin);
+	irq = pin_2_irq(idx, ioapic_idx, pin);
 
 	/* Only handle the non legacy irqs on secondary ioapics */
-	if (apic_id == 0 || irq < NR_IRQS_LEGACY)
+	if (ioapic_idx == 0 || irq < NR_IRQS_LEGACY)
 		return;
 
-	set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
+	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
 			     irq_polarity(idx));
 
 	io_apic_setup_irq_pin_once(irq, node, &attr);
@@ -1477,8 +1478,8 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 /*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
-static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
-					int vector)
+static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
+					 unsigned int pin, int vector)
 {
 	struct IO_APIC_route_entry entry;
 
@@ -1509,10 +1510,10 @@ static void __init setup_timer_IRQ0_pin(
 	/*
 	 * Add it to the IO-APIC irq-routing table:
 	 */
-	ioapic_write_entry(apic_id, pin, entry);
+	ioapic_write_entry(ioapic_idx, pin, entry);
 }
 
-__apicdebuginit(void) print_IO_APIC(int apic)
+__apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 {
 	int i;
 	union IO_APIC_reg_00 reg_00;
@@ -1522,16 +1523,16 @@ __apicdebuginit(void) print_IO_APIC(int
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(apic, 0);
-	reg_01.raw = io_apic_read(apic, 1);
+	reg_00.raw = io_apic_read(ioapic_idx, 0);
+	reg_01.raw = io_apic_read(ioapic_idx, 1);
 	if (reg_01.bits.version >= 0x10)
-		reg_02.raw = io_apic_read(apic, 2);
+		reg_02.raw = io_apic_read(ioapic_idx, 2);
 	if (reg_01.bits.version >= 0x20)
-		reg_03.raw = io_apic_read(apic, 3);
+		reg_03.raw = io_apic_read(ioapic_idx, 3);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mpc_ioapic_id(apic));
+	printk(KERN_DEBUG "IO APIC #%d......\n", mpc_ioapic_id(ioapic_idx));
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
@@ -1581,7 +1582,7 @@ __apicdebuginit(void) print_IO_APIC(int
 			struct IO_APIC_route_entry entry;
 			struct IR_IO_APIC_route_entry *ir_entry;
 
-			entry = ioapic_read_entry(apic, i);
+			entry = ioapic_read_entry(ioapic_idx, i);
 			ir_entry = (struct IR_IO_APIC_route_entry *) &entry;
 			printk(KERN_DEBUG " %02x %04X ",
 				i,
@@ -1602,7 +1603,7 @@ __apicdebuginit(void) print_IO_APIC(int
 		} else {
 			struct IO_APIC_route_entry entry;
 
-			entry = ioapic_read_entry(apic, i);
+			entry = ioapic_read_entry(ioapic_idx, i);
 			printk(KERN_DEBUG " %02x %02X  ",
 				i,
 				entry.dest
@@ -1624,14 +1625,15 @@ __apicdebuginit(void) print_IO_APIC(int
 
 __apicdebuginit(void) print_IO_APICs(void)
 {
-	int apic, i;
+	int ioapic_idx;
 	struct irq_cfg *cfg;
 	unsigned int irq;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
-	for (i = 0; i < nr_ioapics; i++)
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mpc_ioapic_id(i), ioapics[i].nr_registers);
+		       mpc_ioapic_id(ioapic_idx),
+		       ioapics[ioapic_idx].nr_registers);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -1639,8 +1641,8 @@ __apicdebuginit(void) print_IO_APICs(voi
 	 */
 	printk(KERN_INFO "testing the IO APIC.......................\n");
 
-	for (apic = 0; apic < nr_ioapics; apic++)
-		print_IO_APIC(apic);
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		print_IO_APIC(ioapic_idx);
 
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
 	for_each_active_irq(irq) {
@@ -1977,7 +1979,7 @@ void __init setup_ioapic_ids_from_mpc_no
 {
 	union IO_APIC_reg_00 reg_00;
 	physid_mask_t phys_id_present_map;
-	int apic_id;
+	int ioapic_idx;
 	int i;
 	unsigned char old_id;
 	unsigned long flags;
@@ -1991,21 +1993,20 @@ void __init setup_ioapic_ids_from_mpc_no
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
 	 */
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
-
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
 		/* Read the register 0 value */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic_id, 0);
+		reg_00.raw = io_apic_read(ioapic_idx, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
-		old_id = mpc_ioapic_id(apic_id);
+		old_id = mpc_ioapic_id(ioapic_idx);
 
-		if (mpc_ioapic_id(apic_id) >= get_physical_broadcast()) {
+		if (mpc_ioapic_id(ioapic_idx) >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic_id, mpc_ioapic_id(apic_id));
+				ioapic_idx, mpc_ioapic_id(ioapic_idx));
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			ioapics[apic_id].mp_config.apicid = reg_00.bits.ID;
+			ioapics[ioapic_idx].mp_config.apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -2014,9 +2015,9 @@ void __init setup_ioapic_ids_from_mpc_no
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (apic->check_apicid_used(&phys_id_present_map,
-					    mpc_ioapic_id(apic_id))) {
+					    mpc_ioapic_id(ioapic_idx))) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic_id, mpc_ioapic_id(apic_id));
+				ioapic_idx, mpc_ioapic_id(ioapic_idx));
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -2025,14 +2026,14 @@ void __init setup_ioapic_ids_from_mpc_no
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			ioapics[apic_id].mp_config.apicid = i;
+			ioapics[ioapic_idx].mp_config.apicid = i;
 		} else {
 			physid_mask_t tmp;
-			apic->apicid_to_cpu_present(mpc_ioapic_id(apic_id),
+			apic->apicid_to_cpu_present(mpc_ioapic_id(ioapic_idx),
 						    &tmp);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mpc_ioapic_id(apic_id));
+					mpc_ioapic_id(ioapic_idx));
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -2040,35 +2041,35 @@ void __init setup_ioapic_ids_from_mpc_no
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mpc_ioapic_id(apic_id))
+		if (old_id != mpc_ioapic_id(ioapic_idx))
 			for (i = 0; i < mp_irq_entries; i++)
 				if (mp_irqs[i].dstapic == old_id)
 					mp_irqs[i].dstapic
-						= mpc_ioapic_id(apic_id);
+						= mpc_ioapic_id(ioapic_idx);
 
 		/*
 		 * Update the ID register according to the right value
 		 * from the MPC table if they are different.
 		 */
-		if (mpc_ioapic_id(apic_id) == reg_00.bits.ID)
+		if (mpc_ioapic_id(ioapic_idx) == reg_00.bits.ID)
 			continue;
 
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mpc_ioapic_id(apic_id));
+			mpc_ioapic_id(ioapic_idx));
 
-		reg_00.bits.ID = mpc_ioapic_id(apic_id);
+		reg_00.bits.ID = mpc_ioapic_id(ioapic_idx);
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		io_apic_write(apic_id, 0, reg_00.raw);
+		io_apic_write(ioapic_idx, 0, reg_00.raw);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		/*
 		 * Sanity check
 		 */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic_id, 0);
+		reg_00.raw = io_apic_read(ioapic_idx, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mpc_ioapic_id(apic_id))
+		if (reg_00.bits.ID != mpc_ioapic_id(ioapic_idx))
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
@@ -2968,27 +2969,26 @@ static int __init io_apic_bug_finalize(v
 
 late_initcall(io_apic_bug_finalize);
 
-static void resume_ioapic_id(int ioapic_id)
+static void resume_ioapic_id(int ioapic_idx)
 {
 	unsigned long flags;
 	union IO_APIC_reg_00 reg_00;
 
-
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(ioapic_id, 0);
-	if (reg_00.bits.ID != mpc_ioapic_id(ioapic_id)) {
-		reg_00.bits.ID = mpc_ioapic_id(ioapic_id);
-		io_apic_write(ioapic_id, 0, reg_00.raw);
+	reg_00.raw = io_apic_read(ioapic_idx, 0);
+	if (reg_00.bits.ID != mpc_ioapic_id(ioapic_idx)) {
+		reg_00.bits.ID = mpc_ioapic_id(ioapic_idx);
+		io_apic_write(ioapic_idx, 0, reg_00.raw);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void ioapic_resume(void)
 {
-	int ioapic_id;
+	int ioapic_idx;
 
-	for (ioapic_id = nr_ioapics - 1; ioapic_id >= 0; ioapic_id--)
-		resume_ioapic_id(ioapic_id);
+	for (ioapic_idx = nr_ioapics - 1; ioapic_idx >= 0; ioapic_idx--)
+		resume_ioapic_id(ioapic_idx);
 
 	restore_ioapic_entries();
 }
@@ -3597,18 +3597,18 @@ io_apic_setup_irq_pin(unsigned int irq,
 int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 			       struct io_apic_irq_attr *attr)
 {
-	unsigned int id = attr->ioapic, pin = attr->ioapic_pin;
+	unsigned int ioapic_idx = attr->ioapic, pin = attr->ioapic_pin;
 	int ret;
 
 	/* Avoid redundant programming */
-	if (test_bit(pin, ioapics[id].pin_programmed)) {
+	if (test_bit(pin, ioapics[ioapic_idx].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
-			 mpc_ioapic_id(id), pin);
+			 mpc_ioapic_id(ioapic_idx), pin);
 		return 0;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
 	if (!ret)
-		set_bit(pin, ioapics[id].pin_programmed);
+		set_bit(pin, ioapics[ioapic_idx].pin_programmed);
 	return ret;
 }
 
