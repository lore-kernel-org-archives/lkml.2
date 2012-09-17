Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2IQAuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33325 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941Ab2IQAtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:24 -0400
Message-Id: <20120917003628.314911353@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shawn Guo <shawn.guo@linaro.org>
Subject: [ 015/135] ARM: imx6: spin the cpu until hardware takes it down
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit c944b0b9354ea06ffb0c8a7178949f1185f9f499 upstream.

Though commit 602bf40 (ARM: imx6: exit coherency when shutting down
a cpu) improves the stability of imx6q cpu hotplug a lot, there are
still hangs seen with a more stressful hotplug testing.

It's expected that once imx_enable_cpu(cpu, false) is called, the cpu
will be taken down by hardware immediately, and the code after that
will not get any chance to execute.  However, this is not always the
case from the testing.  The cpu could possibly be alive for a few
cycles before hardware actually takes it down.  So rather than letting
cpu execute some code that could cause a hang in these cycles, let's
make the cpu spin there and wait for hardware to take it down.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-imx/hotplug.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

--- a/arch/arm/mach-imx/hotplug.c
+++ b/arch/arm/mach-imx/hotplug.c
@@ -42,22 +42,6 @@ static inline void cpu_enter_lowpower(vo
 	  : "cc");
 }
 
-static inline void cpu_leave_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-		"mrc	p15, 0, %0, c1, c0, 0\n"
-	"	orr	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	orr	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	  : "=&r" (v)
-	  : "Ir" (CR_C), "Ir" (0x40)
-	  : "cc");
-}
-
 /*
  * platform-specific code to shutdown a CPU
  *
@@ -67,11 +51,10 @@ void platform_cpu_die(unsigned int cpu)
 {
 	cpu_enter_lowpower();
 	imx_enable_cpu(cpu, false);
-	cpu_do_idle();
-	cpu_leave_lowpower();
 
-	/* We should never return from idle */
-	panic("cpu %d unexpectedly exit from shutdown\n", cpu);
+	/* spin here until hardware takes it down */
+	while (1)
+		;
 }
 
 int platform_cpu_disable(unsigned int cpu)


