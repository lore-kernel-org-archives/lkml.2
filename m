Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab1FINOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:14:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:39529 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab1FINOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:14:21 -0400
Message-Id: <20110609131307.493181962@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 15:06:48 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] printk: Release console_sem after logbuf_lock
References: <20110609130647.937204592@chello.nl>
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
rq->lock will issue a wakeup from the up() call.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

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
@@ -1271,8 +1273,8 @@ void console_unlock(void)
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
+	up(&console_sem);
 	if (wake_klogd)
 		wake_up_klogd();
 }


