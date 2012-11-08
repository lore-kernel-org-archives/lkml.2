Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2KHNsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:48:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab2KHNsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:48:17 -0500
Date: Thu, 8 Nov 2012 14:48:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v2 1/1] percpu_rw_semaphore: reimplement to not
	block the readers unnecessarily
Message-ID: <20121108134849.GB23870@redhat.com>
References: <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <20121030184800.GA16129@redhat.com> <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com> <20121102180606.GA13255@redhat.com> <20121108134805.GA23870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108134805.GA23870@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the writer does msleep() plus synchronize_sched() 3 times
to acquire/release the semaphore, and during this time the readers
are blocked completely. Even if the "write" section was not actually
started or if it was already finished.

With this patch down_write/up_write does synchronize_sched() twice
and down_read/up_read are still possible during this time, just they
use the slow path.

percpu_down_write() first forces the readers to use rw_semaphore and
increment the "slow" counter to take the lock for reading, then it
takes that rw_semaphore for writing and blocks the readers.

Also. With this patch the code relies on the documented behaviour of
synchronize_sched(), it doesn't try to pair synchronize_sched() with
barrier.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/percpu-rwsem.h |   83 +++++------------------------
 lib/Makefile                 |    2 +-
 lib/percpu-rwsem.c           |  123 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+), 71 deletions(-)
 create mode 100644 lib/percpu-rwsem.c

diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index 250a4ac..592f0d6 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -2,82 +2,25 @@
 #define _LINUX_PERCPU_RWSEM_H
 
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/percpu.h>
-#include <linux/rcupdate.h>
-#include <linux/delay.h>
+#include <linux/wait.h>
 
 struct percpu_rw_semaphore {
-	unsigned __percpu *counters;
-	bool locked;
-	struct mutex mtx;
+	unsigned int __percpu	*fast_read_ctr;
+	struct mutex		writer_mutex;
+	struct rw_semaphore	rw_sem;
+	atomic_t		slow_read_ctr;
+	wait_queue_head_t	write_waitq;
 };
 
-#define light_mb()	barrier()
-#define heavy_mb()	synchronize_sched()
+extern void percpu_down_read(struct percpu_rw_semaphore *);
+extern void percpu_up_read(struct percpu_rw_semaphore *);
 
-static inline void percpu_down_read(struct percpu_rw_semaphore *p)
-{
-	rcu_read_lock_sched();
-	if (unlikely(p->locked)) {
-		rcu_read_unlock_sched();
-		mutex_lock(&p->mtx);
-		this_cpu_inc(*p->counters);
-		mutex_unlock(&p->mtx);
-		return;
-	}
-	this_cpu_inc(*p->counters);
-	rcu_read_unlock_sched();
-	light_mb(); /* A, between read of p->locked and read of data, paired with D */
-}
+extern void percpu_down_write(struct percpu_rw_semaphore *);
+extern void percpu_up_write(struct percpu_rw_semaphore *);
 
-static inline void percpu_up_read(struct percpu_rw_semaphore *p)
-{
-	light_mb(); /* B, between read of the data and write to p->counter, paired with C */
-	this_cpu_dec(*p->counters);
-}
-
-static inline unsigned __percpu_count(unsigned __percpu *counters)
-{
-	unsigned total = 0;
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		total += ACCESS_ONCE(*per_cpu_ptr(counters, cpu));
-
-	return total;
-}
-
-static inline void percpu_down_write(struct percpu_rw_semaphore *p)
-{
-	mutex_lock(&p->mtx);
-	p->locked = true;
-	synchronize_sched(); /* make sure that all readers exit the rcu_read_lock_sched region */
-	while (__percpu_count(p->counters))
-		msleep(1);
-	heavy_mb(); /* C, between read of p->counter and write to data, paired with B */
-}
-
-static inline void percpu_up_write(struct percpu_rw_semaphore *p)
-{
-	heavy_mb(); /* D, between write to data and write to p->locked, paired with A */
-	p->locked = false;
-	mutex_unlock(&p->mtx);
-}
-
-static inline int percpu_init_rwsem(struct percpu_rw_semaphore *p)
-{
-	p->counters = alloc_percpu(unsigned);
-	if (unlikely(!p->counters))
-		return -ENOMEM;
-	p->locked = false;
-	mutex_init(&p->mtx);
-	return 0;
-}
-
-static inline void percpu_free_rwsem(struct percpu_rw_semaphore *p)
-{
-	free_percpu(p->counters);
-	p->counters = NULL; /* catch use after free bugs */
-}
+extern int percpu_init_rwsem(struct percpu_rw_semaphore *);
+extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
 
 #endif
diff --git a/lib/Makefile b/lib/Makefile
index 821a162..4dad4a7 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o percpu-rwsem.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/percpu-rwsem.c b/lib/percpu-rwsem.c
new file mode 100644
index 0000000..0e3bc0f
--- /dev/null
+++ b/lib/percpu-rwsem.c
@@ -0,0 +1,123 @@
+#include <linux/percpu-rwsem.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+
+int percpu_init_rwsem(struct percpu_rw_semaphore *brw)
+{
+	brw->fast_read_ctr = alloc_percpu(int);
+	if (unlikely(!brw->fast_read_ctr))
+		return -ENOMEM;
+
+	mutex_init(&brw->writer_mutex);
+	init_rwsem(&brw->rw_sem);
+	atomic_set(&brw->slow_read_ctr, 0);
+	init_waitqueue_head(&brw->write_waitq);
+	return 0;
+}
+
+void percpu_free_rwsem(struct percpu_rw_semaphore *brw)
+{
+	free_percpu(brw->fast_read_ctr);
+	brw->fast_read_ctr = NULL; /* catch use after free bugs */
+}
+
+static bool update_fast_ctr(struct percpu_rw_semaphore *brw, unsigned int val)
+{
+	bool success = false;
+
+	preempt_disable();
+	if (likely(!mutex_is_locked(&brw->writer_mutex))) {
+		__this_cpu_add(*brw->fast_read_ctr, val);
+		success = true;
+	}
+	preempt_enable();
+
+	return success;
+}
+
+/*
+ * Like the normal down_read() this is not recursive, the writer can
+ * come after the first percpu_down_read() and create the deadlock.
+ */
+void percpu_down_read(struct percpu_rw_semaphore *brw)
+{
+	if (likely(update_fast_ctr(brw, +1)))
+		return;
+
+	down_read(&brw->rw_sem);
+	atomic_inc(&brw->slow_read_ctr);
+	up_read(&brw->rw_sem);
+}
+
+void percpu_up_read(struct percpu_rw_semaphore *brw)
+{
+	if (likely(update_fast_ctr(brw, -1)))
+		return;
+
+	/* false-positive is possible but harmless */
+	if (atomic_dec_and_test(&brw->slow_read_ctr))
+		wake_up_all(&brw->write_waitq);
+}
+
+static int clear_fast_ctr(struct percpu_rw_semaphore *brw)
+{
+	unsigned int sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		sum += per_cpu(*brw->fast_read_ctr, cpu);
+		per_cpu(*brw->fast_read_ctr, cpu) = 0;
+	}
+
+	return sum;
+}
+
+/*
+ * A writer takes ->writer_mutex to exclude other writers and to force the
+ * readers to switch to the slow mode, note the mutex_is_locked() check in
+ * update_fast_ctr().
+ *
+ * After that the readers can only inc/dec the slow ->slow_read_ctr counter,
+ * ->fast_read_ctr is stable. Once the writer moves its sum into the slow
+ * counter it represents the number of active readers.
+ *
+ * Finally the writer takes ->rw_sem for writing and blocks the new readers,
+ * then waits until the slow counter becomes zero.
+ */
+void percpu_down_write(struct percpu_rw_semaphore *brw)
+{
+	/* also blocks update_fast_ctr() which checks mutex_is_locked() */
+	mutex_lock(&brw->writer_mutex);
+
+	/*
+	 * 1. Ensures mutex_is_locked() is visible to any down_read/up_read
+	 *    so that update_fast_ctr() can't succeed.
+	 *
+	 * 2. Ensures we see the result of every previous this_cpu_add() in
+	 *    update_fast_ctr().
+	 *
+	 * 3. Ensures that if any reader has exited its critical section via
+	 *    fast-path, it executes a full memory barrier before we return.
+	 */
+	synchronize_sched();
+
+	/* nobody can use fast_read_ctr, move its sum into slow_read_ctr */
+	atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
+
+	/* block the new readers completely */
+	down_write(&brw->rw_sem);
+
+	/* wait for all readers to complete their percpu_up_read() */
+	wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
+}
+
+void percpu_up_write(struct percpu_rw_semaphore *brw)
+{
+	/* allow the new readers, but only the slow-path */
+	up_write(&brw->rw_sem);
+
+	/* insert the barrier before the next fast-path in down_read */
+	synchronize_sched();
+
+	mutex_unlock(&brw->writer_mutex);
+}
-- 
1.5.5.1


