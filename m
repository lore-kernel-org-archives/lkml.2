Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab1GAVce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:32:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886Ab1GAVbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:31:08 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH v4 7/9] KVM-GST: KVM Steal time accounting
Date: Fri,  1 Jul 2011 17:22:47 -0400
Message-Id: <1309555369-16867-8-git-send-email-glommer@redhat.com>
In-Reply-To: <1309555369-16867-1-git-send-email-glommer@redhat.com>
References: <1309555369-16867-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch accounts steal time time in account_process_tick.
If one or more tick is considered stolen in the current
accounting cycle, user/system accounting is skipped. Idle is fine,
since the hypervisor does not report steal time if the guest
is halted.

Accounting steal time from the core scheduler give us the
advantage of direct access to the runqueue data. In a later
opportunity, it can be used to tweak cpu power and make
the scheduler aware of the time it lost.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 kernel/sched.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3f2e502..247dd51 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -75,6 +75,7 @@
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 #include <asm/mutex.h>
+#include <asm/paravirt.h>
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
@@ -528,6 +529,9 @@ struct rq {
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	u64 prev_irq_time;
 #endif
+#ifdef CONFIG_PARAVIRT
+	u64 prev_steal_time;
+#endif
 
 	/* calc_load related fields */
 	unsigned long calc_load_update;
@@ -1953,6 +1957,18 @@ void account_system_vtime(struct task_struct *curr)
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
+#ifdef CONFIG_PARAVIRT
+static inline u64 steal_ticks(u64 steal)
+{
+	if (unlikely(steal > NSEC_PER_SEC))
+		return div_u64(steal, TICK_NSEC);
+
+	return __iter_div_u64_rem(steal, TICK_NSEC, &steal);
+}
+#endif
+
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
 	s64 irq_delta;
@@ -3929,6 +3945,23 @@ void account_process_tick(struct task_struct *p, int user_tick)
 		return;
 	}
 
+#ifdef CONFIG_PARAVIRT
+	if (static_branch(&paravirt_steal_enabled)) {
+		u64 steal, st = 0;
+
+		steal = paravirt_steal_clock(smp_processor_id());
+		steal -= this_rq()->prev_steal_time;
+
+		st = steal_ticks(steal);
+		this_rq()->prev_steal_time += st * TICK_NSEC;
+
+		if (st) {
+			account_steal_time(st);
+			return;
+		}
+	}
+#endif
+
 	if (user_tick)
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
-- 
1.7.3.4

