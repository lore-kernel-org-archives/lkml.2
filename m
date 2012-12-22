Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2LVB7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:59:23 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:55567 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2LVB6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:46 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 24/25] debugobjects: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:14 -0800
Message-Id: <1356141435-17340-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from debugobjects.  While at it,
change @sched to bool and move kevent_up() test to later for brevity.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 lib/debugobjects.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index d11808c..b9dbfdf 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -189,20 +189,19 @@ static void free_obj_work(struct work_struct *work)
 static void free_object(struct debug_obj *obj)
 {
 	unsigned long flags;
-	int sched = 0;
+	bool sched;
 
 	raw_spin_lock_irqsave(&pool_lock, flags);
 	/*
 	 * schedule work when the pool is filled and the cache is
 	 * initialized:
 	 */
-	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
-		sched = keventd_up() && !work_pending(&debug_obj_work);
+	sched = obj_pool_free > ODEBUG_POOL_SIZE && obj_cache;
 	hlist_add_head(&obj->node, &obj_pool);
 	obj_pool_free++;
 	obj_pool_used--;
 	raw_spin_unlock_irqrestore(&pool_lock, flags);
-	if (sched)
+	if (sched && keventd_up())
 		schedule_work(&debug_obj_work);
 }
 
-- 
1.8.0.2

