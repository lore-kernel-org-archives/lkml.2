Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0LMXAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:00:14 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:50117 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0LMXAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:00:10 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH v3 1/4] genirq: Introduce driver-readable IRQ status word
Date: Mon, 13 Dec 2010 23:59:43 +0100
Message-Id: <3575edb77b3e824f921b6fdbbe5a4fdb8a549e17.1292281184.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1292281184.git.jan.kiszka@web.de>
References: <cover.1292281184.git.jan.kiszka@web.de>
In-Reply-To: <cover.1292281184.git.jan.kiszka@web.de>
References: <cover.1292281184.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1+A0rzPoWXJBpzkv3OjvGzs0SE/Ow4orUkhiUt7
	TrTd2B3f00ZlbLxM/+3ossN2dd4sEUv0SKv1M+tUN4JzhEbLpb
	NnLDXjj8c=
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
index 79d0c4f..4c1aa72 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -126,6 +126,8 @@ struct irqaction {
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
 
+extern unsigned long get_irq_status(unsigned int irq);
+
 #ifdef CONFIG_GENERIC_HARDIRQS
 extern int __must_check
 request_threaded_irq(unsigned int irq, irq_handler_t handler,
diff --git a/include/linux/irq.h b/include/linux/irq.h
index abde252..8bdb421 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -96,6 +96,7 @@ struct msi_desc;
  *			methods, to allow shared chip implementations
  * @msi_desc:		MSI descriptor
  * @affinity:		IRQ affinity on SMP
+ * @drv_status:		driver-readable status flags (IRQS_*)
  *
  * The fields here need to overlay the ones in irq_desc until we
  * cleaned up the direct references and switched everything over to
@@ -111,6 +112,7 @@ struct irq_data {
 #ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
 #endif
+	unsigned long		drv_status;
 };
 
 /**
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5f92acc..2ea0d30 100644
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
+unsigned long get_irq_status(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	return desc ? desc->irq_data.drv_status : 0;
+}
+EXPORT_SYMBOL_GPL(get_irq_status);
-- 
1.7.1

