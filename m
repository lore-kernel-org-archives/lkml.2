Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2K1Rw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:52:59 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57921 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab2K1Rwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:52:38 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 4/4] cputime: Comment cputime's adjusting code
Date: Wed, 28 Nov 2012 18:52:20 +0100
Message-Id: <1354125140-9294-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
References: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason for the scaling and monotonicity correction performed
by cputime_adjust() may not be immediately clear to the reviewer.

Add some comments to explain what happens there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched/cputime.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 220fdc4..b7f7317 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -516,6 +516,10 @@ static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
 	return (__force cputime_t) temp;
 }
 
+/*
+ * Adjust tick based cputime random precision against scheduler
+ * runtime accounting.
+ */
 static void cputime_adjust(struct task_cputime *curr,
 			   struct cputime *prev,
 			   cputime_t *ut, cputime_t *st)
@@ -524,8 +528,16 @@ static void cputime_adjust(struct task_cputime *curr,
 
 	utime = curr->utime;
 	total = utime + curr->stime;
+
 	/*
-	 * Use CFS's precise accounting:
+	 * Tick based cputime accounting depend on random scheduling
+	 * timeslices of a task to be interrupted or not by the timer.
+	 * Depending on these circumstances, the number of these interrupts
+	 * may be over or under-optimistic, matching the real user and system
+	 * cputime with a variable precision.
+	 *
+	 * Fix this by scaling these tick based values against the total
+	 * runtime accounted by the CFS scheduler.
 	 */
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
@@ -535,7 +547,9 @@ static void cputime_adjust(struct task_cputime *curr,
 		utime = rtime;
 
 	/*
-	 * Compare with previous values, to keep monotonicity:
+	 * If the tick based count grows faster than the scheduler one,
+	 * the result of the scaling may go backward.
+	 * Let's enforce monotonicity.
 	 */
 	prev->utime = max(prev->utime, utime);
 	prev->stime = max(prev->stime, rtime - prev->utime);
-- 
1.7.5.4

