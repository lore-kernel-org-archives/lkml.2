Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0LOXNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:13:07 -0500
Received: from www.tglx.de ([62.245.132.106]:59014 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab0LOXM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:12:59 -0500
Message-Id: <20101215230531.242147932@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 15 Dec 2010 23:12:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Jan Kiszka <jan.kiszka@web.de>
Subject: [RFC patch 2/4] genirq: Move action walk outside of desc->lock held
	region
References: <20101215230352.411894017@linutronix.de>
Content-Disposition: inline;
	filename=genirq-move-action-walk-outside-desc-lock-region.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global serialization of request/free_irq allows us to reduce the
spinlocked and interrupt disabled regions as the global lock protects
the action chain and basic setup functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lyon <pugs@cisco.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jan Kiszka <jan.kiszka@web.de>
---
 kernel/irq/manage.c |   73 +++++++++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 34 deletions(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -658,8 +658,8 @@ __setup_irq(unsigned int irq, struct irq
 {
 	struct irqaction *old, **old_ptr;
 	const char *old_name = NULL;
+	bool nested, shared = false;
 	unsigned long flags;
-	int nested, shared = 0;
 	int ret;
 
 	if (!desc)
@@ -705,30 +705,10 @@ __setup_irq(unsigned int irq, struct irq
 	}
 
 	/*
-	 * Create a handler thread when a thread function is supplied
-	 * and the interrupt does not nest into another interrupt
-	 * thread.
+	 * This is called with register_lock held, so we can walk the
+	 * action chain w/o holding desc->lock. Nothing can add or
+	 * remove an action.
 	 */
-	if (new->thread_fn && !nested) {
-		struct task_struct *t;
-
-		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
-				   new->name);
-		if (IS_ERR(t))
-			return PTR_ERR(t);
-		/*
-		 * We keep the reference to the task struct even if
-		 * the thread dies to avoid that the interrupt code
-		 * references an already freed task_struct.
-		 */
-		get_task_struct(t);
-		new->thread = t;
-	}
-
-	/*
-	 * The following block of code has to be executed atomically
-	 */
-	raw_spin_lock_irqsave(&desc->lock, flags);
 	old_ptr = &desc->action;
 	old = *old_ptr;
 	if (old) {
@@ -756,14 +736,36 @@ __setup_irq(unsigned int irq, struct irq
 			old_ptr = &old->next;
 			old = *old_ptr;
 		} while (old);
-		shared = 1;
+		shared = true;
+	}
+
+	/*
+	 * Create a handler thread when a thread function is supplied
+	 * and the interrupt does not nest into another interrupt
+	 * thread.
+	 */
+	if (new->thread_fn && !nested) {
+		struct task_struct *t;
+
+		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
+				   new->name);
+		if (IS_ERR(t))
+			return PTR_ERR(t);
+		/*
+		 * We keep the reference to the task struct even if
+		 * the thread dies to avoid that the interrupt code
+		 * references an already freed task_struct.
+		 */
+		get_task_struct(t);
+		new->thread = t;
 	}
 
 	if (!shared) {
 		irq_chip_set_defaults(desc->irq_data.chip);
-
 		init_waitqueue_head(&desc->wait_for_threads);
 
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
 			ret = __irq_set_trigger(desc, irq,
@@ -773,6 +775,7 @@ __setup_irq(unsigned int irq, struct irq
 				goto out_thread;
 		} else
 			compat_irq_chip_set_default_handler(desc);
+
 #if defined(CONFIG_IRQ_PER_CPU)
 		if (new->flags & IRQF_PERCPU)
 			desc->status |= IRQ_PER_CPU;
@@ -799,13 +802,17 @@ __setup_irq(unsigned int irq, struct irq
 		/* Set default affinity mask once everything is setup */
 		setup_affinity(irq, desc);
 
-	} else if ((new->flags & IRQF_TRIGGER_MASK)
-			&& (new->flags & IRQF_TRIGGER_MASK)
-				!= (desc->status & IRQ_TYPE_SENSE_MASK)) {
+	} else {
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		if ((new->flags & IRQF_TRIGGER_MASK)
+		    && (new->flags & IRQF_TRIGGER_MASK)
+		    != (desc->status & IRQ_TYPE_SENSE_MASK)) {
 		/* hope the handler works with the actual trigger mode... */
 		pr_warning("IRQ %d uses trigger mode %d; requested %d\n",
 				irq, (int)(desc->status & IRQ_TYPE_SENSE_MASK),
 				(int)(new->flags & IRQF_TRIGGER_MASK));
+		}
 	}
 
 	new->irq = irq;
@@ -848,7 +855,7 @@ mismatch:
 		dump_stack();
 	}
 #endif
-	ret = -EBUSY;
+	return -EBUSY;
 
 out_thread:
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -897,8 +904,6 @@ static struct irqaction *__free_irq(unsi
 	if (!desc)
 		return NULL;
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
-
 	/*
 	 * There can be multiple actions per IRQ descriptor, find the right
 	 * one based on the dev_id:
@@ -909,8 +914,6 @@ static struct irqaction *__free_irq(unsi
 
 		if (!action) {
 			WARN(1, "Trying to free already-free IRQ %d\n", irq);
-			raw_spin_unlock_irqrestore(&desc->lock, flags);
-
 			return NULL;
 		}
 
@@ -919,6 +922,8 @@ static struct irqaction *__free_irq(unsi
 		action_ptr = &action->next;
 	}
 
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
 	/* Found it - now remove it from the list of entries: */
 	*action_ptr = action->next;
 


