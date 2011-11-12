Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1KLWOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 17:14:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1KLWOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 17:14:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend regression)
Date: Sat, 12 Nov 2011 23:17:27 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Ferenc Wagner <wferi@niif.hu>, "Tomas M." <tmezzadra@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com, j-pihet@ti.com,
        khilman@ti.com, arjan@linux.intel.com, len.brown@intel.com,
        Arjan van de Ven <arjan@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <4EBD46DF.6060507@gmail.com> <201111120250.14151.rjw@sisk.pl> <87k475cxvf.fsf@tac.ki.iif.hu>
In-Reply-To: <87k475cxvf.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111122317.27576.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After commit e978aa7d7d57d04eb5f88a7507c4fb98577def77 (cpuidle: Move
dev->last_residency update to driver enter routine; remove
dev->last_state) setting acpi_idle_suspend to 1 by
acpi_processor_suspend() causes the ACPI cpuidle routines to return
error codes continuously, which in turn causes cpuidle to lock up
(hard).  However, acpi_idle_suspend doesn't appear to be useful for
any particular purpose (it's racy and doesn't really provide any real
protection), so it can be removed, which makes the problem go away.

Reported-and-tested-by: Tomas M. <tmezzadra@gmail.com>
Reported-and-tested-by: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/processor_idle.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c
+++ linux/drivers/acpi/processor_idle.c
@@ -224,7 +224,6 @@ static void lapic_timer_state_broadcast(
 /*
  * Suspend / resume control
  */
-static int acpi_idle_suspend;
 static u32 saved_bm_rld;
 
 static void acpi_idle_bm_rld_save(void)
@@ -243,21 +242,13 @@ static void acpi_idle_bm_rld_restore(voi
 
 int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
 {
-	if (acpi_idle_suspend == 1)
-		return 0;
-
 	acpi_idle_bm_rld_save();
-	acpi_idle_suspend = 1;
 	return 0;
 }
 
 int acpi_processor_resume(struct acpi_device * device)
 {
-	if (acpi_idle_suspend == 0)
-		return 0;
-
 	acpi_idle_bm_rld_restore();
-	acpi_idle_suspend = 0;
 	return 0;
 }
 
@@ -763,13 +754,6 @@ static int acpi_idle_enter_c1(struct cpu
 
 	local_irq_disable();
 
-	/* Do not access any ACPI IO ports in suspend path */
-	if (acpi_idle_suspend) {
-		local_irq_enable();
-		cpu_relax();
-		return -EINVAL;
-	}
-
 	lapic_timer_state_broadcast(pr, cx, 1);
 	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
@@ -810,13 +794,6 @@ static int acpi_idle_enter_simple(struct
 
 	local_irq_disable();
 
-	if (acpi_idle_suspend) {
-		local_irq_enable();
-		cpu_relax();
-		return -EINVAL;
-	}
-
-
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
@@ -895,12 +872,6 @@ static int acpi_idle_enter_bm(struct cpu
 	if (unlikely(!pr))
 		return -EINVAL;
 
-
-	if (acpi_idle_suspend) {
-		cpu_relax();
-		return -EINVAL;
-	}
-
 	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
 		if (drv->safe_state_index >= 0) {
 			return drv->states[drv->safe_state_index].enter(dev,

