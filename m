Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466Ab0EECLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:11:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:37063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab0EECL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:11:27 -0400
Date: Wed, 5 May 2010 02:09:54 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-12-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-12-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, ioapic: Optimize pin_2_irq
Message-ID: <tip-d464207c4fdd70c2a0febd4f9c58206fa915bb36@git.kernel.org>
Git-Commit-ID: d464207c4fdd70c2a0febd4f9c58206fa915bb36
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:09:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d464207c4fdd70c2a0febd4f9c58206fa915bb36
Gitweb:     http://git.kernel.org/tip/d464207c4fdd70c2a0febd4f9c58206fa915bb36
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:13 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:35:08 -0700

x86, ioapic: Optimize pin_2_irq

Now that all ioapics have valid gsi_base values use this to
accellerate pin_2_irq.  In the case of acpi this also ensures
that pin_2_irq will compute the same irq value for an ioapic
pin as acpi will.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-12-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index dae9240..0d35f46 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1019,7 +1019,7 @@ static inline int irq_trigger(int idx)
 int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
-	int irq, i;
+	int irq;
 	int bus = mp_irqs[idx].srcbus;
 
 	/*
@@ -1031,18 +1031,13 @@ static int pin_2_irq(int idx, int apic, int pin)
 	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
 	} else {
-		/*
-		 * PCI IRQs are mapped in order
-		 */
-		i = irq = 0;
-		while (i < apic)
-			irq += nr_ioapic_registers[i++];
-		irq += pin;
+		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
 		/*
                  * For MPS mode, so far only needed by ES7000 platform
                  */
 		if (ioapic_renumber_irq)
-			irq = ioapic_renumber_irq(apic, irq);
+			gsi = ioapic_renumber_irq(apic, gsi);
+		irq = gsi;
 	}
 
 #ifdef CONFIG_X86_32
