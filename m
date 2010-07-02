Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab0GBJTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:19:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64281 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab0GBJTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WxclsCaE38A/jjfU2X+uh6W29uIwrndYUy8L3byGwItftfiHKAZtHt142+Jyaw4pOU
         BBsqhMJ0eVTuiXXc3rp3sXU2sf9Jd5w32Fe0HwlM6ZB4pHntrTluOG5bWkZtD6cguemt
         yBlMTGOS59tkZQZONl4rjykbs4kEPb0XigRHk=
Message-ID: <4C2DAF32.5040807@gmail.com>
Date: Fri, 02 Jul 2010 11:19:46 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 1/4] workqueue: prepare for WQ_UNBOUND implementation
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com> <4C2DAEBB.7090607@kernel.org>
In-Reply-To: <4C2DAEBB.7090607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of WQ_UNBOUND addition, make the following changes.

* Add WORK_CPU_* constants for pseudo cpu id numbers used (currently
  only WORK_CPU_NONE) and use them instead of NR_CPUS.  This is to
  allow another pseudo cpu id for unbound cpu.

* Reorder WQ_* flags.

* Make workqueue_struct->cpu_wq a union which contains a percpu
  pointer, regular pointer and an unsigned long value and use
  kzalloc/kfree() in UP allocation path.  This will be used to
  implement unbound workqueues which will use only one cwq on SMPs.

* Move alloc_cwqs() allocation after initialization of wq fields, so
  that alloc_cwqs() has access to wq->flags.

* Trivial relocation of wq local variables in freeze functions.

These changes don't cause any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   10 ++++--
 kernel/workqueue.c        |   83 +++++++++++++++++++++++---------------------
 2 files changed, 50 insertions(+), 43 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 3f36d37..139069a 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -50,6 +50,10 @@ enum {
 	WORK_NR_COLORS		= (1 << WORK_STRUCT_COLOR_BITS) - 1,
 	WORK_NO_COLOR		= WORK_NR_COLORS,

+	/* special cpu IDs */
+	WORK_CPU_NONE		= NR_CPUS,
+	WORK_CPU_LAST		= WORK_CPU_NONE,
+
 	/*
 	 * Reserve 6 bits off of cwq pointer w/ debugobjects turned
 	 * off.  This makes cwqs aligned to 64 bytes which isn't too
@@ -60,7 +64,7 @@ enum {

 	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
-	WORK_STRUCT_NO_CPU	= NR_CPUS << WORK_STRUCT_FLAG_BITS,
+	WORK_STRUCT_NO_CPU	= WORK_CPU_NONE << WORK_STRUCT_FLAG_BITS,

 	/* bit mask for work_busy() return values */
 	WORK_BUSY_PENDING	= 1 << 0,
@@ -227,9 +231,9 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 	clear_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))

 enum {
-	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
+	WQ_NON_REENTRANT	= 1 << 0, /* guarantee non-reentrance */
 	WQ_SINGLE_CPU		= 1 << 1, /* only single cpu at a time */
-	WQ_NON_REENTRANT	= 1 << 2, /* guarantee non-reentrance */
+	WQ_FREEZEABLE		= 1 << 2, /* freeze during suspend */
 	WQ_RESCUER		= 1 << 3, /* has an rescue worker */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2eb9fbd..a105ddf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -190,7 +190,11 @@ struct wq_flusher {
  */
 struct workqueue_struct {
 	unsigned int		flags;		/* I: WQ_* flags */
-	struct cpu_workqueue_struct *cpu_wq;	/* I: cwq's */
+	union {
+		struct cpu_workqueue_struct __percpu	*pcpu;
+		struct cpu_workqueue_struct		*single;
+		unsigned long				v;
+	} cpu_wq;				/* I: cwq's */
 	struct list_head	list;		/* W: list of all workqueues */

 	struct mutex		flush_mutex;	/* protects wq flushing */
@@ -362,7 +366,11 @@ static atomic_t *get_gcwq_nr_running(unsigned int cpu)
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 					    struct workqueue_struct *wq)
 {
-	return per_cpu_ptr(wq->cpu_wq, cpu);
+#ifndef CONFIG_SMP
+	return wq->cpu_wq.single;
+#else
+	return per_cpu_ptr(wq->cpu_wq.pcpu, cpu);
+#endif
 }

 static unsigned int work_color_to_flags(int color)
@@ -442,7 +450,7 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 		return ((struct cpu_workqueue_struct *)data)->gcwq;

 	cpu = data >> WORK_STRUCT_FLAG_BITS;
-	if (cpu == NR_CPUS)
+	if (cpu == WORK_CPU_NONE)
 		return NULL;

 	BUG_ON(cpu >= nr_cpu_ids);
@@ -846,7 +854,7 @@ static void cwq_unbind_single_cpu(struct cpu_workqueue_struct *cwq)
 	 */
 	if (likely(!(gcwq->flags & GCWQ_FREEZING))) {
 		smp_wmb();	/* paired with cmpxchg() in __queue_work() */
-		wq->single_cpu = NR_CPUS;
+		wq->single_cpu = WORK_CPU_NONE;
 	}
 }

@@ -904,7 +912,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		 */
 	retry:
 		cpu = wq->single_cpu;
-		arbitrate = cpu == NR_CPUS;
+		arbitrate = cpu == WORK_CPU_NONE;
 		if (arbitrate)
 			cpu = req_cpu;

@@ -918,7 +926,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		 * visible on the new cpu after this point.
 		 */
 		if (arbitrate)
-			cmpxchg(&wq->single_cpu, NR_CPUS, cpu);
+			cmpxchg(&wq->single_cpu, WORK_CPU_NONE, cpu);

 		if (unlikely(wq->single_cpu != cpu)) {
 			spin_unlock_irqrestore(&gcwq->lock, flags);
@@ -2572,7 +2580,7 @@ int keventd_up(void)
 	return system_wq != NULL;
 }

-static struct cpu_workqueue_struct *alloc_cwqs(void)
+static int alloc_cwqs(struct workqueue_struct *wq)
 {
 	/*
 	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
@@ -2582,40 +2590,36 @@ static struct cpu_workqueue_struct *alloc_cwqs(void)
 	const size_t size = sizeof(struct cpu_workqueue_struct);
 	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
 				   __alignof__(unsigned long long));
-	struct cpu_workqueue_struct *cwqs;
 #ifndef CONFIG_SMP
 	void *ptr;

 	/*
-	 * On UP, percpu allocator doesn't honor alignment parameter
-	 * and simply uses arch-dependent default.  Allocate enough
-	 * room to align cwq and put an extra pointer at the end
-	 * pointing back to the originally allocated pointer which
-	 * will be used for free.
-	 *
-	 * FIXME: This really belongs to UP percpu code.  Update UP
-	 * percpu code to honor alignment and remove this ugliness.
+	 * Allocate enough room to align cwq and put an extra pointer
+	 * at the end pointing back to the originally allocated
+	 * pointer which will be used for free.
 	 */
-	ptr = __alloc_percpu(size + align + sizeof(void *), 1);
-	cwqs = PTR_ALIGN(ptr, align);
-	*(void **)per_cpu_ptr(cwqs + 1, 0) = ptr;
+	ptr = kzalloc(size + align + sizeof(void *), GFP_KERNEL);
+	if (ptr) {
+		wq->cpu_wq.single = PTR_ALIGN(ptr, align);
+		*(void **)(wq->cpu_wq.single + 1) = ptr;
+	}
 #else
-	/* On SMP, percpu allocator can do it itself */
-	cwqs = __alloc_percpu(size, align);
+	/* On SMP, percpu allocator can align itself */
+	wq->cpu_wq.pcpu = __alloc_percpu(size, align);
 #endif
 	/* just in case, make sure it's actually aligned */
-	BUG_ON(!IS_ALIGNED((unsigned long)cwqs, align));
-	return cwqs;
+	BUG_ON(!IS_ALIGNED(wq->cpu_wq.v, align));
+	return wq->cpu_wq.v ? 0 : -ENOMEM;
 }

-static void free_cwqs(struct cpu_workqueue_struct *cwqs)
+static void free_cwqs(struct workqueue_struct *wq)
 {
 #ifndef CONFIG_SMP
 	/* on UP, the pointer to free is stored right after the cwq */
-	if (cwqs)
-		free_percpu(*(void **)per_cpu_ptr(cwqs + 1, 0));
+	if (wq->cpu_wq.single)
+		kfree(*(void **)(wq->cpu_wq.single + 1));
 #else
-	free_percpu(cwqs);
+	free_percpu(wq->cpu_wq.pcpu);
 #endif
 }

@@ -2645,22 +2649,21 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	if (!wq)
 		goto err;

-	wq->cpu_wq = alloc_cwqs();
-	if (!wq->cpu_wq)
-		goto err;
-
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
 	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
-	wq->single_cpu = NR_CPUS;
+	wq->single_cpu = WORK_CPU_NONE;

 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);

+	if (alloc_cwqs(wq) < 0)
+		goto err;
+
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct global_cwq *gcwq = get_gcwq(cpu);
@@ -2710,7 +2713,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	return wq;
 err:
 	if (wq) {
-		free_cwqs(wq->cpu_wq);
+		free_cwqs(wq);
 		free_cpumask_var(wq->mayday_mask);
 		kfree(wq->rescuer);
 		kfree(wq);
@@ -2755,7 +2758,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 		free_cpumask_var(wq->mayday_mask);
 	}

-	free_cwqs(wq->cpu_wq);
+	free_cwqs(wq);
 	kfree(wq);
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
@@ -2821,13 +2824,13 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  * @work: the work of interest
  *
  * RETURNS:
- * CPU number if @work was ever queued.  NR_CPUS otherwise.
+ * CPU number if @work was ever queued.  WORK_CPU_NONE otherwise.
  */
 unsigned int work_cpu(struct work_struct *work)
 {
 	struct global_cwq *gcwq = get_work_gcwq(work);

-	return gcwq ? gcwq->cpu : NR_CPUS;
+	return gcwq ? gcwq->cpu : WORK_CPU_NONE;
 }
 EXPORT_SYMBOL_GPL(work_cpu);

@@ -3300,7 +3303,6 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  */
 void freeze_workqueues_begin(void)
 {
-	struct workqueue_struct *wq;
 	unsigned int cpu;

 	spin_lock(&workqueue_lock);
@@ -3310,6 +3312,7 @@ void freeze_workqueues_begin(void)

 	for_each_possible_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct workqueue_struct *wq;

 		spin_lock_irq(&gcwq->lock);

@@ -3344,7 +3347,6 @@ void freeze_workqueues_begin(void)
  */
 bool freeze_workqueues_busy(void)
 {
-	struct workqueue_struct *wq;
 	unsigned int cpu;
 	bool busy = false;

@@ -3353,6 +3355,7 @@ bool freeze_workqueues_busy(void)
 	BUG_ON(!workqueue_freezing);

 	for_each_possible_cpu(cpu) {
+		struct workqueue_struct *wq;
 		/*
 		 * nr_active is monotonically decreasing.  It's safe
 		 * to peek without lock.
@@ -3386,7 +3389,6 @@ out_unlock:
  */
 void thaw_workqueues(void)
 {
-	struct workqueue_struct *wq;
 	unsigned int cpu;

 	spin_lock(&workqueue_lock);
@@ -3396,6 +3398,7 @@ void thaw_workqueues(void)

 	for_each_possible_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct workqueue_struct *wq;

 		spin_lock_irq(&gcwq->lock);

@@ -3443,7 +3446,7 @@ void __init init_workqueues(void)
 	 * sure cpu number won't overflow into kernel pointer area so
 	 * that they can be distinguished.
 	 */
-	BUILD_BUG_ON(NR_CPUS << WORK_STRUCT_FLAG_BITS >= PAGE_OFFSET);
+	BUILD_BUG_ON(WORK_CPU_LAST << WORK_STRUCT_FLAG_BITS >= PAGE_OFFSET);

 	hotcpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);

-- 
1.6.4.2

