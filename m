Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab2IMOnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:43:01 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59055 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab2IMOm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:42:58 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/2] perf, cpu hotplug: Use cached value of smp_processor_id()
To: a.p.zijlstra@chello.nl, acme@infradead.org
Cc: mingo@kernel.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2012 20:12:26 +0530
Message-ID: <20120913144226.3426.93144.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120913144220.3426.22392.stgit@srivatsabhat.in.ibm.com>
References: <20120913144220.3426.22392.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12091314-5816-0000-0000-000004717E50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_cpu_notifier() macro invokes smp_processor_id() multiple
times. Optimize it by using a local variable.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/perf_event.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cc4574d..5b5b017 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1346,15 +1346,16 @@ static inline void perf_event_task_tick(void)				{ }
 do {									\
 	static struct notifier_block fn##_nb __cpuinitdata =		\
 		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
+	unsigned long cpu = smp_processor_id();				\
 	unsigned long flags;						\
 	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
-		(void *)(unsigned long)smp_processor_id());		\
+		(void *)(unsigned long)cpu);				\
 	local_irq_save(flags);						\
 	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
-		(void *)(unsigned long)smp_processor_id());		\
+		(void *)(unsigned long)cpu);				\
 	local_irq_restore(flags);					\
 	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
-		(void *)(unsigned long)smp_processor_id());		\
+		(void *)(unsigned long)cpu);				\
 	register_cpu_notifier(&fn##_nb);				\
 } while (0)
 

