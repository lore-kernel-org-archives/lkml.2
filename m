Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1EZMWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:22:34 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33078 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab1EZMWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:22:33 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1306409575.1200.71.camel@twins>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	 <1306409575.1200.71.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 May 2011 14:21:51 +0200
Message-ID: <1306412511.1200.90.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 13:32 +0200, Peter Zijlstra wrote:
> 
> The bad news is of course that I've got a little more head-scratching to
> do, will keep you informed. 

OK, that wasn't too hard.. (/me crosses fingers and prays Marc doesn't
find more funnies ;-).

Does the below cure all woes?

---
Subject: sched: Fix ttwu() for __ARCH_WANT_INTERRUPTS_ON_CTXSW
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu May 26 14:21:33 CEST 2011

Marc reported that e4a52bcb9 (sched: Remove rq->lock from the first
half of ttwu()) broke his ARM-SMP machine. Now ARM is one of the few
__ARCH_WANT_INTERRUPTS_ON_CTXSW users, so that exception in the ttwu()
code was suspect.

Yong found that the interrupt could hit hits after context_switch() changes
current but before it clears p->on_cpu, if that interrupt were to
attempt a wake-up of p we would indeed find ourselves spinning in IRQ
context.

Sort this by reverting to the old behaviour for this situation and
perform a full remote wake-up.

Cc: Frank Rowand <frank.rowand@am.sony.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reported-by: Marc Zyngier <Marc.Zyngier@arm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2573,7 +2573,26 @@ static void ttwu_queue_remote(struct tas
 	if (!next)
 		smp_send_reschedule(cpu);
 }
-#endif
+
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
+{
+	struct rq *rq;
+	int ret = 0;
+
+	rq = __task_rq_lock(p);
+	if (p->on_cpu) {
+		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+		ttwu_do_wakeup(rq, p, wake_flags);
+		ret = 1;
+	}
+	__task_rq_unlock(rq);
+
+	return ret;
+
+}
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
+#endif /* CONFIG_SMP */
 
 static void ttwu_queue(struct task_struct *p, int cpu)
 {
@@ -2631,17 +2650,17 @@ try_to_wake_up(struct task_struct *p, un
 	while (p->on_cpu) {
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 		/*
-		 * If called from interrupt context we could have landed in the
-		 * middle of schedule(), in this case we should take care not
-		 * to spin on ->on_cpu if p is current, since that would
-		 * deadlock.
+		 * In case the architecture enables interrupts in
+		 * context_switch(), we cannot busy wait, since that
+		 * would lead to live-locks when an interrupt hits and
+		 * tries to wake up @prev. So bail and do a complete
+		 * remote wakeup.
 		 */
-		if (p == current) {
-			ttwu_queue(p, cpu);
+		if (ttwu_activate_remote(p, wake_flags))
 			goto stat;
-		}
-#endif
+#else
 		cpu_relax();
+#endif
 	}
 	/*
 	 * Pairs with the smp_wmb() in finish_lock_switch().

