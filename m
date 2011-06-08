Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab1FHACF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:02:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab1FHACC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:02:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=fTueC8StujSZA0nU2oAihG45RxhxC7W9t0df+jCsZiwyLI443y4RaxsOXRucWmvEO
	+rUDTUz7TPHvZDXoqmsAw==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v2] trace: Set __GFP_NORETRY flag for ring buffer allocating process
Date: Tue,  7 Jun 2011 17:01:42 -0700
Message-Id: <1307491302-9236-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1307490088-8612-1-git-send-email-vnagarnaik@google.com>
References: <1307490088-8612-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracing ring buffer is allocated from kernel memory. While
allocating a large chunk of memory, OOM might happen which destabilizes
the system. Thus random processes might get killed during the
allocation.

This patch adds __GFP_NORETRY flag to the ring buffer allocation calls
to make it fail more gracefully if the system will not be able to
complete the allocation request.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
Changelog:
v2-v1: Added comment to explaing use of __GFP_NORETRY

 kernel/trace/ring_buffer.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2780e60..bd588b6 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1004,8 +1004,14 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
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
 
@@ -1014,7 +1020,7 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		list_add(&bpage->list, &pages);
 
 		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
-					GFP_KERNEL, 0);
+					GFP_KERNEL | __GFP_NORETRY, 0);
 		if (!page)
 			goto free_pages;
 		bpage->page = page_address(page);
@@ -1376,13 +1382,20 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
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
-			page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL,
+			page = alloc_pages_node(cpu_to_node(cpu),
+						GFP_KERNEL | __GFP_NORETRY,
 						0);
 			if (!page)
 				goto free_pages;
@@ -3737,7 +3750,9 @@ void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu)
 	struct buffer_data_page *bpage;
 	struct page *page;
 
-	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+	page = alloc_pages_node(cpu_to_node(cpu),
+				GFP_KERNEL | __GFP_NORETRY,
+				0);
 	if (!page)
 		return NULL;
 
-- 
1.7.3.1

