Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab0FJLKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:10:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39173 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841Ab0FJLKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:47 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: peterz@infradead.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [10/23] SCHED: Only allocate per cpu cpu mask buffer with offstack cpumasks
Message-Id: <20100610111046.18EB4B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This will save a few bytes in the non offstack cpumask case.

Found by gcc 4.6's new warnings.

Cc: peterz@infradead.org
Cc: mingo@elte.hu
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.35-rc2-gcc/kernel/sched.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/kernel/sched.c
+++ linux-2.6.35-rc2-gcc/kernel/sched.c
@@ -7482,7 +7482,7 @@ static void init_tg_rt_entry(struct task
 void __init sched_init(void)
 {
 	int i, j;
-	unsigned long alloc_size = 0, ptr;
+	unsigned long alloc_size = 0;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
@@ -7494,7 +7494,10 @@ void __init sched_init(void)
 	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
 	if (alloc_size) {
+#ifdef CONFIG_CPUMASK_OFFSTACK
+		unsigned long ptr;
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
+#endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.se = (struct sched_entity **)ptr;
