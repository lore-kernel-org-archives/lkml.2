Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1CUMAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:00:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37771 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752942Ab1CUMAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:00:02 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/Waa1JI/jW6YWK01VgbppdVBJZj8RRzi/eAtgrjc
	qGQDg4MvSdN3v3
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linuxpps@ml.enneenne.com,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 1/5] RFC genirq: Add IRQ timestamping
Date: Mon, 21 Mar 2011 12:59:16 +0100
Message-Id: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the IRQF_TIMESTAMP flag to register_threaded_irq()

There are several drivers which record timestamps in their irq handlers.
With the appearance of force_threaded irq handlers these timestamps will see
higher jitter. So by moving the task of taking the timestamp into genirq,
we can mitigate this problem.

Possible users of this:

- PPS is certeinly interested in timestamps as accurate as possible.
  they even tried to implement similar functionality.
  http://kerneltrap.org/mailarchive/linux-kernel/2008/9/10/3285514

- network software timestamps could take advantage of this.

- alsa also takes timestamps.

I am assuming here, that the drivers are actually interested in the time,
when the irq line was risen (Some of them take the timestamps pretty late,
which might be because, before hrtimer, time didnt advance in irq context
anyways, or they dont really care for accuracy, or they are actually
timestamping some operation inside the irq handler)

I am currently storing the timestamp in struct irqdesc and provide
struct timespec irq_get_timestamp( int irq );

Thomas Gleixner proposed to mandate that IRQF_TIMESTAMP irqs need to make
their device_id pointer point to the place where they want to record their
timestamp, and use container_of() to get their device struct then.

I must say i am not a huge fan of container_of() and tacking "obscure"
semantics to void pointers. But if an irq can fire while the handler thread
is still running, this might be our only choice.

However... this would also need to be supported in the subsystems.
iE if snd_usbaudio wants nice timestamps on its irqs. USB subsys would
need to allow it to request timestamps, and pass them on somehow.
So we probaby need functions to dynamically switch timestamping on and off.

This will be addressed in following patches.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/arm/mach-ns9xxx/irq.c              |    3 +++
 arch/m68knommu/platform/5272/intc.c     |    4 ++++
 arch/powerpc/platforms/cell/interrupt.c |    3 +++
 include/linux/interrupt.h               |    1 +
 include/linux/irq.h                     |    1 +
 include/linux/irqdesc.h                 |    1 +
 kernel/irq/chip.c                       |   15 +++++++++++++++
 kernel/irq/manage.c                     |   17 +++++++++++++++++
 kernel/irq/spurious.c                   |    4 ++++
 9 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ns9xxx/irq.c b/arch/arm/mach-ns9xxx/irq.c
index 389fa5c..d3d8a98 100644
--- a/arch/arm/mach-ns9xxx/irq.c
+++ b/arch/arm/mach-ns9xxx/irq.c
@@ -77,6 +77,9 @@ static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
 		goto out_mask;
 
+	if (desc->status & IRQ_TIMESTAMP)
+		getrawmonotonic(&desc->last_timestamp);
+
 	desc->status |= IRQ_INPROGRESS;
 	raw_spin_unlock(&desc->lock);
 
diff --git a/arch/m68knommu/platform/5272/intc.c b/arch/m68knommu/platform/5272/intc.c
index 3cf681c..69c28f4 100644
--- a/arch/m68knommu/platform/5272/intc.c
+++ b/arch/m68knommu/platform/5272/intc.c
@@ -138,6 +138,10 @@ static int intc_irq_set_type(unsigned int irq, unsigned int type)
 static void intc_external_irq(unsigned int irq, struct irq_desc *desc)
 {
 	kstat_incr_irqs_this_cpu(irq, desc);
+
+	if (desc->status & IRQ_TIMESTAMP)
+		getrawmonotonic(&desc->last_timestamp);
+
 	desc->status |= IRQ_INPROGRESS;
 	desc->chip->ack(irq);
 	handle_IRQ_event(irq, desc->action);
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 10eb1a4..a1fc538 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -257,6 +257,9 @@ static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
 
+	if (desc->status & IRQ_TIMESTAMP)
+		getrawmonotonic(&desc->last_timestamp);
+
 	do {
 		struct irqaction *action = desc->action;
 		irqreturn_t action_ret;
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 55e0d42..906b3b6 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -67,6 +67,7 @@
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
+#define IRQF_TIMESTAMP		0x00008000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index abde252..e6900fd 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -71,6 +71,7 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 #define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
+#define IRQ_TIMESTAMP		0x20000000	/* IRQ wants a timestamp  */
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index c1a95b7..89b0be0 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -80,6 +80,7 @@ struct irq_desc {
 	struct proc_dir_entry	*dir;
 #endif
 	const char		*name;
+	struct timespec		last_timestamp;
 } ____cacheline_internodealigned_in_smp;
 
 #ifndef CONFIG_SPARSE_IRQ
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index baa5c4a..aa06ca0 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -475,6 +475,9 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
 
+	if (desc->status & IRQ_TIMESTAMP)
+		getrawmonotonic(&desc->last_timestamp);
+
 	desc->status |= IRQ_INPROGRESS;
 	raw_spin_unlock(&desc->lock);
 
@@ -520,6 +523,9 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
 
+	if (desc->status & IRQ_TIMESTAMP)
+		getrawmonotonic(&desc->last_timestamp);
+
 	desc->status |= IRQ_INPROGRESS;
 	raw_spin_unlock(&desc->lock);
 
@@ -572,6 +578,9 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 		goto out;
 	}
 
+	if (desc->status & IRQ_TIMESTAMP)
+		getrawmonotonic(&desc->last_timestamp);
+
 	desc->status |= IRQ_INPROGRESS;
 	desc->status &= ~IRQ_PENDING;
 	raw_spin_unlock(&desc->lock);
@@ -624,6 +633,9 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
+	if (desc->status & IRQ_TIMESTAMP)
+		getrawmonotonic(&desc->last_timestamp);
+
 	/* Start handling the irq */
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
@@ -676,6 +688,9 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irqreturn_t action_ret;
 
+	if (desc->status & IRQ_TIMESTAMP)
+		getrawmonotonic(&desc->last_timestamp);
+
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	if (desc->irq_data.chip->irq_ack)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0caa59f..e9df1f0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -807,6 +807,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 				(int)(new->flags & IRQF_TRIGGER_MASK));
 	}
 
+	if (new->flags & IRQF_TIMESTAMP)
+		desc->status |= IRQ_TIMESTAMP;
+
 	new->irq = irq;
 	*old_ptr = new;
 
@@ -926,10 +929,24 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
+		desc->status &= ~(IRQ_TIMESTAMP);
 		if (desc->irq_data.chip->irq_shutdown)
 			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 		else
 			desc->irq_data.chip->irq_disable(&desc->irq_data);
+	} else {
+		/* check if the IRQ_TIMESTAMP flag needs to be reset */
+		if (action->flags & IRQF_TIMESTAMP) {
+			struct irqaction *act = desc->action;
+			unsigned long have_timestamp = 0;
+			while (act) {
+				have_timestamp |= (act->flags & IRQF_TIMESTAMP);
+				act = act->next;
+			}
+
+			if (!have_timestamp)
+				desc->status &= ~(IRQ_TIMESTAMP);
+		}
 	}
 
 #ifdef CONFIG_SMP
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 3089d3b..7cbd485 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -44,6 +44,10 @@ static int try_one_irq(int irq, struct irq_desc *desc)
 	}
 	/* Honour the normal IRQ locking */
 	desc->status |= IRQ_INPROGRESS;
+
+	if (desc->status & IRQ_TIMESTAMP)
+		getrawmonotonic(&desc->last_timestamp);
+
 	action = desc->action;
 	raw_spin_unlock(&desc->lock);
 
-- 
1.7.2.3

