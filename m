Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964886Ab2CATGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:06:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab2CATDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:03:47 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=MX5G4bevUTUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_onQlfRAjIk4wGMfO5sA:9 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120301190345.165160680@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 01 Mar 2012 13:55:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT 2/9][RFC] [PATCH 2/9] futex/rt: Fix possible lockup when taking pi_lock in proxy handler
References: <20120301185527.064629423@goodmis.org>
Content-Disposition: inline; filename=0002-futex-rt-Fix-possible-lockup-when-taking-pi_lock-in-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When taking the pi_lock, we must disable interrupts because the
pi_lock can also be taken in an interrupt handler.

Use raw_spin_lock_irq() instead of raw_spin_lock().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rtmutex.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 9850dc0..b525158 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1373,14 +1373,14 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
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
1.7.3.4


