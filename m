Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021Ab2COJut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:50:49 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:60806 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2COJup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:50:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with Linus' tree
Date: Thu, 15 Mar 2012 10:51:06 +0100
Message-ID: <1362815.uO65s14ojU@avalon>
User-Agent: KMail/4.8.0 (Linux/3.2.1-gentoo-r2; KDE/4.8.0; x86_64; ; )
In-Reply-To: <20120315175000.897f1172c296d4a687be0537@canb.auug.org.au>
References: <20120315175000.897f1172c296d4a687be0537@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thursday 15 March 2012 17:50:00 Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-shmobile/board-mackerel.c between commit 1740d3448012
> ("ARM: mach-shmobile: mackerel: Reserve DMA memory for the frame buffer")
> from Linus' tree and commit 5d7220ec000f ("ARM: mach-shmobile: sh7372
> map_io and init_early update") from the arm-soc tree.
> 
> The latter moved the code to another file
> arch/arm/mach-shmobile/setup-sh7372.c and I have no idea how to fix this
> up, so I just removed the change done by the former.

The following patch (5d7220ec000f rebased on top of 1740d3448012) shows the
correct conflict resolution in my opinion.

>From f040ba69632a54c86767974768d68b308901061c Mon Sep 17 00:00:00 2001
From: Magnus Damm <damm@opensource.se>
Date: Wed, 29 Feb 2012 12:37:19 +0900
Subject: [PATCH] ARM: mach-shmobile: sh7372 map_io and init_early update

ARM: mach-shmobile: sh7372 map_io and init_early update

Update the sh7372 SoC and the AP4EVB and Mackerel boards to make use
of the functions sh7372_map_io() and sh7372_add_early_devices().

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/mach-shmobile/board-ap4evb.c        |   25 ++-----------------------
 arch/arm/mach-shmobile/board-mackerel.c      |   21 +++------------------
 arch/arm/mach-shmobile/include/mach/common.h |    1 +
 arch/arm/mach-shmobile/setup-sh7372.c        |   22 ++++++++++++++++++++++
 4 files changed, 28 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index eeb4d96..c57ded1 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -61,7 +61,6 @@
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-#include <asm/mach/map.h>
 #include <asm/mach/time.h>
 #include <asm/setup.h>
 
@@ -1190,27 +1189,6 @@ static struct i2c_board_info i2c1_devices[] = {
 	},
 };
 
-static struct map_desc ap4evb_io_desc[] __initdata = {
-	/* create a 1:1 entity map for 0xe6xxxxxx
-	 * used by CPGA, INTC and PFC.
-	 */
-	{
-		.virtual	= 0xe6000000,
-		.pfn		= __phys_to_pfn(0xe6000000),
-		.length		= 256 << 20,
-		.type		= MT_DEVICE_NONSHARED
-	},
-};
-
-static void __init ap4evb_map_io(void)
-{
-	iotable_init(ap4evb_io_desc, ARRAY_SIZE(ap4evb_io_desc));
-
-	/* setup early devices and console here as well */
-	sh7372_add_early_devices();
-	shmobile_setup_console();
-}
-
 #define GPIO_PORT9CR	0xE6051009
 #define GPIO_PORT10CR	0xE605100A
 #define USCCR1		0xE6058144
@@ -1469,7 +1447,8 @@ static struct sys_timer ap4evb_timer = {
 };
 
 MACHINE_START(AP4EVB, "ap4evb")
-	.map_io		= ap4evb_map_io,
+	.map_io		= sh7372_map_io,
+	.init_early	= sh7372_add_early_devices,
 	.init_irq	= sh7372_init_irq,
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= ap4evb_init,
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 7b53cda..b5bbab7 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -58,7 +58,6 @@
 
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
-#include <asm/mach/map.h>
 #include <asm/mach-types.h>
 
 /*
@@ -1337,29 +1336,14 @@ static struct i2c_board_info i2c1_devices[] = {
 	},
 };
 
-static struct map_desc mackerel_io_desc[] __initdata = {
-	/* create a 1:1 entity map for 0xe6xxxxxx
-	 * used by CPGA, INTC and PFC.
-	 */
-	{
-		.virtual	= 0xe6000000,
-		.pfn		= __phys_to_pfn(0xe6000000),
-		.length		= 256 << 20,
-		.type		= MT_DEVICE_NONSHARED
-	},
-};
-
 static void __init mackerel_map_io(void)
 {
-	iotable_init(mackerel_io_desc, ARRAY_SIZE(mackerel_io_desc));
+	sh7372_map_io();
+
 	/* DMA memory at 0xff200000 - 0xffdfffff. The default 2MB size isn't
 	 * enough to allocate the frame buffer memory.
 	 */
 	init_consistent_dma_size(12 << 20);
-
-	/* setup early devices and console here as well */
-	sh7372_add_early_devices();
-	shmobile_setup_console();
 }
 
 #define GPIO_PORT9CR	0xE6051009
@@ -1592,6 +1576,7 @@ static struct sys_timer mackerel_timer = {
 
 MACHINE_START(MACKEREL, "mackerel")
 	.map_io		= mackerel_map_io,
+	.init_early	= sh7372_add_early_devices,
 	.init_irq	= sh7372_init_irq,
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= mackerel_init,
diff --git a/arch/arm/mach-shmobile/include/mach/common.h b/arch/arm/mach-shmobile/include/mach/common.h
index e4b945e..b327402 100644
--- a/arch/arm/mach-shmobile/include/mach/common.h
+++ b/arch/arm/mach-shmobile/include/mach/common.h
@@ -30,6 +30,7 @@ extern struct clk sh7377_extalc1_clk;
 extern struct clk sh7377_extal2_clk;
 
 extern void sh7372_init_irq(void);
+extern void sh7372_map_io(void);
 extern void sh7372_add_early_devices(void);
 extern void sh7372_add_standard_devices(void);
 extern void sh7372_clock_init(void);
diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index a83cf51..12b4378 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -33,9 +33,28 @@
 #include <linux/pm_domain.h>
 #include <mach/hardware.h>
 #include <mach/sh7372.h>
+#include <mach/common.h>
+#include <asm/mach/map.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
+static struct map_desc sh7372_io_desc[] __initdata = {
+	/* create a 1:1 entity map for 0xe6xxxxxx
+	 * used by CPGA, INTC and PFC.
+	 */
+	{
+		.virtual	= 0xe6000000,
+		.pfn		= __phys_to_pfn(0xe6000000),
+		.length		= 256 << 20,
+		.type		= MT_DEVICE_NONSHARED
+	},
+};
+
+void __init sh7372_map_io(void)
+{
+	iotable_init(sh7372_io_desc, ARRAY_SIZE(sh7372_io_desc));
+}
+
 /* SCIFA0 */
 static struct plat_sci_port scif0_platform_data = {
 	.mapbase	= 0xe6c40000,
@@ -1049,4 +1068,7 @@ void __init sh7372_add_early_devices(void)
 {
 	early_platform_add_devices(sh7372_early_devices,
 				   ARRAY_SIZE(sh7372_early_devices));
+
+	/* setup early console here as well */
+	shmobile_setup_console();
 }

-- 
Regards,

Laurent Pinchart

