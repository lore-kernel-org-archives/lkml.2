Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1G0WAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:00:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:36368 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab1G0VtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="33043725"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: tglx@linutronix.de, stefan.bader@canonical.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [61/99] genirq: Add IRQF_FORCE_RESUME
Message-Id: <20110727214900.689EA2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit dc5f219e88294b93009eef946251251ffffb6d60 upstream.

Xen needs to reenable interrupts which are marked IRQF_NO_SUSPEND in the
resume path. Add a flag to force the reenabling in the resume code.

Tested-and-acked-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/interrupt.h |    3 ++-
 kernel/irq/manage.c       |   11 ++++++++++-
 kernel/irq/pm.c           |    3 ---
 3 files changed, 12 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/include/linux/interrupt.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/interrupt.h
+++ linux-2.6.35.y/include/linux/interrupt.h
@@ -54,7 +54,7 @@
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
- *
+ * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -66,6 +66,7 @@
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
+#define IRQF_FORCE_RESUME	0x00008000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
Index: linux-2.6.35.y/kernel/irq/manage.c
===================================================================
--- linux-2.6.35.y.orig/kernel/irq/manage.c
+++ linux-2.6.35.y/kernel/irq/manage.c
@@ -281,8 +281,17 @@ EXPORT_SYMBOL(disable_irq);
 
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
-	if (resume)
+	if (resume) {
+		if (!(desc->status & IRQ_SUSPENDED)) {
+			if (!desc->action)
+				return;
+			if (!(desc->action->flags & IRQF_FORCE_RESUME))
+				return;
+			/* Pretend that it got disabled ! */
+			desc->depth++;
+		}
 		desc->status &= ~IRQ_SUSPENDED;
+	}
 
 	switch (desc->depth) {
 	case 0:
Index: linux-2.6.35.y/kernel/irq/pm.c
===================================================================
--- linux-2.6.35.y.orig/kernel/irq/pm.c
+++ linux-2.6.35.y/kernel/irq/pm.c
@@ -53,9 +53,6 @@ void resume_device_irqs(void)
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
 
-		if (!(desc->status & IRQ_SUSPENDED))
-			continue;
-
 		raw_spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
