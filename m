Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2JaXOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 19:14:44 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:53361 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2JaXMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 19:12:52 -0400
Message-Id: <3ec3531d21c247ac3dcc76d91ff6be13ebfc733b.1351721190.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Wed, 31 Oct 2012 11:11:59 -0600
Subject: [PATCH 1/8] ARM: zynq: move arm-specific sys_timer out of ttc
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:28 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:28 PM,
	Serialize complete at 10/31/2012 06:12:28 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-31_03:2012-10-31,2012-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the sys_timer definition out of ttc driver and make it part of the
common zynq code.  This is preparation for renaming and COMMON_CLK
support.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/mach-zynq/common.c | 13 +++++++++++++
 arch/arm/mach-zynq/common.h |  4 +---
 arch/arm/mach-zynq/timer.c  | 10 +---------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index ba8d14f..6f058258 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -25,6 +25,7 @@
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/mach/time.h>
 #include <asm/mach-types.h>
 #include <asm/page.h>
 #include <asm/hardware/gic.h>
@@ -93,6 +94,18 @@ static struct map_desc io_desc[] __initdata = {
 
 };
 
+static void __init xilinx_zynq_timer_init(void)
+{
+	xttcpss_timer_init();
+}
+
+/*
+ * Instantiate and initialize the system timer structure
+ */
+static struct sys_timer xttcpss_sys_timer = {
+	.init		= xilinx_zynq_timer_init,
+};
+
 /**
  * xilinx_map_io() - Create memory mappings needed for early I/O.
  */
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index a009644..954b91c 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -17,8 +17,6 @@
 #ifndef __MACH_ZYNQ_COMMON_H__
 #define __MACH_ZYNQ_COMMON_H__
 
-#include <asm/mach/time.h>
-
-extern struct sys_timer xttcpss_sys_timer;
+void __init xttcpss_timer_init(void);
 
 #endif
diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
index c2c96cc..c93cbe5 100644
--- a/arch/arm/mach-zynq/timer.c
+++ b/arch/arm/mach-zynq/timer.c
@@ -24,7 +24,6 @@
 #include <linux/clockchips.h>
 #include <linux/io.h>
 
-#include <asm/mach/time.h>
 #include <mach/zynq_soc.h>
 #include "common.h"
 
@@ -269,7 +268,7 @@ static struct clock_event_device xttcpss_clockevent = {
  * Initializes the timer hardware and register the clock source and clock event
  * timers with Linux kernal timer framework
  **/
-static void __init xttcpss_timer_init(void)
+void __init xttcpss_timer_init(void)
 {
 	xttcpss_timer_hardware_init();
 	clocksource_register_hz(&clocksource_xttcpss, TIMER_RATE);
@@ -289,10 +288,3 @@ static void __init xttcpss_timer_init(void)
 	xttcpss_clockevent.cpumask = cpumask_of(0);
 	clockevents_register_device(&xttcpss_clockevent);
 }
-
-/*
- * Instantiate and initialize the system timer structure
- */
-struct sys_timer xttcpss_sys_timer = {
-	.init		= xttcpss_timer_init,
-};
-- 
1.8.0


