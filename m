Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226Ab2JLSKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:10:36 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050Ab2JLSJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:09:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH 4/5] nohz: Add API to check tick state
Date: Fri, 12 Oct 2012 20:09:35 +0200
Message-Id: <1350065376-23353-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need some quick way to check if the CPU has stopped
its tick. This will be useful for printk when it wants
to wake up klogd on nohz CPU.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tick.h     |   16 +++++++++++++++-
 kernel/time/tick-sched.c |    2 +-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index f37fceb..05d1919 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -8,6 +8,7 @@
 
 #include <linux/clockchips.h>
 #include <linux/irqflags.h>
+#include <linux/percpu.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -122,13 +123,26 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
+DECLARE_PER_CPU(struct tick_sched, tick_cpu_sched);
+
+static inline int tick_nohz_tick_stopped(void)
+{
+	return __this_cpu_read(tick_cpu_sched.tick_stopped);
+}
+
 extern void tick_nohz_idle_enter(void);
 extern void tick_nohz_idle_exit(void);
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
-# else
+
+# else /* !CONFIG_NO_HZ */
+static inline int tick_nohz_tick_stopped(void)
+{
+	return 0;
+}
+
 static inline void tick_nohz_idle_enter(void) { }
 static inline void tick_nohz_idle_exit(void) { }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f423bdd..ccc1971 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -28,7 +28,7 @@
 /*
  * Per cpu nohz control structure
  */
-static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
+DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
 
 /*
  * The time, when the last jiffy update happened. Protected by xtime_lock.
-- 
1.7.5.4

