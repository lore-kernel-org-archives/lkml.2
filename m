Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0HYNqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:46:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42595 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0HYNqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H+qn24+AjjwVGWYS45akPS5yQuSD74aS6vAI+4Dtx7pp1j2U+Dj5QKZ2Nd34sca486
         CI/ne4vuM9KaPrqxZRZykDrElB9JcM64/o4y3xNatrSNcaHfgPZAorYyo+1d9Hr74GrC
         UU2XTnXqBRtVNix3mPuJ9IfRPnO5vlMVCjoxg=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        oleg@redhat.com, peterz@infradead.org
Subject: [RFC V2 PATCH 2/3] timer: del_timer_sync() can be used in softirq context
Date: Wed, 25 Aug 2010 21:45:58 +0800
Message-Id: <1282743959-5427-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282743959-5427-1-git-send-email-yong.zhang0@gmail.com>
References: <1282743959-5427-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Actually we have used del_timer_sync() in softirq context for a long
time, such as: __dst_free()::cancel_delayed_work() and maybe the
DEBUG_OBJECTS_TIMERS fundamental code.

So change the comments of it to warn on hardirq context only,
and make lockdep know about this change.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/timer.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 55b6a2d..08c9559 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -981,7 +981,7 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
  * otherwise this function is meaningless. It must not be called from
- * interrupt contexts. The caller must not hold locks which would prevent
+ * hardirq contexts. The caller must not hold locks which would prevent
  * completion of the timer's handler. The timer's handler must not call
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
@@ -991,12 +991,10 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
 int del_timer_sync(struct timer_list *timer)
 {
 #ifdef CONFIG_LOCKDEP
-	unsigned long flags;
-
-	local_irq_save(flags);
+	local_bh_disable();
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
-	local_irq_restore(flags);
+	local_bh_enable();
 #endif
 
 	for (;;) {
-- 
1.7.0.4

