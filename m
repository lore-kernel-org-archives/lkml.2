Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946196Ab2JYQMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:12:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57502 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759943Ab2JYQMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:12 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 07/11] ARM: davinci - restructure header files for common clock migration
Date: Thu, 25 Oct 2012 12:11:53 -0400
Message-ID: <1351181518-11882-8-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pll.h is added to migrate some of the PLL controller defines for sleep.S.
psc.h is modified to keep only PSC modules definitions needed by sleep.S
after migrating to common clock. The definitions under
ifdef CONFIG_COMMON_CLK will be removed in a subsequent patch.
davinci_watchdog_reset prototype is moved to time.h as clock.h is
being obsoleted. sleep.S and pm.c is modified to include the new header
file replacements.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 arch/arm/mach-davinci/devices.c           |    2 ++
 arch/arm/mach-davinci/include/mach/pll.h  |   46 +++++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/psc.h  |    4 +++
 arch/arm/mach-davinci/include/mach/time.h |    4 ++-
 arch/arm/mach-davinci/pm.c                |    4 +++
 arch/arm/mach-davinci/sleep.S             |    4 +++
 6 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-davinci/include/mach/pll.h

diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index d2f96662..96ee175 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -24,7 +24,9 @@
 #include <mach/time.h>
 
 #include "davinci.h"
+#ifndef CONFIG_COMMON_CLK
 #include "clock.h"
+#endif
 
 #define DAVINCI_I2C_BASE	     0x01C21000
 #define DAVINCI_ATA_BASE	     0x01C66000
diff --git a/arch/arm/mach-davinci/include/mach/pll.h b/arch/arm/mach-davinci/include/mach/pll.h
new file mode 100644
index 0000000..fa51bc4
--- /dev/null
+++ b/arch/arm/mach-davinci/include/mach/pll.h
@@ -0,0 +1,46 @@
+/*
+ * TI DaVinci PLL definitions
+ *
+ * Copyright (C) 2006-2012 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __ASM_ARCH_PLL_H
+#define __ASM_ARCH_PLL_H
+
+/* PLL/Reset register offsets */
+#define PLLCTL          0x100
+#define PLLCTL_PLLEN    BIT(0)
+#define PLLCTL_PLLPWRDN	BIT(1)
+#define PLLCTL_PLLRST	BIT(3)
+#define PLLCTL_PLLDIS	BIT(4)
+#define PLLCTL_PLLENSRC	BIT(5)
+#define PLLCTL_CLKMODE  BIT(8)
+#define PLLDIV_EN       BIT(15)
+#define PLLDIV1         0x118
+/*
+ * OMAP-L138 system reference guide recommends a wait for 4 OSCIN/CLKIN
+ * cycles to ensure that the PLLC has switched to bypass mode. Delay of 1us
+ * ensures we are good for all > 4MHz OSCIN/CLKIN inputs. Typically the input
+ * is ~25MHz. Units are micro seconds.
+ */
+#define PLL_BYPASS_TIME		1
+/* From OMAP-L138 datasheet table 6-4. Units are micro seconds */
+#define PLL_RESET_TIME		1
+/*
+ * From OMAP-L138 datasheet table 6-4; assuming prediv = 1, sqrt(pllm) = 4
+ * Units are micro seconds.
+ */
+#define PLL_LOCK_TIME		20
+#define PLLSTAT_GOSTAT		BIT(0)
+#define PLLCMD_GOSET		BIT(0)
+
+#endif /* __ASM_ARCH_PLL_H */
diff --git a/arch/arm/mach-davinci/include/mach/psc.h b/arch/arm/mach-davinci/include/mach/psc.h
index 405318e..eb464d3 100644
--- a/arch/arm/mach-davinci/include/mach/psc.h
+++ b/arch/arm/mach-davinci/include/mach/psc.h
@@ -27,6 +27,7 @@
 #ifndef __ASM_ARCH_PSC_H
 #define __ASM_ARCH_PSC_H
 
+#ifndef CONFIG_COMMON_CLK
 #define	DAVINCI_PWR_SLEEP_CNTRL_BASE	0x01C41000
 
 /* Power and Sleep Controller (PSC) Domains */
@@ -227,6 +228,7 @@
 #define TNETV107X_LPSC_DDR2_EMIF1_VRST		42
 #define TNETV107X_LPSC_DDR2_EMIF2_VCTL_RST	43
 #define TNETV107X_LPSC_MAX			44
+#endif
 
 /* PSC register offsets */
 #define EPCPR		0x070
@@ -251,9 +253,11 @@
 
 #ifndef __ASSEMBLER__
 
+#ifndef CONFIG_COMMON_CLK
 extern int davinci_psc_is_clk_active(unsigned int ctlr, unsigned int id);
 extern void davinci_psc_config(unsigned int domain, unsigned int ctlr,
 		unsigned int id, bool enable, u32 flags);
+#endif
 
 #endif
 
diff --git a/arch/arm/mach-davinci/include/mach/time.h b/arch/arm/mach-davinci/include/mach/time.h
index 1c971d8..7faa530 100644
--- a/arch/arm/mach-davinci/include/mach/time.h
+++ b/arch/arm/mach-davinci/include/mach/time.h
@@ -31,5 +31,7 @@ enum {
 #define ID_TO_TIMER(id)		(IS_TIMER1(id) != 0)
 
 extern struct davinci_timer_instance davinci_timer_instance[];
-
+#ifdef CONFIG_COMMON_CLK
+extern void davinci_watchdog_reset(struct platform_device *);
+#endif
 #endif /* __ARCH_ARM_MACH_DAVINCI_TIME_H */
diff --git a/arch/arm/mach-davinci/pm.c b/arch/arm/mach-davinci/pm.c
index eb8360b..8802fdc 100644
--- a/arch/arm/mach-davinci/pm.c
+++ b/arch/arm/mach-davinci/pm.c
@@ -23,7 +23,11 @@
 #include <mach/sram.h>
 #include <mach/pm.h>
 
+#ifndef CONFIG_COMMON_CLK
 #include "clock.h"
+#else
+#include <mach/pll.h>
+#endif
 
 #define DEEPSLEEP_SLEEPCOUNT_MASK	0xFFFF
 
diff --git a/arch/arm/mach-davinci/sleep.S b/arch/arm/mach-davinci/sleep.S
index d4e9316..a3bd60d 100644
--- a/arch/arm/mach-davinci/sleep.S
+++ b/arch/arm/mach-davinci/sleep.S
@@ -24,7 +24,11 @@
 #include <mach/psc.h>
 #include <mach/ddr2.h>
 
+#ifndef CONFIG_COMMON_CLK
 #include "clock.h"
+#else
+#include <mach/pll.h>
+#endif
 
 /* Arbitrary, hardware currently does not update PHYRDY correctly */
 #define PHYRDY_CYCLES		0x1000
-- 
1.7.9.5

