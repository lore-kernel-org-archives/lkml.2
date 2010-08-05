Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab0HEWWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:22:38 -0400
Received: from www.tglx.de ([62.245.132.106]:54015 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab0HEWWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:22:36 -0400
Date: Fri, 6 Aug 2010 00:21:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] generic irq updated for 2.6.36
Message-ID: <alpine.LFD.2.00.1008060019470.3225@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

Just cleanups, no functional changes.

Thanks,

	tglx

------------------>
Ian Campbell (4):
      irq: Add new IRQ flag IRQF_NO_SUSPEND
      ixp4xx-beeper: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupt
      powerpc: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupts
      xen: Do not suspend IPI IRQs.


 arch/powerpc/platforms/powermac/low_i2c.c |    5 +++--
 drivers/input/misc/ixp4xx-beeper.c        |    3 ++-
 drivers/macintosh/via-pmu.c               |    9 +++++----
 drivers/xen/events.c                      |    1 +
 include/linux/interrupt.h                 |    7 ++++++-
 kernel/irq/manage.c                       |    2 +-
 6 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index 06a137c..480567e 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -542,11 +542,12 @@ static struct pmac_i2c_host_kw *__init kw_i2c_host_init(struct device_node *np)
 	/* Make sure IRQ is disabled */
 	kw_write_reg(reg_ier, 0);
 
-	/* Request chip interrupt. We set IRQF_TIMER because we don't
+	/* Request chip interrupt. We set IRQF_NO_SUSPEND because we don't
 	 * want that interrupt disabled between the 2 passes of driver
 	 * suspend or we'll have issues running the pfuncs
 	 */
-	if (request_irq(host->irq, kw_i2c_irq, IRQF_TIMER, "keywest i2c", host))
+	if (request_irq(host->irq, kw_i2c_irq, IRQF_NO_SUSPEND,
+			"keywest i2c", host))
 		host->irq = NO_IRQ;
 
 	printk(KERN_INFO "KeyWest i2c @0x%08x irq %d %s\n",
diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index 9946d73..9dfd6e5 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -115,7 +115,8 @@ static int __devinit ixp4xx_spkr_probe(struct platform_device *dev)
 	input_dev->event = ixp4xx_spkr_event;
 
 	err = request_irq(IRQ_IXP4XX_TIMER2, &ixp4xx_spkr_interrupt,
-			  IRQF_DISABLED | IRQF_TIMER, "ixp4xx-beeper", (void *) dev->id);
+			  IRQF_DISABLED | IRQF_NO_SUSPEND, "ixp4xx-beeper",
+			  (void *) dev->id);
 	if (err)
 		goto err_free_device;
 
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 3d4fc0f..35bc273 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -400,11 +400,12 @@ static int __init via_pmu_start(void)
 		printk(KERN_ERR "via-pmu: can't map interrupt\n");
 		return -ENODEV;
 	}
-	/* We set IRQF_TIMER because we don't want the interrupt to be disabled
-	 * between the 2 passes of driver suspend, we control our own disabling
-	 * for that one
+	/* We set IRQF_NO_SUSPEND because we don't want the interrupt
+	 * to be disabled between the 2 passes of driver suspend, we
+	 * control our own disabling for that one
 	 */
-	if (request_irq(irq, via_pmu_interrupt, IRQF_TIMER, "VIA-PMU", (void *)0)) {
+	if (request_irq(irq, via_pmu_interrupt, IRQF_NO_SUSPEND,
+			"VIA-PMU", (void *)0)) {
 		printk(KERN_ERR "via-pmu: can't request irq %d\n", irq);
 		return -ENODEV;
 	}
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index db8f506..28f133a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -536,6 +536,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 	if (irq < 0)
 		return irq;
 
+	irqflags |= IRQF_NO_SUSPEND;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c233113..a0384a4 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -53,16 +53,21 @@
  * IRQF_ONESHOT - Interrupt is not reenabled after the hardirq handler finished.
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
+ * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
+ *
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
-#define IRQF_TIMER		0x00000200
+#define __IRQF_TIMER		0x00000200
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
+#define IRQF_NO_SUSPEND		0x00004000
+
+#define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
 /*
  * Bits used by threaded handlers:
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e149748..c3003e9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -216,7 +216,7 @@ static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_TIMER))
+		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
 			return;
 		desc->status |= IRQ_SUSPENDED;
 	}
