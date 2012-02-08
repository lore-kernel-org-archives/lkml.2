Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2BHGvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 01:51:38 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:43246 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2BHGvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 01:51:37 -0500
Date: Wed, 8 Feb 2012 14:51:15 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
Message-ID: <20120208065115.GA19691@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1328560933-3037-1-git-send-email-venki@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 12:42:13PM -0800, Venkatesh Pallipadi wrote:
> smp_call_function_single and ttwu_queue_remote sends unconditional IPI
> to target CPU. However, if the target CPU is in mwait based idle, we can
> do IPI-less wakeups using the magical powers of monitor-mwait.
> Doing this has certain advantages:

Actually I'm trying to do the similar thing on MIPS.

The difference is that I want task_is_polling() to do something. The basic
idea is:

> +			if (ipi_pending()) {
> +				clear_ipi_pending();
> +				local_bh_disable();
> +				local_irq_disable();
> +				generic_smp_call_function_single_interrupt();
> +				scheduler_wakeup_self_check();
> +				local_irq_enable();
> +				local_bh_enable();

I let cpu_idle() check if there is anything to do as your above code.

And task_is_polling() handle the others with below patch:
---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..09f633d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -527,15 +527,16 @@ void resched_task(struct task_struct *p)
 		smp_send_reschedule(cpu);
 }
 
-void resched_cpu(int cpu)
+int resched_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
 	if (!raw_spin_trylock_irqsave(&rq->lock, flags))
-		return;
+		return 0;
 	resched_task(cpu_curr(cpu));
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	return 1;
 }
 
 #ifdef CONFIG_NO_HZ
@@ -1484,7 +1485,8 @@ void scheduler_ipi(void)
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
-	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
+	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list) &&
+						!resched_cpu(cpu))
 		smp_send_reschedule(cpu);
 }
 
Thought?

Thanks,
Yong
