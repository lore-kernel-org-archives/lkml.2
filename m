Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1BPNva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:51:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:52742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab1BPNv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:51:27 -0500
Date: Wed, 16 Feb 2011 13:51:04 GMT
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1297186794.23343.19.camel@gandalf.stny.rr.com>
References: <1297186794.23343.19.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep/timers: Explain in detail the locking problems del_timer_sync() may cause
Message-ID: <tip-48228f7b470a74b6469a250d2977a13128d8fe96@git.kernel.org>
Git-Commit-ID: 48228f7b470a74b6469a250d2977a13128d8fe96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:51:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48228f7b470a74b6469a250d2977a13128d8fe96
Gitweb:     http://git.kernel.org/tip/48228f7b470a74b6469a250d2977a13128d8fe96
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Tue, 8 Feb 2011 12:39:54 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:35:08 +0100

lockdep/timers: Explain in detail the locking problems del_timer_sync() may cause

Twice I had to explain the output about why lockdep gives an error with
locks in IRQ context and with del_timer_sync(). Might as well write it
up and place it in the comments above the code in del_timer_sync().
Perhaps the next time this lockdep dump triggers people will understand
the issues.

It is a ticky issue and very subtle, explaining it in detail in the code
may help others understand the issue when they stumble upon the bug
again.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1297186794.23343.19.camel@gandalf.stny.rr.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/timer.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index d645992..5f40c2e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -964,6 +964,25 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
  *
+ * Note: You must not hold locks that are held in interrupt context
+ *   while calling this function. Even if the lock has nothing to do
+ *   with the timer in question.  Here's why:
+ *
+ *    CPU0                             CPU1
+ *    ----                             ----
+ *                                   <SOFTIRQ>
+ *                                   call_timer_fn();
+ *                                     base->running_timer = mytimer;
+ *  spin_lock_irq(somelock);
+ *                                     <IRQ>
+ *                                        spin_lock(somelock);
+ *  del_timer_sync(mytimer);
+ *   while (base->running_timer == mytimer);
+ *
+ * Now del_timer_sync() will never return and never release somelock.
+ * The interrupt on the other CPU is waiting to grab somelock but
+ * it has interrupted the softirq that CPU0 is waiting to finish.
+ *
  * The function returns whether it has deactivated a pending timer or not.
  */
 int del_timer_sync(struct timer_list *timer)
@@ -971,6 +990,10 @@ int del_timer_sync(struct timer_list *timer)
 #ifdef CONFIG_LOCKDEP
 	unsigned long flags;
 
+	/*
+	 * If lockdep gives a backtrace here, please reference
+	 * the synchronization rules above.
+	 */
 	local_irq_save(flags);
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
