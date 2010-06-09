Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab0FIKRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:17:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:36352 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363Ab0FIKRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:17:11 -0400
Date: Wed, 9 Jun 2010 10:16:47 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Simplify the ring-buffer logic: make perf_buffer_alloc() do everything needed
Message-ID: <tip-d57e34fdd60be7ffd0b1d86bfa1a553df86b7172@git.kernel.org>
Git-Commit-ID: d57e34fdd60be7ffd0b1d86bfa1a553df86b7172
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:16:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d57e34fdd60be7ffd0b1d86bfa1a553df86b7172
Gitweb:     http://git.kernel.org/tip/d57e34fdd60be7ffd0b1d86bfa1a553df86b7172
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 28 May 2010 19:41:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:35 +0200

perf: Simplify the ring-buffer logic: make perf_buffer_alloc() do everything needed

Currently there are perf_buffer_alloc() + perf_buffer_init() + some
separate bits, fold it all into a single perf_buffer_alloc() and only
leave the attachment to the event separate.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 +
 kernel/perf_event.c        |   61 ++++++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2a0da02..441992a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -602,6 +602,8 @@ enum perf_event_active_state {
 
 struct file;
 
+#define PERF_BUFFER_WRITABLE		0x01
+
 struct perf_buffer {
 	atomic_t			refcount;
 	struct rcu_head			rcu_head;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 93d5458..f75c9c9 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2369,6 +2369,25 @@ unlock:
 	rcu_read_unlock();
 }
 
+static unsigned long perf_data_size(struct perf_buffer *buffer);
+
+static void
+perf_buffer_init(struct perf_buffer *buffer, long watermark, int flags)
+{
+	long max_size = perf_data_size(buffer);
+
+	if (watermark)
+		buffer->watermark = min(max_size, watermark);
+
+	if (!buffer->watermark)
+		buffer->watermark = max_size / 2;
+
+	if (flags & PERF_BUFFER_WRITABLE)
+		buffer->writable = 1;
+
+	atomic_set(&buffer->refcount, 1);
+}
+
 #ifndef CONFIG_PERF_USE_VMALLOC
 
 /*
@@ -2401,7 +2420,7 @@ static void *perf_mmap_alloc_page(int cpu)
 }
 
 static struct perf_buffer *
-perf_buffer_alloc(struct perf_event *event, int nr_pages)
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
 	unsigned long size;
@@ -2414,18 +2433,20 @@ perf_buffer_alloc(struct perf_event *event, int nr_pages)
 	if (!buffer)
 		goto fail;
 
-	buffer->user_page = perf_mmap_alloc_page(event->cpu);
+	buffer->user_page = perf_mmap_alloc_page(cpu);
 	if (!buffer->user_page)
 		goto fail_user_page;
 
 	for (i = 0; i < nr_pages; i++) {
-		buffer->data_pages[i] = perf_mmap_alloc_page(event->cpu);
+		buffer->data_pages[i] = perf_mmap_alloc_page(cpu);
 		if (!buffer->data_pages[i])
 			goto fail_data_pages;
 	}
 
 	buffer->nr_pages = nr_pages;
 
+	perf_buffer_init(buffer, watermark, flags);
+
 	return buffer;
 
 fail_data_pages:
@@ -2516,7 +2537,7 @@ static void perf_buffer_free(struct perf_buffer *buffer)
 }
 
 static struct perf_buffer *
-perf_buffer_alloc(struct perf_event *event, int nr_pages)
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
 	unsigned long size;
@@ -2540,6 +2561,8 @@ perf_buffer_alloc(struct perf_event *event, int nr_pages)
 	buffer->page_order = ilog2(nr_pages);
 	buffer->nr_pages = 1;
 
+	perf_buffer_init(buffer, watermark, flags);
+
 	return buffer;
 
 fail_all_buf:
@@ -2591,23 +2614,6 @@ unlock:
 	return ret;
 }
 
-static void
-perf_buffer_init(struct perf_event *event, struct perf_buffer *buffer)
-{
-	long max_size = perf_data_size(buffer);
-
-	if (event->attr.watermark) {
-		buffer->watermark = min_t(long, max_size,
-					event->attr.wakeup_watermark);
-	}
-
-	if (!buffer->watermark)
-		buffer->watermark = max_size / 2;
-
-	atomic_set(&buffer->refcount, 1);
-	rcu_assign_pointer(event->buffer, buffer);
-}
-
 static void perf_buffer_free_rcu(struct rcu_head *rcu_head)
 {
 	struct perf_buffer *buffer;
@@ -2682,7 +2688,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long vma_size;
 	unsigned long nr_pages;
 	long user_extra, extra;
-	int ret = 0;
+	int ret = 0, flags = 0;
 
 	/*
 	 * Don't allow mmap() of inherited per-task counters. This would
@@ -2747,15 +2753,16 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	WARN_ON(event->buffer);
 
-	buffer = perf_buffer_alloc(event, nr_pages);
+	if (vma->vm_flags & VM_WRITE)
+		flags |= PERF_BUFFER_WRITABLE;
+
+	buffer = perf_buffer_alloc(nr_pages, event->attr.wakeup_watermark,
+				   event->cpu, flags);
 	if (!buffer) {
 		ret = -ENOMEM;
 		goto unlock;
 	}
-
-	perf_buffer_init(event, buffer);
-	if (vma->vm_flags & VM_WRITE)
-		event->buffer->writable = 1;
+	rcu_assign_pointer(event->buffer, buffer);
 
 	atomic_long_add(user_extra, &user->locked_vm);
 	event->mmap_locked = extra;
