Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab0EECKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:10:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:37037 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab0EECKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:10:47 -0400
Date: Wed, 5 May 2010 02:09:37 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-11-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-11-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, ioapic: Move nr_ioapic_registers calculation to mp_register_ioapic.
Message-ID: <tip-7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af@git.kernel.org>
Git-Commit-ID: 7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:09:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af
Gitweb:     http://git.kernel.org/tip/7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:12 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:35:03 -0700

x86, ioapic: Move nr_ioapic_registers calculation to mp_register_ioapic.

Now that all ioapic registration happens in mp_register_ioapic we can
move the calculation of nr_ioapic_registers there from enable_IO_APIC.
The number of ioapic registers is already calucated in mp_register_ioapic
so all that really needs to be done is to save the caluclated value
in nr_ioapic_registers.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-11-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f807255..dae9240 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1953,20 +1953,8 @@ static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
 void __init enable_IO_APIC(void)
 {
-	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
 	int apic;
-	unsigned long flags;
-
-	/*
-	 * The number of IO-APIC IRQ registers (== #pins):
-	 */
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		reg_01.raw = io_apic_read(apic, 1);
-		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
-	}
 
 	if (!legacy_pic->nr_legacy_irqs)
 		return;
@@ -4293,6 +4281,7 @@ static int bad_ioapic(unsigned long address)
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
+	int entries;
 
 	if (bad_ioapic(address))
 		return;
@@ -4311,9 +4300,14 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
+	entries = io_apic_get_redir_entries(idx);
 	mp_gsi_routing[idx].gsi_base = gsi_base;
-	mp_gsi_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx) - 1;
+	mp_gsi_routing[idx].gsi_end = gsi_base + entries - 1;
+
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	nr_ioapic_registers[idx] = entries;
 
 	if (mp_gsi_routing[idx].gsi_end > gsi_end)
 		gsi_end = mp_gsi_routing[idx].gsi_end;
