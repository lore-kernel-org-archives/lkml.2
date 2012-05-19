Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2ESKSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:18:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52017 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2ESKSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:18:37 -0400
Date: Sat, 19 May 2012 03:18:23 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-5040b4b7bcc26a311c799d46f67174bcb20d05dd@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, vnagarnaik@google.com,
        hpa@zytor.com, mingo@kernel.org, dhsharp@google.com,
        fweisbec@gmail.com, rostedt@goodmis.org, chavey@google.com,
        tglx@linutronix.de, teravest@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, dhsharp@google.com,
        fweisbec@gmail.com, rostedt@goodmis.org, chavey@google.com,
        tglx@linutronix.de, teravest@google.com
In-Reply-To: <1336096792-25373-2-git-send-email-vnagarnaik@google.com>
References: <1336096792-25373-2-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ring-buffer:
  Make addition of pages in ring buffer atomic
Git-Commit-ID: 5040b4b7bcc26a311c799d46f67174bcb20d05dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 19 May 2012 03:18:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5040b4b7bcc26a311c799d46f67174bcb20d05dd
Gitweb:     http://git.kernel.org/tip/5040b4b7bcc26a311c799d46f67174bcb20d05dd
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Thu, 3 May 2012 18:59:51 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 16 May 2012 16:25:51 -0400

ring-buffer: Make addition of pages in ring buffer atomic

This patch adds the capability to add new pages to a ring buffer
atomically while write operations are going on. This makes it possible
to expand the ring buffer size without reinitializing the ring buffer.

The new pages are attached between the head page and its previous page.

Link: http://lkml.kernel.org/r/1336096792-25373-2-git-send-email-vnagarnaik@google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Laurent Chavey <chavey@google.com>
Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |  102 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 77 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 27ac37e..d673ef0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1252,7 +1252,7 @@ static inline unsigned long rb_page_write(struct buffer_page *bpage)
 	return local_read(&bpage->write) & RB_WRITE_MASK;
 }
 
-static void
+static int
 rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
 {
 	struct list_head *tail_page, *to_remove, *next_page;
@@ -1359,46 +1359,97 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
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
 
 	raw_spin_lock_irq(&cpu_buffer->reader_lock);
-	/* stop the writers while inserting pages */
-	atomic_inc(&cpu_buffer->record_disabled);
-	rb_head_page_deactivate(cpu_buffer);
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
+		struct list_head *head_page, *prev_page, *r;
+		struct list_head *last_page, *first_page;
+		struct list_head *head_page_with_bit;
 
-	for (i = 0; i < nr_pages; i++) {
-		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
-			goto out;
-		p = pages->next;
-		bpage = list_entry(p, struct buffer_page, list);
-		list_del_init(&bpage->list);
-		list_add_tail(&bpage->list, cpu_buffer->pages);
+		head_page = &rb_set_head_page(cpu_buffer)->list;
+		prev_page = head_page->prev;
+
+		first_page = pages->next;
+		last_page  = pages->prev;
+
+		head_page_with_bit = (struct list_head *)
+				     ((unsigned long)head_page | RB_PAGE_HEAD);
+
+		last_page->next = head_page_with_bit;
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
-	atomic_dec(&cpu_buffer->record_disabled);
+	if (success)
+		INIT_LIST_HEAD(pages);
+	/*
+	 * If we weren't successful in adding in new pages, warn and stop
+	 * tracing
+	 */
+	RB_WARN_ON(cpu_buffer, !success);
 	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
+
+	/* free pages if they weren't inserted */
+	if (!success) {
+		struct buffer_page *bpage, *tmp;
+		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages,
+					 list) {
+			list_del_init(&bpage->list);
+			free_buffer_page(bpage);
+		}
+	}
+	return success;
 }
 
 static void rb_update_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
+	int success;
+
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
 }
 
 static void update_pages_handler(struct work_struct *work)
@@ -3772,6 +3823,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->commit_page = cpu_buffer->head_page;
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	INIT_LIST_HEAD(&cpu_buffer->new_pages);
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
