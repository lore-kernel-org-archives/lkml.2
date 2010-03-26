Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0CZVx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:53:26 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:35325 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0CZVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:53:24 -0400
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: Dmitry Artamonow <mad_soft@inbox.ru>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH 1/2] ARM: mach-sa1100: Fix for the use of wrong CPU_FREQ code in nanoengine.
Date: Fri, 26 Mar 2010 18:53:10 -0300
Message-Id: <1269640391-23451-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects the right CPU_FREQ module to use with nanoengine.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 arch/arm/mach-sa1100/Kconfig      |    2 +-
 arch/arm/mach-sa1100/cpu-sa1110.c |   27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-sa1100/Kconfig b/arch/arm/mach-sa1100/Kconfig
index e6ce667..403db50 100644
--- a/arch/arm/mach-sa1100/Kconfig
+++ b/arch/arm/mach-sa1100/Kconfig
@@ -120,7 +120,7 @@ config SA1100_LART
 
 config SA1100_NANOENGINE
 	bool "nanoEngine"
-	select CPU_FREQ_SA1100
+	select CPU_FREQ_SA1110
 	help
 	  Say Y here if you are using the Bright Star Engineering nanoEngine.
 	  See <http://www.brightstareng.com/arm/nanoeng.htm> for information
diff --git a/arch/arm/mach-sa1100/cpu-sa1110.c b/arch/arm/mach-sa1100/cpu-sa1110.c
index 63b32b6..7236fcd 100644
--- a/arch/arm/mach-sa1100/cpu-sa1110.c
+++ b/arch/arm/mach-sa1100/cpu-sa1110.c
@@ -16,19 +16,17 @@
  *
  * The SDRAM type can be passed on the command line as cpu_sa1110.sdram=type
  */
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
 
-#include <mach/hardware.h>
 #include <asm/cputype.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
+
+#include <mach/hardware.h>
 
 #include "generic.h"
 
@@ -37,7 +35,7 @@
 static struct cpufreq_driver sa1110_driver;
 
 struct sdram_params {
-	const char name[16];
+	const char name[20];
 	u_char  rows;		/* bits				 */
 	u_char  cas_latency;	/* cycles			 */
 	u_char  tck;		/* clock cycle time (ns)	 */
@@ -107,6 +105,15 @@ static struct sdram_params sdram_tbl[] __initdata = {
 		.twr		= 8,
 		.refresh	= 64000,
 		.cas_latency	= 3,
+	}, {	/* Micron MT48LC8M16A2TG-75 */
+		.name		= "MT48LC8M16A2TG-75",
+		.rows		= 12,
+		.tck		= 8,
+		.trcd		= 20,
+		.trp		= 20,
+		.twr		= 8,
+		.refresh	= 64000,
+		.cas_latency	= 3,
 	},
 };
 
@@ -366,14 +373,14 @@ static int __init sa1110_clk_init(void)
 	if (!name[0]) {
 		if (machine_is_assabet())
 			name = "TC59SM716-CL3";
-
 		if (machine_is_pt_system3())
 			name = "K4S641632D";
-
 		if (machine_is_h3100())
 			name = "KM416S4030CT";
 		if (machine_is_jornada720())
 		        name = "K4S281632B-1H";
+		if (machine_is_nanoengine())
+			name = "MT48LC8M16A2TG-75";
 	}
 
 	sdram = sa1110_find_sdram(name);
-- 
1.7.0.3

