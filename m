Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1FGXlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:41:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1FGXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:41:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=jZcTF2nDjefkPOco9vepOnsFFm+mqaeflAYN7B18aH7u0cVHyMrpfCwZJCITCo1g3
	fTgD6yx5nLTiUAb5HBBkg==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] trace: Set __GFP_NORETRY flag for ring buffer allocating process
Date: Tue,  7 Jun 2011 16:41:28 -0700
Message-Id: <1307490088-8612-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1306519125-19301-1-git-send-email-vnagarnaik@google.com>
References: <1306519125-19301-1-git-send-email-vnagarnaik@google.com>
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
 kernel/trace/ring_buffer.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2780e60..ec817d5 100644
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
 
-- 
1.7.3.1

