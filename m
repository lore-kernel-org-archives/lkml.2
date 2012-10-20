Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2JTQXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:23:06 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:51234 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2JTQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:23:00 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 4/8] nohz: Add API to check tick state
Date: Sat, 20 Oct 2012 12:22:43 -0400
Message-Id: <1350750167-14263-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need some quick way to check if the CPU has stopped
its tick. This will be useful to implement the printk tick
using the irq work subsystem.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/tick.h     |   17 ++++++++++++++++-
 kernel/time/tick-sched.c |    2 +-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index f37fceb..2307dd3 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -8,6 +8,8 @@
 
 #include <linux/clockchips.h>
 #include <linux/irqflags.h>
+#include <linux/percpu.h>
+#include <linux/hrtimer.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -122,13 +124,26 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
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

