Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab0EUJLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:11:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0EUJLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:11:30 -0400
Message-Id: <20100521090710.795019386@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 11:02:09 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/10] perf: Optimize the !vmalloc backed buffer
References: <20100521090201.326791353@chello.nl>
Content-Disposition: inline; filename=perf-opt-output-order.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce code and data by using the knowledge that for !PERF_USE_VMALLOC
data_order is always 0.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    2 +-
 kernel/perf_event.c        |   41 ++++++++++++++++++++++++++---------------
 2 files changed, 27 insertions(+), 16 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -588,8 +588,8 @@ struct perf_mmap_data {
 	struct rcu_head			rcu_head;
 #ifdef CONFIG_PERF_USE_VMALLOC
 	struct work_struct		work;
+	int				page_order;	/* allocation order  */
 #endif
-	int				data_order;	/* allocation order  */
 	int				nr_pages;	/* nr of data pages  */
 	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2297,11 +2297,6 @@ unlock:
 	rcu_read_unlock();
 }
 
-static unsigned long perf_data_size(struct perf_mmap_data *data)
-{
-	return data->nr_pages << (PAGE_SHIFT + data->data_order);
-}
-
 #ifndef CONFIG_PERF_USE_VMALLOC
 
 /*
@@ -2359,7 +2354,6 @@ perf_mmap_data_alloc(struct perf_event *
 			goto fail_data_pages;
 	}
 
-	data->data_order = 0;
 	data->nr_pages = nr_pages;
 
 	return data;
@@ -2395,6 +2389,11 @@ static void perf_mmap_data_free(struct p
 	kfree(data);
 }
 
+static inline int page_order(struct perf_mmap_data *data)
+{
+	return 0;
+}
+
 #else
 
 /*
@@ -2403,10 +2402,15 @@ static void perf_mmap_data_free(struct p
  * Required for architectures that have d-cache aliasing issues.
  */
 
+static inline int page_order(struct perf_mmap_data *data)
+{
+	return data->page_order;
+}
+
 static struct page *
 perf_mmap_to_page(struct perf_mmap_data *data, unsigned long pgoff)
 {
-	if (pgoff > (1UL << data->data_order))
+	if (pgoff > (1UL << page_order(data)))
 		return NULL;
 
 	return vmalloc_to_page((void *)data->user_page + pgoff * PAGE_SIZE);
@@ -2426,7 +2430,7 @@ static void perf_mmap_data_free_work(str
 	int i, nr;
 
 	data = container_of(work, struct perf_mmap_data, work);
-	nr = 1 << data->data_order;
+	nr = 1 << page_order(data);
 
 	base = data->user_page;
 	for (i = 0; i < nr + 1; i++)
@@ -2465,7 +2469,7 @@ perf_mmap_data_alloc(struct perf_event *
 
 	data->user_page = all_buf;
 	data->data_pages[0] = all_buf + PAGE_SIZE;
-	data->data_order = ilog2(nr_pages);
+	data->page_order = ilog2(nr_pages);
 	data->nr_pages = 1;
 
 	return data;
@@ -2479,6 +2483,11 @@ fail:
 
 #endif
 
+static unsigned long perf_data_size(struct perf_mmap_data *data)
+{
+	return data->nr_pages << (PAGE_SHIFT + page_order(data));
+}
+
 static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct perf_event *event = vma->vm_file->private_data;
@@ -2978,10 +2987,12 @@ void perf_output_copy(struct perf_output
 		handle->addr += size;
 		handle->size -= size;
 		if (!handle->size) {
+			struct perf_mmap_data *data = handle->data;
+
 			handle->page++;
-			handle->page &= handle->data->nr_pages - 1;
-			handle->addr = handle->data->data_pages[handle->page];
-			handle->size = PAGE_SIZE << handle->data->data_order;
+			handle->page &= data->nr_pages - 1;
+			handle->addr = data->data_pages[handle->page];
+			handle->size = PAGE_SIZE << page_order(data);
 		}
 	} while (len);
 }
@@ -3049,12 +3060,12 @@ int perf_output_begin(struct perf_output
 	if (head - local_read(&data->wakeup) > data->watermark)
 		local_add(data->watermark, &data->wakeup);
 
-	handle->page = handle->offset >> (PAGE_SHIFT + data->data_order);
+	handle->page = handle->offset >> (PAGE_SHIFT + page_order(data));
 	handle->page &= data->nr_pages - 1;
-	handle->size = handle->offset & ((PAGE_SIZE << data->data_order) - 1);
+	handle->size = handle->offset & ((PAGE_SIZE << page_order(data)) - 1);
 	handle->addr = data->data_pages[handle->page];
 	handle->addr += handle->size;
-	handle->size = (PAGE_SIZE << data->data_order) - handle->size;
+	handle->size = (PAGE_SIZE << page_order(data)) - handle->size;
 
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;


