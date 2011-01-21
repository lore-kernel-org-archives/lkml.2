Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1AVAO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:14:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46707 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755072Ab1AVAOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:14:55 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1++zy86QKG+ywLcUlw/wmIZ0mWVcOneZ2vKD3qbbF
	OBIjYSmg2W4StX
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 18/18] make do_timer() and xtime_lock private to the timer code
Date: Sat, 22 Jan 2011 00:07:04 +0100
Message-Id: <1295651224-29823-19-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this commit finishes the xtime_lock cleanup.
arch code is now using xtime_update().

and do_timer() and xtime_lock are declared in kernel/time/timer-internal.h
i did not use tick-internal.h because it would have meant that i needed
to include some more stuff in kernel/time/ntp.c

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 include/linux/sched.h        |    1 -
 include/linux/time.h         |    2 --
 kernel/hrtimer.c             |    2 ++
 kernel/time/ntp.c            |    2 ++
 kernel/time/tick-common.c    |    1 +
 kernel/time/tick-sched.c     |    1 +
 kernel/time/timer-internal.h |    7 +++++++
 7 files changed, 13 insertions(+), 3 deletions(-)
 create mode 100644 kernel/time/timer-internal.h

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
index 1e6d3b5..4a324ac 100644
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
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..63f4714 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -50,6 +50,8 @@
 
 #include <trace/events/timer.h>
 
+#include "time/timer-internal.h"
+
 /*
  * The timer bases:
  *
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 5c00242..f3b47ad 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -16,6 +16,8 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 
+#include "timer-internal.h"
+
 /*
  * NTP timekeeping variables:
  */
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 051bc80..7ff565b 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -23,6 +23,7 @@
 #include <asm/irq_regs.h>
 
 #include "tick-internal.h"
+#include "timer-internal.h"
 
 /*
  * Tick devices
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..ad67e55 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -25,6 +25,7 @@
 #include <asm/irq_regs.h>
 
 #include "tick-internal.h"
+#include "timer-internal.h"
 
 /*
  * Per cpu nohz control structure
diff --git a/kernel/time/timer-internal.h b/kernel/time/timer-internal.h
new file mode 100644
index 0000000..f84a499
--- /dev/null
+++ b/kernel/time/timer-internal.h
@@ -0,0 +1,7 @@
+/*
+ * timer internal variable and functions
+ */
+
+extern void do_timer(unsigned long ticks);
+extern seqlock_t xtime_lock;
+
-- 
1.7.2.3

