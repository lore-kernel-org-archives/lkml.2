Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab0ERRRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:17:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:60694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab0ERRRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:17:01 -0400
Date: Tue, 18 May 2010 17:16:20 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       eranian@google.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1274114880.5605.5236.camel@twins>
References: <1274114880.5605.5236.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize buffer placement by allocating buffers NUMA aware
Message-ID: <tip-a19d35c11fd559dd7dfd5a2078df7c9af74a5d88@git.kernel.org>
Git-Commit-ID: a19d35c11fd559dd7dfd5a2078df7c9af74a5d88
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 17:16:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a19d35c11fd559dd7dfd5a2078df7c9af74a5d88
Gitweb:     http://git.kernel.org/tip/a19d35c11fd559dd7dfd5a2078df7c9af74a5d88
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 17 May 2010 18:48:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 18:35:47 +0200

perf: Optimize buffer placement by allocating buffers NUMA aware

Ensure cpu bound buffers live on the right NUMA node.

Suggested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1274114880.5605.5236.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8d61d29..6ae6218 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2320,6 +2320,19 @@ perf_mmap_to_page(struct perf_mmap_data *data, unsigned long pgoff)
 	return virt_to_page(data->data_pages[pgoff - 1]);
 }
 
+static void *perf_mmap_alloc_page(int cpu)
+{
+	struct page *page;
+	int node;
+
+	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
+	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static struct perf_mmap_data *
 perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 {
@@ -2336,12 +2349,12 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 	if (!data)
 		goto fail;
 
-	data->user_page = (void *)get_zeroed_page(GFP_KERNEL);
+	data->user_page = perf_mmap_alloc_page(event->cpu);
 	if (!data->user_page)
 		goto fail_user_page;
 
 	for (i = 0; i < nr_pages; i++) {
-		data->data_pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		data->data_pages[i] = perf_mmap_alloc_page(event->cpu);
 		if (!data->data_pages[i])
 			goto fail_data_pages;
 	}
