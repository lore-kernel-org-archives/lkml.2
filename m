Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab2GCCRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:17:47 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50936 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2GCCRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:17:45 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] [RFC] hrtimer: Fix clock_was_set so it is safe to call from atomic
Date: Mon,  2 Jul 2012 22:16:04 -0400
Message-Id: <1341281766-22722-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341281766-22722-1-git-send-email-johnstul@us.ibm.com>
References: <1341281766-22722-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070302-7408-0000-0000-0000066D0433
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE:This is a prerequisite patch that's required to
address the widely observed leap-second related futex/hrtimer
issues.

Currently clock_was_set() is unsafe to be called from atomic
context, as it calls on_each_cpu(). This causes problems when
we need to adjust the time from update_wall_time().

To fix this, if clock_was_set is called we're in_atomic,
we schedule a timer to fire for immedately after we're
out of interrupt context to then notify the hrtimer
subsystem.

CC: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/hrtimer.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..393fd4d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -746,7 +746,7 @@ static inline void retrigger_next_event(void *arg) { }
  * resolution timer interrupts. On UP we just disable interrupts and
  * call the high resolution interrupt code.
  */
-void clock_was_set(void)
+static void do_clock_was_set(unsigned long data)
 {
 #ifdef CONFIG_HIGH_RES_TIMERS
 	/* Retrigger the CPU local events everywhere */
@@ -755,6 +755,21 @@ void clock_was_set(void)
 	timerfd_clock_was_set();
 }
 
+static struct timer_list clock_was_set_timer;
+
+void clock_was_set(void)
+{
+	/*
+	 * We can't call on_each_cpu() from atomic context,
+	 * so if we're in_atomic, schedule the clock_was_set
+	 * via a timer_list timer for right after.
+	 */
+	if (in_atomic())
+		mod_timer(&clock_was_set_timer, jiffies);
+	else
+		do_clock_was_set(0);
+}
+
 /*
  * During resume we might have to reprogram the high resolution timer
  * interrupt (on the local CPU):
@@ -1152,6 +1167,8 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 	base = hrtimer_clockid_to_base(clock_id);
 	timer->base = &cpu_base->clock_base[base];
 	timerqueue_init(&timer->node);
+	init_timer(&clock_was_set_timer);
+	clock_was_set_timer.function = do_clock_was_set;
 
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
-- 
1.7.9.5

