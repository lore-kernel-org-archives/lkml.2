Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab1BJXmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:42:20 -0500
Received: from www.tglx.de ([62.245.132.106]:44462 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab1BJXiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:19 -0500
Message-Id: <20110210223300.182015620@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 61/75] genirq: Cleanup irq.h
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-cleanup-irq-h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the constants into an enum and document them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h   |   90 ++++++++++++++++++++++++++++++++------------------
 kernel/irq/settings.h |   15 --------
 2 files changed, 59 insertions(+), 46 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -36,42 +36,70 @@ typedef	void (*irq_flow_handler_t)(unsig
 /*
  * IRQ line status.
  *
- * Bits 0-7 are reserved for the IRQF_* bits in linux/interrupt.h
+ * Bits 0-7 are the same as the IRQF_* bits in linux/interrupt.h
+ *
+ * IRQ_TYPE_NONE		- default, unspecified type
+ * IRQ_TYPE_EDGE_RISING		- rising edge triggered
+ * IRQ_TYPE_EDGE_FALLING	- falling edge triggered
+ * IRQ_TYPE_EDGE_BOTH		- rising and falling edge triggered
+ * IRQ_TYPE_LEVEL_HIGH		- high level triggered
+ * IRQ_TYPE_LEVEL_LOW		- low level triggered
+ * IRQ_TYPE_LEVEL_MASK		- Mask to filter out the level bits
+ * IRQ_TYPE_SENSE_MASK		- Mask for all the above bits
+ * IRQ_TYPE_PROBE		- Special flag for probing in progress
+ *
+ * Bits which can be modified via irq_set/clear/modify_status_flags()
+ * IRQ_LEVEL			- Interrupt is level type. Will be also
+ *				  updated in the code when the above trigger
+ *				  bits are modified via set_irq_type()
+ * IRQ_PER_CPU			- Mark an interrupt PER_CPU. Will protect
+ *				  it from affinity setting
+ * IRQ_NOPROBE			- Interrupt cannot be probed by autoprobing
+ * IRQ_NOREQUEST		- Interrupt cannot be requested via
+ *				  request_irq()
+ * IRQ_NOAUTOEN			- Interrupt is not automatically enabled in
+ *				  request/setup_irq()
+ * IRQ_NO_BALANCING		- Interrupt cannot be balanced (affinity set)
+ * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
+ *
+ * Deprecated bits. They are kept updated as long as
+ * CONFIG_GENERIC_HARDIRQS_NO_COMPAT is not set. Will go away soon. These bits
+ * are internal state of the core code and if you really need to acces
+ * them then talk to the genirq maintainer instead of hacking
+ * something weird.
  *
- * IRQ types
  */
-#define IRQ_TYPE_NONE		0x00000000	/* Default, unspecified type */
-#define IRQ_TYPE_EDGE_RISING	0x00000001	/* Edge rising type */
-#define IRQ_TYPE_EDGE_FALLING	0x00000002	/* Edge falling type */
-#define IRQ_TYPE_EDGE_BOTH (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING)
-#define IRQ_TYPE_LEVEL_HIGH	0x00000004	/* Level high type */
-#define IRQ_TYPE_LEVEL_LOW	0x00000008	/* Level low type */
-#define IRQ_TYPE_LEVEL_MASK	(IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH)
-#define IRQ_TYPE_SENSE_MASK	0x0000000f	/* Mask of the above */
-
-#define IRQ_TYPE_PROBE		0x00000010	/* Probing in progress */
-
-/* Internal flags */
+enum {
+	IRQ_TYPE_NONE		= 0x00000000,
+	IRQ_TYPE_EDGE_RISING	= 0x00000001,
+	IRQ_TYPE_EDGE_FALLING	= 0x00000002,
+	IRQ_TYPE_EDGE_BOTH	= (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING),
+	IRQ_TYPE_LEVEL_HIGH	= 0x00000004,
+	IRQ_TYPE_LEVEL_LOW	= 0x00000008,
+	IRQ_TYPE_LEVEL_MASK	= (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH),
+	IRQ_TYPE_SENSE_MASK	= 0x0000000f,
+
+	IRQ_TYPE_PROBE		= 0x00000010,
+
+	IRQ_LEVEL		= (1 <<  8),
+	IRQ_PER_CPU		= (1 <<  9),
+	IRQ_NOPROBE		= (1 << 10),
+	IRQ_NOREQUEST		= (1 << 11),
+	IRQ_NOAUTOEN		= (1 << 12),
+	IRQ_NO_BALANCING	= (1 << 13),
+	IRQ_MOVE_PCNTXT		= (1 << 14),
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
-#define IRQ_INPROGRESS		0x00000100	/* DEPRECATED */
-#define IRQ_REPLAY		0x00000200	/* DEPRECATED */
-#define IRQ_WAITING		0x00000400	/* DEPRECATED */
-#define IRQ_DISABLED		0x00000800	/* DEPRECATED */
-#define IRQ_PENDING		0x00001000	/* DEPRECATED */
-#define IRQ_MASKED		0x00002000	/* DEPRECATED */
-/* DEPRECATED use irq_setaffinity_pending() instead*/
-#define IRQ_MOVE_PENDING	0x00004000
-#define IRQ_AFFINITY_SET	0x02000000	/* DEPRECATED */
+	IRQ_INPROGRESS		= (1 << 24),
+	IRQ_REPLAY		= (1 << 25),
+	IRQ_WAITING		= (1 << 26),
+	IRQ_DISABLED		= (1 << 27),
+	IRQ_PENDING		= (1 << 28),
+	IRQ_MASKED		= (1 << 29),
+	IRQ_MOVE_PENDING	= (1 << 30),
+	IRQ_AFFINITY_SET	= (1 << 31),
 #endif
-
-#define IRQ_LEVEL		0x00008000	/* IRQ level triggered */
-#define IRQ_PER_CPU		0x00010000	/* IRQ is per CPU */
-#define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
-#define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
-#define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
-#define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
-#define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
+};
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -14,35 +14,20 @@ enum {
 	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
 };
 
-#undef IRQ_INPROGRESS
 #define IRQ_INPROGRESS		GOT_YOU_MORON
-#undef IRQ_REPLAY
 #define IRQ_REPLAY		GOT_YOU_MORON
-#undef IRQ_WAITING
 #define IRQ_WAITING		GOT_YOU_MORON
-#undef IRQ_DISABLED
 #define IRQ_DISABLED		GOT_YOU_MORON
-#undef IRQ_PENDING
 #define IRQ_PENDING		GOT_YOU_MORON
-#undef IRQ_MASKED
 #define IRQ_MASKED		GOT_YOU_MORON
-#undef IRQ_WAKEUP
 #define IRQ_WAKEUP		GOT_YOU_MORON
-#undef IRQ_MOVE_PENDING
 #define IRQ_MOVE_PENDING	GOT_YOU_MORON
-#undef IRQ_PER_CPU
 #define IRQ_PER_CPU		GOT_YOU_MORON
-#undef IRQ_NO_BALANCING
 #define IRQ_NO_BALANCING	GOT_YOU_MORON
-#undef IRQ_AFFINITY_SET
 #define IRQ_AFFINITY_SET	GOT_YOU_MORON
-#undef IRQ_LEVEL
 #define IRQ_LEVEL		GOT_YOU_MORON
-#undef IRQ_NOPROBE
 #define IRQ_NOPROBE		GOT_YOU_MORON
-#undef IRQ_NOREQUEST
 #define IRQ_NOREQUEST		GOT_YOU_MORON
-#undef IRQ_NOAUTOEN
 #define IRQ_NOATOEN		GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON


