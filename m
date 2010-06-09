Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0FIWHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:07:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:46892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0FIWHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:07:06 -0400
Date: Wed, 9 Jun 2010 22:06:46 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai.lu@oracle.com, ebiederm@xmission.com, tglx@linutronix.de,
       jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, yinghai.lu@oracle.com, tglx@linutronix.de,
       jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <m17hm9jre7.fsf_-_@fess.ebiederm.org>
References: <m17hm9jre7.fsf_-_@fess.ebiederm.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, irq: Rename gsi_end gsi_top, and fix off by one errors
Message-ID: <tip-a4384df3e24579d6292a1b3b41d500349948f30b@git.kernel.org>
Git-Commit-ID: a4384df3e24579d6292a1b3b41d500349948f30b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 22:06:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4384df3e24579d6292a1b3b41d500349948f30b
Gitweb:     http://git.kernel.org/tip/a4384df3e24579d6292a1b3b41d500349948f30b
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 8 Jun 2010 11:44:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 9 Jun 2010 13:34:06 -0700

x86, irq: Rename gsi_end gsi_top, and fix off by one errors

When I introduced the global variable gsi_end I thought gsi_end on
io_apics was one past the end of the gsi range for the io_apic.  After
it was pointed out the the range on io_apics was inclusive I changed
my global variable to match.  That was a big mistake.  Inclusive
semantics without a range start cannot describe the case when no gsi's
are allocated.  Describing the case where no gsi's are allocated is
important in sfi.c and mpparse.c so that we can assign gsi numbers
instead of blindly copying the gsi assignments the BIOS has done as we
do in the acpi case.

To keep from getting the global variable confused with the gsi range
end rename it gsi_top.

To allow describing the case where no gsi's are allocated have gsi_top
be one place the highest gsi number seen in the system.

This fixes an off by one bug in sfi.c:
Reported-by: jacob pan <jacob.jun.pan@linux.intel.com>

This fixes the same off by one bug in mpparse.c:

This fixes an off unreachable by one bug in acpi/boot.c:irq_to_gsi
Reported-by: Yinghai <yinghai.lu@oracle.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <m17hm9jre7.fsf_-_@fess.ebiederm.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    4 ++--
 arch/x86/kernel/acpi/boot.c    |    8 ++++----
 arch/x86/kernel/apic/io_apic.c |   12 ++++++------
 arch/x86/kernel/mpparse.c      |    2 +-
 arch/x86/kernel/sfi.c          |    2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

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
 
