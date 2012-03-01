Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815Ab2CATFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:05:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab2CATDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:03:47 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=tzUN-fM884AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hzfX1ENDuXW0RvCmcBUA:9 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120301190345.979435764@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 01 Mar 2012 13:55:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT 6/9][RFC] [PATCH 6/9] sched/rt: Fix wait_task_interactive() to test rt_spin_lock state
References: <20120301185527.064629423@goodmis.org>
Content-Disposition: inline; filename=0006-sched-rt-Fix-wait_task_interactive-to-test-rt_spin_l.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wait_task_interactive() will have a task sleep waiting for another
task to have a certain state. But it ignores the rt_spin_locks state
and can return with an incorrect result if the task it is waiting
for is blocked on a rt_spin_lock() and is waking up.

The rt_spin_locks save the tasks state in the saved_state field
and the wait_task_interactive() must also test that state.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 81b340d..1cc706d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2450,7 +2450,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * is actually now running somewhere else!
 		 */
 		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state != match_state))
+			if (match_state && unlikely(p->state != match_state)
+			    && unlikely(p->saved_state != match_state))
 				return 0;
 			cpu_relax();
 		}
@@ -2465,7 +2466,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		running = task_running(rq, p);
 		on_rq = p->on_rq;
 		ncsw = 0;
-		if (!match_state || p->state == match_state)
+		if (!match_state || p->state == match_state
+		    || p->saved_state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
 		task_rq_unlock(rq, p, &flags);
 
-- 
1.7.3.4


