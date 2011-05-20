Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab1ETNi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:38:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:56508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911Ab1ETNi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:38:56 -0400
Date: Fri, 20 May 2011 13:38:46 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-b69c6c3becc102f3eebc4ebba582abfe76be3f45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110518233157.744315519@sbsiddha-MOBL3.sc.intel.com>
References: <20110518233157.744315519@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Add struct ioapic
Git-Commit-ID: b69c6c3becc102f3eebc4ebba582abfe76be3f45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:38:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b69c6c3becc102f3eebc4ebba582abfe76be3f45
Gitweb:     http://git.kernel.org/tip/b69c6c3becc102f3eebc4ebba582abfe76be3f45
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 18 May 2011 16:31:35 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:40:56 +0200

x86, ioapic: Add struct ioapic

Introduce struct ioapic with nr_registers field.

This will pave way for consolidating different MAX_IO_APICS
arrays into it.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: daniel.blueman@gmail.com
Link: http://lkml.kernel.org/r/20110518233157.744315519@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io_apic.h |    1 -
 arch/x86/kernel/apic/io_apic.c |   32 +++++++++++++++++---------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index f46984e..147700a 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -105,7 +105,6 @@ struct IR_IO_APIC_route_entry {
  * # of IO-APICs and # of IRQ routing registers
  */
 extern int nr_ioapics;
-extern int nr_ioapic_registers[MAX_IO_APICS];
 
 #define MP_MAX_IOAPIC_PIN 127
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4fc544d..2a18a98 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -76,10 +76,12 @@ int sis_apic_bug = -1;
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
 
-/*
- * # of IRQ routing registers
- */
-int nr_ioapic_registers[MAX_IO_APICS];
+static struct ioapic {
+	/*
+	 * # of IRQ routing registers
+	 */
+	int nr_registers;
+} ioapics[MAX_IO_APICS];
 
 /* I/O APIC entries */
 struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
@@ -187,7 +189,7 @@ int __init arch_early_irq_init(void)
 	for (i = 0; i < nr_ioapics; i++) {
 		ioapic_saved_data[i] =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				nr_ioapic_registers[i], GFP_KERNEL);
+				ioapics[i].nr_registers, GFP_KERNEL);
 		if (!ioapic_saved_data[i])
 			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
 	}
@@ -586,7 +588,7 @@ static void clear_IO_APIC (void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++)
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			clear_IO_APIC_pin(apic, pin);
 }
 
@@ -642,7 +644,7 @@ int save_ioapic_entries(void)
 			continue;
 		}
 
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			ioapic_saved_data[apic][pin] =
 				ioapic_read_entry(apic, pin);
 	}
@@ -661,7 +663,7 @@ void mask_ioapic_entries(void)
 		if (!ioapic_saved_data[apic])
 			continue;
 
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			struct IO_APIC_route_entry entry;
 
 			entry = ioapic_saved_data[apic][pin];
@@ -684,7 +686,7 @@ int restore_ioapic_entries(void)
 		if (!ioapic_saved_data[apic])
 			continue;
 
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			ioapic_write_entry(apic, pin,
 					   ioapic_saved_data[apic][pin]);
 	}
@@ -1191,7 +1193,7 @@ static inline int IO_APIC_irq_trigger(int irq)
 	int apic, idx, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			idx = find_irq_entry(apic, pin, mp_INT);
 			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
 				return irq_trigger(idx);
@@ -1358,7 +1360,7 @@ static void __init __io_apic_setup_irqs(unsigned int apic_id)
 	struct io_apic_irq_attr attr;
 	unsigned int pin, irq;
 
-	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
+	for (pin = 0; pin < ioapics[apic_id].nr_registers; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
 		if (io_apic_pin_not_connected(idx, apic_id, pin))
 			continue;
@@ -1480,7 +1482,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].apicid, nr_ioapic_registers[i]);
+		       mp_ioapics[i].apicid, ioapics[i].nr_registers);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -1794,7 +1796,7 @@ void __init enable_IO_APIC(void)
 	for(apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
 		/* See if any of the pins is in ExtINT mode */
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			struct IO_APIC_route_entry entry;
 			entry = ioapic_read_entry(apic, pin);
 
@@ -3754,7 +3756,7 @@ void __init setup_ioapic_dest(void)
 		return;
 
 	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
-	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
+	for (pin = 0; pin < ioapics[ioapic].nr_registers; pin++) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
@@ -3948,7 +3950,7 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	/*
 	 * The number of IO-APIC IRQ registers (== #pins):
 	 */
-	nr_ioapic_registers[idx] = entries;
+	ioapics[idx].nr_registers = entries;
 
 	if (mp_gsi_routing[idx].gsi_end >= gsi_top)
 		gsi_top = mp_gsi_routing[idx].gsi_end + 1;
