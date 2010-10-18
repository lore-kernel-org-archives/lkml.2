Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0JRHuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:50:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37682 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab0JRHuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:50:37 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 2/3] OMAP4: hwmod data: Add hwspinlock
Date: Mon, 18 Oct 2010 09:44:34 +0200
Message-Id: <1287387875-14168-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287387875-14168-1-git-send-email-ohad@wizery.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Cousson <b-cousson@ti.com>

Add hwspinlock hwmod data for OMAP4 chip

Signed-off-by: Cousson, Benoit <b-cousson@ti.com>
Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   63 ++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 0d5c6eb..07c3654 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -1043,6 +1043,66 @@ static struct omap_hwmod omap44xx_uart4_hwmod = {
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
 };
 
+/*
+ * 'spinlock' class
+ * spinlock provides hardware assistance for synchronizing the processes
+ * running on multiple processors
+ */
+
+static struct omap_hwmod_class_sysconfig omap44xx_spinlock_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_CLOCKACTIVITY |
+			   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SIDLEMODE |
+			   SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap44xx_spinlock_hwmod_class = {
+	.name = "spinlock",
+	.sysc = &omap44xx_spinlock_sysc,
+};
+
+/* spinlock */
+static struct omap_hwmod omap44xx_spinlock_hwmod;
+static struct omap_hwmod_addr_space omap44xx_spinlock_addrs[] = {
+	{
+		.pa_start	= 0x4a0f6000,
+		.pa_end		= 0x4a0f6fff,
+		.flags		= ADDR_TYPE_RT
+	},
+};
+
+/* l4_cfg -> spinlock */
+static struct omap_hwmod_ocp_if omap44xx_l4_cfg__spinlock = {
+	.master		= &omap44xx_l4_cfg_hwmod,
+	.slave		= &omap44xx_spinlock_hwmod,
+	.clk		= "l4_div_ck",
+	.addr		= omap44xx_spinlock_addrs,
+	.addr_cnt	= ARRAY_SIZE(omap44xx_spinlock_addrs),
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* spinlock slave ports */
+static struct omap_hwmod_ocp_if *omap44xx_spinlock_slaves[] = {
+	&omap44xx_l4_cfg__spinlock,
+};
+
+static struct omap_hwmod omap44xx_spinlock_hwmod = {
+	.name		= "spinlock",
+	.class		= &omap44xx_spinlock_hwmod_class,
+	.prcm = {
+		.omap4 = {
+			.clkctrl_reg = OMAP4430_CM_L4CFG_HW_SEM_CLKCTRL,
+		},
+	},
+	.slaves		= omap44xx_spinlock_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap44xx_spinlock_slaves),
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP4430),
+};
+
 static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	/* dmm class */
 	&omap44xx_dmm_hwmod,
@@ -1077,6 +1137,9 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	&omap44xx_uart2_hwmod,
 	&omap44xx_uart3_hwmod,
 	&omap44xx_uart4_hwmod,
+
+	/* spinlock class */
+	&omap44xx_spinlock_hwmod,
 	NULL,
 };
 
-- 
1.7.0.4

