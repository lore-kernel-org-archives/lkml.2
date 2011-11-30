Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1K3U7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:59:03 -0500
Received: from d1.icnet.pl ([212.160.220.21]:53581 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab1K3U7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:59:01 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 2a/5 v2] ARM: OMAP1: select clock rate by CPU type
Date: Wed, 30 Nov 2011 21:57:55 +0100
Message-Id: <1322686675-26855-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20111128174508.GO31337@atomide.com>
References: <20111128174508.GO31337@atomide.com>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DPLL1 reprogramming to a different rate is actually blocked inside
omap1_select_table_rate(), resulting in the defalut rate of 60 MHz
always used instead of the one selected in .config. OTOH, in
omap1_defconfig we currently rely on Kconfig options for the supported
MHz rates in case of boards which boot with dpll1 not set correctly by
their boot loaders.

This means that before we allow for reprogramming of dpll1 rate, we
should prevent from incompatible clock rates being selected, otherwise
omap1_defconfig will stop booting on boards with imperfect boot loaders,
as it would always try to change to 216MHz.

Expand omap1_rate_table with flags for different CPU types and match
them while selecting clock rates. The idea is stolen from current
omap24xx clock rate selection algorithm.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
Hi,
Since there is no response to patch 2a/5 "Remove unsafe clock values 
from omap1_defconfig" yet, while rc4 is probably almost out:

If there are reasons for keeping high clock rates selected in
omap1_defconfig, and those reasons are more important than fixing bugs
which prevent some boards from working correctly under 3.2, here is an
alternative, low intrusive solution which should allow booting from
omap1_defconfig at correct speeds, selected by CPU type. If the idea is
acceptable, please review the CPU per clock rate selections I made,
since I'm not sure about their correctness, perhaps except CK_1510,
which is based on my own experience with Amstrad Delta. I'll fix that if
necessary.

Thanks,
Janusz


 arch/arm/mach-omap1/clock.c      |    6 +++++
 arch/arm/mach-omap1/clock_data.c |    4 ++-
 arch/arm/mach-omap1/opp.h        |    2 +
 arch/arm/mach-omap1/opp_data.c   |   43 +++++++++++++++++++++++++------------
 4 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index 3899176..6d8f7c6 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -197,6 +197,9 @@ int omap1_select_table_rate(struct clk *clk, unsigned long rate)
 	ref_rate = ck_ref_p->rate;
 
 	for (ptr = omap1_rate_table; ptr->rate; ptr++) {
+		if (!(ptr->flags & cpu_mask))
+			continue;
+
 		if (ptr->xtal != ref_rate)
 			continue;
 
@@ -286,6 +289,9 @@ long omap1_round_to_table_rate(struct clk *clk, unsigned long rate)
 	highest_rate = -EINVAL;
 
 	for (ptr = omap1_rate_table; ptr->rate; ptr++) {
+		if (!(ptr->flags & cpu_mask))
+			continue;
+
 		if (ptr->xtal != ref_rate)
 			continue;
 
diff --git a/arch/arm/mach-omap1/clock_data.c b/arch/arm/mach-omap1/clock_data.c
index 201b1f2..398a7bb 100644
--- a/arch/arm/mach-omap1/clock_data.c
+++ b/arch/arm/mach-omap1/clock_data.c
@@ -777,12 +777,14 @@ static void __init omap1_show_rates(void)
 		arm_ck.rate / 1000000, (arm_ck.rate / 100000) % 10);
 }
 
+u32 cpu_mask;
+
 int __init omap1_clk_init(void)
 {
 	struct omap_clk *c;
 	const struct omap_clock_config *info;
 	int crystal_type = 0; /* Default 12 MHz */
-	u32 reg, cpu_mask;
+	u32 reg;
 
 #ifdef CONFIG_DEBUG_LL
 	/*
diff --git a/arch/arm/mach-omap1/opp.h b/arch/arm/mach-omap1/opp.h
index 07074d7..f5dcbf1 100644
--- a/arch/arm/mach-omap1/opp.h
+++ b/arch/arm/mach-omap1/opp.h
@@ -21,8 +21,10 @@ struct mpu_rate {
 	unsigned long		pll_rate;
 	__u16			ckctl_val;
 	__u16			dpllctl_val;
+	u32			flags;
 };
 
 extern struct mpu_rate omap1_rate_table[];
+extern u32 cpu_mask;
 
 #endif
diff --git a/arch/arm/mach-omap1/opp_data.c b/arch/arm/mach-omap1/opp_data.c
index 75a5465..d8d451c 100644
--- a/arch/arm/mach-omap1/opp_data.c
+++ b/arch/arm/mach-omap1/opp_data.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <plat/clkdev_omap.h>
 #include "opp.h"
 
 /*-------------------------------------------------------------------------
@@ -21,38 +22,52 @@ struct mpu_rate omap1_rate_table[] = {
 	 * armdiv, dspdiv, dspmmu, tcdiv, perdiv, lcddiv
 	 */
 #if defined(CONFIG_OMAP_ARM_216MHZ)
-	{ 216000000, 12000000, 216000000, 0x050d, 0x2910 }, /* 1/1/2/2/2/8 */
+	{ 216000000, 12000000, 216000000, 0x050d, 0x2910, /* 1/1/2/2/2/8 */
+			CK_16XX },
 #endif
 #if defined(CONFIG_OMAP_ARM_195MHZ)
-	{ 195000000, 13000000, 195000000, 0x050e, 0x2790 }, /* 1/1/2/2/4/8 */
+	{ 195000000, 13000000, 195000000, 0x050e, 0x2790, /* 1/1/2/2/4/8 */
+			CK_7XX|CK_16XX },
 #endif
 #if defined(CONFIG_OMAP_ARM_192MHZ)
-	{ 192000000, 19200000, 192000000, 0x050f, 0x2510 }, /* 1/1/2/2/8/8 */
-	{ 192000000, 12000000, 192000000, 0x050f, 0x2810 }, /* 1/1/2/2/8/8 */
-	{  96000000, 12000000, 192000000, 0x055f, 0x2810 }, /* 2/2/2/2/8/8 */
-	{  48000000, 12000000, 192000000, 0x0baf, 0x2810 }, /* 4/4/4/8/8/8 */
-	{  24000000, 12000000, 192000000, 0x0fff, 0x2810 }, /* 8/8/8/8/8/8 */
+	{ 192000000, 19200000, 192000000, 0x050f, 0x2510, /* 1/1/2/2/8/8 */
+			CK_7XX|CK_16XX },
+	{ 192000000, 12000000, 192000000, 0x050f, 0x2810, /* 1/1/2/2/8/8 */
+			CK_7XX|CK_16XX },
+	{  96000000, 12000000, 192000000, 0x055f, 0x2810, /* 2/2/2/2/8/8 */
+			CK_7XX|CK_16XX },
+	{  48000000, 12000000, 192000000, 0x0baf, 0x2810, /* 4/4/4/8/8/8 */
+			CK_7XX|CK_16XX },
+	{  24000000, 12000000, 192000000, 0x0fff, 0x2810, /* 8/8/8/8/8/8 */
+			CK_7XX|CK_16XX },
 #endif
 #if defined(CONFIG_OMAP_ARM_182MHZ)
-	{ 182000000, 13000000, 182000000, 0x050e, 0x2710 }, /* 1/1/2/2/4/8 */
+	{ 182000000, 13000000, 182000000, 0x050e, 0x2710, /* 1/1/2/2/4/8 */
+			CK_7XX|CK_16XX },
 #endif
 #if defined(CONFIG_OMAP_ARM_168MHZ)
-	{ 168000000, 12000000, 168000000, 0x010f, 0x2710 }, /* 1/1/1/2/8/8 */
+	{ 168000000, 12000000, 168000000, 0x010f, 0x2710, /* 1/1/1/2/8/8 */
+			CK_7XX|CK_16XX },
 #endif
 #if defined(CONFIG_OMAP_ARM_150MHZ)
-	{ 150000000, 12000000, 150000000, 0x010a, 0x2cb0 }, /* 1/1/1/2/4/4 */
+	{ 150000000, 12000000, 150000000, 0x010a, 0x2cb0, /* 1/1/1/2/4/4 */
+			CK_1510|CK_7XX|CK_16XX },
 #endif
 #if defined(CONFIG_OMAP_ARM_120MHZ)
-	{ 120000000, 12000000, 120000000, 0x010a, 0x2510 }, /* 1/1/1/2/4/4 */
+	{ 120000000, 12000000, 120000000, 0x010a, 0x2510, /* 1/1/1/2/4/4 */
+			CK_310|CK_1510|CK_7XX|CK_16XX },
 #endif
 #if defined(CONFIG_OMAP_ARM_96MHZ)
-	{  96000000, 12000000,  96000000, 0x0005, 0x2410 }, /* 1/1/1/1/2/2 */
+	{  96000000, 12000000,  96000000, 0x0005, 0x2410, /* 1/1/1/1/2/2 */
+			CK_310|CK_1510|CK_7XX|CK_16XX },
 #endif
 #if defined(CONFIG_OMAP_ARM_60MHZ)
-	{  60000000, 12000000,  60000000, 0x0005, 0x2290 }, /* 1/1/1/1/2/2 */
+	{  60000000, 12000000,  60000000, 0x0005, 0x2290, /* 1/1/1/1/2/2 */
+			CK_310|CK_1510|CK_7XX|CK_16XX },
 #endif
 #if defined(CONFIG_OMAP_ARM_30MHZ)
-	{  30000000, 12000000,  60000000, 0x0555, 0x2290 }, /* 2/2/2/2/2/2 */
+	{  30000000, 12000000,  60000000, 0x0555, 0x2290, /* 2/2/2/2/2/2 */
+			CK_310|CK_1510|CK_7XX|CK_16XX },
 #endif
 	{ 0, 0, 0, 0, 0 },
 };
-- 
1.7.3.4

