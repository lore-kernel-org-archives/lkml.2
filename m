Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1FNRKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:10:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53010 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1FNRKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:10:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=OOLVZ6L9o1Og6vqOl7pgcuL/n9L4J/uCcHdcGKiq9ZGuGwfMrxo4AXov7mQrnSSghA
         ALA371QOxu3a3M1Ls+ZRQV4RcwRHzcbnCqbMBnGoUVmRXD7VjW6dzjGiJpffJXcAjKpJ
         kOfWuM7GeghB/dkaNbQBMrQ08Idk5ejvSNZIc=
From: Tejun Heo <tj@kernel.org>
To: x86@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] stop_machine: kill __stop_machine()
Date: Tue, 14 Jun 2011 19:06:56 +0200
Message-Id: <1308071218-5912-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1308071218-5912-1-git-send-email-tj@kernel.org>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stop_machine() is different from __stop_machine() in that it
automatically calls get/put_online_cpus() to disable CPU hotplug.  For
__stop_machine(), the caller is responsible for achieving exclusion
against CPU hotplug using either get/put_online_cpus() or
cpu_hotplug_begin/done().

However, get_online_cpus() can nest safely inside both another
get_online_cpus() or cpu_hotplug_begin(); thus, it's safe to use
stop_machine() instead of __stop_machine() making the distinction
pointless - the overhead of extra get/put_online_cpus() is negligible
compared to stop_machine and they basically become noop if hotplug is
in progress.

This patch converts all current __stop_machine() users to
stop_machine() and kills __stop_machine().  While at it, move function
comment for stop_machine() from function declaration to definition and
update it slightly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: x86@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/alternative.c |    5 ++---
 include/linux/stop_machine.h  |   34 ++--------------------------------
 kernel/cpu.c                  |    2 +-
 kernel/stop_machine.c         |   38 +++++++++++++++++++++++++++-----------
 4 files changed, 32 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index a81f2d5..f7a021e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -719,8 +719,7 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	tpp.nparams = 1;
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
-	/* Use __stop_machine() because the caller already got online_cpus. */
-	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
+	stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
 	return addr;
 }
 
@@ -741,5 +740,5 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
 
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
-	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 }
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 092dc9b..4f1a73c 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -98,36 +98,12 @@ static inline int try_stop_cpus(const struct cpumask *cpumask,
  */
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 
-/**
- * stop_machine: freeze the machine on all CPUs and run this function
- * @fn: the function to run
- * @data: the data ptr for the @fn()
- * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
- *
- * Description: This causes a thread to be scheduled on every cpu,
- * each of which disables interrupts.  The result is that no one is
- * holding a spinlock or inside any other preempt-disabled region when
- * @fn() runs.
- *
- * This can be thought of as a very heavy write lock, equivalent to
- * grabbing every spinlock in the kernel. */
 int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
-/**
- * __stop_machine: freeze the machine on all CPUs and run this function
- * @fn: the function to run
- * @data: the data ptr for the @fn
- * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
- *
- * Description: This is a special version of the above, which assumes cpus
- * won't come or go while it's being called.  Used by hotplug cpu.
- */
-int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
-
 #else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
 
-static inline int __stop_machine(int (*fn)(void *), void *data,
-				 const struct cpumask *cpus)
+static inline int stop_machine(int (*fn)(void *), void *data,
+			       const struct cpumask *cpus)
 {
 	int ret;
 	local_irq_disable();
@@ -136,11 +112,5 @@ static inline int __stop_machine(int (*fn)(void *), void *data,
 	return ret;
 }
 
-static inline int stop_machine(int (*fn)(void *), void *data,
-			       const struct cpumask *cpus)
-{
-	return __stop_machine(fn, data, cpus);
-}
-
 #endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..bb23d5b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -235,7 +235,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		goto out_release;
 	}
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e3516b2..3d3f47d 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -464,24 +464,40 @@ static int stop_machine_cpu_stop(void *data)
 	return err;
 }
 
-int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
+/**
+ * stop_machine - freeze the machine on all online CPUs and run this function
+ * @fn: the function to run
+ * @data: the data ptr for the @fn()
+ * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
+ *
+ * This causes a thread to be scheduled on every cpu, each of which
+ * disables interrupts.  The result is that no one is holding a spinlock or
+ * inside any other preempt-disabled region when @fn() runs.
+ *
+ * This can be thought of as a very heavy write lock, equivalent to
+ * grabbing every spinlock in the kernel.
+ *
+ * CONTEXT:
+ * Might sleep.  Temporarily stops all online CPUs.
+ *
+ * RETURNS:
+ * 0 if all executions of @fn returned 0, any non zero return value if any
+ * returned non zero.
+ */
+int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	struct stop_machine_data smdata = { .fn = fn, .data = data,
-					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
-
-	/* Set the initial state and stop all online cpus. */
-	set_state(&smdata, STOPMACHINE_PREPARE);
-	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
-}
-
-int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
-{
 	int ret;
 
 	/* No CPUs can come up or down during this. */
 	get_online_cpus();
-	ret = __stop_machine(fn, data, cpus);
+	smdata.num_threads = num_online_cpus(),
+
+	/* Set the initial state and stop all online cpus. */
+	set_state(&smdata, STOPMACHINE_PREPARE);
+	ret = stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
+
 	put_online_cpus();
 	return ret;
 }
-- 
1.7.5.2

