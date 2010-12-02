Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab0LBVyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:54:08 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:34782 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758031Ab0LBVyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:54:04 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: tC3vxLsVM1nKvt23Du5gqafc6.BnOfMpPbM8xuy4qOQg4i4
 Eq4HrPbGZK4hfY..e4AoXndFI3TkYDtqxVWvlmIKJitFIstp2m19v754Mqer
 w.22hFfsTDOzwW9ENzvNXmqgI1iqtOXBPe1BL2QiyOaTZHDc1w9qXyrBcPqc
 UabR8bmQ9RArMQKvhvoUYdJgOGjqK5GTo0cZLa8.ez_E7Y8Nd4mPmgVCuGth
 U5ZZD3ZCtfxOqCykrqB1Y2kcTz14W9eAiN8qV00i1pUL4SWi_AHXMfdQmlrw
 Hgj2XI4neyNiGUWqhOfl9
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101202215401.190499558@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 15:53:44 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [rfc: cpuops adv V1 4/8] irq_work: Use per cpu atomics instead of regular atomics
References: <20101202215340.562309713@linux.com>
Content-Disposition: inline; filename=irq
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
--- linux-2.6.orig/kernel/irq_work.c	2010-12-02 12:16:54.000000000 -0600
+++ linux-2.6/kernel/irq_work.c	2010-12-02 12:18:26.000000000 -0600
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
 

