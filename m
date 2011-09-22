Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab1IVJBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:01:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34005 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab1IVJBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:01:11 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sam Creasey <sammy@sammy.net>, Greg Ungerer <gerg@uclinux.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-m68k@vger.kernel.org
Subject: [PATCH 10/55] m68k: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:58:37 +0800
Message-Id: <1316681962-8217-11-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/floppy.h         |    2 +-
 arch/m68k/include/asm/irq.h            |    4 ++--
 arch/m68k/include/asm/sun3xflop.h      |    2 +-
 arch/m68k/platform/68328/timers.c      |    2 +-
 arch/m68k/platform/68360/config.c      |    2 +-
 arch/m68k/platform/coldfire/pit.c      |    2 +-
 arch/m68k/platform/coldfire/sltimers.c |    4 ++--
 arch/m68k/platform/coldfire/timers.c   |    4 ++--
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/m68k/include/asm/floppy.h b/arch/m68k/include/asm/floppy.h
index 697d503..47365b1 100644
--- a/arch/m68k/include/asm/floppy.h
+++ b/arch/m68k/include/asm/floppy.h
@@ -85,7 +85,7 @@ static int fd_request_irq(void)
 {
 	if(MACH_IS_Q40)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", floppy_hardint);
+				   0, "floppy", floppy_hardint);
 	else if(MACH_IS_SUN3X)
 		return sun3xflop_request_irq();
 	return -ENXIO;
diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 69ed0d74..35de598 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -60,8 +60,8 @@ struct pt_regs;
 
 /*
  * various flags for request_irq() - the Amiga now uses the standard
- * mechanism like all other architectures - IRQF_DISABLED and
- * IRQF_SHARED are your friends.
+ * mechanism like all other architectures - IRQF_SHARED etc.
+ * are your friends.
  */
 #ifndef MACH_AMIGA_ONLY
 #define IRQ_FLG_LOCK	(0x0001)	/* handler is not replaceable	*/
diff --git a/arch/m68k/include/asm/sun3xflop.h b/arch/m68k/include/asm/sun3xflop.h
index 32c45f8..80f8f9f 100644
--- a/arch/m68k/include/asm/sun3xflop.h
+++ b/arch/m68k/include/asm/sun3xflop.h
@@ -208,7 +208,7 @@ static int sun3xflop_request_irq(void)
 	if(!once) {
 		once = 1;
 		error = request_irq(FLOPPY_IRQ, sun3xflop_hardint,
-				    IRQF_DISABLED, "floppy", NULL);
+				    0, "floppy", NULL);
 		return ((error == 0) ? 0 : -1);
 	} else return 0;
 }
diff --git a/arch/m68k/platform/68328/timers.c b/arch/m68k/platform/68328/timers.c
index 309f725..d135b26 100644
--- a/arch/m68k/platform/68328/timers.c
+++ b/arch/m68k/platform/68328/timers.c
@@ -69,7 +69,7 @@ static irqreturn_t hw_tick(int irq, void *dummy)
 
 static struct irqaction m68328_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = hw_tick,
 };
 
diff --git a/arch/m68k/platform/68360/config.c b/arch/m68k/platform/68360/config.c
index 9dd5bca..c67f1c3 100644
--- a/arch/m68k/platform/68360/config.c
+++ b/arch/m68k/platform/68360/config.c
@@ -58,7 +58,7 @@ static irqreturn_t hw_tick(int irq, void *dummy)
 
 static struct irqaction m68360_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = hw_tick,
 };
 
diff --git a/arch/m68k/platform/coldfire/pit.c b/arch/m68k/platform/coldfire/pit.c
index c2b9809..c69b71a 100644
--- a/arch/m68k/platform/coldfire/pit.c
+++ b/arch/m68k/platform/coldfire/pit.c
@@ -118,7 +118,7 @@ static irqreturn_t pit_tick(int irq, void *dummy)
 
 static struct irqaction pit_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = pit_tick,
 };
 
diff --git a/arch/m68k/platform/coldfire/sltimers.c b/arch/m68k/platform/coldfire/sltimers.c
index 6a85daf..2168dda 100644
--- a/arch/m68k/platform/coldfire/sltimers.c
+++ b/arch/m68k/platform/coldfire/sltimers.c
@@ -51,7 +51,7 @@ irqreturn_t mcfslt_profile_tick(int irq, void *dummy)
 
 static struct irqaction mcfslt_profile_irq = {
 	.name	 = "profile timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = mcfslt_profile_tick,
 };
 
@@ -91,7 +91,7 @@ static irqreturn_t mcfslt_tick(int irq, void *dummy)
 
 static struct irqaction mcfslt_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = mcfslt_tick,
 };
 
diff --git a/arch/m68k/platform/coldfire/timers.c b/arch/m68k/platform/coldfire/timers.c
index 60242f6..687a38f 100644
--- a/arch/m68k/platform/coldfire/timers.c
+++ b/arch/m68k/platform/coldfire/timers.c
@@ -62,7 +62,7 @@ static irqreturn_t mcftmr_tick(int irq, void *dummy)
 
 static struct irqaction mcftmr_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = mcftmr_tick,
 };
 
@@ -150,7 +150,7 @@ irqreturn_t coldfire_profile_tick(int irq, void *dummy)
 
 static struct irqaction coldfire_profile_irq = {
 	.name	 = "profile timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = coldfire_profile_tick,
 };
 
-- 
1.7.4.1

