Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab0FBTEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:04:53 -0400
Received: from smtp-out-182.synserver.de ([212.40.180.182]:1068 "HELO
	smtp-out-182.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757964Ab0FBTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:04:47 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 28645
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [RFC][PATCH 06/26] MIPS: JZ4740: Add power-management and system reset support
Date: Wed,  2 Jun 2010 21:02:57 +0200
Message-Id: <1275505397-16758-7-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1275505397-16758-1-git-send-email-lars@metafoo.de>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for suspend/resume and poweroff/reboot on a JZ4740 SoC.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/pm.c    |   56 +++++++++++++++++++++++++++++++
 arch/mips/jz4740/reset.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/mips/jz4740/reset.h |    7 ++++
 3 files changed, 144 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/jz4740/pm.c
 create mode 100644 arch/mips/jz4740/reset.c
 create mode 100644 arch/mips/jz4740/reset.h

diff --git a/arch/mips/jz4740/pm.c b/arch/mips/jz4740/pm.c
new file mode 100644
index 0000000..3b78ced
--- /dev/null
+++ b/arch/mips/jz4740/pm.c
@@ -0,0 +1,56 @@
+/*
+ *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
+ *		JZ4740 SoC power management support
+ *
+ *  This program is free software; you can redistribute	 it and/or modify it
+ *  under  the terms of	 the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the	License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/pm.h>
+#include <linux/delay.h>
+#include <linux/suspend.h>
+
+#include <asm/mach-jz4740/clock.h>
+
+#include "clock.h"
+#include "irq.h"
+
+static int jz4740_pm_enter(suspend_state_t state)
+{
+	jz4740_intc_suspend();
+	jz4740_clock_suspend();
+
+	jz4740_clock_set_wait_mode(JZ4740_WAIT_MODE_SLEEP);
+
+	__asm__(".set\tmips3\n\t"
+		"wait\n\t"
+		".set\tmips0");
+
+	jz4740_clock_set_wait_mode(JZ4740_WAIT_MODE_IDLE);
+
+	jz4740_clock_resume();
+	jz4740_intc_resume();
+
+	return 0;
+}
+
+static struct platform_suspend_ops jz4740_pm_ops = {
+	.valid		= suspend_valid_only_mem,
+	.enter		= jz4740_pm_enter,
+};
+
+static int __init jz4740_pm_init(void)
+{
+	suspend_set_ops(&jz4740_pm_ops);
+	return 0;
+
+}
+late_initcall(jz4740_pm_init);
diff --git a/arch/mips/jz4740/reset.c b/arch/mips/jz4740/reset.c
new file mode 100644
index 0000000..448a7da
--- /dev/null
+++ b/arch/mips/jz4740/reset.c
@@ -0,0 +1,81 @@
+/*
+ *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
+ *
+ *  This program is free software; you can redistribute	 it and/or modify it
+ *  under  the terms of	 the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the	License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/pm.h>
+
+#include <linux/delay.h>
+
+#include <asm/reboot.h>
+
+#include <asm/mach-jz4740/base.h>
+#include <asm/mach-jz4740/timer.h>
+
+static void jz4740_halt(void)
+{
+	while (1) {
+		__asm__(".set push;\n"
+			".set mips3;\n"
+			"wait;\n"
+			".set pop;\n"
+		);
+	}
+}
+
+#define JZ_REG_WDT_DATA 0x00
+#define JZ_REG_WDT_COUNTER_ENABLE 0x04
+#define JZ_REG_WDT_COUNTER 0x08
+#define JZ_REG_WDT_CTRL 0x0c
+
+static void jz4740_restart(char *command)
+{
+	void __iomem *wdt_base = ioremap(CPHYSADDR(JZ4740_WDT_BASE_ADDR), 0x0f);
+
+	jz4740_timer_enable_watchdog();
+
+	writeb(0, wdt_base + JZ_REG_WDT_COUNTER_ENABLE);
+
+	writew(0, wdt_base + JZ_REG_WDT_COUNTER);
+	writew(0, wdt_base + JZ_REG_WDT_DATA);
+	writew(BIT(2), wdt_base + JZ_REG_WDT_CTRL);
+
+	writeb(1, wdt_base + JZ_REG_WDT_COUNTER_ENABLE);
+	jz4740_halt();
+}
+
+#define JZ_REG_RTC_CTRL		0x00
+#define JZ_REG_RTC_HIBERNATE	0x20
+
+#define JZ_RTC_CTRL_WRDY	BIT(7)
+
+static void jz4740_power_off(void)
+{
+	void __iomem *rtc_base = ioremap(CPHYSADDR(JZ4740_RTC_BASE_ADDR), 0x24);
+	uint32_t ctrl;
+
+	do {
+		ctrl = readl(rtc_base + JZ_REG_RTC_CTRL);
+	} while (!(ctrl & JZ_RTC_CTRL_WRDY));
+
+	writel(1, rtc_base + JZ_REG_RTC_HIBERNATE);
+	jz4740_halt();
+}
+
+void jz4740_reset_init(void)
+{
+	_machine_restart = jz4740_restart;
+	_machine_halt = jz4740_halt;
+	pm_power_off = jz4740_power_off;
+}
diff --git a/arch/mips/jz4740/reset.h b/arch/mips/jz4740/reset.h
new file mode 100644
index 0000000..c57a829
--- /dev/null
+++ b/arch/mips/jz4740/reset.h
@@ -0,0 +1,7 @@
+#ifndef __MIPS_JZ4740_RESET_H__
+#define __MIPS_JZ4740_RESET_H__
+
+extern void jz4740_reset_init(void);
+
+#endif
+
-- 
1.5.6.5

