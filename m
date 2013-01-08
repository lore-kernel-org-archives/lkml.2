Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3AHCIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:08:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52921 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3AHCIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:08:47 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/33] context_tracking: Export context state for generic vtime
Date: Tue,  8 Jan 2013 03:08:02 +0100
Message-Id: <1357610913-1080-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the context state: whether we run in user / kernel
from the context tracking subsystem point of view.

This is going to be used by the generic virtual cputime
accounting subsystem that is needed to implement the full
dynticks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/context_tracking.h |   28 ++++++++++++++++++++++++++++
 kernel/context_tracking.c        |   16 +---------------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index e24339c..b28d161 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,12 +3,40 @@
 
 #ifdef CONFIG_CONTEXT_TRACKING
 #include <linux/sched.h>
+#include <linux/percpu.h>
+
+struct context_tracking {
+	/*
+	 * When active is false, probes are unset in order
+	 * to minimize overhead: TIF flags are cleared
+	 * and calls to user_enter/exit are ignored. This
+	 * may be further optimized using static keys.
+	 */
+	bool active;
+	enum {
+		IN_KERNEL = 0,
+		IN_USER,
+	} state;
+};
+
+DECLARE_PER_CPU(struct context_tracking, context_tracking);
+
+static inline bool context_tracking_in_user(void)
+{
+	return __this_cpu_read(context_tracking.state) == IN_USER;
+}
+
+static inline bool context_tracking_active(void)
+{
+	return __this_cpu_read(context_tracking.active);
+}
 
 extern void user_enter(void);
 extern void user_exit(void);
 extern void context_tracking_task_switch(struct task_struct *prev,
 					 struct task_struct *next);
 #else
+static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
 static inline void context_tracking_task_switch(struct task_struct *prev,
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 4b360b4..c952770 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -17,24 +17,10 @@
 #include <linux/context_tracking.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
-#include <linux/percpu.h>
 #include <linux/hardirq.h>
 
-struct context_tracking {
-	/*
-	 * When active is false, probes are unset in order
-	 * to minimize overhead: TIF flags are cleared
-	 * and calls to user_enter/exit are ignored. This
-	 * may be further optimized using static keys.
-	 */
-	bool active;
-	enum {
-		IN_KERNEL = 0,
-		IN_USER,
-	} state;
-};
 
-static DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
+DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 #ifdef CONFIG_CONTEXT_TRACKING_FORCE
 	.active = true,
 #endif
-- 
1.7.5.4

