Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1IWMso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:48:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56108 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1IWMsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:48:40 -0400
thread-index: Acx57woeMDfjltDNQzeaMrMI8YocEQ==
Content-Transfer-Encoding: 8BIT
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
From: Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv9 09/18] omap3: pm: use prcm chain handler
Date: Fri, 23 Sep 2011 15:46:17 +0300
Message-ID: <1316781986-30642-10-git-send-email-t-kristo@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM interrupt handling is now done through the PRCM chain handler. The
interrupt handling logic is also split in two parts, to server IO and
WKUP events separately. This allows us to handle IO chain events in a
clean way.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/pm34xx.c |  104 +++++++++++++++---------------------------
 1 files changed, 37 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 7255d9b..712fd15 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -29,6 +29,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/console.h>
+#include <linux/mfd/omap-prm.h>
 #include <trace/events/power.h>
 
 #include <asm/suspend.h>
@@ -198,7 +199,7 @@ static void omap3_save_secure_ram_context(void)
  * that any peripheral wake-up events occurring while attempting to
  * clear the PM_WKST_x are detected and cleared.
  */
-static int prcm_clear_mod_irqs(s16 module, u8 regs)
+static int prcm_clear_mod_irqs(s16 module, u8 regs, u32 ignore_bits)
 {
 	u32 wkst, fclk, iclk, clken;
 	u16 wkst_off = (regs == 3) ? OMAP3430ES2_PM_WKST3 : PM_WKST1;
@@ -210,6 +211,7 @@ static int prcm_clear_mod_irqs(s16 module, u8 regs)
 
 	wkst = omap2_prm_read_mod_reg(module, wkst_off);
 	wkst &= omap2_prm_read_mod_reg(module, grpsel_off);
+	wkst &= ~ignore_bits;
 	if (wkst) {
 		iclk = omap2_cm_read_mod_reg(module, iclk_off);
 		fclk = omap2_cm_read_mod_reg(module, fclk_off);
@@ -225,6 +227,7 @@ static int prcm_clear_mod_irqs(s16 module, u8 regs)
 			omap2_cm_set_mod_reg_bits(clken, module, fclk_off);
 			omap2_prm_write_mod_reg(wkst, module, wkst_off);
 			wkst = omap2_prm_read_mod_reg(module, wkst_off);
+			wkst &= ~ignore_bits;
 			c++;
 		}
 		omap2_cm_write_mod_reg(iclk, module, iclk_off);
@@ -234,76 +237,35 @@ static int prcm_clear_mod_irqs(s16 module, u8 regs)
 	return c;
 }
 
-static int _prcm_int_handle_wakeup(void)
+static irqreturn_t _prcm_int_handle_io(int irq, void *unused)
 {
 	int c;
 
-	c = prcm_clear_mod_irqs(WKUP_MOD, 1);
-	c += prcm_clear_mod_irqs(CORE_MOD, 1);
-	c += prcm_clear_mod_irqs(OMAP3430_PER_MOD, 1);
-	if (omap_rev() > OMAP3430_REV_ES1_0) {
-		c += prcm_clear_mod_irqs(CORE_MOD, 3);
-		c += prcm_clear_mod_irqs(OMAP3430ES2_USBHOST_MOD, 1);
-	}
+	c = prcm_clear_mod_irqs(WKUP_MOD, 1,
+		~(OMAP3430_ST_IO_MASK | OMAP3430_ST_IO_CHAIN_MASK));
 
-	return c;
+	return c ? IRQ_HANDLED : IRQ_NONE;
 }
 
-/*
- * PRCM Interrupt Handler
- *
- * The PRM_IRQSTATUS_MPU register indicates if there are any pending
- * interrupts from the PRCM for the MPU. These bits must be cleared in
- * order to clear the PRCM interrupt. The PRCM interrupt handler is
- * implemented to simply clear the PRM_IRQSTATUS_MPU in order to clear
- * the PRCM interrupt. Please note that bit 0 of the PRM_IRQSTATUS_MPU
- * register indicates that a wake-up event is pending for the MPU and
- * this bit can only be cleared if the all the wake-up events latched
- * in the various PM_WKST_x registers have been cleared. The interrupt
- * handler is implemented using a do-while loop so that if a wake-up
- * event occurred during the processing of the prcm interrupt handler
- * (setting a bit in the corresponding PM_WKST_x register and thus
- * preventing us from clearing bit 0 of the PRM_IRQSTATUS_MPU register)
- * this would be handled.
- */
-static irqreturn_t prcm_interrupt_handler (int irq, void *dev_id)
+static irqreturn_t _prcm_int_handle_wakeup(int irq, void *unused)
 {
-	u32 irqenable_mpu, irqstatus_mpu;
-	int c = 0;
-
-	irqenable_mpu = omap2_prm_read_mod_reg(OCP_MOD,
-					 OMAP3_PRM_IRQENABLE_MPU_OFFSET);
-	irqstatus_mpu = omap2_prm_read_mod_reg(OCP_MOD,
-					 OMAP3_PRM_IRQSTATUS_MPU_OFFSET);
-	irqstatus_mpu &= irqenable_mpu;
-
-	do {
-		if (irqstatus_mpu & (OMAP3430_WKUP_ST_MASK |
-				     OMAP3430_IO_ST_MASK)) {
-			c = _prcm_int_handle_wakeup();
-
-			/*
-			 * Is the MPU PRCM interrupt handler racing with the
-			 * IVA2 PRCM interrupt handler ?
-			 */
-			WARN(c == 0, "prcm: WARNING: PRCM indicated MPU wakeup "
-			     "but no wakeup sources are marked\n");
-		} else {
-			/* XXX we need to expand our PRCM interrupt handler */
-			WARN(1, "prcm: WARNING: PRCM interrupt received, but "
-			     "no code to handle it (%08x)\n", irqstatus_mpu);
-		}
-
-		omap2_prm_write_mod_reg(irqstatus_mpu, OCP_MOD,
-					OMAP3_PRM_IRQSTATUS_MPU_OFFSET);
-
-		irqstatus_mpu = omap2_prm_read_mod_reg(OCP_MOD,
-					OMAP3_PRM_IRQSTATUS_MPU_OFFSET);
-		irqstatus_mpu &= irqenable_mpu;
+	int c;
 
-	} while (irqstatus_mpu);
+	/*
+	 * Clear all except ST_IO and ST_IO_CHAIN for wkup module,
+	 * these are handled in a separate handler to avoid acking
+	 * IO events before parsing in mux code
+	 */
+	c = prcm_clear_mod_irqs(WKUP_MOD, 1,
+		OMAP3430_ST_IO_MASK | OMAP3430_ST_IO_CHAIN_MASK);
+	c += prcm_clear_mod_irqs(CORE_MOD, 1, 0);
+	c += prcm_clear_mod_irqs(OMAP3430_PER_MOD, 1, 0);
+	if (omap_rev() > OMAP3430_REV_ES1_0) {
+		c += prcm_clear_mod_irqs(CORE_MOD, 3, 0);
+		c += prcm_clear_mod_irqs(OMAP3430ES2_USBHOST_MOD, 1, 0);
+	}
 
-	return IRQ_HANDLED;
+	return c ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static void omap34xx_save_context(u32 *save)
@@ -876,12 +838,20 @@ static int __init omap3_pm_init(void)
 	 * supervised mode for powerdomains */
 	prcm_setup_regs();
 
-	ret = request_irq(INT_34XX_PRCM_MPU_IRQ,
-			  (irq_handler_t)prcm_interrupt_handler,
-			  IRQF_DISABLED, "prcm", NULL);
+	ret = request_irq(omap_prcm_event_to_irq("wkup"),
+		_prcm_int_handle_wakeup, 0, "pm_wkup", NULL);
+
+	if (ret) {
+		printk(KERN_ERR "Failed to request pm_wkup irq\n");
+		goto err1;
+	}
+
+	/* IO interrupt is shared with mux code */
+	ret = request_irq(omap_prcm_event_to_irq("io"),
+		_prcm_int_handle_io, IRQF_SHARED, "pm_io", omap3_pm_init);
+
 	if (ret) {
-		printk(KERN_ERR "request_irq failed to register for 0x%x\n",
-		       INT_34XX_PRCM_MPU_IRQ);
+		printk(KERN_ERR "Failed to request pm_io irq\n");
 		goto err1;
 	}
 
-- 
1.7.4.1


Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

