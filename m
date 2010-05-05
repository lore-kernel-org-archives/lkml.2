Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448Ab0EECIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:08:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:34935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760404Ab0EECH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:07:59 -0400
Date: Wed, 5 May 2010 02:07:03 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-2-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-2-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, acpi/irq: Teach acpi_get_override_irq to take a gsi not an isa_irq
Message-ID: <tip-9a0a91bb56d2915cdb8585717de38376ad20fef9@git.kernel.org>
Git-Commit-ID: 9a0a91bb56d2915cdb8585717de38376ad20fef9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:07:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a0a91bb56d2915cdb8585717de38376ad20fef9
Gitweb:     http://git.kernel.org/tip/9a0a91bb56d2915cdb8585717de38376ad20fef9
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:03 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:34:27 -0700

x86, acpi/irq: Teach acpi_get_override_irq to take a gsi not an isa_irq

In perverse acpi implementations the isa irqs are not identity mapped
to the first 16 gsi.  Furthermore at least the extended interrupt
resource capability may return gsi's and not isa irqs.  So since
what we get from acpi is a gsi teach acpi_get_overrride_irq to
operate on a gsi instead of an isa_irq.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-2-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |   23 ++++++++++++++---------
 include/linux/acpi.h           |    4 ++--
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 127b871..73ec928 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4082,22 +4082,27 @@ int __init io_apic_get_version(int ioapic)
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
