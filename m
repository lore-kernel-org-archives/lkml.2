Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab1FINOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:14:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40805 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab1FINO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:14:28 -0400
Message-Id: <20110609131307.539373927@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 15:06:49 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] printk, lockdep: Remove lockdep_off() usage
References: <20110609130647.937204592@chello.nl>
Content-Disposition: inline; filename=printk-remove-lockdep_off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the lockdep_off() usage from printk(). Also add a
debug_locks_off() call to zap_locks() since that'll mess up the lock
state in a royal way anyway. Further switch to local_irq_ ops so that
the irq state is properly tracked (raw_local_irq_* isn't tracked by
lockdep, causing confusion). Also drop superfluous preempt_disable(),
disabling IRQs already avoids scheduling.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -686,6 +686,7 @@ static void zap_locks(void)
 
 	oops_timestamp = jiffies;
 
+	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
 	spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
@@ -838,9 +839,8 @@ asmlinkage int vprintk(const char *fmt,
 	boot_delay_msec();
 	printk_delay();
 
-	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
 	/*
@@ -861,7 +861,6 @@ asmlinkage int vprintk(const char *fmt,
 		zap_locks();
 	}
 
-	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
@@ -958,11 +957,9 @@ asmlinkage int vprintk(const char *fmt,
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
 
-	lockdep_on();
 out_restore_irqs:
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
-	preempt_enable();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);


