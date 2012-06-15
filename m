Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab2FOG3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 02:29:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50473 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2FOG3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:29:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1206141221360.3086@ionos>
References: <1339662697-4600-1-git-send-email-ning.n.jiang@gmail.com>
	<1339662697-4600-2-git-send-email-ning.n.jiang@gmail.com>
	<alpine.LFD.2.02.1206141221360.3086@ionos>
Date: Fri, 15 Jun 2012 14:29:37 +0800
Message-ID: <CAH3Oq6R_z1jQ9GPwHJ8yfZUK0mZyK8vwpKsWDBXDTpfOpe4o1w@mail.gmail.com>
Subject: Re: [PATCH 2/2] genirq: Resend nested irq's ancestor irq
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/14 Thomas Gleixner <tglx@linutronix.de>:
> On Thu, 14 Jun 2012, Ning Jiang wrote:
>> We'll set IRQS_PENDING for handle_nested_irq if it's disabled. When
>> it's re-enabled later on, check_irq_resend() will detect this flag
>> and trigger the software resend mechanism. resend_irqs() will call
>> desc->handle_irq() directly to process this interrupt, hence the
>> irq_nested_primary_handler() will be called for the nested irq which
>> gives us a warning.
>>
>> If we need to resend a nested interrupt, we have to trace all the
>> way back to its ancestor and trigger ancestor's irq flow handler.
>
> And what makes you believe that the ancestors demux handler will find
> the irq bit of the nested interrupt still pending? There is NO
> guarantee for that.

You are right.

> The correct solution for this is to replace the tasklet with a kernel
> thread and check whether the interrupt is marked nested or not and
> then invoke the correct function.
>

Do you want something like this? This just gives a rough idea. Please
help to review.

>From 1ce5f392446a06631d190468b314b7060f5c34ae Mon Sep 17 00:00:00 2001
From: Ning Jiang <ning.n.jiang@gmail.com>
Date: Fri, 15 Jun 2012 09:13:24 +0800
Subject: [PATCH] genirq: Create temporary kernel thread when resending
nested irq

---
 kernel/irq/chip.c      |    1 +
 kernel/irq/handle.c    |    2 +-
 kernel/irq/internals.h |    4 ++++
 kernel/irq/manage.c    |    8 +++++++-
 kernel/irq/resend.c    |   20 +++++++++++++++++---
 5 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6cec1a2..ec48d4e 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -272,6 +272,7 @@ void handle_nested_irq(unsigned int irq)

 	raw_spin_lock_irq(&desc->lock);

+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);

 	action = desc->action;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index bdb1803..556b469 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -51,7 +51,7 @@ static void warn_no_thread(unsigned int irq, struct
irqaction *action)
 	       "but no thread function available.", irq, action->name);
 }

-static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
+void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 {
 	/*
 	 * In case the thread crashed and was killed we just pretend that
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 001fa5b..fd9dabe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -104,6 +104,10 @@ extern void irq_set_thread_affinity(struct irq_desc *desc);
 extern int irq_do_set_affinity(struct irq_data *data,
 			       const struct cpumask *dest, bool force);

+extern int irq_thread(void *data);
+
+extern void irq_wake_thread(struct irq_desc *desc, struct irqaction *action);
+
 /* Inline functions for support of irq chips on slow busses */
 static inline void chip_bus_lock(struct irq_desc *desc)
 {
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8c54823..2bd4a39 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -811,7 +811,7 @@ static void irq_thread_dtor(struct task_work *unused)
 /*
  * Interrupt handler thread
  */
-static int irq_thread(void *data)
+int irq_thread(void *data)
 {
 	struct task_work on_exit_work;
 	static const struct sched_param param = {
@@ -843,6 +843,12 @@ static int irq_thread(void *data)
 			note_interrupt(action->irq, desc, action_ret);

 		wake_threads_waitq(desc);
+
+		if (irq_settings_is_nested_thread(desc) && desc->action->thread) {
+			put_task_struct(desc->action->thread);
+			desc->action->thread = NULL;
+			do_exit(0);
+		}
 	}

 	/*
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 6454db7..5bb9227 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -14,6 +14,7 @@
  */

 #include <linux/irq.h>
+#include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
@@ -74,9 +75,22 @@ void check_irq_resend(struct irq_desc *desc,
unsigned int irq)
 		if (!desc->irq_data.chip->irq_retrigger ||
 		    !desc->irq_data.chip->irq_retrigger(&desc->irq_data)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
-			/* Set it pending and activate the softirq: */
-			set_bit(irq, irqs_resend);
-			tasklet_schedule(&resend_tasklet);
+			struct task_struct *t;
+			if (irq_settings_is_nested_thread(desc)) {
+				raw_spin_unlock(&desc->lock);
+				t = kthread_create(irq_thread, desc->action,
+					"irq/%d-%s", irq, desc->action->name);
+				raw_spin_lock(&desc->lock);
+				if (IS_ERR(t))
+					return;
+				get_task_struct(t);
+				desc->action->thread = t;
+				irq_wake_thread(desc, desc->action);
+			} else {
+				/* Set it pending and activate the softirq: */
+				set_bit(irq, irqs_resend);
+				tasklet_schedule(&resend_tasklet);
+			}
 #endif
 		}
 	}
-- 
1.7.1


> That requires a check for irq in progress in the nested handler as
> well, but that's trivial to add.

Will check it later.

> Thanks,
>
>        tglx
