Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308Ab1ETNjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:39:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:56519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911Ab1ETNjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:39:20 -0400
Date: Fri, 20 May 2011 13:39:10 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-57a6f74023c7fd943160d7635bbc8d9f66e2ab54@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110518233157.830697056@sbsiddha-MOBL3.sc.intel.com>
References: <20110518233157.830697056@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Consolidate ioapic_saved_data[] into 'struct ioapic'
Git-Commit-ID: 57a6f74023c7fd943160d7635bbc8d9f66e2ab54
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:39:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57a6f74023c7fd943160d7635bbc8d9f66e2ab54
Gitweb:     http://git.kernel.org/tip/57a6f74023c7fd943160d7635bbc8d9f66e2ab54
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 18 May 2011 16:31:36 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:40:57 +0200

x86, ioapic: Consolidate ioapic_saved_data[] into 'struct ioapic'

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: daniel.blueman@gmail.com
Link: http://lkml.kernel.org/r/20110518233157.830697056@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2a18a98..ceff2d2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -81,6 +81,10 @@ static struct ioapic {
 	 * # of IRQ routing registers
 	 */
 	int nr_registers;
+	/*
+	 * Saved state during suspend/resume, or while enabling intr-remap.
+	 */
+	struct IO_APIC_route_entry *saved_registers;
 } ioapics[MAX_IO_APICS];
 
 /* I/O APIC entries */
@@ -102,11 +106,6 @@ int mp_irq_entries;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
-/*
- * Saved I/O APIC state during suspend/resume, or while enabling intr-remap.
-*/
-static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
-
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
@@ -187,10 +186,10 @@ int __init arch_early_irq_init(void)
 	}
 
 	for (i = 0; i < nr_ioapics; i++) {
-		ioapic_saved_data[i] =
+		ioapics[i].saved_registers =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
 				ioapics[i].nr_registers, GFP_KERNEL);
-		if (!ioapic_saved_data[i])
+		if (!ioapics[i].saved_registers)
 			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
 	}
 
@@ -639,13 +638,13 @@ int save_ioapic_entries(void)
 	int err = 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_saved_data[apic]) {
+		if (!ioapics[apic].saved_registers) {
 			err = -ENOMEM;
 			continue;
 		}
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
-			ioapic_saved_data[apic][pin] =
+			ioapics[apic].saved_registers[pin] =
 				ioapic_read_entry(apic, pin);
 	}
 
@@ -660,13 +659,13 @@ void mask_ioapic_entries(void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_saved_data[apic])
+		if (ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			struct IO_APIC_route_entry entry;
 
-			entry = ioapic_saved_data[apic][pin];
+			entry = ioapics[apic].saved_registers[pin];
 			if (!entry.mask) {
 				entry.mask = 1;
 				ioapic_write_entry(apic, pin, entry);
@@ -676,19 +675,19 @@ void mask_ioapic_entries(void)
 }
 
 /*
- * Restore IO APIC entries which was saved in ioapic_saved_data
+ * Restore IO APIC entries which was saved in the ioapic structure.
  */
 int restore_ioapic_entries(void)
 {
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_saved_data[apic])
+		if (ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			ioapic_write_entry(apic, pin,
-					   ioapic_saved_data[apic][pin]);
+					   ioapics[apic].saved_registers[pin]);
 	}
 	return 0;
 }
