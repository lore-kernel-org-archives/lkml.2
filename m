Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0LLLXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 06:23:44 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:51241 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab0LLLXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 06:23:42 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH v2 1/4] genirq: Introduce driver-readable IRQ status word
Date: Sun, 12 Dec 2010 12:22:41 +0100
Message-Id: <0b28922dfb7f5791fcb1866a0f1c033bacb8f4d8.1292152963.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1292152963.git.jan.kiszka@web.de>
References: <cover.1292152963.git.jan.kiszka@web.de>
In-Reply-To: <cover.1292152963.git.jan.kiszka@web.de>
References: <cover.1292152963.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1+mak4zWIIeT/ZxBV+7uCnlj0TtPa9/UqMfDZEz
	HMTPaxt/pVTUQkUqrkOb38ODbBXQ4JoqwuqfjMrOPfdXv2oyob
	QWnhsgAps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This associates a status word with every IRQ descriptor. Drivers can obtain
its content via get_irq_status(irq). First use case will be propagating the
interrupt sharing state.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 include/linux/interrupt.h |    2 ++
 include/linux/irq.h       |    2 ++
 kernel/irq/manage.c       |   15 +++++++++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 79d0c4f..16cdbbf 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -126,6 +126,8 @@ struct irqaction {
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
 
+extern unsigned long get_irq_status(unsigned long irq);
+
 #ifdef CONFIG_GENERIC_HARDIRQS
 extern int __must_check
 request_threaded_irq(unsigned int irq, irq_handler_t handler,
diff --git a/include/linux/irq.h b/include/linux/irq.h
index abde252..5554203 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -96,6 +96,7 @@ struct msi_desc;
  *			methods, to allow shared chip implementations
  * @msi_desc:		MSI descriptor
  * @affinity:		IRQ affinity on SMP
+ * @status:		driver-readable status flags (IRQS_*)
  *
  * The fields here need to overlay the ones in irq_desc until we
  * cleaned up the direct references and switched everything over to
@@ -108,6 +109,7 @@ struct irq_data {
 	void			*handler_data;
 	void			*chip_data;
 	struct msi_desc		*msi_desc;
+	unsigned long		status;
 #ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
 #endif
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5f92acc..df51284 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1157,3 +1157,18 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
 	return !ret ? IRQC_IS_HARDIRQ : ret;
 }
 EXPORT_SYMBOL_GPL(request_any_context_irq);
+
+/**
+ *	get_irq_status - read interrupt line status word
+ *	@irq: Interrupt line of the status word
+ *
+ *	This returns the current content of the status word associated with
+ *	the given interrupt line. See IRQS_* flags for details.
+ */
+unsigned long get_irq_status(unsigned long irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	return desc ? desc->irq_data.status : 0;
+}
+EXPORT_SYMBOL_GPL(get_irq_status);
-- 
1.7.1

