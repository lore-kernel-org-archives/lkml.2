Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab2LDIzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:55:48 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53218 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2LDIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:55:46 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 01/10] CPU hotplug: Introduce "stable" cpu online mask,
 for atomic hotplug readers
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org
Cc: sbw@mit.edu, tj@kernel.org, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 14:23:41 +0530
Message-ID: <20121204085324.25919.53090.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120408-5564-0000-0000-000005A05C03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

There are places where preempt_disable() is used to prevent any CPU from
going offline during the critical section. Let us call them as "atomic
hotplug readers" (atomic because they run in atomic contexts).

Often, these atomic hotplug readers have a simple need : they want the cpu
online mask that they work with (inside their critical section), to be
stable, i.e., it should be guaranteed that CPUs in that mask won't go
offline during the critical section. An important point here is that they
don't really care if such a "stable" mask is a subset of the actual
cpu_online_mask.

The intent of this patch is to provide such a "stable" cpu online mask
for that class of atomic hotplug readers.

Fundamental idea behind the design:
-----------------------------------

Simply put, have a separate mask called the stable cpu online mask; and
at the hotplug writer (cpu_down()), note down the CPU that is about to go
offline, and remove it from the stable cpu online mask. Then, feel free
to take that CPU offline, since the atomic hotplug readers won't see it
from now on. Also, don't start any new cpu_down() operations until all
existing atomic hotplug readers have completed (because they might still
be working with the old value of the stable online mask).

Some important design requirements and considerations:
-----------------------------------------------------

1. The atomic hotplug readers should ideally *never* wait for the hotplug
   writer (cpu_down()) for *anything*. Because, these atomic hotplug readers
   can be in very hot-paths like interrupt handling/IPI and hence, if they
   have to wait for an ongoing cpu_down() to complete, it would pretty much
   introduce the same performance/latency problems as stop_machine().

2. Any synchronization at the atomic hotplug readers side must be highly
   scalable - avoid global locks/counters etc. Because, these paths currently
   use the extremely fast preempt_disable(); our replacement to
   preempt_disable() should not become ridiculously costly.

3. preempt_disable() was recursive. The replacement should also be recursive.

Implementation of the design:
----------------------------

Atomic hotplug reader side:

We use per-cpu counters to mark the presence of atomic hotplug readers.
A reader would increment its per-cpu counter and continue, without waiting
for anything. And no locks are used in this path. Together, these satisfy
all the 3 requirements mentioned above.

The hotplug writer uses (reads) the per-cpu counters of all CPUs in order to
ensure that all existing atomic hotplug readers have completed. Only after
that, it will proceed to actually take the CPU offline.

[ Michael: Designed the synchronization for the IPI case ]
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
[ Srivatsa: Generalized it to work for all cases and wrote the changelog ]
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h     |    4 +
 include/linux/cpumask.h |    5 ++
 kernel/cpu.c            |  129 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..c64b6ed 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -175,6 +175,8 @@ extern struct bus_type cpu_subsys;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern void get_online_cpus_stable_atomic(void);
+extern void put_online_cpus_stable_atomic(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -198,6 +200,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define get_online_cpus_stable_atomic()	do { } while (0)
+#define put_online_cpus_stable_atomic()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 0325602..2148e60 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -78,6 +78,7 @@ extern int nr_cpu_ids;
 
 extern const struct cpumask *const cpu_possible_mask;
 extern const struct cpumask *const cpu_online_mask;
+extern const struct cpumask *const cpu_online_stable_mask;
 extern const struct cpumask *const cpu_present_mask;
 extern const struct cpumask *const cpu_active_mask;
 
@@ -87,6 +88,7 @@ extern const struct cpumask *const cpu_active_mask;
 #define num_present_cpus()	cpumask_weight(cpu_present_mask)
 #define num_active_cpus()	cpumask_weight(cpu_active_mask)
 #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
+#define cpu_online_stable(cpu)	cpumask_test_cpu((cpu), cpu_online_stable_mask)
 #define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
 #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
 #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
@@ -705,12 +707,15 @@ extern const DECLARE_BITMAP(cpu_all_bits, NR_CPUS);
 
 #define for_each_possible_cpu(cpu) for_each_cpu((cpu), cpu_possible_mask)
 #define for_each_online_cpu(cpu)   for_each_cpu((cpu), cpu_online_mask)
+#define for_each_online_cpu_stable(cpu)					  \
+				for_each_cpu((cpu), cpu_online_stable_mask)
 #define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_mask)
 
 /* Wrappers for arch boot code to manipulate normally-constant masks */
 void set_cpu_possible(unsigned int cpu, bool possible);
 void set_cpu_present(unsigned int cpu, bool present);
 void set_cpu_online(unsigned int cpu, bool online);
+void set_cpu_online_stable(unsigned int cpu, bool online);
 void set_cpu_active(unsigned int cpu, bool active);
 void init_cpu_present(const struct cpumask *src);
 void init_cpu_possible(const struct cpumask *src);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 42bd331..aaf2393 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -49,6 +49,73 @@ static int cpu_hotplug_disabled;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
+/*
+ * Per-cpu counter to mark the presence of active atomic hotplug readers
+ * (those that run in atomic context and want to prevent CPUs from going
+ * offline).
+ */
+static DEFINE_PER_CPU(int, hotplug_reader_refcount);
+
+/*
+ * Hotplug readers (those that want to prevent CPUs from going offline)
+ * sometimes run from atomic contexts, and hence can't use
+ * get/put_online_cpus() because they can sleep. And often-times, all
+ * they really want is a stable (unchanging) online mask to work with, which
+ * could be a subset of the actual cpu_online_mask, but with a guarantee
+ * that all the CPUs in that stable mask stay online throughout the
+ * hotplug-read-side critical section.
+ *
+ * In such cases, these atomic hotplug readers can use the pair
+ * get/put_online_cpus_stable_atomic() around their critical section to
+ * ensure that the stable mask 'cpu_online_stable_mask' remains unaltered
+ * throughout that critical section. And of course, they should only use
+ * the stable mask in their critical section, and not the actual
+ * cpu_online_mask!
+ *
+ * Eg:
+ *
+ * Atomic hotplug read-side critical section:
+ * -----------------------------------------
+ *
+ * get_online_cpus_stable_atomic();
+ *
+ * for_each_online_cpu_stable(cpu) {
+ *         ... Do something...
+ * }
+ *    ...
+ *
+ * if (cpu_online_stable(other_cpu))
+ *         do_something();
+ *
+ * put_online_cpus_stable_atomic();
+ *
+ * You can call this function recursively.
+ */
+void get_online_cpus_stable_atomic(void)
+{
+	preempt_disable();
+	this_cpu_inc(hotplug_reader_refcount);
+
+	/*
+	 * Prevent reordering of writes to hotplug_reader_refcount and
+	 * reads from cpu_online_stable_mask.
+	 */
+	smp_mb();
+}
+EXPORT_SYMBOL_GPL(get_online_cpus_stable_atomic);
+
+void put_online_cpus_stable_atomic(void)
+{
+	/*
+	 * Prevent reordering of reads from cpu_online_stable_mask and
+	 * writes to hotplug_reader_refcount.
+	 */
+	smp_mb();
+	this_cpu_dec(hotplug_reader_refcount);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(put_online_cpus_stable_atomic);
+
 static struct {
 	struct task_struct *active_writer;
 	struct mutex lock; /* Synchronizes accesses to refcount, */
@@ -237,6 +304,44 @@ static inline void check_for_tasks(int cpu)
 	write_unlock_irq(&tasklist_lock);
 }
 
+/*
+ * We want all atomic hotplug readers to refer to the new value of
+ * cpu_online_stable_mask. So wait for the existing atomic hotplug readers
+ * to complete. Any new atomic hotplug readers will see the updated mask
+ * and hence pose no problems.
+ */
+static void sync_hotplug_readers(void)
+{
+	unsigned int cpu;
+
+	for_each_online_cpu(cpu) {
+		while (per_cpu(hotplug_reader_refcount, cpu))
+			cpu_relax();
+	}
+}
+
+/*
+ * We are serious about taking this CPU down. So clear the CPU from the
+ * stable online mask.
+ */
+static void prepare_cpu_take_down(unsigned int cpu)
+{
+	set_cpu_online_stable(cpu, false);
+
+	/*
+	 * Prevent reordering of writes to cpu_online_stable_mask and reads
+	 * from hotplug_reader_refcount.
+	 */
+	smp_mb();
+
+	/*
+	 * Wait for all active hotplug readers to complete, to ensure that
+	 * there are no critical sections still referring to the old stable
+	 * online mask.
+	 */
+	sync_hotplug_readers();
+}
+
 struct take_cpu_down_param {
 	unsigned long mod;
 	void *hcpu;
@@ -246,7 +351,9 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
-	int err;
+	int err, cpu = (long)(param->hcpu);
+
+	prepare_cpu_take_down(cpu);
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
@@ -670,6 +777,11 @@ static DECLARE_BITMAP(cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);
 EXPORT_SYMBOL(cpu_online_mask);
 
+static DECLARE_BITMAP(cpu_online_stable_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_online_stable_mask =
+					to_cpumask(cpu_online_stable_bits);
+EXPORT_SYMBOL(cpu_online_stable_mask);
+
 static DECLARE_BITMAP(cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_present_mask = to_cpumask(cpu_present_bits);
 EXPORT_SYMBOL(cpu_present_mask);
@@ -694,12 +806,26 @@ void set_cpu_present(unsigned int cpu, bool present)
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_present_bits));
 }
 
+void set_cpu_online_stable(unsigned int cpu, bool online)
+{
+	if (online)
+		cpumask_set_cpu(cpu, to_cpumask(cpu_online_stable_bits));
+	else
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_stable_bits));
+}
+
 void set_cpu_online(unsigned int cpu, bool online)
 {
 	if (online)
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
 	else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+
+	/*
+	 * Any changes to the online mask must also be propagated to the
+	 * stable online mask.
+	 */
+	set_cpu_online_stable(cpu, online);
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
@@ -723,4 +849,5 @@ void init_cpu_possible(const struct cpumask *src)
 void init_cpu_online(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_online_bits), src);
+	cpumask_copy(to_cpumask(cpu_online_stable_bits), src);
 }

