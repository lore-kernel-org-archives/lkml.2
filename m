Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2CFQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:59:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2CFQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:58:28 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=M52SsjCrMH4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=D_SbEOMbAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=hzfX1ENDuXW0RvCmcBUA:9 a=jeBq3FmKZ4MA:10 a=7KbvKZvEaC0A:10 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161951.684521420@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 22/25][RFC 3.0.23-rt39-rc1] sched/rt: Fix wait_task_interactive() to test rt_spin_lock state
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0022-sched-rt-Fix-wait_task_interactive-to-test-rt_spin_l.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

The wait_task_interactive() will have a task sleep waiting for another
task to have a certain state. But it ignores the rt_spin_locks state
and can return with an incorrect result if the task it is waiting
for is blocked on a rt_spin_lock() and is waking up.

The rt_spin_locks save the tasks state in the saved_state field
and the wait_task_interactive() must also test that state.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Carsten Emde <C.Emde@osadl.org>
Cc: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Clark Williams <clark.williams@gmail.com>
Cc: stable-rt@vger.kernel.org
Link: http://lkml.kernel.org/r/20120301190345.979435764@goodmis.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e5ef7a8..df30481 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2284,7 +2284,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * is actually now running somewhere else!
 		 */
 		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state != match_state))
+			if (match_state && unlikely(p->state != match_state)
+			    && unlikely(p->saved_state != match_state))
 				return 0;
 			cpu_relax();
 		}
@@ -2299,7 +2300,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		running = task_running(rq, p);
 		on_rq = p->on_rq;
 		ncsw = 0;
-		if (!match_state || p->state == match_state)
+		if (!match_state || p->state == match_state
+		    || p->saved_state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
 		task_rq_unlock(rq, p, &flags);
 
-- 
1.7.8.3


