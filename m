Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1AaSWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:22:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:58722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1AaSWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:22:11 -0500
Date: Mon, 31 Jan 2011 18:21:47 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110127150032.23248.75995.stgit@localhost>
References: <20110127150032.23248.75995.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Make do_timer() and xtime_lock local to kernel/time/
Message-ID: <tip-025c435f6140c99e19e3a827faf49f3880afcf1e@git.kernel.org>
Git-Commit-ID: 025c435f6140c99e19e3a827faf49f3880afcf1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 18:21:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  025c435f6140c99e19e3a827faf49f3880afcf1e
Gitweb:     http://git.kernel.org/tip/025c435f6140c99e19e3a827faf49f3880afcf1e
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 16:00:32 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 17:46:50 +0100

time: Make do_timer() and xtime_lock local to kernel/time/

All callers of do_timer() are converted to xtime_update(). The only
users of xtime_lock are in kernel/time/. Make both local to
kernel/time/ and remove them from the global header files.

[ tglx: Reuse tick-internal.h instead of creating another local header
  	file. Massaged changelog ]

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: yong.zhang0@gmail.com
Cc: hch@infradead.org
LKML-Reference: <20110127150032.23248.75995.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h        |    1 -
 include/linux/time.h         |    2 --
 kernel/time/clockevents.c    |    1 -
 kernel/time/jiffies.c        |    2 ++
 kernel/time/ntp.c            |    2 ++
 kernel/time/tick-broadcast.c |    1 -
 kernel/time/tick-common.c    |    1 -
 kernel/time/tick-internal.h  |    4 ++++
 kernel/time/tick-oneshot.c   |    1 -
 kernel/time/tick-sched.c     |    1 -
 10 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9d9a078..cdef640 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2049,7 +2049,6 @@ extern void release_uids(struct user_namespace *ns);
 
 #include <asm/current.h>
 
-extern void do_timer(unsigned long ticks);
 extern void xtime_update(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
diff --git a/include/linux/time.h b/include/linux/time.h
index ce29c86..38c5206 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -113,8 +113,6 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 #define timespec_valid(ts) \
 	(((ts)->tv_sec >= 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER_SEC))
 
-extern seqlock_t xtime_lock;
-
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index d7395fd..0d74b9b 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -18,7 +18,6 @@
 #include <linux/notifier.h>
 #include <linux/smp.h>
 #include <linux/sysdev.h>
-#include <linux/tick.h>
 
 #include "tick-internal.h"
 
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 2fbc207..b2fa506 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -25,6 +25,8 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
+#include "tick-internal.h"
+
 /* The Jiffies based clocksource is the lowest common
  * denominator clock source which should function on
  * all systems. It has the same coarse resolution as
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 5c00242..ed8cfdf 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -16,6 +16,8 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 
+#include "tick-internal.h"
+
 /*
  * NTP timekeeping variables:
  */
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 48b2761..92ef9a5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -18,7 +18,6 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
-#include <linux/tick.h>
 
 #include "tick-internal.h"
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 051bc80..0e98fac 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -18,7 +18,6 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
-#include <linux/tick.h>
 
 #include <asm/irq_regs.h>
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 290eefb..14ac0d0 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -1,6 +1,7 @@
 /*
  * tick internal variable and functions used by low/high res code
  */
+#include <linux/tick.h>
 
 #define TICK_DO_TIMER_NONE	-1
 #define TICK_DO_TIMER_BOOT	-2
@@ -132,3 +133,6 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 {
 	return !(dev->features & CLOCK_EVT_FEAT_DUMMY);
 }
+
+extern void do_timer(unsigned long ticks);
+extern seqlock_t xtime_lock;
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 5cbc101..2d04411 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -18,7 +18,6 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
-#include <linux/tick.h>
 
 #include "tick-internal.h"
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c55ea24..d5097c4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -19,7 +19,6 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
-#include <linux/tick.h>
 #include <linux/module.h>
 
 #include <asm/irq_regs.h>
