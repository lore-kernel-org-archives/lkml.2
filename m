Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab2EHUPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:15:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41738 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab2EHUPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:15:37 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Arjan van de Veen <arjan@infradead.org>
Subject: [PATCH] [RFC] sched/drm: add infrastructure for gpu waits
Date: Tue,  8 May 2012 22:16:41 +0200
Message-Id: <1336508201-16780-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a quick hack inspired by Arjan to help the ondemand cpufreq
governor a bit in figuring out what should be done. A similar trick is
used for io related waits to ensure that the cpu can pick up right
away.

Some benchmarking shows squat gains, and for the bugs we manage to
track down to ondemand doing something suboptimal, it doesn't help
either. So I'll just toss this over the wall as an rfc.

v2: Arjan van der Veen pointed out the the inc/dec needs to happen on
the same runqueue, so pass back the cpu id from _begin and use that in
_end.

Cc: Arjan van de Veen <arjan@infradead.org>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |    3 +++
 include/linux/sched.h           |    3 +++
 kernel/sched/core.c             |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 44a5f24..6630fd8 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1873,6 +1873,7 @@ static int __wait_seqno(struct intel_ring_buffer *ring, u32 seqno,
 {
 	drm_i915_private_t *dev_priv = ring->dev->dev_private;
 	int ret = 0;
+	int cpu;
 
 	if (i915_seqno_passed(ring->get_seqno(ring), seqno))
 		return 0;
@@ -1881,6 +1882,7 @@ static int __wait_seqno(struct intel_ring_buffer *ring, u32 seqno,
 	if (WARN_ON(!ring->irq_get(ring)))
 		return -ENODEV;
 
+	cpu = gpu_wait_begin();
 #define EXIT_COND \
 	(i915_seqno_passed(ring->get_seqno(ring), seqno) || \
 	atomic_read(&dev_priv->mm.wedged))
@@ -1894,6 +1896,7 @@ static int __wait_seqno(struct intel_ring_buffer *ring, u32 seqno,
 	ring->irq_put(ring);
 	trace_i915_gem_request_wait_end(ring, seqno);
 #undef EXIT_COND
+	gpu_wait_end(cpu);
 
 	return ret;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 81a173c..c3bf19e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -301,6 +301,9 @@ extern void show_stack(struct task_struct *task, unsigned long *sp);
 void io_schedule(void);
 long io_schedule_timeout(long timeout);
 
+int gpu_wait_begin(void);
+void gpu_wait_end(int cpu);
+
 extern void cpu_init (void);
 extern void trap_init(void);
 extern void update_process_times(int user);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0533a68..d6b0469 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4708,6 +4708,7 @@ void __sched io_schedule(void)
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
 	blk_flush_plug(current);
+	WARN_ON(current->in_iowait);
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;
@@ -4732,6 +4733,38 @@ long __sched io_schedule_timeout(long timeout)
 	return ret;
 }
 
+/*
+ * gpu_wait_begin/end
+ *
+ * Mark the task as stalling for an offload engine (most often a gpu). Waits
+ * done in-between will be accounted as performance-critical sections and
+ * prevent the ondemand cpu governor from clocking down the cpu.
+ *
+ * Calls may not nest.
+ */
+int gpu_wait_begin(void)
+{
+	int cpu = smp_processor_id();
+	struct rq *rq = cpu_rq(cpu);
+
+	atomic_inc(&rq->nr_iowait);
+	WARN_ON(current->in_iowait);
+	current->in_iowait = 1;
+
+	return cpu;
+}
+EXPORT_SYMBOL(gpu_wait_begin);
+
+void gpu_wait_end(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	atomic_dec(&rq->nr_iowait);
+	WARN_ON(!current->in_iowait);
+	current->in_iowait = 0;
+}
+EXPORT_SYMBOL(gpu_wait_end);
+
 /**
  * sys_sched_get_priority_max - return maximum RT priority.
  * @policy: scheduling class.
-- 
1.7.10

