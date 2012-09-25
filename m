Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2IYKgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:36:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35537 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2IYKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:36:37 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] workqueue: Schedule work on non-idle cpu instead of current one
Date: Tue, 25 Sep 2012 16:06:08 +0530
Message-Id: <3232b3192e2e373cc4aaf43359d454c5ad53cddb.1348568074.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1348568074.git.viresh.kumar@linaro.org>
References: <viresh.kumar@linaro.org>
 <cover.1348568074.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1348568074.git.viresh.kumar@linaro.org>
References: <cover.1348568074.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Sep 2012 10:36:33.0913 (UTC) FILETIME=[A2091E90:01CD9B09]
X-MC-Unique: 112092511363601701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8PAavpc025574

Workqueues queues work on current cpu, if the caller haven't passed a preferred
cpu. This may wake up an idle CPU, which is actually not required.

This work can be processed by any CPU and so we must select a non-idle CPU here.
This patch adds in support in workqueue framework to get preferred CPU details
from the scheduler, instead of using current CPU.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/Kconfig   | 11 +++++++++++
 kernel/workqueue.c | 25 ++++++++++++++++++-------
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5944511..da17bd0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1594,6 +1594,17 @@ config HMP_SLOW_CPU_MASK
 	  Specify the cpuids of the slow CPUs in the system as a list string,
 	  e.g. cpuid 0+1 should be specified as 0-1.
 
+config MIGRATE_WQ
+	bool "(EXPERIMENTAL) Migrate Workqueues to non-idle cpu"
+	depends on SMP && EXPERIMENTAL
+	help
+	  Workqueues queues work on current cpu, if the caller haven't passed a
+	  preferred cpu. This may wake up an idle CPU, which is actually not
+	  required. This work can be processed by any CPU and so we must select
+	  a non-idle CPU here.  This patch adds in support in workqueue
+	  framework to get preferred CPU details from the scheduler, instead of
+	  using current CPU.
+
 config HAVE_ARM_SCU
 	bool
 	help
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 692a55b..fd8df4a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -456,6 +456,16 @@ static inline void debug_work_activate(struct work_struct *work) { }
 static inline void debug_work_deactivate(struct work_struct *work) { }
 #endif
 
+/* This enables migration of a work to a non-IDLE cpu instead of current cpu */
+#ifdef CONFIG_MIGRATE_WQ
+static int wq_select_cpu(void)
+{
+	return sched_select_cpu(SD_NUMA, -1);
+}
+#else
+#define wq_select_cpu()		smp_processor_id()
+#endif
+
 /* Serializes the accesses to the list of workqueues. */
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
@@ -995,7 +1005,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		struct global_cwq *last_gcwq;
 
 		if (unlikely(cpu == WORK_CPU_UNBOUND))
-			cpu = raw_smp_processor_id();
+			cpu = wq_select_cpu();
 
 		/*
 		 * It's multi cpu.  If @wq is non-reentrant and @work
@@ -1066,8 +1076,9 @@ int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
 	int ret;
 
-	ret = queue_work_on(get_cpu(), wq, work);
-	put_cpu();
+	preempt_disable();
+	ret = queue_work_on(wq_select_cpu(), wq, work);
+	preempt_enable();
 
 	return ret;
 }
@@ -1102,7 +1113,7 @@ static void delayed_work_timer_fn(unsigned long __data)
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
 
-	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
+	__queue_work(wq_select_cpu(), cwq->wq, &dwork->work);
 }
 
 /**
@@ -1158,7 +1169,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
 				lcpu = gcwq->cpu;
 			else
-				lcpu = raw_smp_processor_id();
+				lcpu = wq_select_cpu();
 		} else
 			lcpu = WORK_CPU_UNBOUND;
 
@@ -2823,8 +2834,8 @@ EXPORT_SYMBOL_GPL(cancel_work_sync);
 static inline void __flush_delayed_work(struct delayed_work *dwork)
 {
 	if (del_timer_sync(&dwork->timer))
-		__queue_work(raw_smp_processor_id(),
-			     get_work_cwq(&dwork->work)->wq, &dwork->work);
+		__queue_work(wq_select_cpu(), get_work_cwq(&dwork->work)->wq,
+			     &dwork->work);
 }
 
 /**
-- 
1.7.12.rc2.18.g61b472e


