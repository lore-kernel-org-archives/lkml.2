Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1A0PAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:00:48 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44736 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752679Ab1A0PAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:00:37 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/uIfF2Ge/uFa+lIFL7PXBmf4tJzccESJDFwHFxXb
	wzoAA3dEkV4c5l
Subject: [PATCH v2 20/20] make do_timer() and xtime_lock private to the timer
	code
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, yong.zhang0@gmail.com,
        hch@infradead.org
Date: Thu, 27 Jan 2011 16:00:32 +0100
Message-ID: <20110127150032.23248.75995.stgit@localhost>
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

this commit finishes the xtime_lock cleanup.
arch code is now using xtime_update().

and do_timer() and xtime_lock are declared in kernel/time/timer-internal.h
i did not use tick-internal.h because it would have meant that i needed
to include some more stuff in kernel/time/ntp.c

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 include/linux/sched.h        |    1 -
 include/linux/time.h         |    2 --
 kernel/time/ntp.c            |    2 ++
 kernel/time/tick-common.c    |    1 +
 kernel/time/tick-sched.c     |    1 +
 kernel/time/timer-internal.h |    7 +++++++
 6 files changed, 11 insertions(+), 3 deletions(-)
 create mode 100644 kernel/time/timer-internal.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c0b0bb7..04726ef 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2044,7 +2044,6 @@ extern void release_uids(struct user_namespace *ns);
 
 #include <asm/current.h>
 
-extern void do_timer(unsigned long ticks);
 extern void xtime_update(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
diff --git a/include/linux/time.h b/include/linux/time.h
index b9b2f5b..bb35e79 100644
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
index c55ea24..fb8c52c 100644
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

