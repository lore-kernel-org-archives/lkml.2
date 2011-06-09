Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1FILny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:43:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:53313 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab1FILnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:43:51 -0400
Date: Thu, 9 Jun 2011 11:43:06 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-76369139ceb955deefc509e6e12ce9d6ce50ccab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, bp@alien8.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, bp@alien8.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1305827704-5607-1-git-send-email-fweisbec@gmail.com>
References: <1305827704-5607-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Split up buffer handling from core code
Git-Commit-ID: 76369139ceb955deefc509e6e12ce9d6ce50ccab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 11:43:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76369139ceb955deefc509e6e12ce9d6ce50ccab
Gitweb:     http://git.kernel.org/tip/76369139ceb955deefc509e6e12ce9d6ce50ccab
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 19 May 2011 19:55:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Jun 2011 12:57:54 +0200

perf: Split up buffer handling from core code

And create the internal perf events header.

v2: Keep an internal inlined perf_output_copy()

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1305827704-5607-1-git-send-email-fweisbec@gmail.com
[ v3: use clearer 'ring_buffer' and 'rb' naming ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h  |   33 +---
 kernel/events/Makefile      |    2 +-
 kernel/events/core.c        |  568 ++++++-------------------------------------
 kernel/events/internal.h    |   97 ++++++++
 kernel/events/ring_buffer.c |  399 ++++++++++++++++++++++++++++++
 5 files changed, 572 insertions(+), 527 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..779f6ed 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -680,33 +680,6 @@ enum perf_event_active_state {
 };
 
 struct file;
-
-#define PERF_BUFFER_WRITABLE		0x01
-
-struct perf_buffer {
-	atomic_t			refcount;
-	struct rcu_head			rcu_head;
-#ifdef CONFIG_PERF_USE_VMALLOC
-	struct work_struct		work;
-	int				page_order;	/* allocation order  */
-#endif
-	int				nr_pages;	/* nr of data pages  */
-	int				writable;	/* are we writable   */
-
-	atomic_t			poll;		/* POLL_ for wakeups */
-
-	local_t				head;		/* write position    */
-	local_t				nest;		/* nested writers    */
-	local_t				events;		/* event limit       */
-	local_t				wakeup;		/* wakeup stamp      */
-	local_t				lost;		/* nr records lost   */
-
-	long				watermark;	/* wakeup watermark  */
-
-	struct perf_event_mmap_page	*user_page;
-	void				*data_pages[0];
-};
-
 struct perf_sample_data;
 
 typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
@@ -745,6 +718,8 @@ struct perf_cgroup {
 };
 #endif
 
+struct ring_buffer;
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -834,7 +809,7 @@ struct perf_event {
 	atomic_t			mmap_count;
 	int				mmap_locked;
 	struct user_struct		*mmap_user;
-	struct perf_buffer		*buffer;
+	struct ring_buffer		*rb;
 
 	/* poll related */
 	wait_queue_head_t		waitq;
@@ -945,7 +920,7 @@ struct perf_cpu_context {
 
 struct perf_output_handle {
 	struct perf_event		*event;
-	struct perf_buffer		*buffer;
+	struct ring_buffer		*rb;
 	unsigned long			wakeup;
 	unsigned long			size;
 	void				*addr;
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 1ce23d3..89e5e8a 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,5 +2,5 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o
+obj-y := core.o ring_buffer.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5e8c7b1..5e70f62 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -36,6 +36,8 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 
+#include "internal.h"
+
 #include <asm/irq_regs.h>
 
 struct remote_function_call {
@@ -2886,7 +2888,7 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void perf_buffer_put(struct perf_buffer *buffer);
+static void ring_buffer_put(struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -2909,9 +2911,9 @@ static void free_event(struct perf_event *event)
 		}
 	}
 
-	if (event->buffer) {
-		perf_buffer_put(event->buffer);
-		event->buffer = NULL;
+	if (event->rb) {
+		ring_buffer_put(event->rb);
+		event->rb = NULL;
 	}
 
 	if (is_cgroup_event(event))
@@ -3139,13 +3141,13 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 	unsigned int events = POLL_HUP;
 
 	rcu_read_lock();
-	buffer = rcu_dereference(event->buffer);
-	if (buffer)
-		events = atomic_xchg(&buffer->poll, 0);
+	rb = rcu_dereference(event->rb);
+	if (rb)
+		events = atomic_xchg(&rb->poll, 0);
 	rcu_read_unlock();
 
 	poll_wait(file, &event->waitq, wait);
@@ -3356,14 +3358,14 @@ static int perf_event_index(struct perf_event *event)
 void perf_event_update_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 
 	rcu_read_lock();
-	buffer = rcu_dereference(event->buffer);
-	if (!buffer)
+	rb = rcu_dereference(event->rb);
+	if (!rb)
 		goto unlock;
 
-	userpg = buffer->user_page;
+	userpg = rb->user_page;
 
 	/*
 	 * Disable preemption so as to not let the corresponding user-space
@@ -3390,220 +3392,10 @@ unlock:
 	rcu_read_unlock();
 }
 
-static unsigned long perf_data_size(struct perf_buffer *buffer);
-
-static void
-perf_buffer_init(struct perf_buffer *buffer, long watermark, int flags)
-{
-	long max_size = perf_data_size(buffer);
-
-	if (watermark)
-		buffer->watermark = min(max_size, watermark);
-
-	if (!buffer->watermark)
-		buffer->watermark = max_size / 2;
-
-	if (flags & PERF_BUFFER_WRITABLE)
-		buffer->writable = 1;
-
-	atomic_set(&buffer->refcount, 1);
-}
-
-#ifndef CONFIG_PERF_USE_VMALLOC
-
-/*
- * Back perf_mmap() with regular GFP_KERNEL-0 pages.
- */
-
-static struct page *
-perf_mmap_to_page(struct perf_buffer *buffer, unsigned long pgoff)
-{
-	if (pgoff > buffer->nr_pages)
-		return NULL;
-
-	if (pgoff == 0)
-		return virt_to_page(buffer->user_page);
-
-	return virt_to_page(buffer->data_pages[pgoff - 1]);
-}
-
-static void *perf_mmap_alloc_page(int cpu)
-{
-	struct page *page;
-	int node;
-
-	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
-	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
-	if (!page)
-		return NULL;
-
-	return page_address(page);
-}
-
-static struct perf_buffer *
-perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
-{
-	struct perf_buffer *buffer;
-	unsigned long size;
-	int i;
-
-	size = sizeof(struct perf_buffer);
-	size += nr_pages * sizeof(void *);
-
-	buffer = kzalloc(size, GFP_KERNEL);
-	if (!buffer)
-		goto fail;
-
-	buffer->user_page = perf_mmap_alloc_page(cpu);
-	if (!buffer->user_page)
-		goto fail_user_page;
-
-	for (i = 0; i < nr_pages; i++) {
-		buffer->data_pages[i] = perf_mmap_alloc_page(cpu);
-		if (!buffer->data_pages[i])
-			goto fail_data_pages;
-	}
-
-	buffer->nr_pages = nr_pages;
-
-	perf_buffer_init(buffer, watermark, flags);
-
-	return buffer;
-
-fail_data_pages:
-	for (i--; i >= 0; i--)
-		free_page((unsigned long)buffer->data_pages[i]);
-
-	free_page((unsigned long)buffer->user_page);
-
-fail_user_page:
-	kfree(buffer);
-
-fail:
-	return NULL;
-}
-
-static void perf_mmap_free_page(unsigned long addr)
-{
-	struct page *page = virt_to_page((void *)addr);
-
-	page->mapping = NULL;
-	__free_page(page);
-}
-
-static void perf_buffer_free(struct perf_buffer *buffer)
-{
-	int i;
-
-	perf_mmap_free_page((unsigned long)buffer->user_page);
-	for (i = 0; i < buffer->nr_pages; i++)
-		perf_mmap_free_page((unsigned long)buffer->data_pages[i]);
-	kfree(buffer);
-}
-
-static inline int page_order(struct perf_buffer *buffer)
-{
-	return 0;
-}
-
-#else
-
-/*
- * Back perf_mmap() with vmalloc memory.
- *
- * Required for architectures that have d-cache aliasing issues.
- */
-
-static inline int page_order(struct perf_buffer *buffer)
-{
-	return buffer->page_order;
-}
-
-static struct page *
-perf_mmap_to_page(struct perf_buffer *buffer, unsigned long pgoff)
-{
-	if (pgoff > (1UL << page_order(buffer)))
-		return NULL;
-
-	return vmalloc_to_page((void *)buffer->user_page + pgoff * PAGE_SIZE);
-}
-
-static void perf_mmap_unmark_page(void *addr)
-{
-	struct page *page = vmalloc_to_page(addr);
-
-	page->mapping = NULL;
-}
-
-static void perf_buffer_free_work(struct work_struct *work)
-{
-	struct perf_buffer *buffer;
-	void *base;
-	int i, nr;
-
-	buffer = container_of(work, struct perf_buffer, work);
-	nr = 1 << page_order(buffer);
-
-	base = buffer->user_page;
-	for (i = 0; i < nr + 1; i++)
-		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
-
-	vfree(base);
-	kfree(buffer);
-}
-
-static void perf_buffer_free(struct perf_buffer *buffer)
-{
-	schedule_work(&buffer->work);
-}
-
-static struct perf_buffer *
-perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
-{
-	struct perf_buffer *buffer;
-	unsigned long size;
-	void *all_buf;
-
-	size = sizeof(struct perf_buffer);
-	size += sizeof(void *);
-
-	buffer = kzalloc(size, GFP_KERNEL);
-	if (!buffer)
-		goto fail;
-
-	INIT_WORK(&buffer->work, perf_buffer_free_work);
-
-	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
-	if (!all_buf)
-		goto fail_all_buf;
-
-	buffer->user_page = all_buf;
-	buffer->data_pages[0] = all_buf + PAGE_SIZE;
-	buffer->page_order = ilog2(nr_pages);
-	buffer->nr_pages = 1;
-
-	perf_buffer_init(buffer, watermark, flags);
-
-	return buffer;
-
-fail_all_buf:
-	kfree(buffer);
-
-fail:
-	return NULL;
-}
-
-#endif
-
-static unsigned long perf_data_size(struct perf_buffer *buffer)
-{
-	return buffer->nr_pages << (PAGE_SHIFT + page_order(buffer));
-}
-
 static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct perf_event *event = vma->vm_file->private_data;
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 	int ret = VM_FAULT_SIGBUS;
 
 	if (vmf->flags & FAULT_FLAG_MKWRITE) {
@@ -3613,14 +3405,14 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 
 	rcu_read_lock();
-	buffer = rcu_dereference(event->buffer);
-	if (!buffer)
+	rb = rcu_dereference(event->rb);
+	if (!rb)
 		goto unlock;
 
 	if (vmf->pgoff && (vmf->flags & FAULT_FLAG_WRITE))
 		goto unlock;
 
-	vmf->page = perf_mmap_to_page(buffer, vmf->pgoff);
+	vmf->page = perf_mmap_to_page(rb, vmf->pgoff);
 	if (!vmf->page)
 		goto unlock;
 
@@ -3635,35 +3427,35 @@ unlock:
 	return ret;
 }
 
-static void perf_buffer_free_rcu(struct rcu_head *rcu_head)
+static void rb_free_rcu(struct rcu_head *rcu_head)
 {
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 
-	buffer = container_of(rcu_head, struct perf_buffer, rcu_head);
-	perf_buffer_free(buffer);
+	rb = container_of(rcu_head, struct ring_buffer, rcu_head);
+	rb_free(rb);
 }
 
-static struct perf_buffer *perf_buffer_get(struct perf_event *event)
+static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 {
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 
 	rcu_read_lock();
-	buffer = rcu_dereference(event->buffer);
-	if (buffer) {
-		if (!atomic_inc_not_zero(&buffer->refcount))
-			buffer = NULL;
+	rb = rcu_dereference(event->rb);
+	if (rb) {
+		if (!atomic_inc_not_zero(&rb->refcount))
+			rb = NULL;
 	}
 	rcu_read_unlock();
 
-	return buffer;
+	return rb;
 }
 
-static void perf_buffer_put(struct perf_buffer *buffer)
+static void ring_buffer_put(struct ring_buffer *rb)
 {
-	if (!atomic_dec_and_test(&buffer->refcount))
+	if (!atomic_dec_and_test(&rb->refcount))
 		return;
 
-	call_rcu(&buffer->rcu_head, perf_buffer_free_rcu);
+	call_rcu(&rb->rcu_head, rb_free_rcu);
 }
 
 static void perf_mmap_open(struct vm_area_struct *vma)
@@ -3678,16 +3470,16 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->buffer);
+		unsigned long size = perf_data_size(event->rb);
 		struct user_struct *user = event->mmap_user;
-		struct perf_buffer *buffer = event->buffer;
+		struct ring_buffer *rb = event->rb;
 
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
 		vma->vm_mm->locked_vm -= event->mmap_locked;
-		rcu_assign_pointer(event->buffer, NULL);
+		rcu_assign_pointer(event->rb, NULL);
 		mutex_unlock(&event->mmap_mutex);
 
-		perf_buffer_put(buffer);
+		ring_buffer_put(rb);
 		free_uid(user);
 	}
 }
@@ -3705,7 +3497,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
 	unsigned long locked, lock_limit;
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 	unsigned long vma_size;
 	unsigned long nr_pages;
 	long user_extra, extra;
@@ -3714,7 +3506,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	/*
 	 * Don't allow mmap() of inherited per-task counters. This would
 	 * create a performance issue due to all children writing to the
-	 * same buffer.
+	 * same rb.
 	 */
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
@@ -3726,7 +3518,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
 	/*
-	 * If we have buffer pages ensure they're a power-of-two number, so we
+	 * If we have rb pages ensure they're a power-of-two number, so we
 	 * can do bitmasks instead of modulo.
 	 */
 	if (nr_pages != 0 && !is_power_of_2(nr_pages))
@@ -3740,9 +3532,9 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	mutex_lock(&event->mmap_mutex);
-	if (event->buffer) {
-		if (event->buffer->nr_pages == nr_pages)
-			atomic_inc(&event->buffer->refcount);
+	if (event->rb) {
+		if (event->rb->nr_pages == nr_pages)
+			atomic_inc(&event->rb->refcount);
 		else
 			ret = -EINVAL;
 		goto unlock;
@@ -3772,18 +3564,18 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		goto unlock;
 	}
 
-	WARN_ON(event->buffer);
+	WARN_ON(event->rb);
 
 	if (vma->vm_flags & VM_WRITE)
-		flags |= PERF_BUFFER_WRITABLE;
+		flags |= RING_BUFFER_WRITABLE;
 
-	buffer = perf_buffer_alloc(nr_pages, event->attr.wakeup_watermark,
+	rb = rb_alloc(nr_pages, event->attr.wakeup_watermark,
 				   event->cpu, flags);
-	if (!buffer) {
+	if (!rb) {
 		ret = -ENOMEM;
 		goto unlock;
 	}
-	rcu_assign_pointer(event->buffer, buffer);
+	rcu_assign_pointer(event->rb, rb);
 
 	atomic_long_add(user_extra, &user->locked_vm);
 	event->mmap_locked = extra;
@@ -3882,117 +3674,6 @@ int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
 
-/*
- * Output
- */
-static bool perf_output_space(struct perf_buffer *buffer, unsigned long tail,
-			      unsigned long offset, unsigned long head)
-{
-	unsigned long mask;
-
-	if (!buffer->writable)
-		return true;
-
-	mask = perf_data_size(buffer) - 1;
-
-	offset = (offset - tail) & mask;
-	head   = (head   - tail) & mask;
-
-	if ((int)(head - offset) < 0)
-		return false;
-
-	return true;
-}
-
-static void perf_output_wakeup(struct perf_output_handle *handle)
-{
-	atomic_set(&handle->buffer->poll, POLL_IN);
-
-	if (handle->nmi) {
-		handle->event->pending_wakeup = 1;
-		irq_work_queue(&handle->event->pending);
-	} else
-		perf_event_wakeup(handle->event);
-}
-
-/*
- * We need to ensure a later event_id doesn't publish a head when a former
- * event isn't done writing. However since we need to deal with NMIs we
- * cannot fully serialize things.
- *
- * We only publish the head (and generate a wakeup) when the outer-most
- * event completes.
- */
-static void perf_output_get_handle(struct perf_output_handle *handle)
-{
-	struct perf_buffer *buffer = handle->buffer;
-
-	preempt_disable();
-	local_inc(&buffer->nest);
-	handle->wakeup = local_read(&buffer->wakeup);
-}
-
-static void perf_output_put_handle(struct perf_output_handle *handle)
-{
-	struct perf_buffer *buffer = handle->buffer;
-	unsigned long head;
-
-again:
-	head = local_read(&buffer->head);
-
-	/*
-	 * IRQ/NMI can happen here, which means we can miss a head update.
-	 */
-
-	if (!local_dec_and_test(&buffer->nest))
-		goto out;
-
-	/*
-	 * Publish the known good head. Rely on the full barrier implied
-	 * by atomic_dec_and_test() order the buffer->head read and this
-	 * write.
-	 */
-	buffer->user_page->data_head = head;
-
-	/*
-	 * Now check if we missed an update, rely on the (compiler)
-	 * barrier in atomic_dec_and_test() to re-read buffer->head.
-	 */
-	if (unlikely(head != local_read(&buffer->head))) {
-		local_inc(&buffer->nest);
-		goto again;
-	}
-
-	if (handle->wakeup != local_read(&buffer->wakeup))
-		perf_output_wakeup(handle);
-
-out:
-	preempt_enable();
-}
-
-__always_inline void perf_output_copy(struct perf_output_handle *handle,
-		      const void *buf, unsigned int len)
-{
-	do {
-		unsigned long size = min_t(unsigned long, handle->size, len);
-
-		memcpy(handle->addr, buf, size);
-
-		len -= size;
-		handle->addr += size;
-		buf += size;
-		handle->size -= size;
-		if (!handle->size) {
-			struct perf_buffer *buffer = handle->buffer;
-
-			handle->page++;
-			handle->page &= buffer->nr_pages - 1;
-			handle->addr = buffer->data_pages[handle->page];
-			handle->size = PAGE_SIZE << page_order(buffer);
-		}
-	} while (len);
-}
-
 static void __perf_event_header__init_id(struct perf_event_header *header,
 					 struct perf_sample_data *data,
 					 struct perf_event *event)
@@ -4023,9 +3704,9 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
 	}
 }
 
-static void perf_event_header__init_id(struct perf_event_header *header,
-				       struct perf_sample_data *data,
-				       struct perf_event *event)
+void perf_event_header__init_id(struct perf_event_header *header,
+				struct perf_sample_data *data,
+				struct perf_event *event)
 {
 	if (event->attr.sample_id_all)
 		__perf_event_header__init_id(header, data, event);
@@ -4052,121 +3733,14 @@ static void __perf_event__output_id_sample(struct perf_output_handle *handle,
 		perf_output_put(handle, data->cpu_entry);
 }
 
-static void perf_event__output_id_sample(struct perf_event *event,
-					 struct perf_output_handle *handle,
-					 struct perf_sample_data *sample)
+void perf_event__output_id_sample(struct perf_event *event,
+				  struct perf_output_handle *handle,
+				  struct perf_sample_data *sample)
 {
 	if (event->attr.sample_id_all)
 		__perf_event__output_id_sample(handle, sample);
 }
 
-int perf_output_begin(struct perf_output_handle *handle,
-		      struct perf_event *event, unsigned int size,
-		      int nmi, int sample)
-{
-	struct perf_buffer *buffer;
-	unsigned long tail, offset, head;
-	int have_lost;
-	struct perf_sample_data sample_data;
-	struct {
-		struct perf_event_header header;
-		u64			 id;
-		u64			 lost;
-	} lost_event;
-
-	rcu_read_lock();
-	/*
-	 * For inherited events we send all the output towards the parent.
-	 */
-	if (event->parent)
-		event = event->parent;
-
-	buffer = rcu_dereference(event->buffer);
-	if (!buffer)
-		goto out;
-
-	handle->buffer	= buffer;
-	handle->event	= event;
-	handle->nmi	= nmi;
-	handle->sample	= sample;
-
-	if (!buffer->nr_pages)
-		goto out;
-
-	have_lost = local_read(&buffer->lost);
-	if (have_lost) {
-		lost_event.header.size = sizeof(lost_event);
-		perf_event_header__init_id(&lost_event.header, &sample_data,
-					   event);
-		size += lost_event.header.size;
-	}
-
-	perf_output_get_handle(handle);
-
-	do {
-		/*
-		 * Userspace could choose to issue a mb() before updating the
-		 * tail pointer. So that all reads will be completed before the
-		 * write is issued.
-		 */
-		tail = ACCESS_ONCE(buffer->user_page->data_tail);
-		smp_rmb();
-		offset = head = local_read(&buffer->head);
-		head += size;
-		if (unlikely(!perf_output_space(buffer, tail, offset, head)))
-			goto fail;
-	} while (local_cmpxchg(&buffer->head, offset, head) != offset);
-
-	if (head - local_read(&buffer->wakeup) > buffer->watermark)
-		local_add(buffer->watermark, &buffer->wakeup);
-
-	handle->page = offset >> (PAGE_SHIFT + page_order(buffer));
-	handle->page &= buffer->nr_pages - 1;
-	handle->size = offset & ((PAGE_SIZE << page_order(buffer)) - 1);
-	handle->addr = buffer->data_pages[handle->page];
-	handle->addr += handle->size;
-	handle->size = (PAGE_SIZE << page_order(buffer)) - handle->size;
-
-	if (have_lost) {
-		lost_event.header.type = PERF_RECORD_LOST;
-		lost_event.header.misc = 0;
-		lost_event.id          = event->id;
-		lost_event.lost        = local_xchg(&buffer->lost, 0);
-
-		perf_output_put(handle, lost_event);
-		perf_event__output_id_sample(event, handle, &sample_data);
-	}
-
-	return 0;
-
-fail:
-	local_inc(&buffer->lost);
-	perf_output_put_handle(handle);
-out:
-	rcu_read_unlock();
-
-	return -ENOSPC;
-}
-
-void perf_output_end(struct perf_output_handle *handle)
-{
-	struct perf_event *event = handle->event;
-	struct perf_buffer *buffer = handle->buffer;
-
-	int wakeup_events = event->attr.wakeup_events;
-
-	if (handle->sample && wakeup_events) {
-		int events = local_inc_return(&buffer->events);
-		if (events >= wakeup_events) {
-			local_sub(wakeup_events, &buffer->events);
-			local_inc(&buffer->wakeup);
-		}
-	}
-
-	perf_output_put_handle(handle);
-	rcu_read_unlock();
-}
-
 static void perf_output_read_one(struct perf_output_handle *handle,
 				 struct perf_event *event,
 				 u64 enabled, u64 running)
@@ -4187,7 +3761,7 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(event);
 
-	perf_output_copy(handle, values, n * sizeof(u64));
+	__output_copy(handle, values, n * sizeof(u64));
 }
 
 /*
@@ -4217,7 +3791,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
 
-	perf_output_copy(handle, values, n * sizeof(u64));
+	__output_copy(handle, values, n * sizeof(u64));
 
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		n = 0;
@@ -4229,7 +3803,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
 
-		perf_output_copy(handle, values, n * sizeof(u64));
+		__output_copy(handle, values, n * sizeof(u64));
 	}
 }
 
@@ -4309,7 +3883,7 @@ void perf_output_sample(struct perf_output_handle *handle,
 
 			size *= sizeof(u64);
 
-			perf_output_copy(handle, data->callchain, size);
+			__output_copy(handle, data->callchain, size);
 		} else {
 			u64 nr = 0;
 			perf_output_put(handle, nr);
@@ -4319,8 +3893,8 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_RAW) {
 		if (data->raw) {
 			perf_output_put(handle, data->raw->size);
-			perf_output_copy(handle, data->raw->data,
-					 data->raw->size);
+			__output_copy(handle, data->raw->data,
+					   data->raw->size);
 		} else {
 			struct {
 				u32	size;
@@ -4617,7 +4191,7 @@ static void perf_event_comm_output(struct perf_event *event,
 	comm_event->event_id.tid = perf_event_tid(event, comm_event->task);
 
 	perf_output_put(&handle, comm_event->event_id);
-	perf_output_copy(&handle, comm_event->comm,
+	__output_copy(&handle, comm_event->comm,
 				   comm_event->comm_size);
 
 	perf_event__output_id_sample(event, &handle, &sample);
@@ -4763,7 +4337,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 	mmap_event->event_id.tid = perf_event_tid(event, current);
 
 	perf_output_put(&handle, mmap_event->event_id);
-	perf_output_copy(&handle, mmap_event->file_name,
+	__output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
 
 	perf_event__output_id_sample(event, &handle, &sample);
@@ -4819,7 +4393,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 
 	if (file) {
 		/*
-		 * d_path works from the end of the buffer backwards, so we
+		 * d_path works from the end of the rb backwards, so we
 		 * need to add enough zero bytes after the string to handle
 		 * the 64bit alignment we do later.
 		 */
@@ -6346,7 +5920,7 @@ err_size:
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct perf_buffer *buffer = NULL, *old_buffer = NULL;
+	struct ring_buffer *rb = NULL, *old_rb = NULL;
 	int ret = -EINVAL;
 
 	if (!output_event)
@@ -6363,7 +5937,7 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 		goto out;
 
 	/*
-	 * If its not a per-cpu buffer, it must be the same task.
+	 * If its not a per-cpu rb, it must be the same task.
 	 */
 	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
 		goto out;
@@ -6375,20 +5949,20 @@ set:
 		goto unlock;
 
 	if (output_event) {
-		/* get the buffer we want to redirect to */
-		buffer = perf_buffer_get(output_event);
-		if (!buffer)
+		/* get the rb we want to redirect to */
+		rb = ring_buffer_get(output_event);
+		if (!rb)
 			goto unlock;
 	}
 
-	old_buffer = event->buffer;
-	rcu_assign_pointer(event->buffer, buffer);
+	old_rb = event->rb;
+	rcu_assign_pointer(event->rb, rb);
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
 
-	if (old_buffer)
-		perf_buffer_put(old_buffer);
+	if (old_rb)
+		ring_buffer_put(old_rb);
 out:
 	return ret;
 }
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
new file mode 100644
index 0000000..114f27f
--- /dev/null
+++ b/kernel/events/internal.h
@@ -0,0 +1,97 @@
+#ifndef _KERNEL_EVENTS_INTERNAL_H
+#define _KERNEL_EVENTS_INTERNAL_H
+
+#define RING_BUFFER_WRITABLE		0x01
+
+struct ring_buffer {
+	atomic_t			refcount;
+	struct rcu_head			rcu_head;
+#ifdef CONFIG_PERF_USE_VMALLOC
+	struct work_struct		work;
+	int				page_order;	/* allocation order  */
+#endif
+	int				nr_pages;	/* nr of data pages  */
+	int				writable;	/* are we writable   */
+
+	atomic_t			poll;		/* POLL_ for wakeups */
+
+	local_t				head;		/* write position    */
+	local_t				nest;		/* nested writers    */
+	local_t				events;		/* event limit       */
+	local_t				wakeup;		/* wakeup stamp      */
+	local_t				lost;		/* nr records lost   */
+
+	long				watermark;	/* wakeup watermark  */
+
+	struct perf_event_mmap_page	*user_page;
+	void				*data_pages[0];
+};
+
+
+extern void rb_free(struct ring_buffer *rb);
+extern struct ring_buffer *
+rb_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void perf_event_wakeup(struct perf_event *event);
+
+extern void
+perf_event_header__init_id(struct perf_event_header *header,
+			   struct perf_sample_data *data,
+			   struct perf_event *event);
+extern void
+perf_event__output_id_sample(struct perf_event *event,
+			     struct perf_output_handle *handle,
+			     struct perf_sample_data *sample);
+
+extern struct page *
+perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff);
+
+#ifdef CONFIG_PERF_USE_VMALLOC
+/*
+ * Back perf_mmap() with vmalloc memory.
+ *
+ * Required for architectures that have d-cache aliasing issues.
+ */
+
+static inline int page_order(struct ring_buffer *rb)
+{
+	return rb->page_order;
+}
+
+#else
+
+static inline int page_order(struct ring_buffer *rb)
+{
+	return 0;
+}
+#endif
+
+static unsigned long perf_data_size(struct ring_buffer *rb)
+{
+	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
+}
+
+static inline void
+__output_copy(struct perf_output_handle *handle,
+		   const void *buf, unsigned int len)
+{
+	do {
+		unsigned long size = min_t(unsigned long, handle->size, len);
+
+		memcpy(handle->addr, buf, size);
+
+		len -= size;
+		handle->addr += size;
+		buf += size;
+		handle->size -= size;
+		if (!handle->size) {
+			struct ring_buffer *rb = handle->rb;
+
+			handle->page++;
+			handle->page &= rb->nr_pages - 1;
+			handle->addr = rb->data_pages[handle->page];
+			handle->size = PAGE_SIZE << page_order(rb);
+		}
+	} while (len);
+}
+
+#endif /* _KERNEL_EVENTS_INTERNAL_H */
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
new file mode 100644
index 0000000..fde5259
--- /dev/null
+++ b/kernel/events/ring_buffer.c
@@ -0,0 +1,399 @@
+/*
+ * Performance events ring-buffer code:
+ *
+ *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *
+ * For licensing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_event.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+
+#include "internal.h"
+
+static bool perf_output_space(struct ring_buffer *rb, unsigned long tail,
+			      unsigned long offset, unsigned long head)
+{
+	unsigned long mask;
+
+	if (!rb->writable)
+		return true;
+
+	mask = perf_data_size(rb) - 1;
+
+	offset = (offset - tail) & mask;
+	head   = (head   - tail) & mask;
+
+	if ((int)(head - offset) < 0)
+		return false;
+
+	return true;
+}
+
+static void perf_output_wakeup(struct perf_output_handle *handle)
+{
+	atomic_set(&handle->rb->poll, POLL_IN);
+
+	if (handle->nmi) {
+		handle->event->pending_wakeup = 1;
+		irq_work_queue(&handle->event->pending);
+	} else
+		perf_event_wakeup(handle->event);
+}
+
+/*
+ * We need to ensure a later event_id doesn't publish a head when a former
+ * event isn't done writing. However since we need to deal with NMIs we
+ * cannot fully serialize things.
+ *
+ * We only publish the head (and generate a wakeup) when the outer-most
+ * event completes.
+ */
+static void perf_output_get_handle(struct perf_output_handle *handle)
+{
+	struct ring_buffer *rb = handle->rb;
+
+	preempt_disable();
+	local_inc(&rb->nest);
+	handle->wakeup = local_read(&rb->wakeup);
+}
+
+static void perf_output_put_handle(struct perf_output_handle *handle)
+{
+	struct ring_buffer *rb = handle->rb;
+	unsigned long head;
+
+again:
+	head = local_read(&rb->head);
+
+	/*
+	 * IRQ/NMI can happen here, which means we can miss a head update.
+	 */
+
+	if (!local_dec_and_test(&rb->nest))
+		goto out;
+
+	/*
+	 * Publish the known good head. Rely on the full barrier implied
+	 * by atomic_dec_and_test() order the rb->head read and this
+	 * write.
+	 */
+	rb->user_page->data_head = head;
+
+	/*
+	 * Now check if we missed an update, rely on the (compiler)
+	 * barrier in atomic_dec_and_test() to re-read rb->head.
+	 */
+	if (unlikely(head != local_read(&rb->head))) {
+		local_inc(&rb->nest);
+		goto again;
+	}
+
+	if (handle->wakeup != local_read(&rb->wakeup))
+		perf_output_wakeup(handle);
+
+out:
+	preempt_enable();
+}
+
+int perf_output_begin(struct perf_output_handle *handle,
+		      struct perf_event *event, unsigned int size,
+		      int nmi, int sample)
+{
+	struct ring_buffer *rb;
+	unsigned long tail, offset, head;
+	int have_lost;
+	struct perf_sample_data sample_data;
+	struct {
+		struct perf_event_header header;
+		u64			 id;
+		u64			 lost;
+	} lost_event;
+
+	rcu_read_lock();
+	/*
+	 * For inherited events we send all the output towards the parent.
+	 */
+	if (event->parent)
+		event = event->parent;
+
+	rb = rcu_dereference(event->rb);
+	if (!rb)
+		goto out;
+
+	handle->rb	= rb;
+	handle->event	= event;
+	handle->nmi	= nmi;
+	handle->sample	= sample;
+
+	if (!rb->nr_pages)
+		goto out;
+
+	have_lost = local_read(&rb->lost);
+	if (have_lost) {
+		lost_event.header.size = sizeof(lost_event);
+		perf_event_header__init_id(&lost_event.header, &sample_data,
+					   event);
+		size += lost_event.header.size;
+	}
+
+	perf_output_get_handle(handle);
+
+	do {
+		/*
+		 * Userspace could choose to issue a mb() before updating the
+		 * tail pointer. So that all reads will be completed before the
+		 * write is issued.
+		 */
+		tail = ACCESS_ONCE(rb->user_page->data_tail);
+		smp_rmb();
+		offset = head = local_read(&rb->head);
+		head += size;
+		if (unlikely(!perf_output_space(rb, tail, offset, head)))
+			goto fail;
+	} while (local_cmpxchg(&rb->head, offset, head) != offset);
+
+	if (head - local_read(&rb->wakeup) > rb->watermark)
+		local_add(rb->watermark, &rb->wakeup);
+
+	handle->page = offset >> (PAGE_SHIFT + page_order(rb));
+	handle->page &= rb->nr_pages - 1;
+	handle->size = offset & ((PAGE_SIZE << page_order(rb)) - 1);
+	handle->addr = rb->data_pages[handle->page];
+	handle->addr += handle->size;
+	handle->size = (PAGE_SIZE << page_order(rb)) - handle->size;
+
+	if (have_lost) {
+		lost_event.header.type = PERF_RECORD_LOST;
+		lost_event.header.misc = 0;
+		lost_event.id          = event->id;
+		lost_event.lost        = local_xchg(&rb->lost, 0);
+
+		perf_output_put(handle, lost_event);
+		perf_event__output_id_sample(event, handle, &sample_data);
+	}
+
+	return 0;
+
+fail:
+	local_inc(&rb->lost);
+	perf_output_put_handle(handle);
+out:
+	rcu_read_unlock();
+
+	return -ENOSPC;
+}
+
+void perf_output_copy(struct perf_output_handle *handle,
+		      const void *buf, unsigned int len)
+{
+	__output_copy(handle, buf, len);
+}
+
+void perf_output_end(struct perf_output_handle *handle)
+{
+	struct perf_event *event = handle->event;
+	struct ring_buffer *rb = handle->rb;
+
+	int wakeup_events = event->attr.wakeup_events;
+
+	if (handle->sample && wakeup_events) {
+		int events = local_inc_return(&rb->events);
+		if (events >= wakeup_events) {
+			local_sub(wakeup_events, &rb->events);
+			local_inc(&rb->wakeup);
+		}
+	}
+
+	perf_output_put_handle(handle);
+	rcu_read_unlock();
+}
+
+static void
+ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
+{
+	long max_size = perf_data_size(rb);
+
+	if (watermark)
+		rb->watermark = min(max_size, watermark);
+
+	if (!rb->watermark)
+		rb->watermark = max_size / 2;
+
+	if (flags & RING_BUFFER_WRITABLE)
+		rb->writable = 1;
+
+	atomic_set(&rb->refcount, 1);
+}
+
+#ifndef CONFIG_PERF_USE_VMALLOC
+
+/*
+ * Back perf_mmap() with regular GFP_KERNEL-0 pages.
+ */
+
+struct page *
+perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+{
+	if (pgoff > rb->nr_pages)
+		return NULL;
+
+	if (pgoff == 0)
+		return virt_to_page(rb->user_page);
+
+	return virt_to_page(rb->data_pages[pgoff - 1]);
+}
+
+static void *perf_mmap_alloc_page(int cpu)
+{
+	struct page *page;
+	int node;
+
+	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
+	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
+struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+{
+	struct ring_buffer *rb;
+	unsigned long size;
+	int i;
+
+	size = sizeof(struct ring_buffer);
+	size += nr_pages * sizeof(void *);
+
+	rb = kzalloc(size, GFP_KERNEL);
+	if (!rb)
+		goto fail;
+
+	rb->user_page = perf_mmap_alloc_page(cpu);
+	if (!rb->user_page)
+		goto fail_user_page;
+
+	for (i = 0; i < nr_pages; i++) {
+		rb->data_pages[i] = perf_mmap_alloc_page(cpu);
+		if (!rb->data_pages[i])
+			goto fail_data_pages;
+	}
+
+	rb->nr_pages = nr_pages;
+
+	ring_buffer_init(rb, watermark, flags);
+
+	return rb;
+
+fail_data_pages:
+	for (i--; i >= 0; i--)
+		free_page((unsigned long)rb->data_pages[i]);
+
+	free_page((unsigned long)rb->user_page);
+
+fail_user_page:
+	kfree(rb);
+
+fail:
+	return NULL;
+}
+
+static void perf_mmap_free_page(unsigned long addr)
+{
+	struct page *page = virt_to_page((void *)addr);
+
+	page->mapping = NULL;
+	__free_page(page);
+}
+
+void rb_free(struct ring_buffer *rb)
+{
+	int i;
+
+	perf_mmap_free_page((unsigned long)rb->user_page);
+	for (i = 0; i < rb->nr_pages; i++)
+		perf_mmap_free_page((unsigned long)rb->data_pages[i]);
+	kfree(rb);
+}
+
+#else
+
+struct page *
+perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+{
+	if (pgoff > (1UL << page_order(rb)))
+		return NULL;
+
+	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
+}
+
+static void perf_mmap_unmark_page(void *addr)
+{
+	struct page *page = vmalloc_to_page(addr);
+
+	page->mapping = NULL;
+}
+
+static void rb_free_work(struct work_struct *work)
+{
+	struct ring_buffer *rb;
+	void *base;
+	int i, nr;
+
+	rb = container_of(work, struct ring_buffer, work);
+	nr = 1 << page_order(rb);
+
+	base = rb->user_page;
+	for (i = 0; i < nr + 1; i++)
+		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
+
+	vfree(base);
+	kfree(rb);
+}
+
+void rb_free(struct ring_buffer *rb)
+{
+	schedule_work(&rb->work);
+}
+
+struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+{
+	struct ring_buffer *rb;
+	unsigned long size;
+	void *all_buf;
+
+	size = sizeof(struct ring_buffer);
+	size += sizeof(void *);
+
+	rb = kzalloc(size, GFP_KERNEL);
+	if (!rb)
+		goto fail;
+
+	INIT_WORK(&rb->work, rb_free_work);
+
+	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
+	if (!all_buf)
+		goto fail_all_buf;
+
+	rb->user_page = all_buf;
+	rb->data_pages[0] = all_buf + PAGE_SIZE;
+	rb->page_order = ilog2(nr_pages);
+	rb->nr_pages = 1;
+
+	ring_buffer_init(rb, watermark, flags);
+
+	return rb;
+
+fail_all_buf:
+	kfree(rb);
+
+fail:
+	return NULL;
+}
+
+#endif
