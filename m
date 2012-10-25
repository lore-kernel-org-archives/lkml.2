Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab2JYAxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:53:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44516 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab2JYAwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:52:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/5] vtime: Provide an irq safe version of vtime_account_system()
Date: Thu, 25 Oct 2012 02:51:50 +0200
Message-Id: <1351126313-17804-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351126313-17804-1-git-send-email-fweisbec@gmail.com>
References: <1351126313-17804-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vtime_account_system() currently has only one caller with
vtime_account() that is irq safe.

Now we are going to call it from other places like kvm, so
let's provide an irqsafe version.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/s390/kernel/vtime.c |    4 ++++
 include/linux/vtime.h    |    2 ++
 kernel/sched/cputime.c   |    9 +++++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 7903344..80d1dbc 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -140,6 +140,10 @@ void vtime_account(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 
+void vtime_account_system(struct task_struct *tsk)
+__attribute__((alias("vtime_account")));
+EXPORT_SYMBOL_GPL(vtime_account_system);
+
 void __kprobes vtime_stop_cpu(void)
 {
 	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 7199c24..57f290e 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -6,9 +6,11 @@ struct task_struct;
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void vtime_task_switch(struct task_struct *prev);
 extern void vtime_account_system(struct task_struct *tsk);
+extern void vtime_account_system_irqsafe(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
 #else
 static inline void vtime_task_switch(struct task_struct *prev) { }
+static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
 #endif
 
 #if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 81b763b..3ccbea0 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -433,6 +433,15 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	*st = cputime.stime;
 }
 
+void vtime_account_system_irqsafe(struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	vtime_account_system(tsk);
+	local_irq_restore(flags);
+}
+
 /*
  * Archs that account the whole time spent in the idle task
  * (outside irq) as idle time can rely on this and just implement
-- 
1.7.5.4

