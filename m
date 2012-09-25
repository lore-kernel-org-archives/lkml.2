Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2IYPGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:06:34 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48805 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2IYPG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:06:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/6] cputime: Use a proper subsystem naming for vtime related APIs
Date: Tue, 25 Sep 2012 17:06:02 +0200
Message-Id: <1348585567-2925-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
References: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a naming based on vtime as a prefix for virtual based
cputime accounting APIs:

- account_system_vtime() -> vtime_account()
- account_switch_vtime() -> vtime_task_switch()

It makes it easier to allow for further declension such
as vtime_account_system(), vtime_account_idle(), ... if we
want to find out the context we account to from generic code.

This also make it better to know on which subsystem these APIs
refer to.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/ia64/kernel/time.c     |    6 +++---
 arch/powerpc/kernel/time.c  |   10 +++++-----
 arch/s390/kernel/vtime.c    |    6 +++---
 include/linux/hardirq.h     |    8 ++++----
 include/linux/kernel_stat.h |    4 ++--
 include/linux/kvm_host.h    |    4 ++--
 kernel/sched/core.c         |    2 +-
 kernel/sched/cputime.c      |    8 ++++----
 kernel/softirq.c            |    6 +++---
 9 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 6247197..16bb6ed 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -88,7 +88,7 @@ extern cputime_t cycle_to_cputime(u64 cyc);
  * accumulated times to the current process, and to prepare accounting on
  * the next process.
  */
-void account_switch_vtime(struct task_struct *prev)
+void vtime_task_switch(struct task_struct *prev)
 {
 	struct thread_info *pi = task_thread_info(prev);
 	struct thread_info *ni = task_thread_info(current);
@@ -116,7 +116,7 @@ void account_switch_vtime(struct task_struct *prev)
  * Account time for a transition between system, hard irq or soft irq state.
  * Note that this function is called with interrupts enabled.
  */
-void account_system_vtime(struct task_struct *tsk)
+void vtime_account(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
 	unsigned long flags;
@@ -138,7 +138,7 @@ void account_system_vtime(struct task_struct *tsk)
 
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(account_system_vtime);
+EXPORT_SYMBOL_GPL(vtime_account);
 
 /*
  * Called from the timer interrupt handler to charge accumulated user time
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 49da7f0..39899d7 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -291,7 +291,7 @@ static inline u64 calculate_stolen_time(u64 stop_tb)
  * Account time for a transition between system, hard irq
  * or soft irq state.
  */
-void account_system_vtime(struct task_struct *tsk)
+void vtime_account(struct task_struct *tsk)
 {
 	u64 now, nowscaled, delta, deltascaled;
 	unsigned long flags;
@@ -343,14 +343,14 @@ void account_system_vtime(struct task_struct *tsk)
 	}
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(account_system_vtime);
+EXPORT_SYMBOL_GPL(vtime_account);
 
 /*
  * Transfer the user and system times accumulated in the paca
  * by the exception entry and exit code to the generic process
  * user and system time records.
  * Must be called with interrupts disabled.
- * Assumes that account_system_vtime() has been called recently
+ * Assumes that vtime_account() has been called recently
  * (i.e. since the last entry from usermode) so that
  * get_paca()->user_time_scaled is up to date.
  */
@@ -366,9 +366,9 @@ void account_process_tick(struct task_struct *tsk, int user_tick)
 	account_user_time(tsk, utime, utimescaled);
 }
 
-void account_switch_vtime(struct task_struct *prev)
+void vtime_task_switch(struct task_struct *prev)
 {
-	account_system_vtime(prev);
+	vtime_account(prev);
 	account_process_tick(prev, 0);
 }
 
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 449ac22..cb5093c 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -99,7 +99,7 @@ static int do_account_vtime(struct task_struct *tsk, int hardirq_offset)
 	return virt_timer_forward(user + system);
 }
 
-void account_switch_vtime(struct task_struct *prev)
+void vtime_task_switch(struct task_struct *prev)
 {
 	struct thread_info *ti;
 
@@ -122,7 +122,7 @@ void account_process_tick(struct task_struct *tsk, int user_tick)
  * Update process times based on virtual cpu times stored by entry.S
  * to the lowcore fields user_timer, system_timer & steal_clock.
  */
-void account_system_vtime(struct task_struct *tsk)
+void vtime_account(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
 	u64 timer, system;
@@ -138,7 +138,7 @@ void account_system_vtime(struct task_struct *tsk)
 
 	virt_timer_forward(system);
 }
-EXPORT_SYMBOL_GPL(account_system_vtime);
+EXPORT_SYMBOL_GPL(vtime_account);
 
 void __kprobes vtime_stop_cpu(void)
 {
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 305f23c..cab3da3 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -132,11 +132,11 @@ extern void synchronize_irq(unsigned int irq);
 struct task_struct;
 
 #if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
-static inline void account_system_vtime(struct task_struct *tsk)
+static inline void vtime_account(struct task_struct *tsk)
 {
 }
 #else
-extern void account_system_vtime(struct task_struct *tsk);
+extern void vtime_account(struct task_struct *tsk);
 #endif
 
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
@@ -162,7 +162,7 @@ extern void rcu_nmi_exit(void);
  */
 #define __irq_enter()					\
 	do {						\
-		account_system_vtime(current);		\
+		vtime_account(current);		\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
 	} while (0)
@@ -178,7 +178,7 @@ extern void irq_enter(void);
 #define __irq_exit()					\
 	do {						\
 		trace_hardirq_exit();			\
-		account_system_vtime(current);		\
+		vtime_account(current);		\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
 	} while (0)
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index bbe5d15..ca0944b 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -131,9 +131,9 @@ extern void account_steal_ticks(unsigned long ticks);
 extern void account_idle_ticks(unsigned long ticks);
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_switch_vtime(struct task_struct *prev);
+extern void vtime_task_switch(struct task_struct *prev);
 #else
-static inline void account_switch_vtime(struct task_struct *prev) { }
+static inline void vtime_task_switch(struct task_struct *prev) { }
 #endif
 
 #endif /* _LINUX_KERNEL_STAT_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b70b48b..8a59e0a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -685,7 +685,7 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 static inline void kvm_guest_enter(void)
 {
 	BUG_ON(preemptible());
-	account_system_vtime(current);
+	vtime_account(current);
 	current->flags |= PF_VCPU;
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
@@ -699,7 +699,7 @@ static inline void kvm_guest_enter(void)
 
 static inline void kvm_guest_exit(void)
 {
-	account_system_vtime(current);
+	vtime_account(current);
 	current->flags &= ~PF_VCPU;
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ba144b1..21e4dcf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1764,7 +1764,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 *		Manfred Spraul <manfred@colorfullife.com>
 	 */
 	prev_state = prev->state;
-	account_switch_vtime(prev);
+	vtime_task_switch(prev);
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(prev, current);
 	finish_lock_switch(rq, prev);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 372692b..53f5b12 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -10,11 +10,11 @@
 
 /*
  * There are no locks covering percpu hardirq/softirq time.
- * They are only modified in account_system_vtime, on corresponding CPU
+ * They are only modified in vtime_account, on corresponding CPU
  * with interrupts disabled. So, writes are safe.
  * They are read and saved off onto struct rq in update_rq_clock().
  * This may result in other CPU reading this CPU's irq time and can
- * race with irq/account_system_vtime on this CPU. We would either get old
+ * race with irq/vtime_account on this CPU. We would either get old
  * or new value with a side effect of accounting a slice of irq time to wrong
  * task when irq is in progress while we read rq->clock. That is a worthy
  * compromise in place of having locks on each irq in account_system_time.
@@ -43,7 +43,7 @@ DEFINE_PER_CPU(seqcount_t, irq_time_seq);
  * Called before incrementing preempt_count on {soft,}irq_enter
  * and before decrementing preempt_count on {soft,}irq_exit.
  */
-void account_system_vtime(struct task_struct *curr)
+void vtime_account(struct task_struct *curr)
 {
 	unsigned long flags;
 	s64 delta;
@@ -73,7 +73,7 @@ void account_system_vtime(struct task_struct *curr)
 	irq_time_write_end();
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(account_system_vtime);
+EXPORT_SYMBOL_GPL(vtime_account);
 
 static int irqtime_account_hi_update(void)
 {
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b73e681..d55e315 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -220,7 +220,7 @@ asmlinkage void __do_softirq(void)
 	current->flags &= ~PF_MEMALLOC;
 
 	pending = local_softirq_pending();
-	account_system_vtime(current);
+	vtime_account(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
@@ -271,7 +271,7 @@ restart:
 
 	lockdep_softirq_exit();
 
-	account_system_vtime(current);
+	vtime_account(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
@@ -340,7 +340,7 @@ static inline void invoke_softirq(void)
  */
 void irq_exit(void)
 {
-	account_system_vtime(current);
+	vtime_account(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
-- 
1.7.5.4

