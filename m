Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2EAAEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:04:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41691 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2EAAEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:04:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 21/41] nohz/cpuset: Flush cputime on threads in nohz cpusets when waiting leader
Date: Tue,  1 May 2012 01:54:55 +0200
Message-Id: <1335830115-14335-22-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we wait for a zombie task, flush the cputimes on nohz cpusets
in case we are waiting for a group leader that has threads running
in nohz CPUs. This way thread_group_times() doesn't report stale
values.

<doubts>
If I understood well the code, by the time we call that thread_group_times(),
we may have childs that are still running, so this is necessary.
But I need to check deeper.
</doubts>

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/exit.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 4b4042f..c194662 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -52,6 +52,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/oom.h>
 #include <linux/writeback.h>
+#include <linux/cpuset.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1712,6 +1713,13 @@ repeat:
 	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
 		goto notask;
 
+	/*
+	 * For cputime in sub-threads before adding them.
+	 * Must be called outside tasklist_lock lock because write lock
+	 * can be acquired under irqs disabled.
+	 */
+	cpuset_nohz_flush_cputimes();
+
 	set_current_state(TASK_INTERRUPTIBLE);
 	read_lock(&tasklist_lock);
 	tsk = current;
-- 
1.7.5.4

