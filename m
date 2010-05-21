Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0EULaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:30:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:58661 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab0EULaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:30:09 -0400
Date: Fri, 21 May 2010 11:29:41 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100521090710.742809176@chello.nl>
References: <20100521090710.742809176@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize perf_output_copy()
Message-ID: <tip-5d967a8be636a4f301a8daad642bd1007299d9ec@git.kernel.org>
Git-Commit-ID: 5d967a8be636a4f301a8daad642bd1007299d9ec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:29:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d967a8be636a4f301a8daad642bd1007299d9ec
Gitweb:     http://git.kernel.org/tip/5d967a8be636a4f301a8daad642bd1007299d9ec
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 20 May 2010 16:46:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:37:59 +0200

perf: Optimize perf_output_copy()

Reduce the clutter in perf_output_copy() by keeping
an interator in perf_output_handle.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100521090710.742809176@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    3 ++
 kernel/perf_event.c        |   54 +++++++++++++++++++++----------------------
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7098ebb..7bd17f0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
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
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 1531e0b..b67549a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2961,39 +2961,30 @@ again:
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
@@ -3059,6 +3050,13 @@ int perf_output_begin(struct perf_output_handle *handle,
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
