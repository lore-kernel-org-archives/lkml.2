Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1E0R7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:59:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1E0R67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:58:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=tHMWYmzeBs+NkxnAL3QaVVaMv6LZ4iBGYzfdK9q4PwiJVzuVNRkrk+DSHCCZAqhvR
	OuZg1PrXdjJw1Y+M5I41w==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] trace: Set oom_score_adj to maximum for ring buffer allocating process
Date: Fri, 27 May 2011 10:58:45 -0700
Message-Id: <1306519125-19301-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracing ring buffer is allocated from kernel memory. While
allocating the memory, if OOM happens, the allocating process might not
be the one that gets killed, since the ring-buffer memory is not
allocated as process memory. Thus random processes might get killed
during the allocation.

This patch makes sure that the allocating process is considered the most
likely oom-kill-able process while the allocating is going on. Thus if
oom-killer is invoked because of ring-buffer allocation, it is easier
for the ring buffer memory to be freed and save important system
processes from being killed.

This patch also adds __GFP_NORETRY flag to the ring buffer allocation
calls to make it fail more gracefully if the system will not be able to
complete the allocation request.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/ring_buffer.c |   15 ++++++++++-----
 kernel/trace/trace.c       |    9 +++++++++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 02b7896..0339f95 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1005,7 +1005,8 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
 		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
-				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
+				    GFP_KERNEL | __GFP_NORETRY,
+				    cpu_to_node(cpu_buffer->cpu));
 		if (!bpage)
 			goto free_pages;
 
@@ -1014,7 +1015,7 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		list_add(&bpage->list, &pages);
 
 		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
-					GFP_KERNEL, 0);
+					GFP_KERNEL | __GFP_NORETRY, 0);
 		if (!page)
 			goto free_pages;
 		bpage->page = page_address(page);
@@ -1378,11 +1379,13 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 			struct page *page;
 			bpage = kzalloc_node(ALIGN(sizeof(*bpage),
 						  cache_line_size()),
-					    GFP_KERNEL, cpu_to_node(cpu));
+					    GFP_KERNEL | __GFP_NORETRY,
+					    cpu_to_node(cpu));
 			if (!bpage)
 				goto free_pages;
 			list_add(&bpage->list, &pages);
-			page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL,
+			page = alloc_pages_node(cpu_to_node(cpu),
+						GFP_KERNEL | __GFP_NORETRY,
 						0);
 			if (!page)
 				goto free_pages;
@@ -3737,7 +3740,9 @@ void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu)
 	struct buffer_data_page *bpage;
 	struct page *page;
 
-	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+	page = alloc_pages_node(cpu_to_node(cpu),
+				GFP_KERNEL | __GFP_NORETRY,
+				0);
 	if (!page)
 		return NULL;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b926578..15a667a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/fs.h>
+#include <linux/oom.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -3498,6 +3499,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	unsigned long val;
 	char buf[64];
 	int ret;
+	int oom_score_adj;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -3518,7 +3520,14 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	/* value is in KB */
 	val <<= 10;
 
+	/*
+	 * make sure this process is picked over others to be killed in OOM
+	 * condition
+	 */
+	oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
 	ret = tracing_resize_ring_buffer(val);
+	/* restore the original oom_score_adj value */
+	test_set_oom_score_adj(oom_score_adj);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.3.1

