Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0EaS5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:57:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:34827 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941Ab0EaS5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:57:34 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, paulus@samba.org, acme@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] sched: define and use CPU_PRI_* enums for cpu notifier priorities
Date: Mon, 31 May 2010 20:56:36 +0200
Message-Id: <1275332199-28082-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1275332199-28082-1-git-send-email-tj@kernel.org>
References: <1275332199-28082-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 18:56:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hardcoding priority 10 and 20 in sched and perf, collect
them into CPU_PRI_* enums.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/cpu.h        |    9 +++++++++
 include/linux/perf_event.h |    2 +-
 kernel/sched.c             |    2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index e287863..2d90738 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -48,6 +48,15 @@ extern ssize_t arch_cpu_release(const char *, size_t);
 #endif
 struct notifier_block;
 
+/*
+ * CPU notifier priorities.
+ */
+enum {
+	/* migration should happen before other stuff but after perf */
+	CPU_PRI_PERF		= 20,
+	CPU_PRI_MIGRATION	= 10,
+};
+
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
 #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c8e3754..11a84f9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -990,7 +990,7 @@ static inline void perf_event_disable(struct perf_event *event)		{ }
 #define perf_cpu_notifier(fn)					\
 do {								\
 	static struct notifier_block fn##_nb __cpuinitdata =	\
-		{ .notifier_call = fn, .priority = 20 };	\
+		{ .notifier_call = fn, .priority = CPU_PRI_PERF }; \
 	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,		\
 		(void *)(unsigned long)smp_processor_id());	\
 	fn(&fn##_nb, (unsigned long)CPU_STARTING,		\
diff --git a/kernel/sched.c b/kernel/sched.c
index b531d79..7f07048 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5837,7 +5837,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
  */
 static struct notifier_block __cpuinitdata migration_notifier = {
 	.notifier_call = migration_call,
-	.priority = 10
+	.priority = CPU_PRI_MIGRATION,
 };
 
 static int __init migration_init(void)
-- 
1.6.4.2

