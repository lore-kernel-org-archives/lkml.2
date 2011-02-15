Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1BORCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:02:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56863 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab1BORCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:02:30 -0500
Date: Tue, 15 Feb 2011 18:02:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking fix
Message-ID: <20110215170216.GA3966@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      Revert "lockdep, timer: Fix del_timer_sync() annotation"


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
