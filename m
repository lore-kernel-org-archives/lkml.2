Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0GTOKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:10:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:34295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab0GTOKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:10:22 -0400
Message-ID: <4C45AE48.4060009@kernel.org>
Date: Tue, 20 Jul 2010 16:10:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH wq#for-next] workqueue: fix mayday_mask handling on UP
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 14:10:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All cpumasks are assumed to have cpu 0 permanently set on UP, so it
can't be used to signify whether there's something to be done for the
CPU.  workqueue was using cpumask to track which CPU requested rescuer
assistance and this led rescuer thread to think there always are
pending mayday requests on UP, which resulted in infinite busy loops.

This patch fixes the problem by introducing mayday_mask_t and
associated helpers which wrap cpumask on SMP and emulates its behavior
using bitops and unsigned long on UP.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
Rusty, would it make sense to differentiate between constant cpumasks
(possible, online, present and active) and custom ones and deal the
latter as usual?  IMHO, the behavior change on UP seems too abrupt.

Thanks.

 kernel/workqueue.c |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 79a11e4..c11edc9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -186,6 +186,27 @@ struct wq_flusher {
 };

 /*
+ * All cpumasks are assumed to be always set on UP and thus can't be
+ * used to determine whether there's something to be done.
+ */
+#ifdef CONFIG_SMP
+typedef cpumask_var_t mayday_mask_t;
+#define mayday_test_and_set_cpu(cpu, mask)	\
+	cpumask_test_and_set_cpu((cpu), (mask))
+#define mayday_clear_cpu(cpu, mask)		cpumask_clear_cpu((cpu), (mask))
+#define for_each_mayday_cpu(cpu, mask)		for_each_cpu((cpu), (mask))
+#define alloc_mayday_mask(maskp, gfp)		alloc_cpumask_var((maskp), (gfp))
+#define free_mayday_mask(mask)			free_cpumask_var((mask))
+#else
+typedef unsigned long mayday_mask_t;
+#define mayday_test_and_set_cpu(cpu, mask)	test_and_set_bit(0, &(mask))
+#define mayday_clear_cpu(cpu, mask)		clear_bit(0, &(mask))
+#define for_each_mayday_cpu(cpu, mask)		if ((cpu) = 0, (mask))
+#define alloc_mayday_mask(maskp, gfp)		true
+#define free_mayday_mask(mask)			do { } while (0)
+#endif
+
+/*
  * The externally visible workqueue abstraction is an array of
  * per-CPU workqueues:
  */
@@ -206,7 +227,7 @@ struct workqueue_struct {
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */

-	cpumask_var_t		mayday_mask;	/* cpus requesting rescue */
+	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */

 	int			saved_max_active; /* W: saved cwq max_active */
@@ -1387,7 +1408,7 @@ static bool send_mayday(struct work_struct *work)
 	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
 	if (cpu == WORK_CPU_UNBOUND)
 		cpu = 0;
-	if (!cpumask_test_and_set_cpu(cpu, wq->mayday_mask))
+	if (!mayday_test_and_set_cpu(cpu, wq->mayday_mask))
 		wake_up_process(wq->rescuer->task);
 	return true;
 }
@@ -1915,14 +1936,14 @@ repeat:
 	 * See whether any cpu is asking for help.  Unbounded
 	 * workqueues use cpu 0 in mayday_mask for CPU_UNBOUND.
 	 */
-	for_each_cpu(cpu, wq->mayday_mask) {
+	for_each_mayday_cpu(cpu, wq->mayday_mask) {
 		unsigned int tcpu = is_unbound ? WORK_CPU_UNBOUND : cpu;
 		struct cpu_workqueue_struct *cwq = get_cwq(tcpu, wq);
 		struct global_cwq *gcwq = cwq->gcwq;
 		struct work_struct *work, *n;

 		__set_current_state(TASK_RUNNING);
-		cpumask_clear_cpu(cpu, wq->mayday_mask);
+		mayday_clear_cpu(cpu, wq->mayday_mask);

 		/* migrate to the target cpu if possible */
 		rescuer->gcwq = gcwq;
@@ -2724,7 +2745,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	if (flags & WQ_RESCUER) {
 		struct worker *rescuer;

-		if (!alloc_cpumask_var(&wq->mayday_mask, GFP_KERNEL))
+		if (!alloc_mayday_mask(&wq->mayday_mask, GFP_KERNEL))
 			goto err;

 		wq->rescuer = rescuer = alloc_worker();
@@ -2759,7 +2780,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 err:
 	if (wq) {
 		free_cwqs(wq);
-		free_cpumask_var(wq->mayday_mask);
+		free_mayday_mask(wq->mayday_mask);
 		kfree(wq->rescuer);
 		kfree(wq);
 	}
@@ -2800,7 +2821,7 @@ void destroy_workqueue(struct workqueue_struct *wq)

 	if (wq->flags & WQ_RESCUER) {
 		kthread_stop(wq->rescuer->task);
-		free_cpumask_var(wq->mayday_mask);
+		free_mayday_mask(wq->mayday_mask);
 	}

 	free_cwqs(wq);
-- 
1.6.4.2

