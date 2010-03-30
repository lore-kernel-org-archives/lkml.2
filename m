Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0C3IIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:08:36 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36292 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab0C3IH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:07:29 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 14/15] x86 acpi/irq: Handle isa irqs that are not identity mapped to gsi's.
Date: Tue, 30 Mar 2010 01:07:15 -0700
Message-Id: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1oci6qlmr.fsf_-_@fess.ebiederm.org>
References: <m1oci6qlmr.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, trenn@suse.de, suresh.b.siddha@intel.com, len.brown@intel.com, tony.luck@intel.com, fenghua.yu@intel.com, linux-acpi@vger.kernel.org, iranna.ankad@in.ibm.com, garyhade@us.ibm.com, protasnb@gmail.com, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

ACPI irq source overrides are allowed for the 16 isa irqs and are
allowed to map any gsi to any isa irq.  A few motherboards have been
seen to take advantage of this and put the isa irqs on the 2nd or
3rd ioapic.  This causes some problems, most notably the fact
that we can not use any gsi < 16.

To correct this move the gsis that are not isa irqs and have
a gsi number < 16 into the linux irq space just past gsi_end.
This is what the es7000 platform is doing today.  Moving only the
low 16 gsis above the rest of the gsi's only penalizes weird
platforms, leaving sane acpi implementations with a 1-1 mapping
of gsis and irqs.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/acpi/boot.c    |   57 +++++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/apic/io_apic.c |    8 ++++-
 2 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0e514a1..c4b4bd9 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -92,6 +92,53 @@ static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PIC;
 
 
+/* 
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
 /*
  * Temporarily use the virtual area starting from FIX_IO_APIC_BASE_END,
  * to map the target physical address. The problem is that set_fixmap()
@@ -448,7 +495,7 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 {
-	*irq = gsi;
+	*irq = gsi_to_irq(gsi);
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
@@ -462,7 +509,7 @@ int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
 	if (isa_irq >= 16)
 		return -1;
-	*gsi = isa_irq;
+	*gsi = irq_to_gsi(isa_irq);
 	return 0;
 }
 
@@ -490,7 +537,7 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 	}
 #endif
-	irq = plat_gsi;
+	irq = gsi_to_irq(plat_gsi);
 
 	return irq;
 }
@@ -932,6 +979,8 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irq.dstirq = pin;	/* INTIN# */
 
 	save_mp_irq(&mp_irq);
+
+	isa_irq_to_gsi[bus_irq] = gsi;
 }
 
 void __init mp_config_acpi_legacy_irqs(void)
@@ -1085,7 +1134,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi, &irq_attr);
+	io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
 
 	return gsi;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d6def8..0ac368a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1036,7 +1036,11 @@ static int pin_2_irq(int idx, int apic, int pin)
                  */
 		if (ioapic_renumber_irq)
 			gsi = ioapic_renumber_irq(apic, gsi);
-		irq = gsi;
+
+		if (gsi >= NR_IRQS_LEGACY)
+			irq = gsi;
+		else
+			irq = gsi_end + 1 + gsi;
 	}
 
 #ifdef CONFIG_X86_32
@@ -3843,7 +3847,7 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr;
 
-	nr = gsi_end + 1;
+	nr = gsi_end + 1 + NR_IRQS_LEGACY;
 	if (nr > nr_irqs_gsi)
 		nr_irqs_gsi = nr;
 
-- 
1.6.5.2.143.g8cc62

