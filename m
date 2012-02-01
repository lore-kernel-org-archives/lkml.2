Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2BATnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:00 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44670 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab2BATm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:42:56 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 05/41] rcu: Avoid waking up CPUs having only kfree_rcu() callbacks
Date: Wed,  1 Feb 2012 11:41:23 -0800
Message-Id: <1328125319-5205-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5518-0000-0000-000001F05DD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

When CONFIG_RCU_FAST_NO_HZ is enabled, RCU will allow a given CPU to
enter dyntick-idle mode even if it still has RCU callbacks queued.
RCU avoids system hangs in this case by scheduling a timer for several
jiffies in the future.  However, if all of the callbacks on that CPU
are from kfree_rcu(), there is no reason to wake the CPU up, as it is
not a problem to defer freeing of memory.

This commit therefore tracks the number of callbacks on a given CPU
that are from kfree_rcu(), and avoids scheduling the timer if all of
a given CPU's callbacks are from kfree_rcu().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h   |    2 +-
 include/linux/rcutiny.h    |    6 +++
 include/linux/rcutree.h    |    2 +
 include/trace/events/rcu.h |   63 +++++++++++++++++++++-------------
 kernel/rcu.h               |    4 ++-
 kernel/rcutiny.c           |    4 +-
 kernel/rcutree.c           |   29 ++++++++++------
 kernel/rcutree.h           |    3 +-
 kernel/rcutree_plugin.h    |   79 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/rcutree_trace.c     |    8 ++--
 10 files changed, 153 insertions(+), 47 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 81c04f4..a67d5f1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -841,7 +841,7 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 	/* See the kfree_rcu() header comment. */
 	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
 
-	call_rcu(head, (rcu_callback)offset);
+	kfree_call_rcu(head, (rcu_callback)offset);
 }
 
 /**
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 00b7a5e..51bf29c 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -83,6 +83,12 @@ static inline void synchronize_sched_expedited(void)
 	synchronize_sched();
 }
 
+static inline void kfree_call_rcu(struct rcu_head *head,
+				  void (*func)(struct rcu_head *rcu))
+{
+	call_rcu(head, func);
+}
+
 #ifdef CONFIG_TINY_RCU
 
 static inline void rcu_preempt_note_context_switch(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 73e7195..7389248 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -61,6 +61,8 @@ extern void synchronize_rcu_bh(void);
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
 
+void kfree_call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
+
 static inline void synchronize_rcu_bh_expedited(void)
 {
 	synchronize_sched_expedited();
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index d2d88be..3370997 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -313,19 +313,22 @@ TRACE_EVENT(rcu_prep_idle,
 /*
  * Tracepoint for the registration of a single RCU callback function.
  * The first argument is the type of RCU, the second argument is
- * a pointer to the RCU callback itself, and the third element is the
- * new RCU callback queue length for the current CPU.
+ * a pointer to the RCU callback itself, the third element is the
+ * number of lazy callbacks queued, and the fourth element is the
+ * total number of callbacks queued.
  */
 TRACE_EVENT(rcu_callback,
 
-	TP_PROTO(char *rcuname, struct rcu_head *rhp, long qlen),
+	TP_PROTO(char *rcuname, struct rcu_head *rhp, long qlen_lazy,
+		 long qlen),
 
-	TP_ARGS(rcuname, rhp, qlen),
+	TP_ARGS(rcuname, rhp, qlen_lazy, qlen),
 
 	TP_STRUCT__entry(
 		__field(char *, rcuname)
 		__field(void *, rhp)
 		__field(void *, func)
+		__field(long, qlen_lazy)
 		__field(long, qlen)
 	),
 
@@ -333,11 +336,13 @@ TRACE_EVENT(rcu_callback,
 		__entry->rcuname = rcuname;
 		__entry->rhp = rhp;
 		__entry->func = rhp->func;
+		__entry->qlen_lazy = qlen_lazy;
 		__entry->qlen = qlen;
 	),
 
-	TP_printk("%s rhp=%p func=%pf %ld",
-		  __entry->rcuname, __entry->rhp, __entry->func, __entry->qlen)
+	TP_printk("%s rhp=%p func=%pf %ld/%ld",
+		  __entry->rcuname, __entry->rhp, __entry->func,
+		  __entry->qlen_lazy, __entry->qlen)
 );
 
 /*
@@ -345,20 +350,21 @@ TRACE_EVENT(rcu_callback,
  * kfree() form.  The first argument is the RCU type, the second argument
  * is a pointer to the RCU callback, the third argument is the offset
  * of the callback within the enclosing RCU-protected data structure,
- * and the fourth argument is the new RCU callback queue length for the
- * current CPU.
+ * the fourth argument is the number of lazy callbacks queued, and the
+ * fifth argument is the total number of callbacks queued.
  */
 TRACE_EVENT(rcu_kfree_callback,
 
 	TP_PROTO(char *rcuname, struct rcu_head *rhp, unsigned long offset,
-		 long qlen),
+		 long qlen_lazy, long qlen),
 
-	TP_ARGS(rcuname, rhp, offset, qlen),
+	TP_ARGS(rcuname, rhp, offset, qlen_lazy, qlen),
 
 	TP_STRUCT__entry(
 		__field(char *, rcuname)
 		__field(void *, rhp)
 		__field(unsigned long, offset)
+		__field(long, qlen_lazy)
 		__field(long, qlen)
 	),
 
@@ -366,41 +372,45 @@ TRACE_EVENT(rcu_kfree_callback,
 		__entry->rcuname = rcuname;
 		__entry->rhp = rhp;
 		__entry->offset = offset;
+		__entry->qlen_lazy = qlen_lazy;
 		__entry->qlen = qlen;
 	),
 
-	TP_printk("%s rhp=%p func=%ld %ld",
+	TP_printk("%s rhp=%p func=%ld %ld/%ld",
 		  __entry->rcuname, __entry->rhp, __entry->offset,
-		  __entry->qlen)
+		  __entry->qlen_lazy, __entry->qlen)
 );
 
 /*
  * Tracepoint for marking the beginning rcu_do_batch, performed to start
  * RCU callback invocation.  The first argument is the RCU flavor,
- * the second is the total number of callbacks (including those that
- * are not yet ready to be invoked), and the third argument is the
- * current RCU-callback batch limit.
+ * the second is the number of lazy callbacks queued, the third is
+ * the total number of callbacks queued, and the fourth argument is
+ * the current RCU-callback batch limit.
  */
 TRACE_EVENT(rcu_batch_start,
 
-	TP_PROTO(char *rcuname, long qlen, int blimit),
+	TP_PROTO(char *rcuname, long qlen_lazy, long qlen, int blimit),
 
-	TP_ARGS(rcuname, qlen, blimit),
+	TP_ARGS(rcuname, qlen_lazy, qlen, blimit),
 
 	TP_STRUCT__entry(
 		__field(char *, rcuname)
+		__field(long, qlen_lazy)
 		__field(long, qlen)
 		__field(int, blimit)
 	),
 
 	TP_fast_assign(
 		__entry->rcuname = rcuname;
+		__entry->qlen_lazy = qlen_lazy;
 		__entry->qlen = qlen;
 		__entry->blimit = blimit;
 	),
 
-	TP_printk("%s CBs=%ld bl=%d",
-		  __entry->rcuname, __entry->qlen, __entry->blimit)
+	TP_printk("%s CBs=%ld/%ld bl=%d",
+		  __entry->rcuname, __entry->qlen_lazy, __entry->qlen,
+		  __entry->blimit)
 );
 
 /*
@@ -531,16 +541,21 @@ TRACE_EVENT(rcu_torture_read,
 #else /* #ifdef CONFIG_RCU_TRACE */
 
 #define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
-#define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, qsmask) do { } while (0)
+#define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, \
+				    qsmask) do { } while (0)
 #define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
-#define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks) do { } while (0)
+#define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, \
+					 grplo, grphi, gp_tasks) do { } \
+	while (0)
 #define trace_rcu_fqs(rcuname, gpnum, cpu, qsevent) do { } while (0)
 #define trace_rcu_dyntick(polarity, oldnesting, newnesting) do { } while (0)
 #define trace_rcu_prep_idle(reason) do { } while (0)
-#define trace_rcu_callback(rcuname, rhp, qlen) do { } while (0)
-#define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen) do { } while (0)
-#define trace_rcu_batch_start(rcuname, qlen, blimit) do { } while (0)
+#define trace_rcu_callback(rcuname, rhp, qlen_lazy, qlen) do { } while (0)
+#define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen_lazy, qlen) \
+	do { } while (0)
+#define trace_rcu_batch_start(rcuname, qlen_lazy, qlen, blimit) \
+	do { } while (0)
 #define trace_rcu_invoke_callback(rcuname, rhp) do { } while (0)
 #define trace_rcu_invoke_kfree_callback(rcuname, rhp, offset) do { } while (0)
 #define trace_rcu_batch_end(rcuname, callbacks_invoked, cb, nr, iit, risk) \
diff --git a/kernel/rcu.h b/kernel/rcu.h
index aa88baa..a074b0b 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -76,16 +76,18 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 
 extern void kfree(const void *);
 
-static inline void __rcu_reclaim(char *rn, struct rcu_head *head)
+static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
 
 	if (__is_kfree_rcu_offset(offset)) {
 		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
 		kfree((void *)head - offset);
+		return 1;
 	} else {
 		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
 		head->func(head);
+		return 0;
 	}
 }
 
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 904cda9..b36d1dc 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -258,7 +258,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 
 	/* If no RCU callbacks ready to invoke, just return. */
 	if (&rcp->rcucblist == rcp->donetail) {
-		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
+		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, 0, -1));
 		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0,
 					      ACCESS_ONCE(rcp->rcucblist),
 					      need_resched(),
@@ -269,7 +269,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 
 	/* Move the ready-to-invoke callbacks to a local list. */
 	local_irq_save(flags);
-	RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
+	RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, rcp->qlen, -1));
 	list = rcp->rcucblist;
 	rcp->rcucblist = *rcp->donetail;
 	*rcp->donetail = NULL;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4655f3e..96c1c4a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1261,6 +1261,7 @@ static void rcu_send_cbs_to_online(struct rcu_state *rsp)
 
 	*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
 	receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	receive_rdp->qlen_lazy += rdp->qlen_lazy;
 	receive_rdp->qlen += rdp->qlen;
 	receive_rdp->n_cbs_adopted += rdp->qlen;
 	rdp->n_cbs_orphaned += rdp->qlen;
@@ -1268,6 +1269,7 @@ static void rcu_send_cbs_to_online(struct rcu_state *rsp)
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
+	rdp->qlen_lazy = 0;
 	rdp->qlen = 0;
 }
 
@@ -1368,11 +1370,11 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count;
+	int bl, count, count_lazy;
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
-		trace_rcu_batch_start(rsp->name, 0, 0);
+		trace_rcu_batch_start(rsp->name, rdp->qlen_lazy, rdp->qlen, 0);
 		trace_rcu_batch_end(rsp->name, 0, !!ACCESS_ONCE(rdp->nxtlist),
 				    need_resched(), is_idle_task(current),
 				    rcu_is_callbacks_kthread());
@@ -1385,7 +1387,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	 */
 	local_irq_save(flags);
 	bl = rdp->blimit;
-	trace_rcu_batch_start(rsp->name, rdp->qlen, bl);
+	trace_rcu_batch_start(rsp->name, rdp->qlen_lazy, rdp->qlen, bl);
 	list = rdp->nxtlist;
 	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
 	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
@@ -1396,12 +1398,13 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	local_irq_restore(flags);
 
 	/* Invoke callbacks. */
-	count = 0;
+	count = count_lazy = 0;
 	while (list) {
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
-		__rcu_reclaim(rsp->name, list);
+		if (__rcu_reclaim(rsp->name, list))
+			count_lazy++;
 		list = next;
 		/* Stop only if limit reached and CPU has something to do. */
 		if (++count >= bl &&
@@ -1416,6 +1419,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 			    rcu_is_callbacks_kthread());
 
 	/* Update count, and requeue any remaining callbacks. */
+	rdp->qlen_lazy -= count_lazy;
 	rdp->qlen -= count;
 	rdp->n_cbs_invoked += count;
 	if (list != NULL) {
@@ -1702,7 +1706,7 @@ static void invoke_rcu_core(void)
 
 static void
 __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
-	   struct rcu_state *rsp)
+	   struct rcu_state *rsp, bool lazy)
 {
 	unsigned long flags;
 	struct rcu_data *rdp;
@@ -1727,12 +1731,14 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	*rdp->nxttail[RCU_NEXT_TAIL] = head;
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 	rdp->qlen++;
+	if (lazy)
+		rdp->qlen_lazy++;
 
 	if (__is_kfree_rcu_offset((unsigned long)func))
 		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
-					 rdp->qlen);
+					 rdp->qlen_lazy, rdp->qlen);
 	else
-		trace_rcu_callback(rsp->name, head, rdp->qlen);
+		trace_rcu_callback(rsp->name, head, rdp->qlen_lazy, rdp->qlen);
 
 	/* If interrupts were disabled, don't dive into RCU core. */
 	if (irqs_disabled_flags(flags)) {
@@ -1779,16 +1785,16 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
  */
 void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_sched_state);
+	__call_rcu(head, func, &rcu_sched_state, 0);
 }
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
 /*
- * Queue an RCU for invocation after a quicker grace period.
+ * Queue an RCU callback for invocation after a quicker grace period.
  */
 void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_bh_state);
+	__call_rcu(head, func, &rcu_bh_state, 0);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
@@ -2034,6 +2040,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
+	rdp->qlen_lazy = 0;
 	rdp->qlen = 0;
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index fddff92..af2af3c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -265,7 +265,8 @@ struct rcu_data {
 	 */
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
-	long		qlen;		/* # of queued callbacks */
+	long		qlen_lazy;	/* # of lazy queued callbacks */
+	long		qlen;		/* # of queued callbacks, incl lazy */
 	long		qlen_last_fqs_check;
 					/* qlen at last check for QS forcing */
 	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index cc07bce..0a0013c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -671,10 +671,24 @@ static void rcu_preempt_do_callbacks(void)
  */
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_preempt_state);
+	__call_rcu(head, func, &rcu_preempt_state, 0);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
+/*
+ * Queue an RCU callback for lazy invocation after a grace period.
+ * This will likely be later named something like "call_rcu_lazy()",
+ * but this change will require some way of tagging the lazy RCU
+ * callbacks in the list of pending callbacks.  Until then, this
+ * function may only be called from __kfree_rcu().
+ */
+void kfree_call_rcu(struct rcu_head *head,
+		    void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_preempt_state, 1);
+}
+EXPORT_SYMBOL_GPL(kfree_call_rcu);
+
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -1064,6 +1078,22 @@ static void rcu_preempt_process_callbacks(void)
 }
 
 /*
+ * Queue an RCU callback for lazy invocation after a grace period.
+ * This will likely be later named something like "call_rcu_lazy()",
+ * but this change will require some way of tagging the lazy RCU
+ * callbacks in the list of pending callbacks.  Until then, this
+ * function may only be called from __kfree_rcu().
+ *
+ * Because there is no preemptible RCU, we use RCU-sched instead.
+ */
+void kfree_call_rcu(struct rcu_head *head,
+		    void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_sched_state, 1);
+}
+EXPORT_SYMBOL_GPL(kfree_call_rcu);
+
+/*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
  * But because preemptible RCU does not exist, map to rcu-sched.
  */
@@ -2051,6 +2081,48 @@ int rcu_needs_cpu(int cpu)
 }
 
 /*
+ * Does the specified flavor of RCU have non-lazy callbacks pending on
+ * the specified CPU?  Both RCU flavor and CPU are specified by the
+ * rcu_data structure.
+ */
+static bool __rcu_cpu_has_nonlazy_callbacks(struct rcu_data *rdp)
+{
+	return rdp->qlen != rdp->qlen_lazy;
+}
+
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
+/*
+ * Are there non-lazy RCU-preempt callbacks?  (There cannot be if there
+ * is no RCU-preempt in the kernel.)
+ */
+static bool rcu_preempt_cpu_has_nonlazy_callbacks(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
+
+	return __rcu_cpu_has_nonlazy_callbacks(rdp);
+}
+
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+static bool rcu_preempt_cpu_has_nonlazy_callbacks(int cpu)
+{
+	return 0;
+}
+
+#endif /* else #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+/*
+ * Does any flavor of RCU have non-lazy callbacks on the specified CPU?
+ */
+static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
+{
+	return __rcu_cpu_has_nonlazy_callbacks(&per_cpu(rcu_sched_data, cpu)) ||
+	       __rcu_cpu_has_nonlazy_callbacks(&per_cpu(rcu_bh_data, cpu)) ||
+	       rcu_preempt_cpu_has_nonlazy_callbacks(cpu);
+}
+
+/*
  * Timer handler used to force CPU to start pushing its remaining RCU
  * callbacks in the case where it entered dyntick-idle mode with callbacks
  * pending.  The hander doesn't really need to do anything because the
@@ -2148,8 +2220,9 @@ static void rcu_prepare_for_idle(int cpu)
 		trace_rcu_prep_idle("Dyntick with callbacks");
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
-		hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-			      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+		if (rcu_cpu_has_nonlazy_callbacks(cpu))
+			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
+				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
 		return; /* Nothing more to do immediately. */
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 654cfe6..db0987c 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -73,8 +73,8 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld qs=%c%c%c%c",
-		   rdp->qlen,
+	seq_printf(m, " ql=%ld/%ld qs=%c%c%c%c",
+		   rdp->qlen_lazy, rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
 		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
@@ -145,7 +145,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,\"%c%c%c%c\"", rdp->qlen,
+	seq_printf(m, ",%ld,%ld,\"%c%c%c%c\"", rdp->qlen_lazy, rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
 		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
@@ -168,7 +168,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-	seq_puts(m, "\"of\",\"ri\",\"ql\",\"qs\"");
+	seq_puts(m, "\"of\",\"ri\",\"qll\",\"ql\",\"qs\"");
 #ifdef CONFIG_RCU_BOOST
 	seq_puts(m, "\"kt\",\"ktl\"");
 #endif /* #ifdef CONFIG_RCU_BOOST */
-- 
1.7.8

