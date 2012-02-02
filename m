Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab2BBUBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:01:38 -0500
Received: from mail-fx0-f74.google.com ([209.85.161.74]:63837 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561Ab2BBUB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:01:27 -0500
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>, linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v5 3/4] trace: Make addition of pages in ring buffer atomic
Date: Thu,  2 Feb 2012 12:00:43 -0800
Message-Id: <1328212844-11889-3-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328212844-11889-1-git-send-email-vnagarnaik@google.com>
References: <1318382410-14967-1-git-send-email-vnagarnaik@google.com>
 <1328212844-11889-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the capability to add new pages to a ring buffer
atomically while write operations are going on. This makes it possible
to expand the ring buffer size without reinitializing the ring buffer.

The new pages are attached between the head page and its previous page.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
Changelog v5-v4:
* Rebased to latest upstream

 kernel/trace/ring_buffer.c |  128 +++++++++++++++++++++++++++++--------------
 1 files changed, 86 insertions(+), 42 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a7c66e4..5aef474 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -512,6 +512,7 @@ struct ring_buffer {
 	unsigned			flags;
 	int				cpus;
 	atomic_t			record_disabled;
+	atomic_t			resize_disabled;
 	cpumask_var_t			cpumask;
 
 	struct lock_class_key		*reader_lock_key;
@@ -1283,7 +1284,7 @@ static inline unsigned long rb_page_write(struct buffer_page *bpage)
 	return local_read(&bpage->write) & RB_WRITE_MASK;
 }
 
-static void
+static int
 rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
 {
 	unsigned int nr_removed;
@@ -1374,53 +1375,99 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
 	} while (to_remove_page != last_page);
 
 	RB_WARN_ON(cpu_buffer, nr_removed);
+
+	return nr_removed == 0;
 }
 
-static void
-rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
-		struct list_head *pages, unsigned nr_pages)
+static int
+rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct buffer_page *bpage;
-	struct list_head *p;
-	unsigned i;
+	struct list_head *pages = &cpu_buffer->new_pages;
+	int retries, success;
 
-	/* stop the writers while inserting pages */
-	atomic_inc(&cpu_buffer->record_disabled);
+	raw_spin_lock_irq(&cpu_buffer->reader_lock);
+	/*
+	 * We are holding the reader lock, so the reader page won't be swapped
+	 * in the ring buffer. Now we are racing with the writer trying to
+	 * move head page and the tail page.
+	 * We are going to adapt the reader page update process where:
+	 * 1. We first splice the start and end of list of new pages between
+	 *    the head page and its previous page.
+	 * 2. We cmpxchg the prev_page->next to point from head page to the
+	 *    start of new pages list.
+	 * 3. Finally, we update the head->prev to the end of new list.
+	 *
+	 * We will try this process 10 times, to make sure that we don't keep
+	 * spinning.
+	 */
+	retries = 10;
+	success = 0;
+	while (retries--) {
+		struct list_head *last_page, *first_page;
+		struct list_head *head_page, *prev_page, *r;
+		struct list_head *head_page_with_bit;
 
-	/* Make sure all writers are done with this buffer. */
-	synchronize_sched();
+		head_page = &rb_set_head_page(cpu_buffer)->list;
+		prev_page = head_page->prev;
 
-	raw_spin_lock_irq(&cpu_buffer->reader_lock);
-	rb_head_page_deactivate(cpu_buffer);
+		first_page = pages->next;
+		last_page  = pages->prev;
 
-	for (i = 0; i < nr_pages; i++) {
-		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
-			goto out;
-		p = pages->next;
-		bpage = list_entry(p, struct buffer_page, list);
-		list_del_init(&bpage->list);
-		list_add_tail(&bpage->list, cpu_buffer->pages);
+		head_page_with_bit = (struct list_head *)
+				((unsigned long)head_page | RB_PAGE_HEAD);
+
+		last_page->next  = head_page_with_bit;
+		first_page->prev = prev_page;
+
+		r = cmpxchg(&prev_page->next, head_page_with_bit, first_page);
+
+		if (r == head_page_with_bit) {
+			/*
+			 * yay, we replaced the page pointer to our new list,
+			 * now, we just have to update to head page's prev
+			 * pointer to point to end of list
+			 */
+			head_page->prev = last_page;
+			success = 1;
+			break;
+		}
 	}
-	rb_reset_cpu(cpu_buffer);
-	rb_check_pages(cpu_buffer);
 
-out:
+	if (success)
+		INIT_LIST_HEAD(pages);
+	/*
+	 * If we weren't successful in adding in new pages, warn and stop
+	 * tracing
+	 */
+	RB_WARN_ON(cpu_buffer, !success);
 	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
-	atomic_dec(&cpu_buffer->record_disabled);
+
+	/* free pages if they weren't inserted */
+	if (!success) {
+		struct buffer_page *bpage, *tmp;
+		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages,
+					list) {
+			list_del_init(&bpage->list);
+			free_buffer_page(bpage);
+		}
+	}
+	return success;
 }
 
 static void update_pages_handler(struct work_struct *work)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = container_of(work,
 			struct ring_buffer_per_cpu, update_pages_work);
+	int success;
 
 	if (cpu_buffer->nr_pages_to_update > 0)
-		rb_insert_pages(cpu_buffer, &cpu_buffer->new_pages,
-				cpu_buffer->nr_pages_to_update);
+		success = rb_insert_pages(cpu_buffer);
 	else
-		rb_remove_pages(cpu_buffer, -cpu_buffer->nr_pages_to_update);
+		success = rb_remove_pages(cpu_buffer,
+					-cpu_buffer->nr_pages_to_update);
 
-	cpu_buffer->nr_pages += cpu_buffer->nr_pages_to_update;
+	if (success)
+		cpu_buffer->nr_pages += cpu_buffer->nr_pages_to_update;
 	complete(&cpu_buffer->update_completion);
 }
 
@@ -1456,11 +1503,11 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 
 	/*
-	 * Don't succeed if recording is disabled globally, as a reader might
-	 * be manipulating the ring buffer and is expecting a sane state while
+	 * Don't succeed if resizing is disabled, as a reader might be
+	 * manipulating the ring buffer and is expecting a sane state while
 	 * this is true.
 	 */
-	if (atomic_read(&buffer->record_disabled))
+	if (atomic_read(&buffer->resize_disabled))
 		return -EBUSY;
 	/* prevent another thread from changing buffer sizes */
 	mutex_lock(&buffer->mutex);
@@ -1470,11 +1517,6 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer = buffer->buffers[cpu];
 
-			if (atomic_read(&cpu_buffer->record_disabled)) {
-				err = -EBUSY;
-				goto out_err;
-			}
-
 			cpu_buffer->nr_pages_to_update = nr_pages -
 							cpu_buffer->nr_pages;
 
@@ -1516,11 +1558,6 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 		}
 	} else {
 		cpu_buffer = buffer->buffers[cpu_id];
-		if (atomic_read(&cpu_buffer->record_disabled)) {
-			err = -EBUSY;
-			goto out_err;
-		}
-
 		if (nr_pages == cpu_buffer->nr_pages)
 			goto out;
 
@@ -1537,7 +1574,6 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 
 		schedule_work_on(cpu_id, &cpu_buffer->update_pages_work);
 		wait_for_completion(&cpu_buffer->update_completion);
-
 		/* reset this value */
 		cpu_buffer->nr_pages_to_update = 0;
 	}
@@ -3575,6 +3611,7 @@ ring_buffer_read_prepare(struct ring_buffer *buffer, int cpu)
 
 	iter->cpu_buffer = cpu_buffer;
 
+	atomic_inc(&buffer->resize_disabled);
 	atomic_inc(&cpu_buffer->record_disabled);
 
 	return iter;
@@ -3638,6 +3675,7 @@ ring_buffer_read_finish(struct ring_buffer_iter *iter)
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 
 	atomic_dec(&cpu_buffer->record_disabled);
+	atomic_dec(&cpu_buffer->buffer->resize_disabled);
 	kfree(iter);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_finish);
@@ -3709,6 +3747,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->commit_page = cpu_buffer->head_page;
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	INIT_LIST_HEAD(&cpu_buffer->new_pages);
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
@@ -3745,8 +3784,12 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
+	atomic_inc(&buffer->resize_disabled);
 	atomic_inc(&cpu_buffer->record_disabled);
 
+	/* Make sure all commits have finished */
+	synchronize_sched();
+
 	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
@@ -3762,6 +3805,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	atomic_dec(&cpu_buffer->record_disabled);
+	atomic_dec(&buffer->resize_disabled);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
-- 
1.7.7.3

