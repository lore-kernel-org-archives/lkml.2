Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1AKD5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:57:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54617 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab1AKD5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:57:22 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=7TUYRcYmY2EA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=mWFOXvljRIWJwan956AA:9 a=pGGviBE5GyJPU9qnBacA:7 a=QoLhDuz4HvvHCgOmgc4Q2s2YIsMA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110111035719.582888215@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Jan 2011 22:53:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/5][RT] rtmutex: Only save lock depth once in spin_slowlock
References: <20110111035355.643480133@goodmis.org>
Content-Disposition: inline; filename=0001-rtmutex-Only-save-lock-depth-once-in-spin_slowlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The task that enters the rt_spin_lock_slowlock() will not take or
release the kernel lock again until it leaves the fuction.
There's no reason that we need to save and restore the lock depth
for each iteration of the try_lock loop.

Just save and reset the lock depth before entering the loop
and restore it upon exit.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rtmutex.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 348b1e7..f0ce334 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -821,6 +821,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	struct rt_mutex_waiter waiter;
 	unsigned long saved_state, flags;
 	struct task_struct *orig_owner;
+	int saved_lock_depth;
 
 	debug_rt_mutex_init_waiter(&waiter);
 	waiter.task = NULL;
@@ -843,8 +844,14 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	 */
 	saved_state = rt_set_current_blocked_state(current->state);
 
+	/*
+	 * Prevent schedule() to drop BKL, while waiting for
+	 * the lock ! We restore lock_depth when we come back.
+	 */
+	saved_lock_depth = current->lock_depth;
+	current->lock_depth = -1;
+
 	for (;;) {
-		int saved_lock_depth = current->lock_depth;
 
 		/* Try to acquire the lock */
 		if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL))
@@ -863,11 +870,6 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 				continue;
 		}
 
-		/*
-		 * Prevent schedule() to drop BKL, while waiting for
-		 * the lock ! We restore lock_depth when we come back.
-		 */
-		current->lock_depth = -1;
 		orig_owner = rt_mutex_owner(lock);
 		get_task_struct(orig_owner);
 		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
@@ -883,9 +885,9 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 			put_task_struct(orig_owner);
 
 		raw_spin_lock_irqsave(&lock->wait_lock, flags);
-		current->lock_depth = saved_lock_depth;
 		saved_state = rt_set_current_blocked_state(saved_state);
 	}
+	current->lock_depth = saved_lock_depth;
 
 	rt_restore_current_state(saved_state);
 
-- 
1.7.2.3


