Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1ILCFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 22:05:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:39376 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1ILCFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 22:05:07 -0400
Date: Mon, 12 Sep 2011 12:05:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20110912120501.764336af05069fa23a371b5e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-msm/board-msm8x60.c between commit 9e775ad19f52 ("ARM:
7012/1: Set proper TEXT_OFFSET for newer MSMs") from the arm tree and
commit 56e2d8a68803 ("ARM: msm: Add devicetree support for msm8660-surf")
from the arm-soc tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-msm/board-msm8x60.c
index 9221f54,10fa8f6..0000000
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@@ -20,7 -14,10 +14,11 @@@
  #include <linux/platform_device.h>
  #include <linux/io.h>
  #include <linux/irq.h>
 +#include <linux/memblock.h>
+ #include <linux/irqdomain.h>
+ #include <linux/of.h>
+ #include <linux/of_address.h>
+ #include <linux/of_platform.h>
  
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>
@@@ -81,9 -62,42 +79,44 @@@ static void __init msm8x60_init(void
  {
  }
  
+ #ifdef CONFIG_OF
+ static struct of_dev_auxdata msm_auxdata_lookup[] __initdata = {
+ 	{}
+ };
+ 
+ static struct of_device_id msm_dt_gic_match[] __initdata = {
+ 	{ .compatible = "qcom,msm-8660-qgic", },
+ 	{}
+ };
+ 
+ static void __init msm8x60_dt_init(void)
+ {
+ 	struct device_node *node;
+ 
+ 	node = of_find_matching_node_by_address(NULL, msm_dt_gic_match,
+ 			MSM8X60_QGIC_DIST_PHYS);
+ 	if (node)
+ 		irq_domain_add_simple(node, GIC_SPI_START);
+ 
+ 	if (of_machine_is_compatible("qcom,msm8660-surf")) {
+ 		printk(KERN_INFO "Init surf UART registers\n");
+ 		msm8x60_init_uart12dm();
+ 	}
+ 
+ 	of_platform_populate(NULL, of_default_bus_match_table,
+ 			msm_auxdata_lookup, NULL);
+ }
+ 
+ static const char *msm8x60_fluid_match[] __initdata = {
+ 	"qcom,msm8660-fluid",
+ 	"qcom,msm8660-surf",
+ 	NULL
+ };
+ #endif /* CONFIG_OF */
+ 
  MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
 +	.fixup = msm8x60_fixup,
 +	.reserve = msm8x60_reserve,
  	.map_io = msm8x60_map_io,
  	.init_irq = msm8x60_init_irq,
  	.init_machine = msm8x60_init,
