Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2AVACp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:02:45 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37103 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2AVACP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:02:15 -0500
MBOX-Line: From nobody Sat Jan 21 16:59:34 2012
Subject: [PATCH 5/8] ARM: OMAP2xxx: hwmod data: add HDQ/1-wire hwmod
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Date: Sat, 21 Jan 2012 16:59:34 -0700
Message-ID: <20120121235933.17619.56181.stgit@dusk>
In-Reply-To: <20120121235333.17619.56725.stgit@dusk>
References: <20120121235333.17619.56725.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the HDQ1W hwmod for all OMAP2xxx devices.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_2420_data.c |   41 ++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_2430_data.c |   38 ++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_2420_data.c b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
index a5409ce..dad4a87 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2420_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
@@ -2,6 +2,7 @@
  * omap_hwmod_2420_data.c - hardware modules present on the OMAP2420 chips
  *
  * Copyright (C) 2009-2011 Nokia Corporation
+ * Copyright (C) 2012 Texas Instruments, Inc.
  * Paul Walmsley
  *
  * This program is free software; you can redistribute it and/or modify
@@ -54,6 +55,7 @@ static struct omap_hwmod omap2420_gpio4_hwmod;
 static struct omap_hwmod omap2420_dma_system_hwmod;
 static struct omap_hwmod omap2420_mcspi1_hwmod;
 static struct omap_hwmod omap2420_mcspi2_hwmod;
+static struct omap_hwmod omap2420_hdq1w_hwmod;
 
 /* L3 -> L4_CORE interface */
 static struct omap_hwmod_ocp_if omap2420_l3_main__l4_core = {
@@ -182,6 +184,17 @@ static struct omap_hwmod_ocp_if omap2420_l4_core__i2c2 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* L4 CORE -> HDQ1W interface */
+static struct omap_hwmod_ocp_if omap2420_l4_core__hdq1w = {
+	.master		= &omap2420_l4_core_hwmod,
+	.slave		= &omap2420_hdq1w_hwmod,
+	.clk		= "hdq_ick",
+	.addr		= omap2_hdq1w_addr_space,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+	.flags		= OMAP_FIREWALL_L4
+};
+
+
 /* Slave interfaces on the L4_CORE interconnect */
 static struct omap_hwmod_ocp_if *omap2420_l4_core_slaves[] = {
 	&omap2420_l3_main__l4_core,
@@ -1513,6 +1526,30 @@ static struct omap_hwmod omap2420_mcbsp2_hwmod = {
 	.slaves_cnt	= ARRAY_SIZE(omap2420_mcbsp2_slaves),
 };
 
+/* HDQ1W/1-wire */
+
+static struct omap_hwmod_ocp_if *omap2420_hdq1w_slaves[] = {
+	&omap2420_l4_core__hdq1w,
+};
+
+static struct omap_hwmod omap2420_hdq1w_hwmod = {
+	.name		= "hdq1w",
+	.mpu_irqs	= omap2_hdq1w_mpu_irqs,
+	.main_clk	= "hdq_fck",
+	.prcm		= {
+		.omap2 = {
+			.module_offs = CORE_MOD,
+			.prcm_reg_id = 1,
+			.module_bit = OMAP24XX_EN_HDQ_SHIFT,
+			.idlest_reg_id = 1,
+			.idlest_idle_bit = OMAP24XX_ST_HDQ_SHIFT,
+		},
+	},
+	.slaves		= omap2420_hdq1w_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap2420_hdq1w_slaves),
+	.class		= &omap2_hdq1w_class,
+};
+
 static __initdata struct omap_hwmod *omap2420_hwmods[] = {
 	&omap2420_l3_main_hwmod,
 	&omap2420_l4_core_hwmod,
@@ -1565,6 +1602,10 @@ static __initdata struct omap_hwmod *omap2420_hwmods[] = {
 	/* mcspi class */
 	&omap2420_mcspi1_hwmod,
 	&omap2420_mcspi2_hwmod,
+
+	/* hdq1w class */
+	&omap2420_hdq1w_hwmod,
+
 	NULL,
 };
 
diff --git a/arch/arm/mach-omap2/omap_hwmod_2430_data.c b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
index c4f56cb..592b0b2 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2430_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
@@ -64,6 +64,7 @@ static struct omap_hwmod omap2430_mcspi2_hwmod;
 static struct omap_hwmod omap2430_mcspi3_hwmod;
 static struct omap_hwmod omap2430_mmc1_hwmod;
 static struct omap_hwmod omap2430_mmc2_hwmod;
+static struct omap_hwmod omap2430_hdq1w_hwmod;
 
 /* L3 -> L4_CORE interface */
 static struct omap_hwmod_ocp_if omap2430_l3_main__l4_core = {
@@ -291,6 +292,16 @@ static struct omap_hwmod_ocp_if omap2430_l4_core__mcspi3 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* L4 CORE -> HDQ1W interface */
+static struct omap_hwmod_ocp_if omap2430_l4_core__hdq1w = {
+	.master		= &omap2430_l4_core_hwmod,
+	.slave		= &omap2430_hdq1w_hwmod,
+	.clk		= "hdq_ick",
+	.addr		= omap2_hdq1w_addr_space,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+	.flags		= OMAP_FIREWALL_L4,
+};
+
 /* L4 WKUP */
 static struct omap_hwmod omap2430_l4_wkup_hwmod = {
 	.name		= "l4_wkup",
@@ -2001,6 +2012,30 @@ static struct omap_hwmod omap2430_mmc2_hwmod = {
 	.class		= &omap2430_mmc_class,
 };
 
+/* HDQ1W/1-wire */
+
+static struct omap_hwmod_ocp_if *omap2430_hdq1w_slaves[] = {
+	&omap2430_l4_core__hdq1w,
+};
+
+static struct omap_hwmod omap2430_hdq1w_hwmod = {
+	.name		= "hdq1w",
+	.mpu_irqs	= omap2_hdq1w_mpu_irqs,
+	.main_clk	= "hdq_fck",
+	.prcm		= {
+		.omap2 = {
+			.module_offs = CORE_MOD,
+			.prcm_reg_id = 1,
+			.module_bit = OMAP24XX_EN_HDQ_SHIFT,
+			.idlest_reg_id = 1,
+			.idlest_idle_bit = OMAP24XX_ST_HDQ_SHIFT,
+		},
+	},
+	.slaves		= omap2430_hdq1w_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap2430_hdq1w_slaves),
+	.class		= &omap2_hdq1w_class,
+};
+
 static __initdata struct omap_hwmod *omap2430_hwmods[] = {
 	&omap2430_l3_main_hwmod,
 	&omap2430_l4_core_hwmod,
@@ -2064,6 +2099,9 @@ static __initdata struct omap_hwmod *omap2430_hwmods[] = {
 	/* usbotg class*/
 	&omap2430_usbhsotg_hwmod,
 
+	/* hdq1w class */
+	&omap2430_hdq1w_hwmod,
+
 	NULL,
 };
 


