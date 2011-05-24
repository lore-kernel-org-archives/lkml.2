Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab1EXSMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:12:30 -0400
Received: from service87.mimecast.com ([94.185.240.25]:56853 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752799Ab1EXSM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:12:28 -0400
Subject: [BUG]  "sched: Remove rq->lock from the first half of ttwu()" 
 locks up on ARM
From: Marc Zyngier <Marc.Zyngier@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Organization: ARM Ltd
Date: Tue, 24 May 2011 19:13:12 +0100
Message-ID: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
X-OriginalArrivalTime: 24 May 2011 18:12:35.0636 (UTC) FILETIME=[287B3740:01CC1A3E]
X-MC-Unique: 111052419122501201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I've experienced all kind of lock-ups on ARM SMP platforms recently, and
finally tracked it down to the following patch:

e4a52bcb9a18142d79e231b6733cabdbf2e67c1f [sched: Remove rq->lock from the first half of ttwu()].

Even on moderate load, the machine locks up, often silently, and
sometimes with a few messages like:
INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 0} (detected by 1, t=12002 jiffies)

Another side effect of this patch is that the load average is always 0,
whatever load I throw at the system.

Reverting the sched changes up to that patch (included) gives me a
working system again, which happily survives parallel kernel
compilations without complaining.

My knowledge of the scheduler being rather limited, I haven't been able
to pinpoint the exact problem (though it probably have something to do
with __ARCH_WANT_INTERRUPTS_ON_CTXSW being defined on ARM). The enclosed
patch somehow papers over the load average problem, but the system ends
up locking up anyway:

diff --git a/kernel/sched.c b/kernel/sched.c
index d3ade54..5ab43c4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2526,8 +2526,13 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		 * to spin on ->on_cpu if p is current, since that would
 		 * deadlock.
 		 */
-		if (p == current)
+		if (p == current) {
+			p->sched_contributes_to_load = !!task_contributes_to_load(p);
+			p->state = TASK_WAKING;
+			if (p->sched_class->task_waking)
+				p->sched_class->task_waking(p);
 			goto out_activate;
+		}
 #endif
 		cpu_relax();
 	}

I'd be happy to test any patch you may have.

Cheers,

	M.
-- 
Reality is an implementation detail.


