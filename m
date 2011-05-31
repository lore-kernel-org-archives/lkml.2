Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab1EaIbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:31:19 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:52333 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084Ab1EaIbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:31:16 -0400
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
Date: Tue, 31 May 2011 10:31:01 +0200
Message-ID: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DB8500 PRCMU Timer driver as a clocksource
and as sched_clock.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/clocksource/Kconfig               |   15 +++++
 drivers/clocksource/Makefile              |    1 +
 drivers/clocksource/clksrc-db8500-prcmu.c |   89 +++++++++++++++++++++++++++++
 include/linux/clksrc-db8500-prcmu.h       |   17 ++++++
 4 files changed, 122 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clocksource/clksrc-db8500-prcmu.c
 create mode 100644 include/linux/clksrc-db8500-prcmu.h

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 96c9219..d7ee415 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -3,3 +3,18 @@ config CLKSRC_I8253
 
 config CLKSRC_MMIO
 	bool
+
+config CLKSRC_DB8500_PRCMU
+	bool "Clocksource PRCMU Timer"
+	depends on MFD_DB8500_PRCMU
+	default y
+	help
+	  Use the always on PRCMU Timer as clocksource
+
+config CLKSRC_DB8500_PRCMU_SCHED_CLOCK
+	bool "Clocksource PRCMU Timer sched_clock"
+	depends on (CLKSRC_DB8500_PRCMU && !NOMADIK_MTU_SCHED_CLOCK)
+	select HAVE_SCHED_CLOCK
+	default y
+	help
+	  Use the always on PRCMU Timer as sched_clock
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index b995942..f2308ba 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
 obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
 obj-$(CONFIG_CLKSRC_I8253)	+= i8253.o
 obj-$(CONFIG_CLKSRC_MMIO)	+= mmio.o
+obj-$(CONFIG_CLKSRC_DB8500_PRCMU)	+= clksrc-db8500-prcmu.o
diff --git a/drivers/clocksource/clksrc-db8500-prcmu.c b/drivers/clocksource/clksrc-db8500-prcmu.c
new file mode 100644
index 0000000..07a4d1a
--- /dev/null
+++ b/drivers/clocksource/clksrc-db8500-prcmu.c
@@ -0,0 +1,89 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Mattias Wallin <mattias.wallin@stericsson.com> for ST-Ericsson
+ * sched_clock implementation is based on:
+ * plat-nomadik/timer.c Linus Walleij <linus.walleij@stericsson.com>
+ *
+ * Clocksource DB8500 PRCMU Timer
+ * The PRCMU in the DB8500 chip has 5 timers which
+ * are available in an always-on power domain.
+ * Timer 4 is dedicated to our always-on clock source.
+ */
+#include <linux/clockchips.h>
+#include <linux/clksrc-db8500-prcmu.h>
+#include <asm/sched_clock.h>
+#include <mach/setup.h>
+#include <mach/db8500-regs.h>
+#include <mach/hardware.h>
+
+#define RATE_32K		(32768)
+
+#define TIMER_MODE_CONTINOUS	(0x1)
+#define TIMER_DOWNCOUNT_VAL	(0xffffffff)
+
+/* PRCMU Timer 4 */
+#define PRCMU_TIMER_4_REF       (prcmu_base + 0x450)
+#define PRCMU_TIMER_4_DOWNCOUNT (prcmu_base + 0x454)
+#define PRCMU_TIMER_4_MODE      (prcmu_base + 0x458)
+
+static __iomem void *prcmu_base;
+
+#define SCHED_CLOCK_MIN_WRAP (131072) /* 2^32 / 32768 */
+
+static cycle_t clksrc_db8500_prcmu_read(struct clocksource *cs)
+{
+	u32 count, count2;
+
+	do {
+		count = readl(PRCMU_TIMER_4_DOWNCOUNT);
+		count2 = readl(PRCMU_TIMER_4_DOWNCOUNT);
+	} while (count2 != count);
+
+	/* Negate because the timer is a decrementing counter */
+	return ~count;
+}
+
+static struct clocksource clocksource_db8500_prcmu = {
+	.name		= "clksrc-db8500-prcmu-timer4",
+	.rating		= 300,
+	.read		= clksrc_db8500_prcmu_read,
+	.shift		= 10,
+	.mask		= CLOCKSOURCE_MASK(32),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+#ifdef CONFIG_CS_DB8500_PRCMU_SCHED_CLOCK
+static DEFINE_CLOCK_DATA(cd);
+
+static void notrace clksrc_db8500_prcmu_update_sched_clock(void)
+{
+	u32 cyc = clksrc_db8500_prcmu_read(&clocksource_db8500_prcmu);
+	update_sched_clock(&cd, cyc, (u32)~0);
+}
+#endif
+
+void __init clksrc_db8500_prcmu_init(void)
+{
+	prcmu_base = __io_address(U8500_PRCMU_BASE);
+
+	/*
+	 * The A9 sub system expects the timer to be configured as
+	 * a continous looping timer.
+	 * The PRCMU should configure it but if it for some reason
+	 * don't we do it here.
+	 */
+	if (readl(PRCMU_TIMER_4_MODE) != TIMER_MODE_CONTINOUS) {
+		writel(TIMER_MODE_CONTINOUS, PRCMU_TIMER_4_MODE);
+		writel(TIMER_DOWNCOUNT_VAL, PRCMU_TIMER_4_REF);
+	}
+#ifdef CONFIG_CS_DB8500_PRCMU_SCHED_CLOCK
+	init_sched_clock(&cd, clksrc_db8500_prcmu_update_sched_clock,
+		32, RATE_32K);
+#endif
+	clocksource_calc_mult_shift(&clocksource_db8500_prcmu,
+		RATE_32K, SCHED_CLOCK_MIN_WRAP);
+	clocksource_register(&clocksource_db8500_prcmu);
+}
+
diff --git a/include/linux/clksrc-db8500-prcmu.h b/include/linux/clksrc-db8500-prcmu.h
new file mode 100644
index 0000000..42b8587
--- /dev/null
+++ b/include/linux/clksrc-db8500-prcmu.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Mattias Wallin <mattias.wallin@stericsson.com>
+ *
+ */
+#ifndef __CLKSRC_DB8500_PRCMU_H
+#define __CLKSRC_DB8500_PRCMU_H
+
+#ifdef CONFIG_CLKSRC_DB8500_PRCMU
+void __init clksrc_db8500_prcmu_init(void);
+#else
+void __init clksrc_db8500_prcmu_init(void) {}
+#endif
+
+#endif
-- 
1.7.4.3

