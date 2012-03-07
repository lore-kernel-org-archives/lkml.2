Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab2CGDVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:21:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65400 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878Ab2CGDVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:21:44 -0500
Date: Tue, 6 Mar 2012 19:21:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 2/2] mm, counters: fold __sync_task_rss_stat into
 sync_mm_rss
In-Reply-To: <alpine.DEB.2.00.1203061919260.21806@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1203061920370.21806@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203061919260.21806@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no difference between sync_mm_rss() and __sync_task_rss_stat(),
so fold the latter into the former.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memory.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -125,7 +125,7 @@ core_initcall(init_zero_pfn);
 
 #if defined(SPLIT_RSS_COUNTING)
 
-static void __sync_task_rss_stat(struct mm_struct *mm)
+void sync_mm_rss(struct mm_struct *mm)
 {
 	int i;
 
@@ -157,7 +157,7 @@ static void check_sync_rss_stat(struct task_struct *task)
 	if (unlikely(task != current))
 		return;
 	if (unlikely(task->rss_stat.events++ > TASK_RSS_EVENTS_THRESH))
-		__sync_task_rss_stat(task->mm);
+		sync_mm_rss(task->mm);
 }
 
 unsigned long get_mm_counter(struct mm_struct *mm, int member)
@@ -177,11 +177,6 @@ unsigned long get_mm_counter(struct mm_struct *mm, int member)
 		return 0;
 	return (unsigned long)val;
 }
-
-void sync_mm_rss(struct mm_struct *mm)
-{
-	__sync_task_rss_stat(mm);
-}
 #else /* SPLIT_RSS_COUNTING */
 
 #define inc_mm_counter_fast(mm, member) inc_mm_counter(mm, member)
