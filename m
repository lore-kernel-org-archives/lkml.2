Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487Ab0EECND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:13:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:37117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab0EECNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:13:00 -0400
Date: Wed, 5 May 2010 02:10:29 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, acpi/irq: Handle isa irqs that are not identity mapped to gsi's.
Message-ID: <tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>
Git-Commit-ID: 988856ee1623bd37e384105f7bb2b7fe44c009f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:10:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  988856ee1623bd37e384105f7bb2b7fe44c009f6
Gitweb:     http://git.kernel.org/tip/988856ee1623bd37e384105f7bb2b7fe44c009f6
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:15 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:35:17 -0700

x86, acpi/irq: Handle isa irqs that are not identity mapped to gsi's.

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
LKML-Reference: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/acpi/boot.c    |   57 +++++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/apic/io_apic.c |    8 ++++-
 2 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 07a63ce..325fbba 100644
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
@@ -449,7 +496,7 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 {
-	*irq = gsi;
+	*irq = gsi_to_irq(gsi);
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
@@ -463,7 +510,7 @@ int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
 	if (isa_irq >= 16)
 		return -1;
-	*gsi = isa_irq;
+	*gsi = irq_to_gsi(isa_irq);
 	return 0;
 }
 
@@ -491,7 +538,7 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 	}
 #endif
-	irq = plat_gsi;
+	irq = gsi_to_irq(plat_gsi);
 
 	return irq;
 }
@@ -933,6 +980,8 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irq.dstirq = pin;	/* INTIN# */
 
 	save_mp_irq(&mp_irq);
+
+	isa_irq_to_gsi[bus_irq] = gsi;
 }
 
 void __init mp_config_acpi_legacy_irqs(void)
@@ -1086,7 +1135,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi, &irq_attr);
+	io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
 
 	return gsi;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9f3f6ca..594827c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1037,7 +1037,11 @@ static int pin_2_irq(int idx, int apic, int pin)
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
@@ -3852,7 +3856,7 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr;
 
-	nr = gsi_end + 1;
+	nr = gsi_end + 1 + NR_IRQS_LEGACY;
 	if (nr > nr_irqs_gsi)
 		nr_irqs_gsi = nr;
 
