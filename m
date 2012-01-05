Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2AENpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:45:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45835 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2AENo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:44:59 -0500
Date: Thu, 5 Jan 2012 14:42:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/printk changes for v3.3
Message-ID: <20120105134250.GA29161@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-printk-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-printk-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (3):
      printk, lockdep: Disable lock debugging on zap_locks()
      printk, lockdep: Remove superfluous preempt_disable()
      printk, lockdep: Switch to tracked irq ops


 include/linux/lockdep.h |    4 ++++
 kernel/printk.c         |    9 ++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b6a56e3..d36619e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -343,6 +343,8 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_assert_held(l)	WARN_ON(debug_locks && !lockdep_is_held(l))
 
+#define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
+
 #else /* !LOCKDEP */
 
 static inline void lockdep_off(void)
@@ -392,6 +394,8 @@ struct lock_class_key { };
 
 #define lockdep_assert_held(l)			do { } while (0)
 
+#define lockdep_recursing(tsk)			(0)
+
 #endif /* !LOCKDEP */
 
 #ifdef CONFIG_LOCK_STAT
diff --git a/kernel/printk.c b/kernel/printk.c
index 1455a0d..dfd8f73 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -688,6 +688,7 @@ static void zap_locks(void)
 
 	oops_timestamp = jiffies;
 
+	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
 	raw_spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
@@ -840,9 +841,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	boot_delay_msec();
 	printk_delay();
 
-	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
 	/*
@@ -856,7 +856,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		 * recursion and return - but flag the recursion so that
 		 * it can be printed at the next appropriate moment:
 		 */
-		if (!oops_in_progress) {
+		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
@@ -962,9 +962,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 
 	lockdep_on();
 out_restore_irqs:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
-	preempt_enable();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
