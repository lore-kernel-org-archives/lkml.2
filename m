Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2AVADr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:03:47 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37100 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2AVACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:02:14 -0500
MBOX-Line: From nobody Sat Jan 21 16:59:33 2012
Subject: [PATCH 4/8] ARM: OMAP3: hwmod data: add HDQ/1-wire hwmod
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
Date: Sat, 21 Jan 2012 16:59:33 -0700
Message-ID: <20120121235933.17619.66308.stgit@dusk>
In-Reply-To: <20120121235333.17619.56725.stgit@dusk>
References: <20120121235333.17619.56725.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the HDQ1W hwmod for OMAP34xx, OMAP36xx, and AM3505/3517 devices.
According to the respective TRMs, it doesn't appear to be available for the
816x/814x or the AM335x.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   39 ++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 5324e8d..dd155c4 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -2,6 +2,7 @@
  * omap_hwmod_3xxx_data.c - hardware modules present on the OMAP3xxx chips
  *
  * Copyright (C) 2009-2011 Nokia Corporation
+ * Copyright (C) 2012 Texas Instruments, Inc.
  * Paul Walmsley
  *
  * This program is free software; you can redistribute it and/or modify
@@ -86,6 +87,7 @@ static struct omap_hwmod omap3xxx_mcbsp2_sidetone_hwmod;
 static struct omap_hwmod omap3xxx_mcbsp3_sidetone_hwmod;
 static struct omap_hwmod omap3xxx_usb_host_hs_hwmod;
 static struct omap_hwmod omap3xxx_usb_tll_hs_hwmod;
+static struct omap_hwmod omap3xxx_hdq1w_hwmod;
 
 /* L3 -> L4_CORE interface */
 static struct omap_hwmod_ocp_if omap3xxx_l3_main__l4_core = {
@@ -230,6 +232,16 @@ static struct omap_hwmod_ocp_if omap3xxx_l4_core__mmc3 = {
 	.flags		= OMAP_FIREWALL_L4
 };
 
+/* L4 CORE -> HDQ1W interface */
+static struct omap_hwmod_ocp_if omap3xxx_l4_core__hdq1w = {
+	.master		= &omap3xxx_l4_core_hwmod,
+	.slave		= &omap3xxx_hdq1w_hwmod,
+	.clk		= "hdq_ick",
+	.addr		= omap2_hdq1w_addr_space,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+	.flags		= OMAP_FIREWALL_L4
+};
+
 /* L4 CORE -> UART1 interface */
 static struct omap_hwmod_addr_space omap3xxx_uart1_addr_space[] = {
 	{
@@ -3498,6 +3510,30 @@ static struct omap_hwmod omap3xxx_usb_tll_hs_hwmod = {
 	.slaves_cnt	= ARRAY_SIZE(omap3xxx_usb_tll_hs_slaves),
 };
 
+/* HDQ1W/1-wire */
+
+static struct omap_hwmod_ocp_if *omap3xxx_hdq1w_slaves[] = {
+	&omap3xxx_l4_core__hdq1w,
+};
+
+static struct omap_hwmod omap3xxx_hdq1w_hwmod = {
+	.name		= "hdq1w",
+	.mpu_irqs	= omap2_hdq1w_mpu_irqs,
+	.main_clk	= "hdq_fck",
+	.prcm		= {
+		.omap2 = {
+			.module_offs = CORE_MOD,
+			.prcm_reg_id = 1,
+			.module_bit = OMAP3430_EN_HDQ_SHIFT,
+			.idlest_reg_id = 1,
+			.idlest_idle_bit = OMAP3430_ST_HDQ_SHIFT,
+		},
+	},
+	.slaves		= omap3xxx_hdq1w_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap3xxx_hdq1w_slaves),
+	.class		= &omap2_hdq1w_class,
+};
+
 static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	&omap3xxx_l3_main_hwmod,
 	&omap3xxx_l4_core_hwmod,
@@ -3605,6 +3641,7 @@ static __initdata struct omap_hwmod *omap34xx_hwmods[] = {
 	&omap34xx_sr1_hwmod,
 	&omap34xx_sr2_hwmod,
 	&omap3xxx_mailbox_hwmod,
+	&omap3xxx_hdq1w_hwmod,
 	NULL
 };
 
@@ -3621,6 +3658,7 @@ static __initdata struct omap_hwmod *omap36xx_hwmods[] = {
 	&omap3xxx_usb_tll_hs_hwmod,
 	&omap3xxx_es3plus_mmc1_hwmod,
 	&omap3xxx_es3plus_mmc2_hwmod,
+	&omap3xxx_hdq1w_hwmod,
 	NULL
 };
 
@@ -3632,6 +3670,7 @@ static __initdata struct omap_hwmod *am35xx_hwmods[] = {
 	&omap3xxx_usb_tll_hs_hwmod,
 	&omap3xxx_es3plus_mmc1_hwmod,
 	&omap3xxx_es3plus_mmc2_hwmod,
+	&omap3xxx_hdq1w_hwmod,
 	NULL
 };
 


