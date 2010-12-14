Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab0LNQ3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:29:38 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:49035 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759565Ab0LNQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:28:56 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XhI7wmAVM1lgYjCc5xX7SeTW_4Yoo.ArW7dT9o.4WpShTrz
 Q2iiEj1l.cpfCA2g.0U29nmOXcQu.5nP_A3x22LpMeA_39M90meSRmugcOOX
 gBam1fnVcfhRz_OzOIdoFYNA7eSzxm4Izj2xe3chA3HzPqh0eS4ARYxCy.9h
 aozDQ5Oy5JT6nLyJ5vVtgerfaku99cyz4sDDiLO3Qq_OAjXw1uLbJCAt7ZjA
 LtAYa7cE8lcrHsW5YxoHECS0FdekTbwWNDZF3Ie2GCyBmIgTyi.LmeQ2F32.
 6WxKBA9BKpik0QfUUt2op8CqzmK.e.ATKoqy.FYUS0OiEMC0-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214162854.218751478@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 10:28:45 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg V2 3/5] irq_work: Use per cpu atomics instead of regular atomics
References: <20101214162842.542421046@linux.com>
Content-Disposition: inline; filename=cpuops_cmpxchg_irq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq work queue is a per cpu object and it is sufficient for
synchronization if per cpu atomics are used. Doing so simplifies
the code and reduces the overhead of the code.

Before:

christoph@linux-2.6$ size kernel/irq_work.o
   text	   data	    bss	    dec	    hex	filename
    451	      8	      1	    460	    1cc	kernel/irq_work.o

After:

christoph@linux-2.6$ size kernel/irq_work.o 
   text	   data	    bss	    dec	    hex	filename
    438	      8	      1	    447	    1bf	kernel/irq_work.o

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 kernel/irq_work.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/irq_work.c
===================================================================
--- linux-2.6.orig/kernel/irq_work.c	2010-12-07 10:24:30.000000000 -0600
+++ linux-2.6/kernel/irq_work.c	2010-12-07 10:26:45.000000000 -0600
@@ -77,21 +77,21 @@ void __weak arch_irq_work_raise(void)
  */
 static void __irq_work_queue(struct irq_work *entry)
 {
-	struct irq_work **head, *next;
+	struct irq_work *next;
 
-	head = &get_cpu_var(irq_work_list);
+	preempt_disable();
 
 	do {
-		next = *head;
+		next = __this_cpu_read(irq_work_list);
 		/* Can assign non-atomic because we keep the flags set. */
 		entry->next = next_flags(next, IRQ_WORK_FLAGS);
-	} while (cmpxchg(head, next, entry) != next);
+	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
 
 	/* The list was empty, raise self-interrupt to start processing. */
 	if (!irq_work_next(entry))
 		arch_irq_work_raise();
 
-	put_cpu_var(irq_work_list);
+	preempt_enable();
 }
 
 /*
@@ -120,16 +120,16 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
  */
 void irq_work_run(void)
 {
-	struct irq_work *list, **head;
+	struct irq_work *list;
 
-	head = &__get_cpu_var(irq_work_list);
-	if (*head == NULL)
+	if (this_cpu_read(irq_work_list) == NULL)
 		return;
 
 	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
-	list = xchg(head, NULL);
+	list = this_cpu_xchg(irq_work_list, NULL);
+
 	while (list != NULL) {
 		struct irq_work *entry = list;
 

