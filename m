Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0C3IH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:07:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36219 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab0C3IHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:07:22 -0400
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
Subject: [PATCH 05/15] x86 acpi/irq: Generalize mp_config_acpi_legacy_irqs
Date: Tue, 30 Mar 2010 01:07:06 -0700
Message-Id: <1269936436-7039-5-git-send-email-ebiederm@xmission.com>
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

Remove the assumption that there is not an override for isa irq 0.
Instead lookup the gsi and from that lookup the ioapic and pin of each
isa irq indivdually.

In general this should not have any behavioural affect but in
perverse cases this gets all of the details correct, instead of
doing something weird.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/acpi/boot.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 1742888..9c48e99 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -960,8 +960,6 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 void __init mp_config_acpi_legacy_irqs(void)
 {
 	int i;
-	int ioapic;
-	unsigned int dstapic;
 	struct mpc_intsrc mp_irq;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
@@ -982,19 +980,27 @@ void __init mp_config_acpi_legacy_irqs(void)
 #endif
 
 	/*
-	 * Locate the IOAPIC that manages the ISA IRQs (0-15).
-	 */
-	ioapic = mp_find_ioapic(0);
-	if (ioapic < 0)
-		return;
-	dstapic = mp_ioapics[ioapic].apicid;
-
-	/*
 	 * Use the default configuration for the IRQs 0-15.  Unless
 	 * overridden by (MADT) interrupt source override entries.
 	 */
 	for (i = 0; i < 16; i++) {
+		int ioapic, pin;
+		unsigned int dstapic;
 		int idx;
+		u32 gsi;
+
+		/* Locate the gsi that irq i maps to. */
+		if (acpi_isa_irq_to_gsi(i, &gsi))
+			continue;
+
+		/*
+		 * Locate the IOAPIC that manages the ISA IRQ.
+		 */
+		ioapic = mp_find_ioapic(gsi);
+		if (ioapic < 0)
+			continue;
+		pin = mp_find_ioapic_pin(ioapic, gsi);
+		dstapic = mp_ioapics[ioapic].apicid;
 
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mpc_intsrc *irq = mp_irqs + idx;
@@ -1004,7 +1010,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 				break;
 
 			/* Do we already have a mapping for this IOAPIC pin */
-			if (irq->dstapic == dstapic && irq->dstirq == i)
+			if (irq->dstapic == dstapic && irq->dstirq == pin)
 				break;
 		}
 
@@ -1019,7 +1025,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 		mp_irq.dstapic = dstapic;
 		mp_irq.irqtype = mp_INT;
 		mp_irq.srcbusirq = i; /* Identity mapped */
-		mp_irq.dstirq = i;
+		mp_irq.dstirq = pin;
 
 		save_mp_irq(&mp_irq);
 	}
-- 
1.6.5.2.143.g8cc62

