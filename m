Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0EUJL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:11:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:36405 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0EUJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:11:24 -0400
Message-Id: <20100521090710.852926930@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 11:02:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/10] perf: Remove more fastpath code
References: <20100521090201.326791353@chello.nl>
Content-Disposition: inline; filename=perf-opt-output-more.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sanity checks cost instructions

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    2 --
 kernel/perf_event.c        |   20 ++++----------------
 2 files changed, 4 insertions(+), 18 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -803,8 +803,6 @@ struct perf_cpu_context {
 struct perf_output_handle {
 	struct perf_event		*event;
 	struct perf_mmap_data		*data;
-	unsigned long			head;
-	unsigned long			offset;
 	unsigned long			wakeup;
 	unsigned long			size;
 	void				*addr;
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2966,20 +2966,11 @@ again:
 	preempt_enable();
 }
 
-void perf_output_copy(struct perf_output_handle *handle,
+__always_inline void perf_output_copy(struct perf_output_handle *handle,
 		      const void *buf, unsigned int len)
 {
-	handle->offset += len;
-
-	/*
-	 * Check we didn't copy past our reservation window, taking the
-	 * possible unsigned int wrap into account.
-	 */
-	if (WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0))
-		return;
-
 	do {
-		unsigned long size = min(handle->size, len);
+		unsigned long size = min_t(unsigned long, handle->size, len);
 
 		memcpy(handle->addr, buf, size);
 
@@ -3054,15 +3045,12 @@ int perf_output_begin(struct perf_output
 			goto fail;
 	} while (local_cmpxchg(&data->head, offset, head) != offset);
 
-	handle->offset	= offset;
-	handle->head	= head;
-
 	if (head - local_read(&data->wakeup) > data->watermark)
 		local_add(data->watermark, &data->wakeup);
 
-	handle->page = handle->offset >> (PAGE_SHIFT + page_order(data));
+	handle->page = offset >> (PAGE_SHIFT + page_order(data));
 	handle->page &= data->nr_pages - 1;
-	handle->size = handle->offset & ((PAGE_SIZE << page_order(data)) - 1);
+	handle->size = offset & ((PAGE_SIZE << page_order(data)) - 1);
 	handle->addr = data->data_pages[handle->page];
 	handle->addr += handle->size;
 	handle->size = (PAGE_SIZE << page_order(data)) - handle->size;


