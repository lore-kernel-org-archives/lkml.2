Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913Ab0D1EKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 00:10:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35480 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab0D1EKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 00:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=N2QkYB4ZggGShusuHagHTnBi48Vw1nLRiLjuWITAqtR3EEnK3tPTMZnkLNiYiUm3Oe
         2+nC5lo4UcOxwSuRmhVYuVvvK4hCyO7aivDGHrHc6HuOkaQZNYuX8/WjqHa6snSePhw2
         3fy0ayBS74rXwUwkZz1OMmGQGZ0FoT/afkA+Q=
From: Changli Gao <xiaosuo@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] sched: use wrapper functions
Date: Wed, 28 Apr 2010 11:43:08 +0800
Message-Id: <1272426188-2982-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use wrapper functions.

Since there are add_wait_queue_exclusive_locked() and remove_wait_queue_locked()
, we'd better use them instead.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 kernel/sched.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)
diff --git a/kernel/sched.c b/kernel/sched.c
index 6af210a..be5ab70 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4039,8 +4039,7 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 	if (!x->done) {
 		DECLARE_WAITQUEUE(wait, current);
 
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue_tail(&x->wait, &wait);
+		add_wait_queue_exclusive_locked(&x->wait, &wait);
 		do {
 			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
@@ -4051,7 +4050,7 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 			timeout = schedule_timeout(timeout);
 			spin_lock_irq(&x->wait.lock);
 		} while (!x->done && timeout);
-		__remove_wait_queue(&x->wait, &wait);
+		remove_wait_queue_locked(&x->wait, &wait);
 		if (!x->done)
 			return timeout;
 	}
