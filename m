Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1ATLHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:07:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62776 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1ATLHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:07:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PIx9zq8e3MXhlGeJ9qoyo6LLSpO5EQylevTdK3ZgxMhtbDKUsze5OcgLXfIMg/6rnU
         cWlZrJk7ENV4GlnEtpCMHSEdWIInFCRf2UgfhhUr+Pf3g80ppZU/APmavh2FBMh08z1X
         q9sr+fcL2zAI+3WMmO2mdFrpb5FddtGRDszaY=
Date: Thu, 20 Jan 2011 12:07:13 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 2/2] smp: allow on_each_cpu() to be called while
 early_boot_irqs_disabled status to init/main.c
Message-ID: <20110120110713.GC6036@htj.dyndns.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119120200.GA1057@elte.hu>
 <20110120110635.GB6036@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120110635.GB6036@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu may end up calling vfree() during early boot which in turn may
call on_each_cpu() for TLB flushes.  The function of on_each_cpu() can
be done safely while IRQ is disabled during early boot but it assumed
that the function is always called with local IRQ enabled which ended
up enabling local IRQ prematurely during boot and triggering a couple
of warnings.

This patch updates on_each_cpu() and smp_call_function_many() such
on_each_cpu() can be used safely while early_boot_irqs_disabled is
set.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/smp.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: work/kernel/smp.c
===================================================================
--- work.orig/kernel/smp.c
+++ work/kernel/smp.c
@@ -430,7 +430,7 @@ void smp_call_function_many(const struct
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
