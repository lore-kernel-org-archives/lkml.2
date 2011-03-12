Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1CLDTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 22:19:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab1CLDTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 22:19:24 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=W890QU52e7oA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=dvECyFAcQTuGCxTeIEoA:9 a=GORnCVj32U5SHe69vfMA:7 a=uTtued64IP0yHSOfwzqKaBMGLowA:4 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110312031919.546715141@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 22:14:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 2/4] futex,plist: Remove debug lock assignment from plist_node
References: <20110312031435.890203189@goodmis.org>
Content-Disposition: inline; filename=0002-futex-plist-Remove-debug-lock-assignment-from-plist_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The original code uses &plist_node->plist as the fake head of
the priority list for plist_del(), these debug locks in
the fake head are needed for CONFIG_DEBUG_PI_LIST.

But now we always pass the real head to plist_del(), the debug locks
in plist_node will not be used, so we remove these assignments.

Acked-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D10797E.7040803@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/futex.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6feeea4..9fe9131 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1089,9 +1089,6 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 		plist_del(&q->list, &hb1->chain);
 		plist_add(&q->list, &hb2->chain);
 		q->lock_ptr = &hb2->lock;
-#ifdef CONFIG_DEBUG_PI_LIST
-		q->list.plist.spinlock = &hb2->lock;
-#endif
 	}
 	get_futex_key_refs(key2);
 	q->key = *key2;
@@ -1124,9 +1121,6 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 	q->rt_waiter = NULL;
 
 	q->lock_ptr = &hb->lock;
-#ifdef CONFIG_DEBUG_PI_LIST
-	q->list.plist.spinlock = &hb->lock;
-#endif
 
 	wake_up_state(q->task, TASK_NORMAL);
 }
@@ -1474,9 +1468,6 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 	prio = min(current->normal_prio, MAX_RT_PRIO);
 
 	plist_node_init(&q->list, prio);
-#ifdef CONFIG_DEBUG_PI_LIST
-	q->list.plist.spinlock = &hb->lock;
-#endif
 	plist_add(&q->list, &hb->chain);
 	q->task = current;
 	spin_unlock(&hb->lock);
-- 
1.7.2.3


