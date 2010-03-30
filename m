Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0C3IJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:09:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47351 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0C3IHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:07:24 -0400
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
Subject: [PATCH 02/15] x86 acpi/irq: Teach acpi_get_override_irq to take a gsi not an isa_irq
Date: Tue, 30 Mar 2010 01:07:03 -0700
Message-Id: <1269936436-7039-2-git-send-email-ebiederm@xmission.com>
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

In perverse acpi implementations the isa irqs are not identity mapped
to the first 16 gsi.  Furthermore at least the extended interrupt
resource capability may return gsi's and not isa irqs.  So since
what we get from acpi is a gsi teach acpi_get_overrride_irq to
operate on a gsi instead of an isa_irq.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/apic/io_apic.c |   23 ++++++++++++++---------
 include/linux/acpi.h           |    4 ++--
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e4e0ddc..54ba1f7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4073,22 +4073,27 @@ int __init io_apic_get_version(int ioapic)
 	return reg_01.bits.version;
 }
 
-int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
+int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
 {
-	int i;
+	int ioapic, pin, idx;
 
 	if (skip_ioapic_setup)
 		return -1;
 
-	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].irqtype == mp_INT &&
-		    mp_irqs[i].srcbusirq == bus_irq)
-			break;
-	if (i >= mp_irq_entries)
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
+		return -1;
+
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+	if (pin < 0)
+		return -1;
+
+	idx = find_irq_entry(ioapic, pin, mp_INT);
+	if (idx < 0)
 		return -1;
 
-	*trigger = irq_trigger(i);
-	*polarity = irq_polarity(i);
+	*trigger = irq_trigger(idx);
+	*polarity = irq_polarity(idx);
 	return 0;
 }
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 7a937da..3da73f5 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -119,9 +119,9 @@ int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
 int acpi_isa_irq_to_gsi (unsigned isa_irq, u32 *gsi);
 
 #ifdef CONFIG_X86_IO_APIC
-extern int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity);
+extern int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity);
 #else
-#define acpi_get_override_irq(bus, trigger, polarity) (-1)
+#define acpi_get_override_irq(gsi, trigger, polarity) (-1)
 #endif
 /*
  * This function undoes the effect of one call to acpi_register_gsi().
-- 
1.6.5.2.143.g8cc62

