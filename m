Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1AKER5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 23:17:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63540 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1AKERw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 23:17:52 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=_Kp_6M9sMtsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5gGhRTZK2JgBjUD_UcYA:9 a=OetkvSXJ3JAVntUUcpAA:7 a=dMGjBFxK_QuicA-69PydaU8Ex_gA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [GIT PULL] rtmutex: Fix comment about why new_owner can be NULL in
 wake_futex_pi()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Lai Jiangshan <eag0628@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 10 Jan 2011 23:17:49 -0500
Message-ID: <1294719469.26623.246.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

While porting Lai Jiangshan's rt-pi patch to the -rt kernel, I found
that the comment about why rt_mutex_next_owner() can return NULL is
incorrect. This caused Lai to remove the following if condition, which
caused a bit of headache in debugging why his patch was causing a crash.

Please pull the latest tip/futex tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/futex


Steven Rostedt (1):
      rtmutex: Fix comment about why new_owner can be NULL in wake_futex_pi()

----
 kernel/futex.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)
---------------------------
commit 03cb8f564241019619d52b8716a8194b4220871c
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Jan 6 15:08:29 2011 -0500

    rtmutex: Fix comment about why new_owner can be NULL in wake_futex_pi()
    
    The comment about why rt_mutex_next_owner() can return NULL in
    wake_futex_pi() is not the normal case.
    
    Tracing the cause of why this occurs is more likely that waiter
    simply timedout. But because it originally caused contention with
    the futex, the owner will go into the kernel when it unlocks
    the lock. Then it will hit this code path and
    rt_mutex_next_owner() will return NULL.
    
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/futex.c b/kernel/futex.c
index 3019b92..5696d38 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -791,10 +791,9 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
-	 * This happens when we have stolen the lock and the original
-	 * pending owner did not enqueue itself back on the rt_mutex.
-	 * Thats not a tragedy. We know that way, that a lock waiter
-	 * is on the fly. We make the futex_q waiter the pending owner.
+	 * It is possible that the next waiter (the one that brought
+	 * this owner to the kernel) timed out and is no longer
+	 * waiting on the lock.
 	 */
 	if (!new_owner)
 		new_owner = this->task;


