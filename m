Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1FJKQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:16:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:51983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1FJKQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:16:32 -0400
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
In-Reply-To: <20110609131307.493181962@chello.nl>
References: <20110609130647.937204592@chello.nl>
	 <20110609131307.493181962@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 12:15:52 +0200
Message-ID: <1307700952.3941.112.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: printk: Release console_sem after logbuf_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Jun 07 11:15:33 CEST 2011

Release console_sem after unlocking the logbuf_lock so that we don't
generate wakeups while holding logbuf_lock. This avoids some lock
inversion troubles once we remove the lockdep_off bits between
logbuf_lock and rq->lock (prints while holding rq->lock vs doing
wakeups while holding logbuf_lock).

There's of course still an actual deadlock where the printk()s under
rq->lock will issue a wakeup from the up() call.

Since console_unlock() needs to flush the buffer while holding
console_sem unlocking logbuf_lock before dropping console_sem opens a
window in which another cpu could fill the buffer again but wouldn't be
able to flush due to us still owning the console_sem, thus loosing a
flush in the process.

Solve this by dropping logbuf_lock over the up(), but re-acquire it
afterwards and check the buffer is still empty, if not try to re-acquire
the console_sem and redo the whole flush bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..37dff34 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -782,7 +782,7 @@ static inline int can_use_console(unsigned int cpu)
 static int console_trylock_for_printk(unsigned int cpu)
 	__releases(&logbuf_lock)
 {
-	int retval = 0;
+	int retval = 0, wake = 0;
 
 	if (console_trylock()) {
 		retval = 1;
@@ -795,12 +795,14 @@ static int console_trylock_for_printk(unsigned int cpu)
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

