Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2BXDu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:50:59 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37608 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2BXDu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:50:56 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Henrik Kretzschmar <henne@nachtwindheim.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 05/13] x86, irq: add ioapic_gsi_to_irq
Date: Thu, 23 Feb 2012 19:48:51 -0800
Message-Id: <1330055339-11662-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F4708C8.0001,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it will handle hot add ioapic that irq_base is not equal to gsi_base.

Also remove irq_to_gsi that is causing confusing.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/acpi/boot.c    |   22 +++++-----------------
 arch/x86/kernel/apic/io_apic.c |   29 ++++++++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index f2a83ae..b5489e8 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -168,6 +168,7 @@ struct mp_ioapic_gsi{
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
 extern u32 gsi_top;
+int ioapic_gsi_to_irq(u32 gsi);
 int mp_find_ioapic(u32 gsi);
 int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index ce664f3..fa9473b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -112,6 +112,10 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 		}
 	}
 
+#ifdef CONFIG_X86_IO_APIC
+	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
+		return ioapic_gsi_to_irq(gsi);
+#endif
 	/* Provide an identity mapping of gsi == irq
 	 * except on truly weird platforms that have
 	 * non isa irqs in the first 16 gsis.
@@ -124,22 +128,6 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 	return irq;
 }
 
-static u32 irq_to_gsi(int irq)
-{
-	unsigned int gsi;
-
-	if (irq < NR_IRQS_LEGACY)
-		gsi = isa_irq_to_gsi[irq];
-	else if (irq < gsi_top)
-		gsi = irq;
-	else if (irq < (gsi_top + NR_IRQS_LEGACY))
-		gsi = irq - gsi_top;
-	else
-		gsi = 0xffffffff;
-
-	return gsi;
-}
-
 /*
  * Temporarily use the virtual area starting from FIX_IO_APIC_BASE_END,
  * to map the target physical address. The problem is that set_fixmap()
@@ -527,7 +515,7 @@ int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
 	if (isa_irq >= 16)
 		return -1;
-	*gsi = irq_to_gsi(isa_irq);
+	*gsi = isa_irq_to_gsi[isa_irq];
 	return 0;
 }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0702998..527b184 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1081,13 +1081,16 @@ static int pin_2_irq(int idx, int apic, int pin)
 
 	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
-	} else {
+	} else if (gsi_cfg->gsi_base == gsi_cfg->irq_base) {
 		u32 gsi = gsi_cfg->gsi_base + pin;
 
 		if (gsi >= NR_IRQS_LEGACY)
 			irq = gsi;
 		else
 			irq = gsi_top + gsi;
+	} else {
+		/* hotadd ioapic */
+		irq = gsi_cfg->irq_base + pin;
 	}
 
 #ifdef CONFIG_X86_32
@@ -1581,6 +1584,30 @@ static void __init setup_IO_APIC_irqs(void)
 		__io_apic_setup_irqs(ioapic_idx);
 }
 
+int ioapic_gsi_to_irq(u32 gsi)
+{
+	int ioapic_idx = 0, irq = gsi;
+	struct mp_ioapic_gsi *gsi_cfg;
+
+	ioapic_idx = mp_find_ioapic(gsi);
+	if (ioapic_idx < 0)
+		return -1;
+
+	gsi_cfg = mp_ioapic_gsi_routing(ioapic_idx);
+	if (gsi_cfg->gsi_base == gsi_cfg->irq_base) {
+		if (gsi < NR_IRQS_LEGACY)
+			irq = gsi_top + gsi;
+	} else {
+		int pin = mp_find_ioapic_pin(ioapic_idx, gsi);
+
+		if (pin < 0)
+			return -1;
+		/* hotadd ioapic */
+		irq = gsi_cfg->irq_base + pin;
+	}
+
+	return irq;
+}
 /*
  * for the gsit that is not in first ioapic
  * but could not use acpi_register_gsi()
-- 
1.7.7

