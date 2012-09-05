Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab2IEJ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:59:58 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:34927 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758402Ab2IEJ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:46 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 02/17] arm: ux500: add ccu9540 board support
Date: Wed, 5 Sep 2012 11:58:58 +0200
Message-ID: <1346839153-6465-3-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upgrade existing mop500 definition to support new ccu9540
board.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-sdi.c | 12 ++++++++++++
 arch/arm/mach-ux500/board-mop500.c     | 35 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.h     |  1 +
 3 files changed, 48 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 18ff781..4fd21fe 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -255,6 +255,18 @@ void __init mop500_sdi_init(struct device *parent)
 	 */
 }
 
+void __init ccu9540_sdi_init(struct device *parent)
+{
+	/* On-board eMMC */
+	db8500_add_sdi4(parent, &mop500_sdi4_data, U8500_SDI_V2_PERIPHID);
+
+	/*
+	 * On boards with the TC35892 GPIO expander, sdi0 will finally
+	 * be added when the TC35892 initializes and calls
+	 * mop500_sdi_tc35892_init() above.
+	 */
+}
+
 void __init snowball_sdi_init(struct device *parent)
 {
 	/* On Snowball MMC_CAP_SD_HIGHSPEED isn't supported (Hardware issue?) */
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index fe1ff85..fa75f95 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -691,6 +691,30 @@ static void __init hrefv60_init_machine(void)
 	mop500_uib_init();
 }
 
+
+static void __init u9540_init_machine(void)
+{
+	struct device *parent;
+	int i;
+
+	ccu9540_pins_init();
+
+	parent = u8500_init_devices(&ab8500_platdata);
+
+	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
+		mop500_platform_devs[i]->dev.parent = parent;
+
+	platform_add_devices(mop500_platform_devs,
+				ARRAY_SIZE(mop500_platform_devs));
+	mop500_i2c_init(parent);
+	ccu9540_sdi_init(parent);
+	mop500_msp_init(parent);
+	mop500_uart_init(parent);
+
+	/* This board has full regulator constraints */
+	regulator_has_full_constraints();
+}
+
 MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
 	/* Maintainer: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com> */
 	.atag_offset	= 0x100,
@@ -727,6 +751,17 @@ MACHINE_START(SNOWBALL, "Calao Systems Snowball platform")
 	.init_late	= ux500_init_late,
 MACHINE_END
 
+MACHINE_START(U9540, "ST-Ericsson 9540 platform")
+	.atag_offset	= 0x100,
+	.map_io		= u8500_map_io,
+	.nr_irqs	= UX500_NR_IRQS,
+	.init_irq	= ux500_init_irq,
+	.timer		= &ux500_timer,
+	.handle_irq	= gic_handle_irq,
+	.init_machine	= u9540_init_machine,
+	.init_late	= ux500_init_late,
+MACHINE_END
+
 #ifdef CONFIG_MACH_UX500_DT
 
 struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index b696ab0..e5b2d3c 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -84,6 +84,7 @@ extern struct mmci_platform_data mop500_sdi4_data;
 extern struct arm_pmu_platdata db8500_pmu_platdata;
 
 extern void mop500_sdi_init(struct device *parent);
+extern void ccu9540_sdi_init(struct device *parent);
 extern void snowball_sdi_init(struct device *parent);
 extern void hrefv60_sdi_init(struct device *parent);
 extern void mop500_sdi_tc35892_init(struct device *parent);
-- 
1.7.11.1

