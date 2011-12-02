Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab1LBPD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:03:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50219 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1LBPDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:03:24 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 1/7] omap4: introduce fdif(face detect module) hwmod
Date: Fri,  2 Dec 2011 23:02:46 +0800
Message-Id: <1322838172-11149-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   81 ++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 6cf21ee..30db754 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -53,6 +53,7 @@ static struct omap_hwmod omap44xx_dmm_hwmod;
 static struct omap_hwmod omap44xx_dsp_hwmod;
 static struct omap_hwmod omap44xx_dss_hwmod;
 static struct omap_hwmod omap44xx_emif_fw_hwmod;
+static struct omap_hwmod omap44xx_fdif_hwmod;
 static struct omap_hwmod omap44xx_hsi_hwmod;
 static struct omap_hwmod omap44xx_ipu_hwmod;
 static struct omap_hwmod omap44xx_iss_hwmod;
@@ -354,6 +355,14 @@ static struct omap_hwmod_ocp_if omap44xx_dma_system__l3_main_2 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* fdif -> l3_main_2 */
+static struct omap_hwmod_ocp_if omap44xx_fdif__l3_main_2 = {
+	.master		= &omap44xx_fdif_hwmod,
+	.slave		= &omap44xx_l3_main_2_hwmod,
+	.clk		= "l3_div_ck",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* hsi -> l3_main_2 */
 static struct omap_hwmod_ocp_if omap44xx_hsi__l3_main_2 = {
 	.master		= &omap44xx_hsi_hwmod,
@@ -5444,6 +5453,75 @@ static struct omap_hwmod omap44xx_wd_timer3_hwmod = {
 	.slaves_cnt	= ARRAY_SIZE(omap44xx_wd_timer3_slaves),
 };
 
+/* 'fdif' class */
+static struct omap_hwmod_class_sysconfig omap44xx_fdif_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_RESET_STATUS |
+			   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   MSTANDBY_FORCE | MSTANDBY_NO |
+			   MSTANDBY_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class omap44xx_fdif_hwmod_class = {
+	.name	= "fdif",
+	.sysc	= &omap44xx_fdif_sysc,
+};
+
+/*fdif*/
+static struct omap_hwmod_addr_space omap44xx_fdif_addrs[] = {
+	{
+		.pa_start	= 0x4a10a000,
+		.pa_end		= 0x4a10afff,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+/* l4_cfg -> fdif */
+static struct omap_hwmod_ocp_if omap44xx_l4_cfg__fdif = {
+	.master		= &omap44xx_l4_cfg_hwmod,
+	.slave		= &omap44xx_fdif_hwmod,
+	.clk		= "l4_div_ck",
+	.addr		= omap44xx_fdif_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* fdif slave ports */
+static struct omap_hwmod_ocp_if *omap44xx_fdif_slaves[] = {
+	&omap44xx_l4_cfg__fdif,
+};
+static struct omap_hwmod_irq_info omap44xx_fdif_irqs[] = {
+	{ .irq = 69 + OMAP44XX_IRQ_GIC_START },
+	{ .irq = -1 }
+};
+
+/* fdif master ports */
+static struct omap_hwmod_ocp_if *omap44xx_fdif_masters[] = {
+	&omap44xx_fdif__l3_main_2,
+};
+
+static struct omap_hwmod omap44xx_fdif_hwmod = {
+	.name		= "fdif",
+	.class		= &omap44xx_fdif_hwmod_class,
+	.clkdm_name	= "iss_clkdm",
+	.mpu_irqs	= omap44xx_fdif_irqs,
+	.main_clk	= "fdif_fck",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_CAM_FDIF_CLKCTRL_OFFSET,
+			.context_offs = OMAP4_RM_CAM_FDIF_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+	.slaves		= omap44xx_fdif_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap44xx_fdif_slaves),
+	.masters	= omap44xx_fdif_masters,
+	.masters_cnt	= ARRAY_SIZE(omap44xx_fdif_masters),
+};
+
 static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 
 	/* dmm class */
@@ -5593,6 +5671,9 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	&omap44xx_wd_timer2_hwmod,
 	&omap44xx_wd_timer3_hwmod,
 
+	/* fdif class */
+	&omap44xx_fdif_hwmod,
+
 	NULL,
 };
 
-- 
1.7.5.4

