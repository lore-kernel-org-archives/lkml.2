Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab1A0O7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:33493 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751727Ab1A0O7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:03 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19Fx4dt7udFZ3SCJf6VHjpcsEbPNBBr5jCtMlF88n
	+r064U083GOjCA
Subject: [PATCH v2 01/20] move do_timer() from kernel/timer.c into
	kernel/time/timekeeping.c
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, yong.zhang0@gmail.com,
        hch@infradead.org
Date: Thu, 27 Jan 2011 15:58:55 +0100
Message-ID: <20110127145855.23248.56933.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this allows us to make update_wall_time() static.

do_timer only updates the jiffies_64 value, and calls update_walltime
these actions are all residing in kernel/time, and require holding
a writelock on xtime_lock.

one goal of this patchset is to make xtime_lock local to kernel/time.
thats why we are moving things.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 include/linux/time.h      |    1 -
 kernel/time/timekeeping.c |   13 ++++++++++++-
 kernel/timer.c            |   12 ------------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 1e6d3b5..86a9c48 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -166,7 +166,6 @@ extern void monotonic_to_bootbased(struct timespec *ts);
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
-extern void update_wall_time(void);
 extern void timekeeping_leap_insert(int leapsecond);
 
 struct tms;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d27c756..e4fd957 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -779,7 +779,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
  *
  * Called from the timer interrupt, must hold a write on xtime_lock.
  */
-void update_wall_time(void)
+static void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
@@ -946,3 +946,14 @@ struct timespec get_monotonic_coarse(void)
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
+}
diff --git a/kernel/timer.c b/kernel/timer.c
index afdc13b..87f656c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1293,18 +1293,6 @@ void run_local_timers(void)
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
-}
-
 #ifdef __ARCH_WANT_SYS_ALARM
 
 /*

