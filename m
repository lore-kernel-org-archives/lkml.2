Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0EQXFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:05:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54465 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab0EQXFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:05:31 -0400
Date: Tue, 18 May 2010 01:04:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: [GIT PULL] x86/irq changes for v2.6.35
Message-ID: <20100517230417.GA4735@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4796]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-irq-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-irq-for-linus


out-of-topic modifications in x86-irq-for-linus:
------------------------------------------------
arch/ia64/kernel/acpi.c            # 2c2df84: x86, acpi/irq: Introduce apci_isa
drivers/acpi/pci_irq.c             # 414d344: x86, acpi/irq: pci device dev->ir
include/linux/acpi.h               # 9a0a91b: x86, acpi/irq: Teach acpi_get_ove
                                   # 2c2df84: x86, acpi/irq: Introduce apci_isa

 Thanks,

	Ingo

------------------>
Eric W. Biederman (16):
      x86, acpi/irq: Introduce apci_isa_irq_to_gsi
      x86, acpi/irq: Teach acpi_get_override_irq to take a gsi not an isa_irq
      x86, acpi/irq: pci device dev->irq is an isa irq not a gsi
      x86, acpi/irq: Fix acpi_sci_ioapic_setup so it has both bus_irq and gsi
      x86, acpi/irq: Generalize mp_config_acpi_legacy_irqs
      x86, ioapic: Only export mp_find_ioapic and mp_find_ioapic_pin in io_apic.h
      x86, ioapic: Fix io_apic_redir_entries to return the number of entries.
      x86, ioapic: Fix the types of gsi values
      x86, ioapic: Teach mp_register_ioapic to compute a global gsi_end
      x86, ioapic: In mpparse use mp_register_ioapic
      x86, ioapic: Move nr_ioapic_registers calculation to mp_register_ioapic.
      x86, ioapic: Optimize pin_2_irq
      x86, ioapic: Simplify probe_nr_irqs_gsi.
      x86, acpi/irq: Handle isa irqs that are not identity mapped to gsi's.
      x86, irq: Kill io_apic_renumber_irq
      x86, acpi/irq: Define gsi_end when X86_IO_APIC is undefined


 arch/ia64/kernel/acpi.c          |    8 ++
 arch/x86/include/asm/io_apic.h   |   13 ++--
 arch/x86/include/asm/mpspec.h    |   10 ---
 arch/x86/kernel/acpi/boot.c      |  133 ++++++++++++++++++++++++--------------
 arch/x86/kernel/apic/es7000_32.c |   19 ------
 arch/x86/kernel/apic/io_apic.c   |   99 +++++++++++++---------------
 arch/x86/kernel/mpparse.c        |   25 +-------
 arch/x86/kernel/sfi.c            |    4 +-
 drivers/acpi/pci_irq.c           |    8 ++-
 include/linux/acpi.h             |    5 +-
 10 files changed, 155 insertions(+), 169 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 4d1a7e9..c6c90f3 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -785,6 +785,14 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 	return 0;
 }
 
+int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
+{
+	if (isa_irq >= 16)
+		return -1;
+	*gsi = isa_irq;
+	return 0;
+}
+
 /*
  *  ACPI based hotplug CPU support
  */
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 35832a0..63cb409 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -159,7 +159,6 @@ struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
-extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
 
@@ -180,12 +179,13 @@ extern void ioapic_write_entry(int apic, int pin,
 extern void setup_ioapic_ids_from_mpc(void);
 
 struct mp_ioapic_gsi{
-	int gsi_base;
-	int gsi_end;
+	u32 gsi_base;
+	u32 gsi_end;
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
-int mp_find_ioapic(int gsi);
-int mp_find_ioapic_pin(int ioapic, int gsi);
+extern u32 gsi_end;
+int mp_find_ioapic(u32 gsi);
+int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
@@ -197,7 +197,8 @@ static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
 static inline void probe_nr_irqs_gsi(void)	{ }
-static inline int mp_find_ioapic(int gsi) { return 0; }
+#define gsi_end (NR_IRQS_LEGACY - 1)
+static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index d8bf23a..c82868e 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -105,16 +105,6 @@ extern void mp_config_acpi_legacy_irqs(void);
 struct device;
 extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
-extern int acpi_probe_gsi(void);
-#ifdef CONFIG_X86_IO_APIC
-extern int mp_find_ioapic(int gsi);
-extern int mp_find_ioapic_pin(int ioapic, int gsi);
-#endif
-#else /* !CONFIG_ACPI: */
-static inline int acpi_probe_gsi(void)
-{
-	return 0;
-}
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index cd40aba..9a5ed58 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -94,6 +94,53 @@ enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PIC;
 
 
 /*
+ * ISA irqs by default are the first 16 gsis but can be
+ * any gsi as specified by an interrupt source override.
+ */
+static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
+	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
+};
+
+static unsigned int gsi_to_irq(unsigned int gsi)
+{
+	unsigned int irq = gsi + NR_IRQS_LEGACY;
+	unsigned int i;
+
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+		if (isa_irq_to_gsi[i] == gsi) {
+			return i;
+		}
+	}
+
+	/* Provide an identity mapping of gsi == irq
+	 * except on truly weird platforms that have
+	 * non isa irqs in the first 16 gsis.
+	 */
+	if (gsi >= NR_IRQS_LEGACY)
+		irq = gsi;
+	else
+		irq = gsi_end + 1 + gsi;
+
+	return irq;
+}
+
+static u32 irq_to_gsi(int irq)
+{
+	unsigned int gsi;
+
+	if (irq < NR_IRQS_LEGACY)
+		gsi = isa_irq_to_gsi[irq];
+	else if (irq <= gsi_end)
+		gsi = irq;
+	else if (irq <= (gsi_end + NR_IRQS_LEGACY))
+		gsi = irq - gsi_end;
+	else
+		gsi = 0xffffffff;
+
+	return gsi;
+}
+
+/*
  * Temporarily use the virtual area starting from FIX_IO_APIC_BASE_END,
  * to map the target physical address. The problem is that set_fixmap()
  * provides a single page, and it is possible that the page is not
@@ -313,7 +360,7 @@ acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 /*
  * Parse Interrupt Source Override for the ACPI SCI
  */
-static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
+static void __init acpi_sci_ioapic_setup(u8 bus_irq, u16 polarity, u16 trigger, u32 gsi)
 {
 	if (trigger == 0)	/* compatible SCI trigger is level */
 		trigger = 3;
@@ -333,7 +380,7 @@ static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
 	 * If GSI is < 16, this will update its flags,
 	 * else it will create a new mp_irqs[] entry.
 	 */
-	mp_override_legacy_irq(gsi, polarity, trigger, gsi);
+	mp_override_legacy_irq(bus_irq, polarity, trigger, gsi);
 
 	/*
 	 * stash over-ride to indicate we've been here
@@ -357,9 +404,10 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
 	acpi_table_print_madt_entry(header);
 
 	if (intsrc->source_irq == acpi_gbl_FADT.sci_interrupt) {
-		acpi_sci_ioapic_setup(intsrc->global_irq,
+		acpi_sci_ioapic_setup(intsrc->source_irq,
 				      intsrc->inti_flags & ACPI_MADT_POLARITY_MASK,
-				      (intsrc->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2);
+				      (intsrc->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2,
+				      intsrc->global_irq);
 		return 0;
 	}
 
@@ -448,7 +496,7 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 {
-	*irq = gsi;
+	*irq = gsi_to_irq(gsi);
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
@@ -458,6 +506,14 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 	return 0;
 }
 
+int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
+{
+	if (isa_irq >= 16)
+		return -1;
+	*gsi = irq_to_gsi(isa_irq);
+	return 0;
+}
+
 /*
  * success: return IRQ number (>=0)
  * failure: return < 0
@@ -482,7 +538,7 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 	}
 #endif
-	irq = plat_gsi;
+	irq = gsi_to_irq(plat_gsi);
 
 	return irq;
 }
@@ -867,29 +923,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
 extern int es7000_plat;
 #endif
 
-int __init acpi_probe_gsi(void)
-{
-	int idx;
-	int gsi;
-	int max_gsi = 0;
-
-	if (acpi_disabled)
-		return 0;
-
-	if (!acpi_ioapic)
-		return 0;
-
-	max_gsi = 0;
-	for (idx = 0; idx < nr_ioapics; idx++) {
-		gsi = mp_gsi_routing[idx].gsi_end;
-
-		if (gsi > max_gsi)
-			max_gsi = gsi;
-	}
-
-	return max_gsi + 1;
-}
-
 static void assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mpc_intsrc *mp_irq)
 {
@@ -947,13 +980,13 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irq.dstirq = pin;	/* INTIN# */
 
 	save_mp_irq(&mp_irq);
+
+	isa_irq_to_gsi[bus_irq] = gsi;
 }
 
 void __init mp_config_acpi_legacy_irqs(void)
 {
 	int i;
-	int ioapic;
-	unsigned int dstapic;
 	struct mpc_intsrc mp_irq;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
@@ -974,19 +1007,27 @@ void __init mp_config_acpi_legacy_irqs(void)
 #endif
 
 	/*
-	 * Locate the IOAPIC that manages the ISA IRQs (0-15).
-	 */
-	ioapic = mp_find_ioapic(0);
-	if (ioapic < 0)
-		return;
-	dstapic = mp_ioapics[ioapic].apicid;
-
-	/*
 	 * Use the default configuration for the IRQs 0-15.  Unless
 	 * overridden by (MADT) interrupt source override entries.
 	 */
 	for (i = 0; i < 16; i++) {
+		int ioapic, pin;
+		unsigned int dstapic;
 		int idx;
+		u32 gsi;
+
+		/* Locate the gsi that irq i maps to. */
+		if (acpi_isa_irq_to_gsi(i, &gsi))
+			continue;
+
+		/*
+		 * Locate the IOAPIC that manages the ISA IRQ.
+		 */
+		ioapic = mp_find_ioapic(gsi);
+		if (ioapic < 0)
+			continue;
+		pin = mp_find_ioapic_pin(ioapic, gsi);
+		dstapic = mp_ioapics[ioapic].apicid;
 
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mpc_intsrc *irq = mp_irqs + idx;
@@ -996,7 +1037,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 				break;
 
 			/* Do we already have a mapping for this IOAPIC pin */
-			if (irq->dstapic == dstapic && irq->dstirq == i)
+			if (irq->dstapic == dstapic && irq->dstirq == pin)
 				break;
 		}
 
@@ -1011,7 +1052,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 		mp_irq.dstapic = dstapic;
 		mp_irq.irqtype = mp_INT;
 		mp_irq.srcbusirq = i; /* Identity mapped */
-		mp_irq.dstirq = i;
+		mp_irq.dstirq = pin;
 
 		save_mp_irq(&mp_irq);
 	}
@@ -1076,11 +1117,6 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 
 	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
 
-#ifdef CONFIG_X86_32
-	if (ioapic_renumber_irq)
-		gsi = ioapic_renumber_irq(ioapic, gsi);
-#endif
-
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 		       "%d-%d\n", mp_ioapics[ioapic].apicid,
@@ -1094,7 +1130,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi, &irq_attr);
+	io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
 
 	return gsi;
 }
@@ -1154,7 +1190,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	 * pretend we got one so we can set the SCI flags.
 	 */
 	if (!acpi_sci_override_gsi)
-		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0);
+		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0,
+				      acpi_gbl_FADT.sci_interrupt);
 
 	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 03ba1b8..425e53a 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -131,24 +131,6 @@ int					es7000_plat;
 
 static unsigned int			base;
 
-static int
-es7000_rename_gsi(int ioapic, int gsi)
-{
-	if (es7000_plat == ES7000_ZORRO)
-		return gsi;
-
-	if (!base) {
-		int i;
-		for (i = 0; i < nr_ioapics; i++)
-			base += nr_ioapic_registers[i];
-	}
-
-	if (!ioapic && (gsi < 16))
-		gsi += base;
-
-	return gsi;
-}
-
 static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
@@ -190,7 +172,6 @@ static void setup_unisys(void)
 		es7000_plat = ES7000_ZORRO;
 	else
 		es7000_plat = ES7000_CLASSIC;
-	ioapic_renumber_irq = es7000_rename_gsi;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 127b871..d174d88 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -89,6 +89,9 @@ int nr_ioapics;
 /* IO APIC gsi routing info */
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
 
+/* The last gsi number used */
+u32 gsi_end;
+
 /* MP IRQ source entries */
 struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
@@ -1013,10 +1016,9 @@ static inline int irq_trigger(int idx)
 	return MPBIOS_trigger(idx);
 }
 
-int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
-	int irq, i;
+	int irq;
 	int bus = mp_irqs[idx].srcbus;
 
 	/*
@@ -1028,18 +1030,12 @@ static int pin_2_irq(int idx, int apic, int pin)
 	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
 	} else {
-		/*
-		 * PCI IRQs are mapped in order
-		 */
-		i = irq = 0;
-		while (i < apic)
-			irq += nr_ioapic_registers[i++];
-		irq += pin;
-		/*
-                 * For MPS mode, so far only needed by ES7000 platform
-                 */
-		if (ioapic_renumber_irq)
-			irq = ioapic_renumber_irq(apic, irq);
+		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
+
+		if (gsi >= NR_IRQS_LEGACY)
+			irq = gsi;
+		else
+			irq = gsi_end + 1 + gsi;
 	}
 
 #ifdef CONFIG_X86_32
@@ -1950,20 +1946,8 @@ static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
 void __init enable_IO_APIC(void)
 {
-	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
 	int apic;
-	unsigned long flags;
-
-	/*
-	 * The number of IO-APIC IRQ registers (== #pins):
-	 */
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		reg_01.raw = io_apic_read(apic, 1);
-		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
-	}
 
 	if (!legacy_pic->nr_legacy_irqs)
 		return;
@@ -3855,27 +3839,20 @@ int __init io_apic_get_redir_entries (int ioapic)
 	reg_01.raw = io_apic_read(ioapic, 1);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
-	return reg_01.bits.entries;
+	/* The register returns the maximum index redir index
+	 * supported, which is one less than the total number of redir
+	 * entries.
+	 */
+	return reg_01.bits.entries + 1;
 }
 
 void __init probe_nr_irqs_gsi(void)
 {
-	int nr = 0;
+	int nr;
 
-	nr = acpi_probe_gsi();
-	if (nr > nr_irqs_gsi) {
+	nr = gsi_end + 1 + NR_IRQS_LEGACY;
+	if (nr > nr_irqs_gsi)
 		nr_irqs_gsi = nr;
-	} else {
-		/* for acpi=off or acpi is not compiled in */
-		int idx;
-
-		nr = 0;
-		for (idx = 0; idx < nr_ioapics; idx++)
-			nr += io_apic_get_redir_entries(idx) + 1;
-
-		if (nr > nr_irqs_gsi)
-			nr_irqs_gsi = nr;
-	}
 
 	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
@@ -4082,22 +4059,27 @@ int __init io_apic_get_version(int ioapic)
 	return reg_01.bits.version;
 }
 
-int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
+int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
 {
-	int i;
+	int ioapic, pin, idx;
 
 	if (skip_ioapic_setup)
 		return -1;
 
-	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].irqtype == mp_INT &&
-		    mp_irqs[i].srcbusirq == bus_irq)
-			break;
-	if (i >= mp_irq_entries)
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
 		return -1;
 
-	*trigger = irq_trigger(i);
-	*polarity = irq_polarity(i);
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+	if (pin < 0)
+		return -1;
+
+	idx = find_irq_entry(ioapic, pin, mp_INT);
+	if (idx < 0)
+		return -1;
+
+	*trigger = irq_trigger(idx);
+	*polarity = irq_polarity(idx);
 	return 0;
 }
 
@@ -4238,7 +4220,7 @@ void __init ioapic_insert_resources(void)
 	}
 }
 
-int mp_find_ioapic(int gsi)
+int mp_find_ioapic(u32 gsi)
 {
 	int i = 0;
 
@@ -4253,7 +4235,7 @@ int mp_find_ioapic(int gsi)
 	return -1;
 }
 
-int mp_find_ioapic_pin(int ioapic, int gsi)
+int mp_find_ioapic_pin(int ioapic, u32 gsi)
 {
 	if (WARN_ON(ioapic == -1))
 		return -1;
@@ -4281,6 +4263,7 @@ static int bad_ioapic(unsigned long address)
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
+	int entries;
 
 	if (bad_ioapic(address))
 		return;
@@ -4299,9 +4282,17 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
+	entries = io_apic_get_redir_entries(idx);
 	mp_gsi_routing[idx].gsi_base = gsi_base;
-	mp_gsi_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx);
+	mp_gsi_routing[idx].gsi_end = gsi_base + entries - 1;
+
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	nr_ioapic_registers[idx] = entries;
+
+	if (mp_gsi_routing[idx].gsi_end > gsi_end)
+		gsi_end = mp_gsi_routing[idx].gsi_end;
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index e81030f..5ae5d24 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -115,21 +115,6 @@ static void __init MP_bus_info(struct mpc_bus *m)
 		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
 }
 
-static int bad_ioapic(unsigned long address)
-{
-	if (nr_ioapics >= MAX_IO_APICS) {
-		printk(KERN_ERR "ERROR: Max # of I/O APICs (%d) exceeded "
-		       "(found %d)\n", MAX_IO_APICS, nr_ioapics);
-		panic("Recompile kernel with bigger MAX_IO_APICS!\n");
-	}
-	if (!address) {
-		printk(KERN_ERR "WARNING: Bogus (zero) I/O APIC address"
-		       " found in table, skipping!\n");
-		return 1;
-	}
-	return 0;
-}
-
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
 	if (!(m->flags & MPC_APIC_USABLE))
@@ -138,15 +123,7 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
 	       m->apicid, m->apicver, m->apicaddr);
 
-	if (bad_ioapic(m->apicaddr))
-		return;
-
-	mp_ioapics[nr_ioapics].apicaddr = m->apicaddr;
-	mp_ioapics[nr_ioapics].apicid = m->apicid;
-	mp_ioapics[nr_ioapics].type = m->type;
-	mp_ioapics[nr_ioapics].apicver = m->apicver;
-	mp_ioapics[nr_ioapics].flags = m->flags;
-	nr_ioapics++;
+	mp_register_ioapic(m->apicid, m->apicaddr, gsi_end + 1);
 }
 
 static void print_MP_intsrc_info(struct mpc_intsrc *m)
diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
index 34e0993..7ded578 100644
--- a/arch/x86/kernel/sfi.c
+++ b/arch/x86/kernel/sfi.c
@@ -81,7 +81,6 @@ static int __init sfi_parse_cpus(struct sfi_table_header *table)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
-static u32 gsi_base;
 
 static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 {
@@ -94,8 +93,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_base);
-		gsi_base += io_apic_get_redir_entries(i);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_end + 1);
 		pentry++;
 	}
 
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index b0a71ec..e4804fb 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -401,11 +401,13 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	 * driver reported one, then use it. Exit in any case.
 	 */
 	if (gsi < 0) {
+		u32 dev_gsi;
 		dev_warn(&dev->dev, "PCI INT %c: no GSI", pin_name(pin));
 		/* Interrupt Line values above 0xF are forbidden */
-		if (dev->irq > 0 && (dev->irq <= 0xF)) {
-			printk(" - using IRQ %d\n", dev->irq);
-			acpi_register_gsi(&dev->dev, dev->irq,
+		if (dev->irq > 0 && (dev->irq <= 0xF) &&
+		    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
+			printk(" - using ISA IRQ %d\n", dev->irq);
+			acpi_register_gsi(&dev->dev, dev_gsi,
 					  ACPI_LEVEL_SENSITIVE,
 					  ACPI_ACTIVE_LOW);
 			return 0;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index b926afe..3da73f5 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -116,11 +116,12 @@ extern unsigned long acpi_realmode_flags;
 
 int acpi_register_gsi (struct device *dev, u32 gsi, int triggering, int polarity);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
+int acpi_isa_irq_to_gsi (unsigned isa_irq, u32 *gsi);
 
 #ifdef CONFIG_X86_IO_APIC
-extern int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity);
+extern int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity);
 #else
-#define acpi_get_override_irq(bus, trigger, polarity) (-1)
+#define acpi_get_override_irq(gsi, trigger, polarity) (-1)
 #endif
 /*
  * This function undoes the effect of one call to acpi_register_gsi().
