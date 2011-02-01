Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab1BANv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:51:26 -0500
Received: from www.tglx.de ([62.245.132.106]:47136 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab1BANvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:25 -0500
Message-Id: <20110201134417.841974553@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 04/28] posix-timers: Introduce clock_posix_cpu
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-timers-introduce-local-posix-cpu-clockid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CLOCK_DISPATCH() macro is a horrible magic. We call common
functions if a function pointer is not set. That's just backwards.

To support dynamic file decriptor based clocks we need to cleanup that
dispatch logic.

Create a k_clock struct clock_posix_cpu which has all the
posix-cpu-timer functions filled in. After the cleanup the functions
can be made static.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/posix-timers.h |    2 ++
 kernel/posix-cpu-timers.c    |   12 ++++++++++++
 2 files changed, 14 insertions(+)

Index: linux-2.6-tip/include/linux/posix-timers.h
===================================================================
--- linux-2.6-tip.orig/include/linux/posix-timers.h
+++ linux-2.6-tip/include/linux/posix-timers.h
@@ -85,6 +85,8 @@ struct k_clock {
 			   struct itimerspec * cur_setting);
 };
 
+extern struct k_clock clock_posix_cpu;
+
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
 /* error handlers for timer_create, nanosleep and settime */
Index: linux-2.6-tip/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-cpu-timers.c
+++ linux-2.6-tip/kernel/posix-cpu-timers.c
@@ -1604,6 +1604,18 @@ static long thread_cpu_nsleep_restart(st
 	return -EINVAL;
 }
 
+struct k_clock clock_posix_cpu = {
+	.clock_getres	= posix_cpu_clock_getres,
+	.clock_set	= posix_cpu_clock_set,
+	.clock_get	= posix_cpu_clock_get,
+	.timer_create	= posix_cpu_timer_create,
+	.nsleep		= posix_cpu_nsleep,
+	.nsleep_restart	= posix_cpu_nsleep_restart,
+	.timer_set	= posix_cpu_timer_set,
+	.timer_del	= posix_cpu_timer_del,
+	.timer_get	= posix_cpu_timer_get,
+};
+
 static __init int init_posix_cpu_timers(void)
 {
 	struct k_clock process = {


