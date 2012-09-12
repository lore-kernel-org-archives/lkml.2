Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2ILXb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:31:26 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59246 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2ILXbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:31:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: [ 013/108] ARM: imx6: spin the cpu until hardware takes it down
Date: Wed, 12 Sep 2012 16:28:11 -0700
Message-Id: <20120912232451.904294771@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


