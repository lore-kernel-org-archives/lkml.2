Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1C0QUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 12:20:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:36157 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1C0QT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 12:19:58 -0400
Date: Sun, 27 Mar 2011 16:19:49 GMT
From: tip-bot for David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ddaney@caviumnetworks.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ddaney@caviumnetworks.com, tglx@linutronix.de
In-Reply-To: <1301081931-11240-3-git-send-email-ddaney@caviumnetworks.com>
References: <1301081931-11240-3-git-send-email-ddaney@caviumnetworks.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Add chip hooks for taking CPUs on/off line.
Message-ID: <tip-0fdb4b259ed3e91b687ac26848202f5e7c217e62@git.kernel.org>
Git-Commit-ID: 0fdb4b259ed3e91b687ac26848202f5e7c217e62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Mar 2011 16:19:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fdb4b259ed3e91b687ac26848202f5e7c217e62
Gitweb:     http://git.kernel.org/tip/0fdb4b259ed3e91b687ac26848202f5e7c217e62
Author:     David Daney <ddaney@caviumnetworks.com>
AuthorDate: Fri, 25 Mar 2011 12:38:49 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 27 Mar 2011 17:45:58 +0200

genirq: Add chip hooks for taking CPUs on/off line.

[ tglx: Removed the enabled argument as this is now available in
irq_data ]

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org
LKML-Reference: <1301081931-11240-3-git-send-email-ddaney@caviumnetworks.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    8 +++++++
 kernel/irq/chip.c   |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8649b0f..c2a0c19 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -279,6 +279,8 @@ static inline bool irqd_irq_disabled(struct irq_data *d)
  * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
  * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
  * @irq_bus_sync_unlock:function to sync and unlock slow bus (i2c) chips
+ * @irq_cpu_online:	configure an interrupt source for a secondary CPU
+ * @irq_cpu_offline:	un-configure an interrupt source for a secondary CPU
  * @irq_print_chip:	optional to print special chip info in show_interrupts
  * @flags:		chip specific flags
  *
@@ -327,6 +329,9 @@ struct irq_chip {
 	void		(*irq_bus_lock)(struct irq_data *data);
 	void		(*irq_bus_sync_unlock)(struct irq_data *data);
 
+	void		(*irq_cpu_online)(struct irq_data *data);
+	void		(*irq_cpu_offline)(struct irq_data *data);
+
 	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);
 
 	unsigned long	flags;
@@ -372,6 +377,9 @@ struct irqaction;
 extern int setup_irq(unsigned int irq, struct irqaction *new);
 extern void remove_irq(unsigned int irq, struct irqaction *act);
 
+extern void irq_cpu_online(void);
+extern void irq_cpu_offline(void);
+
 #ifdef CONFIG_GENERIC_HARDIRQS
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 0a890bd..44b16a1 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -696,3 +696,61 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 
 	irq_put_desc_unlock(desc, flags);
 }
+
+/**
+ *	irq_cpu_online - Invoke all irq_cpu_online functions.
+ *
+ *	Iterate through all irqs and invoke the chip.irq_cpu_online()
+ *	for each.
+ */
+void irq_cpu_online(void)
+{
+	struct irq_desc *desc;
+	struct irq_chip *chip;
+	unsigned long flags;
+	unsigned int irq;
+
+	for_each_active_irq(irq) {
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		chip = irq_data_get_irq_chip(&desc->irq_data);
+
+		if (chip && chip->irq_cpu_online)
+			chip->irq_cpu_online(&desc->irq_data);
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
+
+/**
+ *	irq_cpu_offline - Invoke all irq_cpu_offline functions.
+ *
+ *	Iterate through all irqs and invoke the chip.irq_cpu_offline()
+ *	for each.
+ */
+void irq_cpu_offline(void)
+{
+	struct irq_desc *desc;
+	struct irq_chip *chip;
+	unsigned long flags;
+	unsigned int irq;
+
+	for_each_active_irq(irq) {
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		chip = irq_data_get_irq_chip(&desc->irq_data);
+
+		if (chip && chip->irq_cpu_offline)
+			chip->irq_cpu_offline(&desc->irq_data);
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
