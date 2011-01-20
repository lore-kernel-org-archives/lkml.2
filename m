Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1ATUX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:23:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:54781 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab1ATUXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:23:23 -0500
Date: Thu, 20 Jan 2011 20:22:06 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, penberg@kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        penberg@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110120110713.GC6036@htj.dyndns.org>
References: <20110120110713.GC6036@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] smp: Allow on_each_cpu() to be called while early_boot_irqs_disabled status to init/main.c
Message-ID: <tip-bd924e8cbd4b73ffb7d707a774c04f7e2cae88ed@git.kernel.org>
Git-Commit-ID: bd924e8cbd4b73ffb7d707a774c04f7e2cae88ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 20 Jan 2011 20:22:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd924e8cbd4b73ffb7d707a774c04f7e2cae88ed
Gitweb:     http://git.kernel.org/tip/bd924e8cbd4b73ffb7d707a774c04f7e2cae88ed
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 20 Jan 2011 12:07:13 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 20 Jan 2011 13:32:34 +0100

smp: Allow on_each_cpu() to be called while early_boot_irqs_disabled status to init/main.c

percpu may end up calling vfree() during early boot which in
turn may call on_each_cpu() for TLB flushes.  The function of
on_each_cpu() can be done safely while IRQ is disabled during
early boot but it assumed that the function is always called
with local IRQ enabled which ended up enabling local IRQ
prematurely during boot and triggering a couple of warnings.

This patch updates on_each_cpu() and smp_call_function_many()
such on_each_cpu() can be used safely while
early_boot_irqs_disabled is set.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20110120110713.GC6036@htj.dyndns.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/smp.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 4ec30e0..4b83cd6 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -430,7 +430,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	 * can't happen.
 	 */
 	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
-		     && !oops_in_progress);
+		     && !oops_in_progress && !early_boot_irqs_disabled);
 
 	/* So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
@@ -533,17 +533,20 @@ void ipi_call_unlock_irq(void)
 #endif /* USE_GENERIC_SMP_HELPERS */
 
 /*
- * Call a function on all processors
+ * Call a function on all processors.  May be used during early boot while
+ * early_boot_irqs_disabled is set.  Use local_irq_save/restore() instead
+ * of local_irq_disable/enable().
  */
 int on_each_cpu(void (*func) (void *info), void *info, int wait)
 {
+	unsigned long flags;
 	int ret = 0;
 
 	preempt_disable();
 	ret = smp_call_function(func, info, wait);
-	local_irq_disable();
+	local_irq_save(flags);
 	func(info);
-	local_irq_enable();
+	local_irq_restore(flags);
 	preempt_enable();
 	return ret;
 }
