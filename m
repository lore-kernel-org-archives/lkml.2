Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1FGATN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 20:19:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:39947 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1FGATM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 20:19:12 -0400
Date: Tue, 7 Jun 2011 00:19:04 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-e9de5210f6a6a8b403035985b5a65e77e7004690@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110606231752.023885847@sbsiddha-MOBL3.sc.intel.com>
References: <20110606231752.023885847@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, stop_machine: Enable __stop_machine() to be called from the cpu online path
Git-Commit-ID: e9de5210f6a6a8b403035985b5a65e77e7004690
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Jun 2011 00:19:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9de5210f6a6a8b403035985b5a65e77e7004690
Gitweb:     http://git.kernel.org/tip/e9de5210f6a6a8b403035985b5a65e77e7004690
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 6 Jun 2011 16:16:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 6 Jun 2011 16:42:09 -0700

x86, stop_machine: Enable __stop_machine() to be called from the cpu online path

Currently stop machine infrastructure can be called only from a cpu that is
online. But for !CONFIG_SMP, we do allow calling __stop_machine() before the
cpu is online.

x86 for example requires stop machine infrastructure in the cpu online path
and currently implements its own stop machine (using stop_one_cpu_nowait())
for MTRR initialization in the cpu online path.

Enhance the __stop_machine() so that it can be called before the cpu
is onlined. This will pave the way for code consolidation and address potential
deadlocks caused by multiple mechanisms of doing system wide rendezvous.

This will also address the behavioral differences of __stop_machine()
between SMP and UP builds.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/20110606231752.023885847@sbsiddha-MOBL3.sc.intel.com
Cc: stable@kernel.org    # v2.6.35+
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/stop_machine.c |   62 +++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e3516b2..c78b0c2 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -136,12 +136,35 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
+/**
+ * __stop_cpus - stop multiple cpus
+ * @cpumask: cpus to stop
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Execute @fn(@arg) on online cpus in @cpumask. If @cpumask is NULL, @fn
+ * is run on all the online cpus including the current cpu (even if it
+ * is not online).
+ * On each target cpu, @fn is run in a process context (except when run on
+ * the cpu that is in the process of coming online, in which case @fn is run
+ * in the same context as __stop_cpus()) with the highest priority
+ * preempting any task on the cpu and monopolizing it.  This function
+ * returns after all executions are complete.
+ */
 int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 {
+	int online = cpu_online(smp_processor_id());
+	int include_this_offline = 0;
 	struct cpu_stop_work *work;
 	struct cpu_stop_done done;
+	unsigned int weight;
 	unsigned int cpu;
 
+	if (!cpumask) {
+		cpumask = cpu_online_mask;
+		include_this_offline = 1;
+	}
+
 	/* initialize works and done */
 	for_each_cpu(cpu, cpumask) {
 		work = &per_cpu(stop_cpus_work, cpu);
@@ -149,7 +172,12 @@ int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 		work->arg = arg;
 		work->done = &done;
 	}
-	cpu_stop_init_done(&done, cpumask_weight(cpumask));
+
+	weight = cpumask_weight(cpumask);
+	if (!online && include_this_offline)
+		weight++;
+
+	cpu_stop_init_done(&done, weight);
 
 	/*
 	 * Disable preemption while queueing to avoid getting
@@ -162,7 +190,20 @@ int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 				    &per_cpu(stop_cpus_work, cpu));
 	preempt_enable();
 
-	wait_for_completion(&done.completion);
+	if (online)
+		wait_for_completion(&done.completion);
+	else {
+		/*
+		 * This cpu is not yet online. If @fn needs to be run on this
+		 * cpu, run it now. Also, we can't afford to sleep here,
+		 * so poll till the work is completed on all the cpu's.
+		 */
+		if (include_this_offline)
+			fn(arg);
+		while (atomic_read(&done.nr_todo) > 1)
+			cpu_relax();
+	}
+
 	return done.executed ? done.ret : -ENOENT;
 }
 
@@ -431,6 +472,7 @@ static int stop_machine_cpu_stop(void *data)
 	struct stop_machine_data *smdata = data;
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int cpu = smp_processor_id(), err = 0;
+	unsigned long flags = 0;
 	bool is_active;
 
 	if (!smdata->active_cpus)
@@ -446,7 +488,7 @@ static int stop_machine_cpu_stop(void *data)
 			curstate = smdata->state;
 			switch (curstate) {
 			case STOPMACHINE_DISABLE_IRQ:
-				local_irq_disable();
+				local_irq_save(flags);
 				hard_irq_disable();
 				break;
 			case STOPMACHINE_RUN:
@@ -460,7 +502,7 @@ static int stop_machine_cpu_stop(void *data)
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 	return err;
 }
 
@@ -470,9 +512,19 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	/* Include the calling cpu that might not be online yet. */
+	if (!cpu_online(smp_processor_id()))
+		smdata.num_threads++;
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
-	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
+
+	if (cpu_online(smp_processor_id()))
+		return stop_cpus(cpu_online_mask, stop_machine_cpu_stop,
+				 &smdata);
+	else
+		return __stop_cpus(NULL, stop_machine_cpu_stop,
+				   &smdata);
 }
 
 int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
