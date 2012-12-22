Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab2LVAye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 19:54:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8010 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2LVAyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 19:54:32 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=sLk-kaDLNjMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fUr-R2fLZecA:10 a=wvseWig2nT2a-eVs9YUA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121222005431.143151944@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 21 Dec 2012 19:30:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <clark.williams@gmail.com>
Subject: [RFC][PATCH 2/2] sched: Enable interrupts in idle_balance()
References: <20121222003019.433916240@goodmis.org>
Content-Disposition: inline; filename=idle-balance-resched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the idle_balance is called from the post_schedule of the
idle task sched class, it is safe to enable interrupts. This allows
for better interaction of tasks waking up and other interrupts that
are triggered while the idle balance is in process.

Preemption is still disabled, but perhaps that can change as well.
That may need some more investigation.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/kernel/sched/fair.c
===================================================================
--- linux-trace.git.orig/kernel/sched/fair.c
+++ linux-trace.git/kernel/sched/fair.c
@@ -5231,9 +5231,10 @@ void idle_balance(int this_cpu, struct r
 	update_rq_runnable_avg(this_rq, 1);
 
 	/*
-	 * Drop the rq->lock, but keep IRQ/preempt disabled.
+	 * Drop the rq->lock, but keep preempt disabled.
 	 */
-	raw_spin_unlock(&this_rq->lock);
+	preempt_disable();
+	raw_spin_unlock_irq(&this_rq->lock);
 
 	update_blocked_averages(this_cpu);
 	rcu_read_lock();
@@ -5260,7 +5261,8 @@ void idle_balance(int this_cpu, struct r
 	}
 	rcu_read_unlock();
 
-	raw_spin_lock(&this_rq->lock);
+	raw_spin_lock_irq(&this_rq->lock);
+	preempt_enable();
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*

