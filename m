Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496Ab0EECIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:08:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:34950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760479Ab0EECIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:08:10 -0400
Date: Wed, 5 May 2010 02:07:55 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-5-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-5-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, acpi/irq: Generalize mp_config_acpi_legacy_irqs
Message-ID: <tip-0fd52670fb6400be0996ac492b5ed77f3d83d69a@git.kernel.org>
Git-Commit-ID: 0fd52670fb6400be0996ac492b5ed77f3d83d69a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:07:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fd52670fb6400be0996ac492b5ed77f3d83d69a
Gitweb:     http://git.kernel.org/tip/0fd52670fb6400be0996ac492b5ed77f3d83d69a
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:06 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:34:38 -0700

x86, acpi/irq: Generalize mp_config_acpi_legacy_irqs

Remove the assumption that there is not an override for isa irq 0.
Instead lookup the gsi and from that lookup the ioapic and pin of each
isa irq indivdually.

In general this should not have any behavioural affect but in
perverse cases this gets all of the details correct, instead of
doing something weird.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-5-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/acpi/boot.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0a036dc..3ee92f2 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -961,8 +961,6 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 void __init mp_config_acpi_legacy_irqs(void)
 {
 	int i;
-	int ioapic;
-	unsigned int dstapic;
 	struct mpc_intsrc mp_irq;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
@@ -983,19 +981,27 @@ void __init mp_config_acpi_legacy_irqs(void)
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
@@ -1005,7 +1011,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 				break;
 
 			/* Do we already have a mapping for this IOAPIC pin */
-			if (irq->dstapic == dstapic && irq->dstirq == i)
+			if (irq->dstapic == dstapic && irq->dstirq == pin)
 				break;
 		}
 
@@ -1020,7 +1026,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 		mp_irq.dstapic = dstapic;
 		mp_irq.irqtype = mp_INT;
 		mp_irq.srcbusirq = i; /* Identity mapped */
-		mp_irq.dstirq = i;
+		mp_irq.dstirq = pin;
 
 		save_mp_irq(&mp_irq);
 	}
