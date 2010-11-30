Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0K3W3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab0K3W2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:28:03 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, gorcunov@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 9/9] watchdog:  touch_nmi_watchdog should only touch local cpu not every one
Date: Tue, 30 Nov 2010 17:27:30 -0500
Message-Id: <1291156050-4482-10-git-send-email-dzickus@redhat.com>
In-Reply-To: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into a scenario where while one cpu was stuck and should have panic'd
because of the NMI watchdog, it didn't.  The reason was another cpu was spewing
stack dumps on to the console.  Upon investigation, I noticed that when writing
to the console and also when dumping the stack, the watchdog is touched.

This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu
just spins forever.

This change causes the semantics of touch_nmi_watchdog to be changed slightly.
Previously, I accidentally changed the semantics and we noticed there was a
codepath in which touch_nmi_watchdog could be touched from a preemtible area.
That caused a BUG() to happen when CONFIG_DEBUG_PREEMPT was enabled.  I believe
it was the acpi code.

My attempt here re-introduces the change to have the touch_nmi_watchdog() code
only touch the local cpu instead of all of the cpus.  But instead of using
__get_cpu_var(), I use the __raw_get_cpu_var() version.

This avoids the preemption problem.  However my reasoning wasn't because I was
trying to be lazy.  Instead I rationalized it as, well if preemption is enabled
then interrupts should be enabled to and the NMI watchdog will have no reason
to trigger.  So it won't matter if the wrong cpu is touched because the percpu
interrupt counters the NMI watchdog uses should still be incrementing.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e0f44dc..792a4ed 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -143,14 +143,15 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	if (watchdog_enabled) {
-		unsigned cpu;
+	/*
+	 * Using __raw here because some code paths have
+	 * preemption enabled.  If preemption is enabled
+	 * then interrupts should be enabled too, in which
+	 * case we shouldn't have to worry about the watchdog
+	 * going off.
+	 */
+	__raw_get_cpu_var(watchdog_nmi_touch) = true;
 
-		for_each_present_cpu(cpu) {
-			if (per_cpu(watchdog_nmi_touch, cpu) != true)
-				per_cpu(watchdog_nmi_touch, cpu) = true;
-		}
-	}
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
-- 
1.7.3.2

