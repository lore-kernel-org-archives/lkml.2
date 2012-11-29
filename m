Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2K2Gmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:42:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45324 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2K2GmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:42:24 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "tony@atomide.com" <tony@atomide.com>
CC: "paul@pwsan.com" <paul@pwsan.com>, "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "srinath@mistralsolutions.com" <srinath@mistralsolutions.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] omap: craneboard: support the TPS65910 PMU
Thread-Topic: [PATCH 2/3] omap: craneboard: support the TPS65910 PMU
Thread-Index: Ac3N/JnMrsD5R4jYTvKReZdpbaG7Zg==
Date: Thu, 29 Nov 2012 06:41:46 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6418F140@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch supports the TPS65910 PMU function on the AM3517 Craneboard.
 The IRQ pin, SYS_NIRQ is dedicated connection between the AM3517 and
 the TPS65910 PMU.
 To handle the PMU IRQs, mux configuration is required.

 Platform data configuration:
 .IRQ number : SYS_NIRQ (M_IRQ_7)
 .External clock source : external 32KHz clock is connected

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 37646e5..82805de 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
+#include <linux/mfd/tps65910.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
@@ -41,6 +42,7 @@
 
 #ifdef CONFIG_OMAP_MUX
 static struct omap_board_mux board_mux[] __initdata = {
+	OMAP3_MUX(SYS_NIRQ, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
 	{ .reg_offset = OMAP_MUX_TERMINATOR },
 };
 #endif
@@ -86,6 +88,24 @@ static struct mtd_partition crane_nand_partitions[] = {
 	},
 };
 
+static struct tps65910_board tps65910_pdata = {
+	.irq = 7 + OMAP_INTC_START,
+	.en_ck32k_xtal = true,
+};
+
+static struct i2c_board_info __initdata tps65910_board_info[] = {
+	{
+		I2C_BOARD_INFO("tps65910", 0x2d),
+		.platform_data = &tps65910_pdata,
+	},
+};
+
+static void __init am3517_crane_i2c_init(void)
+{
+	omap_register_i2c_bus(1, 2600, tps65910_board_info,
+			ARRAY_SIZE(tps65910_board_info));
+}
+
 static void __init am3517_crane_init(void)
 {
 	int ret;
@@ -96,6 +116,7 @@ static void __init am3517_crane_init(void)
 	board_nand_init(crane_nand_partitions,
 			ARRAY_SIZE(crane_nand_partitions), 0,
 			NAND_BUSWIDTH_16, NULL);
+	am3517_crane_i2c_init();
 
 	/* Configure GPIO for EHCI port */
 	if (omap_mux_init_gpio(GPIO_USB_NRESET, OMAP_PIN_OUTPUT)) {
-- 
1.7.9.5


Best Regards,
Milo


