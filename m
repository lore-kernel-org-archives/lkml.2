Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1EYVQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:16:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:39208 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab1EYVQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:16:06 -0400
Subject: Re: [BUG]  "sched: Remove rq->lock from the first half of ttwu()" 
 locks up on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1306343335.21578.65.camel@twins>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop>  <1306343335.21578.65.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 25 May 2011 23:15:28 +0200
Message-ID: <1306358128.21578.107.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 19:08 +0200, Peter Zijlstra wrote:
> Ooh, shiny, whilst typing this I got an NMI-watchdog error reporting me
> that CPU1 got stuck in try_to_wake_up(), so it looks like I can indeed
> reproduce some funnies.
> 
> /me goes dig in. 

Does the below make your ARM box happy again?

It restores the old ttwu behaviour for this case and seems to not mess
up my x86 with __ARCH_WANT_INTERRUPTS_ON_CTXSW.

Figuring out why the existing condition failed and writing a proper
changelog requires a mind that is slightly less deprived of sleep and I
shall attempt that tomorrow -- provided this does indeed work for you.

---
diff --git a/kernel/sched.c b/kernel/sched.c
index 2d12893..6976eac 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2573,7 +2573,19 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
 	if (!next)
 		smp_send_reschedule(cpu);
 }
-#endif
+
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+static void ttwu_activate_remote(struct task_struct *p, int wake_flags)
+{
+	struct rq *rq = __task_rq_lock(p);
+
+	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
+	ttwu_do_wakeup(rq, p, wake_flags);
+
+	__task_rq_unlock(rq);
+}
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
+#endif /* CONFIG_SMP */
 
 static void ttwu_queue(struct task_struct *p, int cpu)
 {
@@ -2630,18 +2642,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	 */
 	while (p->on_cpu) {
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-		/*
-		 * If called from interrupt context we could have landed in the
-		 * middle of schedule(), in this case we should take care not
-		 * to spin on ->on_cpu if p is current, since that would
-		 * deadlock.
-		 */
-		if (p == current) {
-			ttwu_queue(p, cpu);
-			goto stat;
-		}
-#endif
+		ttwu_activate_remote(p, wake_flags);
+		goto stat;
+#else
 		cpu_relax();
+#endif
 	}
 	/*
 	 * Pairs with the smp_wmb() in finish_lock_switch().


