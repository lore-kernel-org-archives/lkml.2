Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab1HWS4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:56:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11682 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1HWS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:56:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=vFxat9MTJqfF8wpamZQGLNO/FM4okVH9r1ZwZBG6OCs9TsyySAG+ZH63cHeuLzaWT
	222U6iniLws/1uhl0t4Iw==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v3 5/5] trace: Make addition of pages in ring buffer atomic
Date: Tue, 23 Aug 2011 11:55:58 -0700
Message-Id: <1314125758-5069-2-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313531179-9323-5-git-send-email-vnagarnaik@google.com>
References: <1313531179-9323-5-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the capability to add new pages to a ring buffer
atomically while write operations are going on. This makes it possible
to expand the ring buffer size without reinitializing the ring buffer.

The new pages are attached between the head page and its previous page.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
Changelog v3-v2:
* Fix compile errors

 kernel/trace/ring_buffer.c |   79 ++++++++++++++++++++++++++++++-------------
 1 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f10e439..5381168 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1377,36 +1377,67 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
 }
 
 static void
-rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
-		struct list_head *pages, unsigned nr_pages)
+rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct buffer_page *bpage;
-	struct list_head *p;
-	unsigned i;
+	struct list_head *pages = &cpu_buffer->new_pages;
+	int retries, success;
 
-	/* stop the writers while inserting pages */
-	atomic_inc(&cpu_buffer->record_disabled);
+	spin_lock_irq(&cpu_buffer->reader_lock);
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
 
-	spin_lock_irq(&cpu_buffer->reader_lock);
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
 	spin_unlock_irq(&cpu_buffer->reader_lock);
-	atomic_dec(&cpu_buffer->record_disabled);
 }
 
 static void update_pages_handler(struct work_struct *work)
@@ -1415,8 +1446,7 @@ static void update_pages_handler(struct work_struct *work)
 			struct ring_buffer_per_cpu, update_pages_work);
 
 	if (cpu_buffer->nr_pages_to_update > 0)
-		rb_insert_pages(cpu_buffer, &cpu_buffer->new_pages,
-				cpu_buffer->nr_pages_to_update);
+		rb_insert_pages(cpu_buffer);
 	else
 		rb_remove_pages(cpu_buffer, -cpu_buffer->nr_pages_to_update);
 
@@ -3710,6 +3740,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->commit_page = cpu_buffer->head_page;
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	INIT_LIST_HEAD(&cpu_buffer->new_pages);
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
-- 
1.7.3.1

