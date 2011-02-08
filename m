Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1BHPw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:52:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:42958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1BHPw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:52:57 -0500
Date: Tue, 8 Feb 2011 15:51:46 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, bp@alien8.de, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        peterz@infradead.org, bp@alien8.de, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <1297174680.13327.107.camel@laptop>
References: <1297174680.13327.107.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] Revert "lockdep, timer: Fix del_timer_sync() annotation"
Message-ID: <tip-7ff207928eb0761fa6b6c39eda82ac07a5241acf@git.kernel.org>
Git-Commit-ID: 7ff207928eb0761fa6b6c39eda82ac07a5241acf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Feb 2011 15:51:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ff207928eb0761fa6b6c39eda82ac07a5241acf
Gitweb:     http://git.kernel.org/tip/7ff207928eb0761fa6b6c39eda82ac07a5241acf
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 8 Feb 2011 15:18:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Feb 2011 16:18:39 +0100

Revert "lockdep, timer: Fix del_timer_sync() annotation"

Both attempts at trying to allow softirq usage for
del_timer_sync() failed (produced bogus warnings),
so revert the commit for this release:

  f266a5110d45: lockdep, timer: Fix del_timer_sync() annotation

and try again later.

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1297174680.13327.107.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/timer.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index d53ce66..d645992 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -959,7 +959,7 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
  * otherwise this function is meaningless. It must not be called from
- * hardirq contexts. The caller must not hold locks which would prevent
+ * interrupt contexts. The caller must not hold locks which would prevent
  * completion of the timer's handler. The timer's handler must not call
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
@@ -971,12 +971,10 @@ int del_timer_sync(struct timer_list *timer)
 #ifdef CONFIG_LOCKDEP
 	unsigned long flags;
 
-	raw_local_irq_save(flags);
-	local_bh_disable();
+	local_irq_save(flags);
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
-	_local_bh_enable();
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 #endif
 	/*
 	 * don't use it in hardirq context, because it
