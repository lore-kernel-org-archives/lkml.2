Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2IJMFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:05:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab2IJMFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:05:31 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antonynpavlov@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH v2 2/3] MIPS: JZ4740: Export timer API
Date: Mon, 10 Sep 2012 14:05:18 +0200
Message-Id: <1347278719-15276-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:HQ89UM4vFbH2Mb7WTNYLn94RU111ke8VAlGJeLwYy1A
 HDLbkna6zgd8geFxobggXvqFidt+54Hzcg19hdGhRirLfNh+AI
 rMvPE+f+CaTKJBb/zck+rWumuTsnE9H3v4eAh9UhiRPVROpd8L
 F/MdeCecsjROl1YaF/vpHpsIDkdP3nCGf7lgSIDz2/I9MHy9WV
 Sxb3f+utrNuXlFGsSeVGQsqh74/Xjipc6jUYq9lHnBr+wG0YvA
 vcyUf5S+/cwzJPY8z+LCiICeQEYP/vOo8FvTLvLO1tFGLrIx87
 7bzPOwV+DPDclPu/R5pySW1RxF4R4w39lvZb3ma4DnMFIhQzaA
 yu2wq+he09XcKY7kfKKMli2SPQ8lwG20FhcqZitAnTu8MziX/5
 hranEOFcmK8Iuj4ij5kRVJNjzxHmxnxE6xxQeJKn560M9LnimB
 JjYwI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a prerequisite for allowing the PWM driver to be converted to
the PWM framework.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- keep timer API as static inline, move it to public header instead

 arch/mips/include/asm/mach-jz4740/timer.h | 113 +++++++++++++++++++++++++
 arch/mips/jz4740/time.c                   |   2 +-
 arch/mips/jz4740/timer.c                  |   4 +-
 arch/mips/jz4740/timer.h                  | 136 ------------------------------
 4 files changed, 116 insertions(+), 139 deletions(-)
 delete mode 100644 arch/mips/jz4740/timer.h

diff --git a/arch/mips/include/asm/mach-jz4740/timer.h b/arch/mips/include/asm/mach-jz4740/timer.h
index 9baa03c..a7759fb 100644
--- a/arch/mips/include/asm/mach-jz4740/timer.h
+++ b/arch/mips/include/asm/mach-jz4740/timer.h
@@ -16,7 +16,120 @@
 #ifndef __ASM_MACH_JZ4740_TIMER
 #define __ASM_MACH_JZ4740_TIMER
 
+#define JZ_REG_TIMER_STOP		0x0C
+#define JZ_REG_TIMER_STOP_SET		0x1C
+#define JZ_REG_TIMER_STOP_CLEAR		0x2C
+#define JZ_REG_TIMER_ENABLE		0x00
+#define JZ_REG_TIMER_ENABLE_SET		0x04
+#define JZ_REG_TIMER_ENABLE_CLEAR	0x08
+#define JZ_REG_TIMER_FLAG		0x10
+#define JZ_REG_TIMER_FLAG_SET		0x14
+#define JZ_REG_TIMER_FLAG_CLEAR		0x18
+#define JZ_REG_TIMER_MASK		0x20
+#define JZ_REG_TIMER_MASK_SET		0x24
+#define JZ_REG_TIMER_MASK_CLEAR		0x28
+
+#define JZ_REG_TIMER_DFR(x) (((x) * 0x10) + 0x30)
+#define JZ_REG_TIMER_DHR(x) (((x) * 0x10) + 0x34)
+#define JZ_REG_TIMER_CNT(x) (((x) * 0x10) + 0x38)
+#define JZ_REG_TIMER_CTRL(x) (((x) * 0x10) + 0x3C)
+
+#define JZ_TIMER_IRQ_HALF(x) BIT((x) + 0x10)
+#define JZ_TIMER_IRQ_FULL(x) BIT(x)
+
+#define JZ_TIMER_CTRL_PWM_ABBRUPT_SHUTDOWN	BIT(9)
+#define JZ_TIMER_CTRL_PWM_ACTIVE_LOW		BIT(8)
+#define JZ_TIMER_CTRL_PWM_ENABLE		BIT(7)
+#define JZ_TIMER_CTRL_PRESCALE_MASK		0x1c
+#define JZ_TIMER_CTRL_PRESCALE_OFFSET		0x3
+#define JZ_TIMER_CTRL_PRESCALE_1		(0 << 3)
+#define JZ_TIMER_CTRL_PRESCALE_4		(1 << 3)
+#define JZ_TIMER_CTRL_PRESCALE_16		(2 << 3)
+#define JZ_TIMER_CTRL_PRESCALE_64		(3 << 3)
+#define JZ_TIMER_CTRL_PRESCALE_256		(4 << 3)
+#define JZ_TIMER_CTRL_PRESCALE_1024		(5 << 3)
+
+#define JZ_TIMER_CTRL_PRESCALER(x) ((x) << JZ_TIMER_CTRL_PRESCALE_OFFSET)
+
+#define JZ_TIMER_CTRL_SRC_EXT		BIT(2)
+#define JZ_TIMER_CTRL_SRC_RTC		BIT(1)
+#define JZ_TIMER_CTRL_SRC_PCLK		BIT(0)
+
+extern void __iomem *jz4740_timer_base;
+void __init jz4740_timer_init(void);
+
 void jz4740_timer_enable_watchdog(void);
 void jz4740_timer_disable_watchdog(void);
 
+static inline void jz4740_timer_stop(unsigned int timer)
+{
+	writel(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_STOP_SET);
+}
+
+static inline void jz4740_timer_start(unsigned int timer)
+{
+	writel(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_STOP_CLEAR);
+}
+
+static inline bool jz4740_timer_is_enabled(unsigned int timer)
+{
+	return readb(jz4740_timer_base + JZ_REG_TIMER_ENABLE) & BIT(timer);
+}
+
+static inline void jz4740_timer_enable(unsigned int timer)
+{
+	writeb(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_ENABLE_SET);
+}
+
+static inline void jz4740_timer_disable(unsigned int timer)
+{
+	writeb(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_ENABLE_CLEAR);
+}
+
+static inline void jz4740_timer_set_period(unsigned int timer, uint16_t period)
+{
+	writew(period, jz4740_timer_base + JZ_REG_TIMER_DFR(timer));
+}
+
+static inline void jz4740_timer_set_duty(unsigned int timer, uint16_t duty)
+{
+	writew(duty, jz4740_timer_base + JZ_REG_TIMER_DHR(timer));
+}
+
+static inline void jz4740_timer_set_count(unsigned int timer, uint16_t count)
+{
+	writew(count, jz4740_timer_base + JZ_REG_TIMER_CNT(timer));
+}
+
+static inline uint16_t jz4740_timer_get_count(unsigned int timer)
+{
+	return readw(jz4740_timer_base + JZ_REG_TIMER_CNT(timer));
+}
+
+static inline void jz4740_timer_ack_full(unsigned int timer)
+{
+	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_FLAG_CLEAR);
+}
+
+static inline void jz4740_timer_irq_full_enable(unsigned int timer)
+{
+	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_FLAG_CLEAR);
+	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_MASK_CLEAR);
+}
+
+static inline void jz4740_timer_irq_full_disable(unsigned int timer)
+{
+	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_MASK_SET);
+}
+
+static inline void jz4740_timer_set_ctrl(unsigned int timer, uint16_t ctrl)
+{
+	writew(ctrl, jz4740_timer_base + JZ_REG_TIMER_CTRL(timer));
+}
+
+static inline uint16_t jz4740_timer_get_ctrl(unsigned int timer)
+{
+	return readw(jz4740_timer_base + JZ_REG_TIMER_CTRL(timer));
+}
+
 #endif
diff --git a/arch/mips/jz4740/time.c b/arch/mips/jz4740/time.c
index f83c2dd..39bb4bb 100644
--- a/arch/mips/jz4740/time.c
+++ b/arch/mips/jz4740/time.c
@@ -20,10 +20,10 @@
 #include <linux/clockchips.h>
 
 #include <asm/mach-jz4740/irq.h>
+#include <asm/mach-jz4740/timer.h>
 #include <asm/time.h>
 
 #include "clock.h"
-#include "timer.h"
 
 #define TIMER_CLOCKEVENT 0
 #define TIMER_CLOCKSOURCE 1
diff --git a/arch/mips/jz4740/timer.c b/arch/mips/jz4740/timer.c
index 654d5c3..22f11d7 100644
--- a/arch/mips/jz4740/timer.c
+++ b/arch/mips/jz4740/timer.c
@@ -17,11 +17,11 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include "timer.h"
-
 #include <asm/mach-jz4740/base.h>
+#include <asm/mach-jz4740/timer.h>
 
 void __iomem *jz4740_timer_base;
+EXPORT_SYMBOL_GPL(jz4740_timer_base);
 
 void jz4740_timer_enable_watchdog(void)
 {
diff --git a/arch/mips/jz4740/timer.h b/arch/mips/jz4740/timer.h
deleted file mode 100644
index fca3994..0000000
--- a/arch/mips/jz4740/timer.h
+++ /dev/null
@@ -1,136 +0,0 @@
-/*
- *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
- *  JZ4740 platform timer support
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under  the terms of the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the License, or (at your
- *  option) any later version.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-#ifndef __MIPS_JZ4740_TIMER_H__
-#define __MIPS_JZ4740_TIMER_H__
-
-#include <linux/module.h>
-#include <linux/io.h>
-
-#define JZ_REG_TIMER_STOP		0x0C
-#define JZ_REG_TIMER_STOP_SET		0x1C
-#define JZ_REG_TIMER_STOP_CLEAR		0x2C
-#define JZ_REG_TIMER_ENABLE		0x00
-#define JZ_REG_TIMER_ENABLE_SET		0x04
-#define JZ_REG_TIMER_ENABLE_CLEAR	0x08
-#define JZ_REG_TIMER_FLAG		0x10
-#define JZ_REG_TIMER_FLAG_SET		0x14
-#define JZ_REG_TIMER_FLAG_CLEAR		0x18
-#define JZ_REG_TIMER_MASK		0x20
-#define JZ_REG_TIMER_MASK_SET		0x24
-#define JZ_REG_TIMER_MASK_CLEAR		0x28
-
-#define JZ_REG_TIMER_DFR(x) (((x) * 0x10) + 0x30)
-#define JZ_REG_TIMER_DHR(x) (((x) * 0x10) + 0x34)
-#define JZ_REG_TIMER_CNT(x) (((x) * 0x10) + 0x38)
-#define JZ_REG_TIMER_CTRL(x) (((x) * 0x10) + 0x3C)
-
-#define JZ_TIMER_IRQ_HALF(x) BIT((x) + 0x10)
-#define JZ_TIMER_IRQ_FULL(x) BIT(x)
-
-#define JZ_TIMER_CTRL_PWM_ABBRUPT_SHUTDOWN	BIT(9)
-#define JZ_TIMER_CTRL_PWM_ACTIVE_LOW		BIT(8)
-#define JZ_TIMER_CTRL_PWM_ENABLE		BIT(7)
-#define JZ_TIMER_CTRL_PRESCALE_MASK		0x1c
-#define JZ_TIMER_CTRL_PRESCALE_OFFSET		0x3
-#define JZ_TIMER_CTRL_PRESCALE_1		(0 << 3)
-#define JZ_TIMER_CTRL_PRESCALE_4		(1 << 3)
-#define JZ_TIMER_CTRL_PRESCALE_16		(2 << 3)
-#define JZ_TIMER_CTRL_PRESCALE_64		(3 << 3)
-#define JZ_TIMER_CTRL_PRESCALE_256		(4 << 3)
-#define JZ_TIMER_CTRL_PRESCALE_1024		(5 << 3)
-
-#define JZ_TIMER_CTRL_PRESCALER(x) ((x) << JZ_TIMER_CTRL_PRESCALE_OFFSET)
-
-#define JZ_TIMER_CTRL_SRC_EXT		BIT(2)
-#define JZ_TIMER_CTRL_SRC_RTC		BIT(1)
-#define JZ_TIMER_CTRL_SRC_PCLK		BIT(0)
-
-extern void __iomem *jz4740_timer_base;
-void __init jz4740_timer_init(void);
-
-static inline void jz4740_timer_stop(unsigned int timer)
-{
-	writel(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_STOP_SET);
-}
-
-static inline void jz4740_timer_start(unsigned int timer)
-{
-	writel(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_STOP_CLEAR);
-}
-
-static inline bool jz4740_timer_is_enabled(unsigned int timer)
-{
-	return readb(jz4740_timer_base + JZ_REG_TIMER_ENABLE) & BIT(timer);
-}
-
-static inline void jz4740_timer_enable(unsigned int timer)
-{
-	writeb(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_ENABLE_SET);
-}
-
-static inline void jz4740_timer_disable(unsigned int timer)
-{
-	writeb(BIT(timer), jz4740_timer_base + JZ_REG_TIMER_ENABLE_CLEAR);
-}
-
-
-static inline void jz4740_timer_set_period(unsigned int timer, uint16_t period)
-{
-	writew(period, jz4740_timer_base + JZ_REG_TIMER_DFR(timer));
-}
-
-static inline void jz4740_timer_set_duty(unsigned int timer, uint16_t duty)
-{
-	writew(duty, jz4740_timer_base + JZ_REG_TIMER_DHR(timer));
-}
-
-static inline void jz4740_timer_set_count(unsigned int timer, uint16_t count)
-{
-	writew(count, jz4740_timer_base + JZ_REG_TIMER_CNT(timer));
-}
-
-static inline uint16_t jz4740_timer_get_count(unsigned int timer)
-{
-	return readw(jz4740_timer_base + JZ_REG_TIMER_CNT(timer));
-}
-
-static inline void jz4740_timer_ack_full(unsigned int timer)
-{
-	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_FLAG_CLEAR);
-}
-
-static inline void jz4740_timer_irq_full_enable(unsigned int timer)
-{
-	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_FLAG_CLEAR);
-	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_MASK_CLEAR);
-}
-
-static inline void jz4740_timer_irq_full_disable(unsigned int timer)
-{
-	writel(JZ_TIMER_IRQ_FULL(timer), jz4740_timer_base + JZ_REG_TIMER_MASK_SET);
-}
-
-static inline void jz4740_timer_set_ctrl(unsigned int timer, uint16_t ctrl)
-{
-	writew(ctrl, jz4740_timer_base + JZ_REG_TIMER_CTRL(timer));
-}
-
-static inline uint16_t jz4740_timer_get_ctrl(unsigned int timer)
-{
-	return readw(jz4740_timer_base + JZ_REG_TIMER_CTRL(timer));
-}
-
-#endif
-- 
1.7.12

