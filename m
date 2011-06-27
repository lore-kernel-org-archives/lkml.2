Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1F0XRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:17:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:60275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab1F0XQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:16:52 -0400
Date: Mon, 27 Jun 2011 23:16:32 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-f740e6cd0cb5e7468e46831aeb4d9c30e03d5ebc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tj@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <20110623182056.982526827@sbsiddha-MOBL3.sc.intel.com>
References: <20110623182056.982526827@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mtrr] stop_machine: implement stop_machine_from_inactive_cpu()
Git-Commit-ID: f740e6cd0cb5e7468e46831aeb4d9c30e03d5ebc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 27 Jun 2011 23:16:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f740e6cd0cb5e7468e46831aeb4d9c30e03d5ebc
Gitweb:     http://git.kernel.org/tip/f740e6cd0cb5e7468e46831aeb4d9c30e03d5ebc
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 23 Jun 2011 11:19:28 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 27 Jun 2011 15:17:08 -0700

stop_machine: implement stop_machine_from_inactive_cpu()

Currently, mtrr wants stop_machine functionality while a CPU is being
brought up.  As stop_machine() requires the calling CPU to be active,
mtrr implements its own stop_machine using stop_one_cpu() on each
online CPU.  This doesn't only unnecessarily duplicate complex logic
but also introduces a possibility of deadlock when it races against
the generic stop_machine().

This patch implements stop_machine_from_inactive_cpu() to serve such
use cases.  Its functionality is basically the same as stop_machine();
however, it should be called from a CPU which isn't active and doesn't
depend on working scheduling on the calling CPU.

This is achieved by using busy loops for synchronization and
open-coding stop_cpus queuing and waiting with direct invocation of
fn() for local CPU inbetween.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20110623182056.982526827@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/stop_machine.h |   14 ++++++++-
 kernel/stop_machine.c        |   62 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 14d3524..e0f2da2 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -126,15 +126,19 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
  */
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
+int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
+				   const struct cpumask *cpus);
+
 #else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
 
 static inline int __stop_machine(int (*fn)(void *), void *data,
 				 const struct cpumask *cpus)
 {
+	unsigned long flags;
 	int ret;
-	local_irq_disable();
+	local_irq_save(flags);
 	ret = fn(data);
-	local_irq_enable();
+	local_irq_restore(flags);
 	return ret;
 }
 
@@ -144,5 +148,11 @@ static inline int stop_machine(int (*fn)(void *), void *data,
 	return __stop_machine(fn, data, cpus);
 }
 
+static inline int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
+						 const struct cpumask *cpus)
+{
+	return __stop_machine(fn, data, cpus);
+}
+
 #endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 4c89ee9..e8f05b1 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -439,8 +439,15 @@ static int stop_machine_cpu_stop(void *data)
 	struct stop_machine_data *smdata = data;
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int cpu = smp_processor_id(), err = 0;
+	unsigned long flags;
 	bool is_active;
 
+	/*
+	 * When called from stop_machine_from_inactive_cpu(), irq might
+	 * already be disabled.  Save the state and restore it on exit.
+	 */
+	local_save_flags(flags);
+
 	if (!smdata->active_cpus)
 		is_active = cpu == cpumask_first(cpu_online_mask);
 	else
@@ -468,7 +475,7 @@ static int stop_machine_cpu_stop(void *data)
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 	return err;
 }
 
@@ -495,4 +502,57 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 }
 EXPORT_SYMBOL_GPL(stop_machine);
 
+/**
+ * stop_machine_from_inactive_cpu - stop_machine() from inactive CPU
+ * @fn: the function to run
+ * @data: the data ptr for the @fn()
+ * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
+ *
+ * This is identical to stop_machine() but can be called from a CPU which
+ * is not active.  The local CPU is in the process of hotplug (so no other
+ * CPU hotplug can start) and not marked active and doesn't have enough
+ * context to sleep.
+ *
+ * This function provides stop_machine() functionality for such state by
+ * using busy-wait for synchronization and executing @fn directly for local
+ * CPU.
+ *
+ * CONTEXT:
+ * Local CPU is inactive.  Temporarily stops all active CPUs.
+ *
+ * RETURNS:
+ * 0 if all executions of @fn returned 0, any non zero return value if any
+ * returned non zero.
+ */
+int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
+				  const struct cpumask *cpus)
+{
+	struct stop_machine_data smdata = { .fn = fn, .data = data,
+					    .active_cpus = cpus };
+	struct cpu_stop_done done;
+	int ret;
+
+	/* Local CPU must be inactive and CPU hotplug in progress. */
+	BUG_ON(cpu_active(raw_smp_processor_id()));
+	smdata.num_threads = num_active_cpus() + 1;	/* +1 for local */
+
+	/* No proper task established and can't sleep - busy wait for lock. */
+	while (!mutex_trylock(&stop_cpus_mutex))
+		cpu_relax();
+
+	/* Schedule work on other CPUs and execute directly for local CPU */
+	set_state(&smdata, STOPMACHINE_PREPARE);
+	cpu_stop_init_done(&done, num_active_cpus());
+	queue_stop_cpus_work(cpu_active_mask, stop_machine_cpu_stop, &smdata,
+			     &done);
+	ret = stop_machine_cpu_stop(&smdata);
+
+	/* Busy wait for completion. */
+	while (!completion_done(&done.completion))
+		cpu_relax();
+
+	mutex_unlock(&stop_cpus_mutex);
+	return ret ?: done.ret;
+}
+
 #endif	/* CONFIG_STOP_MACHINE */
