Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab0HTJw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:52:28 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61758 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab0HTJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:52:22 -0400
Date: Fri, 20 Aug 2010 11:50:46 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH/RFCv4 6/6] arm: Added CMA to Aquila and Goni
In-reply-to: <2e2a3d55b07cf8ce852e0d02e6fd77dc1fcbf275.1282286941.git.m.nazarewicz@samsung.com>
To: linux-mm@kvack.org
Cc: Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Message-id: <360303f5fb76d6544e4fb78537da07a096d904a7.1282286941.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <0b02e05fc21e70a3af39e65e628d117cd89d70a1.1282286941.git.m.nazarewicz@samsung.com>
 <343f4b0edf9b5eef598831700cb459cd428d3f2e.1282286941.git.m.nazarewicz@samsung.com>
 <9883433f103cc84e55db150806d2270200c74c6b.1282286941.git.m.nazarewicz@samsung.com>
 <8fa83f632d8198f98b232b96c848eece44e33f83.1282286941.git.m.nazarewicz@samsung.com>
 <2e2a3d55b07cf8ce852e0d02e6fd77dc1fcbf275.1282286941.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the CMA initialisation code to two Samsung platforms.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/mach-aquila.c |   31 +++++++++++++++++++++++++++++++
 arch/arm/mach-s5pv210/mach-goni.c   |   31 +++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
index 0dda801..3561859 100644
--- a/arch/arm/mach-s5pv210/mach-aquila.c
+++ b/arch/arm/mach-s5pv210/mach-aquila.c
@@ -19,6 +19,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/cma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -493,6 +494,35 @@ static void __init aquila_map_io(void)
 	s3c24xx_init_uarts(aquila_uartcfgs, ARRAY_SIZE(aquila_uartcfgs));
 }
 
+static void __init aquila_reserve(void)
+{
+	static struct cma_region regions[] = {
+		{
+			.name		= "fw",
+			.size		=   1 << 20,
+			{ .alignment	= 128 << 10 },
+		},
+		{
+			.name		= "b1",
+			.size		=  32 << 20,
+			.asterisk	= 1,
+		},
+		{
+			.name		= "b2",
+			.size		=  16 << 20,
+			.start		= 0x40000000,
+			.asterisk	= 1,
+		},
+		{ }
+	};
+
+	static const char map[] __initconst =
+		"s3c-mfc5/f=fw;s3c-mfc5/a=b1;s3c-mfc5/b=b2";
+
+	cma_set_defaults(regions, map);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init aquila_machine_init(void)
 {
 	/* PMIC */
@@ -523,4 +553,5 @@ MACHINE_START(AQUILA, "Aquila")
 	.map_io		= aquila_map_io,
 	.init_machine	= aquila_machine_init,
 	.timer		= &s3c24xx_timer,
+	.reserve	= aquila_reserve,
 MACHINE_END
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 53754d7..edeb93f 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -19,6 +19,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/cma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -474,6 +475,35 @@ static void __init goni_map_io(void)
 	s3c24xx_init_uarts(goni_uartcfgs, ARRAY_SIZE(goni_uartcfgs));
 }
 
+static void __init goni_reserve(void)
+{
+	static struct cma_region regions[] = {
+		{
+			.name		= "fw",
+			.size		=   1 << 20,
+			{ .alignment	= 128 << 10 },
+		},
+		{
+			.name		= "b1",
+			.size		=  32 << 20,
+			.asterisk	= 1,
+		},
+		{
+			.name		= "b2",
+			.size		=  16 << 20,
+			.start		= 0x40000000,
+			.asterisk	= 1,
+		},
+		{ }
+	};
+
+	static const char map[] __initconst =
+		"s3c-mfc5/f=fw;s3c-mfc5/a=b1;s3c-mfc5/b=b2";
+
+	cma_set_defaults(regions, map);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init goni_machine_init(void)
 {
 	/* PMIC */
@@ -498,4 +528,5 @@ MACHINE_START(GONI, "GONI")
 	.map_io		= goni_map_io,
 	.init_machine	= goni_machine_init,
 	.timer		= &s3c24xx_timer,
+	.reserve	= goni_reserve,
 MACHINE_END
-- 
1.7.1


