Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab2JXNuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:50:19 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:49022 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab2JXNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:50:16 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/2] arm: mvebu: increase atomic coherent pool size for armada 370/XP
Date: Wed, 24 Oct 2012 15:49:20 +0200
Message-Id: <1351086561-13569-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Armada 370/XP we have the same problem that for the commit
cb01b63, so we applied the same solution: "The default 256 KiB
coherent pool may be too small for some of the Kirkwood devices, so
increase it to make sure that devices will be able to allocate their
buffers with GFP_ATOMIC flag"

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-mvebu/armada-370-xp.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
index 2af6ce5..cbad821 100644
--- a/arch/arm/mach-mvebu/armada-370-xp.c
+++ b/arch/arm/mach-mvebu/armada-370-xp.c
@@ -17,6 +17,7 @@
 #include <linux/of_platform.h>
 #include <linux/io.h>
 #include <linux/time-armada-370-xp.h>
+#include <linux/dma-mapping.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
@@ -43,6 +44,16 @@ void __init armada_370_xp_timer_and_clk_init(void)
 	armada_370_xp_timer_init();
 }
 
+void __init armada_370_xp_init_early(void)
+{
+	/*
+	 * Some Armada 370/XP devices allocate their coherent buffers
+	 * from atomic context. Increase size of atomic coherent pool
+	 * to make sure such the allocations won't fail.
+	 */
+	init_dma_coherent_pool_size(SZ_1M);
+}
+
 struct sys_timer armada_370_xp_timer = {
 	.init		= armada_370_xp_timer_and_clk_init,
 };
@@ -61,6 +72,7 @@ static const char * const armada_370_xp_dt_board_dt_compat[] = {
 DT_MACHINE_START(ARMADA_XP_DT, "Marvell Aramada 370/XP (Device Tree)")
 	.init_machine	= armada_370_xp_dt_init,
 	.map_io		= armada_370_xp_map_io,
+	.init_early	= armada_370_xp_init_early,
 	.init_irq	= armada_370_xp_init_irq,
 	.handle_irq     = armada_370_xp_handle_irq,
 	.timer		= &armada_370_xp_timer,
-- 
1.7.9.5

