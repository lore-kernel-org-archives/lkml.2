Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1C0QUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 12:20:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:36180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab1C0QUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 12:20:48 -0400
Date: Sun, 27 Mar 2011 16:20:39 GMT
From: tip-bot for David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ddaney@caviumnetworks.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ddaney@caviumnetworks.com, tglx@linutronix.de
In-Reply-To: <1301081931-11240-4-git-send-email-ddaney@caviumnetworks.com>
References: <1301081931-11240-4-git-send-email-ddaney@caviumnetworks.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Split irq_set_affinity() so it can be called with lock held.
Message-ID: <tip-c2d0c555c22242c3a76e366074c4d83ef9fa3b8c@git.kernel.org>
Git-Commit-ID: c2d0c555c22242c3a76e366074c4d83ef9fa3b8c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Mar 2011 16:20:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2d0c555c22242c3a76e366074c4d83ef9fa3b8c
Gitweb:     http://git.kernel.org/tip/c2d0c555c22242c3a76e366074c4d83ef9fa3b8c
Author:     David Daney <ddaney@caviumnetworks.com>
AuthorDate: Fri, 25 Mar 2011 12:38:50 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 27 Mar 2011 17:45:59 +0200

genirq: Split irq_set_affinity() so it can be called with lock held.

The .irq_cpu_online() and .irq_cpu_offline() functions may need to
adjust affinity, but they are called with the descriptor lock held.
Create __irq_set_affinity_locked() which is called with the lock held.
Make irq_set_affinity() just a wrapper that acquires the lock.

[ tglx: Changed the argument to irq_data, added a !desc check and
        moved the !irq_set_affinity check where it belongs ]

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org
LKML-Reference: <1301081931-11240-4-git-send-email-ddaney@caviumnetworks.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    1 +
 kernel/irq/manage.c |   48 ++++++++++++++++++++++++++++++------------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 76e948f..a10717e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -382,6 +382,7 @@ extern void remove_irq(unsigned int irq, struct irqaction *act);
 
 extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
+extern int __irq_set_affinity_locked(struct irq_data *data,  const struct cpumask *cpumask);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a2aa73..3d151fd 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -139,35 +139,26 @@ static inline void
 irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
 #endif
 
-/**
- *	irq_set_affinity - Set the irq affinity of a given irq
- *	@irq:		Interrupt to set affinity
- *	@cpumask:	cpumask
- *
- */
-int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = desc->irq_data.chip;
-	unsigned long flags;
+	struct irq_chip *chip = irq_data_get_irq_chip(data);
+	struct irq_desc *desc = irq_data_to_desc(data);
 	int ret = 0;
 
-	if (!chip->irq_set_affinity)
+	if (!chip || !chip->irq_set_affinity)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
-
-	if (irq_can_move_pcntxt(desc)) {
-		ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
+	if (irqd_can_move_in_process_context(data)) {
+		ret = chip->irq_set_affinity(data, mask, false);
 		switch (ret) {
 		case IRQ_SET_MASK_OK:
-			cpumask_copy(desc->irq_data.affinity, mask);
+			cpumask_copy(data->affinity, mask);
 		case IRQ_SET_MASK_OK_NOCOPY:
 			irq_set_thread_affinity(desc);
 			ret = 0;
 		}
 	} else {
-		irqd_set_move_pending(&desc->irq_data);
+		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
 	}
 
@@ -176,7 +167,28 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 		schedule_work(&desc->affinity_notify->work);
 	}
 	irq_compat_set_affinity(desc);
-	irqd_set(&desc->irq_data, IRQD_AFFINITY_SET);
+	irqd_set(data, IRQD_AFFINITY_SET);
+
+	return ret;
+}
+
+/**
+ *	irq_set_affinity - Set the irq affinity of a given irq
+ *	@irq:		Interrupt to set affinity
+ *	@cpumask:	cpumask
+ *
+ */
+int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+	int ret;
+
+	if (!desc)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
