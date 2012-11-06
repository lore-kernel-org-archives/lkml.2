Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2KFKju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:39:50 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41232 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2KFKjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:39:05 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: Arvind.Chauhan@arm.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 1/4] sched: Create sched_select_cpu() to give preferred CPU for power saving
Date: Tue,  6 Nov 2012 16:08:43 +0530
Message-Id: <351f8e3a6e9d78f584dc10d9e0ecc1505f73f7d9.1352196505.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1352196505.git.viresh.kumar@linaro.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1352196505.git.viresh.kumar@linaro.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 06 Nov 2012 10:38:53.0124 (UTC) FILETIME=[EA5C8840:01CDBC0A]
X-MC-Unique: 112110610385602601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qA6Adqi2014387

In order to save power, it would be useful to schedule work onto non-IDLE cpus
instead of waking up an IDLE one.

To achieve this, we need scheduler to guide kernel frameworks (like: timers &
workqueues) on which is the most preferred CPU that must be used for these
tasks.

This routine returns the preferred cpu which is non-idle. It accepts a bitwise
OR of SD_* flags present in linux/sched.h. If the local CPU isn't idle, it is
returned back. If it is idle, then we must look for another CPU which have all
the flags passed as argument as set. Also, as this activity is part of load
balancing only, SD_LOAD_BALANCE must also be set for selected domain.

This patch reuses the code from get_nohz_timer_target() routine, which had
similar implementation. get_nohz_timer_target() is also modified to use
sched_select_cpu() now.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/sched.h | 16 ++++++++++--
 kernel/sched/core.c   | 69 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..24f546d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -232,14 +232,26 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
 
-#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
+#ifdef CONFIG_SMP
+extern int sched_select_cpu(unsigned int sd_flags);
+
+#ifdef CONFIG_NO_HZ
 extern void nohz_balance_enter_idle(int cpu);
 extern void set_cpu_sd_state_idle(void);
-extern int get_nohz_timer_target(void);
+/*
+ * In the semi idle case, use the nearest busy cpu for migrating timers
+ * from an idle cpu.  This is good for power-savings.
+ *
+ * We don't do similar optimization for completely idle system, as
+ * selecting an idle cpu will add more delays to the timers than intended
+ * (as that cpu's timer base may not be uptodate wrt jiffies etc).
+ */
+#define get_nohz_timer_target() sched_select_cpu(0)
 #else
 static inline void nohz_balance_enter_idle(int cpu) { }
 static inline void set_cpu_sd_state_idle(void) { }
 #endif
+#endif /* CONFIG_SMP */
 
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..cf1a420 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -542,33 +542,6 @@ void resched_cpu(int cpu)
 
 #ifdef CONFIG_NO_HZ
 /*
- * In the semi idle case, use the nearest busy cpu for migrating timers
- * from an idle cpu.  This is good for power-savings.
- *
- * We don't do similar optimization for completely idle system, as
- * selecting an idle cpu will add more delays to the timers than intended
- * (as that cpu's timer base may not be uptodate wrt jiffies etc).
- */
-int get_nohz_timer_target(void)
-{
-	int cpu = smp_processor_id();
-	int i;
-	struct sched_domain *sd;
-
-	rcu_read_lock();
-	for_each_domain(cpu, sd) {
-		for_each_cpu(i, sched_domain_span(sd)) {
-			if (!idle_cpu(i)) {
-				cpu = i;
-				goto unlock;
-			}
-		}
-	}
-unlock:
-	rcu_read_unlock();
-	return cpu;
-}
-/*
  * When add_timer_on() enqueues a timer into the timer wheel of an
  * idle CPU then this timer might expire before the next timer event
  * which is scheduled to wake up that CPU. In case of a completely
@@ -639,6 +612,48 @@ void sched_avg_update(struct rq *rq)
 	}
 }
 
+/*
+ * This routine returns the preferred cpu which is non-idle. It accepts a
+ * bitwise OR of SD_* flags present in linux/sched.h. If the local CPU isn't
+ * idle, it is returned back. If it is idle, then we must look for another CPU
+ * which have all the flags passed as argument as set. Also, as this activity is
+ * part of load balancing only, SD_LOAD_BALANCE must also be set for selected
+ * domain.
+ */
+int sched_select_cpu(unsigned int sd_flags)
+{
+	struct sched_domain *sd;
+	int cpu = smp_processor_id();
+	int i;
+
+	/* If Current cpu isn't idle, don't migrate anything */
+	if (!idle_cpu(cpu))
+		return cpu;
+
+	/* Add SD_LOAD_BALANCE to flags */
+	sd_flags |= SD_LOAD_BALANCE;
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd) {
+		/*
+		 * If sd doesnt' have both sd_flags and SD_LOAD_BALANCE set,
+		 * skip sd.
+		 */
+		if ((sd->flags & sd_flags) != sd_flags)
+			continue;
+
+		for_each_cpu(i, sched_domain_span(sd)) {
+			if (!idle_cpu(i)) {
+				cpu = i;
+				goto unlock;
+			}
+		}
+	}
+unlock:
+	rcu_read_unlock();
+	return cpu;
+}
+
 #else /* !CONFIG_SMP */
 void resched_task(struct task_struct *p)
 {
-- 
1.7.12.rc2.18.g61b472e


