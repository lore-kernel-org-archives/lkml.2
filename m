Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab2AVACo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:02:44 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37105 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2AVACP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:02:15 -0500
MBOX-Line: From nobody Sat Jan 21 16:59:34 2012
Subject: [PATCH 6/8] ARM: OMAP4: hwmod data: add HDQ/1-wire hwmod
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: =?utf-8?q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>
Date: Sat, 21 Jan 2012 16:59:34 -0700
Message-ID: <20120121235934.17619.74939.stgit@dusk>
In-Reply-To: <20120121235333.17619.56725.stgit@dusk>
References: <20120121235333.17619.56725.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the hwmod data for the HDQ/1-wire hwmod ('hdq1w').  The scripts have been
updated.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Benoît Cousson <b-cousson@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   74 ++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index f9f1510..0f79ec8 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -1,7 +1,7 @@
 /*
  * Hardware modules present on the OMAP44xx chips
  *
- * Copyright (C) 2009-2011 Texas Instruments, Inc.
+ * Copyright (C) 2009-2012 Texas Instruments, Inc.
  * Copyright (C) 2009-2010 Nokia Corporation
  *
  * Paul Walmsley
@@ -31,6 +31,7 @@
 #include <plat/i2c.h>
 #include <plat/dmtimer.h>
 #include <plat/common.h>
+#include <plat/hdq1w.h>
 
 #include "omap_hwmod_common_data.h"
 
@@ -72,6 +73,7 @@ static struct omap_hwmod omap44xx_mpu_private_hwmod;
 static struct omap_hwmod omap44xx_usb_otg_hs_hwmod;
 static struct omap_hwmod omap44xx_usb_host_hs_hwmod;
 static struct omap_hwmod omap44xx_usb_tll_hs_hwmod;
+static struct omap_hwmod omap44xx_hdq1w_hwmod;
 
 /*
  * Interconnects omap_hwmod structures
@@ -2157,6 +2159,73 @@ static struct omap_hwmod omap44xx_gpio6_hwmod = {
 };
 
 /*
+ * 'hdq1w' class
+ * hdq / 1-wire serial interface controller
+ */
+
+static struct omap_hwmod_class_sysconfig omap44xx_hdq1w_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0014,
+	.syss_offs	= 0x0018,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_SOFTRESET |
+			   SYSS_HAS_RESET_STATUS),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap44xx_hdq1w_hwmod_class = {
+	.name	= "hdq1w",
+	.sysc	= &omap44xx_hdq1w_sysc,
+	.reset	= &omap_hdq1w_reset,
+};
+
+/* hdq1w */
+static struct omap_hwmod omap44xx_hdq1w_hwmod;
+static struct omap_hwmod_irq_info omap44xx_hdq1w_irqs[] = {
+	{ .irq = 58 + OMAP44XX_IRQ_GIC_START },
+	{ .irq = -1 }
+};
+
+static struct omap_hwmod_addr_space omap44xx_hdq1w_addrs[] = {
+	{
+		.pa_start	= 0x480b2000,
+		.pa_end		= 0x480b201f,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+/* l4_per -> hdq1w */
+static struct omap_hwmod_ocp_if omap44xx_l4_per__hdq1w = {
+	.master		= &omap44xx_l4_per_hwmod,
+	.slave		= &omap44xx_hdq1w_hwmod,
+	.clk		= "l4_div_ck",
+	.addr		= omap44xx_hdq1w_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* hdq1w slave ports */
+static struct omap_hwmod_ocp_if *omap44xx_hdq1w_slaves[] = {
+	&omap44xx_l4_per__hdq1w,
+};
+
+static struct omap_hwmod omap44xx_hdq1w_hwmod = {
+	.name		= "hdq1w",
+	.class		= &omap44xx_hdq1w_hwmod_class,
+	.clkdm_name	= "l4_per_clkdm",
+	.mpu_irqs	= omap44xx_hdq1w_irqs,
+	.main_clk	= "func_12m_fclk",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_L4PER_HDQ1W_CLKCTRL_OFFSET,
+			.context_offs = OMAP4_RM_L4PER_HDQ1W_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+	.slaves		= omap44xx_hdq1w_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap44xx_hdq1w_slaves),
+};
+
+/*
  * 'hsi' class
  * mipi high-speed synchronous serial interface (multichannel and full-duplex
  * serial if)
@@ -5539,6 +5608,9 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	&omap44xx_gpio5_hwmod,
 	&omap44xx_gpio6_hwmod,
 
+	/* hdq1w class */
+	&omap44xx_hdq1w_hwmod,
+
 	/* hsi class */
 /*	&omap44xx_hsi_hwmod, */
 


