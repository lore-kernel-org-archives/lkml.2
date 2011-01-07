Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1AGNU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:20:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44122 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1AGNU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:20:27 -0500
Date: Fri, 7 Jan 2011 14:20:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic-cleanups for v2.6.38
Message-ID: <20110107132019.GA29643@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.2
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.2 required=5.9 tests=BAYES_00,FRT_LEVITRA autolearn=no SpamAssassin version=3.2.5
	1.8 FRT_LEVITRA            BODY: ReplaceTags: Levitra
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Feng Tang (2):
      x86: Unify 3 similar ways of saving mp_irqs info
      x86: Further simplify mp_irq info handling

Tejun Heo (1):
      x86: apic: Cleanup and simplify setup_local_APIC()

Yinghai Lu (6):
      x86, apic: Unify identical register_lapic_address() functions
      x86, apic: Remove early_init_lapic_mapping()
      x86, apic: Use register_lapic_address() in init_apic_mapping()
      x86, sfi: Use register_lapic_address()
      x86, x2apic: Don't map lapic addr for preenabled x2apic systems
      x86, ioapic: Avoid writing io_apic id if already correct


 arch/x86/include/asm/apic.h    |    2 +-
 arch/x86/include/asm/io_apic.h |    3 +
 arch/x86/kernel/acpi/boot.c    |   48 ++---------------
 arch/x86/kernel/apic/apic.c    |   64 +++++++++-------------
 arch/x86/kernel/apic/io_apic.c |   28 +++++++++-
 arch/x86/kernel/mpparse.c      |  114 ++++------------------------------------
 arch/x86/mm/amdtopology_64.c   |    1 -
 arch/x86/platform/mrst/mrst.c  |   30 +----------
 arch/x86/platform/sfi/sfi.c    |   13 +----
 9 files changed, 75 insertions(+), 228 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index cf12007..5e3969c 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -234,6 +234,7 @@ extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
 extern void end_local_APIC_setup(void);
 extern void init_apic_mappings(void);
+void register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
@@ -244,7 +245,6 @@ extern int apic_force_enable(void);
  * On 32bit this is mach-xxx local
  */
 #ifdef CONFIG_X86_64
-extern void early_init_lapic_mapping(void);
 extern int apic_is_clustered_box(void);
 #else
 static inline int apic_is_clustered_box(void)
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0c5ca4e..f327d38 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -169,6 +169,7 @@ extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 
 extern int get_nr_irqs_gsi(void);
+
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
@@ -183,6 +184,8 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
+extern void mp_save_irq(struct mpc_intsrc *m);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 17c8090..ec881c6 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -852,18 +852,6 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
  * returns 0 on success, < 0 on error
  */
 
-static void __init acpi_register_lapic_address(unsigned long address)
-{
-	mp_lapic_addr = address;
-
-	set_fixmap_nocache(FIX_APIC_BASE, address);
-	if (boot_cpu_physical_apicid == -1U) {
-		boot_cpu_physical_apicid  = read_apic_id();
-		apic_version[boot_cpu_physical_apicid] =
-			 GET_APIC_VERSION(apic_read(APIC_LVR));
-	}
-}
-
 static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
 {
 	int count;
@@ -885,7 +873,7 @@ static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
 		return count;
 	}
 
-	acpi_register_lapic_address(acpi_lapic_addr);
+	register_lapic_address(acpi_lapic_addr);
 
 	return count;
 }
@@ -912,7 +900,7 @@ static int __init acpi_parse_madt_lapic_entries(void)
 		return count;
 	}
 
-	acpi_register_lapic_address(acpi_lapic_addr);
+	register_lapic_address(acpi_lapic_addr);
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC,
 				      acpi_parse_sapic, MAX_LOCAL_APIC);
@@ -954,32 +942,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
 extern int es7000_plat;
 #endif
 
-static void assign_to_mp_irq(struct mpc_intsrc *m,
-				    struct mpc_intsrc *mp_irq)
-{
-	memcpy(mp_irq, m, sizeof(struct mpc_intsrc));
-}
-
-static int mp_irq_cmp(struct mpc_intsrc *mp_irq,
-				struct mpc_intsrc *m)
-{
-	return memcmp(mp_irq, m, sizeof(struct mpc_intsrc));
-}
-
-static void save_mp_irq(struct mpc_intsrc *m)
-{
-	int i;
-
-	for (i = 0; i < mp_irq_entries; i++) {
-		if (!mp_irq_cmp(&mp_irqs[i], m))
-			return;
-	}
-
-	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
-	if (++mp_irq_entries == MAX_IRQ_SOURCES)
-		panic("Max # of irq sources exceeded!!\n");
-}
-
 void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 {
 	int ioapic;
@@ -1010,7 +972,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
 	mp_irq.dstirq = pin;	/* INTIN# */
 
-	save_mp_irq(&mp_irq);
+	mp_save_irq(&mp_irq);
 
 	isa_irq_to_gsi[bus_irq] = gsi;
 }
@@ -1085,7 +1047,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 		mp_irq.srcbusirq = i; /* Identity mapped */
 		mp_irq.dstirq = pin;
 
-		save_mp_irq(&mp_irq);
+		mp_save_irq(&mp_irq);
 	}
 }
 
@@ -1122,7 +1084,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
 	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
-	save_mp_irq(&mp_irq);
+	mp_save_irq(&mp_irq);
 #endif
 	return 0;
 }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 879999a..ce65d44 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1191,12 +1191,15 @@ static void __cpuinit lapic_setup_esr(void)
 			oldvalue, value);
 }
 
-
 /**
  * setup_local_APIC - setup the local APIC
+ *
+ * Used to setup local APIC while initializing BSP or bringin up APs.
+ * Always called with preemption disabled.
  */
 void __cpuinit setup_local_APIC(void)
 {
+	int cpu = smp_processor_id();
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
@@ -1221,8 +1224,6 @@ void __cpuinit setup_local_APIC(void)
 #endif
 	perf_events_lapic_init();
 
-	preempt_disable();
-
 	/*
 	 * Double-check whether this APIC is really registered.
 	 * This is meaningless in clustered apic mode, so we skip it.
@@ -1338,21 +1339,19 @@ void __cpuinit setup_local_APIC(void)
 	 * TODO: set up through-local-APIC from through-I/O-APIC? --macro
 	 */
 	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
-	if (!smp_processor_id() && (pic_mode || !value)) {
+	if (!cpu && (pic_mode || !value)) {
 		value = APIC_DM_EXTINT;
-		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n",
-				smp_processor_id());
+		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n", cpu);
 	} else {
 		value = APIC_DM_EXTINT | APIC_LVT_MASKED;
-		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n",
-				smp_processor_id());
+		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n", cpu);
 	}
 	apic_write(APIC_LVT0, value);
 
 	/*
 	 * only the BP should see the LINT1 NMI signal, obviously.
 	 */
-	if (!smp_processor_id())
+	if (!cpu)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
@@ -1360,11 +1359,9 @@ void __cpuinit setup_local_APIC(void)
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
 
-	preempt_enable();
-
 #ifdef CONFIG_X86_MCE_INTEL
 	/* Recheck CMCI information after local APIC is up on CPU #0 */
-	if (smp_processor_id() == 0)
+	if (!cpu)
 		cmci_recheck();
 #endif
 }
@@ -1633,28 +1630,6 @@ no_apic:
 }
 #endif
 
-#ifdef CONFIG_X86_64
-void __init early_init_lapic_mapping(void)
-{
-	/*
-	 * If no local APIC can be found then go out
-	 * : it means there is no mpatable and MADT
-	 */
-	if (!smp_found_config)
-		return;
-
-	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-		    APIC_BASE, mp_lapic_addr);
-
-	/*
-	 * Fetch the APIC ID of the BSP in case we have a
-	 * default configuration (or the MP table is broken).
-	 */
-	boot_cpu_physical_apicid = read_apic_id();
-}
-#endif
-
 /**
  * init_apic_mappings - initialize APIC mappings
  */
@@ -1680,10 +1655,7 @@ void __init init_apic_mappings(void)
 		 * acpi_register_lapic_address()
 		 */
 		if (!acpi_lapic && !smp_found_config)
-			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-
-		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-					APIC_BASE, apic_phys);
+			register_lapic_address(apic_phys);
 	}
 
 	/*
@@ -1705,6 +1677,22 @@ void __init init_apic_mappings(void)
 	}
 }
 
+void __init register_lapic_address(unsigned long address)
+{
+	mp_lapic_addr = address;
+
+	if (!x2apic_mode) {
+		set_fixmap_nocache(FIX_APIC_BASE, address);
+		apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+			    APIC_BASE, mp_lapic_addr);
+	}
+	if (boot_cpu_physical_apicid == -1U) {
+		boot_cpu_physical_apicid  = read_apic_id();
+		apic_version[boot_cpu_physical_apicid] =
+			 GET_APIC_VERSION(apic_read(APIC_LVR));
+	}
+}
+
 /*
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f6cd5b4..52735a7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -125,6 +125,26 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
+/* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
+void mp_save_irq(struct mpc_intsrc *m)
+{
+	int i;
+
+	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
+		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
+		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbus,
+		m->srcbusirq, m->dstapic, m->dstirq);
+
+	for (i = 0; i < mp_irq_entries; i++) {
+		if (!memcmp(&mp_irqs[i], m, sizeof(*m)))
+			return;
+	}
+
+	memcpy(&mp_irqs[mp_irq_entries], m, sizeof(*m));
+	if (++mp_irq_entries == MAX_IRQ_SOURCES)
+		panic("Max # of irq sources exceeded!!\n");
+}
+
 struct irq_pin_list {
 	int apic, pin;
 	struct irq_pin_list *next;
@@ -135,6 +155,7 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
 }
 
+
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
@@ -2006,9 +2027,12 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 						= mp_ioapics[apic_id].apicid;
 
 		/*
-		 * Read the right value from the MPC table and
-		 * write it into the ID register.
+		 * Update the ID register according to the right value
+		 * from the MPC table if they are different.
 		 */
+		if (mp_ioapics[apic_id].apicid == reg_00.bits.ID)
+			continue;
+
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
 			mp_ioapics[apic_id].apicid);
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9af64d9..01b0f6d 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -118,21 +118,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
-	if (!(m->flags & MPC_APIC_USABLE))
-		return;
-
-	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
-	       m->apicid, m->apicver, m->apicaddr);
-
-	mp_register_ioapic(m->apicid, m->apicaddr, gsi_top);
-}
-
-static void print_MP_intsrc_info(struct mpc_intsrc *m)
-{
-	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
-		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
-		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbus,
-		m->srcbusirq, m->dstapic, m->dstirq);
+	if (m->flags & MPC_APIC_USABLE)
+		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top);
 }
 
 static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
@@ -144,73 +131,11 @@ static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
 }
 
-static void __init assign_to_mp_irq(struct mpc_intsrc *m,
-				    struct mpc_intsrc *mp_irq)
-{
-	mp_irq->dstapic = m->dstapic;
-	mp_irq->type = m->type;
-	mp_irq->irqtype = m->irqtype;
-	mp_irq->irqflag = m->irqflag;
-	mp_irq->srcbus = m->srcbus;
-	mp_irq->srcbusirq = m->srcbusirq;
-	mp_irq->dstirq = m->dstirq;
-}
-
-static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
-					struct mpc_intsrc *m)
-{
-	m->dstapic = mp_irq->dstapic;
-	m->type = mp_irq->type;
-	m->irqtype = mp_irq->irqtype;
-	m->irqflag = mp_irq->irqflag;
-	m->srcbus = mp_irq->srcbus;
-	m->srcbusirq = mp_irq->srcbusirq;
-	m->dstirq = mp_irq->dstirq;
-}
-
-static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
-					struct mpc_intsrc *m)
-{
-	if (mp_irq->dstapic != m->dstapic)
-		return 1;
-	if (mp_irq->type != m->type)
-		return 2;
-	if (mp_irq->irqtype != m->irqtype)
-		return 3;
-	if (mp_irq->irqflag != m->irqflag)
-		return 4;
-	if (mp_irq->srcbus != m->srcbus)
-		return 5;
-	if (mp_irq->srcbusirq != m->srcbusirq)
-		return 6;
-	if (mp_irq->dstirq != m->dstirq)
-		return 7;
-
-	return 0;
-}
-
-static void __init MP_intsrc_info(struct mpc_intsrc *m)
-{
-	int i;
-
-	print_MP_intsrc_info(m);
-
-	for (i = 0; i < mp_irq_entries; i++) {
-		if (!mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m))
-			return;
-	}
-
-	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
-	if (++mp_irq_entries == MAX_IRQ_SOURCES)
-		panic("Max # of irq sources exceeded!!\n");
-}
 #else /* CONFIG_X86_IO_APIC */
 static inline void __init MP_bus_info(struct mpc_bus *m) {}
 static inline void __init MP_ioapic_info(struct mpc_ioapic *m) {}
-static inline void __init MP_intsrc_info(struct mpc_intsrc *m) {}
 #endif /* CONFIG_X86_IO_APIC */
 
-
 static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 {
 	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
@@ -222,7 +147,6 @@ static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 /*
  * Read/parse the MPC
  */
-
 static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 {
 
@@ -275,18 +199,6 @@ static void __init smp_dump_mptable(struct mpc_table *mpc, unsigned char *mpt)
 
 void __init default_smp_read_mpc_oem(struct mpc_table *mpc) { }
 
-static void __init smp_register_lapic_address(unsigned long address)
-{
-	mp_lapic_addr = address;
-
-	set_fixmap_nocache(FIX_APIC_BASE, address);
-	if (boot_cpu_physical_apicid == -1U) {
-		boot_cpu_physical_apicid  = read_apic_id();
-		apic_version[boot_cpu_physical_apicid] =
-			 GET_APIC_VERSION(apic_read(APIC_LVR));
-	}
-}
-
 static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
@@ -301,17 +213,13 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 #ifdef CONFIG_X86_32
 	generic_mps_oem_check(mpc, oem, str);
 #endif
-	/* save the local APIC address, it might be non-default */
+	/* Initialize the lapic mapping */
 	if (!acpi_lapic)
-		mp_lapic_addr = mpc->lapic;
+		register_lapic_address(mpc->lapic);
 
 	if (early)
 		return 1;
 
-	/* Initialize the lapic mapping */
-	if (!acpi_lapic)
-		smp_register_lapic_address(mpc->lapic);
-
 	if (mpc->oemptr)
 		x86_init.mpparse.smp_read_mpc_oem(mpc);
 
@@ -337,7 +245,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
 			break;
 		case MP_INTSRC:
-			MP_intsrc_info((struct mpc_intsrc *)mpt);
+			mp_save_irq((struct mpc_intsrc *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
 			break;
 		case MP_LINTSRC:
@@ -429,13 +337,13 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 
 		intsrc.srcbusirq = i;
 		intsrc.dstirq = i ? i : 2;	/* IRQ0 to INTIN2 */
-		MP_intsrc_info(&intsrc);
+		mp_save_irq(&intsrc);
 	}
 
 	intsrc.irqtype = mp_ExtINT;
 	intsrc.srcbusirq = 0;
 	intsrc.dstirq = 0;	/* 8259A to INTIN0 */
-	MP_intsrc_info(&intsrc);
+	mp_save_irq(&intsrc);
 }
 
 
@@ -784,11 +692,11 @@ static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 	int i;
 
 	apic_printk(APIC_VERBOSE, "OLD ");
-	print_MP_intsrc_info(m);
+	print_mp_irq_info(m);
 
 	i = get_MP_intsrc_index(m);
 	if (i > 0) {
-		assign_to_mpc_intsrc(&mp_irqs[i], m);
+		memcpy(m, &mp_irqs[i], sizeof(*m));
 		apic_printk(APIC_VERBOSE, "NEW ");
 		print_mp_irq_info(&mp_irqs[i]);
 		return;
@@ -875,14 +783,14 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		if (nr_m_spare > 0) {
 			apic_printk(APIC_VERBOSE, "*NEW* found\n");
 			nr_m_spare--;
-			assign_to_mpc_intsrc(&mp_irqs[i], m_spare[nr_m_spare]);
+			memcpy(m_spare[nr_m_spare], &mp_irqs[i], sizeof(mp_irqs[i]));
 			m_spare[nr_m_spare] = NULL;
 		} else {
 			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 			count += sizeof(struct mpc_intsrc);
 			if (check_slot(mpc_new_phys, mpc_new_length, count) < 0)
 				goto out;
-			assign_to_mpc_intsrc(&mp_irqs[i], m);
+			memcpy(m, &mp_irqs[i], sizeof(*m));
 			mpc->length = count;
 			mpt += sizeof(struct mpc_intsrc);
 		}
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 51fae9c..08a0069 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -66,7 +66,6 @@ static __init void early_get_boot_cpu_id(void)
 	if (smp_found_config)
 		early_get_smp_config();
 #endif
-	early_init_lapic_mapping();
 }
 
 int __init amd_get_nodes(struct bootnode *physnodes)
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index fee0b49..ea6529e 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -71,32 +71,6 @@ struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
 EXPORT_SYMBOL_GPL(sfi_mrtc_array);
 int sfi_mrtc_num;
 
-static inline void assign_to_mp_irq(struct mpc_intsrc *m,
-				    struct mpc_intsrc *mp_irq)
-{
-	memcpy(mp_irq, m, sizeof(struct mpc_intsrc));
-}
-
-static inline int mp_irq_cmp(struct mpc_intsrc *mp_irq,
-				struct mpc_intsrc *m)
-{
-	return memcmp(mp_irq, m, sizeof(struct mpc_intsrc));
-}
-
-static void save_mp_irq(struct mpc_intsrc *m)
-{
-	int i;
-
-	for (i = 0; i < mp_irq_entries; i++) {
-		if (!mp_irq_cmp(&mp_irqs[i], m))
-			return;
-	}
-
-	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
-	if (++mp_irq_entries == MAX_IRQ_SOURCES)
-		panic("Max # of irq sources exceeded!!\n");
-}
-
 /* parse all the mtimer info to a static mtimer array */
 static int __init sfi_parse_mtmr(struct sfi_table_header *table)
 {
@@ -130,7 +104,7 @@ static int __init sfi_parse_mtmr(struct sfi_table_header *table)
 			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 			mp_irq.dstapic = MP_APIC_ALL;
 			mp_irq.dstirq = pentry->irq;
-			save_mp_irq(&mp_irq);
+			mp_save_irq(&mp_irq);
 	}
 
 	return 0;
@@ -200,7 +174,7 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 		mp_irq.dstapic = MP_APIC_ALL;
 		mp_irq.dstirq = pentry->irq;
-		save_mp_irq(&mp_irq);
+		mp_save_irq(&mp_irq);
 	}
 	return 0;
 }
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index ca54875..7785b72 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -34,17 +34,6 @@
 #ifdef CONFIG_X86_LOCAL_APIC
 static unsigned long sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 
-static void __init mp_sfi_register_lapic_address(unsigned long address)
-{
-	mp_lapic_addr = address;
-
-	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
-	if (boot_cpu_physical_apicid == -1U)
-		boot_cpu_physical_apicid = read_apic_id();
-
-	pr_info("Boot CPU = %d\n", boot_cpu_physical_apicid);
-}
-
 /* All CPUs enumerated by SFI must be present and enabled */
 static void __cpuinit mp_sfi_register_lapic(u8 id)
 {
@@ -110,7 +99,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 int __init sfi_platform_init(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
-	mp_sfi_register_lapic_address(sfi_lapic_addr);
+	register_lapic_address(sfi_lapic_addr);
 	sfi_table_parse(SFI_SIG_CPUS, NULL, NULL, sfi_parse_cpus);
 #endif
 #ifdef CONFIG_X86_IO_APIC
