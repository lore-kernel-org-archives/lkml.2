Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326Ab1ETNju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:39:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:36043 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911Ab1ETNjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:39:48 -0400
Date: Fri, 20 May 2011 13:39:38 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-d5371430840f3e8d3b8bdbc9c02867808f299449@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110518233157.909013179@sbsiddha-MOBL3.sc.intel.com>
References: <20110518233157.909013179@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Consolidate mp_ioapics[] into 'struct ioapic'
Git-Commit-ID: d5371430840f3e8d3b8bdbc9c02867808f299449
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:39:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5371430840f3e8d3b8bdbc9c02867808f299449
Gitweb:     http://git.kernel.org/tip/d5371430840f3e8d3b8bdbc9c02867808f299449
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 18 May 2011 16:31:37 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:40:59 +0200

x86, ioapic: Consolidate mp_ioapics[] into 'struct ioapic'

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: daniel.blueman@gmail.com
Link: http://lkml.kernel.org/r/20110518233157.909013179@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io_apic.h |    6 +-
 arch/x86/kernel/acpi/boot.c    |    8 ++--
 arch/x86/kernel/apic/io_apic.c |   94 ++++++++++++++++++++++-----------------
 arch/x86/kernel/devicetree.c   |    2 +-
 arch/x86/kernel/mpparse.c      |    2 +-
 5 files changed, 62 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 147700a..4f07bf6 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -106,10 +106,10 @@ struct IR_IO_APIC_route_entry {
  */
 extern int nr_ioapics;
 
-#define MP_MAX_IOAPIC_PIN 127
+extern int mpc_ioapic_id(int ioapic);
+extern unsigned int mpc_ioapic_addr(int ioapic);
 
-/* I/O APIC entries */
-extern struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
+#define MP_MAX_IOAPIC_PIN 127
 
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 9a966c5..4558f0d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -970,7 +970,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irq.irqflag = (trigger << 2) | polarity;
 	mp_irq.srcbus = MP_ISA_BUS;
 	mp_irq.srcbusirq = bus_irq;	/* IRQ */
-	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
+	mp_irq.dstapic = mpc_ioapic_id(ioapic); /* APIC ID */
 	mp_irq.dstirq = pin;	/* INTIN# */
 
 	mp_save_irq(&mp_irq);
@@ -1021,7 +1021,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 		if (ioapic < 0)
 			continue;
 		pin = mp_find_ioapic_pin(ioapic, gsi);
-		dstapic = mp_ioapics[ioapic].apicid;
+		dstapic = mpc_ioapic_id(ioapic);
 
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mpc_intsrc *irq = mp_irqs + idx;
@@ -1082,7 +1082,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 	mp_irq.srcbus = number;
 	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
-	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
+	mp_irq.dstapic = mpc_ioapic_id(ioapic);
 	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
 	mp_save_irq(&mp_irq);
@@ -1113,7 +1113,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mp_ioapics[ioapic].apicid,
+		       "%d-%d\n", mpc_ioapic_id(ioapic),
 		       ioapic_pin);
 		return gsi;
 	}
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ceff2d2..e911315 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -85,10 +85,22 @@ static struct ioapic {
 	 * Saved state during suspend/resume, or while enabling intr-remap.
 	 */
 	struct IO_APIC_route_entry *saved_registers;
+	/* I/O APIC config */
+	struct mpc_ioapic mp_config;
 } ioapics[MAX_IO_APICS];
 
-/* I/O APIC entries */
-struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
+#define mpc_ioapic_ver(id)		ioapics[id].mp_config.apicver
+
+int mpc_ioapic_id(int id)
+{
+	return ioapics[id].mp_config.apicid;
+}
+
+unsigned int mpc_ioapic_addr(int id)
+{
+	return ioapics[id].mp_config.apicaddr;
+}
+
 int nr_ioapics;
 
 /* IO APIC gsi routing info */
@@ -311,7 +323,7 @@ struct io_apic {
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 {
 	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
-		+ (mp_ioapics[idx].apicaddr & ~PAGE_MASK);
+		+ (mpc_ioapic_addr(idx) & ~PAGE_MASK);
 }
 
 static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
@@ -701,7 +713,7 @@ static int find_irq_entry(int apic, int pin, int type)
 
 	for (i = 0; i < mp_irq_entries; i++)
 		if (mp_irqs[i].irqtype == type &&
-		    (mp_irqs[i].dstapic == mp_ioapics[apic].apicid ||
+		    (mp_irqs[i].dstapic == mpc_ioapic_id(apic) ||
 		     mp_irqs[i].dstapic == MP_APIC_ALL) &&
 		    mp_irqs[i].dstirq == pin)
 			return i;
@@ -743,7 +755,7 @@ static int __init find_isa_irq_apic(int irq, int type)
 	if (i < mp_irq_entries) {
 		int apic;
 		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic)
+			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic)
 				return apic;
 		}
 	}
@@ -973,7 +985,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 		int lbus = mp_irqs[i].srcbus;
 
 		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
+			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic ||
 			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
 
@@ -1320,14 +1332,14 @@ static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i)\n",
-		    apic_id, mp_ioapics[apic_id].apicid, pin, cfg->vector,
+		    apic_id, mpc_ioapic_id(apic_id), pin, cfg->vector,
 		    irq, trigger, polarity);
 
 
-	if (setup_ioapic_entry(mp_ioapics[apic_id].apicid, irq, &entry,
+	if (setup_ioapic_entry(mpc_ioapic_id(apic_id), irq, &entry,
 			       dest, trigger, polarity, cfg->vector, pin)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mp_ioapics[apic_id].apicid, pin);
+		       mpc_ioapic_id(apic_id), pin);
 		__clear_irq_vector(irq, cfg);
 		return;
 	}
@@ -1349,7 +1361,7 @@ static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
 		return false;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
-		    mp_ioapics[apic_id].apicid, pin);
+		    mpc_ioapic_id(apic_id), pin);
 	return true;
 }
 
@@ -1481,7 +1493,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].apicid, ioapics[i].nr_registers);
+		       mpc_ioapic_id(i), ioapics[i].nr_registers);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -1501,7 +1513,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].apicid);
+	printk(KERN_DEBUG "IO APIC #%d......\n", mpc_ioapic_id(apic));
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
@@ -1919,14 +1931,14 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		reg_00.raw = io_apic_read(apic_id, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
-		old_id = mp_ioapics[apic_id].apicid;
+		old_id = mpc_ioapic_id(apic_id);
 
-		if (mp_ioapics[apic_id].apicid >= get_physical_broadcast()) {
+		if (mpc_ioapic_id(apic_id) >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic_id, mp_ioapics[apic_id].apicid);
+				apic_id, mpc_ioapic_id(apic_id));
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			mp_ioapics[apic_id].apicid = reg_00.bits.ID;
+			ioapics[apic_id].mp_config.apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -1935,9 +1947,9 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (apic->check_apicid_used(&phys_id_present_map,
-					mp_ioapics[apic_id].apicid)) {
+					    mpc_ioapic_id(apic_id))) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic_id, mp_ioapics[apic_id].apicid);
+				apic_id, mpc_ioapic_id(apic_id));
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -1946,13 +1958,14 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			mp_ioapics[apic_id].apicid = i;
+			ioapics[apic_id].mp_config.apicid = i;
 		} else {
 			physid_mask_t tmp;
-			apic->apicid_to_cpu_present(mp_ioapics[apic_id].apicid, &tmp);
+			apic->apicid_to_cpu_present(mpc_ioapic_id(apic_id),
+						    &tmp);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mp_ioapics[apic_id].apicid);
+					mpc_ioapic_id(apic_id));
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -1960,24 +1973,24 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mp_ioapics[apic_id].apicid)
+		if (old_id != mpc_ioapic_id(apic_id))
 			for (i = 0; i < mp_irq_entries; i++)
 				if (mp_irqs[i].dstapic == old_id)
 					mp_irqs[i].dstapic
-						= mp_ioapics[apic_id].apicid;
+						= mpc_ioapic_id(apic_id);
 
 		/*
 		 * Update the ID register according to the right value
 		 * from the MPC table if they are different.
 		 */
-		if (mp_ioapics[apic_id].apicid == reg_00.bits.ID)
+		if (mpc_ioapic_id(apic_id) == reg_00.bits.ID)
 			continue;
 
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mp_ioapics[apic_id].apicid);
+			mpc_ioapic_id(apic_id));
 
-		reg_00.bits.ID = mp_ioapics[apic_id].apicid;
+		reg_00.bits.ID = mpc_ioapic_id(apic_id);
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(apic_id, 0, reg_00.raw);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -1988,7 +2001,7 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic_id, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mp_ioapics[apic_id].apicid)
+		if (reg_00.bits.ID != mpc_ioapic_id(apic_id))
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
@@ -2374,7 +2387,7 @@ static void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		if (mp_ioapics[entry->apic].apicver >= 0x20) {
+		if (mpc_ioapic_ver(entry->apic) >= 0x20) {
 			/*
 			 * Intr-remapping uses pin number as the virtual vector
 			 * in the RTE. Actual vector is programmed in
@@ -2896,8 +2909,8 @@ static void resume_ioapic_id(int ioapic_id)
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic_id, 0);
-	if (reg_00.bits.ID != mp_ioapics[ioapic_id].apicid) {
-		reg_00.bits.ID = mp_ioapics[ioapic_id].apicid;
+	if (reg_00.bits.ID != mpc_ioapic_id(ioapic_id)) {
+		reg_00.bits.ID = mpc_ioapic_id(ioapic_id);
 		io_apic_write(ioapic_id, 0, reg_00.raw);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -3524,7 +3537,7 @@ int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 	/* Avoid redundant programming */
 	if (test_bit(pin, mp_ioapic_routing[id].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
-			 mp_ioapics[id].apicid, pin);
+			 mpc_ioapic_id(id), pin);
 		return 0;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
@@ -3694,8 +3707,7 @@ static u8 __init io_apic_unique_id(u8 id)
 
 	bitmap_zero(used, 256);
 	for (i = 0; i < nr_ioapics; i++) {
-		struct mpc_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->apicid, used);
+		__set_bit(mpc_ioapic_id(i), used);
 	}
 	if (!test_bit(id, used))
 		return id;
@@ -3826,7 +3838,7 @@ void __init ioapic_and_gsi_init(void)
 	ioapic_res = ioapic_setup_resources(nr_ioapics);
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
-			ioapic_phys = mp_ioapics[i].apicaddr;
+			ioapic_phys = mpc_ioapic_addr(i);
 #ifdef CONFIG_X86_32
 			if (!ioapic_phys) {
 				printk(KERN_ERR
@@ -3930,13 +3942,13 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	idx = nr_ioapics;
 
-	mp_ioapics[idx].type = MP_IOAPIC;
-	mp_ioapics[idx].flags = MPC_APIC_USABLE;
-	mp_ioapics[idx].apicaddr = address;
+	ioapics[idx].mp_config.type = MP_IOAPIC;
+	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
+	ioapics[idx].mp_config.apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].apicid = io_apic_unique_id(id);
-	mp_ioapics[idx].apicver = io_apic_get_version(idx);
+	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
+	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 
 	/*
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
@@ -3955,8 +3967,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 		gsi_top = mp_gsi_routing[idx].gsi_end + 1;
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
-	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
+	       "GSI %d-%d\n", idx, mpc_ioapic_id(idx),
+	       mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
 	       mp_gsi_routing[idx].gsi_base, mp_gsi_routing[idx].gsi_end);
 
 	nr_ioapics++;
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index e90f084..f06494e 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -407,7 +407,7 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 	}
 
 	for (i = 0; i < nr_ioapics; i++) {
-		if (r.start == mp_ioapics[i].apicaddr) {
+		if (r.start == mpc_ioapic_addr(i)) {
 			struct irq_domain *id;
 
 			id = kzalloc(sizeof(*id), GFP_KERNEL);
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6f9bfff..9103b89 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -285,7 +285,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 	intsrc.type = MP_INTSRC;
 	intsrc.irqflag = 0;	/* conforming */
 	intsrc.srcbus = 0;
-	intsrc.dstapic = mp_ioapics[0].apicid;
+	intsrc.dstapic = mpc_ioapic_id(0);
 
 	intsrc.irqtype = mp_INT;
 
