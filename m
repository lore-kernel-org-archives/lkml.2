Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1IPIsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:48:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47149 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1IPIsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:48:39 -0400
Subject: Re: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Fri, 16 Sep 2011 10:48:21 +0200
In-Reply-To: <4E7301EA.9070505@google.com>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.739484417@chello.nl> <4E7301EA.9070505@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316162901.10174.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 00:59 -0700, Paul Turner wrote:
> It's probably worth folding the idle_cpu fix for checking whether 
> there's an enqueued task into this.

Yeah, I've actually got that in too..

---
Subject: sched: Fix idle_cpu()
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu Sep 15 15:32:06 CEST 2011

On -rt we observed hackbench waking all 400 tasks to a single cpu.
This is because of select_idle_sibling()'s interaction with the new
ipi based wakeup scheme.

The existing idle_cpu() test only checks to see if the current task on
that cpu is the idle task, it does not take already queued tasks into
account, nor does it take queued to be woken tasks into account.

If the remote wakeup IPIs come hard enough, there won't be time to
schedule away from the idle task, and would thus keep thinking the cpu
was in fact idle, regardless of the fact that there were already
several hundred tasks runnable.

We couldn't reproduce on mainline, but there's no reason it couldn't 
happen.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-3o30p18b2paswpc9ohy2gltp@git.kernel.org
---
 kernel/sched.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -5152,7 +5152,20 @@ EXPORT_SYMBOL(task_nice);
  */
 int idle_cpu(int cpu)
 {
-	return cpu_curr(cpu) == cpu_rq(cpu)->idle;
+	struct rq *rq = cpu_rq(cpu);
+
+	if (rq->curr != rq->idle)
+		return 0;
+
+	if (rq->nr_running)
+		return 0;
+
+#ifdef CONFIG_SMP
+	if (!llist_empty(&rq->wake_list))
+		return 0;
+#endif
+
+	return 1;
 }
 
 /**

