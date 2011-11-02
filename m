Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1KBUbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:31:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59118 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab1KBUbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 24/28] rcu: Introduce bulk reference count
Date: Wed,  2 Nov 2011 13:30:45 -0700
Message-Id: <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5930-0000-0000-000000D63604
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU implementations, including SRCU, are designed to be used in a
lock-like fashion, so that the read-side lock and unlock primitives must
execute in the same context for any given read-side critical section.
This constraint is enforced by lockdep-RCU.  However, there is a need for
something that acts more like a reference count than a lock, in order
to allow (for example) the reference to be acquired within the context
of an exception, while that same reference is released in the context of
the task that encountered the exception.  The cost of this capability is
that the read-side operations incur the overhead of disabling interrupts.
Some optimization is possible, and will be carried out if warranted.

Note that although the current implementation allows a given reference to
be acquired by one task and then released by another, all known possible
implementations that allow this have scalability problems.  Therefore,
a given reference must be released by the same task that acquired it,
though perhaps from an interrupt or exception handler running within
that task's context.

Requested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/srcu.h |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/srcu.c        |    3 ++-
 2 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index d4b1244..d5334d0 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -181,4 +181,54 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__srcu_read_unlock(sp, idx);
 }
 
+/* Definitions for bulkref_t, currently defined in terms of SRCU. */
+
+typedef struct srcu_struct bulkref_t;
+int init_srcu_struct_fields(struct srcu_struct *sp);
+
+static inline int init_bulkref(bulkref_t *brp)
+{
+	return init_srcu_struct_fields(brp);
+}
+
+static inline void cleanup_bulkref(bulkref_t *brp)
+{
+	cleanup_srcu_struct(brp);
+}
+
+static inline int bulkref_get(bulkref_t *brp)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	ret =  __srcu_read_lock(brp);
+	local_irq_restore(flags);
+	return ret;
+}
+
+static inline void bulkref_put(bulkref_t *brp, int idx)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__srcu_read_unlock(brp, idx);
+	local_irq_restore(flags);
+}
+
+static inline void bulkref_wait_old(bulkref_t *brp)
+{
+	synchronize_srcu(brp);
+}
+
+static inline void bulkref_wait_old_expedited(bulkref_t *brp)
+{
+	synchronize_srcu_expedited(brp);
+}
+
+static inline long bulkref_batches_completed(bulkref_t *brp)
+{
+	return srcu_batches_completed(brp);
+}
+
 #endif
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 73ce23f..10214c8 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -34,13 +34,14 @@
 #include <linux/delay.h>
 #include <linux/srcu.h>
 
-static int init_srcu_struct_fields(struct srcu_struct *sp)
+int init_srcu_struct_fields(struct srcu_struct *sp)
 {
 	sp->completed = 0;
 	mutex_init(&sp->mutex);
 	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
 	return sp->per_cpu_ref ? 0 : -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(init_srcu_struct_fields);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-- 
1.7.3.2

