Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab1EXSSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:18:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab1EXSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:17:24 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=68I4gZkdJykA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=khOY_qMXpQlfi-yhZHEA:9 a=vS7H8wuHCCoUkPJdh-4A:7 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=YQ7kWE67OQSokMvF:21 a=aqXSHMEQPK-qIz7j:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110524181721.371550083@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 14:10:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 09/12] tracing: Use NUMA allocation for per-cpu ring buffer pages
References: <20110524181032.382259739@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Use-NUMA-allocation-for-per-cpu-ring-buffer-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

The tracing ring buffer is a group of per-cpu ring buffers where
allocation and logging is done on a per-cpu basis. The events that are
generated on a particular CPU are logged in the corresponding buffer.
This is to provide wait-free writes between CPUs and good NUMA node
locality while accessing the ring buffer.

However, the allocation routines consider NUMA locality only for buffer
page metadata and not for the actual buffer page. This causes the pages
to be allocated on the NUMA node local to the CPU where the allocation
routine is running at the time.

This patch fixes the problem by using a NUMA node specific allocation
routine so that the pages are allocated from a NUMA node local to the
logging CPU.

I tested with the getuid_microbench from autotest. It is a simple binary
that calls getuid() in a loop and measures the average time for the
syscall to complete. The following command was used to test:
$ getuid_microbench 1000000

Compared the numbers found on kernel with and without this patch and
found that logging latency decreases by 30-50 ns/call.
tracing with non-NUMA allocation - 569 ns/call
tracing with NUMA allocation     - 512 ns/call

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Link: http://lkml.kernel.org/r/1304470602-20366-1-git-send-email-vnagarnaik@google.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h          |    2 +-
 kernel/trace/ring_buffer.c           |   36 +++++++++++++++++----------------
 kernel/trace/ring_buffer_benchmark.c |    2 +-
 kernel/trace/trace.c                 |    6 +++-
 4 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index ab38ac8..b891de9 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -169,7 +169,7 @@ void ring_buffer_set_clock(struct ring_buffer *buffer,
 size_t ring_buffer_page_len(void *page);
 
 
-void *ring_buffer_alloc_read_page(struct ring_buffer *buffer);
+void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu);
 void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
 int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,
 			  size_t len, int cpu, int full);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0ef7b4b..02b7896 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -997,13 +997,13 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			     unsigned nr_pages)
 {
 	struct buffer_page *bpage, *tmp;
-	unsigned long addr;
 	LIST_HEAD(pages);
 	unsigned i;
 
 	WARN_ON(!nr_pages);
 
 	for (i = 0; i < nr_pages; i++) {
+		struct page *page;
 		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
 		if (!bpage)
@@ -1013,10 +1013,11 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 		list_add(&bpage->list, &pages);
 
-		addr = __get_free_page(GFP_KERNEL);
-		if (!addr)
+		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
+					GFP_KERNEL, 0);
+		if (!page)
 			goto free_pages;
-		bpage->page = (void *)addr;
+		bpage->page = page_address(page);
 		rb_init_page(bpage->page);
 	}
 
@@ -1045,7 +1046,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long addr;
+	struct page *page;
 	int ret;
 
 	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
@@ -1067,10 +1068,10 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	rb_check_bpage(cpu_buffer, bpage);
 
 	cpu_buffer->reader_page = bpage;
-	addr = __get_free_page(GFP_KERNEL);
-	if (!addr)
+	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+	if (!page)
 		goto fail_free_reader;
-	bpage->page = (void *)addr;
+	bpage->page = page_address(page);
 	rb_init_page(bpage->page);
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
@@ -1314,7 +1315,6 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	unsigned nr_pages, rm_pages, new_pages;
 	struct buffer_page *bpage, *tmp;
 	unsigned long buffer_size;
-	unsigned long addr;
 	LIST_HEAD(pages);
 	int i, cpu;
 
@@ -1375,16 +1375,18 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 
 	for_each_buffer_cpu(buffer, cpu) {
 		for (i = 0; i < new_pages; i++) {
+			struct page *page;
 			bpage = kzalloc_node(ALIGN(sizeof(*bpage),
 						  cache_line_size()),
 					    GFP_KERNEL, cpu_to_node(cpu));
 			if (!bpage)
 				goto free_pages;
 			list_add(&bpage->list, &pages);
-			addr = __get_free_page(GFP_KERNEL);
-			if (!addr)
+			page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL,
+						0);
+			if (!page)
 				goto free_pages;
-			bpage->page = (void *)addr;
+			bpage->page = page_address(page);
 			rb_init_page(bpage->page);
 		}
 	}
@@ -3730,16 +3732,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
  * Returns:
  *  The page allocated, or NULL on error.
  */
-void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
+void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu)
 {
 	struct buffer_data_page *bpage;
-	unsigned long addr;
+	struct page *page;
 
-	addr = __get_free_page(GFP_KERNEL);
-	if (!addr)
+	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+	if (!page)
 		return NULL;
 
-	bpage = (void *)addr;
+	bpage = page_address(page);
 
 	rb_init_page(bpage);
 
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 302f8a6..a5457d5 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -106,7 +106,7 @@ static enum event_status read_page(int cpu)
 	int inc;
 	int i;
 
-	bpage = ring_buffer_alloc_read_page(buffer);
+	bpage = ring_buffer_alloc_read_page(buffer, cpu);
 	if (!bpage)
 		return EVENT_DROPPED;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bbcf6dd..0e3a85b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3722,7 +3722,8 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 		return 0;
 
 	if (!info->spare)
-		info->spare = ring_buffer_alloc_read_page(info->tr->buffer);
+		info->spare = ring_buffer_alloc_read_page(info->tr->buffer,
+								info->cpu);
 	if (!info->spare)
 		return -ENOMEM;
 
@@ -3879,7 +3880,8 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 
 		ref->ref = 1;
 		ref->buffer = info->tr->buffer;
-		ref->page = ring_buffer_alloc_read_page(ref->buffer);
+		ref->page = ring_buffer_alloc_read_page(ref->buffer,
+							info->cpu);
 		if (!ref->page) {
 			kfree(ref);
 			break;
-- 
1.7.4.4


