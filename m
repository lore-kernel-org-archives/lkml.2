Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0LIU5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:57:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:35012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab0LIU5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:57:10 -0500
Date: Thu, 9 Dec 2010 20:56:49 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, yinghai@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com, len.brown@intel.com
In-Reply-To: <20101207133204.4d913c5a@feng-i7>
References: <20101207133204.4d913c5a@feng-i7>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic-cleanups] x86: Unify 3 similar ways of saving mp_irqs info
Message-ID: <tip-2d8009ba67f9503ceadf9d5a3b5637cee291ea8d@git.kernel.org>
Git-Commit-ID: 2d8009ba67f9503ceadf9d5a3b5637cee291ea8d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 20:56:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d8009ba67f9503ceadf9d5a3b5637cee291ea8d
Gitweb:     http://git.kernel.org/tip/2d8009ba67f9503ceadf9d5a3b5637cee291ea8d
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Fri, 19 Nov 2010 11:33:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Dec 2010 21:52:06 +0100

x86: Unify 3 similar ways of saving mp_irqs info

There are 3 places defining similar functions of saving IRQ vector
info into mp_irqs[] array: mmparse/acpi/mrst.

Replace the redundant code by a common function in io_apic.c as it's
only called when CONFIG_X86_IO_APIC=y

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20101207133204.4d913c5a@feng-i7>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |    2 +
 arch/x86/kernel/acpi/boot.c    |   32 ++--------------------
 arch/x86/kernel/apic/io_apic.c |   54 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/mpparse.c      |   56 ++-------------------------------------
 arch/x86/platform/mrst/mrst.c  |   30 +--------------------
 5 files changed, 64 insertions(+), 110 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 107f2d8..f327d38 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -184,6 +184,8 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
+extern void mp_save_irq(struct mpc_intsrc *m);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b3cf01a..1a5b9a8 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -937,32 +937,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
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
@@ -993,7 +967,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
 	mp_irq.dstirq = pin;	/* INTIN# */
 
-	save_mp_irq(&mp_irq);
+	mp_save_irq(&mp_irq);
 
 	isa_irq_to_gsi[bus_irq] = gsi;
 }
@@ -1068,7 +1042,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 		mp_irq.srcbusirq = i; /* Identity mapped */
 		mp_irq.dstirq = pin;
 
-		save_mp_irq(&mp_irq);
+		mp_save_irq(&mp_irq);
 	}
 }
 
@@ -1105,7 +1079,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
 	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
-	save_mp_irq(&mp_irq);
+	mp_save_irq(&mp_irq);
 #endif
 	return 0;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8a02150..c6b44f7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -126,6 +126,59 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
+static void assign_to_mp_irq(struct mpc_intsrc *m,
+				    struct mpc_intsrc *mp_irq)
+{
+	mp_irq->dstapic = m->dstapic;
+	mp_irq->type = m->type;
+	mp_irq->irqtype = m->irqtype;
+	mp_irq->irqflag = m->irqflag;
+	mp_irq->srcbus = m->srcbus;
+	mp_irq->srcbusirq = m->srcbusirq;
+	mp_irq->dstirq = m->dstirq;
+}
+
+static int mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
+					struct mpc_intsrc *m)
+{
+	if (mp_irq->dstapic != m->dstapic)
+		return 1;
+	if (mp_irq->type != m->type)
+		return 2;
+	if (mp_irq->irqtype != m->irqtype)
+		return 3;
+	if (mp_irq->irqflag != m->irqflag)
+		return 4;
+	if (mp_irq->srcbus != m->srcbus)
+		return 5;
+	if (mp_irq->srcbusirq != m->srcbusirq)
+		return 6;
+	if (mp_irq->dstirq != m->dstirq)
+		return 7;
+
+	return 0;
+}
+
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
+		if (!mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m))
+			return;
+	}
+
+	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
+	if (++mp_irq_entries == MAX_IRQ_SOURCES)
+		panic("Max # of irq sources exceeded!!\n");
+}
+
 struct irq_pin_list {
 	int apic, pin;
 	struct irq_pin_list *next;
@@ -136,6 +189,7 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
 }
 
+
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 27ccb70..4318687 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -144,18 +144,6 @@ static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
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
 static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
@@ -167,47 +155,9 @@ static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
 	m->srcbusirq = mp_irq->srcbusirq;
 	m->dstirq = mp_irq->dstirq;
 }
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
 
 
@@ -321,7 +271,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
 			break;
 		case MP_INTSRC:
-			MP_intsrc_info((struct mpc_intsrc *)mpt);
+			mp_save_irq((struct mpc_intsrc *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
 			break;
 		case MP_LINTSRC:
@@ -413,13 +363,13 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 
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
