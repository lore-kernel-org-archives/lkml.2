Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab0KKIgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:36:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:38413 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab0KKIgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:36:24 -0500
Date: Thu, 11 Nov 2010 17:36:22 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [RFC-PATCH] clocksource: update lpj if clocksource has been changed.
To: linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, Magnus Damm <damm@opensource.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>
Message-id: <1289464582-26898-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.6.3.3
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 11 Nov 2010 08:36:22.0860 (UTC)
 FILETIME=[855CC0C0:01CB817B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a clocksource change, loops_per_jiffy may have been changed; thus,
the loops_per_jiffy in each cpu should be updated. Especially after some
of the cpus were turned off and on, their loops_per_jiffy values are
updated while the cpus kept on are not. Therefore, in order to make them
"normalized equally", we need to let the loops_per_jiffy values of
different cpus be based on the same clocksource.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 kernel/time/clocksource.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..a9d7935 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -30,6 +30,9 @@
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -592,6 +593,9 @@ static inline void clocksource_select(void) { }
  */
 static int __init clocksource_done_booting(void)
 {
+#ifdef CONFIG_SMP
+	int cpu;
+#endif
 	mutex_lock(&clocksource_mutex);
 	curr_clocksource = clocksource_default_clock();
 	mutex_unlock(&clocksource_mutex);
@@ -606,6 +610,13 @@ static int __init clocksource_done_booting(void)
 	mutex_lock(&clocksource_mutex);
 	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
+
+	calibrate_delay();
+#ifdef CONFIG_SMP
+	/* loops_per_jiffy may have been changed. */
+	for_each_online_cpu(cpu)
+		smp_store_cpu_info(cpu);
+#endif
 	return 0;
 }
 fs_initcall(clocksource_done_booting);
-- 
1.6.3.3

