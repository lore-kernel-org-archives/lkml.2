Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab0FIKRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:17:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:36356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab0FIKRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:17:14 -0400
Date: Wed, 9 Jun 2010 10:16:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Rename perf_mmap_data to perf_buffer
Message-ID: <tip-ca5135e6b4a3cbc7e187737520fbc4b508f6f7a2@git.kernel.org>
Git-Commit-ID: ca5135e6b4a3cbc7e187737520fbc4b508f6f7a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:16:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca5135e6b4a3cbc7e187737520fbc4b508f6f7a2
Gitweb:     http://git.kernel.org/tip/ca5135e6b4a3cbc7e187737520fbc4b508f6f7a2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 28 May 2010 19:33:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:35 +0200

perf: Rename perf_mmap_data to perf_buffer

Rename to clarify code.

s/perf_mmap_data/perf_buffer/g and selective s/data/buffer/g

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    6 +-
 kernel/perf_event.c        |  308 ++++++++++++++++++++++----------------------
 2 files changed, 157 insertions(+), 157 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f1b6ba0..2a0da02 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -602,7 +602,7 @@ enum perf_event_active_state {
 
 struct file;
 
-struct perf_mmap_data {
+struct perf_buffer {
 	atomic_t			refcount;
 	struct rcu_head			rcu_head;
 #ifdef CONFIG_PERF_USE_VMALLOC
@@ -727,7 +727,7 @@ struct perf_event {
 	atomic_t			mmap_count;
 	int				mmap_locked;
 	struct user_struct		*mmap_user;
-	struct perf_mmap_data		*data;
+	struct perf_buffer		*buffer;
 
 	/* poll related */
 	wait_queue_head_t		waitq;
@@ -825,7 +825,7 @@ struct perf_cpu_context {
 
 struct perf_output_handle {
 	struct perf_event		*event;
-	struct perf_mmap_data		*data;
+	struct perf_buffer		*buffer;
 	unsigned long			wakeup;
 	unsigned long			size;
 	void				*addr;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6f60920..93d5458 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1876,7 +1876,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void perf_pending_sync(struct perf_event *event);
-static void perf_mmap_data_put(struct perf_mmap_data *data);
+static void perf_buffer_put(struct perf_buffer *buffer);
 
 static void free_event(struct perf_event *event)
 {
@@ -1892,9 +1892,9 @@ static void free_event(struct perf_event *event)
 			atomic_dec(&nr_task_events);
 	}
 
-	if (event->data) {
-		perf_mmap_data_put(event->data);
-		event->data = NULL;
+	if (event->buffer) {
+		perf_buffer_put(event->buffer);
+		event->buffer = NULL;
 	}
 
 	if (event->destroy)
@@ -2119,13 +2119,13 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 	unsigned int events = POLL_HUP;
 
 	rcu_read_lock();
-	data = rcu_dereference(event->data);
-	if (data)
-		events = atomic_xchg(&data->poll, 0);
+	buffer = rcu_dereference(event->buffer);
+	if (buffer)
+		events = atomic_xchg(&buffer->poll, 0);
 	rcu_read_unlock();
 
 	poll_wait(file, &event->waitq, wait);
@@ -2335,14 +2335,14 @@ static int perf_event_index(struct perf_event *event)
 void perf_event_update_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 
 	rcu_read_lock();
-	data = rcu_dereference(event->data);
-	if (!data)
+	buffer = rcu_dereference(event->buffer);
+	if (!buffer)
 		goto unlock;
 
-	userpg = data->user_page;
+	userpg = buffer->user_page;
 
 	/*
 	 * Disable preemption so as to not let the corresponding user-space
@@ -2376,15 +2376,15 @@ unlock:
  */
 
 static struct page *
-perf_mmap_to_page(struct perf_mmap_data *data, unsigned long pgoff)
+perf_mmap_to_page(struct perf_buffer *buffer, unsigned long pgoff)
 {
-	if (pgoff > data->nr_pages)
+	if (pgoff > buffer->nr_pages)
 		return NULL;
 
 	if (pgoff == 0)
-		return virt_to_page(data->user_page);
+		return virt_to_page(buffer->user_page);
 
-	return virt_to_page(data->data_pages[pgoff - 1]);
+	return virt_to_page(buffer->data_pages[pgoff - 1]);
 }
 
 static void *perf_mmap_alloc_page(int cpu)
@@ -2400,42 +2400,42 @@ static void *perf_mmap_alloc_page(int cpu)
 	return page_address(page);
 }
 
-static struct perf_mmap_data *
-perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
+static struct perf_buffer *
+perf_buffer_alloc(struct perf_event *event, int nr_pages)
 {
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 	unsigned long size;
 	int i;
 
-	size = sizeof(struct perf_mmap_data);
+	size = sizeof(struct perf_buffer);
 	size += nr_pages * sizeof(void *);
 
-	data = kzalloc(size, GFP_KERNEL);
-	if (!data)
+	buffer = kzalloc(size, GFP_KERNEL);
+	if (!buffer)
 		goto fail;
 
-	data->user_page = perf_mmap_alloc_page(event->cpu);
-	if (!data->user_page)
+	buffer->user_page = perf_mmap_alloc_page(event->cpu);
+	if (!buffer->user_page)
 		goto fail_user_page;
 
 	for (i = 0; i < nr_pages; i++) {
-		data->data_pages[i] = perf_mmap_alloc_page(event->cpu);
-		if (!data->data_pages[i])
+		buffer->data_pages[i] = perf_mmap_alloc_page(event->cpu);
+		if (!buffer->data_pages[i])
 			goto fail_data_pages;
 	}
 
-	data->nr_pages = nr_pages;
+	buffer->nr_pages = nr_pages;
 
-	return data;
+	return buffer;
 
 fail_data_pages:
 	for (i--; i >= 0; i--)
-		free_page((unsigned long)data->data_pages[i]);
+		free_page((unsigned long)buffer->data_pages[i]);
 
-	free_page((unsigned long)data->user_page);
+	free_page((unsigned long)buffer->user_page);
 
 fail_user_page:
-	kfree(data);
+	kfree(buffer);
 
 fail:
 	return NULL;
@@ -2449,17 +2449,17 @@ static void perf_mmap_free_page(unsigned long addr)
 	__free_page(page);
 }
 
-static void perf_mmap_data_free(struct perf_mmap_data *data)
+static void perf_buffer_free(struct perf_buffer *buffer)
 {
 	int i;
 
-	perf_mmap_free_page((unsigned long)data->user_page);
-	for (i = 0; i < data->nr_pages; i++)
-		perf_mmap_free_page((unsigned long)data->data_pages[i]);
-	kfree(data);
+	perf_mmap_free_page((unsigned long)buffer->user_page);
+	for (i = 0; i < buffer->nr_pages; i++)
+		perf_mmap_free_page((unsigned long)buffer->data_pages[i]);
+	kfree(buffer);
 }
 
-static inline int page_order(struct perf_mmap_data *data)
+static inline int page_order(struct perf_buffer *buffer)
 {
 	return 0;
 }
@@ -2472,18 +2472,18 @@ static inline int page_order(struct perf_mmap_data *data)
  * Required for architectures that have d-cache aliasing issues.
  */
 
-static inline int page_order(struct perf_mmap_data *data)
+static inline int page_order(struct perf_buffer *buffer)
 {
-	return data->page_order;
+	return buffer->page_order;
 }
 
 static struct page *
-perf_mmap_to_page(struct perf_mmap_data *data, unsigned long pgoff)
+perf_mmap_to_page(struct perf_buffer *buffer, unsigned long pgoff)
 {
-	if (pgoff > (1UL << page_order(data)))
+	if (pgoff > (1UL << page_order(buffer)))
 		return NULL;
 
-	return vmalloc_to_page((void *)data->user_page + pgoff * PAGE_SIZE);
+	return vmalloc_to_page((void *)buffer->user_page + pgoff * PAGE_SIZE);
 }
 
 static void perf_mmap_unmark_page(void *addr)
@@ -2493,57 +2493,57 @@ static void perf_mmap_unmark_page(void *addr)
 	page->mapping = NULL;
 }
 
-static void perf_mmap_data_free_work(struct work_struct *work)
+static void perf_buffer_free_work(struct work_struct *work)
 {
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 	void *base;
 	int i, nr;
 
-	data = container_of(work, struct perf_mmap_data, work);
-	nr = 1 << page_order(data);
+	buffer = container_of(work, struct perf_buffer, work);
+	nr = 1 << page_order(buffer);
 
-	base = data->user_page;
+	base = buffer->user_page;
 	for (i = 0; i < nr + 1; i++)
 		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
 
 	vfree(base);
-	kfree(data);
+	kfree(buffer);
 }
 
-static void perf_mmap_data_free(struct perf_mmap_data *data)
+static void perf_buffer_free(struct perf_buffer *buffer)
 {
-	schedule_work(&data->work);
+	schedule_work(&buffer->work);
 }
 
-static struct perf_mmap_data *
-perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
+static struct perf_buffer *
+perf_buffer_alloc(struct perf_event *event, int nr_pages)
 {
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 	unsigned long size;
 	void *all_buf;
 
-	size = sizeof(struct perf_mmap_data);
+	size = sizeof(struct perf_buffer);
 	size += sizeof(void *);
 
-	data = kzalloc(size, GFP_KERNEL);
-	if (!data)
+	buffer = kzalloc(size, GFP_KERNEL);
+	if (!buffer)
 		goto fail;
 
-	INIT_WORK(&data->work, perf_mmap_data_free_work);
+	INIT_WORK(&buffer->work, perf_buffer_free_work);
 
 	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
 	if (!all_buf)
 		goto fail_all_buf;
 
-	data->user_page = all_buf;
-	data->data_pages[0] = all_buf + PAGE_SIZE;
-	data->page_order = ilog2(nr_pages);
-	data->nr_pages = 1;
+	buffer->user_page = all_buf;
+	buffer->data_pages[0] = all_buf + PAGE_SIZE;
+	buffer->page_order = ilog2(nr_pages);
+	buffer->nr_pages = 1;
 
-	return data;
+	return buffer;
 
 fail_all_buf:
-	kfree(data);
+	kfree(buffer);
 
 fail:
 	return NULL;
@@ -2551,15 +2551,15 @@ fail:
 
 #endif
 
-static unsigned long perf_data_size(struct perf_mmap_data *data)
+static unsigned long perf_data_size(struct perf_buffer *buffer)
 {
-	return data->nr_pages << (PAGE_SHIFT + page_order(data));
+	return buffer->nr_pages << (PAGE_SHIFT + page_order(buffer));
 }
 
 static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct perf_event *event = vma->vm_file->private_data;
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 	int ret = VM_FAULT_SIGBUS;
 
 	if (vmf->flags & FAULT_FLAG_MKWRITE) {
@@ -2569,14 +2569,14 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 
 	rcu_read_lock();
-	data = rcu_dereference(event->data);
-	if (!data)
+	buffer = rcu_dereference(event->buffer);
+	if (!buffer)
 		goto unlock;
 
 	if (vmf->pgoff && (vmf->flags & FAULT_FLAG_WRITE))
 		goto unlock;
 
-	vmf->page = perf_mmap_to_page(data, vmf->pgoff);
+	vmf->page = perf_mmap_to_page(buffer, vmf->pgoff);
 	if (!vmf->page)
 		goto unlock;
 
@@ -2592,51 +2592,51 @@ unlock:
 }
 
 static void
-perf_mmap_data_init(struct perf_event *event, struct perf_mmap_data *data)
+perf_buffer_init(struct perf_event *event, struct perf_buffer *buffer)
 {
-	long max_size = perf_data_size(data);
+	long max_size = perf_data_size(buffer);
 
 	if (event->attr.watermark) {
-		data->watermark = min_t(long, max_size,
+		buffer->watermark = min_t(long, max_size,
 					event->attr.wakeup_watermark);
 	}
 
-	if (!data->watermark)
-		data->watermark = max_size / 2;
+	if (!buffer->watermark)
+		buffer->watermark = max_size / 2;
 
-	atomic_set(&data->refcount, 1);
-	rcu_assign_pointer(event->data, data);
+	atomic_set(&buffer->refcount, 1);
+	rcu_assign_pointer(event->buffer, buffer);
 }
 
-static void perf_mmap_data_free_rcu(struct rcu_head *rcu_head)
+static void perf_buffer_free_rcu(struct rcu_head *rcu_head)
 {
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 
-	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
-	perf_mmap_data_free(data);
+	buffer = container_of(rcu_head, struct perf_buffer, rcu_head);
+	perf_buffer_free(buffer);
 }
 
-static struct perf_mmap_data *perf_mmap_data_get(struct perf_event *event)
+static struct perf_buffer *perf_buffer_get(struct perf_event *event)
 {
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 
 	rcu_read_lock();
-	data = rcu_dereference(event->data);
-	if (data) {
-		if (!atomic_inc_not_zero(&data->refcount))
-			data = NULL;
+	buffer = rcu_dereference(event->buffer);
+	if (buffer) {
+		if (!atomic_inc_not_zero(&buffer->refcount))
+			buffer = NULL;
 	}
 	rcu_read_unlock();
 
-	return data;
+	return buffer;
 }
 
-static void perf_mmap_data_put(struct perf_mmap_data *data)
+static void perf_buffer_put(struct perf_buffer *buffer)
 {
-	if (!atomic_dec_and_test(&data->refcount))
+	if (!atomic_dec_and_test(&buffer->refcount))
 		return;
 
-	call_rcu(&data->rcu_head, perf_mmap_data_free_rcu);
+	call_rcu(&buffer->rcu_head, perf_buffer_free_rcu);
 }
 
 static void perf_mmap_open(struct vm_area_struct *vma)
@@ -2651,16 +2651,16 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->data);
+		unsigned long size = perf_data_size(event->buffer);
 		struct user_struct *user = event->mmap_user;
-		struct perf_mmap_data *data = event->data;
+		struct perf_buffer *buffer = event->buffer;
 
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
 		vma->vm_mm->locked_vm -= event->mmap_locked;
-		rcu_assign_pointer(event->data, NULL);
+		rcu_assign_pointer(event->buffer, NULL);
 		mutex_unlock(&event->mmap_mutex);
 
-		perf_mmap_data_put(data);
+		perf_buffer_put(buffer);
 		free_uid(user);
 	}
 }
@@ -2678,7 +2678,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
 	unsigned long locked, lock_limit;
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 	unsigned long vma_size;
 	unsigned long nr_pages;
 	long user_extra, extra;
@@ -2699,7 +2699,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
 	/*
-	 * If we have data pages ensure they're a power-of-two number, so we
+	 * If we have buffer pages ensure they're a power-of-two number, so we
 	 * can do bitmasks instead of modulo.
 	 */
 	if (nr_pages != 0 && !is_power_of_2(nr_pages))
@@ -2713,9 +2713,9 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	mutex_lock(&event->mmap_mutex);
-	if (event->data) {
-		if (event->data->nr_pages == nr_pages)
-			atomic_inc(&event->data->refcount);
+	if (event->buffer) {
+		if (event->buffer->nr_pages == nr_pages)
+			atomic_inc(&event->buffer->refcount);
 		else
 			ret = -EINVAL;
 		goto unlock;
@@ -2745,17 +2745,17 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		goto unlock;
 	}
 
-	WARN_ON(event->data);
+	WARN_ON(event->buffer);
 
-	data = perf_mmap_data_alloc(event, nr_pages);
-	if (!data) {
+	buffer = perf_buffer_alloc(event, nr_pages);
+	if (!buffer) {
 		ret = -ENOMEM;
 		goto unlock;
 	}
 
-	perf_mmap_data_init(event, data);
+	perf_buffer_init(event, buffer);
 	if (vma->vm_flags & VM_WRITE)
-		event->data->writable = 1;
+		event->buffer->writable = 1;
 
 	atomic_long_add(user_extra, &user->locked_vm);
 	event->mmap_locked = extra;
@@ -2964,15 +2964,15 @@ EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
 /*
  * Output
  */
-static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
+static bool perf_output_space(struct perf_buffer *buffer, unsigned long tail,
 			      unsigned long offset, unsigned long head)
 {
 	unsigned long mask;
 
-	if (!data->writable)
+	if (!buffer->writable)
 		return true;
 
-	mask = perf_data_size(data) - 1;
+	mask = perf_data_size(buffer) - 1;
 
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
@@ -2985,7 +2985,7 @@ static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
 
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
-	atomic_set(&handle->data->poll, POLL_IN);
+	atomic_set(&handle->buffer->poll, POLL_IN);
 
 	if (handle->nmi) {
 		handle->event->pending_wakeup = 1;
@@ -3005,45 +3005,45 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
  */
 static void perf_output_get_handle(struct perf_output_handle *handle)
 {
-	struct perf_mmap_data *data = handle->data;
+	struct perf_buffer *buffer = handle->buffer;
 
 	preempt_disable();
-	local_inc(&data->nest);
-	handle->wakeup = local_read(&data->wakeup);
+	local_inc(&buffer->nest);
+	handle->wakeup = local_read(&buffer->wakeup);
 }
 
 static void perf_output_put_handle(struct perf_output_handle *handle)
 {
-	struct perf_mmap_data *data = handle->data;
+	struct perf_buffer *buffer = handle->buffer;
 	unsigned long head;
 
 again:
-	head = local_read(&data->head);
+	head = local_read(&buffer->head);
 
 	/*
 	 * IRQ/NMI can happen here, which means we can miss a head update.
 	 */
 
-	if (!local_dec_and_test(&data->nest))
+	if (!local_dec_and_test(&buffer->nest))
 		goto out;
 
 	/*
 	 * Publish the known good head. Rely on the full barrier implied
-	 * by atomic_dec_and_test() order the data->head read and this
+	 * by atomic_dec_and_test() order the buffer->head read and this
 	 * write.
 	 */
-	data->user_page->data_head = head;
+	buffer->user_page->data_head = head;
 
 	/*
 	 * Now check if we missed an update, rely on the (compiler)
-	 * barrier in atomic_dec_and_test() to re-read data->head.
+	 * barrier in atomic_dec_and_test() to re-read buffer->head.
 	 */
-	if (unlikely(head != local_read(&data->head))) {
-		local_inc(&data->nest);
+	if (unlikely(head != local_read(&buffer->head))) {
+		local_inc(&buffer->nest);
 		goto again;
 	}
 
-	if (handle->wakeup != local_read(&data->wakeup))
+	if (handle->wakeup != local_read(&buffer->wakeup))
 		perf_output_wakeup(handle);
 
  out:
@@ -3063,12 +3063,12 @@ __always_inline void perf_output_copy(struct perf_output_handle *handle,
 		buf += size;
 		handle->size -= size;
 		if (!handle->size) {
-			struct perf_mmap_data *data = handle->data;
+			struct perf_buffer *buffer = handle->buffer;
 
 			handle->page++;
-			handle->page &= data->nr_pages - 1;
-			handle->addr = data->data_pages[handle->page];
-			handle->size = PAGE_SIZE << page_order(data);
+			handle->page &= buffer->nr_pages - 1;
+			handle->addr = buffer->data_pages[handle->page];
+			handle->size = PAGE_SIZE << page_order(buffer);
 		}
 	} while (len);
 }
@@ -3077,7 +3077,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size,
 		      int nmi, int sample)
 {
-	struct perf_mmap_data *data;
+	struct perf_buffer *buffer;
 	unsigned long tail, offset, head;
 	int have_lost;
 	struct {
@@ -3093,19 +3093,19 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (event->parent)
 		event = event->parent;
 
-	data = rcu_dereference(event->data);
-	if (!data)
+	buffer = rcu_dereference(event->buffer);
+	if (!buffer)
 		goto out;
 
-	handle->data	= data;
+	handle->buffer	= buffer;
 	handle->event	= event;
 	handle->nmi	= nmi;
 	handle->sample	= sample;
 
-	if (!data->nr_pages)
+	if (!buffer->nr_pages)
 		goto out;
 
-	have_lost = local_read(&data->lost);
+	have_lost = local_read(&buffer->lost);
 	if (have_lost)
 		size += sizeof(lost_event);
 
@@ -3117,30 +3117,30 @@ int perf_output_begin(struct perf_output_handle *handle,
 		 * tail pointer. So that all reads will be completed before the
 		 * write is issued.
 		 */
-		tail = ACCESS_ONCE(data->user_page->data_tail);
+		tail = ACCESS_ONCE(buffer->user_page->data_tail);
 		smp_rmb();
-		offset = head = local_read(&data->head);
+		offset = head = local_read(&buffer->head);
 		head += size;
-		if (unlikely(!perf_output_space(data, tail, offset, head)))
+		if (unlikely(!perf_output_space(buffer, tail, offset, head)))
 			goto fail;
-	} while (local_cmpxchg(&data->head, offset, head) != offset);
+	} while (local_cmpxchg(&buffer->head, offset, head) != offset);
 
-	if (head - local_read(&data->wakeup) > data->watermark)
-		local_add(data->watermark, &data->wakeup);
+	if (head - local_read(&buffer->wakeup) > buffer->watermark)
+		local_add(buffer->watermark, &buffer->wakeup);
 
-	handle->page = offset >> (PAGE_SHIFT + page_order(data));
-	handle->page &= data->nr_pages - 1;
-	handle->size = offset & ((PAGE_SIZE << page_order(data)) - 1);
-	handle->addr = data->data_pages[handle->page];
+	handle->page = offset >> (PAGE_SHIFT + page_order(buffer));
+	handle->page &= buffer->nr_pages - 1;
+	handle->size = offset & ((PAGE_SIZE << page_order(buffer)) - 1);
+	handle->addr = buffer->data_pages[handle->page];
 	handle->addr += handle->size;
-	handle->size = (PAGE_SIZE << page_order(data)) - handle->size;
+	handle->size = (PAGE_SIZE << page_order(buffer)) - handle->size;
 
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;
 		lost_event.header.misc = 0;
 		lost_event.header.size = sizeof(lost_event);
 		lost_event.id          = event->id;
-		lost_event.lost        = local_xchg(&data->lost, 0);
+		lost_event.lost        = local_xchg(&buffer->lost, 0);
 
 		perf_output_put(handle, lost_event);
 	}
@@ -3148,7 +3148,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	return 0;
 
 fail:
-	local_inc(&data->lost);
+	local_inc(&buffer->lost);
 	perf_output_put_handle(handle);
 out:
 	rcu_read_unlock();
@@ -3159,15 +3159,15 @@ out:
 void perf_output_end(struct perf_output_handle *handle)
 {
 	struct perf_event *event = handle->event;
-	struct perf_mmap_data *data = handle->data;
+	struct perf_buffer *buffer = handle->buffer;
 
 	int wakeup_events = event->attr.wakeup_events;
 
 	if (handle->sample && wakeup_events) {
-		int events = local_inc_return(&data->events);
+		int events = local_inc_return(&buffer->events);
 		if (events >= wakeup_events) {
-			local_sub(wakeup_events, &data->events);
-			local_inc(&data->wakeup);
+			local_sub(wakeup_events, &buffer->events);
+			local_inc(&buffer->wakeup);
 		}
 	}
 
@@ -5010,7 +5010,7 @@ err_size:
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct perf_mmap_data *data = NULL, *old_data = NULL;
+	struct perf_buffer *buffer = NULL, *old_buffer = NULL;
 	int ret = -EINVAL;
 
 	if (!output_event)
@@ -5040,19 +5040,19 @@ set:
 
 	if (output_event) {
 		/* get the buffer we want to redirect to */
-		data = perf_mmap_data_get(output_event);
-		if (!data)
+		buffer = perf_buffer_get(output_event);
+		if (!buffer)
 			goto unlock;
 	}
 
-	old_data = event->data;
-	rcu_assign_pointer(event->data, data);
+	old_buffer = event->buffer;
+	rcu_assign_pointer(event->buffer, buffer);
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
 
-	if (old_data)
-		perf_mmap_data_put(old_data);
+	if (old_buffer)
+		perf_buffer_put(old_buffer);
 out:
 	return ret;
 }
