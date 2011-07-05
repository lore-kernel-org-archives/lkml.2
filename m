Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1GEMyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:54:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:58478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab1GEMyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:54:20 -0400
Date: Tue, 5 Jul 2011 12:54:11 GMT
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-d7ec4bfed6c97405c6417970ba06c439e08ab8e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com, hpa@zytor.com,
        mingo@redhat.com, dhsharp@google.com, fweisbec@gmail.com,
        rostedt@goodmis.org, mrubin@google.com, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, dhsharp@google.com, fweisbec@gmail.com,
        rostedt@goodmis.org, mrubin@google.com, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1307491302-9236-1-git-send-email-vnagarnaik@google.com>
References: <1307491302-9236-1-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ring-buffer: Set __GFP_NORETRY flag for ring buffer allocating process
Git-Commit-ID: d7ec4bfed6c97405c6417970ba06c439e08ab8e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:54:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7ec4bfed6c97405c6417970ba06c439e08ab8e3
Gitweb:     http://git.kernel.org/tip/d7ec4bfed6c97405c6417970ba06c439e08ab8e3
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Tue, 7 Jun 2011 17:01:42 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:51 -0400

ring-buffer: Set __GFP_NORETRY flag for ring buffer allocating process

The tracing ring buffer is allocated from kernel memory. While
allocating a large chunk of memory, OOM might happen which destabilizes
the system. Thus random processes might get killed during the
allocation.

This patch adds __GFP_NORETRY flag to the ring buffer allocation calls
to make it fail more gracefully if the system will not be able to
complete the allocation request.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Link: http://lkml.kernel.org/r/1307491302-9236-1-git-send-email-vnagarnaik@google.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f00ede3..731201b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1004,9 +1004,14 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
-
+		/*
+		 * __GFP_NORETRY flag makes sure that the allocation fails
+		 * gracefully without invoking oom-killer and the system is
+		 * not destabilized.
+		 */
 		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
-				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
+				    GFP_KERNEL | __GFP_NORETRY,
+				    cpu_to_node(cpu_buffer->cpu));
 		if (!bpage)
 			goto free_pages;
 
@@ -1015,7 +1020,7 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		list_add(&bpage->list, &pages);
 
 		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
-					GFP_KERNEL, 0);
+					GFP_KERNEL | __GFP_NORETRY, 0);
 		if (!page)
 			goto free_pages;
 		bpage->page = page_address(page);
@@ -1377,13 +1382,20 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	for_each_buffer_cpu(buffer, cpu) {
 		for (i = 0; i < new_pages; i++) {
 			struct page *page;
+			/*
+			 * __GFP_NORETRY flag makes sure that the allocation
+			 * fails gracefully without invoking oom-killer and
+			 * the system is not destabilized.
+			 */
 			bpage = kzalloc_node(ALIGN(sizeof(*bpage),
 						  cache_line_size()),
-					    GFP_KERNEL, cpu_to_node(cpu));
+					    GFP_KERNEL | __GFP_NORETRY,
+					    cpu_to_node(cpu));
 			if (!bpage)
 				goto free_pages;
 			list_add(&bpage->list, &pages);
-			page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+			page = alloc_pages_node(cpu_to_node(cpu),
+						GFP_KERNEL | __GFP_NORETRY, 0);
 			if (!page)
 				goto free_pages;
 			bpage->page = page_address(page);
@@ -3737,7 +3749,8 @@ void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu)
 	struct buffer_data_page *bpage;
 	struct page *page;
 
-	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+	page = alloc_pages_node(cpu_to_node(cpu),
+				GFP_KERNEL | __GFP_NORETRY, 0);
 	if (!page)
 		return NULL;
 
