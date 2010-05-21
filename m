Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0EULaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:30:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:58700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0EULap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:30:45 -0400
Date: Fri, 21 May 2010 11:29:58 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100521090710.795019386@chello.nl>
References: <20100521090710.795019386@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize the !vmalloc backed buffer
Message-ID: <tip-3cafa9fbb5c1d564b7b8e7224f493effbf04ffee@git.kernel.org>
Git-Commit-ID: 3cafa9fbb5c1d564b7b8e7224f493effbf04ffee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:29:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cafa9fbb5c1d564b7b8e7224f493effbf04ffee
Gitweb:     http://git.kernel.org/tip/3cafa9fbb5c1d564b7b8e7224f493effbf04ffee
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 20 May 2010 19:07:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:37:59 +0200

perf: Optimize the !vmalloc backed buffer

Reduce code and data by using the knowledge that for
!PERF_USE_VMALLOC data_order is always 0.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100521090710.795019386@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 +-
 kernel/perf_event.c        |   41 ++++++++++++++++++++++++++---------------
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7bd17f0..09cd9c1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
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
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b67549a..953ce46 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
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
@@ -2359,7 +2354,6 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 			goto fail_data_pages;
 	}
 
-	data->data_order = 0;
 	data->nr_pages = nr_pages;
 
 	return data;
@@ -2395,6 +2389,11 @@ static void perf_mmap_data_free(struct perf_mmap_data *data)
 	kfree(data);
 }
 
+static inline int page_order(struct perf_mmap_data *data)
+{
+	return 0;
+}
+
 #else
 
 /*
@@ -2403,10 +2402,15 @@ static void perf_mmap_data_free(struct perf_mmap_data *data)
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
@@ -2426,7 +2430,7 @@ static void perf_mmap_data_free_work(struct work_struct *work)
 	int i, nr;
 
 	data = container_of(work, struct perf_mmap_data, work);
-	nr = 1 << data->data_order;
+	nr = 1 << page_order(data);
 
 	base = data->user_page;
 	for (i = 0; i < nr + 1; i++)
@@ -2465,7 +2469,7 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 
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
@@ -2979,10 +2988,12 @@ void perf_output_copy(struct perf_output_handle *handle,
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
@@ -3050,12 +3061,12 @@ int perf_output_begin(struct perf_output_handle *handle,
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
