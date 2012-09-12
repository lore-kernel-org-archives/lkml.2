Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab2ILOOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:14:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61686 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759109Ab2ILONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:13:40 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Subject: [PATCH v2 1/3] hrtimer: add hrtimer_init_cpu()
Date: Wed, 12 Sep 2012 16:13:13 +0200
Message-Id: <1347459195-5491-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347459195-5491-1-git-send-email-eranian@google.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_init() assumes it is called for the current CPU
as it accesses per-cpu variables (hrtimer_bases).

However, there can be cases where a hrtimer is initialized
from a different CPU, so add an entry point to make this
more explicit.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/hrtimer.h |    3 +++
 kernel/hrtimer.c        |   17 ++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index cc07d27..9d07e93 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -337,6 +337,9 @@ DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 /* Initialize timers: */
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
 			 enum hrtimer_mode mode);
+extern void hrtimer_init_cpu(int cpu, struct hrtimer *timer,
+			     clockid_t which_clock,
+			     enum hrtimer_mode mode);
 
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_clock,
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..cde7fc4 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -440,14 +440,14 @@ static inline void debug_hrtimer_free(struct hrtimer *timer)
 	debug_object_free(timer, &hrtimer_debug_descr);
 }
 
-static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
+static void __hrtimer_init(int cpu, struct hrtimer *timer, clockid_t clock_id,
 			   enum hrtimer_mode mode);
 
 void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t clock_id,
 			   enum hrtimer_mode mode)
 {
 	debug_object_init_on_stack(timer, &hrtimer_debug_descr);
-	__hrtimer_init(timer, clock_id, mode);
+	__hrtimer_init(smp_processor_id(), timer, clock_id, mode);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init_on_stack);
 
@@ -1146,7 +1146,7 @@ ktime_t hrtimer_get_next_event(void)
 }
 #endif
 
-static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
+static void __hrtimer_init(int cpu, struct hrtimer *timer, clockid_t clock_id,
 			   enum hrtimer_mode mode)
 {
 	struct hrtimer_cpu_base *cpu_base;
@@ -1154,7 +1154,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 
 	memset(timer, 0, sizeof(struct hrtimer));
 
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	cpu_base = &per_cpu(hrtimer_bases, cpu);
 
 	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
 		clock_id = CLOCK_MONOTONIC;
@@ -1180,10 +1180,17 @@ void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 		  enum hrtimer_mode mode)
 {
 	debug_init(timer, clock_id, mode);
-	__hrtimer_init(timer, clock_id, mode);
+	__hrtimer_init(smp_processor_id(), timer, clock_id, mode);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
+void hrtimer_init_cpu(int cpu, struct hrtimer *timer, clockid_t clock_id,
+		  enum hrtimer_mode mode)
+{
+	debug_init(timer, clock_id, mode);
+	__hrtimer_init(cpu, timer, clock_id, mode);
+}
+
 /**
  * hrtimer_get_res - get the timer resolution for a clock
  * @which_clock: which clock to query
-- 
1.7.5.4

