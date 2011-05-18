Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab1ERXdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:33:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:64110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab1ERXb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:31:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,234,1304319600"; 
   d="scan'208";a="652610"
Message-Id: <20110518233157.481404505@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 18 May 2011 16:31:32 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com
Subject: [patch 2/9] x86, ioapic: allocate ioapic_saved_data early
References: <20110518233130.524634928@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=allocate_ioapic_saved_data_early.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows re-using this buffer for enabling interrupt-remapping during
boot and resume. And thus allow for conslidating the code between
ioapic suspend/resume and interrupt-remapping.

Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
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
@@ -2918,8 +2931,6 @@ static int __init io_apic_bug_finalize(v
 
 late_initcall(io_apic_bug_finalize);
 
-static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
-
 static void suspend_ioapic(int ioapic_id)
 {
 	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
@@ -2978,18 +2989,6 @@ static struct syscore_ops ioapic_syscore
 
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


