Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab0E0Cmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:42:54 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:52930 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab0E0Cmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:42:47 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 7/8] ACPI: acpi_idle: touch TS_POLLING only in the non-MWAIT
 case
Date: Wed, 26 May 2010 22:42:30 -0400
Message-id: <34959ffadbffe1eaedcf5cc677916b2f7313dc4e.1274926772.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-reply-to: <1274928151-30919-1-git-send-email-lenb@kernel.org>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
In-reply-to: <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
References: <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

commit d306ebc28649b89877a22158fe0076f06cc46f60
(ACPI: Be in TS_POLLING state during mwait based C-state entry)
fixed an important power & performance issue where ACPI c2 and c3 C-states
were clearing TS_POLLING even when using MWAIT (ACPI_STATE_FFH).
That bug had been causing us to receive redundant scheduling interrups
when we had already been woken up by MONITOR/MWAIT.

Following up on that...

In the MWAIT case, we don't have to subsequently
check need_resched(), as that c heck was there
for the TS_POLLING-clearing case.

Note that not only does the cpuidle calling function
already check need_resched() before calling us, the
low-level entry into monitor/mwait calls it twice --
guaranteeing that a write to the trigger address
can not go un-noticed.

Also, in this case, we don't have to set TS_POLLING
when we wake, because we never cleared it.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>
---
 drivers/acpi/processor_idle.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 5939e7f..a4166e2 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -881,6 +881,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 		return(acpi_idle_enter_c1(dev, state));
 
 	local_irq_disable();
+
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
@@ -888,12 +889,12 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 		 * NEED_RESCHED:
 		 */
 		smp_mb();
-	}
 
-	if (unlikely(need_resched())) {
-		current_thread_info()->status |= TS_POLLING;
-		local_irq_enable();
-		return 0;
+		if (unlikely(need_resched())) {
+			current_thread_info()->status |= TS_POLLING;
+			local_irq_enable();
+			return 0;
+		}
 	}
 
 	/*
@@ -918,7 +919,8 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
 
 	local_irq_enable();
-	current_thread_info()->status |= TS_POLLING;
+	if (cx->entry_method != ACPI_CSTATE_FFH)
+		current_thread_info()->status |= TS_POLLING;
 
 	cx->usage++;
 
@@ -968,6 +970,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	}
 
 	local_irq_disable();
+
 	if (cx->entry_method != ACPI_CSTATE_FFH) {
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
@@ -975,12 +978,12 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		 * NEED_RESCHED:
 		 */
 		smp_mb();
-	}
 
-	if (unlikely(need_resched())) {
-		current_thread_info()->status |= TS_POLLING;
-		local_irq_enable();
-		return 0;
+		if (unlikely(need_resched())) {
+			current_thread_info()->status |= TS_POLLING;
+			local_irq_enable();
+			return 0;
+		}
 	}
 
 	acpi_unlazy_tlb(smp_processor_id());
@@ -1032,7 +1035,8 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
 
 	local_irq_enable();
-	current_thread_info()->status |= TS_POLLING;
+	if (cx->entry_method != ACPI_CSTATE_FFH)
+		current_thread_info()->status |= TS_POLLING;
 
 	cx->usage++;
 
-- 
1.6.0.6

