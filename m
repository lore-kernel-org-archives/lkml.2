Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1CLK6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 05:58:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:43865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1CLK6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 05:58:33 -0500
Date: Sat, 12 Mar 2011 10:58:15 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, dvhart@linux.intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
In-Reply-To: <4D10797E.7040803@cn.fujitsu.com>
References: <4D10797E.7040803@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] futex,plist: Remove debug lock assignment from plist_node
Message-ID: <tip-017f2b239dabb2740b91df162e004371b861f371@git.kernel.org>
Git-Commit-ID: 017f2b239dabb2740b91df162e004371b861f371
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 12 Mar 2011 10:58:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  017f2b239dabb2740b91df162e004371b861f371
Gitweb:     http://git.kernel.org/tip/017f2b239dabb2740b91df162e004371b861f371
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 21 Dec 2010 17:55:10 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 11 Mar 2011 15:09:53 -0500

futex,plist: Remove debug lock assignment from plist_node

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
