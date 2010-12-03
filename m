Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0LCDif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 22:38:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:42926 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab0LCDid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 22:38:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,291,1288594800"; 
   d="scan'208";a="356449326"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: mingo@elte.com, hpa@zytor.com, alan@linux.intel.com,
        Feng Tang <feng.tang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH] x86: unify current 3 similar ways of saving IRQ info
Date: Fri,  3 Dec 2010 12:11:58 +0800
Message-Id: <1291349518-3502-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 places defining the similar function of saving IRQ
vector info into mp_irqs[] array: mmparse/acpi/mrst. This patch
will reduce the redundant code, and make it only one API:
	void mp_save_irq(struct mpc_intsrc *m);

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/mpspec.h |    6 ++++++
 arch/x86/kernel/acpi/boot.c   |   32 +++-----------------------------
 arch/x86/kernel/mpparse.c     |   14 +++++++-------
 arch/x86/platform/mrst/mrst.c |   30 ++----------------------------
 4 files changed, 18 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index c82868e..17f4314 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -42,6 +42,12 @@ extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 
 #endif /* CONFIG_X86_64 */
 
+#ifdef CONFIG_X86_IO_APIC
+void mp_save_irq(struct mpc_intsrc *m);
+#else
+static inline void mp_save_irq(struct mpc_intsrc *m) {}
+#endif
+
 #if defined(CONFIG_MCA) || defined(CONFIG_EISA)
 extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 71232b9..006f896 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -949,32 +949,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
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
@@ -1005,7 +979,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
 	mp_irq.dstirq = pin;	/* INTIN# */
 
-	save_mp_irq(&mp_irq);
+	mp_save_irq(&mp_irq);
 
 	isa_irq_to_gsi[bus_irq] = gsi;
 }
@@ -1080,7 +1054,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 		mp_irq.srcbusirq = i; /* Identity mapped */
 		mp_irq.dstirq = pin;
 
-		save_mp_irq(&mp_irq);
+		mp_save_irq(&mp_irq);
 	}
 }
 
@@ -1117,7 +1091,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
 	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
-	save_mp_irq(&mp_irq);
+	mp_save_irq(&mp_irq);
 #endif
 	return 0;
 }
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9af64d9..ecaa897 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -144,7 +144,7 @@ static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
 }
 
-static void __init assign_to_mp_irq(struct mpc_intsrc *m,
+static void assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mpc_intsrc *mp_irq)
 {
 	mp_irq->dstapic = m->dstapic;
@@ -168,7 +168,7 @@ static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
 	m->dstirq = mp_irq->dstirq;
 }
 
-static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
+static int mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
 	if (mp_irq->dstapic != m->dstapic)
@@ -189,7 +189,8 @@ static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
 	return 0;
 }
 
-static void __init MP_intsrc_info(struct mpc_intsrc *m)
+/* Will also be called in acpi/sfi related code */
+void mp_save_irq(struct mpc_intsrc *m)
 {
 	int i;
 
@@ -207,7 +208,6 @@ static void __init MP_intsrc_info(struct mpc_intsrc *m)
 #else /* CONFIG_X86_IO_APIC */
 static inline void __init MP_bus_info(struct mpc_bus *m) {}
 static inline void __init MP_ioapic_info(struct mpc_ioapic *m) {}
-static inline void __init MP_intsrc_info(struct mpc_intsrc *m) {}
 #endif /* CONFIG_X86_IO_APIC */
 
 
@@ -337,7 +337,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
 			break;
 		case MP_INTSRC:
-			MP_intsrc_info((struct mpc_intsrc *)mpt);
+			mp_save_irq((struct mpc_intsrc *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
 			break;
 		case MP_LINTSRC:
@@ -429,13 +429,13 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 
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
-- 
1.7.0.4

