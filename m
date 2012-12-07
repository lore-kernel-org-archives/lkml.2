Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423407Ab2LGRjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:39:52 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54623 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423392Ab2LGRju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:39:50 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 23:08:13 +0530
Message-ID: <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120717-7014-0000-0000-0000025003EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are places where preempt_disable() is used to prevent any CPU from
going offline during the critical section. Let us call them as "atomic
hotplug readers" ("atomic" because they run in atomic contexts).

Today, preempt_disable() works because the writer uses stop_machine().
But once stop_machine() is gone, the readers won't be able to prevent
CPUs from going offline using preempt_disable().

The intent of this patch is to provide synchronization APIs for such
atomic hotplug readers, to prevent (any) CPUs from going offline, without
depending on stop_machine() at the writer-side. The new APIs will look
something like this:  get/put_online_cpus_atomic()

Some important design requirements and considerations:
-----------------------------------------------------

1. Scalable synchronization at the reader-side, especially in the fast-path

   Any synchronization at the atomic hotplug readers side must be highly
   scalable - avoid global single-holder locks/counters etc. Because, these
   paths currently use the extremely fast preempt_disable(); our replacement
   to preempt_disable() should not become ridiculously costly and also should
   not serialize the readers among themselves needlessly.

   At a minimum, the new APIs must be extremely fast at the reader side
   atleast in the fast-path, when no CPU offline writers are active.

2. preempt_disable() was recursive. The replacement should also be recursive.

3. No (new) lock-ordering restrictions

   preempt_disable() was super-flexible. It didn't impose any ordering
   restrictions or rules for nesting. Our replacement should also be equally
   flexible and usable.

4. No deadlock possibilities

   Per-cpu locking is not the way to go if we want to have relaxed rules
   for lock-ordering. Because, we can end up in circular-locking dependencies
   as explained in https://lkml.org/lkml/2012/12/6/290

   So, avoid per-cpu locking schemes (per-cpu locks/per-cpu atomic counters
   with spin-on-contention etc) as much as possible.


Implementation of the design:
----------------------------

We use global rwlocks for synchronization, because then we won't get into
lock-ordering related problems (unlike per-cpu locks). However, global
rwlocks lead to unnecessary cache-line bouncing even when there are no
hotplug writers present, which can slow down the system needlessly.

Per-cpu counters can help solve the cache-line bouncing problem. So we
actually use the best of both: per-cpu counters (no-waiting) at the reader
side in the fast-path, and global rwlocks in the slowpath.

[ Fastpath = no writer is active; Slowpath = a writer is active ]

IOW, the hotplug readers just increment/decrement their per-cpu refcounts
when no writer is active. When a writer becomes active, he signals all
readers to switch to global rwlocks for the duration of the CPU offline
operation. The readers ACK the writer's signal when it is safe for them
(ie., when they are about to start a fresh, non-nested read-side critical
section) and start using (holding) the global rwlock for read in their
subsequent critical sections.

The hotplug writer waits for ACKs from every reader, and then acquires
the global rwlock for write and takes the CPU offline. Then the writer
signals all readers that the CPU offline is done, and that they can go back
to using their per-cpu refcounts again.

Note that the lock-safety (despite the per-cpu scheme) comes from the fact
that the readers can *choose* when to ACK the writer's signal (iow, when
to switch to the global rwlock). And the readers don't wait on anybody based
on the per-cpu counters. The only true synchronization that involves waiting
at the reader-side in this scheme, is the one arising from the global rwlock,
which is safe from the circular locking dependency problems mentioned above
(because it is global).

Reader-writer locks and per-cpu counters are recursive, so they can be
used in a nested fashion in the reader-path. And the "signal-and-ack-with-no-
reader-spinning" design of switching the synchronization scheme ensures that
you can safely nest and call these APIs in any way you want, just like
preempt_disable()/enable.

Together, these satisfy all the requirements mentioned above.

I'm indebted to Michael Wang and Xiao Guangrong for their numerous thoughtful
suggestions and ideas, which inspired and influenced many of the decisions in
this as well as previous designs. Thanks a lot Michael and Xiao!

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |    4 +
 kernel/cpu.c        |  252 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 253 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..cf24da1 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -175,6 +175,8 @@ extern struct bus_type cpu_subsys;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern void get_online_cpus_atomic(void);
+extern void put_online_cpus_atomic(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -198,6 +200,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define get_online_cpus_atomic()	do { } while (0)
+#define put_online_cpus_atomic()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 42bd331..d2076fa 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/suspend.h>
+#include <linux/atomic.h>
 
 #include "smpboot.h"
 
@@ -133,6 +134,161 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 
+/*
+ * Reader-writer lock to synchronize between atomic hotplug readers
+ * and the CPU offline hotplug writer.
+ */
+static DEFINE_RWLOCK(hotplug_rwlock);
+
+static DEFINE_PER_CPU(atomic_t, reader_refcount);
+static DEFINE_PER_CPU(atomic_t, writer_signal);
+
+static inline void ack_writer_signal(void)
+{
+	/* Writer raised it to 2. Reduce it to 1 */
+	atomic_dec(&__get_cpu_var(writer_signal));
+	smp_mb__after_atomic_dec();
+}
+
+
+#define reader_active(cpu)						\
+			(atomic_read(&per_cpu(reader_refcount, cpu)) > 0)
+
+#define writer_active(cpu)						\
+			(atomic_read(&per_cpu(writer_signal, cpu)) > 0)
+
+#define is_new_writer(cpu)						\
+			(atomic_read(&per_cpu(writer_signal, cpu)) == 2)
+
+#define reader_acked(cpu)						\
+			(atomic_read(&per_cpu(writer_signal, cpu)) == 1)
+
+
+static inline void mark_reader_fastpath(void)
+{
+	atomic_inc(&__get_cpu_var(reader_refcount));
+	smp_mb__after_atomic_inc();
+}
+
+static inline void unmark_reader_fastpath(void)
+{
+	atomic_dec(&__get_cpu_var(reader_refcount));
+	smp_mb__after_atomic_dec();
+}
+
+static inline void mark_reader_slowpath(void)
+{
+	unsigned int cpu = smp_processor_id();
+
+	mark_reader_fastpath();
+
+	read_lock(&hotplug_rwlock);
+
+	/*
+	 * Release the lock before returning, if the writer has finished.
+	 * This will help reduce the burden on put_online_cpus_atomic().
+	 */
+	if (!writer_active(cpu))
+		read_unlock(&hotplug_rwlock);
+}
+
+/*
+ * Invoked by hotplug reader, to prevent CPUs from going offline.
+ *
+ * If there are no CPU offline writers active, just increment the
+ * per-cpu counter 'reader_refcount' and proceed.
+ *
+ * If a CPU offline hotplug writer is active, we need to ACK his
+ * signal and switch to using the global rwlocks, when the time is
+ * right.
+ *
+ * It is not safe to switch the synchronization scheme when we are
+ * already in a read-side critical section (because their corresponding
+ * put_online_cpus_atomic() won't know of the switch and will continue
+ * to use the old scheme (per-cpu counter updates), which would be
+ * wrong).
+ *
+ * So don't ACK the writer's signal (and don't switch to rwlocks) unless
+ * this is a fresh non-nested read-side critical section on this CPU.
+ *
+ * Once you switch, keep using the rwlocks for synchronization, until
+ * the writer signals the end of CPU offline.
+ *
+ * You can call this recursively, without fear of locking problems.
+ *
+ * Returns with preemption disabled.
+ */
+void get_online_cpus_atomic(void)
+{
+	unsigned int cpu = smp_processor_id();
+	unsigned long flags;
+
+	preempt_disable();
+	local_irq_save(flags);
+
+	if (cpu_hotplug.active_writer == current)
+		goto out;
+
+	smp_rmb(); /* Paired with smp_wmb() in drop_writer_signal() */
+
+	if (likely(!writer_active(cpu))) {
+		mark_reader_fastpath();
+		goto out;
+	}
+
+	/* CPU offline writer is active... */
+
+	/* ACK his signal only once */
+	if (is_new_writer(cpu)) {
+		/*
+		 * ACK the writer's signal only if this is a fresh read-side
+		 * critical section, and not just an extension of a running
+		 * (nested) read-side critical section.
+		 */
+		if (!reader_active(cpu)) {
+			ack_writer_signal();
+			mark_reader_slowpath();
+		} else {
+			/*
+			 * Keep taking the fastpath until all existing nested
+			 * read-side critical sections complete on this CPU.
+			 */
+			mark_reader_fastpath();
+		}
+	} else {
+		/*
+		 * The writer is not new because we have already acked his
+		 * signal before. So just take the slowpath and proceed.
+		 */
+		mark_reader_slowpath();
+	}
+
+out:
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(get_online_cpus_atomic);
+
+void put_online_cpus_atomic(void)
+{
+	unsigned int cpu = smp_processor_id();
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (cpu_hotplug.active_writer == current)
+		goto out;
+
+	if (unlikely(writer_active(cpu)) && reader_acked(cpu))
+		read_unlock(&hotplug_rwlock);
+
+	unmark_reader_fastpath();
+
+out:
+	local_irq_restore(flags);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(put_online_cpus_atomic);
+
 #else /* #if CONFIG_HOTPLUG_CPU */
 static void cpu_hotplug_begin(void) {}
 static void cpu_hotplug_done(void) {}
@@ -237,6 +393,66 @@ static inline void check_for_tasks(int cpu)
 	write_unlock_irq(&tasklist_lock);
 }
 
+/* Set the per-cpu variable writer_signal to 2 */
+static inline void raise_writer_signal(unsigned int cpu)
+{
+	atomic_add(2, &per_cpu(writer_signal, cpu));
+	smp_mb__after_atomic_inc();
+}
+
+/* Reset the per-cpu variable writer_signal to 0 */
+static inline void drop_writer_signal(unsigned int cpu)
+{
+	atomic_set(&per_cpu(writer_signal, cpu), 0);
+	smp_wmb(); /* Paired with smp_rmb() in get_online_cpus_atomic() */
+}
+
+static void announce_cpu_offline_begin(void)
+{
+	unsigned int cpu;
+
+	for_each_online_cpu(cpu)
+		raise_writer_signal(cpu);
+}
+
+static void announce_cpu_offline_end(unsigned int dead_cpu)
+{
+	unsigned int cpu;
+
+	drop_writer_signal(dead_cpu);
+
+	for_each_online_cpu(cpu)
+		drop_writer_signal(cpu);
+}
+
+/*
+ * Check if the reader saw and acked the writer's signal.
+ * If he has, return immediately.
+ *
+ * If he hasn't acked it, there are 2 possibilities:
+ *  a. He is not an active reader; so we can return safely.
+ *  b. He is an active reader, so we need to retry until
+ *     he acks the writer's signal.
+ */
+static void sync_atomic_reader(unsigned int cpu)
+{
+
+retry:
+	if (reader_acked(cpu))
+		return;
+
+	if (reader_active(cpu))
+		goto retry;
+}
+
+static void sync_all_readers(void)
+{
+	unsigned int cpu;
+
+	for_each_online_cpu(cpu)
+		sync_atomic_reader(cpu);
+}
+
 struct take_cpu_down_param {
 	unsigned long mod;
 	void *hcpu;
@@ -246,15 +462,45 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
-	int err;
+	unsigned long flags;
+	unsigned int cpu = (long)(param->hcpu);
+	int err = 0;
+
+
+	/*
+	 * Inform all atomic readers that we are going to offline a CPU
+	 * and that they need to switch from per-cpu counters to the
+	 * global hotplug_rwlock.
+	 */
+	announce_cpu_offline_begin();
+
+	/* Wait for every reader to notice the announcement and ACK it */
+	sync_all_readers();
+
+	/*
+	 * Now all the readers have switched to using the global hotplug_rwlock.
+	 * So now is our chance, go bring down the CPU!
+	 */
+
+	write_lock_irqsave(&hotplug_rwlock, flags);
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
-		return err;
+		goto out;
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
-	return 0;
+
+out:
+	/*
+	 * Inform all atomic readers that we are done with the CPU offline
+	 * operation, so that they can switch back to their per-cpu counters.
+	 * (We don't need to wait for them to see it).
+	 */
+	announce_cpu_offline_end(cpu);
+
+	write_unlock_irqrestore(&hotplug_rwlock, flags);
+	return err;
 }
 
 /* Requires cpu_add_remove_lock to be held */

