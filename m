Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2LKOGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:06:05 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52591 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab2LKOGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:06:02 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Dec 2012 19:34:29 +0530
Message-ID: <20121211140358.23621.97011.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com>
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121114-5140-0000-0000-0000027DFE3E
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

   Regular per-cpu locking is not the way to go if we want to have relaxed
   rules for lock-ordering. Because, we can end up in circular-locking
   dependencies as explained in https://lkml.org/lkml/2012/12/6/290

   So, avoid the usual per-cpu locking schemes (per-cpu locks/per-cpu atomic
   counters with spin-on-contention etc) as much as possible.


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
operation. The readers switch over when it is safe for them (ie., when they
are about to start a fresh, non-nested read-side critical section) and
start using (holding) the global rwlock for read in their subsequent critical
sections.

The hotplug writer waits for every reader to switch, and then acquires
the global rwlock for write and takes the CPU offline. Then the writer
signals all readers that the CPU offline is done, and that they can go back
to using their per-cpu refcounts again.

Note that the lock-safety (despite the per-cpu scheme) comes from the fact
that the readers can *choose* _when_ to switch to rwlocks upon the writer's
signal. And the readers don't wait on anybody based on the per-cpu counters.
The only true synchronization that involves waiting at the reader-side in this
scheme, is the one arising from the global rwlock, which is safe from the
circular locking dependency problems mentioned above (because it is global).

Reader-writer locks and per-cpu counters are recursive, so they can be
used in a nested fashion in the reader-path. Also, this design of switching
the synchronization scheme ensures that you can safely nest and call these
APIs in any way you want, just like preempt_disable()/enable.

Together, these satisfy all the requirements mentioned above.

I'm indebted to Michael Wang and Xiao Guangrong for their numerous thoughtful
suggestions and ideas, which inspired and influenced many of the decisions in
this as well as previous designs. Thanks a lot Michael and Xiao!

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |    4 +
 kernel/cpu.c        |  204 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 205 insertions(+), 3 deletions(-)

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
index 42bd331..5a63296 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -133,6 +133,119 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 
+/*
+ * Reader-writer lock to synchronize between atomic hotplug readers
+ * and the CPU offline hotplug writer.
+ */
+static DEFINE_RWLOCK(hotplug_rwlock);
+
+static DEFINE_PER_CPU(int, reader_percpu_refcnt);
+static DEFINE_PER_CPU(bool, writer_signal);
+
+
+#define reader_uses_percpu_refcnt(cpu)					\
+			(ACCESS_ONCE(per_cpu(reader_percpu_refcnt, cpu)))
+
+#define reader_nested_percpu()						\
+				(__this_cpu_read(reader_percpu_refcnt) > 1)
+
+#define writer_active()							\
+				(__this_cpu_read(writer_signal))
+
+
+
+/*
+ * Invoked by hotplug reader, to prevent CPUs from going offline.
+ *
+ * If there are no CPU offline writers active, just increment the
+ * per-cpu counter 'reader_percpu_refcnt' and proceed.
+ *
+ * If a CPU offline hotplug writer is active, we'll need to switch from
+ * per-cpu refcounts to the global rwlock, when the time is right.
+ *
+ * It is not safe to switch the synchronization scheme when we are
+ * already in a read-side critical section which uses per-cpu refcounts.
+ * Also, we don't want to allow heterogeneous readers to nest inside
+ * each other, to avoid complications in put_online_cpus_atomic().
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
+	unsigned long flags;
+
+	preempt_disable();
+
+	if (cpu_hotplug.active_writer == current)
+		return;
+
+	local_irq_save(flags);
+
+	/*
+	 * Use the percpu refcounts by default. Switch over to rwlock (if
+	 * necessary) later on. This helps avoid several race conditions
+	 * as well.
+	 */
+	__this_cpu_inc(reader_percpu_refcnt);
+
+	smp_rmb(); /* Paired with smp_mb() in announce_cpu_offline_begin(). */
+
+	/*
+	 * We must not allow heterogeneous nesting of readers (ie., readers
+	 * using percpu refcounts to nest with readers using rwlocks).
+	 * So don't switch the synchronization scheme if we are currently
+	 * using perpcu refcounts.
+	 */
+	if (!reader_nested_percpu() && unlikely(writer_active())) {
+
+		read_lock(&hotplug_rwlock);
+
+		/*
+		 * We might have raced with a writer going inactive before we
+		 * took the read-lock. So re-evaluate whether we still need to
+		 * use the rwlock or if we can switch back to percpu refcounts.
+		 * (This also helps avoid heterogeneous nesting of readers).
+		 */
+		if (writer_active())
+			__this_cpu_dec(reader_percpu_refcnt);
+		else
+			read_unlock(&hotplug_rwlock);
+	}
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(get_online_cpus_atomic);
+
+void put_online_cpus_atomic(void)
+{
+	unsigned long flags;
+
+	if (cpu_hotplug.active_writer == current)
+		goto out;
+
+	local_irq_save(flags);
+
+	/*
+	 * We never allow heterogeneous nesting of readers. So it is trivial
+	 * to find out the kind of reader we are, and undo the operation
+	 * done by our corresponding get_online_cpus_atomic().
+	 */
+	if (__this_cpu_read(reader_percpu_refcnt))
+		__this_cpu_dec(reader_percpu_refcnt);
+	else
+		read_unlock(&hotplug_rwlock);
+
+	local_irq_restore(flags);
+out:
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(put_online_cpus_atomic);
+
 #else /* #if CONFIG_HOTPLUG_CPU */
 static void cpu_hotplug_begin(void) {}
 static void cpu_hotplug_done(void) {}
@@ -237,6 +350,61 @@ static inline void check_for_tasks(int cpu)
 	write_unlock_irq(&tasklist_lock);
 }
 
+static inline void raise_writer_signal(unsigned int cpu)
+{
+	per_cpu(writer_signal, cpu) = true;
+}
+
+static inline void drop_writer_signal(unsigned int cpu)
+{
+	per_cpu(writer_signal, cpu) = false;
+}
+
+static void announce_cpu_offline_begin(void)
+{
+	unsigned int cpu;
+
+	for_each_online_cpu(cpu)
+		raise_writer_signal(cpu);
+
+	smp_mb();
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
+
+	smp_mb();
+}
+
+/*
+ * Wait for the reader to see the writer's signal and switch from percpu
+ * refcounts to global rwlock.
+ *
+ * If the reader is still using percpu refcounts, wait for him to switch.
+ * Else, we can safely go ahead, because either the reader has already
+ * switched over, or the next atomic hotplug reader who comes along on this
+ * CPU will notice the writer's signal and will switch over to the rwlock.
+ */
+static inline void sync_atomic_reader(unsigned int cpu)
+{
+	while (reader_uses_percpu_refcnt(cpu))
+		cpu_relax();
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
@@ -246,15 +414,45 @@ struct take_cpu_down_param {
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
+	 * and that they need to switch from per-cpu refcounts to the
+	 * global hotplug_rwlock.
+	 */
+	announce_cpu_offline_begin();
+
+	/* Wait for every reader to notice the announcement and switch over */
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
+	 * operation, so that they can switch back to their per-cpu refcounts.
+	 * (We don't need to wait for them to see it).
+	 */
+	announce_cpu_offline_end(cpu);
+
+	write_unlock_irqrestore(&hotplug_rwlock, flags);
+	return err;
 }
 
 /* Requires cpu_add_remove_lock to be held */

