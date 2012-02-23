Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2BWO03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:26:29 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:17063 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab2BWO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:26:26 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de
Subject: [PATCH v3 04/21] ARM: at91: make ST (System Timer) soc independent
Date: Thu, 23 Feb 2012 15:25:48 +0100
Message-Id: <5e9cf5e18d4bed39467cc020dcd3e66e8a8cd231.1330006537.git.nicolas.ferre@atmel.com>
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
Reviewed-by: Ryan Mallon <rmallon@gmail.com>
---
 arch/arm/mach-at91/at91rm9200.c              |    5 ++-
 arch/arm/mach-at91/at91rm9200_time.c         |   37 ++++++++++++++++----------
 arch/arm/mach-at91/generic.h                 |    1 +
 arch/arm/mach-at91/include/mach/at91_st.h    |   32 +++++++++++++++-------
 arch/arm/mach-at91/include/mach/at91rm9200.h |    2 +-
 drivers/watchdog/at91rm9200_wdt.c            |    8 +++---
 6 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index dd6e2de..ebe597b 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -303,8 +303,8 @@ static void at91rm9200_restart(char mode, const char *cmd)
 	/*
 	 * Perform a hardware reset with the use of the Watchdog timer.
 	 */
-	at91_sys_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
-	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
+	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
+	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
 }
 
 /* --------------------------------------------------------------------
@@ -319,6 +319,7 @@ static void __init at91rm9200_map_io(void)
 
 static void __init at91rm9200_ioremap_registers(void)
 {
+	at91rm9200_ioremap_st(AT91RM9200_BASE_ST);
 }
 
 static void __init at91rm9200_initialize(void)
diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index a028cdf..0c1980c 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -43,9 +43,9 @@ static inline unsigned long read_CRTR(void)
 {
 	unsigned long x1, x2;
 
-	x1 = at91_sys_read(AT91_ST_CRTR);
+	x1 = at91_st_read(AT91_ST_CRTR);
 	do {
-		x2 = at91_sys_read(AT91_ST_CRTR);
+		x2 = at91_st_read(AT91_ST_CRTR);
 		if (x1 == x2)
 			break;
 		x1 = x2;
@@ -58,7 +58,7 @@ static inline unsigned long read_CRTR(void)
  */
 static irqreturn_t at91rm9200_timer_interrupt(int irq, void *dev_id)
 {
-	u32	sr = at91_sys_read(AT91_ST_SR) & irqmask;
+	u32	sr = at91_st_read(AT91_ST_SR) & irqmask;
 
 	/*
 	 * irqs should be disabled here, but as the irq is shared they are only
@@ -110,22 +110,22 @@ static void
 clkevt32k_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 {
 	/* Disable and flush pending timer interrupts */
-	at91_sys_write(AT91_ST_IDR, AT91_ST_PITS | AT91_ST_ALMS);
-	(void) at91_sys_read(AT91_ST_SR);
+	at91_st_write(AT91_ST_IDR, AT91_ST_PITS | AT91_ST_ALMS);
+	(void) at91_st_read(AT91_ST_SR);
 
 	last_crtr = read_CRTR();
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* PIT for periodic irqs; fixed rate of 1/HZ */
 		irqmask = AT91_ST_PITS;
-		at91_sys_write(AT91_ST_PIMR, RM9200_TIMER_LATCH);
+		at91_st_write(AT91_ST_PIMR, RM9200_TIMER_LATCH);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* ALM for oneshot irqs, set by next_event()
 		 * before 32 seconds have passed
 		 */
 		irqmask = AT91_ST_ALMS;
-		at91_sys_write(AT91_ST_RTAR, last_crtr);
+		at91_st_write(AT91_ST_RTAR, last_crtr);
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
@@ -133,7 +133,7 @@ clkevt32k_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 		irqmask = 0;
 		break;
 	}
-	at91_sys_write(AT91_ST_IER, irqmask);
+	at91_st_write(AT91_ST_IER, irqmask);
 }
 
 static int
@@ -156,12 +156,12 @@ clkevt32k_next_event(unsigned long delta, struct clock_event_device *dev)
 	alm = read_CRTR();
 
 	/* Cancel any pending alarm; flush any pending IRQ */
-	at91_sys_write(AT91_ST_RTAR, alm);
-	(void) at91_sys_read(AT91_ST_SR);
+	at91_st_write(AT91_ST_RTAR, alm);
+	(void) at91_st_read(AT91_ST_SR);
 
 	/* Schedule alarm by writing RTAR. */
 	alm += delta;
-	at91_sys_write(AT91_ST_RTAR, alm);
+	at91_st_write(AT91_ST_RTAR, alm);
 
 	return status;
 }
@@ -175,15 +175,24 @@ static struct clock_event_device clkevt = {
 	.set_mode	= clkevt32k_mode,
 };
 
+void __iomem *at91_st_base;
+
+void __init at91rm9200_ioremap_st(u32 addr)
+{
+	at91_st_base = ioremap(addr, 256);
+	if (!at91_st_base)
+		panic("Impossible to ioremap ST\n");
+}
+
 /*
  * ST (system timer) module supports both clockevents and clocksource.
  */
 void __init at91rm9200_timer_init(void)
 {
 	/* Disable all timer interrupts, and clear any pending ones */
-	at91_sys_write(AT91_ST_IDR,
+	at91_st_write(AT91_ST_IDR,
 		AT91_ST_PITS | AT91_ST_WDOVF | AT91_ST_RTTINC | AT91_ST_ALMS);
-	(void) at91_sys_read(AT91_ST_SR);
+	(void) at91_st_read(AT91_ST_SR);
 
 	/* Make IRQs happen for the system timer */
 	setup_irq(AT91_ID_SYS, &at91rm9200_timer_irq);
@@ -192,7 +201,7 @@ void __init at91rm9200_timer_init(void)
 	 * directly for the clocksource and all clockevents, after adjusting
 	 * its prescaler from the 1 Hz default.
 	 */
-	at91_sys_write(AT91_ST_RTMR, 1);
+	at91_st_write(AT91_ST_RTMR, 1);
 
 	/* Setup timer clockevent, with minimum of two ticks (important!!) */
 	clkevt.mult = div_sc(AT91_SLOW_CLOCK, NSEC_PER_SEC, clkevt.shift);
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index dc74ec0..aec7fd0 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -28,6 +28,7 @@ extern void __init at91_aic_init(unsigned int priority[]);
 
  /* Timer */
 struct sys_timer;
+extern void at91rm9200_ioremap_st(u32 addr);
 extern struct sys_timer at91rm9200_timer;
 extern void at91sam926x_ioremap_pit(u32 addr);
 extern struct sys_timer at91sam926x_timer;
diff --git a/arch/arm/mach-at91/include/mach/at91_st.h b/arch/arm/mach-at91/include/mach/at91_st.h
index 8847173..969aac2 100644
--- a/arch/arm/mach-at91/include/mach/at91_st.h
+++ b/arch/arm/mach-at91/include/mach/at91_st.h
@@ -16,34 +16,46 @@
 #ifndef AT91_ST_H
 #define AT91_ST_H
 
-#define	AT91_ST_CR		(AT91_ST + 0x00)	/* Control Register */
+#ifndef __ASSEMBLY__
+extern void __iomem *at91_st_base;
+
+#define at91_st_read(field) \
+	__raw_readl(at91_st_base + field)
+
+#define at91_st_write(field, value) \
+	__raw_writel(value, at91_st_base + field);
+#else
+.extern at91_st_base
+#endif
+
+#define	AT91_ST_CR		0x00			/* Control Register */
 #define 	AT91_ST_WDRST		(1 << 0)		/* Watchdog Timer Restart */
 
-#define	AT91_ST_PIMR		(AT91_ST + 0x04)	/* Period Interval Mode Register */
+#define	AT91_ST_PIMR		0x04			/* Period Interval Mode Register */
 #define		AT91_ST_PIV		(0xffff <<  0)		/* Period Interval Value */
 
-#define	AT91_ST_WDMR		(AT91_ST + 0x08)	/* Watchdog Mode Register */
+#define	AT91_ST_WDMR		0x08			/* Watchdog Mode Register */
 #define		AT91_ST_WDV		(0xffff <<  0)		/* Watchdog Counter Value */
 #define		AT91_ST_RSTEN		(1	<< 16)		/* Reset Enable */
 #define		AT91_ST_EXTEN		(1	<< 17)		/* External Signal Assertion Enable */
 
-#define	AT91_ST_RTMR		(AT91_ST + 0x0c)	/* Real-time Mode Register */
+#define	AT91_ST_RTMR		0x0c			/* Real-time Mode Register */
 #define		AT91_ST_RTPRES		(0xffff <<  0)		/* Real-time Prescalar Value */
 
-#define	AT91_ST_SR		(AT91_ST + 0x10)	/* Status Register */
+#define	AT91_ST_SR		0x10			/* Status Register */
 #define		AT91_ST_PITS		(1 << 0)		/* Period Interval Timer Status */
 #define		AT91_ST_WDOVF		(1 << 1) 		/* Watchdog Overflow */
 #define		AT91_ST_RTTINC		(1 << 2) 		/* Real-time Timer Increment */
 #define		AT91_ST_ALMS		(1 << 3) 		/* Alarm Status */
 
-#define	AT91_ST_IER		(AT91_ST + 0x14)	/* Interrupt Enable Register */
-#define	AT91_ST_IDR		(AT91_ST + 0x18)	/* Interrupt Disable Register */
-#define	AT91_ST_IMR		(AT91_ST + 0x1c)	/* Interrupt Mask Register */
+#define	AT91_ST_IER		0x14			/* Interrupt Enable Register */
+#define	AT91_ST_IDR		0x18			/* Interrupt Disable Register */
+#define	AT91_ST_IMR		0x1c			/* Interrupt Mask Register */
 
-#define	AT91_ST_RTAR		(AT91_ST + 0x20)	/* Real-time Alarm Register */
+#define	AT91_ST_RTAR		0x20			/* Real-time Alarm Register */
 #define		AT91_ST_ALMV		(0xfffff << 0)		/* Alarm Value */
 
-#define	AT91_ST_CRTR		(AT91_ST + 0x24)	/* Current Real-time Register */
+#define	AT91_ST_CRTR		0x24			/* Current Real-time Register */
 #define		AT91_ST_CRTV		(0xfffff << 0)		/* Current Real-Time Value */
 
 #endif
diff --git a/arch/arm/mach-at91/include/mach/at91rm9200.h b/arch/arm/mach-at91/include/mach/at91rm9200.h
index fbde306..0d0b9b3 100644
--- a/arch/arm/mach-at91/include/mach/at91rm9200.h
+++ b/arch/arm/mach-at91/include/mach/at91rm9200.h
@@ -80,7 +80,6 @@
  * System Peripherals (offset from AT91_BASE_SYS)
  */
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)	/* Power Management Controller */
-#define AT91_ST		(0xfffffd00 - AT91_BASE_SYS)	/* System Timer */
 #define AT91_MC		(0xffffff00 - AT91_BASE_SYS)	/* Memory Controllers */
 
 #define AT91RM9200_BASE_DBGU	AT91_BASE_DBGU0	/* Debug Unit */
@@ -88,6 +87,7 @@
 #define AT91RM9200_BASE_PIOB	0xfffff600	/* PIO Controller B */
 #define AT91RM9200_BASE_PIOC	0xfffff800	/* PIO Controller C */
 #define AT91RM9200_BASE_PIOD	0xfffffa00	/* PIO Controller D */
+#define AT91RM9200_BASE_ST	0xfffffd00	/* System Timer */
 #define AT91RM9200_BASE_RTC	0xfffffe00	/* Real-Time Clock */
 
 #define AT91_USART0	AT91RM9200_BASE_US0
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index b3046dc..7ceefd2 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -51,7 +51,7 @@ static unsigned long at91wdt_busy;
  */
 static inline void at91_wdt_stop(void)
 {
-	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN);
+	at91_st_write(AT91_ST_WDMR, AT91_ST_EXTEN);
 }
 
 /*
@@ -59,9 +59,9 @@ static inline void at91_wdt_stop(void)
  */
 static inline void at91_wdt_start(void)
 {
-	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN |
+	at91_st_write(AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN |
 				(((65536 * wdt_time) >> 8) & AT91_ST_WDV));
-	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
+	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
 }
 
 /*
@@ -69,7 +69,7 @@ static inline void at91_wdt_start(void)
  */
 static inline void at91_wdt_reload(void)
 {
-	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
+	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
 }
 
 /* ......................................................................... */
-- 
1.7.9

