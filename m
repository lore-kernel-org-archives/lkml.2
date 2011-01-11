Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1AKD5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:57:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42215 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab1AKD5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:57:24 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=mE48QfZ1GLYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=1nSz6Ew-AAAA:8 a=meVymXHHAAAA:8 a=90yoMks2NXfqcteSHF8A:9 a=hI8lqDGLouhKB5jEdJcA:7 a=xWYsQVGwaVXPe1FBYnS8AqLPCfoA:4 a=jEp0ucaQiEUA:10 a=nj4rVwXhlm8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110111035720.253294483@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Jan 2011 22:53:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Peter Morreale <pmorreale@novell.com>
Subject: [PATCH 3/5][RT] rtmutex: Revert Optimize rt lock wakeup
References: <20110111035355.643480133@goodmis.org>
Content-Disposition: inline; filename=0003-rtmutex-Revert-Optimize-rt-lock-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The commit: rtmutex: Optimize rt lock wakeup

Does not do what it was suppose to do.
This is because the adaptive waiter sets its state to TASK_(UN)INTERRUPTIBLE
before going into the loop. Thus, the test in wakeup_next_waiter()
will always fail on an adaptive waiter, as it only tests to see if
the pending waiter never has its state set ot TASK_RUNNING unless
something else had woke it up.

The smp_mb() added to make this test work is just as expensive as
just calling wakeup. And since we we fail to wake up anyway, we are
doing both a smp_mb() and wakeup as well.

I tested this with dbench and we run faster without this patch.
I also tried a variant that instead fixed the loop, to change the state
only if the spinner was to go to sleep, and that still did not show
any improvement.

Cc: Gregory Haskins <ghaskins@novell.com>
Cc: Peter Morreale <pmorreale@novell.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rtmutex.c |   29 ++---------------------------
 1 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 318d7ed..e218873 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -554,33 +554,8 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 	 */
 	if (!savestate)
 		wake_up_process(pendowner);
-	else {
-		/*
-		 * We can skip the actual (expensive) wakeup if the
-		 * waiter is already running, but we have to be careful
-		 * of race conditions because they may be about to sleep.
-		 *
-		 * The waiter-side protocol has the following pattern:
-		 * 1: Set state != RUNNING
-		 * 2: Conditionally sleep if waiter->task != NULL;
-		 *
-		 * And the owner-side has the following:
-		 * A: Set waiter->task = NULL
-		 * B: Conditionally wake if the state != RUNNING
-		 *
-		 * As long as we ensure 1->2 order, and A->B order, we
-		 * will never miss a wakeup.
-		 *
-		 * Therefore, this barrier ensures that waiter->task = NULL
-		 * is visible before we test the pendowner->state.  The
-		 * corresponding barrier is in the sleep logic.
-		 */
-		smp_mb();
-
-		/* If !RUNNING && !RUNNING_MUTEX */
-		if (pendowner->state & ~TASK_RUNNING_MUTEX)
-			wake_up_process_mutex(pendowner);
-	}
+	else
+		wake_up_process_mutex(pendowner);
 
 	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
 
-- 
1.7.2.3


