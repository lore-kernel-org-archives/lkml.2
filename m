Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0HXHAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:00:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:42909 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab0HXHAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:00:05 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        peterz@infradead.org, oleg@redhat.com
Subject: [RFC PATCH 2/3] timer: del_timer_sync() can be used in softirq context
Date: Tue, 24 Aug 2010 14:58:48 +0800
Message-Id: <1282633129-9187-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com>
References: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com>
X-OriginalArrivalTime: 24 Aug 2010 06:58:57.0995 (UTC) FILETIME=[D2EAE1B0:01CB4359]
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

