Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0F1KIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:08:53 -0400
Received: from www.tglx.de ([62.245.132.106]:43196 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab0F1KIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:08:52 -0400
Date: Mon, 28 Jun 2010 12:08:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] x86 fixes for 2.6.35
Message-ID: <alpine.LFD.2.00.1006281147140.2530@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
arch/um/include/asm/arch_hweight.h # 055c472: um, hweight: Fix UML boot crash d

Thanks,

	tglx

------------------>
Andi Kleen (3):
      percpu, x86: Avoid warnings of unused variables in per cpu
      x86, setup: Set ax register in boot vga query
      x86: Fix vsyscall on gcc 4.5 with -Os

Andres Salomon (1):
      x86: use __ASSEMBLY__ rather than __ASSEMBLER__

Borislav Petkov (1):
      um, hweight: Fix UML boot crash due to x86 optimized hweight

Darrick J. Wong (1):
      x86, Calgary: Increase max PHB number

Eric W. Biederman (1):
      x86, irq: Rename gsi_end gsi_top, and fix off by one errors

Thomas Backlund (1):
      x86: Fix rebooting on Dell Precision WorkStation T7400

Venkatesh Pallipadi (1):
      x86, pat: Proper init of memtype subtree_max_end


 arch/um/include/asm/arch_hweight.h      |    6 ++++++
 arch/x86/boot/video-vga.c               |    3 +--
 arch/x86/include/asm/io_apic.h          |    4 ++--
 arch/x86/include/asm/percpu.h           |    2 ++
 arch/x86/include/asm/pgtable_32_types.h |    2 +-
 arch/x86/include/asm/system.h           |    2 +-
 arch/x86/kernel/acpi/boot.c             |    8 ++++----
 arch/x86/kernel/apic/io_apic.c          |   12 ++++++------
 arch/x86/kernel/mpparse.c               |    2 +-
 arch/x86/kernel/pci-calgary_64.c        |   15 ++++++++++-----
 arch/x86/kernel/reboot.c                |    8 ++++++++
 arch/x86/kernel/sfi.c                   |    2 +-
 arch/x86/mm/pat.c                       |    2 +-
 arch/x86/mm/pat_rbtree.c                |    1 +
 14 files changed, 45 insertions(+), 24 deletions(-)
 create mode 100644 arch/um/include/asm/arch_hweight.h

diff --git a/arch/um/include/asm/arch_hweight.h b/arch/um/include/asm/arch_hweight.h
new file mode 100644
index 0000000..c656cf4
--- /dev/null
+++ b/arch/um/include/asm/arch_hweight.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_UM_HWEIGHT_H
+#define _ASM_UM_HWEIGHT_H
+
+#include <asm-generic/bitops/arch_hweight.h>
+
+#endif
diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index ed7aeff..45bc940 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -41,13 +41,12 @@ static __videocard video_vga;
 static u8 vga_set_basic_mode(void)
 {
 	struct biosregs ireg, oreg;
-	u16 ax;
 	u8 mode;
 
 	initregs(&ireg);
 
 	/* Query current mode */
-	ax = 0x0f00;
+	ireg.ax = 0x0f00;
 	intcall(0x10, &ireg, &oreg);
 	mode = oreg.al;
 
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 63cb409..9cb2edb 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -183,7 +183,7 @@ struct mp_ioapic_gsi{
 	u32 gsi_end;
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
-extern u32 gsi_end;
+extern u32 gsi_top;
 int mp_find_ioapic(u32 gsi);
 int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
@@ -197,7 +197,7 @@ static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
 static inline void probe_nr_irqs_gsi(void)	{ }
-#define gsi_end (NR_IRQS_LEGACY - 1)
+#define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
 struct io_apic_irq_attr;
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 0797e74..cd28f9a 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -77,6 +77,7 @@ do {							\
 	if (0) {					\
 		pto_T__ pto_tmp__;			\
 		pto_tmp__ = (val);			\
+		(void)pto_tmp__;			\
 	}						\
 	switch (sizeof(var)) {				\
 	case 1:						\
@@ -115,6 +116,7 @@ do {									\
 	if (0) {							\
 		pao_T__ pao_tmp__;					\
 		pao_tmp__ = (val);					\
+		(void)pao_tmp__;					\
 	}								\
 	switch (sizeof(var)) {						\
 	case 1:								\
diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index 5e67c15..ed5903b 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -26,7 +26,7 @@
  */
 #define VMALLOC_OFFSET	(8 * 1024 * 1024)
 
-#ifndef __ASSEMBLER__
+#ifndef __ASSEMBLY__
 extern bool __vmalloc_start_set; /* set once high_memory is set */
 #endif
 
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index b8fe48e..e7f4d33 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -451,7 +451,7 @@ void stop_this_cpu(void *dummy);
  *
  * (Could use an alternative three way for this if there was one.)
  */
-static inline void rdtsc_barrier(void)
+static __always_inline void rdtsc_barrier(void)
 {
 	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
 	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 60cc405..c05872a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -118,7 +118,7 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 	if (gsi >= NR_IRQS_LEGACY)
 		irq = gsi;
 	else
-		irq = gsi_end + 1 + gsi;
+		irq = gsi_top + gsi;
 
 	return irq;
 }
@@ -129,10 +129,10 @@ static u32 irq_to_gsi(int irq)
 
 	if (irq < NR_IRQS_LEGACY)
 		gsi = isa_irq_to_gsi[irq];
-	else if (irq <= gsi_end)
+	else if (irq < gsi_top)
 		gsi = irq;
-	else if (irq <= (gsi_end + NR_IRQS_LEGACY))
-		gsi = irq - gsi_end;
+	else if (irq < (gsi_top + NR_IRQS_LEGACY))
+		gsi = irq - gsi_top;
 	else
 		gsi = 0xffffffff;
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 33f3563..e41ed24 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -89,8 +89,8 @@ int nr_ioapics;
 /* IO APIC gsi routing info */
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
 
-/* The last gsi number used */
-u32 gsi_end;
+/* The one past the highest gsi number used */
+u32 gsi_top;
 
 /* MP IRQ source entries */
 struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
@@ -1035,7 +1035,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 		if (gsi >= NR_IRQS_LEGACY)
 			irq = gsi;
 		else
-			irq = gsi_end + 1 + gsi;
+			irq = gsi_top + gsi;
 	}
 
 #ifdef CONFIG_X86_32
@@ -3853,7 +3853,7 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr;
 
-	nr = gsi_end + 1 + NR_IRQS_LEGACY;
+	nr = gsi_top + NR_IRQS_LEGACY;
 	if (nr > nr_irqs_gsi)
 		nr_irqs_gsi = nr;
 
@@ -4294,8 +4294,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	nr_ioapic_registers[idx] = entries;
 
-	if (mp_gsi_routing[idx].gsi_end > gsi_end)
-		gsi_end = mp_gsi_routing[idx].gsi_end;
+	if (mp_gsi_routing[idx].gsi_end >= gsi_top)
+		gsi_top = mp_gsi_routing[idx].gsi_end + 1;
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5ae5d24..d86dbf7 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -123,7 +123,7 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
 	       m->apicid, m->apicver, m->apicaddr);
 
-	mp_register_ioapic(m->apicid, m->apicaddr, gsi_end + 1);
+	mp_register_ioapic(m->apicid, m->apicaddr, gsi_top);
 }
 
 static void print_MP_intsrc_info(struct mpc_intsrc *m)
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index fb99f7e..0b96b55 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -103,11 +103,16 @@ int use_calgary __read_mostly = 0;
 #define PMR_SOFTSTOPFAULT	0x40000000
 #define PMR_HARDSTOP		0x20000000
 
-#define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
-#define MAX_NUM_CHASSIS		8 /* max number of chassis */
-/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
-#define MAX_PHB_BUS_NUM		(MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
-#define PHBS_PER_CALGARY	4
+/*
+ * The maximum PHB bus number.
+ * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
+ * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
+ * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
+ * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
+ */
+#define MAX_PHB_BUS_NUM		384
+
+#define PHBS_PER_CALGARY	  4
 
 /* register offsets in Calgary's internal register space */
 static const unsigned long tar_offsets[] = {
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 8e1aac8..e3af342 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -228,6 +228,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T5400"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell T7400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision T7400",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T7400"),
+		},
+	},
 	{	/* Handle problems with rebooting on HP laptops */
 		.callback = set_bios_reboot,
 		.ident = "HP Compaq Laptop",
diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
index 7ded578..cb22acf 100644
--- a/arch/x86/kernel/sfi.c
+++ b/arch/x86/kernel/sfi.c
@@ -93,7 +93,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_end + 1);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_top);
 		pentry++;
 	}
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index acc15b2..64121a1 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -302,7 +302,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return -EINVAL;
 	}
 
-	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
+	new  = kzalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index f537087..f20eeec 100644
--- a/arch/x86/mm/pat_rbtree.c
+++ b/arch/x86/mm/pat_rbtree.c
@@ -226,6 +226,7 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
 		if (ret_type)
 			new->type = *ret_type;
 
+		new->subtree_max_end = new->end;
 		memtype_rb_insert(&memtype_rbroot, new);
 	}
 	return err;
