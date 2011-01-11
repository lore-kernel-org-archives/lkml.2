Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1AKD5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:57:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54617 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab1AKD5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:57:24 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=qo6EBEGyu-oA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=E0TfBq03XM5opxeFWeAA:9 a=BoYCG7-xTozTfJXBDxkA:7 a=4vl1YPoGNKmI4Ru321Vub3HwSHUA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110111035720.548276314@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Jan 2011 22:53:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/5][RT] rtmutex: Fix comment about why new_owner can be NULL in wake_futex_pi()
References: <20110111035355.643480133@goodmis.org>
Content-Disposition: inline; filename=0004-rtmutex-Fix-comment-about-why-new_owner-can-be-NULL-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The comment about why rt_mutex_next_owner() can return NULL in
wake_futex_pi() is not the normal case.

Tracing the cause of why this occurs is more likely that waiter
simply timedout. But because it originally caused contention with
the futex, the owner will go into the kernel when it unlocks
the lock. Then it will hit this code path and
rt_mutex_next_owner() will return NULL.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/futex.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 07cd774..b9abcfd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -777,10 +777,9 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
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
-- 
1.7.2.3


