Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2BWO0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:26:23 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:19493 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab2BWO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:26:22 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de
Subject: [PATCH v3 02/21] ARM: at91/at91x40: remove use of at91_sys_read/write
Date: Thu, 23 Feb 2012 15:25:46 +0100
Message-Id: <fac36a5ab9fe5a8bd977d2305eeccad48389cbb5.1330006537.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91x40.c              |    2 +-
 arch/arm/mach-at91/at91x40_time.c         |   28 +++++++++++++++++-----------
 arch/arm/mach-at91/include/mach/at91x40.h |   18 +++++++++---------
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
index 0154b7f..5400a1d 100644
--- a/arch/arm/mach-at91/at91x40.c
+++ b/arch/arm/mach-at91/at91x40.c
@@ -44,7 +44,7 @@ static void at91x40_idle(void)
 	 * Disable the processor clock.  The processor will be automatically
 	 * re-enabled by an interrupt or by a reset.
 	 */
-	at91_sys_write(AT91_PS_CR, AT91_PS_CR_CPU);
+	__raw_writel(AT91_PS_CR_CPU, AT91_PS_CR);
 	cpu_do_idle();
 }
 
diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
index dfff289..6ca680a 100644
--- a/arch/arm/mach-at91/at91x40_time.c
+++ b/arch/arm/mach-at91/at91x40_time.c
@@ -28,6 +28,12 @@
 #include <asm/mach/time.h>
 #include <mach/at91_tc.h>
 
+#define at91_tc_read(field) \
+	__raw_readl(AT91_TC + field)
+
+#define at91_tc_write(field, value) \
+	__raw_writel(value, AT91_TC + field);
+
 /*
  *	3 counter/timer units present.
  */
@@ -37,12 +43,12 @@
 
 static unsigned long at91x40_gettimeoffset(void)
 {
-	return (at91_sys_read(AT91_TC + AT91_TC_CLK1BASE + AT91_TC_CV) * 1000000 / (AT91X40_MASTER_CLOCK / 128));
+	return (at91_tc_read(AT91_TC_CLK1BASE + AT91_TC_CV) * 1000000 / (AT91X40_MASTER_CLOCK / 128));
 }
 
 static irqreturn_t at91x40_timer_interrupt(int irq, void *dev_id)
 {
-	at91_sys_read(AT91_TC + AT91_TC_CLK1BASE + AT91_TC_SR);
+	at91_tc_read(AT91_TC_CLK1BASE + AT91_TC_SR);
 	timer_tick();
 	return IRQ_HANDLED;
 }
@@ -57,20 +63,20 @@ void __init at91x40_timer_init(void)
 {
 	unsigned int v;
 
-	at91_sys_write(AT91_TC + AT91_TC_BCR, 0);
-	v = at91_sys_read(AT91_TC + AT91_TC_BMR);
+	at91_tc_write(AT91_TC_BCR, 0);
+	v = at91_tc_read(AT91_TC_BMR);
 	v = (v & ~AT91_TC_TC1XC1S) | AT91_TC_TC1XC1S_NONE;
-	at91_sys_write(AT91_TC + AT91_TC_BMR, v);
+	at91_tc_write(AT91_TC_BMR, v);
 
-	at91_sys_write(AT91_TC + AT91_TC_CLK1BASE + AT91_TC_CCR, AT91_TC_CLKDIS);
-	at91_sys_write(AT91_TC + AT91_TC_CLK1BASE + AT91_TC_CMR, (AT91_TC_TIMER_CLOCK4 | AT91_TC_CPCTRG));
-	at91_sys_write(AT91_TC + AT91_TC_CLK1BASE + AT91_TC_IDR, 0xffffffff);
-	at91_sys_write(AT91_TC + AT91_TC_CLK1BASE + AT91_TC_RC, (AT91X40_MASTER_CLOCK / 128) / HZ - 1);
-	at91_sys_write(AT91_TC + AT91_TC_CLK1BASE + AT91_TC_IER, (1<<4));
+	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_CCR, AT91_TC_CLKDIS);
+	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_CMR, (AT91_TC_TIMER_CLOCK4 | AT91_TC_CPCTRG));
+	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_IDR, 0xffffffff);
+	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_RC, (AT91X40_MASTER_CLOCK / 128) / HZ - 1);
+	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_IER, (1<<4));
 
 	setup_irq(AT91X40_ID_TC1, &at91x40_timer_irq);
 
-	at91_sys_write(AT91_TC + AT91_TC_CLK1BASE + AT91_TC_CCR, (AT91_TC_SWTRG | AT91_TC_CLKEN));
+	at91_tc_write(AT91_TC_CLK1BASE + AT91_TC_CCR, (AT91_TC_SWTRG | AT91_TC_CLKEN));
 }
 
 struct sys_timer at91x40_timer = {
diff --git a/arch/arm/mach-at91/include/mach/at91x40.h b/arch/arm/mach-at91/include/mach/at91x40.h
index a57829f..9068021 100644
--- a/arch/arm/mach-at91/include/mach/at91x40.h
+++ b/arch/arm/mach-at91/include/mach/at91x40.h
@@ -28,18 +28,18 @@
 #define AT91X40_ID_IRQ2		18	/* External IRQ 2 */
 
 /*
- * System Peripherals (offset from AT91_BASE_SYS)
+ * System Peripherals
  */
 #define AT91_BASE_SYS	0xffc00000
 
-#define AT91_EBI	(0xffe00000 - AT91_BASE_SYS)	/* External Bus Interface */
-#define AT91_SF		(0xfff00000 - AT91_BASE_SYS)	/* Special Function */
-#define AT91_USART1	(0xfffcc000 - AT91_BASE_SYS)	/* USART 1 */
-#define AT91_USART0	(0xfffd0000 - AT91_BASE_SYS)	/* USART 0 */
-#define AT91_TC		(0xfffe0000 - AT91_BASE_SYS)	/* Timer Counter */
-#define AT91_PIOA	(0xffff0000 - AT91_BASE_SYS)	/* PIO Controller A */
-#define AT91_PS		(0xffff4000 - AT91_BASE_SYS)	/* Power Save */
-#define AT91_WD		(0xffff8000 - AT91_BASE_SYS)	/* Watchdog Timer */
+#define AT91_EBI	0xffe00000	/* External Bus Interface */
+#define AT91_SF		0xfff00000	/* Special Function */
+#define AT91_USART1	0xfffcc000	/* USART 1 */
+#define AT91_USART0	0xfffd0000	/* USART 0 */
+#define AT91_TC		0xfffe0000	/* Timer Counter */
+#define AT91_PIOA	0xffff0000	/* PIO Controller A */
+#define AT91_PS		0xffff4000	/* Power Save */
+#define AT91_WD		0xffff8000	/* Watchdog Timer */
 
 /*
  * The AT91x40 series doesn't have a debug unit like the other AT91 parts.
-- 
1.7.9

