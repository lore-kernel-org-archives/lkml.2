Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab2KPSC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:02:26 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:46049 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2KPSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:02:23 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 1/2] clk: mvebu: armada 370/XP add clock gating control provider for DT
Date: Fri, 16 Nov 2012 19:01:59 +0100
Message-Id: <1353088920-17458-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch>
 <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 .../bindings/clock/mvebu-gated-clock.txt           |   43 ++++++++++++++
 arch/arm/mach-mvebu/Kconfig                        |    1 +
 drivers/clk/mvebu/clk-gating-ctrl.c                |   61 ++++++++++++++++++++
 3 files changed, 105 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt b/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
index 7497cc0..9dbcdd9 100644
--- a/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
+++ b/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
@@ -6,6 +6,49 @@ the clock ID in its "clocks" phandle cell. The clock ID is directly mapped to
 the corresponding clock gating control bit in HW to ease manual clock lookup
 in datasheet.
 
+The following is a list of provided IDs for Armada XP:
+ID	Clock	Peripheral
+-----------------------------------
+0	Audio	AC97 Cntrl
+1	pex0_en	PCIe 0 Clock out
+2	pex1_en	PCIe 1 Clock out
+3	ge1	Gigabit Ethernet 1
+4	ge0	Gigabit Ethernet 0
+5	pex0	PCIe Cntrl 0
+9	pex1	PCIe Cntrl 1
+15	sata0	SATA Host 0
+17	sdio	SDHCI Host
+25	tdm	Time Division Mplx
+28	ddr	DDR Cntrl
+30	sata1	SATA Host 0
+
+The following is a list of provided IDs for Armada XP:
+ID	Clock	Peripheral
+-----------------------------------
+0	audio	Audio Cntrl
+1	ge3	Gigabit Ethernet 3
+2	ge2	Gigabit Ethernet 2
+3	ge1	Gigabit Ethernet 1
+4	ge0	Gigabit Ethernet 0
+5	pex0	PCIe Cntrl 0
+6	pex1	PCIe Cntrl 1
+7	pex2	PCIe Cntrl 2
+8	pex3	PCIe Cntrl 3
+13	bp
+14	sata0lnk
+15	sata0	SATA Host 0
+16	lcd	LCD Cntrl
+17	sdio	SDHCI Host
+18	usb0	USB Host 0
+19	usb1	USB Host 1
+20	usb2	USB Host 2
+22	xor0	XOR DMA 0
+23	crypto	CESA engine
+25	tdm	Time Division Mplx
+28	xor1	XOR DMA 1
+29	sata1lnk
+30	sata1	SATA Host 0
+
 The following is a list of provided IDs for Dove:
 ID	Clock	Peripheral
 -----------------------------------
diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
index ad38b64..dc009d5 100644
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@ -12,6 +12,7 @@ config ARCH_MVEBU
 	select CLKDEV_LOOKUP
 	select MVEBU_CLK_CORE
 	select MVEBU_CLK_CPU
+	select MVEBU_CLK_GATING
 
 if ARCH_MVEBU
 
diff --git a/drivers/clk/mvebu/clk-gating-ctrl.c b/drivers/clk/mvebu/clk-gating-ctrl.c
index 3ac7607..7f04e8b 100644
--- a/drivers/clk/mvebu/clk-gating-ctrl.c
+++ b/drivers/clk/mvebu/clk-gating-ctrl.c
@@ -101,6 +101,53 @@ static void __init mvebu_clk_gating_setup(
  * SoC specific clock gating control
  */
 
+#ifdef CONFIG_MACH_ARMADA_370
+static const struct mvebu_soc_descr __initconst armada_370_gating_descr[] = {
+	{ "audio", NULL, 0 },
+	{ "pex0_en", NULL, 1 },
+	{ "pex1_en", NULL,  2 },
+	{ "ge1", NULL, 3 },
+	{ "ge0", NULL, 4 },
+	{ "pex0", NULL, 5 },
+	{ "pex1", NULL, 9 },
+	{ "sata0", NULL, 15 },
+	{ "sdio", NULL, 17 },
+	{ "tdm", NULL, 25 },
+	{ "ddr", NULL, 28 },
+	{ "sata1", NULL, 30 },
+	{ }
+};
+#endif
+
+#ifdef CONFIG_MACH_ARMADA_XP
+static const struct mvebu_soc_descr __initconst armada_xp_gating_descr[] = {
+	{ "audio", NULL, 0 },
+	{ "ge3", NULL, 1 },
+	{ "ge2", NULL,  2 },
+	{ "ge1", NULL, 3 },
+	{ "ge0", NULL, 4 },
+	{ "pex0", NULL, 5 },
+	{ "pex1", NULL, 6 },
+	{ "pex2", NULL, 7 },
+	{ "pex3", NULL, 8 },
+	{ "bp", NULL, 13 },
+	{ "sata0lnk", NULL, 14 },
+	{ "sata0", NULL, 15 },
+	{ "lcd", NULL, 16 },
+	{ "sdio", NULL, 17 },
+	{ "usb0", NULL, 18 },
+	{ "usb1", NULL, 19 },
+	{ "usb2", NULL, 20 },
+	{ "xor0", NULL, 22 },
+	{ "crypto", NULL, 23 },
+	{ "tdm", NULL, 25 },
+	{ "xor1", NULL, 28 },
+	{ "sata1lnk", NULL, 29 },
+	{ "sata1", NULL, 30 },
+	{ }
+};
+#endif
+
 #ifdef CONFIG_ARCH_DOVE
 static const struct mvebu_soc_descr __initconst dove_gating_descr[] = {
 	{ "usb0", NULL, 0 },
@@ -147,6 +194,20 @@ static const struct mvebu_soc_descr __initconst kirkwood_gating_descr[] = {
 #endif
 
 static const __initdata struct of_device_id clk_gating_match[] = {
+#ifdef CONFIG_MACH_ARMADA_370
+	{
+		.compatible = "marvell,armada-370-clock-gating",
+		.data = armada_370_gating_descr,
+	},
+#endif
+
+#ifdef CONFIG_MACH_ARMADA_XP
+	{
+		.compatible = "marvell,armada-xp-clock-gating",
+		.data = armada_xp_gating_descr,
+	},
+#endif
+
 #ifdef CONFIG_ARCH_DOVE
 	{
 		.compatible = "marvell,dove-clock-gating",
-- 
1.7.9.5

