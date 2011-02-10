Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab1BJXhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:50 -0500
Received: from www.tglx.de ([62.245.132.106]:44296 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab1BJXhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:42 -0500
Message-Id: <20110210223257.694466031@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 35/75] genirq: Protect tglx from tripping over his own feet
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-protect-myself.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq_desc.status field will either go away or renamed to
settings. Anyway we need to maintain compatibility to avoid breaking
the world and some more. While moving bits into the core, I need to
avoid that I use any of the still existing IRQ_ bits in the core code
by typos. So that file will hold the inline wrappers and some nasty
CPP tricks to break the build when typoed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/internals.h |    2 ++
 kernel/irq/irqdesc.c   |    4 ++--
 kernel/irq/settings.h  |    7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -7,6 +7,8 @@
  */
 #include <linux/irqdesc.h>
 
+#include "settings.h"
+
 #define istate core_internal_state__do_not_mess_with_it
 
 extern int noirqdebug;
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -79,7 +79,7 @@ static void desc_set_defaults(unsigned i
 	desc->irq_data.chip_data = NULL;
 	desc->irq_data.handler_data = NULL;
 	desc->irq_data.msi_desc = NULL;
-	desc->status = IRQ_DEFAULT_INIT_FLAGS;
+	desc->status = _IRQ_DEFAULT_INIT_FLAGS;
 	desc->handle_irq = handle_bad_irq;
 	desc->depth = 1;
 	desc->irq_count = 0;
@@ -229,7 +229,7 @@ int __init early_irq_init(void)
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
-		.status		= IRQ_DEFAULT_INIT_FLAGS,
+		.status		= _IRQ_DEFAULT_INIT_FLAGS,
 		.handle_irq	= handle_bad_irq,
 		.depth		= 1,
 		.lock		= __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- /dev/null
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -0,0 +1,7 @@
+/*
+ * Internal header to deal with irq_desc->status which will be renamed
+ * to irq_desc->settings.
+ */
+enum {
+	_IRQ_DEFAULT_INIT_FLAGS	= IRQ_DEFAULT_INIT_FLAGS,
+};


