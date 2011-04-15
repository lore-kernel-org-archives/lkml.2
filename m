Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1DOSm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:42:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32000 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1DOSmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:42:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6317"; a="86078499"
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
To: tglx@linutronix.de
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        mathieu.desnoyers@efficios.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        dwalker@fifo99.com, linux-arm-msm-owner@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [RFC PATCH] genirq: implement read_irq_line for interrupt lines
Date: Fri, 15 Apr 2011 11:42:32 -0700
Message-Id: <1302892952-7090-1-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers need to know what the status of the interrupt line is.
This is especially true for drivers that register a handler with
IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING and in the handler they
need to know which edge transition it was invoked for.

The irq_read_line callback in the chip allows the controller to provide
the real time status of this line. Controllers that can read the status
of an interrupt line should implement this by doing necessary
hardware reads and return the logical state of the line.

Interrupt controllers based on the slow bus architecture should conduct
the transaction in this callback. The genirq code will call the chip's
bus lock prior to calling irq_read_line. Obviously since the transaction
would be completed before returning from irq_read_line it need not do
any transactions in the bus unlock call.

Drivers need to be aware whether the interrupt controller is a slow bus
and call read_irq_line in proper context.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 include/linux/interrupt.h |    1 +
 include/linux/irq.h       |    2 ++
 kernel/irq/manage.c       |   25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 59b72ca..0722576 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -337,6 +337,7 @@ static inline void enable_irq_lockdep_irqrestore(unsigned int irq, unsigned long
 
 /* IRQ wakeup (PM) control: */
 extern int irq_set_irq_wake(unsigned int irq, unsigned int on);
+extern int irq_read_line(unsigned int irq);
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
 /* Please do not use: Use the replacement functions instead */
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 2a375a7..52198b6 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -298,6 +298,7 @@ static inline void irqd_clr_chained_irq_inprogress(struct irq_data *d)
  * @irq_retrigger:	resend an IRQ to the CPU
  * @irq_set_type:	set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
  * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
+ * @irq_read_line:	return the current value on the irq line
  * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
  * @irq_bus_sync_unlock:function to sync and unlock slow bus (i2c) chips
  * @irq_cpu_online:	configure an interrupt source for a secondary CPU
@@ -324,6 +325,7 @@ struct irq_chip {
 	int		(*irq_retrigger)(struct irq_data *data);
 	int		(*irq_set_type)(struct irq_data *data, unsigned int flow_type);
 	int		(*irq_set_wake)(struct irq_data *data, unsigned int on);
+	int		(*irq_read_line)(struct irq_data *data);
 
 	void		(*irq_bus_lock)(struct irq_data *data);
 	void		(*irq_bus_sync_unlock)(struct irq_data *data);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 12a80fd..6667052 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -518,6 +518,31 @@ int irq_set_irq_wake(unsigned int irq, unsigned int on)
 }
 EXPORT_SYMBOL(irq_set_irq_wake);
 
+/**
+ *	irq_read_line - read the value on an irq line
+ *	@irq: Interrupt number representing a hardware line
+ *
+ *	This function may be called from IRQ context only when
+ *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
+ */
+int irq_read_line(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+	int val;
+
+	if (!desc || !desc->irq_data.chip->irq_read_line)
+		return -EINVAL;
+
+	chip_bus_lock(desc);
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	val = desc->irq_data.chip->irq_read_line(&desc->irq_data);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(desc);
+	return val;
+}
+EXPORT_SYMBOL(irq_read_line);
+
 /*
  * Internal function that tells the architecture code whether a
  * particular irq has been exclusively allocated or is available
-- 
1.7.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
