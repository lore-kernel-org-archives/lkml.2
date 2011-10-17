Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1JQCH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 22:07:57 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53370 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1JQCHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 22:07:55 -0400
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 2/2] irq: Add function pointer table for generic-chip
Date: Mon, 17 Oct 2011 11:08:47 +0900
Message-Id: <1318817327-4589-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318817327-4589-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1318817327-4589-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the function table to access it with function pointer
by some functions providedd in generic-chip.
The driver who uses the function offered in generic-chip can use
this via this function table.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 include/linux/irq.h       |   27 ++++++++++++++++-----------
 kernel/irq/generic-chip.c |   31 +++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bff29c5..06ed817 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -638,6 +638,20 @@ struct irq_chip_type {
 	u32			type;
 };
 
+/* Generic chip callback functions table */
+struct irq_gc_functions {
+	void (* gc_noop)(struct irq_data *d);
+	void (* gc_mask_disable_reg)(struct irq_data *d);
+	void (* gc_mask_set_bit)(struct irq_data *d);
+	void (* gc_mask_clr_bit)(struct irq_data *d);
+	void (* gc_unmask_enable_reg)(struct irq_data *d);
+	void (* gc_ack_set_bit)(struct irq_data *d);
+	void (* gc_ack_clr_bit)(struct irq_data *d);
+	void (* gc_mask_disable_reg_and_ack)(struct irq_data *d);
+	void (* gc_eoi)(struct irq_data *d);
+	int (* gc_set_wake)(struct irq_data *d, unsigned int on);
+};
+
 /**
  * struct irq_chip_generic - Generic irq chip data structure
  * @lock:		Lock to protect register and cache data access
@@ -653,6 +667,7 @@ struct irq_chip_type {
  * @private:		Private data for non generic chip callbacks
  * @list:		List head for keeping track of instances
  * @chip_types:		Array of interrupt irq_chip_types
+ * @functions:		Generic chip callback functions
  *
  * Note, that irq_chip_generic can have multiple irq_chip_type
  * implementations which can be associated to a particular irq line of
@@ -674,6 +689,7 @@ struct irq_chip_generic {
 	void			*private;
 	struct list_head	list;
 	struct irq_chip_type	chip_types[0];
+	struct irq_gc_functions	functions;
 };
 
 /**
@@ -688,17 +704,6 @@ enum irq_gc_flags {
 	IRQ_GC_INIT_NESTED_LOCK		= 1 << 1,
 };
 
-/* Generic chip callback functions */
-void irq_gc_noop(struct irq_data *d);
-void irq_gc_mask_disable_reg(struct irq_data *d);
-void irq_gc_mask_set_bit(struct irq_data *d);
-void irq_gc_mask_clr_bit(struct irq_data *d);
-void irq_gc_unmask_enable_reg(struct irq_data *d);
-void irq_gc_ack_set_bit(struct irq_data *d);
-void irq_gc_ack_clr_bit(struct irq_data *d);
-void irq_gc_mask_disable_reg_and_ack(struct irq_data *d);
-void irq_gc_eoi(struct irq_data *d);
-int irq_gc_set_wake(struct irq_data *d, unsigned int on);
 
 /* Setup functions for irq_chip_generic */
 struct irq_chip_generic *
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 6cb7613..8aec156 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -24,7 +24,7 @@ static inline struct irq_chip_regs *cur_regs(struct irq_data *d)
  * irq_gc_noop - NOOP function
  * @d: irq_data
  */
-void irq_gc_noop(struct irq_data *d)
+static void irq_gc_noop(struct irq_data *d)
 {
 }
 
@@ -35,7 +35,7 @@ void irq_gc_noop(struct irq_data *d)
  * Chip has separate enable/disable registers instead of a single mask
  * register.
  */
-void irq_gc_mask_disable_reg(struct irq_data *d)
+static void irq_gc_mask_disable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
@@ -53,7 +53,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
  * Chip has a single mask register. Values of this register are cached
  * and protected by gc->lock
  */
-void irq_gc_mask_set_bit(struct irq_data *d)
+static void irq_gc_mask_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
@@ -71,7 +71,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
  * Chip has a single mask register. Values of this register are cached
  * and protected by gc->lock
  */
-void irq_gc_mask_clr_bit(struct irq_data *d)
+static void irq_gc_mask_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
@@ -89,7 +89,7 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
  * Chip has separate enable/disable registers instead of a single mask
  * register.
  */
-void irq_gc_unmask_enable_reg(struct irq_data *d)
+static void irq_gc_unmask_enable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
@@ -104,7 +104,7 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
  * irq_gc_ack_set_bit - Ack pending interrupt via setting bit
  * @d: irq_data
  */
-void irq_gc_ack_set_bit(struct irq_data *d)
+static void irq_gc_ack_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
@@ -118,7 +118,7 @@ void irq_gc_ack_set_bit(struct irq_data *d)
  * irq_gc_ack_clr_bit - Ack pending interrupt via clearing bit
  * @d: irq_data
  */
-void irq_gc_ack_clr_bit(struct irq_data *d)
+static void irq_gc_ack_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	u32 mask = ~(1 << (d->irq - gc->irq_base));
@@ -132,7 +132,7 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
  * irq_gc_mask_disable_reg_and_ack- Mask and ack pending interrupt
  * @d: irq_data
  */
-void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
+static void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
@@ -147,7 +147,7 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
  * irq_gc_eoi - EOI interrupt
  * @d: irq_data
  */
-void irq_gc_eoi(struct irq_data *d)
+static void irq_gc_eoi(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
@@ -165,7 +165,7 @@ void irq_gc_eoi(struct irq_data *d)
  * configured in a separate register and the wakeup active state is
  * just stored in a bitmask.
  */
-int irq_gc_set_wake(struct irq_data *d, unsigned int on)
+static int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << (d->irq - gc->irq_base);
@@ -208,6 +208,17 @@ irq_alloc_generic_chip(const char *name, int num_ct, unsigned int irq_base,
 		gc->reg_base = reg_base;
 		gc->chip_types->chip.name = name;
 		gc->chip_types->handler = handler;
+
+		gc->functions.gc_noop = irq_gc_noop;
+		gc->functions.gc_mask_disable_reg = irq_gc_mask_disable_reg;
+		gc->functions.gc_mask_set_bit = irq_gc_mask_set_bit;
+		gc->functions.gc_mask_clr_bit = irq_gc_mask_clr_bit;
+		gc->functions.gc_unmask_enable_reg = irq_gc_unmask_enable_reg;
+		gc->functions.gc_ack_set_bit = irq_gc_ack_set_bit;
+		gc->functions.gc_ack_clr_bit = irq_gc_ack_clr_bit;
+		gc->functions.gc_mask_disable_reg_and_ack = irq_gc_mask_disable_reg_and_ack;
+		gc->functions.gc_eoi = irq_gc_eoi;
+		gc->functions.gc_set_wake = irq_gc_set_wake;
 	}
 	return gc;
 }
-- 
1.7.7

