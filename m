Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991Ab2JaXM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 19:12:57 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:57338 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2JaXMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 19:12:52 -0400
Message-Id: <c0347788fbad559a249a25128a23f40c85d9cbda.1351721190.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Mon, 29 Oct 2012 12:42:13 -0600
Subject: [PATCH 2/8] ARM: zynq: move ttc timer code to drivers/clocksource
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
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:28 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:28 PM,
	Serialize complete at 10/31/2012 06:12:28 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-31_03:2012-10-31,2012-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested cleanup by Arnd Bergmann.  Move the ttc timer.c code to
drivers/clocksource, and out of the mach-zynq directory.

The common.h (which only held the timer declaration) was renamed to
xilinx_ttc.h and moved into include/linux.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-zynq/Makefile                                    | 2 +-
 arch/arm/mach-zynq/common.c                                    | 2 +-
 drivers/clocksource/Makefile                                   | 1 +
 arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c | 1 -
 arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h      | 4 ++--
 5 files changed, 5 insertions(+), 5 deletions(-)
 rename arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c (99%)
 rename arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h (91%)

diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
index 397268c..320faed 100644
--- a/arch/arm/mach-zynq/Makefile
+++ b/arch/arm/mach-zynq/Makefile
@@ -3,4 +3,4 @@
 #
 
 # Common support
-obj-y				:= common.o timer.o
+obj-y				:= common.o
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 6f058258..0279ea7 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -22,6 +22,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of.h>
+#include <linux/xilinx_ttc.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -32,7 +33,6 @@
 #include <asm/hardware/cache-l2x0.h>
 
 #include <mach/zynq_soc.h>
-#include "common.h"
 
 static struct of_device_id zynq_of_bus_ids[] __initdata = {
 	{ .compatible = "simple-bus", },
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 603be36..f27c7b1 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -14,5 +14,6 @@ obj-$(CONFIG_DW_APB_TIMER_OF)	+= dw_apb_timer_of.o
 obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
+obj-$(CONFIG_ARCH_ZYNQ)		+= xilinx_ttc.o
 
 obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+= arm_generic.o
diff --git a/arch/arm/mach-zynq/timer.c b/drivers/clocksource/xilinx_ttc.c
similarity index 99%
rename from arch/arm/mach-zynq/timer.c
rename to drivers/clocksource/xilinx_ttc.c
index c93cbe5..ff38b3e 100644
--- a/arch/arm/mach-zynq/timer.c
+++ b/drivers/clocksource/xilinx_ttc.c
@@ -25,7 +25,6 @@
 #include <linux/io.h>
 
 #include <mach/zynq_soc.h>
-#include "common.h"
 
 #define IRQ_TIMERCOUNTER0	42
 
diff --git a/arch/arm/mach-zynq/common.h b/include/linux/xilinx_ttc.h
similarity index 91%
rename from arch/arm/mach-zynq/common.h
rename to include/linux/xilinx_ttc.h
index 954b91c..303a3fd 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/include/linux/xilinx_ttc.h
@@ -14,8 +14,8 @@
  * GNU General Public License for more details.
  */
 
-#ifndef __MACH_ZYNQ_COMMON_H__
-#define __MACH_ZYNQ_COMMON_H__
+#ifndef __XILINX_TTC_H__
+#define __XILINX_TTC_H__
 
 void __init xttcpss_timer_init(void);
 
-- 
1.8.0


