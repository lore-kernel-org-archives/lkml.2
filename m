Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1BANwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:45 -0500
Received: from www.tglx.de ([62.245.132.106]:47396 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207Ab1BANwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:42 -0500
Message-Id: <20110201134420.062860200@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 27/28] posix-timers: Add support for fd based clocks
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-timers-add-support-for-fd-based-clocks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richard.cochran@omicron.at>

Extend the negative clockids which are currently used by posix cpu
timers to encode the PID with a file descriptor based type which
encodes the fd in the upper bits.

Originally-from: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
---
 include/linux/posix-timers.h |   13 +++++++++++++
 kernel/posix-timers.c        |    2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/posix-timers.h
===================================================================
--- linux-2.6-tip.orig/include/linux/posix-timers.h
+++ linux-2.6-tip/include/linux/posix-timers.h
@@ -18,6 +18,17 @@ struct cpu_timer_list {
 	int firing;
 };
 
+/*
+ * Bit fields within a clockid:
+ *
+ * The most significant 29 bits hold either a pid or a file descriptor.
+ *
+ * Bit 2 indicates whether a cpu clock refers to a thread or a process.
+ *
+ * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
+ *
+ * A clockid is invalid if bits 2, 1, and 0 all set.
+ */
 #define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
 #define CPUCLOCK_PERTHREAD(clock) \
 	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
@@ -29,6 +40,8 @@ struct cpu_timer_list {
 #define CPUCLOCK_VIRT		1
 #define CPUCLOCK_SCHED		2
 #define CPUCLOCK_MAX		3
+#define CLOCKFD			CPUCLOCK_MAX
+#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
 
 #define MAKE_PROCESS_CPUCLOCK(pid, clock) \
 	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -477,7 +477,7 @@ static void release_posix_timer(struct k
 static struct k_clock *clockid_to_kclock(const clockid_t id)
 {
 	if (id < 0)
-		return &clock_posix_cpu;
+		return (id & CLOCKFD_MASK) == CLOCKFD ? NULL : &clock_posix_cpu;
 
 	if (id >= MAX_CLOCKS || !posix_clocks[id].clock_getres)
 		return NULL;


