Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab1ETNhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:37:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:56462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933914Ab1ETNhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:37:40 -0400
Date: Fri, 20 May 2011 13:37:27 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-4c79185cdb1425fb74241d0be772ff1a9913091a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        daniel.blueman@gmail.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        daniel.blueman@gmail.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110518233157.481404505@sbsiddha-MOBL3.sc.intel.com>
References: <20110518233157.481404505@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Allocate ioapic_saved_data early
Git-Commit-ID: 4c79185cdb1425fb74241d0be772ff1a9913091a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:37:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c79185cdb1425fb74241d0be772ff1a9913091a
Gitweb:     http://git.kernel.org/tip/4c79185cdb1425fb74241d0be772ff1a9913091a
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 18 May 2011 16:31:32 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:40:50 +0200

x86, ioapic: Allocate ioapic_saved_data early

This allows re-using this buffer for enabling
interrupt-remapping during boot and resume. And thus allow for
consolidating the code between ioapic suspend/resume and
interrupt-remapping.

Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/20110518233157.481404505@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index df63620..8e771d3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -100,6 +100,11 @@ int mp_irq_entries;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
+/*
+ * Saved I/O APIC state during suspend/resume.
+*/
+static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
+
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
@@ -179,6 +184,14 @@ int __init arch_early_irq_init(void)
 		io_apic_irqs = ~0UL;
 	}
 
+	for (i = 0; i < nr_ioapics; i++) {
+		ioapic_saved_data[i] =
+			kzalloc(sizeof(struct IO_APIC_route_entry) *
+				nr_ioapic_registers[i], GFP_KERNEL);
+		if (!ioapic_saved_data[i])
+			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
+	}
+
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
 	node = cpu_to_node(0);
@@ -2918,8 +2931,6 @@ static int __init io_apic_bug_finalize(void)
 
 late_initcall(io_apic_bug_finalize);
 
-static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
-
 static void suspend_ioapic(int ioapic_id)
 {
 	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
@@ -2978,18 +2989,6 @@ static struct syscore_ops ioapic_syscore_ops = {
 
 static int __init ioapic_init_ops(void)
 {
-	int i;
-
-	for (i = 0; i < nr_ioapics; i++) {
-		unsigned int size;
-
-		size = nr_ioapic_registers[i]
-			* sizeof(struct IO_APIC_route_entry);
-		ioapic_saved_data[i] = kzalloc(size, GFP_KERNEL);
-		if (!ioapic_saved_data[i])
-			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
-	}
-
 	register_syscore_ops(&ioapic_syscore_ops);
 
 	return 0;
