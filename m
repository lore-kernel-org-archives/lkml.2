Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0LGFeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 00:34:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:64893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab0LGFeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 00:34:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,309,1288594800"; 
   d="scan'208";a="865283377"
Date: Tue, 7 Dec 2010 13:32:04 +0800
From: Feng Tang <feng.tang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/platform] x86: Unify current 3 similar ways of saving
 IRQ info
Message-ID: <20101207133204.4d913c5a@feng-i7>
In-Reply-To: <4CFD226C.60308@kernel.org>
References: <1291349518-3502-1-git-send-email-feng.tang@intel.com>
	<tip-a6427a341985e0379060c86b50fcdb59883e4102@git.kernel.org>
	<4CFD226C.60308@kernel.org>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010 01:50:36 +0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On 12/06/2010 07:01 AM, tip-bot for Feng Tang wrote:
> > Commit-ID:  a6427a341985e0379060c86b50fcdb59883e4102
> > Gitweb:
> > http://git.kernel.org/tip/a6427a341985e0379060c86b50fcdb59883e4102
> > Author:     Feng Tang <feng.tang@intel.com> AuthorDate: Fri, 3 Dec
> > 2010 12:11:58 +0800 Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Mon, 6 Dec 2010 15:58:26 +0100
> > 
> > x86: Unify current 3 similar ways of saving IRQ info
> > 
> > There are 3 places defining the similar function of saving IRQ
> > vector info into mp_irqs[] array: mmparse/acpi/mrst. This patch
> > will reduce the redundant code, and make it only one API:
> > 	void mp_save_irq(struct mpc_intsrc *m);
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > Cc: Alan Cox <alan@linux.intel.com>
> > Cc: Len Brown <len.brown@intel.com>
> > LKML-Reference:
> > <1291349518-3502-1-git-send-email-feng.tang@intel.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de> ---
> >  arch/x86/include/asm/mpspec.h |    6 ++++++
> >  arch/x86/kernel/acpi/boot.c   |   32
> > +++----------------------------- arch/x86/kernel/mpparse.c     |
> > 14 +++++++------- arch/x86/platform/mrst/mrst.c |   30
> > ++---------------------------- 4 files changed, 18 insertions(+),
> > 64 deletions(-)
> > 
> 
> it breaks compiling when CONFIG_X86_MPPARSE is not defined.
> 
> obj-$(CONFIG_X86_MPPARSE)       += mpparse.o
> 
> 
> config X86_MPPARSE              
>         bool "Enable MPS table" if ACPI
>         default y
>         depends on X86_LOCAL_APIC
>         ---help---              
>           For old smp systems that do not have proper acpi support.
> Newer systems (esp with 64bit cpus) with acpi support, MADT and DSDT
> will override it
> 
> 
> 
> Yinghai

Thanks for the good catch! I only tried allyes/allno/allmod/def configs.

How about move the code into io_apic.c as mp_save_irq() only will get
called when CONFIG_X86_IO_APIC=y, pls review the following patch which
is against x86/platform branch of tip tree

Thanks,
Feng

>From c84518b4243e30de1470c9e3dfa38b2ee4fd34ee Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Fri, 19 Nov 2010 11:33:35 +0800
Subject: [PATCH] x86: unify current 3 similar ways of saving IRQ info

There are 3 places defining the similar function of saving IRQ
vector info into mp_irqs[] array: mmparse/acpi/mrst. This patch
will reduce the redundant code, and make it only one API in
io_apic.c:
	void mp_save_irq(struct mpc_intsrc *m);
as that func will only get called when CONFIG_X86_IO_APIC=y

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/io_apic.h |    2 +
 arch/x86/kernel/acpi/boot.c    |   32 ++--------------------
 arch/x86/kernel/apic/io_apic.c |   54 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/mpparse.c      |   56 ++-------------------------------------
 arch/x86/platform/mrst/mrst.c  |   30 +--------------------
 5 files changed, 64 insertions(+), 110 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index a6b28d0..df49dd6 100644
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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7cc0a72..4aa4dbc 100644
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
index 9af64d9..1fe4e79 100644
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
 
 
@@ -337,7 +287,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
 			break;
 		case MP_INTSRC:
-			MP_intsrc_info((struct mpc_intsrc *)mpt);
+			mp_save_irq((struct mpc_intsrc *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
 			break;
 		case MP_LINTSRC:
@@ -429,13 +379,13 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 
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

