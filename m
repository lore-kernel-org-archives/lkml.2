Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0F2IOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:14:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:52686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab0F2IOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:14:20 -0400
Message-ID: <4C29AADD.1070503@kernel.org>
Date: Tue, 29 Jun 2010 10:12:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: [PATCH UPDATED 12/35] workqueue: update cwq alignement
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere>
In-Reply-To: <20100628224755.GA10104@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 08:12:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

work->data field is used for two purposes.  It points to cwq it's
queued on and the lower bits are used for flags.  Currently, two bits
are reserved which is always safe as 4 byte alignment is guaranteed on
every architecture.  However, future changes will need more flag bits.

On SMP, the percpu allocator is capable of honoring larger alignment
(there are other users which depend on it) and larger alignment works
just fine.  On UP, percpu allocator is a thin wrapper around
kzalloc/kfree() and don't honor alignment request.

This patch introduces WORK_STRUCT_FLAG_BITS and implements
alloc/free_cwqs() which guarantees max(1 << WORK_STRUCT_FLAG_BITS,
__alignof__(unsigned long long) alignment both on SMP and UP.  On SMP,
simply wrapping percpu allocator is enough.  On UP, extra space is
allocated so that cwq can be aligned and the original pointer can be
stored after it which is used in the free path.

* Alignment problem on UP is reported by Michal Simek.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Michal Simek <michal.simek@petalogix.com>
---

Never mind of about config.  This was originally after workqueue
flushing patch so there were enough flag bits to avoid triggering that
BUILD_BUG_ON().  I updated alloc_cwqs() to just take the larger
alignment.  After this change, 0023 fails to apply but it's trivial
context conflict.  I've updated the git tree with the refreshed
patches.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

Thanks.

 include/linux/workqueue.h |    5 +++
 kernel/workqueue.c        |   60 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 6 deletions(-)

Index: work/include/linux/workqueue.h
===================================================================
--- work.orig/include/linux/workqueue.h
+++ work/include/linux/workqueue.h
@@ -26,6 +26,9 @@ enum {
 	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 	WORK_STRUCT_STATIC_BIT	= 1,	/* static initializer (debugobjects) */
+	WORK_STRUCT_FLAG_BITS	= 2,
+#else
+	WORK_STRUCT_FLAG_BITS	= 1,
 #endif

 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
@@ -35,7 +38,7 @@ enum {
 	WORK_STRUCT_STATIC	= 0,
 #endif

-	WORK_STRUCT_FLAG_MASK	= 3UL,
+	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
 };

Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
@@ -46,7 +46,9 @@

 /*
  * The per-CPU workqueue (if single thread, we always use the first
- * possible cpu).
+ * possible cpu).  The lower WORK_STRUCT_FLAG_BITS of
+ * work_struct->data are used for flags and thus cwqs need to be
+ * aligned at two's power of the number of flag bits.
  */
 struct cpu_workqueue_struct {

@@ -59,7 +61,7 @@ struct cpu_workqueue_struct {

 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	struct task_struct	*thread;
-} ____cacheline_aligned;
+};

 /*
  * The externally visible workqueue abstraction is an array of
@@ -967,6 +969,53 @@ int current_is_keventd(void)

 }

+static struct cpu_workqueue_struct *alloc_cwqs(void)
+{
+	/*
+	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
+	 * Make sure that the alignment isn't lower than that of
+	 * unsigned long long.
+	 */
+	const size_t size = sizeof(struct cpu_workqueue_struct);
+	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
+				   __alignof__(unsigned long long));
+	struct cpu_workqueue_struct *cwqs;
+#ifndef CONFIG_SMP
+	void *ptr;
+
+	/*
+	 * On UP, percpu allocator doesn't honor alignment parameter
+	 * and simply uses arch-dependent default.  Allocate enough
+	 * room to align cwq and put an extra pointer at the end
+	 * pointing back to the originally allocated pointer which
+	 * will be used for free.
+	 *
+	 * FIXME: This really belongs to UP percpu code.  Update UP
+	 * percpu code to honor alignment and remove this ugliness.
+	 */
+	ptr = __alloc_percpu(size + align + sizeof(void *), 1);
+	cwqs = PTR_ALIGN(ptr, align);
+	*(void **)per_cpu_ptr(cwqs + 1, 0) = ptr;
+#else
+	/* On SMP, percpu allocator can do it itself */
+	cwqs = __alloc_percpu(size, align);
+#endif
+	/* just in case, make sure it's actually aligned */
+	BUG_ON(!IS_ALIGNED((unsigned long)cwqs, align));
+	return cwqs;
+}
+
+static void free_cwqs(struct cpu_workqueue_struct *cwqs)
+{
+#ifndef CONFIG_SMP
+	/* on UP, the pointer to free is stored right after the cwq */
+	if (cwqs)
+		free_percpu(*(void **)per_cpu_ptr(cwqs + 1, 0));
+#else
+	free_percpu(cwqs);
+#endif
+}
+
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct workqueue_struct *wq = cwq->wq;
@@ -1012,7 +1061,7 @@ struct workqueue_struct *__create_workqu
 	if (!wq)
 		goto err;

-	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
+	wq->cpu_wq = alloc_cwqs();
 	if (!wq->cpu_wq)
 		goto err;

@@ -1031,6 +1080,7 @@ struct workqueue_struct *__create_workqu
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);

+		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
 		cwq->wq = wq;
 		cwq->cpu = cpu;
 		spin_lock_init(&cwq->lock);
@@ -1059,7 +1109,7 @@ struct workqueue_struct *__create_workqu
 	return wq;
 err:
 	if (wq) {
-		free_percpu(wq->cpu_wq);
+		free_cwqs(wq->cpu_wq);
 		kfree(wq);
 	}
 	return NULL;
@@ -1112,7 +1162,7 @@ void destroy_workqueue(struct workqueue_
 	for_each_possible_cpu(cpu)
 		cleanup_workqueue_thread(get_cwq(cpu, wq));

-	free_percpu(wq->cpu_wq);
+	free_cwqs(wq->cpu_wq);
 	kfree(wq);
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
