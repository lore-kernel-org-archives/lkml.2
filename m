Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab1F2PiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab1F2Ph7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:37:59 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH v3 7/9] KVM-GST: KVM Steal time accounting
Date: Wed, 29 Jun 2011 11:29:46 -0400
Message-Id: <1309361388-30163-8-git-send-email-glommer@redhat.com>
In-Reply-To: <1309361388-30163-1-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch accounts steal time time in kernel/sched.
I kept it from last proposal, because I still see advantages
in it: Doing it here will give us easier access from scheduler
variables such as the cpu rq. The next patch shows an example of
usage for it.

Since functions like account_idle_time() can be called from
multiple places, not only account_process_tick(), steal time
grabbing is repeated in each account function separatedely.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 kernel/sched.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3f2e502..c166863 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -75,6 +75,7 @@
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 #include <asm/mutex.h>
+#include <asm/paravirt.h>
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
@@ -528,6 +529,7 @@ struct rq {
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	u64 prev_irq_time;
 #endif
+	u64 prev_steal_time;
 
 	/* calc_load related fields */
 	unsigned long calc_load_update;
@@ -1953,6 +1955,48 @@ void account_system_vtime(struct task_struct *curr)
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
+static inline u64 steal_ticks(u64 steal)
+{
+	if (unlikely(steal > NSEC_PER_SEC))
+		return steal / TICK_NSEC;
+
+	return __iter_div_u64_rem(steal, TICK_NSEC, &steal);
+}
+
+/*
+ * We have to at flush steal time information every time something else
+ * is accounted. Since the accounting functions are all visible to the rest
+ * of the kernel, it gets tricky to do them in one place. This helper function
+ * helps us.
+ *
+ * When the system is idle, the concept of steal time does not apply. We just
+ * tell the underlying hypervisor that we grabbed the data, but skip steal time
+ * accounting
+ */
+static noinline bool touch_steal_time(int is_idle)
+{
+	u64 steal, st = 0;
+
+	if (static_branch(&paravirt_steal_enabled)) {
+
+		steal = paravirt_steal_clock(smp_processor_id());
+
+		steal -= this_rq()->prev_steal_time;
+
+		st = steal_ticks(steal);
+		this_rq()->prev_steal_time += st * TICK_NSEC;
+
+		if (is_idle || st == 0)
+			return false;
+
+		account_steal_time(st);
+		return true;
+	}
+	return false;
+}
+
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
 	s64 irq_delta;
@@ -3716,6 +3760,9 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t tmp;
 
+	if (touch_steal_time(0))
+		return;
+
 	/* Add user time to process. */
 	p->utime = cputime_add(p->utime, cputime);
 	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
@@ -3802,6 +3849,9 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t *target_cputime64;
 
+	if (touch_steal_time(0))
+		return;
+
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
 		return;
@@ -3839,6 +3889,8 @@ void account_idle_time(cputime_t cputime)
 	cputime64_t cputime64 = cputime_to_cputime64(cputime);
 	struct rq *rq = this_rq();
 
+	touch_steal_time(1);
+
 	if (atomic_read(&rq->nr_iowait) > 0)
 		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
 	else
-- 
1.7.3.4

