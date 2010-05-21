Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0EUCES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 22:04:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:60059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945Ab0EUCEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 22:04:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,274,1272870000"; 
   d="scan'208,223";a="519939124"
Date: Fri, 21 May 2010 10:16:57 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       "Brown, Len" <len.brown@intel.com>
Subject: [PATCH 2/3] x86: unify current 3 similar ways of saving IRQ info
Message-ID: <20100521101657.461383ce@feng-i7>
In-Reply-To: <alpine.LFD.2.00.1005171102590.3368@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
	<alpine.LFD.2.00.1005111643380.3401@localhost.localdomain>
	<20100512103422.1d59cc85@feng-i7>
	<alpine.LFD.2.00.1005171102590.3368@localhost.localdomain>
Organization: intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9ba7685bfdcaa2a5c40eade388902c478bc46071 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Thu, 20 May 2010 17:40:05 +0800
Subject: [PATCH 2/3] x86: unify current 3 similar ways of saving IRQ info

There are 3 places defining the similar function of saving IRQ
vector info into mp_irqs[] array: mmparse/acpi/sfi. This patch
will reduce the redundant code, and make it only one API:
	void mp_save_irq(struct mpc_intsrc *m);

Cc: Len Brown <len.brown@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/include/asm/mpspec.h |    6 ++++++
 arch/x86/kernel/acpi/boot.c   |   32 +++-----------------------------
 arch/x86/kernel/mpparse.c     |   14 +++++++-------
 arch/x86/kernel/mrst.c        |   30 ++----------------------------
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
index 9a5ed58..8f32fe2 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -923,32 +923,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
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
@@ -979,7 +953,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
 	mp_irq.dstirq = pin;	/* INTIN# */
 
-	save_mp_irq(&mp_irq);
+	mp_save_irq(&mp_irq);
 
 	isa_irq_to_gsi[bus_irq] = gsi;
 }
@@ -1054,7 +1028,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 		mp_irq.srcbusirq = i; /* Identity mapped */
 		mp_irq.dstirq = pin;
 
-		save_mp_irq(&mp_irq);
+		mp_save_irq(&mp_irq);
 	}
 }
 
@@ -1091,7 +1065,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
 	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
-	save_mp_irq(&mp_irq);
+	mp_save_irq(&mp_irq);
 #endif
 	return 0;
 }
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5ae5d24..f5491f7 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -143,7 +143,7 @@ static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
 }
 
-static void __init assign_to_mp_irq(struct mpc_intsrc *m,
+static void assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mpc_intsrc *mp_irq)
 {
 	mp_irq->dstapic = m->dstapic;
@@ -167,7 +167,7 @@ static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
 	m->dstirq = mp_irq->dstirq;
 }
 
-static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
+static int mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
 	if (mp_irq->dstapic != m->dstapic)
@@ -188,7 +188,8 @@ static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
 	return 0;
 }
 
-static void __init MP_intsrc_info(struct mpc_intsrc *m)
+/* Will also be called in acpi/sfi related code */
+void mp_save_irq(struct mpc_intsrc *m)
 {
 	int i;
 
@@ -206,7 +207,6 @@ static void __init MP_intsrc_info(struct mpc_intsrc *m)
 #else /* CONFIG_X86_IO_APIC */
 static inline void __init MP_bus_info(struct mpc_bus *m) {}
 static inline void __init MP_ioapic_info(struct mpc_ioapic *m) {}
-static inline void __init MP_intsrc_info(struct mpc_intsrc *m) {}
 #endif /* CONFIG_X86_IO_APIC */
 
 
@@ -320,7 +320,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
 			break;
 		case MP_INTSRC:
-			MP_intsrc_info((struct mpc_intsrc *)mpt);
+			mp_save_irq((struct mpc_intsrc *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
 			break;
 		case MP_LINTSRC:
@@ -412,13 +412,13 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 
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
 
 
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index e796448..def416c 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -33,32 +33,6 @@ struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
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
@@ -92,7 +66,7 @@ static int __init sfi_parse_mtmr(struct sfi_table_header *table)
 			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 			mp_irq.dstapic = MP_APIC_ALL;
 			mp_irq.dstirq = pentry->irq;
-			save_mp_irq(&mp_irq);
+			mp_save_irq(&mp_irq);
 	}
 
 	return 0;
@@ -162,7 +136,7 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 		mp_irq.dstapic = MP_APIC_ALL;
 		mp_irq.dstirq = pentry->irq;
-		save_mp_irq(&mp_irq);
+		mp_save_irq(&mp_irq);
 	}
 	return 0;
 }
-- 
1.6.3.3
