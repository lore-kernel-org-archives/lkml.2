Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab1ERXdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:33:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:64110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab1ERXb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:31:58 -0400
X-ExtLoop1: 1
Message-Id: <20110518233157.673130611@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 18 May 2011 16:31:34 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com
Subject: [patch 4/9] x86, ioapic: remove duplicate code for saving/restoring RTEs
References: <20110518233130.524634928@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=use_saved_ioapic_for_suspend.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code flow for enabling interrupt-remapping has its own routines for saving and
restoring io-apic RTE's. ioapic suspend/resume code flow also has similar
routines. Remove the duplicate code.

Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
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
 


