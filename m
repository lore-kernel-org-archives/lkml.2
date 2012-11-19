Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2KSSba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:31:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59823 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2KSSb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:31:27 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V3 04/11] ARM: set arch_gettimeoffset directly
Date: Mon, 19 Nov 2012 11:31:00 -0700
Message-Id: <1353349867-28494-5-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
References: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

remove ARM's struct sys_timer .offset function pointer, and instead
directly set the arch_gettimeoffset function pointer when the timer
driver is initialized. This requires multiplying all function results
by 1000, since the removed arm_gettimeoffset() did this. Also,
s/unsigned long/u32/ just to make the function prototypes exactly
match that of arch_gettimeoffset.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Fix comment in ep93xx_gettimeoffset.
---
 arch/arm/include/asm/mach/time.h  |    3 ---
 arch/arm/kernel/time.c            |   14 --------------
 arch/arm/mach-at91/at91x40_time.c |    8 +++++---
 arch/arm/mach-ebsa110/core.c      |    7 ++++---
 arch/arm/mach-ep93xx/core.c       |   29 ++++++++++++++++++-----------
 arch/arm/mach-h720x/common.c      |    6 +++---
 arch/arm/mach-h720x/common.h      |    2 +-
 arch/arm/mach-h720x/cpu-h7201.c   |    3 ++-
 arch/arm/mach-h720x/cpu-h7202.c   |    3 ++-
 arch/arm/mach-rpc/time.c          |    6 +++---
 arch/arm/plat-samsung/time.c      |    7 ++++---
 11 files changed, 42 insertions(+), 46 deletions(-)

diff --git a/arch/arm/include/asm/mach/time.h b/arch/arm/include/asm/mach/time.h
index 6ca945f..cac8d9c 100644
--- a/arch/arm/include/asm/mach/time.h
+++ b/arch/arm/include/asm/mach/time.h
@@ -35,9 +35,6 @@ struct sys_timer {
 	void			(*init)(void);
 	void			(*suspend)(void);
 	void			(*resume)(void);
-#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	unsigned long		(*offset)(void);
-#endif
 };
 
 extern void timer_tick(void);
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index b0190b4..ea36bfa 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -69,16 +69,6 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-static u32 arm_gettimeoffset(void)
-{
-	if (system_timer->offset != NULL)
-		return system_timer->offset() * 1000;
-
-	return 0;
-}
-#endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
-
 #ifndef CONFIG_GENERIC_CLOCKEVENTS
 /*
  * Kernel system timer support.
@@ -164,10 +154,6 @@ device_initcall(timer_init_syscore_ops);
 
 void __init time_init(void)
 {
-#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	arch_gettimeoffset = arm_gettimeoffset;
-#endif
-
 	system_timer = machine_desc->timer;
 	system_timer->init();
 	sched_clock_postinit();
diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
index 0e57e44..fb3c701 100644
--- a/arch/arm/mach-at91/at91x40_time.c
+++ b/arch/arm/mach-at91/at91x40_time.c
@@ -42,9 +42,10 @@
 #define	AT91_TC_CLK1BASE	0x40
 #define	AT91_TC_CLK2BASE	0x80
 
-static unsigned long at91x40_gettimeoffset(void)
+static u32 at91x40_gettimeoffset(void)
 {
-	return (at91_tc_read(AT91_TC_CLK1BASE + AT91_TC_CV) * 1000000 / (AT91X40_MASTER_CLOCK / 128));
+	return (at91_tc_read(AT91_TC_CLK1BASE + AT91_TC_CV) * 1000000 /
+		(AT91X40_MASTER_CLOCK / 128)) * 1000;
 }
 
 static irqreturn_t at91x40_timer_interrupt(int irq, void *dev_id)
@@ -64,6 +65,8 @@ void __init at91x40_timer_init(void)
 {
 	unsigned int v;
 
+	arch_gettimeoffset = at91x40_gettimeoffset;
+
 	at91_tc_write(AT91_TC_BCR, 0);
 	v = at91_tc_read(AT91_TC_BMR);
 	v = (v & ~AT91_TC_TC1XC1S) | AT91_TC_TC1XC1S_NONE;
@@ -82,6 +85,5 @@ void __init at91x40_timer_init(void)
 
 struct sys_timer at91x40_timer = {
 	.init	= at91x40_timer_init,
-	.offset	= at91x40_gettimeoffset,
 };
 
diff --git a/arch/arm/mach-ebsa110/core.c b/arch/arm/mach-ebsa110/core.c
index f0fe6b5..d96dd94 100644
--- a/arch/arm/mach-ebsa110/core.c
+++ b/arch/arm/mach-ebsa110/core.c
@@ -158,7 +158,7 @@ static void __init ebsa110_init_early(void)
  * interrupt, then the PIT counter will roll over (ie, be negative).
  * This actually works out to be convenient.
  */
-static unsigned long ebsa110_gettimeoffset(void)
+static u32 ebsa110_gettimeoffset(void)
 {
 	unsigned long offset, count;
 
@@ -181,7 +181,7 @@ static unsigned long ebsa110_gettimeoffset(void)
 	 */
 	offset = offset * (1000000 / HZ) / COUNT;
 
-	return offset;
+	return offset * 1000;
 }
 
 static irqreturn_t
@@ -215,6 +215,8 @@ static struct irqaction ebsa110_timer_irq = {
  */
 static void __init ebsa110_timer_init(void)
 {
+	arch_gettimeoffset = ebsa110_gettimeoffset;
+
 	/*
 	 * Timer 1, mode 2, LSB/MSB
 	 */
@@ -227,7 +229,6 @@ static void __init ebsa110_timer_init(void)
 
 static struct sys_timer ebsa110_timer = {
 	.init		= ebsa110_timer_init,
-	.offset		= ebsa110_gettimeoffset,
 };
 
 static struct plat_serial8250_port serial_platform_data[] = {
diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index e85bf17..6f48b87 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -140,11 +140,29 @@ static struct irqaction ep93xx_timer_irq = {
 	.handler	= ep93xx_timer_interrupt,
 };
 
+static u32 ep93xx_gettimeoffset(void)
+{
+	int offset;
+
+	offset = __raw_readl(EP93XX_TIMER4_VALUE_LOW) - last_jiffy_time;
+
+	/*
+	 * Timer 4 is based on a 983.04 kHz reference clock,
+	 * so dividing by 983040 gives the fraction of a second,
+	 * so dividing by 0.983040 converts to uS.
+	 * Refactor the calculation to avoid overflow.
+	 * Finally, multiply by 1000 to give nS.
+	 */
+	return (offset + (53 * offset / 3072)) * 1000;
+}
+
 static void __init ep93xx_timer_init(void)
 {
 	u32 tmode = EP93XX_TIMER123_CONTROL_MODE |
 		    EP93XX_TIMER123_CONTROL_CLKSEL;
 
+	arch_gettimeoffset = ep93xx_gettimeoffset;
+
 	/* Enable periodic HZ timer.  */
 	__raw_writel(tmode, EP93XX_TIMER1_CONTROL);
 	__raw_writel(TIMER1_RELOAD, EP93XX_TIMER1_LOAD);
@@ -158,19 +176,8 @@ static void __init ep93xx_timer_init(void)
 	setup_irq(IRQ_EP93XX_TIMER1, &ep93xx_timer_irq);
 }
 
-static unsigned long ep93xx_gettimeoffset(void)
-{
-	int offset;
-
-	offset = __raw_readl(EP93XX_TIMER4_VALUE_LOW) - last_jiffy_time;
-
-	/* Calculate (1000000 / 983040) * offset.  */
-	return offset + (53 * offset / 3072);
-}
-
 struct sys_timer ep93xx_timer = {
 	.init		= ep93xx_timer_init,
-	.offset		= ep93xx_gettimeoffset,
 };
 
 
diff --git a/arch/arm/mach-h720x/common.c b/arch/arm/mach-h720x/common.c
index aa1331e..17ef91f 100644
--- a/arch/arm/mach-h720x/common.c
+++ b/arch/arm/mach-h720x/common.c
@@ -42,12 +42,12 @@ void __init arch_dma_init(dma_t *dma)
 }
 
 /*
- * Return usecs since last timer reload
+ * Return nsecs since last timer reload
  * (timercount * (usecs perjiffie)) / (ticks per jiffie)
  */
-unsigned long h720x_gettimeoffset(void)
+u32 h720x_gettimeoffset(void)
 {
-	return (CPU_REG (TIMER_VIRT, TM0_COUNT) * tick_usec) / LATCH;
+	return ((CPU_REG(TIMER_VIRT, TM0_COUNT) * tick_usec) / LATCH) * 1000;
 }
 
 /*
diff --git a/arch/arm/mach-h720x/common.h b/arch/arm/mach-h720x/common.h
index 2489537..79cfb97 100644
--- a/arch/arm/mach-h720x/common.h
+++ b/arch/arm/mach-h720x/common.h
@@ -13,7 +13,7 @@
  *
  */
 
-extern unsigned long h720x_gettimeoffset(void);
+extern u32 h720x_gettimeoffset(void);
 extern void __init h720x_init_irq(void);
 extern void __init h720x_map_io(void);
 extern void h720x_restart(char, const char *);
diff --git a/arch/arm/mach-h720x/cpu-h7201.c b/arch/arm/mach-h720x/cpu-h7201.c
index 24df2a3..ba349cf 100644
--- a/arch/arm/mach-h720x/cpu-h7201.c
+++ b/arch/arm/mach-h720x/cpu-h7201.c
@@ -46,6 +46,8 @@ static struct irqaction h7201_timer_irq = {
  */
 void __init h7201_init_time(void)
 {
+	arch_gettimeoffset = h720x_gettimeoffset;
+
 	CPU_REG (TIMER_VIRT, TM0_PERIOD) = LATCH;
 	CPU_REG (TIMER_VIRT, TM0_CTRL) = TM_RESET;
 	CPU_REG (TIMER_VIRT, TM0_CTRL) = TM_REPEAT | TM_START;
@@ -56,5 +58,4 @@ void __init h7201_init_time(void)
 
 struct sys_timer h7201_timer = {
 	.init		= h7201_init_time,
-	.offset		= h720x_gettimeoffset,
 };
diff --git a/arch/arm/mach-h720x/cpu-h7202.c b/arch/arm/mach-h720x/cpu-h7202.c
index c37d570..fb9ca76 100644
--- a/arch/arm/mach-h720x/cpu-h7202.c
+++ b/arch/arm/mach-h720x/cpu-h7202.c
@@ -180,6 +180,8 @@ static struct irqaction h7202_timer_irq = {
  */
 void __init h7202_init_time(void)
 {
+	arch_gettimeoffset = h720x_gettimeoffset;
+
 	CPU_REG (TIMER_VIRT, TM0_PERIOD) = LATCH;
 	CPU_REG (TIMER_VIRT, TM0_CTRL) = TM_RESET;
 	CPU_REG (TIMER_VIRT, TM0_CTRL) = TM_REPEAT | TM_START;
@@ -190,7 +192,6 @@ void __init h7202_init_time(void)
 
 struct sys_timer h7202_timer = {
 	.init		= h7202_init_time,
-	.offset		= h720x_gettimeoffset,
 };
 
 void __init h7202_init_irq (void)
diff --git a/arch/arm/mach-rpc/time.c b/arch/arm/mach-rpc/time.c
index 581fca9..6ddccb0 100644
--- a/arch/arm/mach-rpc/time.c
+++ b/arch/arm/mach-rpc/time.c
@@ -24,7 +24,7 @@
 
 #include <asm/mach/time.h>
 
-unsigned long ioc_timer_gettimeoffset(void)
+static u32 ioc_timer_gettimeoffset(void)
 {
 	unsigned int count1, count2, status;
 	long offset;
@@ -56,7 +56,7 @@ unsigned long ioc_timer_gettimeoffset(void)
 	}
 
 	offset = (LATCH - offset) * (tick_nsec / 1000);
-	return (offset + LATCH/2) / LATCH;
+	return ((offset + LATCH/2) / LATCH) * 1000;
 }
 
 void __init ioctime_init(void)
@@ -84,12 +84,12 @@ static struct irqaction ioc_timer_irq = {
  */
 static void __init ioc_timer_init(void)
 {
+	arch_gettimeoffset = ioc_timer_gettimeoffset;
 	ioctime_init();
 	setup_irq(IRQ_TIMER0, &ioc_timer_irq);
 }
 
 struct sys_timer ioc_timer = {
 	.init		= ioc_timer_init,
-	.offset		= ioc_timer_gettimeoffset,
 };
 
diff --git a/arch/arm/plat-samsung/time.c b/arch/arm/plat-samsung/time.c
index 60552e2..67206df 100644
--- a/arch/arm/plat-samsung/time.c
+++ b/arch/arm/plat-samsung/time.c
@@ -95,7 +95,7 @@ static inline unsigned long timer_ticks_to_usec(unsigned long ticks)
  * IRQs are disabled before entering here from do_gettimeofday()
  */
 
-static unsigned long s3c2410_gettimeoffset (void)
+static u32 s3c2410_gettimeoffset(void)
 {
 	unsigned long tdone;
 	unsigned long tval;
@@ -120,7 +120,7 @@ static unsigned long s3c2410_gettimeoffset (void)
 			tdone += timer_startval;
 	}
 
-	return timer_ticks_to_usec(tdone);
+	return timer_ticks_to_usec(tdone) * 1000;
 }
 
 
@@ -273,6 +273,8 @@ static void __init s3c2410_timer_resources(void)
 
 static void __init s3c2410_timer_init(void)
 {
+	arch_gettimeoffset = s3c2410_gettimeoffset;
+
 	s3c2410_timer_resources();
 	s3c2410_timer_setup();
 	setup_irq(IRQ_TIMER4, &s3c2410_timer_irq);
@@ -280,6 +282,5 @@ static void __init s3c2410_timer_init(void)
 
 struct sys_timer s3c24xx_timer = {
 	.init		= s3c2410_timer_init,
-	.offset		= s3c2410_gettimeoffset,
 	.resume		= s3c2410_timer_setup
 };
-- 
1.7.10.4

