Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1FOO30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:29:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37230 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1FOO3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LgWiTjJH71wjxExglCbzFuE+xnrElil+I8F36wb1fnmXhU1WZAW9loS9uagyeZR6Zj
         4kmeBTB6A7gL/nmlSNFD7zUaHBNbm+hYy9QJHb5p1ZHzjEvXValCB1HZsWN2Kyi/plYr
         CY9IwU/eYNsTGuo6o8q1guZPE8onkDrDVeekA=
Date: Wed, 15 Jun 2011 16:29:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: don't use flush_scheduled_work() in IRQ affinity
 notifiers
Message-ID: <20110615142917.GY8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cd7eab44e9 (genirq: Add IRQ affinity notifiers) added use of
flush_scheduled_work() which is being deprecated.  Add a dedicated
workqueue and flush it instead of flushing system-wide workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ben Hutchings <bhutchings@solarflare.com>
---
I'm planning on marking flush_scheduled_work() deprecated in
linux-next soonish.  It would be great if this patch (or something
else which removes flush_scheduled_work() call somehow) can be
included in linux-next.

Thanks.

 include/linux/interrupt.h |    6 +-----
 kernel/irq/manage.c       |   17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 6 deletions(-)

Index: work/include/linux/interrupt.h
===================================================================
--- work.orig/include/linux/interrupt.h
+++ work/include/linux/interrupt.h
@@ -256,11 +256,7 @@ struct irq_affinity_notify {
 
 extern int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
-
-static inline void irq_run_affinity_notifiers(void)
-{
-	flush_scheduled_work();
-}
+extern void irq_run_affinity_notifiers(void);
 
 #else /* CONFIG_SMP */
 
Index: work/kernel/irq/manage.c
===================================================================
--- work.orig/kernel/irq/manage.c
+++ work/kernel/irq/manage.c
@@ -74,6 +74,16 @@ EXPORT_SYMBOL(synchronize_irq);
 
 #ifdef CONFIG_SMP
 cpumask_var_t irq_default_affinity;
+static struct workqueue_struct *irq_affinity_notify_wq;
+
+static int __init irq_affinity_init(void)
+{
+	irq_affinity_notify_wq = alloc_workqueue("irq_affinity_notify", 0, 0);
+	if (!irq_affinity_notify_wq)
+		return -ENOMEM;
+	return 0;
+}
+subsys_initcall(irq_affinity_init);
 
 /**
  *	irq_can_set_affinity - Check if the affinity of a given irq can be set
@@ -164,7 +174,7 @@ int __irq_set_affinity_locked(struct irq
 
 	if (desc->affinity_notify) {
 		kref_get(&desc->affinity_notify->kref);
-		schedule_work(&desc->affinity_notify->work);
+		queue_work(irq_affinity_notify_wq, &desc->affinity_notify->work);
 	}
 	irqd_set(data, IRQD_AFFINITY_SET);
 
@@ -273,6 +283,11 @@ irq_set_affinity_notifier(unsigned int i
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
 
+void irq_run_affinity_notifiers(void)
+{
+	flush_workqueue(irq_affinity_notify_wq);
+}
+
 #ifndef CONFIG_AUTO_IRQ_AFFINITY
 /*
  * Generic version of the affinity autoselector.
