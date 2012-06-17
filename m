Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab2FQS2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:28:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50346 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758444Ab2FQSWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:55 -0400
Message-Id: <20120617175946.277226082@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shawn Guo <shawn.guo@linaro.org>
Subject: [ 35/69] ARM: imx6: exit coherency when shutting down a cpu
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit 602bf40971d7f9a1ec0b7ba2b7e6427849828651 upstream.

There is a system hang issue on imx6q which can easily be seen with
running a cpu hotplug stress testing (hotplug secondary cores from
user space via sysfs interface for thousands iterations).

It turns out that the issue is caused by coherency of the cpu that
is being shut down.  When shutting down a cpu, we need to have the
cpu exit coherency to prevent it from receiving cache, TLB, or BTB
maintenance operations broadcast by other CPUs in the cluster.

Copy cpu_enter_lowpower() and cpu_leave_lowpower() from mach-vexpress
to have coherency properly handled in platform_cpu_die(), thus fix
the issue.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-imx/hotplug.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/hotplug.c b/arch/arm/mach-imx/hotplug.c
index 89493ab..20ed2d5 100644
--- a/arch/arm/mach-imx/hotplug.c
+++ b/arch/arm/mach-imx/hotplug.c
@@ -12,6 +12,7 @@
 
 #include <linux/errno.h>
 #include <asm/cacheflush.h>
+#include <asm/cp15.h>
 #include <mach/common.h>
 
 int platform_cpu_kill(unsigned int cpu)
@@ -19,6 +20,44 @@ int platform_cpu_kill(unsigned int cpu)
 	return 1;
 }
 
+static inline void cpu_enter_lowpower(void)
+{
+	unsigned int v;
+
+	flush_cache_all();
+	asm volatile(
+		"mcr	p15, 0, %1, c7, c5, 0\n"
+	"	mcr	p15, 0, %1, c7, c10, 4\n"
+	/*
+	 * Turn off coherency
+	 */
+	"	mrc	p15, 0, %0, c1, c0, 1\n"
+	"	bic	%0, %0, %3\n"
+	"	mcr	p15, 0, %0, c1, c0, 1\n"
+	"	mrc	p15, 0, %0, c1, c0, 0\n"
+	"	bic	%0, %0, %2\n"
+	"	mcr	p15, 0, %0, c1, c0, 0\n"
+	  : "=&r" (v)
+	  : "r" (0), "Ir" (CR_C), "Ir" (0x40)
+	  : "cc");
+}
+
+static inline void cpu_leave_lowpower(void)
+{
+	unsigned int v;
+
+	asm volatile(
+		"mrc	p15, 0, %0, c1, c0, 0\n"
+	"	orr	%0, %0, %1\n"
+	"	mcr	p15, 0, %0, c1, c0, 0\n"
+	"	mrc	p15, 0, %0, c1, c0, 1\n"
+	"	orr	%0, %0, %2\n"
+	"	mcr	p15, 0, %0, c1, c0, 1\n"
+	  : "=&r" (v)
+	  : "Ir" (CR_C), "Ir" (0x40)
+	  : "cc");
+}
+
 /*
  * platform-specific code to shutdown a CPU
  *
@@ -26,9 +65,10 @@ int platform_cpu_kill(unsigned int cpu)
  */
 void platform_cpu_die(unsigned int cpu)
 {
-	flush_cache_all();
+	cpu_enter_lowpower();
 	imx_enable_cpu(cpu, false);
 	cpu_do_idle();
+	cpu_leave_lowpower();
 
 	/* We should never return from idle */
 	panic("cpu %d unexpectedly exit from shutdown\n", cpu);


