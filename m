Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2LKJTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:19:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46727 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2LKJTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:19:49 -0500
Date: Tue, 11 Dec 2012 10:19:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes for v3.8
Message-ID: <20121211091943.GA23647@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 08cd2a6960ae2e1aa7f44b44ebafa84f503a2dd1 Merge branch 'tip/perf/urgent-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent

These are late-v3.7 pending fixes for tracing.

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      ftrace: Clear bits properly in reset_iter_read()

Steven Rostedt (2):
      ring-buffer: Fix NULL pointer if rb_set_head_page() fails
      ring-buffer: Fix race between integrity check and readers


 kernel/trace/ftrace.c      |  2 +-
 kernel/trace/ring_buffer.c | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9dcf15d..51b7159 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2437,7 +2437,7 @@ static void reset_iter_read(struct ftrace_iterator *iter)
 {
 	iter->pos = 0;
 	iter->func_pos = 0;
-	iter->flags &= ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
+	iter->flags &= ~(FTRACE_ITER_PRINTALL | FTRACE_ITER_HASH);
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b979426..4cb5e51 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1396,6 +1396,8 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer)
 		struct list_head *head_page_with_bit;
 
 		head_page = &rb_set_head_page(cpu_buffer)->list;
+		if (!head_page)
+			break;
 		prev_page = head_page->prev;
 
 		first_page = pages->next;
@@ -2934,7 +2936,7 @@ unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
 	unsigned long flags;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long ret;
+	unsigned long ret = 0;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
@@ -2949,7 +2951,8 @@ unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
 		bpage = cpu_buffer->reader_page;
 	else
 		bpage = rb_set_head_page(cpu_buffer);
-	ret = bpage->page->time_stamp;
+	if (bpage)
+		ret = bpage->page->time_stamp;
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return ret;
@@ -3260,6 +3263,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
+	if (!reader)
+		goto out;
 	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
@@ -3778,12 +3783,17 @@ void
 ring_buffer_read_finish(struct ring_buffer_iter *iter)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+	unsigned long flags;
 
 	/*
 	 * Ring buffer is disabled from recording, here's a good place
-	 * to check the integrity of the ring buffer. 
+	 * to check the integrity of the ring buffer.
+	 * Must prevent readers from trying to read, as the check
+	 * clears the HEAD page and readers require it.
 	 */
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	rb_check_pages(cpu_buffer);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	atomic_dec(&cpu_buffer->record_disabled);
 	atomic_dec(&cpu_buffer->buffer->resize_disabled);
