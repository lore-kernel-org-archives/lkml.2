Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1AUXHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:07:24 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45315 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754268Ab1AUXHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:07:21 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+U5EMU8kaUBASKF/9OvvpKO6SfswxRK+TThHhHuG
	DQ/LPVncS+uMCX
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 01/18] move do_timer() from kernel/timer.c into kernel/time/timekeeping.c
Date: Sat, 22 Jan 2011 00:06:47 +0100
Message-Id: <1295651224-29823-2-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 kernel/time/timekeeping.c |   12 ++++++++++++
 kernel/timer.c            |   13 -------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d27c756..546d82f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -946,3 +946,15 @@ struct timespec get_monotonic_coarse(void)
 				now.tv_nsec + mono.tv_nsec);
 	return now;
 }
+
+/*
+ * The 64-bit jiffies value is not atomic - you MUST NOT read it
+ * without sampling the sequence number in xtime_lock.
+ * jiffies is defined in the linker script...
+ */
+void do_timer(unsigned long ticks)
+{
+	jiffies_64 += ticks;
+	update_wall_time();
+	calc_global_load(ticks);
+}
diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..87f656c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1293,19 +1293,6 @@ void run_local_timers(void)
 	raise_softirq(TIMER_SOFTIRQ);
 }
 
-/*
- * The 64-bit jiffies value is not atomic - you MUST NOT read it
- * without sampling the sequence number in xtime_lock.
- * jiffies is defined in the linker script...
- */
-
-void do_timer(unsigned long ticks)
-{
-	jiffies_64 += ticks;
-	update_wall_time();
-	calc_global_load(ticks);
-}
-
 #ifdef __ARCH_WANT_SYS_ALARM
 
 /*
-- 
1.7.2.3

