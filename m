Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0DDKJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 06:09:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52539 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab0DDKJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 06:09:09 -0400
Date: Sun, 4 Apr 2010 12:09:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20100404100902.GA28689@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Julia Lawall (1):
      ring-buffer: Add missing unlock

Li Zefan (1):
      tracing: Fix lockdep warning in global_clock()


 kernel/trace/ring_buffer.c |    8 +++++---
 kernel/trace/trace_clock.c |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d1187ef..9a0f9bf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1209,18 +1209,19 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 
 	for (i = 0; i < nr_pages; i++) {
 		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
-			return;
+			goto out;
 		p = cpu_buffer->pages->next;
 		bpage = list_entry(p, struct buffer_page, list);
 		list_del_init(&bpage->list);
 		free_buffer_page(bpage);
 	}
 	if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
-		return;
+		goto out;
 
 	rb_reset_cpu(cpu_buffer);
 	rb_check_pages(cpu_buffer);
 
+out:
 	spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
@@ -1237,7 +1238,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 	for (i = 0; i < nr_pages; i++) {
 		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
-			return;
+			goto out;
 		p = pages->next;
 		bpage = list_entry(p, struct buffer_page, list);
 		list_del_init(&bpage->list);
@@ -1246,6 +1247,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	rb_reset_cpu(cpu_buffer);
 	rb_check_pages(cpu_buffer);
 
+out:
 	spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 6fbfb8f..9d589d8 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -84,7 +84,7 @@ u64 notrace trace_clock_global(void)
 	int this_cpu;
 	u64 now;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 
 	this_cpu = raw_smp_processor_id();
 	now = cpu_clock(this_cpu);
@@ -110,7 +110,7 @@ u64 notrace trace_clock_global(void)
 	arch_spin_unlock(&trace_clock_struct.lock);
 
  out:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	return now;
 }
