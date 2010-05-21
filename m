Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0EULas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:30:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:58701 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab0EULap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:30:45 -0400
Date: Fri, 21 May 2010 11:30:16 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100521090710.852926930@chello.nl>
References: <20100521090710.852926930@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove more code from the fastpath
Message-ID: <tip-a94ffaaf55552769af328eaca9260fe6291c66c7@git.kernel.org>
Git-Commit-ID: a94ffaaf55552769af328eaca9260fe6291c66c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:30:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a94ffaaf55552769af328eaca9260fe6291c66c7
Gitweb:     http://git.kernel.org/tip/a94ffaaf55552769af328eaca9260fe6291c66c7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 20 May 2010 19:50:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:37:59 +0200

perf: Remove more code from the fastpath

Sanity checks cost instructions.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100521090710.852926930@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 --
 kernel/perf_event.c        |   20 ++++----------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 09cd9c1..fb6c91e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -803,8 +803,6 @@ struct perf_cpu_context {
 struct perf_output_handle {
 	struct perf_event		*event;
 	struct perf_mmap_data		*data;
-	unsigned long			head;
-	unsigned long			offset;
 	unsigned long			wakeup;
 	unsigned long			size;
 	void				*addr;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 953ce46..d25c864 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2967,20 +2967,11 @@ again:
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
 
@@ -3055,15 +3046,12 @@ int perf_output_begin(struct perf_output_handle *handle,
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
