Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0IFGfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:35:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21432 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0IFGfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:35:05 -0400
Date: Mon, 06 Sep 2010 08:33:56 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [RFCv5 6/9] ARM: cma: Added CMA to Aquila,
 Goni and c210 universal boards
In-reply-to: <cover.1283749231.git.mina86@mina86.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jonathan Corbet <corbet@lwn.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>, linux-kernel@vger.kernel.org
Message-id: <75d7a03247944cc210dbdd100a7ff57ac582ba4e.1283749231.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1283749231.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds CMA memory reservation code to Aquila, Goni and c210
universal boards.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/mach-aquila.c         |   31 +++++++++++++++++++++++++++
 arch/arm/mach-s5pv210/mach-goni.c           |   31 +++++++++++++++++++++++++++
 arch/arm/mach-s5pv310/mach-universal_c210.c |   23 ++++++++++++++++++++
 3 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
index bf772de..ff89534 100644
--- a/arch/arm/mach-s5pv210/mach-aquila.c
+++ b/arch/arm/mach-s5pv210/mach-aquila.c
@@ -19,6 +19,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/cma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -486,6 +487,35 @@ static struct platform_device *aquila_devices[] __initdata = {
 	&s5p_device_fimc2,
 };
 
+static void __init aquila_reserve(void)
+{
+	static struct cma_region regions[] = {
+		{
+			.name		= "fw",
+			.size		=   1 << 20,
+			{ .alignment	= 128 << 10 },
+			.start		= 0x32000000,
+		},
+		{
+			.name		= "b1",
+			.size		=  32 << 20,
+			.start		= 0x33000000,
+		},
+		{
+			.name		= "b2",
+			.size		=  16 << 20,
+			.start		= 0x44000000,
+		},
+		{ }
+	};
+
+	static const char map[] __initconst =
+		"s5p-mfc5/f=fw;s5p-mfc5/a=b1;s5p-mfc5/b=b2;*=b1,b2";
+
+	cma_set_defaults(regions, map);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init aquila_map_io(void)
 {
 	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
@@ -523,4 +553,5 @@ MACHINE_START(AQUILA, "Aquila")
 	.map_io		= aquila_map_io,
 	.init_machine	= aquila_machine_init,
 	.timer		= &s3c24xx_timer,
+	.reserve	= aquila_reserve,
 MACHINE_END
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index fdc5cca..10dc2b9 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -19,6 +19,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/cma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -467,6 +468,35 @@ static struct platform_device *goni_devices[] __initdata = {
 	&s3c_device_hsmmc2,
 };
 
+static void __init goni_reserve(void)
+{
+	static struct cma_region regions[] = {
+		{
+			.name		= "fw",
+			.size		=   1 << 20,
+			{ .alignment	= 128 << 10 },
+			.start		= 0x32000000,
+		},
+		{
+			.name		= "b1",
+			.size		=  32 << 20,
+			.start		= 0x33000000,
+		},
+		{
+			.name		= "b2",
+			.size		=  16 << 20,
+			.start		= 0x44000000,
+		},
+		{ }
+	};
+
+	static const char map[] __initconst =
+		"s5p-mfc5/f=fw;s5p-mfc5/a=b1;s5p-mfc5/b=b2;*=b1,b2";
+
+	cma_set_defaults(regions, map);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init goni_map_io(void)
 {
 	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
@@ -498,4 +528,5 @@ MACHINE_START(GONI, "GONI")
 	.map_io		= goni_map_io,
 	.init_machine	= goni_machine_init,
 	.timer		= &s3c24xx_timer,
+	.reserve	= goni_reserve,
 MACHINE_END
diff --git a/arch/arm/mach-s5pv310/mach-universal_c210.c b/arch/arm/mach-s5pv310/mach-universal_c210.c
index b57efae..f735c52 100644
--- a/arch/arm/mach-s5pv310/mach-universal_c210.c
+++ b/arch/arm/mach-s5pv310/mach-universal_c210.c
@@ -12,6 +12,7 @@
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
 #include <linux/gpio.h>
+#include <linux/cma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -126,6 +127,27 @@ static void __init universal_map_io(void)
 	s3c24xx_init_uarts(universal_uartcfgs, ARRAY_SIZE(universal_uartcfgs));
 }
 
+static void __init universal_reserve(void)
+{
+	static struct cma_region regions[] = {
+		{
+			.name		= "r",
+			.size		=  64 << 20,
+		},
+		{
+			.name		= "fw",
+			.size		=   1 << 20,
+		},
+		{ }
+	};
+
+	static const char map[] __initconst =
+		"s3c-mfc5/f=fw;*=r";
+
+	cma_set_defaults(regions, map);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init universal_machine_init(void)
 {
 #ifdef CONFIG_CACHE_L2X0
@@ -143,6 +165,7 @@ MACHINE_START(UNIVERSAL_C210, "UNIVERSAL_C210")
 	.boot_params	= S5P_PA_SDRAM + 0x100,
 	.init_irq	= s5pv310_init_irq,
 	.map_io		= universal_map_io,
+	.reserve	= universal_reserve,
 	.init_machine	= universal_machine_init,
 	.timer		= &s5pv310_timer,
 MACHINE_END
-- 
1.7.1

