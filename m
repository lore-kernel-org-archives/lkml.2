Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1BWXwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:52:53 -0500
Received: from www.tglx.de ([62.245.132.106]:56012 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab1BWXwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:52:51 -0500
Message-Id: <20110223234956.677109139@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 23 Feb 2011 23:52:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 4/5] sched: Switch wait_task_inactive to schedule_hrtimeout()
References: <20110223231601.613115832@linutronix.de>
Content-Disposition: inline;
	filename=sched-switch-to-hrtimer-for-wait-task-inactive.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we force thread hard and soft interrupts the startup of ksoftirqd
would hang in kthread_bind() when wait_task_inactive() calls
schedule_timeout_uninterruptible() because there is no softirq yet
which will wake us up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -2224,7 +2224,10 @@ unsigned long wait_task_inactive(struct 
 		 * yield - it could be a while.
 		 */
 		if (unlikely(on_rq)) {
-			schedule_timeout_uninterruptible(1);
+			ktime_t to = ktime_set(0, NSEC_PER_SEC/HZ);
+
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_hrtimeout(&to, HRTIMER_MODE_REL);
 			continue;
 		}
 


