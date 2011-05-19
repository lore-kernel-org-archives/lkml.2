Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1ESBGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:06:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56402 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1ESBGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=idG04jzE/j43KMJTMngQWPCEa67yaEydHZsP9hQKky0G57aVe7CMjYJk8sbANnZ3UI
         392qxBB1OtsQh+KaU49oaA/e0IBu3Gu47iIK/ZXZBtF1826QLiE8EOIjjwPbllzsglIH
         KJ0mAC5v4TlES3HI+5+QYrawluv9hnkUQ4uPg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: =?UTF-8?q?=5BRFC=20PATCH=5D=20perf=3A=20Split=20up=20buffer=20handling=20from=20core=20code?=
Date: Thu, 19 May 2011 03:06:25 +0200
Message-Id: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping perf_output_copy() inlined is responsible
of some ugliness there.

A solution could be to have an internal only
perf_output_copy_inline() version in internal.h
and a wrapper in buffer.c that exports it.

Or we can completely uninline it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |   47 +++++-
 kernel/events/Makefile     |    2 +-
 kernel/events/buffer.c     |  394 +++++++++++++++++++++++++++++++++++++++
 kernel/events/core.c       |  442 +-------------------------------------------
 kernel/events/internal.h   |   28 +++
 5 files changed, 476 insertions(+), 437 deletions(-)
 create mode 100644 kernel/events/buffer.c
 create mode 100644 kernel/events/internal.h

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..02952d4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1142,12 +1142,55 @@ extern void perf_bp_event(struct perf_event *event, void *data);
 # define perf_instruction_pointer(regs)	instruction_pointer(regs)
 #endif
 
+#ifdef CONFIG_PERF_USE_VMALLOC
+/*
+ * Back perf_mmap() with vmalloc memory.
+ *
+ * Required for architectures that have d-cache aliasing issues.
+ */
+
+static inline int perf_output_page_order(struct perf_buffer *buffer)
+{
+	return buffer->page_order;
+}
+
+#else
+
+static inline int perf_output_page_order(struct perf_buffer *buffer)
+{
+	return 0;
+}
+#endif
+
 extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size,
 			     int nmi, int sample);
 extern void perf_output_end(struct perf_output_handle *handle);
-extern void perf_output_copy(struct perf_output_handle *handle,
-			     const void *buf, unsigned int len);
+
+static inline void
+perf_output_copy(struct perf_output_handle *handle,
+		 const void *buf, unsigned int len)
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
+			struct perf_buffer *buffer = handle->buffer;
+
+			handle->page++;
+			handle->page &= buffer->nr_pages - 1;
+			handle->addr = buffer->data_pages[handle->page];
+			handle->size = PAGE_SIZE << perf_output_page_order(buffer);
+		}
+	} while (len);
+}
+
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 1ce23d3..b66b057 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,5 +2,5 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o
+obj-y := core.o buffer.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
diff --git a/kernel/events/buffer.c b/kernel/events/buffer.c
new file mode 100644
index 0000000..03493d4
--- /dev/null
+++ b/kernel/events/buffer.c
@@ -0,0 +1,394 @@
+/*
+ * Performance events buffer code:
+ *
+ *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *
+ * For licensing details see kernel-base/COPYING
+ */
+
+#include <linux/slab.h>
+#include <linux/perf_event.h>
+#include "internal.h"
+
+
+static bool perf_output_space(struct perf_buffer *buffer, unsigned long tail,
+			      unsigned long offset, unsigned long head)
+{
+	unsigned long mask;
+
+	if (!buffer->writable)
+		return true;
+
+	mask = perf_data_size(buffer) - 1;
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
+	atomic_set(&handle->buffer->poll, POLL_IN);
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
+	struct perf_buffer *buffer = handle->buffer;
+
+	preempt_disable();
+	local_inc(&buffer->nest);
+	handle->wakeup = local_read(&buffer->wakeup);
+}
+
+static void perf_output_put_handle(struct perf_output_handle *handle)
+{
+	struct perf_buffer *buffer = handle->buffer;
+	unsigned long head;
+
+again:
+	head = local_read(&buffer->head);
+
+	/*
+	 * IRQ/NMI can happen here, which means we can miss a head update.
+	 */
+
+	if (!local_dec_and_test(&buffer->nest))
+		goto out;
+
+	/*
+	 * Publish the known good head. Rely on the full barrier implied
+	 * by atomic_dec_and_test() order the buffer->head read and this
+	 * write.
+	 */
+	buffer->user_page->data_head = head;
+
+	/*
+	 * Now check if we missed an update, rely on the (compiler)
+	 * barrier in atomic_dec_and_test() to re-read buffer->head.
+	 */
+	if (unlikely(head != local_read(&buffer->head))) {
+		local_inc(&buffer->nest);
+		goto again;
+	}
+
+	if (handle->wakeup != local_read(&buffer->wakeup))
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
+	struct perf_buffer *buffer;
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
+	buffer = rcu_dereference(event->buffer);
+	if (!buffer)
+		goto out;
+
+	handle->buffer	= buffer;
+	handle->event	= event;
+	handle->nmi	= nmi;
+	handle->sample	= sample;
+
+	if (!buffer->nr_pages)
+		goto out;
+
+	have_lost = local_read(&buffer->lost);
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
+		tail = ACCESS_ONCE(buffer->user_page->data_tail);
+		smp_rmb();
+		offset = head = local_read(&buffer->head);
+		head += size;
+		if (unlikely(!perf_output_space(buffer, tail, offset, head)))
+			goto fail;
+	} while (local_cmpxchg(&buffer->head, offset, head) != offset);
+
+	if (head - local_read(&buffer->wakeup) > buffer->watermark)
+		local_add(buffer->watermark, &buffer->wakeup);
+
+	handle->page = offset >> (PAGE_SHIFT + perf_output_page_order(buffer));
+	handle->page &= buffer->nr_pages - 1;
+	handle->size = offset & ((PAGE_SIZE << perf_output_page_order(buffer)) - 1);
+	handle->addr = buffer->data_pages[handle->page];
+	handle->addr += handle->size;
+	handle->size = (PAGE_SIZE << perf_output_page_order(buffer)) - handle->size;
+
+	if (have_lost) {
+		lost_event.header.type = PERF_RECORD_LOST;
+		lost_event.header.misc = 0;
+		lost_event.id          = event->id;
+		lost_event.lost        = local_xchg(&buffer->lost, 0);
+
+		perf_output_put(handle, lost_event);
+		perf_event__output_id_sample(event, handle, &sample_data);
+	}
+
+	return 0;
+
+fail:
+	local_inc(&buffer->lost);
+	perf_output_put_handle(handle);
+out:
+	rcu_read_unlock();
+
+	return -ENOSPC;
+}
+
+void perf_output_end(struct perf_output_handle *handle)
+{
+	struct perf_event *event = handle->event;
+	struct perf_buffer *buffer = handle->buffer;
+
+	int wakeup_events = event->attr.wakeup_events;
+
+	if (handle->sample && wakeup_events) {
+		int events = local_inc_return(&buffer->events);
+		if (events >= wakeup_events) {
+			local_sub(wakeup_events, &buffer->events);
+			local_inc(&buffer->wakeup);
+		}
+	}
+
+	perf_output_put_handle(handle);
+	rcu_read_unlock();
+}
+
+static void
+perf_buffer_init(struct perf_buffer *buffer, long watermark, int flags)
+{
+	long max_size = perf_data_size(buffer);
+
+	if (watermark)
+		buffer->watermark = min(max_size, watermark);
+
+	if (!buffer->watermark)
+		buffer->watermark = max_size / 2;
+
+	if (flags & PERF_BUFFER_WRITABLE)
+		buffer->writable = 1;
+
+	atomic_set(&buffer->refcount, 1);
+}
+
+#ifndef CONFIG_PERF_USE_VMALLOC
+
+/*
+ * Back perf_mmap() with regular GFP_KERNEL-0 pages.
+ */
+
+struct page *
+perf_mmap_to_page(struct perf_buffer *buffer, unsigned long pgoff)
+{
+	if (pgoff > buffer->nr_pages)
+		return NULL;
+
+	if (pgoff == 0)
+		return virt_to_page(buffer->user_page);
+
+	return virt_to_page(buffer->data_pages[pgoff - 1]);
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
+struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
+{
+	struct perf_buffer *buffer;
+	unsigned long size;
+	int i;
+
+	size = sizeof(struct perf_buffer);
+	size += nr_pages * sizeof(void *);
+
+	buffer = kzalloc(size, GFP_KERNEL);
+	if (!buffer)
+		goto fail;
+
+	buffer->user_page = perf_mmap_alloc_page(cpu);
+	if (!buffer->user_page)
+		goto fail_user_page;
+
+	for (i = 0; i < nr_pages; i++) {
+		buffer->data_pages[i] = perf_mmap_alloc_page(cpu);
+		if (!buffer->data_pages[i])
+			goto fail_data_pages;
+	}
+
+	buffer->nr_pages = nr_pages;
+
+	perf_buffer_init(buffer, watermark, flags);
+
+	return buffer;
+
+fail_data_pages:
+	for (i--; i >= 0; i--)
+		free_page((unsigned long)buffer->data_pages[i]);
+
+	free_page((unsigned long)buffer->user_page);
+
+fail_user_page:
+	kfree(buffer);
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
+void perf_buffer_free(struct perf_buffer *buffer)
+{
+	int i;
+
+	perf_mmap_free_page((unsigned long)buffer->user_page);
+	for (i = 0; i < buffer->nr_pages; i++)
+		perf_mmap_free_page((unsigned long)buffer->data_pages[i]);
+	kfree(buffer);
+}
+
+#else
+
+struct page *
+perf_mmap_to_page(struct perf_buffer *buffer, unsigned long pgoff)
+{
+	if (pgoff > (1UL << perf_output_page_order(buffer)))
+		return NULL;
+
+	return vmalloc_to_page((void *)buffer->user_page + pgoff * PAGE_SIZE);
+}
+
+static void perf_mmap_unmark_page(void *addr)
+{
+	struct page *page = vmalloc_to_page(addr);
+
+	page->mapping = NULL;
+}
+
+static void perf_buffer_free_work(struct work_struct *work)
+{
+	struct perf_buffer *buffer;
+	void *base;
+	int i, nr;
+
+	buffer = container_of(work, struct perf_buffer, work);
+	nr = 1 << perf_output_page_order(buffer);
+
+	base = buffer->user_page;
+	for (i = 0; i < nr + 1; i++)
+		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
+
+	vfree(base);
+	kfree(buffer);
+}
+
+void perf_buffer_free(struct perf_buffer *buffer)
+{
+	schedule_work(&buffer->work);
+}
+
+struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
+{
+	struct perf_buffer *buffer;
+	unsigned long size;
+	void *all_buf;
+
+	size = sizeof(struct perf_buffer);
+	size += sizeof(void *);
+
+	buffer = kzalloc(size, GFP_KERNEL);
+	if (!buffer)
+		goto fail;
+
+	INIT_WORK(&buffer->work, perf_buffer_free_work);
+
+	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
+	if (!all_buf)
+		goto fail_all_buf;
+
+	buffer->user_page = all_buf;
+	buffer->data_pages[0] = all_buf + PAGE_SIZE;
+	buffer->page_order = ilog2(nr_pages);
+	buffer->nr_pages = 1;
+
+	perf_buffer_init(buffer, watermark, flags);
+
+	return buffer;
+
+fail_all_buf:
+	kfree(buffer);
+
+fail:
+	return NULL;
+}
+
+#endif
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c09767f..b374fc2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -36,6 +36,8 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 
+#include "internal.h"
+
 #include <asm/irq_regs.h>
 
 struct remote_function_call {
@@ -3400,216 +3402,6 @@ unlock:
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
@@ -3892,117 +3684,6 @@ int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
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
@@ -4033,9 +3714,9 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
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
@@ -4062,121 +3743,14 @@ static void __perf_event__output_id_sample(struct perf_output_handle *handle,
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
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
new file mode 100644
index 0000000..2645cb9
--- /dev/null
+++ b/kernel/events/internal.h
@@ -0,0 +1,28 @@
+#ifndef _LINUX_KERNEL_EVENTS_H
+#define _LINUX_KERNEL_EVENTS_H
+
+#include <linux/perf_event.h>
+
+extern void perf_buffer_free(struct perf_buffer *buffer);
+extern struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags);
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
+perf_mmap_to_page(struct perf_buffer *buffer, unsigned long pgoff);
+
+static unsigned long perf_data_size(struct perf_buffer *buffer)
+{
+	return buffer->nr_pages << (PAGE_SHIFT + perf_output_page_order(buffer));
+}
+
+#endif /* _LINUX_KERNEL_EVENTS_H */
-- 
1.7.3.2

