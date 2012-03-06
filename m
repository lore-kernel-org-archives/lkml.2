Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2CFQ6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:58:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2CFQ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:58:27 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=cvm8Kb7S8hkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=D_SbEOMbAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Qx_Y9JEi6s3GFzttdNwA:9 a=jeBq3FmKZ4MA:10 a=7KbvKZvEaC0A:10 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161951.181773677@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 20/25][RFC 3.0.23-rt39-rc1] futex/rt: Fix possible lockup when taking pi_lock in proxy handler
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0020-futex-rt-Fix-possible-lockup-when-taking-pi_lock-in-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

When taking the pi_lock, we must disable interrupts because the
pi_lock can also be taken in an interrupt handler.

Use raw_spin_lock_irq() instead of raw_spin_lock().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Carsten Emde <C.Emde@osadl.org>
Cc: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Clark Williams <clark.williams@gmail.com>
Cc: stable-rt@vger.kernel.org
Link: http://lkml.kernel.org/r/20120301190345.165160680@goodmis.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rtmutex.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 789744a..a02fbd9 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1365,14 +1365,14 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	 * PI_REQUEUE_INPROGRESS, so that if the task is waking up
 	 * it will know that we are in the process of requeuing it.
 	 */
-	raw_spin_lock(&task->pi_lock);
+	raw_spin_lock_irq(&task->pi_lock);
 	if (task->pi_blocked_on) {
-		raw_spin_unlock(&task->pi_lock);
+		raw_spin_unlock_irq(&task->pi_lock);
 		raw_spin_unlock(&lock->wait_lock);
 		return -EAGAIN;
 	}
 	task->pi_blocked_on = PI_REQUEUE_INPROGRESS;
-	raw_spin_unlock(&task->pi_lock);
+	raw_spin_unlock_irq(&task->pi_lock);
 #endif
 
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
-- 
1.7.8.3


