Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1EPS7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:59:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:37511 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab1EPS7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:59:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,220,1304319600"; 
   d="scan'208";a="2408173"
Message-Id: <20110516185646.559690403@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 16 May 2011 11:56:07 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com
Subject: [patch 4/4] x86, ioapic: remove duplicate code for saving/restoring RTEs
References: <20110516185646.282418545@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=use_saved_ioapic_for_suspend.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code flow for enabling interrupt-remapping has its own routines for saving and
restoring io-apic RTE's. ioapic suspend/resume code flow also has similar
routines. Remove the duplicate code.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -2887,37 +2887,11 @@ static int __init io_apic_bug_finalize(v
 
 late_initcall(io_apic_bug_finalize);
 
-static void suspend_ioapic(int ioapic_id)
+static void resume_ioapic_id(int ioapic_id)
 {
-	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
-	int i;
-
-	if (!saved_data)
-		return;
-
-	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
-		saved_data[i] = ioapic_read_entry(ioapic_id, i);
-}
-
-static int ioapic_suspend(void)
-{
-	int ioapic_id;
-
-	for (ioapic_id = 0; ioapic_id < nr_ioapics; ioapic_id++)
-		suspend_ioapic(ioapic_id);
-
-	return 0;
-}
-
-static void resume_ioapic(int ioapic_id)
-{
-	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
 	unsigned long flags;
 	union IO_APIC_reg_00 reg_00;
-	int i;
 
-	if (!saved_data)
-		return;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic_id, 0);
@@ -2926,8 +2900,6 @@ static void resume_ioapic(int ioapic_id)
 		io_apic_write(ioapic_id, 0, reg_00.raw);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
-		ioapic_write_entry(ioapic_id, i, saved_data[i]);
 }
 
 static void ioapic_resume(void)
@@ -2935,11 +2907,13 @@ static void ioapic_resume(void)
 	int ioapic_id;
 
 	for (ioapic_id = nr_ioapics - 1; ioapic_id >= 0; ioapic_id--)
-		resume_ioapic(ioapic_id);
+		resume_ioapic_id(ioapic_id);
+
+	restore_ioapic_entries();
 }
 
 static struct syscore_ops ioapic_syscore_ops = {
-	.suspend = ioapic_suspend,
+	.suspend = save_ioapic_entries,
 	.resume = ioapic_resume,
 };
 


