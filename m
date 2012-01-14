Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2ANQYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 11:24:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33600 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2ANQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 11:24:21 -0500
Subject: [PATCH] kvm: remove dependence on delay-accounting
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Sat, 14 Jan 2012 20:24:13 +0400
Message-ID: <20120114162413.15761.7341.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM selects delay-accounting only to get sched-info for steal-time accounting.
Meanwhile delay-accounting can be disabled by boot option. This is ridiculous.

This patch adds internal boolean option CONFIG_TASK_SCHED_INFO to enable only
task->sched_info and its collecting inside scheduler.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 arch/x86/kvm/Kconfig  |    5 +----
 include/linux/sched.h |    6 ++----
 init/Kconfig          |    7 +++++++
 kernel/sched/core.c   |    2 +-
 kernel/sched/stats.h  |    4 ++--
 lib/Kconfig.debug     |    1 +
 6 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 1a7fe86..2e27d8c 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -22,8 +22,6 @@ config KVM
 	depends on HAVE_KVM
 	# for device assignment:
 	depends on PCI
-	# for TASKSTATS/TASK_DELAY_ACCT:
-	depends on NET
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
@@ -33,8 +31,7 @@ config KVM
 	select KVM_ASYNC_PF
 	select USER_RETURN_NOTIFIER
 	select KVM_MMIO
-	select TASKSTATS
-	select TASK_DELAY_ACCT
+	select TAKS_SCHED_INFO
 	select PERF_EVENTS
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 868cb83..dd5bf78 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -734,7 +734,6 @@ extern struct user_struct root_user;
 
 struct backing_dev_info;
 
-#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 struct sched_info {
 	/* cumulative counters */
 	unsigned long pcount;	      /* # of times run on this cpu */
@@ -744,7 +743,6 @@ struct sched_info {
 	unsigned long long last_arrival,/* when we last ran on a cpu */
 			   last_queued;	/* when we were last queued to run */
 };
-#endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
 
 #ifdef CONFIG_TASK_DELAY_ACCT
 struct task_delay_info {
@@ -782,7 +780,7 @@ struct task_delay_info {
 
 static inline int sched_info_on(void)
 {
-#ifdef CONFIG_SCHEDSTATS
+#if IS_ENABLED(CONFIG_SCHEDSTATS) || IS_ENABLED(CONFIG_KVM)
 	return 1;
 #elif defined(CONFIG_TASK_DELAY_ACCT)
 	extern int delayacct_on;
@@ -1285,7 +1283,7 @@ struct task_struct {
 	struct rt_mutex *rcu_boost_mutex;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
-#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+#ifdef CONFIG_TASK_SCHED_INFO
 	struct sched_info sched_info;
 #endif
 
diff --git a/init/Kconfig b/init/Kconfig
index 6ac2236..ee0dd4b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -318,6 +318,7 @@ config TASKSTATS
 config TASK_DELAY_ACCT
 	bool "Enable per-task delay accounting (EXPERIMENTAL)"
 	depends on TASKSTATS
+	select TASK_SCHED_INFO
 	help
 	  Collect information on time spent by a task waiting for system
 	  resources like cpu, synchronous block I/O completion and swapping
@@ -860,6 +861,12 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
+#
+# collect per-task scheduler statistics
+#
+config TASK_SCHED_INFO
+	bool
+
 config MM_OWNER
 	bool
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fd7b25e..bf5616d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1758,7 +1758,7 @@ void sched_fork(struct task_struct *p)
 	set_task_cpu(p, cpu);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
-#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+#ifdef CONFIG_TASK_SCHED_INFO
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
 #endif
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 2ef90a5..2322b86 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -47,7 +47,7 @@ rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 # define schedstat_set(var, val)	do { } while (0)
 #endif
 
-#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+#ifdef CONFIG_TASK_SCHED_INFO
 static inline void sched_info_reset_dequeued(struct task_struct *t)
 {
 	t->sched_info.last_queued = 0;
@@ -153,7 +153,7 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
 #define sched_info_reset_dequeued(t)	do { } while (0)
 #define sched_info_dequeued(t)			do { } while (0)
 #define sched_info_switch(t, next)		do { } while (0)
-#endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
+#endif /* CONFIG_TASK_SCHED_INFO */
 
 /*
  * The following are functions that support scheduler-internal time accounting.
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 82928f5..f2e9ee3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -290,6 +290,7 @@ config SCHED_DEBUG
 config SCHEDSTATS
 	bool "Collect scheduler statistics"
 	depends on DEBUG_KERNEL && PROC_FS
+	select TASK_SCHED_INFO
 	help
 	  If you say Y here, additional code will be inserted into the
 	  scheduler and related routines to collect statistics about

