Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2APNyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:54:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33637 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2APNyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:54:23 -0500
Subject: [PATCH] sched: remove task-sched-info dynamic disabler
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 16 Jan 2012 17:54:18 +0400
Message-ID: <20120116135418.594.83083.stgit@zurg>
In-Reply-To: <20120114163051.23946.25895.stgit@zurg>
References: <20120114163051.23946.25895.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently per-task sched-info statistics can be disabled if delay-accounting is
disabled by boot option. There is no reason for it, sched-info is built-in
into task-struct, and its collecting does not add any extra atomic operations.
In other combinations it either not compiled or cannot be disabled.

This patch removes sched_info_on() and fixes all its users.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 arch/x86/kvm/cpuid.c  |    6 ++----
 arch/x86/kvm/x86.c    |    4 ----
 include/linux/sched.h |   12 ------------
 kernel/sched/core.c   |    3 +--
 kernel/sched/stats.h  |   18 +++++-------------
 5 files changed, 8 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 89b02bf..12870d8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -408,10 +408,8 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
-			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
-
-		if (sched_info_on())
-			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
+			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+			     (1 << KVM_FEATURE_STEAL_TIME);
 
 		entry->ebx = 0;
 		entry->ecx = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 14d6cad..a60645c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1579,10 +1579,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			return 1;
 		break;
 	case MSR_KVM_STEAL_TIME:
-
-		if (unlikely(!sched_info_on()))
-			return 1;
-
 		if (data & KVM_STEAL_RESERVED_MASK)
 			return 1;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dd5bf78..eb8842e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -778,18 +778,6 @@ struct task_delay_info {
 };
 #endif	/* CONFIG_TASK_DELAY_ACCT */
 
-static inline int sched_info_on(void)
-{
-#if IS_ENABLED(CONFIG_SCHEDSTATS) || IS_ENABLED(CONFIG_KVM)
-	return 1;
-#elif defined(CONFIG_TASK_DELAY_ACCT)
-	extern int delayacct_on;
-	return delayacct_on;
-#else
-	return 0;
-#endif
-}
-
 enum cpu_idle_type {
 	CPU_IDLE,
 	CPU_NOT_IDLE,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0c59dcb..73acf77 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1759,8 +1759,7 @@ void sched_fork(struct task_struct *p)
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 #ifdef CONFIG_TASK_SCHED_INFO
-	if (likely(sched_info_on()))
-		memset(&p->sched_info, 0, sizeof(p->sched_info));
+	memset(&p->sched_info, 0, sizeof(p->sched_info));
 #endif
 #if defined(CONFIG_SMP)
 	p->on_cpu = 0;
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 2322b86..e6363ed 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -63,9 +63,8 @@ static inline void sched_info_dequeued(struct task_struct *t)
 {
 	unsigned long long now = task_rq(t)->clock, delta = 0;
 
-	if (unlikely(sched_info_on()))
-		if (t->sched_info.last_queued)
-			delta = now - t->sched_info.last_queued;
+	if (t->sched_info.last_queued)
+		delta = now - t->sched_info.last_queued;
 	sched_info_reset_dequeued(t);
 	t->sched_info.run_delay += delta;
 
@@ -98,9 +97,8 @@ static void sched_info_arrive(struct task_struct *t)
  */
 static inline void sched_info_queued(struct task_struct *t)
 {
-	if (unlikely(sched_info_on()))
-		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = task_rq(t)->clock;
+	if (!t->sched_info.last_queued)
+		t->sched_info.last_queued = task_rq(t)->clock;
 }
 
 /*
@@ -127,7 +125,7 @@ static inline void sched_info_depart(struct task_struct *t)
  * the idle task.)  We are only called when prev != next.
  */
 static inline void
-__sched_info_switch(struct task_struct *prev, struct task_struct *next)
+sched_info_switch(struct task_struct *prev, struct task_struct *next)
 {
 	struct rq *rq = task_rq(prev);
 
@@ -142,12 +140,6 @@ __sched_info_switch(struct task_struct *prev, struct task_struct *next)
 	if (next != rq->idle)
 		sched_info_arrive(next);
 }
-static inline void
-sched_info_switch(struct task_struct *prev, struct task_struct *next)
-{
-	if (unlikely(sched_info_on()))
-		__sched_info_switch(prev, next);
-}
 #else
 #define sched_info_queued(t)			do { } while (0)
 #define sched_info_reset_dequeued(t)	do { } while (0)

