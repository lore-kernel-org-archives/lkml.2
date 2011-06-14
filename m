Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1FNRHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:07:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1FNRHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=t7zeryGHqx0WopCWO9fNvW/5ptCAdWf0IW0CFEq4ZHJ5P/BCJhl+JaV9NzMux0qTGP
         WEyi8PoVCgQn7skpFewIkN8f/pITmjFla3t9Lsw3QTR9X1Ko/DGqZpYsz8YrfCeK4Ykv
         673ByIpvaSOLChNebchqE0CXIaNhP/oVL188Q=
From: Tejun Heo <tj@kernel.org>
To: x86@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] stop_machine: implement stop_machine_from_offline_cpu()
Date: Tue, 14 Jun 2011 19:06:58 +0200
Message-Id: <1308071218-5912-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1308071218-5912-1-git-send-email-tj@kernel.org>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, mtrr wants stop_machine functionality while a CPU is being
brought up.  As stop_machine() requires the calling CPU to be online,
mtrr implements its own stop_machine using stop_one_cpu() on each
online CPU.  This doesn't only unnecessarily duplicate complex logic
but also introduces a possibility of deadlock when it races against
the generic stop_machine().

This patch implements stop_machine_from_offline_cpu() to serve such
use cases.  Its functionality is basically the same to stop_machine();
however, it should be called from a CPU which isn't online and doesn't
depend on working scheduling on the calling CPU.

This is achieved by using busy loops for synchronization and
open-coding stop_cpus queueing and waiting with direct invocation of
fn() for local CPU inbetween.

This is inspired from Suresh's patch to implement similar
functionality into stop_machine().

 http://article.gmane.org/gmane.linux.kernel/1154384

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/stop_machine.h |   14 ++++++++-
 kernel/stop_machine.c        |   61 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 4f1a73c..c78ef6a 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -99,18 +99,28 @@ static inline int try_stop_cpus(const struct cpumask *cpumask,
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 
 int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
+int stop_machine_from_offline_cpu(int (*fn)(void *), void *data,
+				  const struct cpumask *cpus);
 
 #else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
 
 static inline int stop_machine(int (*fn)(void *), void *data,
 			       const struct cpumask *cpus)
 {
+	unsigned long flags;
 	int ret;
-	local_irq_disable();
+
+	local_irq_save(flags);
 	ret = fn(data);
-	local_irq_enable();
+	local_irq_restore(flags);
 	return ret;
 }
 
+static inline int stop_machine_from_offline_cpu(int (*fn)(void *), void *data,
+						const struct cpumask *cpus)
+{
+	return stop_machine(fn, data, cpus);
+}
+
 #endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 198973f..ff648d9 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -439,8 +439,15 @@ static int stop_machine_cpu_stop(void *data)
 	struct stop_machine_data *smdata = data;
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int cpu = smp_processor_id(), err = 0;
+	unsigned long flags;
 	bool is_active;
 
+	/*
+	 * When called from stop_machine_from_offline_cpu(), irq might
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
 
@@ -511,4 +518,56 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 }
 EXPORT_SYMBOL_GPL(stop_machine);
 
+/**
+ * stop_machine_from_offline_cpu - stop_machine() from offline CPU
+ * @fn: the function to run
+ * @data: the data ptr for the @fn()
+ * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
+ *
+ * This is identical to stop_machine() but can be called from a CPU which
+ * isn't online.  The local CPU is in the process of hotplug (so no other
+ * CPU hotplug can start) and not marked online and doesn't have enough
+ * context to sleep.
+ *
+ * This function provides stop_machine() functionality for such state by
+ * using busy-wait for synchronization and executing @fn directly for local
+ * CPU.
+ *
+ * CONTEXT:
+ * Local CPU is offline.  Temporarily stops all online CPUs.
+ *
+ * RETURNS:
+ * 0 if all executions of @fn returned 0, any non zero return value if any
+ * returned non zero.
+ */
+int stop_machine_from_offline_cpu(int (*fn)(void *), void *data,
+				  const struct cpumask *cpus)
+{
+	struct stop_machine_data smdata = { .fn = fn, .data = data,
+					    .active_cpus = cpus };
+	struct cpu_stop_done done;
+	int ret;
+
+	/* Local CPU must be offline and CPU hotplug in progress. */
+	BUG_ON(cpu_online(raw_smp_processor_id()));
+	smdata.num_threads = num_online_cpus() + 1;	/* +1 for local */
+
+	/* No proper task established and can't sleep - busy wait for lock. */
+	while (!mutex_trylock(&stop_cpus_mutex))
+		cpu_relax();
+
+	/* Schedule work on other CPUs and execute directly for local CPU */
+	set_state(&smdata, STOPMACHINE_PREPARE);
+	cpu_stop_init_done(&done, num_online_cpus());
+	stop_cpus_queue(cpu_online_mask, stop_machine_cpu_stop, &smdata, &done);
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
-- 
1.7.5.2

