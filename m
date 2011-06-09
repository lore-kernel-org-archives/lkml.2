Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1FIRaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:30:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46085 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1FIR3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:29:16 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ZSFM6Zn_U7cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=8ptb5Uy6ivW2y5QcxncA:9 a=Tcx2j25mhxmYTP6WR_8A:7 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110609172913.445768816@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:27:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 12/15] ring-buffer: Set __GFP_NORETRY flag for ring buffer allocating
References: <20110609172744.333794089@goodmis.org>
Content-Disposition: inline; filename=0012-ring-buffer-Set-__GFP_NORETRY-flag-for-ring-buffer-a.patch
 process
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

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
 kernel/trace/ring_buffer.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7c5d1c2..911d572 100644
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
1.7.4.4


