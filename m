Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1JJTYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:24:24 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:59342 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1JJTYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:24:22 -0400
Date: Mon, 10 Oct 2011 13:24:21 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Tero Kristo <t-kristo@ti.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
In-Reply-To: <1316781986-30642-4-git-send-email-t-kristo@ti.com>
Message-ID: <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tero

On Fri, 23 Sep 2011, Tero Kristo wrote:

> This patch is temporary until Paul can provide a final version.
> 
> Signed-off-by: Tero Kristo <t-kristo@ti.com>

Here's an updated version of this one.  The one change is that the hwmod's 
name is now "prm3xxx" to reflect that the register layout of this IP block 
is quite different from its OMAP2 predecessors and OMAP4 successors.  
This should avoid some of the special-purpose driver probing code.


- Paul

From: Paul Walmsley <paul@pwsan.com>
Date: Mon, 10 Oct 2011 13:11:11 -0600
Subject: [PATCH] OMAP3xxx: hwmod data: add PRM hwmod

Add a hwmod for the Power & Reset Management (PRM) IP block that is
present on OMAP3xxx SoCs.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   62 ++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index ab35acb..382fad9 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -160,6 +160,7 @@ static struct omap_hwmod omap3xxx_l3_main_hwmod = {
 };
 
 static struct omap_hwmod omap3xxx_l4_wkup_hwmod;
+static struct omap_hwmod omap3xxx_prm_hwmod;
 static struct omap_hwmod omap3xxx_uart1_hwmod;
 static struct omap_hwmod omap3xxx_uart2_hwmod;
 static struct omap_hwmod omap3xxx_uart3_hwmod;
@@ -475,6 +476,29 @@ static struct omap_hwmod omap3xxx_l4_per_hwmod = {
 	.flags		= HWMOD_NO_IDLEST,
 };
 
+static struct omap_hwmod_addr_space omap3xxx_prm_addrs[] = {
+	{
+		.pa_start	= 0x48306000,
+		.pa_end		= 0x48306000 + SZ_8K + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+/* L4_WKUP -> PRM interface */
+static struct omap_hwmod_ocp_if omap3xxx_l4_wkup__prm = {
+	.master		= &omap3xxx_l4_wkup_hwmod,
+	.slave		= &omap3xxx_prm_hwmod,
+	.clk		= "wkup_l4_ick",
+	.addr		= omap3xxx_prm_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+/* Master interfaces on the L4_WKUP interconnect */
+static struct omap_hwmod_ocp_if *omap3xxx_l4_wkup_masters[] = {
+	&omap3xxx_l4_wkup__prm,
+};
+
 /* Slave interfaces on the L4_WKUP interconnect */
 static struct omap_hwmod_ocp_if *omap3xxx_l4_wkup_slaves[] = {
 	&omap3xxx_l4_core__l4_wkup,
@@ -484,11 +508,46 @@ static struct omap_hwmod_ocp_if *omap3xxx_l4_wkup_slaves[] = {
 static struct omap_hwmod omap3xxx_l4_wkup_hwmod = {
 	.name		= "l4_wkup",
 	.class		= &l4_hwmod_class,
+	.masters	= omap3xxx_l4_wkup_masters,
+	.masters_cnt	= ARRAY_SIZE(omap3xxx_l4_wkup_masters),
 	.slaves		= omap3xxx_l4_wkup_slaves,
 	.slaves_cnt	= ARRAY_SIZE(omap3xxx_l4_wkup_slaves),
 	.flags		= HWMOD_NO_IDLEST,
 };
 
+/* Slave interfaces on the L4_WKUP interconnect */
+static struct omap_hwmod_ocp_if *omap3xxx_prm_slaves[] = {
+	&omap3xxx_l4_wkup__prm,
+};
+
+static struct omap_hwmod_class_sysconfig omap3xxx_prm_sysc = {
+	.rev_offs	= 0x0804,
+	.sysc_offs	= 0x0814,
+	.sysc_flags	= SYSC_HAS_AUTOIDLE,
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap3xxx_prm_hwmod_class = {
+	.name		= "prm",
+	.sysc		= &omap3xxx_prm_sysc,
+};
+
+static struct omap_hwmod_irq_info omap3xxx_prm_irqs[] = {
+	{ .irq = 11 },
+	{ .irq = -1 }
+};
+
+/* PRM */
+static struct omap_hwmod omap3xxx_prm_hwmod = {
+	.name		= "prm3xxx",
+	.mpu_irqs	= omap3xxx_prm_irqs,
+	.class		= &omap3xxx_prm_hwmod_class,
+	.main_clk	= "wkup_32k_fck",
+	.slaves		= omap3xxx_prm_slaves,
+	.slaves_cnt	= ARRAY_SIZE(omap3xxx_prm_slaves),
+	.flags		= HWMOD_NO_IDLEST,
+};
+
 /* Master interfaces on the MPU device */
 static struct omap_hwmod_ocp_if *omap3xxx_mpu_masters[] = {
 	&omap3xxx_mpu__l3_main,
@@ -3128,6 +3187,9 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	&omap3xxx_l4_core_hwmod,
 	&omap3xxx_l4_per_hwmod,
 	&omap3xxx_l4_wkup_hwmod,
+
+	&omap3xxx_prm_hwmod,
+
 	&omap3xxx_mmc1_hwmod,
 	&omap3xxx_mmc2_hwmod,
 	&omap3xxx_mmc3_hwmod,
-- 
1.7.6.3

