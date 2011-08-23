Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab1HWS4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:56:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11693 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1HWS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:56:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=WYvkpaaYL/jCgFdsJQJuFxvKqV6E2gOOWLPRKVzePkJQmHP+XHS3UG6F1a5B7YklR
	BcnhtEIIj3aksSurW2Axg==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v3 4/5] trace: Make removal of ring buffer pages atomic
Date: Tue, 23 Aug 2011 11:55:57 -0700
Message-Id: <1314125758-5069-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313531179-9323-5-git-send-email-vnagarnaik@google.com>
References: <1313531179-9323-5-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the capability to remove pages from a ring buffer
without destroying any existing data in it.

This is done by removing the pages after the tail page. This makes sure
that first all the empty pages in the ring buffer are removed. If the
head page is one in the list of pages to be removed, then the page after
the removed ones is made the head page. This removes the oldest data
from the ring buffer and keeps the latest data around to be read.

To do this in a non-racey manner, tracing is stopped for a very short
time while the pages to be removed are identified and unlinked from the
ring buffer. The pages are freed after the tracing is restarted to
minimize the time needed to stop tracing.

The context in which the pages from the per-cpu ring buffer are removed
runs on the respective CPU. This minimizes the events not traced to only
NMI trace contexts.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
Changelog v3-v2:
* Fix compile errors

 kernel/trace/ring_buffer.c |  225 ++++++++++++++++++++++++++++++++------------
 kernel/trace/trace.c       |   20 +----
 2 files changed, 167 insertions(+), 78 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bb0ffdd..f10e439 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -23,6 +23,8 @@
 #include <asm/local.h>
 #include "trace.h"
 
+static void update_pages_handler(struct work_struct *work);
+
 /*
  * The ring buffer header is special. We must manually up keep it.
  */
@@ -502,6 +504,8 @@ struct ring_buffer_per_cpu {
 	/* ring buffer pages to update, > 0 to add, < 0 to remove */
 	int				nr_pages_to_update;
 	struct list_head		new_pages; /* new pages to add */
+	struct work_struct		update_pages_work;
+	struct completion		update_completion;
 };
 
 struct ring_buffer {
@@ -1080,6 +1084,8 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 	spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+	INIT_WORK(&cpu_buffer->update_pages_work, update_pages_handler);
+	init_completion(&cpu_buffer->update_completion);
 
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
@@ -1267,32 +1273,107 @@ void ring_buffer_set_clock(struct ring_buffer *buffer,
 
 static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
 
+static inline unsigned long rb_page_entries(struct buffer_page *bpage)
+{
+	return local_read(&bpage->entries) & RB_WRITE_MASK;
+}
+
+static inline unsigned long rb_page_write(struct buffer_page *bpage)
+{
+	return local_read(&bpage->write) & RB_WRITE_MASK;
+}
+
 static void
-rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
+rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
 {
-	struct buffer_page *bpage;
-	struct list_head *p;
-	unsigned i;
+	unsigned int nr_removed;
+	int page_entries;
+	struct list_head *tail_page, *to_remove, *next_page;
+	unsigned long head_bit;
+	struct buffer_page *last_page, *first_page;
+	struct buffer_page *to_remove_page, *tmp_iter_page;
 
+	head_bit = 0;
 	spin_lock_irq(&cpu_buffer->reader_lock);
-	rb_head_page_deactivate(cpu_buffer);
-
-	for (i = 0; i < nr_pages; i++) {
-		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
-			goto out;
-		p = cpu_buffer->pages->next;
-		bpage = list_entry(p, struct buffer_page, list);
-		list_del_init(&bpage->list);
-		free_buffer_page(bpage);
+	atomic_inc(&cpu_buffer->record_disabled);
+	/*
+	 * We don't race with the readers since we have acquired the reader
+	 * lock. We also don't race with writers after disabling recording.
+	 * This makes it easy to figure out the first and the last page to be
+	 * removed from the list. We remove all the pages in between including
+	 * the first and last pages. This is done in a busy loop so that we
+	 * lose the least number of traces.
+	 * The pages are freed after we restart recording and unlock readers.
+	 */
+	tail_page = &cpu_buffer->tail_page->list;
+	/*
+	 * tail page might be on reader page, we remove the next page
+	 * from the ring buffer
+	 */
+	if (cpu_buffer->tail_page == cpu_buffer->reader_page)
+		tail_page = rb_list_head(tail_page->next);
+	to_remove = tail_page;
+
+	/* start of pages to remove */
+	first_page = list_entry(rb_list_head(to_remove->next),
+				struct buffer_page, list);
+	for (nr_removed = 0; nr_removed < nr_pages; nr_removed++) {
+		to_remove = rb_list_head(to_remove)->next;
+		head_bit |= (unsigned long)to_remove & RB_PAGE_HEAD;
 	}
-	if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
-		goto out;
 
-	rb_reset_cpu(cpu_buffer);
-	rb_check_pages(cpu_buffer);
-
-out:
+	next_page = rb_list_head(to_remove)->next;
+	/* now we remove all pages between tail_page and next_page */
+	tail_page->next = (struct list_head *)((unsigned long)next_page |
+						head_bit);
+	next_page = rb_list_head(next_page);
+	next_page->prev = tail_page;
+	/* make sure pages points to a valid page in the ring buffer */
+	cpu_buffer->pages = next_page;
+	/* update head page */
+	if (head_bit)
+		cpu_buffer->head_page = list_entry(next_page,
+						struct buffer_page, list);
+	/*
+	 * change read pointer to make sure any read iterators reset
+	 * themselves
+	 */
+	cpu_buffer->read = 0;
+	/* pages are removed, resume tracing and then free the pages */
+	atomic_dec(&cpu_buffer->record_disabled);
 	spin_unlock_irq(&cpu_buffer->reader_lock);
+
+	RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages));
+
+	/* last buffer page to remove */
+	last_page = list_entry(rb_list_head(to_remove), struct buffer_page,
+				list);
+	tmp_iter_page = first_page;
+	do {
+		to_remove_page = tmp_iter_page;
+		rb_inc_page(cpu_buffer, &tmp_iter_page);
+		/* update the counters */
+		page_entries = rb_page_entries(to_remove_page);
+		if (page_entries) {
+			/*
+			 * If something was added to this page, it was full
+			 * since it is not the tail page. So we deduct the
+			 * bytes consumed in ring buffer from here.
+			 * No need to update overruns, since this page is
+			 * deleted from ring buffer and its entries are
+			 * already accounted for.
+			 */
+			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+		}
+		/*
+		 * We have already removed references to this list item, just
+		 * free up the buffer_page and its page
+		 */
+		nr_removed--;
+		free_buffer_page(to_remove_page);
+	} while (to_remove_page != last_page);
+
+	RB_WARN_ON(cpu_buffer, nr_removed);
 }
 
 static void
@@ -1303,6 +1384,12 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	struct list_head *p;
 	unsigned i;
 
+	/* stop the writers while inserting pages */
+	atomic_inc(&cpu_buffer->record_disabled);
+
+	/* Make sure all writers are done with this buffer. */
+	synchronize_sched();
+
 	spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
@@ -1319,17 +1406,21 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 out:
 	spin_unlock_irq(&cpu_buffer->reader_lock);
+	atomic_dec(&cpu_buffer->record_disabled);
 }
 
-static void update_pages_handler(struct ring_buffer_per_cpu *cpu_buffer)
+static void update_pages_handler(struct work_struct *work)
 {
+	struct ring_buffer_per_cpu *cpu_buffer = container_of(work,
+			struct ring_buffer_per_cpu, update_pages_work);
+
 	if (cpu_buffer->nr_pages_to_update > 0)
 		rb_insert_pages(cpu_buffer, &cpu_buffer->new_pages,
 				cpu_buffer->nr_pages_to_update);
 	else
 		rb_remove_pages(cpu_buffer, -cpu_buffer->nr_pages_to_update);
-	/* reset this value */
-	cpu_buffer->nr_pages_to_update = 0;
+
+	complete(&cpu_buffer->update_completion);
 }
 
 /**
@@ -1339,14 +1430,14 @@ static void update_pages_handler(struct ring_buffer_per_cpu *cpu_buffer)
  *
  * Minimum size is 2 * BUF_PAGE_SIZE.
  *
- * Returns -1 on failure.
+ * Returns 0 on success and < 0 on failure.
  */
 int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 			int cpu_id)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned nr_pages;
-	int cpu;
+	int cpu, err = 0;
 
 	/*
 	 * Always succeed at resizing a non-existent buffer:
@@ -1361,21 +1452,28 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 	if (size < BUF_PAGE_SIZE * 2)
 		size = BUF_PAGE_SIZE * 2;
 
-	atomic_inc(&buffer->record_disabled);
-
-	/* Make sure all writers are done with this buffer. */
-	synchronize_sched();
+	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 
+	/*
+	 * Don't succeed if recording is disabled globally, as a reader might
+	 * be manipulating the ring buffer and is expecting a sane state while
+	 * this is true.
+	 */
+	if (atomic_read(&buffer->record_disabled))
+		return -EBUSY;
+	/* prevent another thread from changing buffer sizes */
 	mutex_lock(&buffer->mutex);
-	get_online_cpus();
-
-	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 
 	if (cpu_id == RING_BUFFER_ALL_CPUS) {
 		/* calculate the pages to update */
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer = buffer->buffers[cpu];
 
+			if (atomic_read(&cpu_buffer->record_disabled)) {
+				err = -EBUSY;
+				goto out_err;
+			}
+
 			cpu_buffer->nr_pages_to_update = nr_pages -
 							cpu_buffer->nr_pages;
 
@@ -1391,21 +1489,38 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 			 */
 			INIT_LIST_HEAD(&cpu_buffer->new_pages);
 			if (__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
-						&cpu_buffer->new_pages, cpu))
+						&cpu_buffer->new_pages, cpu)) {
 				/* not enough memory for new pages */
-				goto no_mem;
+				err = -ENOMEM;
+				goto out_err;
+			}
+		}
+
+		/* fire off all the required work handlers */
+		for_each_buffer_cpu(buffer, cpu) {
+			cpu_buffer = buffer->buffers[cpu];
+			if (!cpu_buffer->nr_pages_to_update)
+				continue;
+			schedule_work_on(cpu, &cpu_buffer->update_pages_work);
 		}
 
 		/* wait for all the updates to complete */
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer = buffer->buffers[cpu];
-			if (cpu_buffer->nr_pages_to_update) {
-				update_pages_handler(cpu_buffer);
-				cpu_buffer->nr_pages = nr_pages;
-			}
+			if (!cpu_buffer->nr_pages_to_update)
+				continue;
+			wait_for_completion(&cpu_buffer->update_completion);
+			cpu_buffer->nr_pages = nr_pages;
+			/* reset this value */
+			cpu_buffer->nr_pages_to_update = 0;
 		}
 	} else {
 		cpu_buffer = buffer->buffers[cpu_id];
+		if (atomic_read(&cpu_buffer->record_disabled)) {
+			err = -EBUSY;
+			goto out_err;
+		}
+
 		if (nr_pages == cpu_buffer->nr_pages)
 			goto out;
 
@@ -1415,40 +1530,42 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 		INIT_LIST_HEAD(&cpu_buffer->new_pages);
 		if (cpu_buffer->nr_pages_to_update > 0 &&
 			__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
-						&cpu_buffer->new_pages, cpu_id))
-			goto no_mem;
+					&cpu_buffer->new_pages, cpu_id)) {
+			err = -ENOMEM;
+			goto out_err;
+		}
 
-		update_pages_handler(cpu_buffer);
+		schedule_work_on(cpu_id, &cpu_buffer->update_pages_work);
+		wait_for_completion(&cpu_buffer->update_completion);
 
 		cpu_buffer->nr_pages = nr_pages;
+		/* reset this value */
+		cpu_buffer->nr_pages_to_update = 0;
 	}
 
  out:
-	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
-
-	atomic_dec(&buffer->record_disabled);
-
 	return size;
 
- no_mem:
+ out_err:
 	for_each_buffer_cpu(buffer, cpu) {
 		struct buffer_page *bpage, *tmp;
+
 		cpu_buffer = buffer->buffers[cpu];
 		/* reset this number regardless */
 		cpu_buffer->nr_pages_to_update = 0;
+
 		if (list_empty(&cpu_buffer->new_pages))
 			continue;
+
 		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages,
 					list) {
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);
 		}
 	}
-	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
-	atomic_dec(&buffer->record_disabled);
-	return -ENOMEM;
+	return err;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
 
@@ -1487,21 +1604,11 @@ rb_iter_head_event(struct ring_buffer_iter *iter)
 	return __rb_page_index(iter->head_page, iter->head);
 }
 
-static inline unsigned long rb_page_write(struct buffer_page *bpage)
-{
-	return local_read(&bpage->write) & RB_WRITE_MASK;
-}
-
 static inline unsigned rb_page_commit(struct buffer_page *bpage)
 {
 	return local_read(&bpage->page->commit);
 }
 
-static inline unsigned long rb_page_entries(struct buffer_page *bpage)
-{
-	return local_read(&bpage->entries) & RB_WRITE_MASK;
-}
-
 /* Size is determined by what has been committed */
 static inline unsigned rb_page_size(struct buffer_page *bpage)
 {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bb3c867..736518f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2936,20 +2936,10 @@ static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 
 static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
 {
-	int cpu, ret = size;
+	int ret = size;
 
 	mutex_lock(&trace_types_lock);
 
-	tracing_stop();
-
-	/* disable all cpu buffers */
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_inc(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_inc(&max_tr.data[cpu]->disabled);
-	}
-
 	if (cpu_id != RING_BUFFER_ALL_CPUS) {
 		/* make sure, this cpu is enabled in the mask */
 		if (!cpumask_test_cpu(cpu_id, tracing_buffer_mask)) {
@@ -2963,14 +2953,6 @@ static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
 		ret = -ENOMEM;
 
 out:
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_dec(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_dec(&max_tr.data[cpu]->disabled);
-	}
-
-	tracing_start();
 	mutex_unlock(&trace_types_lock);
 
 	return ret;
-- 
1.7.3.1

