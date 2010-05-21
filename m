Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0EUJLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:11:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45998 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0EUJL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:11:27 -0400
Message-Id: <20100521090710.742809176@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 11:02:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/10] perf: Optimize perf_output_copy
References: <20100521090201.326791353@chello.nl>
Content-Disposition: inline; filename=perf-opt-output_copy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the clutter in perf_output_copy() by keeping an interator in
perf_output_handle.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    3 ++
 kernel/perf_event.c        |   54 +++++++++++++++++++++------------------------
 2 files changed, 29 insertions(+), 28 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -806,6 +806,9 @@ struct perf_output_handle {
 	unsigned long			head;
 	unsigned long			offset;
 	unsigned long			wakeup;
+	unsigned long			size;
+	void				*addr;
+	int				page;
 	int				nmi;
 	int				sample;
 };
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2960,39 +2960,30 @@ again:
 void perf_output_copy(struct perf_output_handle *handle,
 		      const void *buf, unsigned int len)
 {
-	unsigned int pages_mask;
-	unsigned long offset;
-	unsigned int size;
-	void **pages;
-
-	offset		= handle->offset;
-	pages_mask	= handle->data->nr_pages - 1;
-	pages		= handle->data->data_pages;
-
-	do {
-		unsigned long page_offset;
-		unsigned long page_size;
-		int nr;
-
-		nr	    = (offset >> PAGE_SHIFT) & pages_mask;
-		page_size   = 1UL << (handle->data->data_order + PAGE_SHIFT);
-		page_offset = offset & (page_size - 1);
-		size	    = min_t(unsigned int, page_size - page_offset, len);
-
-		memcpy(pages[nr] + page_offset, buf, size);
-
-		len	    -= size;
-		buf	    += size;
-		offset	    += size;
-	} while (len);
-
-	handle->offset = offset;
+	handle->offset += len;
 
 	/*
 	 * Check we didn't copy past our reservation window, taking the
 	 * possible unsigned int wrap into account.
 	 */
-	WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0);
+	if (WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0))
+		return;
+
+	do {
+		unsigned long size = min(handle->size, len);
+
+		memcpy(handle->addr, buf, size);
+
+		len -= size;
+		handle->addr += size;
+		handle->size -= size;
+		if (!handle->size) {
+			handle->page++;
+			handle->page &= handle->data->nr_pages - 1;
+			handle->addr = handle->data->data_pages[handle->page];
+			handle->size = PAGE_SIZE << handle->data->data_order;
+		}
+	} while (len);
 }
 
 int perf_output_begin(struct perf_output_handle *handle,
@@ -3058,6 +3049,13 @@ int perf_output_begin(struct perf_output
 	if (head - local_read(&data->wakeup) > data->watermark)
 		local_add(data->watermark, &data->wakeup);
 
+	handle->page = handle->offset >> (PAGE_SHIFT + data->data_order);
+	handle->page &= data->nr_pages - 1;
+	handle->size = handle->offset & ((PAGE_SIZE << data->data_order) - 1);
+	handle->addr = data->data_pages[handle->page];
+	handle->addr += handle->size;
+	handle->size = (PAGE_SIZE << data->data_order) - handle->size;
+
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;
 		lost_event.header.misc = 0;


