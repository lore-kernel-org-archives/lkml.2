Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0CWXFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:05:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51962 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0CWXF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:05:29 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arm: convert arm to arch_gettimeoffset()
Date: Tue, 23 Mar 2010 16:05:21 -0700
Message-Id: <1269385522-2525-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Against linux-next next-20100323)

Convert arm to use GENERIC_TIME via the arch_getoffset() infrastructure,
reducing the amount of arch specific code we need to maintain.

The arm architecture is the last arch that need to be converted.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/Kconfig                 |   26 ++++++++++++++
 arch/arm/include/asm/mach/time.h |    2 +-
 arch/arm/kernel/time.c           |   70 +++----------------------------------
 arch/arm/mach-at91/Kconfig       |    1 +
 4 files changed, 34 insertions(+), 65 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4bb7730..d77f934 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -42,6 +42,11 @@ config GENERIC_GPIO
 
 config GENERIC_TIME
 	bool
+	default y
+
+config ARCH_USES_GETTIMEOFFSET
+	bool
+	default n
 
 config GENERIC_CLOCKEVENTS
 	bool
@@ -231,6 +236,7 @@ config ARCH_AAEC2000
 	select CPU_ARM920T
 	select ARM_AMBA
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Agilent AAEC-2000
 
@@ -295,6 +301,7 @@ config ARCH_AT91
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
@@ -314,6 +321,7 @@ config ARCH_BCMRING
 config ARCH_CLPS711X
 	bool "Cirrus Logic CLPS711x/EP721x-based"
 	select CPU_ARM720T
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Cirrus Logic 711x/721x based boards.
 
@@ -322,6 +330,7 @@ config ARCH_GEMINI
 	select CPU_FA526
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for the Cortina Systems Gemini family SoCs
 
@@ -330,6 +339,7 @@ config ARCH_EBSA110
 	select CPU_SA110
 	select ISA
 	select NO_IOPORT
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This is an evaluation board for the StrongARM processor available
 	  from Digital. It has limited hardware on-board, including an
@@ -346,6 +356,7 @@ config ARCH_EP93XX
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_HOLES_MEMORYMODEL
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -353,6 +364,7 @@ config ARCH_FOOTBRIDGE
 	bool "FootBridge"
 	select CPU_SA110
 	select FOOTBRIDGE
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
@@ -393,6 +405,7 @@ config ARCH_H720X
 	bool "Hynix HMS720x-based"
 	select CPU_ARM720T
 	select ISA_DMA_API
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Hynix HMS720x
 
@@ -404,6 +417,7 @@ config ARCH_IOP13XX
 	select PCI
 	select ARCH_SUPPORTS_MSI
 	select VMSPLIT_1G
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP13XX (XScale) family of processors.
 
@@ -415,6 +429,7 @@ config ARCH_IOP32X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's 80219 and IOP32X (XScale) family of
 	  processors.
@@ -427,6 +442,7 @@ config ARCH_IOP33X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
@@ -435,6 +451,7 @@ config ARCH_IXP23XX
 	depends on MMU
 	select CPU_XSC3
  	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP23xx (XScale) family of processors.
 
@@ -443,6 +460,7 @@ config ARCH_IXP2000
 	depends on MMU
 	select CPU_XSCALE
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP2400/2800 (XScale) family of processors.
 
@@ -461,6 +479,7 @@ config ARCH_L7200
 	bool "LinkUp-L7200"
 	select CPU_ARM720T
 	select FIQ
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here if you intend to run this kernel on a LinkUp Systems
 	  L7200 Software Development Board which uses an ARM720T processor.
@@ -551,6 +570,7 @@ config ARCH_KS8695
 	select CPU_ARM922T
 	select GENERIC_GPIO
         select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Micrel/Kendin KS8695 "Centaur" (ARM922T) based
 	  System-on-Chip devices.
@@ -600,6 +620,7 @@ config ARCH_PNX4008
 	select CPU_ARM926T
 	select HAVE_CLK
 	select COMMON_CLKDEV
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for Philips PNX4008 mobile platform.
 
@@ -645,6 +666,7 @@ config ARCH_RPC
 	select ISA_DMA_API
 	select NO_IOPORT
 	select ARCH_SPARSEMEM_ENABLE
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -671,6 +693,7 @@ config ARCH_S3C2410
 	select GENERIC_GPIO
 	select ARCH_HAS_CPUFREQ
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -684,6 +707,7 @@ config ARCH_S3C64XX
 	select ARM_VIC
 	select HAVE_CLK
 	select NO_IOPORT
+	select ARCH_USES_GETTIMEOFFSET
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select SAMSUNG_CLKSRC
@@ -740,6 +764,7 @@ config ARCH_SHARK
 	select ISA_DMA
 	select ZONE_DMA
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for the StrongARM based Digital DNARD machine, also known
 	  as "Shark" (<http://www.shark-linux.de/shark.html>).
@@ -749,6 +774,7 @@ config ARCH_LH7A40X
 	select CPU_ARM922T
 	select ARCH_DISCONTIGMEM_ENABLE if !LH7A40X_CONTIGMEM
 	select ARCH_SPARSEMEM_ENABLE if !LH7A40X_CONTIGMEM
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here for systems based on one of the Sharp LH7A40X
 	  System on a Chip processors.  These CPUs include an ARM922T
diff --git a/arch/arm/include/asm/mach/time.h b/arch/arm/include/asm/mach/time.h
index 8bffc3f..35d408f 100644
--- a/arch/arm/include/asm/mach/time.h
+++ b/arch/arm/include/asm/mach/time.h
@@ -38,7 +38,7 @@ struct sys_timer {
 	void			(*init)(void);
 	void			(*suspend)(void);
 	void			(*resume)(void);
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	unsigned long		(*offset)(void);
 #endif
 };
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 2875380..38c261f 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -72,12 +72,15 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-#ifndef CONFIG_GENERIC_TIME
-static unsigned long dummy_gettimeoffset(void)
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+u32 arch_gettimeoffset(void)
 {
+	if (system_timer->offset != NULL)
+		return system_timer->offset() * 1000;
+
 	return 0;
 }
-#endif
+#endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 #ifdef CONFIG_LEDS_TIMER
 static inline void do_leds(void)
@@ -93,63 +96,6 @@ static inline void do_leds(void)
 #define	do_leds()
 #endif
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = system_timer->offset();
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / 1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	/* usec may have gone up a lot: be safe */
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * done, and then undo it!
-	 */
-	nsec -= system_timer->offset() * NSEC_PER_USEC;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
 
 #ifndef CONFIG_GENERIC_CLOCKEVENTS
 /*
@@ -214,10 +160,6 @@ device_initcall(timer_init_sysfs);
 
 void __init time_init(void)
 {
-#ifndef CONFIG_GENERIC_TIME
-	if (system_timer->offset == NULL)
-		system_timer->offset = dummy_gettimeoffset;
-#endif
 	system_timer->init();
 }
 
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 2db43a5..8a5e8e9 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -97,6 +97,7 @@ config ARCH_AT572D940HF
 
 config ARCH_AT91X40
 	bool "AT91x40"
+	select ARCH_USES_GETTIMEOFFSET
 
 endchoice
 
-- 
1.6.0.4

