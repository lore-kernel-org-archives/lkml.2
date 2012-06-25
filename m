Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2FYMiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:38:18 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56214 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab2FYMiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:38:17 -0400
Message-ID: <4FE85BAF.609@linux.vnet.ibm.com>
Date: Mon, 25 Jun 2012 18:08:07 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Fengguang Wu <wfg@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Preeti Murthy <preeti@linux.vnet.ibm.com>,
        Srivatsa S Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: boot hang on commit "PM / ACPI: Fix suspend/resume regression
 caused by cpuidle cleanup."
References: <20120622073513.GA15864@localhost> <4FE44163.4060509@linux.vnet.ibm.com> <20120622122453.GA17341@localhost> <201206250018.15384.rjw@sisk.pl>
In-Reply-To: <201206250018.15384.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12062512-3864-0000-0000-0000037C1102
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

Fix suspend/resume regression caused by cpuidle cleanup.

Commit e978aa7d7d57d04eb5f88a7507c4fb98577def77 ( cpuidle: Move
dev->last_residency update to driver enter routine; remove dev->last_state)
was  breaking suspend on laptops, as reported in the below link
	- https://lkml.org/lkml/2011/11/11/164

This was fixed in commit 3439a8da16bcad6b0982ece938c9f8299bb53584
(ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend regression)
by removing acpi_idle_suspend flag.
	- https://lkml.org/lkml/2011/11/14/74

But this did fix did not work on all systems
as Suspend/resume regression was reported on Lenovo S10-3
recently by Dave.
	- https://lkml.org/lkml/2012/5/27/115
It looked like with commit e978aa7d broke suspend and
with commit 3439a8da resume was not working with acpi_idle driver.

This patch fixes the regression that caused this issue
in the first place. acpi_idle_suspend flag is essential on
some x86 systems to prevent the cpus from going to deeper C-states
when suspend is triggered ( commit b04e7bdb984 )
So reverting the commit 3439a8da is essential.

By default, irqs are disabled in cpu_idle arch specific call
and re-enabled in idle state return path . During suspend,
the acpi_idle_suspend flag is set, which
prevents the cpus from going to deeper idle states,
it is essential to enabling the irqs in this return path too.

To address the suspend issue,
we were not re-enabling the interrupts while returning from
acpi_idle_enter_bm() routine if acpi_idle_suspend flag is set.
and this caused suspend failure.

In addition to the above, to improve the readability of the code,
return of -ENIVAL is replaced with -EBUSY in acpi_idle_suspend
return path. Implying that the system is currently busy when suspend
is in progress, which prevents the cpus from entering deeper C-states.

---
This patch applies on 3.5-rc2

Reported-and-Tested-by: Dav Hansen <dave@linux.vnet.ibm.com>
Tested-by: Preeti Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Reviewed-by: Srivatsa S Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/processor_idle.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f3decb3..47a8caa 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -224,6 +224,7 @@ static void lapic_timer_state_broadcast(struct acpi_processor *pr,
 /*
  * Suspend / resume control
  */
+static int acpi_idle_suspend;
 static u32 saved_bm_rld;
 
 static void acpi_idle_bm_rld_save(void)
@@ -242,13 +243,21 @@ static void acpi_idle_bm_rld_restore(void)
 
 int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
 {
+	if (acpi_idle_suspend == 1)
+		return 0;
+
 	acpi_idle_bm_rld_save();
+	acpi_idle_suspend = 1;
 	return 0;
 }
 
 int acpi_processor_resume(struct acpi_device * device)
 {
+	if (acpi_idle_suspend == 0)
+		return 0;
+
 	acpi_idle_bm_rld_restore();
+	acpi_idle_suspend = 0;
 	return 0;
 }
 
@@ -754,6 +763,12 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 
 	local_irq_disable();
 
+	if (acpi_idle_suspend) {
+		local_irq_enable();
+		cpu_relax();
+		return -EBUSY;
+	}
+
 	lapic_timer_state_broadcast(pr, cx, 1);
 	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
@@ -823,6 +838,12 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 
 	local_irq_disable();
 
+	if (acpi_idle_suspend) {
+		local_irq_enable();
+		cpu_relax();
+		return -EBUSY;
+	}
+
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
@@ -907,14 +928,21 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 						drv, drv->safe_state_index);
 		} else {
 			local_irq_disable();
-			acpi_safe_halt();
+			if (!acpi_idle_suspend)
+				acpi_safe_halt();
 			local_irq_enable();
-			return -EINVAL;
+			return -EBUSY;
 		}
 	}
 
 	local_irq_disable();
 
+	if (acpi_idle_suspend) {
+		local_irq_enable();
+		cpu_relax();
+		return -EBUSY;
+	}
+
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
 		current_thread_info()->status &= ~TS_POLLING;
 		/*

Cheers,
Deepthi

