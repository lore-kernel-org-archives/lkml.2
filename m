Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1FUPkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:40:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52973 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab1FUPkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:40:42 -0400
Message-Id: <20110621153806.132761621@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 17:17:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] printk: Release console_sem after logbuf_lock
References: <20110621151725.705140475@chello.nl>
Content-Disposition: inline; filename=printk-up-after-unlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release console_sem after unlocking the logbuf_lock so that we don't
generate wakeups while holding logbuf_lock. This avoids some lock
inversion troubles once we remove the lockdep_off bits between
logbuf_lock and rq->lock (prints while holding rq->lock vs doing
wakeups while holding logbuf_lock).

There's of course still an actual deadlock where the printk()s under
rq->lock will issue a wakeup from the up() call, but lockdep won't
warn about that since semaphores are not tracked.

The reason for unlocking the console_sem under the logbuf_lock is that
a concurrent printk() might full up the buffer but fail to acquire the
console sem, resulting in a missed write to the console until a
subsequent console_sem acquire/release cycle.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -782,7 +782,7 @@ static inline int can_use_console(unsign
 static int console_trylock_for_printk(unsigned int cpu)
 	__releases(&logbuf_lock)
 {
-	int retval = 0;
+	int retval = 0, wake = 0;
 
 	if (console_trylock()) {
 		retval = 1;
@@ -795,12 +795,14 @@ static int console_trylock_for_printk(un
 		 */
 		if (!can_use_console(cpu)) {
 			console_locked = 0;
-			up(&console_sem);
+			wake = 1;
 			retval = 0;
 		}
 	}
 	printk_cpu = UINT_MAX;
 	spin_unlock(&logbuf_lock);
+	if (wake)
+		up(&console_sem);
 	return retval;
 }
 static const char recursion_bug_msg [] =
@@ -1242,7 +1244,7 @@ void console_unlock(void)
 {
 	unsigned long flags;
 	unsigned _con_start, _log_end;
-	unsigned wake_klogd = 0;
+	unsigned wake_klogd = 0, retry = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -1251,6 +1253,7 @@ void console_unlock(void)
 
 	console_may_schedule = 0;
 
+again:
 	for ( ; ; ) {
 		spin_lock_irqsave(&logbuf_lock, flags);
 		wake_klogd |= log_start - log_end;
@@ -1271,8 +1274,23 @@ void console_unlock(void)
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
+	spin_unlock(&logbuf_lock);
+
 	up(&console_sem);
+
+	/*
+	 * Someone could have filled up the buffer again, so re-check if there's
+	 * something to flush. In case we cannot trylock the console_sem again,
+	 * there's a new owner and the console_unlock() from them will do the
+	 * flush, no worries.
+	 */
+	spin_lock(&logbuf_lock);
+	if (con_start != log_end)
+		retry = 1;
 	spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (retry && console_trylock())
+		goto again;
+
 	if (wake_klogd)
 		wake_up_klogd();
 }


