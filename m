Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2LESot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:44:49 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46414 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2LESor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:44:47 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 02/10] CPU hotplug: Provide APIs for "full" atomic
 readers to prevent CPU offline
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 00:13:17 +0530
Message-ID: <20121205184313.3750.17752.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com>
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120518-4790-0000-0000-000005E31359
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the atomic hotplug readers cannot tolerate CPUs going offline while
they are in their critical section. That is, they can't get away with just
synchronizing with the updates to the cpu_online_mask; they really need to
synchronize with the entire CPU tear-down sequence, because they are very
much involved in the hotplug related code paths.

Such "full" atomic hotplug readers need a way to *actually* and *truly*
prevent CPUs from going offline while they are active.

The intent of this patch is to provide synchronization APIs for such "full"
atomic hotplug readers. [ get/put_online_cpus_atomic_full()]

Some important design requirements and considerations:
-----------------------------------------------------

1. Scalable synchronization

Any synchronization at the atomic hotplug readers side must be highly
scalable - avoid global single-holder locks/counters etc. Because, these
paths currently use the extremely fast preempt_disable(); our replacement
to preempt_disable() should not become ridiculously costly and also should
not serialize the readers among themselves needlessly.

2. Should not have ABBA deadlock possibilities between the 2 types of atomic
readers ("light" vs "full")

Atomic readers who can get away with a stable online mask ("light" readers)
and atomic readers who need full synchronization with CPU offline ("full"
readers) must not end up in situations leading to ABBA deadlocks because of
the APIs they use respectively.

Also, we should not impose any ordering restrictions on how the 2 types of
readers can nest. They should be allowed to nest freely in any way they want,
and we should provide the guarantee that they won't deadlock.
(preempt_disable() posed no ordering restrictions before. Neither should we).

3. preempt_disable() was recursive. The replacement should also be recursive.

Implementation of the design:
----------------------------

Basically, we use another reader-writer lock for synchronizing the "full"
hotplug readers with the writer. But since we want to avoid ABBA deadlock
possibilities, we need to be careful as well as clever while designing this
"full" reader APIs.

Simplification: All "full" readers are also "light" readers
-----------------------------------------------------------

This simplification helps us get rid of ABBA deadlock possibilites, because
the lock ordering remains consistent to both types of readers, and looks
something like this:

Light reader:
------------
    Take light-lock for read

        /* Critical section */

    Release the light-lock

Full reader:
-----------
    Take light-lock for read

        Take full-lock for read

            /* Critical section */

        Release the full-lock

    Release the light-lock


But then, the writer path should be cleverly designed in such a way that
after the update to cpu_online_mask, only the light-readers can continue, but
the full-readers continue to spin until entire CPU offline operation is
complete.

So the lock ordering in the writer should look like this:

Writer:
------

    Take light-lock for write

        Take the full-lock for write

            Update cpu_online_mask (flip the bit)


    /*
     * Now allow only the light-readers to continue, while keeping the
     * full-readers spinning (ie., release the light-lock alone).
     */
    Release the light-lock

    /* Continue CPU tear-down, calling CPU_DYING notifiers */

    /* Finally, allow the full-readers to continue */
    Release the full-lock


It can be verified that, with this scheme, there is no possibility of any
ABBA deadlocks, and that the 2 types of atomic readers can nest in any
way they want, without fear.


We expect that the atomic hotplug readers who need full synchronization
with CPU offline (and cannot just get away with a stable online mask), be
rare. Otherwise, we could end up creating a similar effect as
stop_machine() without even using stop_machine()! [That is, if too many
readers are of this kind, everybody will wait for the entire CPU offline to
finish, which is almost like having stop_machine() itself.]

So we hope that most atomic hotplug readers are of the "light" type.
That would keeps things fast and scalable and make CPU offline operations
painless.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |    4 ++++
 kernel/cpu.c        |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index dd0a3ee..e2a9c49 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -177,6 +177,8 @@ extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 extern void get_online_cpus_atomic_light(void);
 extern void put_online_cpus_atomic_light(void);
+extern void get_online_cpus_atomic_full(void);
+extern void put_online_cpus_atomic_full(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -202,6 +204,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 #define put_online_cpus()	do { } while (0)
 #define get_online_cpus_atomic_light()	do { } while (0)
 #define put_online_cpus_atomic_light()	do { } while (0)
+#define get_online_cpus_atomic_full()	do { } while (0)
+#define put_online_cpus_atomic_full()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 381593c..c71c723 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -112,6 +112,46 @@ void put_online_cpus_atomic_light(void)
 }
 EXPORT_SYMBOL_GPL(put_online_cpus_atomic_light);
 
+/*
+ * Reader-writer lock to synchronize between "full/heavy" atomic hotplug
+ * readers and the hotplug writer while doing CPU offline operation.
+ * "Full/heavy" atomic hotplug readers are those who need to synchronize
+ * with the full CPU take-down sequence, and not just the bit flip in the
+ * cpu_online_mask.
+ */
+static DEFINE_RWLOCK(full_hotplug_rwlock);
+
+/*
+ * Some atomic hotplug readers need to synchronize with the entire CPU
+ * tear-down sequence, and not just with the update of the cpu_online_mask.
+ * Such readers are called "full" atomic hotplug readers.
+ *
+ * The following APIs help them synchronize fully with the CPU offline
+ * operation.
+ *
+ * You can call this function recursively.
+ *
+ * Also, you can mix and match (nest) "full" and "light" atomic hotplug
+ * readers in any way you want (without worrying about their ordering).
+ * The respective APIs have been designed in such a way as to provide
+ * the guarantee that you won't end up in a deadlock.
+ */
+void get_online_cpus_atomic_full(void)
+{
+	preempt_disable();
+	read_lock(&light_hotplug_rwlock);
+	read_lock(&full_hotplug_rwlock);
+}
+EXPORT_SYMBOL_GPL(get_online_cpus_atomic_full);
+
+void put_online_cpus_atomic_full(void)
+{
+	read_unlock(&full_hotplug_rwlock);
+	read_unlock(&light_hotplug_rwlock);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(put_online_cpus_atomic_full);
+
 static struct {
 	struct task_struct *active_writer;
 	struct mutex lock; /* Synchronizes accesses to refcount, */
@@ -318,9 +358,13 @@ static int __ref take_cpu_down(void *_param)
 	 */
 	write_lock_irqsave(&light_hotplug_rwlock, flags);
 
+	/* Disable the atomic hotplug readers who need full synchronization */
+	write_lock(&full_hotplug_rwlock);
+
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0) {
+		write_unlock(&full_hotplug_rwlock);
 		write_unlock_irqrestore(&light_hotplug_rwlock, flags);
 		return err;
 	}
@@ -338,6 +382,9 @@ static int __ref take_cpu_down(void *_param)
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
 
+	/* Enable the atomic hotplug readers who need full synchronization */
+	write_unlock(&full_hotplug_rwlock);
+
 	local_irq_restore(flags);
 	return 0;
 }

