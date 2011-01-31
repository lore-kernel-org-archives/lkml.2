Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1AaKeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:34:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44200 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab1AaKeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:34:11 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul@pwsan.com>,
        Hari Kanigeri <hari.kanigeri@gmail.com>,
        Simon Que <simonque@gmail.com>
Subject: [PATCH v4 3/4] OMAP4: hwmod data: Add hwspinlock
Date: Mon, 31 Jan 2011 12:33:43 +0200
Message-Id: <1296470024-26854-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296470024-26854-1-git-send-email-ohad@wizery.com>
References: <1296470024-26854-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Cousson <b-cousson@ti.com>

Add hwspinlock hwmod data for OMAP4 chip

Signed-off-by: Cousson, Benoit <b-cousson@ti.com>
Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Paul Walmsley <paul@pwsan.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   63 ++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index c2806bd..e1c8e6d 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -2001,6 +2001,66 @@ static struct omap_hwmod omap44xx_wd_timer3_hwmod = {
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
@@ -2068,6 +2128,9 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	&omap44xx_wd_timer2_hwmod,
 	&omap44xx_wd_timer3_hwmod,
 
+
+	/* spinlock class */
+	&omap44xx_spinlock_hwmod,
 	NULL,
 };
 
-- 
1.7.1

