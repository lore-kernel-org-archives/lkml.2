Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0FHRzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:55:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:40030 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab0FHRzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:55:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,385,1272870000"; 
   d="scan'208";a="286496372"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/apic: replace gsi_end with semiclosed gsi_next
Date: Tue,  8 Jun 2010 10:48:21 -0700
Message-Id: <1276019301-17815-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code gsi_end is inclusive, when gsi_end = 0, it is unclear
whether there are 0 gsis or the next available one is 0. By using semiclosed
gsi_next variable, we can avoid many +1 kind of corrections and fix a bug in
the SFI code where gsi for the firsrt IOAPIC starts with 1 instead of 0.

http://lkml.org/lkml/2010/6/7/394

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    4 ++--
 arch/x86/kernel/acpi/boot.c    |    8 ++++----
 arch/x86/kernel/apic/io_apic.c |   12 ++++++------
 arch/x86/kernel/mpparse.c      |    2 +-
 arch/x86/kernel/sfi.c          |    2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 63cb409..3463b93 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -183,7 +183,7 @@ struct mp_ioapic_gsi{
 	u32 gsi_end;
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
-extern u32 gsi_end;
+extern u32 gsi_next;
 int mp_find_ioapic(u32 gsi);
 int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
@@ -197,7 +197,7 @@ static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
 static inline void probe_nr_irqs_gsi(void)	{ }
-#define gsi_end (NR_IRQS_LEGACY - 1)
+#define gsi_next NR_IRQS_LEGACY
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
 struct io_apic_irq_attr;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 60cc405..a7fa7ff 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -118,7 +118,7 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 	if (gsi >= NR_IRQS_LEGACY)
 		irq = gsi;
 	else
-		irq = gsi_end + 1 + gsi;
+		irq = gsi_next + gsi;
 
 	return irq;
 }
@@ -129,10 +129,10 @@ static u32 irq_to_gsi(int irq)
 
 	if (irq < NR_IRQS_LEGACY)
 		gsi = isa_irq_to_gsi[irq];
-	else if (irq <= gsi_end)
+	else if (irq < gsi_next)
 		gsi = irq;
-	else if (irq <= (gsi_end + NR_IRQS_LEGACY))
-		gsi = irq - gsi_end;
+	else if (irq < (gsi_next + NR_IRQS_LEGACY))
+		gsi = irq - gsi_next + 1;
 	else
 		gsi = 0xffffffff;
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 33f3563..4f69e61 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -89,8 +89,8 @@ int nr_ioapics;
 /* IO APIC gsi routing info */
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
 
-/* The last gsi number used */
-u32 gsi_end;
+/* The next gsi number to be used */
+u32 gsi_next;
 
 /* MP IRQ source entries */
 struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
@@ -1035,7 +1035,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 		if (gsi >= NR_IRQS_LEGACY)
 			irq = gsi;
 		else
-			irq = gsi_end + 1 + gsi;
+			irq = gsi_next + gsi;
 	}
 
 #ifdef CONFIG_X86_32
@@ -3853,7 +3853,7 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr;
 
-	nr = gsi_end + 1 + NR_IRQS_LEGACY;
+	nr = gsi_next + NR_IRQS_LEGACY;
 	if (nr > nr_irqs_gsi)
 		nr_irqs_gsi = nr;
 
@@ -4294,8 +4294,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	nr_ioapic_registers[idx] = entries;
 
-	if (mp_gsi_routing[idx].gsi_end > gsi_end)
-		gsi_end = mp_gsi_routing[idx].gsi_end;
+	if (mp_gsi_routing[idx].gsi_end >= gsi_next)
+		gsi_next = mp_gsi_routing[idx].gsi_end + 1;
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5ae5d24..d95a2c3 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -123,7 +123,7 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
 	       m->apicid, m->apicver, m->apicaddr);
 
-	mp_register_ioapic(m->apicid, m->apicaddr, gsi_end + 1);
+	mp_register_ioapic(m->apicid, m->apicaddr, gsi_next);
 }
 
 static void print_MP_intsrc_info(struct mpc_intsrc *m)
diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
index 7ded578..c55d777 100644
--- a/arch/x86/kernel/sfi.c
+++ b/arch/x86/kernel/sfi.c
@@ -93,7 +93,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_end + 1);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_next);
 		pentry++;
 	}
 
-- 
1.6.3.3

