Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2FTUKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:10:00 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:34052 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab2FTUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:09:57 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/6] mn10300: Move setup_jiffies_interrupt() to cevt-mn10300.c
Date: Wed, 20 Jun 2012 22:09:45 +0200
Message-Id: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the static inline function setup_jiffies_interrupt() from
<asm/timex.h> to arch/mn10300/kernel/cevt-mn10300.c, which is its only
callsite.

This allows to remove the inclusion of <asm/hardirq.h> and <linux/irq.h>
from <asm/timex.h> and <unit/timex.h>, fixing include hell like:

include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:46:42: error: division by zero in #if
make[4]: *** [arch/mn10300/kernel/asm-offsets.s] Error 1

and (after a quick hack for the above by defining CLOCK_TICK_RATE in
<linux/jiffies.h>):

In file included from include/linux/notifier.h:15:0,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:718,
                 from include/linux/gfp.h:4,
                 from include/linux/irq.h:20,
                 from arch/mn10300/unit-asb2303/include/unit/timex.h:15,
                 from arch/mn10300/include/asm/timex.h:15,
                 from include/linux/timex.h:174,
                 from include/linux/jiffies.h:8,
                 from include/linux/ktime.h:25,
                 from include/linux/timer.h:5,
                 from include/linux/workqueue.h:8,
include/linux/srcu.h:55:22: error: field 'work' has incomplete type

As a consequence, we do need a few more inclusions of <asm/irq.h>, namely
in arch/mn10300/unit-asb2303/smc91111.c and
arch/mn10300/unit-asb2305/unit-init.c.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/mn10300/include/asm/timex.h               |   11 -----------
 arch/mn10300/kernel/cevt-mn10300.c             |   10 ++++++++++
 arch/mn10300/unit-asb2303/include/unit/timex.h |    4 ----
 arch/mn10300/unit-asb2303/smc91111.c           |    1 +
 arch/mn10300/unit-asb2305/include/unit/timex.h |    4 ----
 arch/mn10300/unit-asb2305/unit-init.c          |    1 +
 arch/mn10300/unit-asb2364/include/unit/timex.h |    4 ----
 7 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/arch/mn10300/include/asm/timex.h b/arch/mn10300/include/asm/timex.h
index bd4e90d..f8e6642 100644
--- a/arch/mn10300/include/asm/timex.h
+++ b/arch/mn10300/include/asm/timex.h
@@ -11,7 +11,6 @@
 #ifndef _ASM_TIMEX_H
 #define _ASM_TIMEX_H
 
-#include <asm/hardirq.h>
 #include <unit/timex.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
@@ -30,16 +29,6 @@ static inline cycles_t get_cycles(void)
 extern int init_clockevents(void);
 extern int init_clocksource(void);
 
-static inline void setup_jiffies_interrupt(int irq,
-					   struct irqaction *action)
-{
-	u16 tmp;
-	setup_irq(irq, action);
-	set_intr_level(irq, NUM2GxICR_LEVEL(CONFIG_TIMER_IRQ_LEVEL));
-	GxICR(irq) |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
-	tmp = GxICR(irq);
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_TIMEX_H */
diff --git a/arch/mn10300/kernel/cevt-mn10300.c b/arch/mn10300/kernel/cevt-mn10300.c
index 69cae02..ccce35e 100644
--- a/arch/mn10300/kernel/cevt-mn10300.c
+++ b/arch/mn10300/kernel/cevt-mn10300.c
@@ -70,6 +70,16 @@ static void event_handler(struct clock_event_device *dev)
 {
 }
 
+static inline void setup_jiffies_interrupt(int irq,
+					   struct irqaction *action)
+{
+	u16 tmp;
+	setup_irq(irq, action);
+	set_intr_level(irq, NUM2GxICR_LEVEL(CONFIG_TIMER_IRQ_LEVEL));
+	GxICR(irq) |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
+	tmp = GxICR(irq);
+}
+
 int __init init_clockevents(void)
 {
 	struct clock_event_device *cd;
diff --git a/arch/mn10300/unit-asb2303/include/unit/timex.h b/arch/mn10300/unit-asb2303/include/unit/timex.h
index cc18fe7..c37f983 100644
--- a/arch/mn10300/unit-asb2303/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2303/include/unit/timex.h
@@ -11,10 +11,6 @@
 #ifndef _ASM_UNIT_TIMEX_H
 #define _ASM_UNIT_TIMEX_H
 
-#ifndef __ASSEMBLY__
-#include <linux/irq.h>
-#endif /* __ASSEMBLY__ */
-
 #include <asm/timer-regs.h>
 #include <unit/clock.h>
 #include <asm/param.h>
diff --git a/arch/mn10300/unit-asb2303/smc91111.c b/arch/mn10300/unit-asb2303/smc91111.c
index 43c2464..5367769 100644
--- a/arch/mn10300/unit-asb2303/smc91111.c
+++ b/arch/mn10300/unit-asb2303/smc91111.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
+#include <asm/irq.h>
 #include <asm/timex.h>
 #include <asm/processor.h>
 #include <asm/intctl-regs.h>
diff --git a/arch/mn10300/unit-asb2305/include/unit/timex.h b/arch/mn10300/unit-asb2305/include/unit/timex.h
index 758af30..4cefc22 100644
--- a/arch/mn10300/unit-asb2305/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2305/include/unit/timex.h
@@ -11,10 +11,6 @@
 #ifndef _ASM_UNIT_TIMEX_H
 #define _ASM_UNIT_TIMEX_H
 
-#ifndef __ASSEMBLY__
-#include <linux/irq.h>
-#endif /* __ASSEMBLY__ */
-
 #include <asm/timer-regs.h>
 #include <unit/clock.h>
 #include <asm/param.h>
diff --git a/arch/mn10300/unit-asb2305/unit-init.c b/arch/mn10300/unit-asb2305/unit-init.c
index e1becd6..bc4adfa 100644
--- a/arch/mn10300/unit-asb2305/unit-init.c
+++ b/arch/mn10300/unit-asb2305/unit-init.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/io.h>
+#include <asm/irq.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/intctl-regs.h>
diff --git a/arch/mn10300/unit-asb2364/include/unit/timex.h b/arch/mn10300/unit-asb2364/include/unit/timex.h
index ddb7ed0..42f32db 100644
--- a/arch/mn10300/unit-asb2364/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2364/include/unit/timex.h
@@ -11,10 +11,6 @@
 #ifndef _ASM_UNIT_TIMEX_H
 #define _ASM_UNIT_TIMEX_H
 
-#ifndef __ASSEMBLY__
-#include <linux/irq.h>
-#endif /* __ASSEMBLY__ */
-
 #include <asm/timer-regs.h>
 #include <unit/clock.h>
 #include <asm/param.h>
-- 
1.7.0.4

