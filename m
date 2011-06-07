Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1FGMER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:04:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:52983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab1FGMEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:04:15 -0400
Date: Tue, 7 Jun 2011 12:03:29 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-j8swthl12u73h4znbvitljzd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/printk] printk: Release console_sem after logbuf_lock
Git-Commit-ID: 0b5e1c5255e7ee8670e077e8224e5c2281229a5b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Jun 2011 12:03:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b5e1c5255e7ee8670e077e8224e5c2281229a5b
Gitweb:     http://git.kernel.org/tip/0b5e1c5255e7ee8670e077e8224e5c2281229a5b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 7 Jun 2011 11:15:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Jun 2011 12:50:02 +0200

printk: Release console_sem after logbuf_lock

Release console_sem after unlocking the logbuf_lock so that we don't
generate wakeups while holding logbuf_lock. This avoids some lock
inversion troubles once we remove the lockdep_off bits between
logbuf_lock and rq->lock (prints while holding rq->lock vs doing
wakeups while holding logbuf_lock).

There's of course still an actual deadlock where the printk()s under
rq->lock will issue a wakeup from the up() call, but lockdep won't
warn about that since semaphores are not tracked.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-j8swthl12u73h4znbvitljzd@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..751e7b8 100644
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
@@ -1271,8 +1273,8 @@ void console_unlock(void)
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
+	up(&console_sem);
 	if (wake_klogd)
 		wake_up_klogd();
 }
