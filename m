Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1GZXAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:00:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1GZXAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:00:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=B0bOfiiQZcwG5ZXk37CmGyxjWt/gZr21rc0hpj47ZJa8qa0sIbhI5rpIaZZ42qx5P
	MbNywLtoF9UQrL6WkB8sA==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 4/5] trace: Make removal of ring buffer pages atomic
Date: Tue, 26 Jul 2011 15:59:53 -0700
Message-Id: <1311721194-12164-5-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the capability to remove pages from a ring buffer
atomically while write operations are going on. This makes it possible
to reduce the ring buffer size without losing any latest events from the
ring buffer.

This is done by moving the page after the tail page. This makes sure
that first all the empty pages in the ring buffer are removed. If the
page after tail page happens to be the head page, then that page is
removed and head page is moved forward to the next page. This removes
the oldest data from the ring buffer and keeps the latest data around to
be read.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/ring_buffer.c |  214 ++++++++++++++++++++++++++++++++++---------
 kernel/trace/trace.c       |   20 +----
 2 files changed, 170 insertions(+), 64 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 83450c9..0b43758 100644
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
@@ -1267,29 +1273,142 @@ void ring_buffer_set_clock(struct ring_buffer *buffer,
 
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
 rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 {
-	struct buffer_page *bpage;
-	struct list_head *p;
-	unsigned i;
+	struct list_head *tail_page;
+	unsigned int nr_removed;
+	int retries, page_entries;
+	struct list_head *to_remove, *next_page, *ret;
+	struct buffer_page *to_remove_page, *next_buffer_page;
 
 	spin_lock_irq(&cpu_buffer->reader_lock);
-	rb_head_page_deactivate(cpu_buffer);
+	/*
+	 * We don't race with the readers since we have acquired the reader
+	 * lock.
+	 * The only race would be with the writer in 2 conditions:
+	 * 1. When moving to the new page to write (not head)
+	 * 2. When moving to the head page
+	 * In both these cases, we make sure that if we get any failures, we
+	 * pick the next page available and continue the delete operation.
+	 */
+	nr_removed = 0;
+	retries = 3;
+	while (nr_removed < nr_pages) {
 
-	for (i = 0; i < nr_pages; i++) {
 		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
 			goto out;
-		p = cpu_buffer->pages->next;
-		bpage = list_entry(p, struct buffer_page, list);
-		list_del_init(&bpage->list);
-		free_buffer_page(bpage);
-	}
-	if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
-		goto out;
 
-	rb_reset_cpu(cpu_buffer);
-	rb_check_pages(cpu_buffer);
+		/*
+		 * Always get the fresh copy, the writer might have moved the
+		 * tail page while we are in this operation
+		 */
+		tail_page = &cpu_buffer->tail_page->list;
+		/*
+		 * tail page might be on reader page, we remove the next page
+		 * from the ring buffer
+		 */
+		if (cpu_buffer->tail_page == cpu_buffer->reader_page)
+			tail_page = rb_list_head(tail_page->next);
+		to_remove = tail_page->next;
+		next_page = rb_list_head(to_remove)->next;
+
+		ret = NULL;
+		if (((unsigned long)to_remove & RB_FLAG_MASK) == RB_PAGE_HEAD) {
+			/*
+			 * this is a head page, we have to set RB_PAGE_HEAD
+			 * flag while updating the next pointer
+			 */
+			unsigned long tmp = (unsigned long)next_page |
+							RB_PAGE_HEAD;
+			ret = cmpxchg(&tail_page->next, to_remove,
+					(struct list_head *) tmp);
+
+		} else if (((unsigned long)to_remove & ~RB_PAGE_HEAD) ==
+					(unsigned long)to_remove) {
+
+			/* not a head page, just update the next pointer */
+			ret = cmpxchg(&tail_page->next, to_remove, next_page);
+
+		} else {
+			/*
+			 * this means that this page is being operated on
+			 * try the next page in the list
+			 */
+		}
+
+		if (ret != to_remove) {
+			/*
+			 * Well, try again with the next page.
+			 * If we cannot move the page in 3 retries, there are
+			 * lot of interrupts on this cpu and probably causing
+			 * some weird behavior. Warn in this case and stop
+			 * tracing
+			 */
+			if (RB_WARN_ON(cpu_buffer, !retries--))
+				break;
+			else
+				continue;
+		}
+
+		/*
+		 * point the next_page->prev to skip the to_remove page to
+		 * complete the removal process
+		 */
+		rb_list_head(next_page)->prev = rb_list_head(to_remove)->prev;
+
+		/* yay, we removed the page */
+		nr_removed++;
+		/* for the next page to remove, reset retry counter */
+		retries = 3;
+
+		to_remove_page = list_entry(rb_list_head(to_remove),
+					struct buffer_page, list);
+		next_buffer_page = list_entry(rb_list_head(next_page),
+					struct buffer_page, list);
+
+		if (cpu_buffer->head_page == to_remove_page) {
+			/*
+			 * update head page and change read pointer to make
+			 * sure any read iterators reset themselves
+			 */
+			cpu_buffer->head_page = next_buffer_page;
+			cpu_buffer->read = 0;
+		}
+		/* Also, update the start of cpu_buffer to keep it valid */
+		cpu_buffer->pages = rb_list_head(next_page);
+
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
+
+		/*
+		 * We have already removed references to this list item, just
+		 * free up the buffer_page and its page
+		 */
+		free_buffer_page(to_remove_page);
+	}
+	RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages));
 
 out:
 	spin_unlock_irq(&cpu_buffer->reader_lock);
@@ -1303,6 +1422,12 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
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
 
@@ -1319,17 +1444,21 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
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
@@ -1361,15 +1490,10 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 	if (size < BUF_PAGE_SIZE * 2)
 		size = BUF_PAGE_SIZE * 2;
 
-	atomic_inc(&buffer->record_disabled);
-
-	/* Make sure all writers are done with this buffer. */
-	synchronize_sched();
+	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 
+	/* prevent another thread from changing buffer sizes */
 	mutex_lock(&buffer->mutex);
-	get_online_cpus();
-
-	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 
 	if (cpu_id == RING_BUFFER_ALL_CPUS) {
 		/* calculate the pages to update */
@@ -1396,13 +1520,23 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 				goto no_mem;
 		}
 
+		/* fire off all the required work handlers */
+		for_each_buffer_cpu(buffer, cpu) {
+			cpu_buffer = buffer->buffers[cpu];
+			if (!cpu_buffer->nr_pages_to_update)
+				continue;
+			schedule_work_on(cpu, &cpu_buffer->update_pages_work);
+		}
+
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
@@ -1418,36 +1552,36 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 						&cpu_buffer->new_pages, cpu_id))
 			goto no_mem;
 
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
 
  no_mem:
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
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
@@ -1487,21 +1621,11 @@ rb_iter_head_event(struct ring_buffer_iter *iter)
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
index 8ea48e0..72894c1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2934,20 +2934,10 @@ static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 
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
@@ -2961,14 +2951,6 @@ static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
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

