Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2CIJ6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:58:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59692 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab2CIJ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:58:32 -0500
X-IronPort-AV: E=Sophos;i="4.73,557,1325433600"; 
   d="scan'208";a="4499222"
Message-ID: <4F59D568.4030604@cn.fujitsu.com>
Date: Fri, 09 Mar 2012 18:03:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: use percpu allocator for cwq on UP
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-09 17:56:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-09 17:56:33,
	Serialize complete at 2012-03-09 17:56:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I notice that the commit bbddff makes percpu allocator can work on UP,
So we don't need the magic way for UP.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
Just pass build test

 kernel/workqueue.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bec7b5b..5bbba09 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -474,13 +474,8 @@ static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 					    struct workqueue_struct *wq)
 {
 	if (!(wq->flags & WQ_UNBOUND)) {
-		if (likely(cpu < nr_cpu_ids)) {
-#ifdef CONFIG_SMP
+		if (likely(cpu < nr_cpu_ids))
 			return per_cpu_ptr(wq->cpu_wq.pcpu, cpu);
-#else
-			return wq->cpu_wq.single;
-#endif
-		}
 	} else if (likely(cpu == WORK_CPU_UNBOUND))
 		return wq->cpu_wq.single;
 	return NULL;
@@ -2897,13 +2892,8 @@ static int alloc_cwqs(struct workqueue_struct *wq)
 	const size_t size = sizeof(struct cpu_workqueue_struct);
 	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
 				   __alignof__(unsigned long long));
-#ifdef CONFIG_SMP
-	bool percpu = !(wq->flags & WQ_UNBOUND);
-#else
-	bool percpu = false;
-#endif
 
-	if (percpu)
+	if (!(wq->flags & WQ_UNBOUND))
 		wq->cpu_wq.pcpu = __alloc_percpu(size, align);
 	else {
 		void *ptr;
@@ -2927,13 +2917,7 @@ static int alloc_cwqs(struct workqueue_struct *wq)
 
 static void free_cwqs(struct workqueue_struct *wq)
 {
-#ifdef CONFIG_SMP
-	bool percpu = !(wq->flags & WQ_UNBOUND);
-#else
-	bool percpu = false;
-#endif
-
-	if (percpu)
+	if (!(wq->flags & WQ_UNBOUND))
 		free_percpu(wq->cpu_wq.pcpu);
 	else if (wq->cpu_wq.single) {
 		/* the pointer to free is stored right after the cwq */
