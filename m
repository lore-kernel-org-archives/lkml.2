Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2LESog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:44:36 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:41075 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2LESoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:44:34 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light" atomic
 readers to prevent CPU offline
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 00:13:04 +0530
Message-ID: <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com>
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120518-5816-0000-0000-000005B2BCDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are places where preempt_disable() is used to prevent any CPU from
going offline during the critical section. Let us call them as "atomic
hotplug readers" (atomic because they run in atomic contexts).

Often, these atomic hotplug readers have a simple need : they want the cpu
online mask that they work with (inside their critical section), to be
stable, i.e., it should be guaranteed that CPUs in that mask won't go
offline during the critical section. The important point here is that
they don't really need to synchronize with the actual CPU tear-down
sequence. All they need is synchronization with the updates to the
cpu_online_mask. (Hence the term "light", for light-weight).

The intent of this patch is to provide synchronization APIs for such
"light" atomic hotplug readers. [ get/put_online_cpus_atomic_light() ]

Fundamental idea behind the design:
-----------------------------------

Simply put, in the hotplug writer path, have appropriate locking around the
update to the cpu_online_mask in the CPU tear-down sequence. And once the
update is done, release the lock and allow the "light" atomic hotplug readers
to go ahead. Meanwhile, the hotplug writer can safely continue the actual
CPU tear-down sequence (running CPU_DYING notifiers etc) since the "light"
atomic readers don't really care about those operations (and hence don't
need to synchronize with them).

Also, once the hotplug writer completes taking the CPU offline, it should
not start any new cpu_down() operations until all existing "light" atomic
hotplug readers have completed.

Some important design requirements and considerations:
-----------------------------------------------------

1. The "light" atomic hotplug readers should ideally *never* have to wait
   for the hotplug writer (cpu_down()) for too long (like entire duration
   of CPU offline, for example). Because, these atomic hotplug readers can be
   in very hot-paths like interrupt handling/IPI and hence, if they have to
   wait for an ongoing cpu_down() to complete, it would pretty much
   introduce the same performance/latency problems as stop_machine().

2. Any synchronization at the atomic hotplug readers side must be highly
   scalable - avoid global single-holder locks/counters etc. Because, these
   paths currently use the extremely fast preempt_disable(); our replacement
   to preempt_disable() should not become ridiculously costly and also should
   not serialize the readers among themselves needlessly.

3. preempt_disable() was recursive. The replacement should also be recursive.

Implementation of the design:
----------------------------

At the core, we use a reader-writer lock to synchronize the update to the
cpu_online_mask. That way, multiple "light" atomic hotplug readers can co-exist
and the writer can acquire the lock only when all the readers have completed.

Once acquired, the writer holds the "light" lock only during the duration of
the update to the cpu_online_mask. That way, the readers don't have to spin
for too long (ie., the write-hold-time for the "light" lock is tiny), which
keeps the readers in good shape.

Reader-writer lock are recursive, so they can be used in a nested fashion in
the reader-path. Together, these satisfy all the 3 requirements mentioned above.

Also, since we don't use per-cpu locks (because rwlocks themselves are quite
scalable for readers), we don't end up in any lock ordering problems that can
occur if we try to use per-cpu locks.

I'm indebted to Michael Wang and Xiao Guangrong for their numerous thoughtful
suggestions and ideas, which inspired and influenced many of the decisions in
this as well as previous designs. Thanks a lot Michael and Xiao!

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |    4 ++
 kernel/cpu.c        |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..dd0a3ee 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -175,6 +175,8 @@ extern struct bus_type cpu_subsys;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern void get_online_cpus_atomic_light(void);
+extern void put_online_cpus_atomic_light(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -198,6 +200,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define get_online_cpus_atomic_light()	do { } while (0)
+#define put_online_cpus_atomic_light()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 42bd331..381593c 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -49,6 +49,69 @@ static int cpu_hotplug_disabled;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
+/*
+ * Reader-writer lock to synchronize between "light" atomic hotplug readers
+ * and the hotplug writer while updating cpu_online_mask.
+ * "Light" atomic hotplug readers are those who don't really need to
+ * synchronize with the actual CPU bring-up/take-down sequence, but only
+ * need to synchronize with the updates to the cpu_online_mask.
+ */
+static DEFINE_RWLOCK(light_hotplug_rwlock);
+
+/*
+ * Hotplug readers (those that want to prevent CPUs from coming online or
+ * going offline ) sometimes run from atomic contexts, and hence can't use
+ * get/put_online_cpus() because they can sleep. And often-times, all
+ * they really want is that the cpu_online_mask remain unchanged while
+ * they are executing in their critical section. They also don't really
+ * need to synchronize with the actual CPU tear-down sequence. Such atomic
+ * hotplug readers are called "light" readers (light for light-weight).
+ *
+ * These "light" atomic hotplug readers can use the APIs
+ * get/put_online_atomic_light() around their critical sections to
+ * ensure that the cpu_online_mask remains unaltered throughout that
+ * critical section.
+ *
+ * Caution!: While the readers are in their critical section, a CPU offline
+ * operation can actually happen under the covers; its just that the bit flip
+ * in the cpu_online_mask will be synchronized properly if you use these APIs.
+ * If you really want full synchronization with the entire CPU tear-down
+ * sequence, then you are not a "light" hotplug reader. So don't use these
+ * APIs!
+ *
+ * Eg:
+ *
+ * "Light" atomic hotplug read-side critical section:
+ * --------------------------------------------------
+ *
+ * get_online_cpus_atomic_light();
+ *
+ * for_each_online_cpu(cpu) {
+ *         ... Do something...
+ * }
+ *    ...
+ *
+ * if (cpu_online(other_cpu))
+ *         do_something();
+ *
+ * put_online_cpus_atomic_light();
+ *
+ * You can call this function recursively.
+ */
+void get_online_cpus_atomic_light(void)
+{
+	preempt_disable();
+	read_lock(&light_hotplug_rwlock);
+}
+EXPORT_SYMBOL_GPL(get_online_cpus_atomic_light);
+
+void put_online_cpus_atomic_light(void)
+{
+	read_unlock(&light_hotplug_rwlock);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(put_online_cpus_atomic_light);
+
 static struct {
 	struct task_struct *active_writer;
 	struct mutex lock; /* Synchronizes accesses to refcount, */
@@ -246,14 +309,36 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
+	unsigned long flags;
 	int err;
 
+	/*
+	 *  __cpu_disable() is the step where the CPU is removed from the
+	 *  cpu_online_mask. Protect it with the light-lock held for write.
+	 */
+	write_lock_irqsave(&light_hotplug_rwlock, flags);
+
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
-	if (err < 0)
+	if (err < 0) {
+		write_unlock_irqrestore(&light_hotplug_rwlock, flags);
 		return err;
+	}
+
+	/*
+	 * We have successfully removed the CPU from the cpu_online_mask.
+	 * So release the light-lock, so that the light-weight atomic readers
+	 * (who care only about the cpu_online_mask updates, and not really
+	 * about the actual cpu-take-down operation) can continue.
+	 *
+	 * But don't enable interrupts yet, because we still have work left to
+	 * do, to actually bring the CPU down.
+	 */
+	write_unlock(&light_hotplug_rwlock);
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
+
+	local_irq_restore(flags);
 	return 0;
 }
 

