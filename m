Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab0LUJxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:53:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63868 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933687Ab0LUJxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:53:50 -0500
Message-ID: <4D10797E.7040803@cn.fujitsu.com>
Date: Tue, 21 Dec 2010 17:55:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/4] futex,plist: remove debug lock assignment for plist_node
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-21 17:53:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-21 17:53:38,
	Serialize complete at 2010-12-21 17:53:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

original code use &plist_node->plist as the faked head of
the priority list for plist_del(), these debug locks in
the faked head are needed for CONFIG_DEBUG_PI_LIST.

But now we always pass the real head to plist_del(), the debug locks
in plist_node will not be used, so we remove these assignments.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/futex.c b/kernel/futex.c
index 6c4f67a..725834e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1032,9 +1032,6 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 		plist_del(&q->list, &hb1->chain);
 		plist_add(&q->list, &hb2->chain);
 		q->lock_ptr = &hb2->lock;
-#ifdef CONFIG_DEBUG_PI_LIST
-		q->list.plist.spinlock = &hb2->lock;
-#endif
 	}
 	get_futex_key_refs(key2);
 	q->key = *key2;
@@ -1068,9 +1065,6 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 	q->rt_waiter = NULL;
 
 	q->lock_ptr = &hb->lock;
-#ifdef CONFIG_DEBUG_PI_LIST
-	q->list.plist.spinlock = &hb->lock;
-#endif
 
 	wake_up_state(q->task, TASK_NORMAL);
 }
@@ -1418,9 +1412,6 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 	prio = min(current->normal_prio, MAX_RT_PRIO);
 
 	plist_node_init(&q->list, prio);
-#ifdef CONFIG_DEBUG_PI_LIST
-	q->list.plist.spinlock = &hb->lock;
-#endif
 	plist_add(&q->list, &hb->chain);
 	q->task = current;
 	spin_unlock(&hb->lock);
