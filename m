Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1LASSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:18:41 -0500
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:14999 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab1LASSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:18:17 -0500
Message-Id: <201112011815.pB1IFEpF004912@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Dec 2011 12:58:19 -0500
Subject: [PATCH] arch/tile: use new generic {enable,disable}_percpu_irq() routines
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        netdev@vger.kernel.org
X-OriginalArrivalTime: 01 Dec 2011 18:15:15.0112 (UTC) FILETIME=[2C6F9280:01CCB055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We provided very similar routines internally, but now we can hook
into the generic framework by supplying our routines as function
pointers in the irq_chip structure instead.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/irq.h         |   10 ----------
 arch/tile/kernel/irq.c              |   16 ++++++++--------
 drivers/net/ethernet/tile/tilepro.c |    4 ++--
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/tile/include/asm/irq.h b/arch/tile/include/asm/irq.h
index 94e9a51..f80f8ce 100644
--- a/arch/tile/include/asm/irq.h
+++ b/arch/tile/include/asm/irq.h
@@ -74,16 +74,6 @@ enum {
  */
 void tile_irq_activate(unsigned int irq, int tile_irq_type);
 
-/*
- * For onboard, non-PCI (e.g. TILE_IRQ_PERCPU) devices, drivers know
- * how to use enable/disable_percpu_irq() to manage interrupts on each
- * core.  We can't use the generic enable/disable_irq() because they
- * use a single reference count per irq, rather than per cpu per irq.
- */
-void enable_percpu_irq(unsigned int irq);
-void disable_percpu_irq(unsigned int irq);
-
-
 void setup_irq_regs(void);
 
 #endif /* _ASM_TILE_IRQ_H */
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index aa0134d..02e6280 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -152,14 +152,13 @@ void tile_dev_intr(struct pt_regs *regs, int intnum)
  * Remove an irq from the disabled mask.  If we're in an interrupt
  * context, defer enabling the HW interrupt until we leave.
  */
-void enable_percpu_irq(unsigned int irq)
+static void tile_irq_chip_enable(struct irq_data *d)
 {
-	get_cpu_var(irq_disable_mask) &= ~(1UL << irq);
+	get_cpu_var(irq_disable_mask) &= ~(1UL << d->irq);
 	if (__get_cpu_var(irq_depth) == 0)
-		unmask_irqs(1UL << irq);
+		unmask_irqs(1UL << d->irq);
 	put_cpu_var(irq_disable_mask);
 }
-EXPORT_SYMBOL(enable_percpu_irq);
 
 /*
  * Add an irq to the disabled mask.  We disable the HW interrupt
@@ -167,13 +166,12 @@ EXPORT_SYMBOL(enable_percpu_irq);
  * in an interrupt context, the return path is careful to avoid
  * unmasking a newly disabled interrupt.
  */
-void disable_percpu_irq(unsigned int irq)
+static void tile_irq_chip_disable(struct irq_data *d)
 {
-	get_cpu_var(irq_disable_mask) |= (1UL << irq);
-	mask_irqs(1UL << irq);
+	get_cpu_var(irq_disable_mask) |= (1UL << d->irq);
+	mask_irqs(1UL << d->irq);
 	put_cpu_var(irq_disable_mask);
 }
-EXPORT_SYMBOL(disable_percpu_irq);
 
 /* Mask an interrupt. */
 static void tile_irq_chip_mask(struct irq_data *d)
@@ -209,6 +207,8 @@ static void tile_irq_chip_eoi(struct irq_data *d)
 
 static struct irq_chip tile_irq_chip = {
 	.name = "tile_irq_chip",
+	.irq_enable = tile_irq_chip_enable,
+	.irq_disable = tile_irq_chip_disable,
 	.irq_ack = tile_irq_chip_ack,
 	.irq_eoi = tile_irq_chip_eoi,
 	.irq_mask = tile_irq_chip_mask,
diff --git a/drivers/net/ethernet/tile/tilepro.c b/drivers/net/ethernet/tile/tilepro.c
index 1c0f9fa..1187a11 100644
--- a/drivers/net/ethernet/tile/tilepro.c
+++ b/drivers/net/ethernet/tile/tilepro.c
@@ -926,7 +926,7 @@ static int tile_net_poll(struct napi_struct *napi, int budget)
 		goto done;
 
 	/* Re-enable the ingress interrupt. */
-	enable_percpu_irq(priv->intr_id);
+	enable_percpu_irq(priv->intr_id, 0);
 
 	/* HACK: Avoid the "rotting packet" problem (see above). */
 	if (qup->__packet_receive_read !=
@@ -1296,7 +1296,7 @@ static void tile_net_open_enable(void *dev_ptr)
 	info->napi_enabled = true;
 
 	/* Enable the ingress interrupt. */
-	enable_percpu_irq(priv->intr_id);
+	enable_percpu_irq(priv->intr_id, 0);
 }
 
 
-- 
1.6.5.2

