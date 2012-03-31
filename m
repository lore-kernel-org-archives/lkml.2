Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2CaOKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 10:10:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:57383 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351Ab2CaOK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 10:10:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="124001138"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: tim.c.chen@linux.intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] mm: Allow using fast mm counters from other files
Date: Sat, 31 Mar 2012 07:09:56 -0700
Message-Id: <1333202997-19550-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333202997-19550-1-git-send-email-andi@firstfloor.org>
References: <1333202997-19550-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Allow calling inc/dec_mm_counter_fast() from other files, not just memory.c

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/mm.h |   10 ++++++++++
 mm/memory.c        |    7 +------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17b27cd..ad8d314 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1082,6 +1082,16 @@ static inline void inc_mm_counter(struct mm_struct *mm, int member)
 	atomic_long_inc(&mm->rss_stat.count[member]);
 }
 
+#if defined(SPLIT_RSS_COUNTING)
+extern void add_mm_counter_fast(struct mm_struct *mm, int member, int val);
+
+#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, 1)
+#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, -1)
+#else
+#define inc_mm_counter_fast(mm, member) inc_mm_counter(mm, member)
+#define dec_mm_counter_fast(mm, member) inc_mm_counter_fast(mm, member)
+#endif
+
 static inline void dec_mm_counter(struct mm_struct *mm, int member)
 {
 	atomic_long_dec(&mm->rss_stat.count[member]);
diff --git a/mm/memory.c b/mm/memory.c
index fa2f04e..89d8401 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -138,7 +138,7 @@ static void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
 	task->rss_stat.events = 0;
 }
 
-static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
+void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
 {
 	struct task_struct *task = current;
 
@@ -147,8 +147,6 @@ static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
 	else
 		add_mm_counter(mm, member, val);
 }
-#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, 1)
-#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, -1)
 
 /* sync counter once per 64 page faults */
 #define TASK_RSS_EVENTS_THRESH	(64)
@@ -184,9 +182,6 @@ void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
 }
 #else /* SPLIT_RSS_COUNTING */
 
-#define inc_mm_counter_fast(mm, member) inc_mm_counter(mm, member)
-#define dec_mm_counter_fast(mm, member) dec_mm_counter(mm, member)
-
 static void check_sync_rss_stat(struct task_struct *task)
 {
 }
-- 
1.7.7.6

