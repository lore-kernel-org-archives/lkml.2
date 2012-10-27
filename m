Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2J0SuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 14:50:07 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35896 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932330Ab2J0SuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 14:50:06 -0400
From: Constantine Shulyupin <const@MakeLinux.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        tim.bird@am.sony.com, pandaboard@googlegroups.com,
        Tony Lindgren OMAP <tony@atomide.com>,
        Santosh Shilimkar OMAP <santosh.shilimkar@ti.com>, nsekhar@ti.com,
        balbi@ti.com, Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH] Add FDT support to Pandaboard initialization
Date: Sat, 27 Oct 2012 20:50:00 +0200
Message-Id: <1351363800-28744-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 84.229.179.154 authed with poster@makelinux.net}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Problem:
- FDT is supported only by generic OMAP board initialization in arch/arm/mach-omap2/board-generic.c and lacks some configurations, which are not yet configured in FDT (USB for example).
Solution:
- arch/arm/mach-omap2/board-omap4panda.c supports initialization with FDT and without it.

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 arch/arm/mach-omap2/board-omap4panda.c |   33 ++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index bfcd397..fea7a83 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -31,6 +31,7 @@
 #include <linux/ti_wilink_st.h>
 #include <linux/wl12xx.h>
 #include <linux/platform_data/omap-abe-twl6040.h>
+#include <linux/of_platform.h>
 
 #include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
@@ -526,3 +527,35 @@ MACHINE_START(OMAP4_PANDA, "OMAP4 Panda board")
 	.timer		= &omap4_timer,
 	.restart	= omap_prcm_restart,
 MACHINE_END
+
+static struct of_device_id omap_dt_match_table[] __initdata = {
+	{ .compatible = "simple-bus", },
+	{ .compatible = "ti,omap-infra", },
+	{ }
+};
+
+static void __init panda_dt_init(void)
+{
+	of_platform_populate(NULL, omap_dt_match_table, NULL, NULL);
+	omap4_panda_init();
+}
+
+static const char *omap4_panda_compat[] __initdata = {
+	"ti,omap4-panda",
+	"ti,omap4",
+	NULL,
+};
+
+DT_MACHINE_START(OMAP4_PANDA_DT, "OMAP4 Pandaboard with FDT support")
+	.dt_compat	= omap4_panda_compat,
+	.reserve	= omap_reserve,
+	.smp		= smp_ops(omap4_smp_ops),
+	.map_io		= omap4_map_io,
+	.init_early	= omap4430_init_early,
+	.init_irq	= omap_gic_of_init,
+	.handle_irq	= gic_handle_irq,
+	.init_machine	= panda_dt_init,
+	.init_late	= omap4430_init_late,
+	.timer		= &omap4_timer,
+	.restart	= omap_prcm_restart,
+MACHINE_END
-- 
1.7.9.5

