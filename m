Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1FEP75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 11:59:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56969 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab1FEP7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 11:59:55 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, olof@lixom.net,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v4 2/2] gpio/mxc: Change gpio-mxc into an upstanding gpio driver
Date: Mon,  6 Jun 2011 00:07:55 +0800
Message-Id: <1307290075-7062-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307290075-7062-1-git-send-email-shawn.guo@linaro.org>
References: <1307290075-7062-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch makes necessary changes on gpio-mxc as below to turn it
into an upstanding gpio driver.

 * Add a list to save all mx2 ports references, so that
   mx2_gpio_irq_handler can walk through all interrupt status
   registers

 * Use readl/writel to replace mach-specific accessors
   __raw_readl/__raw_writel

 * Change mxc_gpio_init into mxc_gpio_probe function

 * Move "struct mxc_gpio_port" into gpio-mxc.c, as it needs not to
   be public at all, and also make some other cleanup on
   plat-mxc/include/mach/gpio.h at the same time

And the patch then migrates mach-imx and mach-mx5 to the updated
driver by adding corresponding platform devices.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Olof Johansson <olof@lixom.net>
---
 arch/arm/mach-imx/mach-apf9328.c                |    2 +
 arch/arm/mach-imx/mach-armadillo5x0.c           |    2 +
 arch/arm/mach-imx/mach-bug.c                    |    2 +
 arch/arm/mach-imx/mach-cpuimx27.c               |    2 +
 arch/arm/mach-imx/mach-cpuimx35.c               |    2 +
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c        |    2 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |    2 +
 arch/arm/mach-imx/mach-imx27ipcam.c             |    2 +
 arch/arm/mach-imx/mach-imx27lite.c              |    2 +
 arch/arm/mach-imx/mach-kzm_arm11_01.c           |    2 +
 arch/arm/mach-imx/mach-mx1ads.c                 |    2 +
 arch/arm/mach-imx/mach-mx21ads.c                |    2 +
 arch/arm/mach-imx/mach-mx25_3ds.c               |    2 +
 arch/arm/mach-imx/mach-mx27_3ds.c               |    2 +
 arch/arm/mach-imx/mach-mx27ads.c                |    2 +
 arch/arm/mach-imx/mach-mx31_3ds.c               |    2 +
 arch/arm/mach-imx/mach-mx31ads.c                |    2 +
 arch/arm/mach-imx/mach-mx31lilly.c              |    2 +
 arch/arm/mach-imx/mach-mx31lite.c               |    2 +
 arch/arm/mach-imx/mach-mx31moboard.c            |    2 +
 arch/arm/mach-imx/mach-mx35_3ds.c               |    2 +
 arch/arm/mach-imx/mach-mxt_td60.c               |    2 +
 arch/arm/mach-imx/mach-pca100.c                 |    2 +
 arch/arm/mach-imx/mach-pcm037.c                 |    2 +
 arch/arm/mach-imx/mach-pcm038.c                 |    2 +
 arch/arm/mach-imx/mach-pcm043.c                 |    2 +
 arch/arm/mach-imx/mach-qong.c                   |    2 +
 arch/arm/mach-imx/mach-scb9328.c                |    2 +
 arch/arm/mach-imx/mach-vpr200.c                 |    2 +
 arch/arm/mach-imx/mm-imx1.c                     |   17 +-
 arch/arm/mach-imx/mm-imx21.c                    |   21 +--
 arch/arm/mach-imx/mm-imx25.c                    |   16 +-
 arch/arm/mach-imx/mm-imx27.c                    |   21 +--
 arch/arm/mach-imx/mm-imx31.c                    |   15 +-
 arch/arm/mach-imx/mm-imx35.c                    |   15 +-
 arch/arm/mach-mx5/board-cpuimx51.c              |    2 +
 arch/arm/mach-mx5/board-cpuimx51sd.c            |    2 +
 arch/arm/mach-mx5/board-mx50_rdp.c              |    2 +
 arch/arm/mach-mx5/board-mx51_3ds.c              |    2 +
 arch/arm/mach-mx5/board-mx51_babbage.c          |    2 +
 arch/arm/mach-mx5/board-mx51_efikamx.c          |    2 +
 arch/arm/mach-mx5/board-mx51_efikasb.c          |    2 +
 arch/arm/mach-mx5/board-mx53_evk.c              |    2 +
 arch/arm/mach-mx5/board-mx53_loco.c             |    2 +
 arch/arm/mach-mx5/board-mx53_smd.c              |    2 +
 arch/arm/mach-mx5/devices.c                     |   64 -------
 arch/arm/mach-mx5/mm-mx50.c                     |   21 +--
 arch/arm/mach-mx5/mm.c                          |   25 ++-
 arch/arm/plat-mxc/devices.c                     |   11 ++
 arch/arm/plat-mxc/devices/Makefile              |    1 +
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c   |   32 ++++
 arch/arm/plat-mxc/include/mach/common.h         |   12 ++-
 arch/arm/plat-mxc/include/mach/devices-common.h |    2 +
 arch/arm/plat-mxc/include/mach/gpio.h           |   27 ---
 drivers/gpio/gpio-mxc.c                         |  217 +++++++++++++++--------
 55 files changed, 358 insertions(+), 237 deletions(-)
 create mode 100644 arch/arm/plat-mxc/devices/platform-gpio-mxc.c

diff --git a/arch/arm/mach-imx/mach-apf9328.c b/arch/arm/mach-imx/mach-apf9328.c
index 15e45c8..59d2a3b 100644
--- a/arch/arm/mach-imx/mach-apf9328.c
+++ b/arch/arm/mach-imx/mach-apf9328.c
@@ -115,6 +115,8 @@ static struct platform_device *devices[] __initdata = {
 
 static void __init apf9328_init(void)
 {
+	imx1_soc_init();
+
 	mxc_gpio_setup_multiple_pins(apf9328_pins,
 			ARRAY_SIZE(apf9328_pins),
 			"APF9328");
diff --git a/arch/arm/mach-imx/mach-armadillo5x0.c b/arch/arm/mach-imx/mach-armadillo5x0.c
index ffb40ff..ede2710 100644
--- a/arch/arm/mach-imx/mach-armadillo5x0.c
+++ b/arch/arm/mach-imx/mach-armadillo5x0.c
@@ -490,6 +490,8 @@ static struct platform_device *devices[] __initdata = {
  */
 static void __init armadillo5x0_init(void)
 {
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(armadillo5x0_pins,
 			ARRAY_SIZE(armadillo5x0_pins), "armadillo5x0");
 
diff --git a/arch/arm/mach-imx/mach-bug.c b/arch/arm/mach-imx/mach-bug.c
index 42e4f07..f494705 100644
--- a/arch/arm/mach-imx/mach-bug.c
+++ b/arch/arm/mach-imx/mach-bug.c
@@ -42,6 +42,8 @@ static const unsigned int bug_pins[] __initconst = {
 
 static void __init bug_board_init(void)
 {
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(bug_pins,
 				      ARRAY_SIZE(bug_pins), "uart-4");
 	imx31_add_imx_uart4(&uart_pdata);
diff --git a/arch/arm/mach-imx/mach-cpuimx27.c b/arch/arm/mach-imx/mach-cpuimx27.c
index 46a2e41..87887ac 100644
--- a/arch/arm/mach-imx/mach-cpuimx27.c
+++ b/arch/arm/mach-imx/mach-cpuimx27.c
@@ -250,6 +250,8 @@ __setup("otg_mode=", eukrea_cpuimx27_otg_mode);
 
 static void __init eukrea_cpuimx27_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(eukrea_cpuimx27_pins,
 		ARRAY_SIZE(eukrea_cpuimx27_pins), "CPUIMX27");
 
diff --git a/arch/arm/mach-imx/mach-cpuimx35.c b/arch/arm/mach-imx/mach-cpuimx35.c
index 3f8ef82..f39a478b 100644
--- a/arch/arm/mach-imx/mach-cpuimx35.c
+++ b/arch/arm/mach-imx/mach-cpuimx35.c
@@ -156,6 +156,8 @@ __setup("otg_mode=", eukrea_cpuimx35_otg_mode);
  */
 static void __init eukrea_cpuimx35_init(void)
 {
+	imx35_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx35_pads,
 			ARRAY_SIZE(eukrea_cpuimx35_pads));
 
diff --git a/arch/arm/mach-imx/mach-eukrea_cpuimx25.c b/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
index 148cff2..da36da5 100644
--- a/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
+++ b/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
@@ -125,6 +125,8 @@ __setup("otg_mode=", eukrea_cpuimx25_otg_mode);
 
 static void __init eukrea_cpuimx25_init(void)
 {
+	imx25_soc_init();
+
 	if (mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx25_pads,
 			ARRAY_SIZE(eukrea_cpuimx25_pads)))
 		printk(KERN_ERR "error setting cpuimx25 pads !\n");
diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 7ae43b1..c6269d6 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -231,6 +231,8 @@ static void __init visstrim_m10_board_init(void)
 {
 	int ret;
 
+	imx27_soc_init();
+
 	ret = mxc_gpio_setup_multiple_pins(visstrim_m10_pins,
 			ARRAY_SIZE(visstrim_m10_pins), "VISSTRIM_M10");
 	if (ret)
diff --git a/arch/arm/mach-imx/mach-imx27ipcam.c b/arch/arm/mach-imx/mach-imx27ipcam.c
index 9be6cd6..272f793 100644
--- a/arch/arm/mach-imx/mach-imx27ipcam.c
+++ b/arch/arm/mach-imx/mach-imx27ipcam.c
@@ -50,6 +50,8 @@ static const int mx27ipcam_pins[] __initconst = {
 
 static void __init mx27ipcam_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx27ipcam_pins, ARRAY_SIZE(mx27ipcam_pins),
 		"mx27ipcam");
 
diff --git a/arch/arm/mach-imx/mach-imx27lite.c b/arch/arm/mach-imx/mach-imx27lite.c
index 8411405..d81a769 100644
--- a/arch/arm/mach-imx/mach-imx27lite.c
+++ b/arch/arm/mach-imx/mach-imx27lite.c
@@ -59,6 +59,8 @@ static const struct imxuart_platform_data uart_pdata __initconst = {
 
 static void __init mx27lite_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx27lite_pins, ARRAY_SIZE(mx27lite_pins),
 		"imx27lite");
 	imx27_add_imx_uart0(&uart_pdata);
diff --git a/arch/arm/mach-imx/mach-kzm_arm11_01.c b/arch/arm/mach-imx/mach-kzm_arm11_01.c
index 1ecae20..e472a1d 100644
--- a/arch/arm/mach-imx/mach-kzm_arm11_01.c
+++ b/arch/arm/mach-imx/mach-kzm_arm11_01.c
@@ -223,6 +223,8 @@ static int kzm_pins[] __initdata = {
  */
 static void __init kzm_board_init(void)
 {
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(kzm_pins,
 				      ARRAY_SIZE(kzm_pins), "kzm");
 	kzm_init_ext_uart();
diff --git a/arch/arm/mach-imx/mach-mx1ads.c b/arch/arm/mach-imx/mach-mx1ads.c
index 38ec5cb..5cd8bee 100644
--- a/arch/arm/mach-imx/mach-mx1ads.c
+++ b/arch/arm/mach-imx/mach-mx1ads.c
@@ -115,6 +115,8 @@ static struct i2c_board_info mx1ads_i2c_devices[] = {
  */
 static void __init mx1ads_init(void)
 {
+	imx1_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx1ads_pins,
 		ARRAY_SIZE(mx1ads_pins), "mx1ads");
 
diff --git a/arch/arm/mach-imx/mach-mx21ads.c b/arch/arm/mach-imx/mach-mx21ads.c
index 74ac889..d389ecf 100644
--- a/arch/arm/mach-imx/mach-mx21ads.c
+++ b/arch/arm/mach-imx/mach-mx21ads.c
@@ -279,6 +279,8 @@ static struct platform_device *platform_devices[] __initdata = {
 
 static void __init mx21ads_board_init(void)
 {
+	imx21_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx21ads_pins, ARRAY_SIZE(mx21ads_pins),
 			"mx21ads");
 
diff --git a/arch/arm/mach-imx/mach-mx25_3ds.c b/arch/arm/mach-imx/mach-mx25_3ds.c
index 58ea3fd..01534bb 100644
--- a/arch/arm/mach-imx/mach-mx25_3ds.c
+++ b/arch/arm/mach-imx/mach-mx25_3ds.c
@@ -219,6 +219,8 @@ static const struct esdhc_platform_data mx25pdk_esdhc_pdata __initconst = {
 
 static void __init mx25pdk_init(void)
 {
+	imx25_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx25pdk_pads,
 			ARRAY_SIZE(mx25pdk_pads));
 
diff --git a/arch/arm/mach-imx/mach-mx27_3ds.c b/arch/arm/mach-imx/mach-mx27_3ds.c
index 6e1accf..117ce0a 100644
--- a/arch/arm/mach-imx/mach-mx27_3ds.c
+++ b/arch/arm/mach-imx/mach-mx27_3ds.c
@@ -267,6 +267,8 @@ static const struct imxi2c_platform_data mx27_3ds_i2c0_data __initconst = {
 
 static void __init mx27pdk_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx27pdk_pins, ARRAY_SIZE(mx27pdk_pins),
 		"mx27pdk");
 	mx27_3ds_sdhc1_enable_level_translator();
diff --git a/arch/arm/mach-imx/mach-mx27ads.c b/arch/arm/mach-imx/mach-mx27ads.c
index 1db7950..fc26ed7 100644
--- a/arch/arm/mach-imx/mach-mx27ads.c
+++ b/arch/arm/mach-imx/mach-mx27ads.c
@@ -288,6 +288,8 @@ static const struct imxuart_platform_data uart_pdata __initconst = {
 
 static void __init mx27ads_board_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mx27ads_pins, ARRAY_SIZE(mx27ads_pins),
 			"mx27ads");
 
diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index 9b98244..ab2a626 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -689,6 +689,8 @@ static void __init mx31_3ds_init(void)
 {
 	int ret;
 
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(mx31_3ds_pins, ARRAY_SIZE(mx31_3ds_pins),
 				      "mx31_3ds");
 
diff --git a/arch/arm/mach-imx/mach-mx31ads.c b/arch/arm/mach-imx/mach-mx31ads.c
index f4dee02..0ce4947 100644
--- a/arch/arm/mach-imx/mach-mx31ads.c
+++ b/arch/arm/mach-imx/mach-mx31ads.c
@@ -516,6 +516,8 @@ static void __init mx31ads_init_irq(void)
 
 static void __init mx31ads_init(void)
 {
+	imx31_soc_init();
+
 	mxc_init_extuart();
 	mxc_init_imx_uart();
 	mxc_init_i2c();
diff --git a/arch/arm/mach-imx/mach-mx31lilly.c b/arch/arm/mach-imx/mach-mx31lilly.c
index 410e676..750368d 100644
--- a/arch/arm/mach-imx/mach-mx31lilly.c
+++ b/arch/arm/mach-imx/mach-mx31lilly.c
@@ -243,6 +243,8 @@ core_param(mx31lilly_baseboard, mx31lilly_baseboard, int, 0444);
 
 static void __init mx31lilly_board_init(void)
 {
+	imx31_soc_init();
+
 	switch (mx31lilly_baseboard) {
 	case MX31LILLY_NOBOARD:
 		break;
diff --git a/arch/arm/mach-imx/mach-mx31lite.c b/arch/arm/mach-imx/mach-mx31lite.c
index ac9b4ca..4b47fd9 100644
--- a/arch/arm/mach-imx/mach-mx31lite.c
+++ b/arch/arm/mach-imx/mach-mx31lite.c
@@ -230,6 +230,8 @@ static void __init mx31lite_init(void)
 {
 	int ret;
 
+	imx31_soc_init();
+
 	switch (mx31lite_baseboard) {
 	case MX31LITE_NOBOARD:
 		break;
diff --git a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
index eaa51e4..a52fd36 100644
--- a/arch/arm/mach-imx/mach-mx31moboard.c
+++ b/arch/arm/mach-imx/mach-mx31moboard.c
@@ -507,6 +507,8 @@ core_param(mx31moboard_baseboard, mx31moboard_baseboard, int, 0444);
  */
 static void __init mx31moboard_init(void)
 {
+	imx31_soc_init();
+
 	mxc_iomux_setup_multiple_pins(moboard_pins, ARRAY_SIZE(moboard_pins),
 		"moboard");
 
diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 882880a..48b3c6f 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -179,6 +179,8 @@ static const struct imxi2c_platform_data mx35_3ds_i2c0_data __initconst = {
  */
 static void __init mx35_3ds_init(void)
 {
+	imx35_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx35pdk_pads, ARRAY_SIZE(mx35pdk_pads));
 
 	imx35_add_fec(NULL);
diff --git a/arch/arm/mach-imx/mach-mxt_td60.c b/arch/arm/mach-imx/mach-mxt_td60.c
index 2774541..c85876f 100644
--- a/arch/arm/mach-imx/mach-mxt_td60.c
+++ b/arch/arm/mach-imx/mach-mxt_td60.c
@@ -233,6 +233,8 @@ static const struct imxuart_platform_data uart_pdata __initconst = {
 
 static void __init mxt_td60_board_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(mxt_td60_pins, ARRAY_SIZE(mxt_td60_pins),
 			"MXT_TD60");
 
diff --git a/arch/arm/mach-imx/mach-pca100.c b/arch/arm/mach-imx/mach-pca100.c
index bbddc5a..71083aa 100644
--- a/arch/arm/mach-imx/mach-pca100.c
+++ b/arch/arm/mach-imx/mach-pca100.c
@@ -357,6 +357,8 @@ static void __init pca100_init(void)
 {
 	int ret;
 
+	imx27_soc_init();
+
 	/* SSI unit */
 	mxc_audmux_v1_configure_port(MX27_AUDMUX_HPCR1_SSI0,
 				  MXC_AUDMUX_V1_PCR_SYN | /* 4wire mode */
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index 89c213b..f45b7cd 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -576,6 +576,8 @@ static void __init pcm037_init(void)
 {
 	int ret;
 
+	imx31_soc_init();
+
 	mxc_iomux_set_gpr(MUX_PGP_UH2, 1);
 
 	mxc_iomux_setup_multiple_pins(pcm037_pins, ARRAY_SIZE(pcm037_pins),
diff --git a/arch/arm/mach-imx/mach-pcm038.c b/arch/arm/mach-imx/mach-pcm038.c
index 853bb87..2d6a64b 100644
--- a/arch/arm/mach-imx/mach-pcm038.c
+++ b/arch/arm/mach-imx/mach-pcm038.c
@@ -295,6 +295,8 @@ static const struct mxc_usbh_platform_data usbh2_pdata __initconst = {
 
 static void __init pcm038_init(void)
 {
+	imx27_soc_init();
+
 	mxc_gpio_setup_multiple_pins(pcm038_pins, ARRAY_SIZE(pcm038_pins),
 			"PCM038");
 
diff --git a/arch/arm/mach-imx/mach-pcm043.c b/arch/arm/mach-imx/mach-pcm043.c
index 0264416..163cc31 100644
--- a/arch/arm/mach-imx/mach-pcm043.c
+++ b/arch/arm/mach-imx/mach-pcm043.c
@@ -356,6 +356,8 @@ static struct esdhc_platform_data sd1_pdata = {
  */
 static void __init pcm043_init(void)
 {
+	imx35_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(pcm043_pads, ARRAY_SIZE(pcm043_pads));
 
 	mxc_audmux_v2_configure_port(3,
diff --git a/arch/arm/mach-imx/mach-qong.c b/arch/arm/mach-imx/mach-qong.c
index c163287..3626f48 100644
--- a/arch/arm/mach-imx/mach-qong.c
+++ b/arch/arm/mach-imx/mach-qong.c
@@ -244,6 +244,8 @@ static void __init qong_init_fpga(void)
  */
 static void __init qong_init(void)
 {
+	imx31_soc_init();
+
 	mxc_init_imx_uart();
 	qong_init_nor_mtd();
 	qong_init_fpga();
diff --git a/arch/arm/mach-imx/mach-scb9328.c b/arch/arm/mach-imx/mach-scb9328.c
index dcaee04..8280526 100644
--- a/arch/arm/mach-imx/mach-scb9328.c
+++ b/arch/arm/mach-imx/mach-scb9328.c
@@ -129,6 +129,8 @@ static struct platform_device *devices[] __initdata = {
  */
 static void __init scb9328_init(void)
 {
+	imx1_soc_init();
+
 	imx1_add_imx_uart0(&uart_pdata);
 
 	printk(KERN_INFO"Scb9328: Adding devices\n");
diff --git a/arch/arm/mach-imx/mach-vpr200.c b/arch/arm/mach-imx/mach-vpr200.c
index d74e347..7d8e012 100644
--- a/arch/arm/mach-imx/mach-vpr200.c
+++ b/arch/arm/mach-imx/mach-vpr200.c
@@ -267,6 +267,8 @@ static struct platform_device *devices[] __initdata = {
  */
 static void __init vpr200_board_init(void)
 {
+	imx35_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(vpr200_pads, ARRAY_SIZE(vpr200_pads));
 
 	imx35_add_fec(NULL);
diff --git a/arch/arm/mach-imx/mm-imx1.c b/arch/arm/mach-imx/mm-imx1.c
index 2e482ba..b486595 100644
--- a/arch/arm/mach-imx/mm-imx1.c
+++ b/arch/arm/mach-imx/mm-imx1.c
@@ -23,7 +23,6 @@
 
 #include <mach/common.h>
 #include <mach/hardware.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 #include <mach/iomux-v1.h>
 
@@ -44,15 +43,15 @@ void __init imx1_init_early(void)
 			MX1_NUM_GPIO_PORT);
 }
 
-static struct mxc_gpio_port imx1_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 0, 1, MX1_GPIO_INT_PORTA),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 1, 2, MX1_GPIO_INT_PORTB),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 2, 3, MX1_GPIO_INT_PORTC),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX1, 3, 4, MX1_GPIO_INT_PORTD),
-};
-
 void __init mx1_init_irq(void)
 {
 	mxc_init_irq(MX1_IO_ADDRESS(MX1_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx1_gpio_ports,	ARRAY_SIZE(imx1_gpio_ports));
+}
+
+void __init imx1_soc_init(void)
+{
+	mxc_register_gpio(0, MX1_GPIO1_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTA, 0);
+	mxc_register_gpio(1, MX1_GPIO2_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTB, 0);
+	mxc_register_gpio(2, MX1_GPIO3_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTC, 0);
+	mxc_register_gpio(3, MX1_GPIO4_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTD, 0);
 }
diff --git a/arch/arm/mach-imx/mm-imx21.c b/arch/arm/mach-imx/mm-imx21.c
index 7a0c500..f0fb8bc 100644
--- a/arch/arm/mach-imx/mm-imx21.c
+++ b/arch/arm/mach-imx/mm-imx21.c
@@ -24,7 +24,6 @@
 #include <mach/common.h>
 #include <asm/pgtable.h>
 #include <asm/mach/map.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 #include <mach/iomux-v1.h>
 
@@ -70,17 +69,17 @@ void __init imx21_init_early(void)
 			MX21_NUM_GPIO_PORT);
 }
 
-static struct mxc_gpio_port imx21_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX21, 0, 1, MX21_INT_GPIO),
-	DEFINE_IMX_GPIO_PORT(MX21, 1, 2),
-	DEFINE_IMX_GPIO_PORT(MX21, 2, 3),
-	DEFINE_IMX_GPIO_PORT(MX21, 3, 4),
-	DEFINE_IMX_GPIO_PORT(MX21, 4, 5),
-	DEFINE_IMX_GPIO_PORT(MX21, 5, 6),
-};
-
 void __init mx21_init_irq(void)
 {
 	mxc_init_irq(MX21_IO_ADDRESS(MX21_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx21_gpio_ports,	ARRAY_SIZE(imx21_gpio_ports));
+}
+
+void __init imx21_soc_init(void)
+{
+	mxc_register_gpio(0, MX21_GPIO1_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(1, MX21_GPIO2_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(2, MX21_GPIO3_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(3, MX21_GPIO4_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(4, MX21_GPIO5_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
+	mxc_register_gpio(5, MX21_GPIO6_BASE_ADDR, SZ_4K, MX21_INT_GPIO, 0);
 }
diff --git a/arch/arm/mach-imx/mm-imx25.c b/arch/arm/mach-imx/mm-imx25.c
index 02f7b5c..1b6d583 100644
--- a/arch/arm/mach-imx/mm-imx25.c
+++ b/arch/arm/mach-imx/mm-imx25.c
@@ -27,7 +27,6 @@
 #include <mach/hardware.h>
 #include <mach/mx25.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 /*
@@ -57,16 +56,15 @@ void __init imx25_init_early(void)
 	mxc_arch_reset_init(MX25_IO_ADDRESS(MX25_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx25_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 0, 1, MX25_INT_GPIO1),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 1, 2, MX25_INT_GPIO2),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 2, 3, MX25_INT_GPIO3),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX25, 3, 4, MX25_INT_GPIO4),
-};
-
 void __init mx25_init_irq(void)
 {
 	mxc_init_irq(MX25_IO_ADDRESS(MX25_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx25_gpio_ports,	ARRAY_SIZE(imx25_gpio_ports));
 }
 
+void __init imx25_soc_init(void)
+{
+	mxc_register_gpio(0, MX25_GPIO1_BASE_ADDR, SZ_16K, MX25_INT_GPIO1, 0);
+	mxc_register_gpio(1, MX25_GPIO2_BASE_ADDR, SZ_16K, MX25_INT_GPIO2, 0);
+	mxc_register_gpio(2, MX25_GPIO3_BASE_ADDR, SZ_16K, MX25_INT_GPIO3, 0);
+	mxc_register_gpio(3, MX25_GPIO4_BASE_ADDR, SZ_16K, MX25_INT_GPIO4, 0);
+}
diff --git a/arch/arm/mach-imx/mm-imx27.c b/arch/arm/mach-imx/mm-imx27.c
index a6761a3..d3700ce 100644
--- a/arch/arm/mach-imx/mm-imx27.c
+++ b/arch/arm/mach-imx/mm-imx27.c
@@ -24,7 +24,6 @@
 #include <mach/common.h>
 #include <asm/pgtable.h>
 #include <asm/mach/map.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 #include <mach/iomux-v1.h>
 
@@ -70,17 +69,17 @@ void __init imx27_init_early(void)
 			MX27_NUM_GPIO_PORT);
 }
 
-static struct mxc_gpio_port imx27_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX27, 0, 1, MX27_INT_GPIO),
-	DEFINE_IMX_GPIO_PORT(MX27, 1, 2),
-	DEFINE_IMX_GPIO_PORT(MX27, 2, 3),
-	DEFINE_IMX_GPIO_PORT(MX27, 3, 4),
-	DEFINE_IMX_GPIO_PORT(MX27, 4, 5),
-	DEFINE_IMX_GPIO_PORT(MX27, 5, 6),
-};
-
 void __init mx27_init_irq(void)
 {
 	mxc_init_irq(MX27_IO_ADDRESS(MX27_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx27_gpio_ports,	ARRAY_SIZE(imx27_gpio_ports));
+}
+
+void __init imx27_soc_init(void)
+{
+	mxc_register_gpio(0, MX27_GPIO1_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(1, MX27_GPIO2_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(2, MX27_GPIO3_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(3, MX27_GPIO4_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(4, MX27_GPIO5_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
+	mxc_register_gpio(5, MX27_GPIO6_BASE_ADDR, SZ_4K, MX27_INT_GPIO, 0);
 }
diff --git a/arch/arm/mach-imx/mm-imx31.c b/arch/arm/mach-imx/mm-imx31.c
index 86b9b45..cb16ac6 100644
--- a/arch/arm/mach-imx/mm-imx31.c
+++ b/arch/arm/mach-imx/mm-imx31.c
@@ -26,7 +26,6 @@
 #include <mach/common.h>
 #include <mach/hardware.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 static struct map_desc mx31_io_desc[] __initdata = {
@@ -53,14 +52,14 @@ void __init imx31_init_early(void)
 	mxc_arch_reset_init(MX31_IO_ADDRESS(MX31_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx31_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX31, 0, 1, MX31_INT_GPIO1),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX31, 1, 2, MX31_INT_GPIO2),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX31, 2, 3, MX31_INT_GPIO3),
-};
-
 void __init mx31_init_irq(void)
 {
 	mxc_init_irq(MX31_IO_ADDRESS(MX31_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx31_gpio_ports,	ARRAY_SIZE(imx31_gpio_ports));
+}
+
+void __init imx31_soc_init(void)
+{
+	mxc_register_gpio(0, MX31_GPIO1_BASE_ADDR, SZ_16K, MX31_INT_GPIO1, 0);
+	mxc_register_gpio(1, MX31_GPIO2_BASE_ADDR, SZ_16K, MX31_INT_GPIO2, 0);
+	mxc_register_gpio(2, MX31_GPIO3_BASE_ADDR, SZ_16K, MX31_INT_GPIO3, 0);
 }
diff --git a/arch/arm/mach-imx/mm-imx35.c b/arch/arm/mach-imx/mm-imx35.c
index c880e6d..648bfca 100644
--- a/arch/arm/mach-imx/mm-imx35.c
+++ b/arch/arm/mach-imx/mm-imx35.c
@@ -27,7 +27,6 @@
 #include <mach/common.h>
 #include <mach/hardware.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 static struct map_desc mx35_io_desc[] __initdata = {
@@ -50,14 +49,14 @@ void __init imx35_init_early(void)
 	mxc_arch_reset_init(MX35_IO_ADDRESS(MX35_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx35_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ(MX35, 0, 1, MX35_INT_GPIO1),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX35, 1, 2, MX35_INT_GPIO2),
-	DEFINE_IMX_GPIO_PORT_IRQ(MX35, 2, 3, MX35_INT_GPIO3),
-};
-
 void __init mx35_init_irq(void)
 {
 	mxc_init_irq(MX35_IO_ADDRESS(MX35_AVIC_BASE_ADDR));
-	mxc_gpio_init(imx35_gpio_ports,	ARRAY_SIZE(imx35_gpio_ports));
+}
+
+void __init imx35_soc_init(void)
+{
+	mxc_register_gpio(0, MX35_GPIO1_BASE_ADDR, SZ_16K, MX35_INT_GPIO1, 0);
+	mxc_register_gpio(1, MX35_GPIO2_BASE_ADDR, SZ_16K, MX35_INT_GPIO2, 0);
+	mxc_register_gpio(2, MX35_GPIO3_BASE_ADDR, SZ_16K, MX35_INT_GPIO3, 0);
 }
diff --git a/arch/arm/mach-mx5/board-cpuimx51.c b/arch/arm/mach-mx5/board-cpuimx51.c
index 4efa02e..add0d42 100644
--- a/arch/arm/mach-mx5/board-cpuimx51.c
+++ b/arch/arm/mach-mx5/board-cpuimx51.c
@@ -245,6 +245,8 @@ __setup("otg_mode=", eukrea_cpuimx51_otg_mode);
  */
 static void __init eukrea_cpuimx51_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx51_pads,
 					ARRAY_SIZE(eukrea_cpuimx51_pads));
 
diff --git a/arch/arm/mach-mx5/board-cpuimx51sd.c b/arch/arm/mach-mx5/board-cpuimx51sd.c
index 5ef25a5..ff096d5 100644
--- a/arch/arm/mach-mx5/board-cpuimx51sd.c
+++ b/arch/arm/mach-mx5/board-cpuimx51sd.c
@@ -264,6 +264,8 @@ static struct platform_device *platform_devices[] __initdata = {
 
 static void __init eukrea_cpuimx51sd_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(eukrea_cpuimx51sd_pads,
 					ARRAY_SIZE(eukrea_cpuimx51sd_pads));
 
diff --git a/arch/arm/mach-mx5/board-mx50_rdp.c b/arch/arm/mach-mx5/board-mx50_rdp.c
index 11210e1..7de25c6 100644
--- a/arch/arm/mach-mx5/board-mx50_rdp.c
+++ b/arch/arm/mach-mx5/board-mx50_rdp.c
@@ -192,6 +192,8 @@ static const struct imxi2c_platform_data i2c_data __initconst = {
  */
 static void __init mx50_rdp_board_init(void)
 {
+	imx50_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx50_rdp_pads,
 					ARRAY_SIZE(mx50_rdp_pads));
 
diff --git a/arch/arm/mach-mx5/board-mx51_3ds.c b/arch/arm/mach-mx5/board-mx51_3ds.c
index 63dfbea..3112d15 100644
--- a/arch/arm/mach-mx5/board-mx51_3ds.c
+++ b/arch/arm/mach-mx5/board-mx51_3ds.c
@@ -135,6 +135,8 @@ static struct spi_board_info mx51_3ds_spi_nor_device[] = {
  */
 static void __init mx51_3ds_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx51_3ds_pads,
 					ARRAY_SIZE(mx51_3ds_pads));
 
diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index c7b3fab..6021dd0 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -340,6 +340,8 @@ static void __init mx51_babbage_init(void)
 	iomux_v3_cfg_t power_key = _MX51_PAD_EIM_A27__GPIO2_21 |
 		MUX_PAD_CTRL(PAD_CTL_SRE_FAST | PAD_CTL_DSE_HIGH | PAD_CTL_PUS_100K_UP);
 
+	imx51_soc_init();
+
 #if defined(CONFIG_CPU_FREQ_IMX)
 	get_cpu_op = mx51_get_cpu_op;
 #endif
diff --git a/arch/arm/mach-mx5/board-mx51_efikamx.c b/arch/arm/mach-mx5/board-mx51_efikamx.c
index 6e36231..3be603b 100644
--- a/arch/arm/mach-mx5/board-mx51_efikamx.c
+++ b/arch/arm/mach-mx5/board-mx51_efikamx.c
@@ -236,6 +236,8 @@ late_initcall(mx51_efikamx_power_init);
 
 static void __init mx51_efikamx_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx51efikamx_pads,
 					ARRAY_SIZE(mx51efikamx_pads));
 	efika_board_common_init();
diff --git a/arch/arm/mach-mx5/board-mx51_efikasb.c b/arch/arm/mach-mx5/board-mx51_efikasb.c
index 474fc6e..4b2e522 100644
--- a/arch/arm/mach-mx5/board-mx51_efikasb.c
+++ b/arch/arm/mach-mx5/board-mx51_efikasb.c
@@ -248,6 +248,8 @@ static void __init mx51_efikasb_board_id(void)
 
 static void __init efikasb_board_init(void)
 {
+	imx51_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx51efikasb_pads,
 					ARRAY_SIZE(mx51efikasb_pads));
 	efika_board_common_init();
diff --git a/arch/arm/mach-mx5/board-mx53_evk.c b/arch/arm/mach-mx5/board-mx53_evk.c
index f87d571..0d9218a 100644
--- a/arch/arm/mach-mx5/board-mx53_evk.c
+++ b/arch/arm/mach-mx5/board-mx53_evk.c
@@ -117,6 +117,8 @@ static const struct spi_imx_master mx53_evk_spi_data __initconst = {
 
 static void __init mx53_evk_board_init(void)
 {
+	imx53_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx53_evk_pads,
 					ARRAY_SIZE(mx53_evk_pads));
 	mx53_evk_init_uart();
diff --git a/arch/arm/mach-mx5/board-mx53_loco.c b/arch/arm/mach-mx5/board-mx53_loco.c
index 1b947e8..359c3e2 100644
--- a/arch/arm/mach-mx5/board-mx53_loco.c
+++ b/arch/arm/mach-mx5/board-mx53_loco.c
@@ -227,6 +227,8 @@ static const struct imxi2c_platform_data mx53_loco_i2c_data __initconst = {
 
 static void __init mx53_loco_board_init(void)
 {
+	imx53_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx53_loco_pads,
 					ARRAY_SIZE(mx53_loco_pads));
 	imx53_add_imx_uart(0, NULL);
diff --git a/arch/arm/mach-mx5/board-mx53_smd.c b/arch/arm/mach-mx5/board-mx53_smd.c
index 817c089..bc02894 100644
--- a/arch/arm/mach-mx5/board-mx53_smd.c
+++ b/arch/arm/mach-mx5/board-mx53_smd.c
@@ -113,6 +113,8 @@ static const struct imxi2c_platform_data mx53_smd_i2c_data __initconst = {
 
 static void __init mx53_smd_board_init(void)
 {
+	imx53_soc_init();
+
 	mxc_iomux_v3_setup_multiple_pads(mx53_smd_pads,
 					ARRAY_SIZE(mx53_smd_pads));
 	mx53_smd_init_uart();
diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
index 153ada5..371ca8c 100644
--- a/arch/arm/mach-mx5/devices.c
+++ b/arch/arm/mach-mx5/devices.c
@@ -12,7 +12,6 @@
 
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <linux/gpio.h>
 #include <mach/hardware.h>
 #include <mach/imx-uart.h>
 #include <mach/irqs.h>
@@ -119,66 +118,3 @@ struct platform_device mxc_usbh2_device = {
 		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
-
-static struct mxc_gpio_port mxc_gpio_ports[] = {
-	{
-		.chip.label = "gpio-0",
-		.base = MX51_IO_ADDRESS(MX51_GPIO1_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO1_LOW,
-		.irq_high = MX51_MXC_INT_GPIO1_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START
-	},
-	{
-		.chip.label = "gpio-1",
-		.base = MX51_IO_ADDRESS(MX51_GPIO2_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO2_LOW,
-		.irq_high = MX51_MXC_INT_GPIO2_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 1
-	},
-	{
-		.chip.label = "gpio-2",
-		.base = MX51_IO_ADDRESS(MX51_GPIO3_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO3_LOW,
-		.irq_high = MX51_MXC_INT_GPIO3_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 2
-	},
-	{
-		.chip.label = "gpio-3",
-		.base = MX51_IO_ADDRESS(MX51_GPIO4_BASE_ADDR),
-		.irq = MX51_MXC_INT_GPIO4_LOW,
-		.irq_high = MX51_MXC_INT_GPIO4_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3
-	},
-	{
-		.chip.label = "gpio-4",
-		.base = MX53_IO_ADDRESS(MX53_GPIO5_BASE_ADDR),
-		.irq = MX53_INT_GPIO5_LOW,
-		.irq_high = MX53_INT_GPIO5_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 4
-	},
-	{
-		.chip.label = "gpio-5",
-		.base = MX53_IO_ADDRESS(MX53_GPIO6_BASE_ADDR),
-		.irq = MX53_INT_GPIO6_LOW,
-		.irq_high = MX53_INT_GPIO6_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 5
-	},
-	{
-		.chip.label = "gpio-6",
-		.base = MX53_IO_ADDRESS(MX53_GPIO7_BASE_ADDR),
-		.irq = MX53_INT_GPIO7_LOW,
-		.irq_high = MX53_INT_GPIO7_HIGH,
-		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 6
-	},
-};
-
-int __init imx51_register_gpios(void)
-{
-	return mxc_gpio_init(mxc_gpio_ports, 4);
-}
-
-int __init imx53_register_gpios(void)
-{
-	return mxc_gpio_init(mxc_gpio_ports, ARRAY_SIZE(mxc_gpio_ports));
-}
-
diff --git a/arch/arm/mach-mx5/mm-mx50.c b/arch/arm/mach-mx5/mm-mx50.c
index b9c363b..28c3f60 100644
--- a/arch/arm/mach-mx5/mm-mx50.c
+++ b/arch/arm/mach-mx5/mm-mx50.c
@@ -26,7 +26,6 @@
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/iomux-v3.h>
-#include <mach/gpio.h>
 #include <mach/irqs.h>
 
 /*
@@ -56,17 +55,17 @@ void __init imx50_init_early(void)
 	mxc_arch_reset_init(MX50_IO_ADDRESS(MX50_WDOG_BASE_ADDR));
 }
 
-static struct mxc_gpio_port imx50_gpio_ports[] = {
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 0, 1, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 1, 2, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 2, 3, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 3, 4, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 4, 5, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(MX50, 5, 6, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH),
-};
-
 void __init mx50_init_irq(void)
 {
 	tzic_init_irq(MX50_IO_ADDRESS(MX50_TZIC_BASE_ADDR));
-	mxc_gpio_init(imx50_gpio_ports,	ARRAY_SIZE(imx50_gpio_ports));
+}
+
+void __init imx50_soc_init(void)
+{
+	mxc_register_gpio(0, MX50_GPIO1_BASE_ADDR, SZ_16K, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH);
+	mxc_register_gpio(1, MX50_GPIO2_BASE_ADDR, SZ_16K, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH);
+	mxc_register_gpio(2, MX50_GPIO3_BASE_ADDR, SZ_16K, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH);
+	mxc_register_gpio(3, MX50_GPIO4_BASE_ADDR, SZ_16K, MX50_INT_GPIO4_LOW, MX50_INT_GPIO4_HIGH);
+	mxc_register_gpio(4, MX50_GPIO5_BASE_ADDR, SZ_16K, MX50_INT_GPIO5_LOW, MX50_INT_GPIO5_HIGH);
+	mxc_register_gpio(5, MX50_GPIO6_BASE_ADDR, SZ_16K, MX50_INT_GPIO6_LOW, MX50_INT_GPIO6_HIGH);
 }
diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
index ff55730..800bb8b2 100644
--- a/arch/arm/mach-mx5/mm.c
+++ b/arch/arm/mach-mx5/mm.c
@@ -69,8 +69,6 @@ void __init imx53_init_early(void)
 	mxc_arch_reset_init(MX53_IO_ADDRESS(MX53_WDOG1_BASE_ADDR));
 }
 
-int imx51_register_gpios(void);
-
 void __init mx51_init_irq(void)
 {
 	unsigned long tzic_addr;
@@ -86,11 +84,8 @@ void __init mx51_init_irq(void)
 		panic("unable to map TZIC interrupt controller\n");
 
 	tzic_init_irq(tzic_virt);
-	imx51_register_gpios();
 }
 
-int imx53_register_gpios(void);
-
 void __init mx53_init_irq(void)
 {
 	unsigned long tzic_addr;
@@ -103,5 +98,23 @@ void __init mx53_init_irq(void)
 		panic("unable to map TZIC interrupt controller\n");
 
 	tzic_init_irq(tzic_virt);
-	imx53_register_gpios();
+}
+
+void __init imx51_soc_init(void)
+{
+	mxc_register_gpio(0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
+	mxc_register_gpio(1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
+	mxc_register_gpio(2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
+	mxc_register_gpio(3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
+}
+
+void __init imx53_soc_init(void)
+{
+	mxc_register_gpio(0, MX53_GPIO1_BASE_ADDR, SZ_16K, MX53_INT_GPIO1_LOW, MX53_INT_GPIO1_HIGH);
+	mxc_register_gpio(1, MX53_GPIO2_BASE_ADDR, SZ_16K, MX53_INT_GPIO2_LOW, MX53_INT_GPIO2_HIGH);
+	mxc_register_gpio(2, MX53_GPIO3_BASE_ADDR, SZ_16K, MX53_INT_GPIO3_LOW, MX53_INT_GPIO3_HIGH);
+	mxc_register_gpio(3, MX53_GPIO4_BASE_ADDR, SZ_16K, MX53_INT_GPIO4_LOW, MX53_INT_GPIO4_HIGH);
+	mxc_register_gpio(4, MX53_GPIO5_BASE_ADDR, SZ_16K, MX53_INT_GPIO5_LOW, MX53_INT_GPIO5_HIGH);
+	mxc_register_gpio(5, MX53_GPIO6_BASE_ADDR, SZ_16K, MX53_INT_GPIO6_LOW, MX53_INT_GPIO6_HIGH);
+	mxc_register_gpio(6, MX53_GPIO7_BASE_ADDR, SZ_16K, MX53_INT_GPIO7_LOW, MX53_INT_GPIO7_HIGH);
 }
diff --git a/arch/arm/plat-mxc/devices.c b/arch/arm/plat-mxc/devices.c
index eee1b60..fb166b2 100644
--- a/arch/arm/plat-mxc/devices.c
+++ b/arch/arm/plat-mxc/devices.c
@@ -89,3 +89,14 @@ err:
 
 	return pdev;
 }
+
+struct device mxc_aips_bus = {
+	.init_name	= "mxc_aips",
+	.parent		= &platform_bus,
+};
+
+static int __init mxc_device_init(void)
+{
+	return device_register(&mxc_aips_bus);
+}
+core_initcall(mxc_device_init);
diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
index ad2922a..b41bf97 100644
--- a/arch/arm/plat-mxc/devices/Makefile
+++ b/arch/arm/plat-mxc/devices/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_FEC) += platform-fec.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_FLEXCAN) += platform-flexcan.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_FSL_USB2_UDC) += platform-fsl-usb2-udc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_GPIO_KEYS) += platform-gpio_keys.o
+obj-y += platform-gpio-mxc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX21_HCD) += platform-imx21-hcd.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX2_WDT) += platform-imx2-wdt.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMXDI_RTC) += platform-imxdi_rtc.o
diff --git a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
new file mode 100644
index 0000000..cf1b7fd
--- /dev/null
+++ b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
@@ -0,0 +1,32 @@
+/*
+ * Copyright 2011 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2011 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#include <mach/devices-common.h>
+
+struct platform_device *__init mxc_register_gpio(int id,
+	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high)
+{
+	struct resource res[] = {
+		{
+			.start = iobase,
+			.end = iobase + iosize - 1,
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = irq,
+			.end = irq,
+			.flags = IORESOURCE_IRQ,
+		}, {
+			.start = irq_high,
+			.end = irq_high,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+
+	return platform_device_register_resndata(&mxc_aips_bus,
+			"gpio-mxc", id, res, ARRAY_SIZE(res), NULL, 0);
+}
diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index da79918..91fa263 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -43,6 +43,15 @@ extern void mx35_init_irq(void);
 extern void mx50_init_irq(void);
 extern void mx51_init_irq(void);
 extern void mx53_init_irq(void);
+extern void imx1_soc_init(void);
+extern void imx21_soc_init(void);
+extern void imx25_soc_init(void);
+extern void imx27_soc_init(void);
+extern void imx31_soc_init(void);
+extern void imx35_soc_init(void);
+extern void imx50_soc_init(void);
+extern void imx51_soc_init(void);
+extern void imx53_soc_init(void);
 extern void epit_timer_init(struct clk *timer_clk, void __iomem *base, int irq);
 extern void mxc_timer_init(struct clk *timer_clk, void __iomem *, int);
 extern int mx1_clocks_init(unsigned long fref);
@@ -55,7 +64,8 @@ extern int mx51_clocks_init(unsigned long ckil, unsigned long osc,
 			unsigned long ckih1, unsigned long ckih2);
 extern int mx53_clocks_init(unsigned long ckil, unsigned long osc,
 			unsigned long ckih1, unsigned long ckih2);
-extern int mxc_register_gpios(void);
+extern struct platform_device *mxc_register_gpio(int id,
+	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high);
 extern int mxc_register_device(struct platform_device *pdev, void *data);
 extern void mxc_set_cpu_type(unsigned int type);
 extern void mxc_arch_reset_init(void __iomem *);
diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
index fa84773..03f6266 100644
--- a/arch/arm/plat-mxc/include/mach/devices-common.h
+++ b/arch/arm/plat-mxc/include/mach/devices-common.h
@@ -10,6 +10,8 @@
 #include <linux/platform_device.h>
 #include <linux/init.h>
 
+extern struct device mxc_aips_bus;
+
 struct platform_device *imx_add_platform_device_dmamask(
 		const char *name, int id,
 		const struct resource *res, unsigned int num_resources,
diff --git a/arch/arm/plat-mxc/include/mach/gpio.h b/arch/arm/plat-mxc/include/mach/gpio.h
index a2747f1..31c820c 100644
--- a/arch/arm/plat-mxc/include/mach/gpio.h
+++ b/arch/arm/plat-mxc/include/mach/gpio.h
@@ -36,31 +36,4 @@
 #define gpio_to_irq(gpio)	(MXC_GPIO_IRQ_START + (gpio))
 #define irq_to_gpio(irq)	((irq) - MXC_GPIO_IRQ_START)
 
-struct mxc_gpio_port {
-	void __iomem *base;
-	int irq;
-	int irq_high;
-	int virtual_irq_start;
-	struct gpio_chip chip;
-	u32 both_edges;
-	spinlock_t lock;
-};
-
-#define DEFINE_IMX_GPIO_PORT_IRQ_HIGH(soc, _id, _hwid, _irq, _irq_high)	\
-	{								\
-		.chip.label = "gpio-" #_id,				\
-		.irq = _irq,						\
-		.irq_high = _irq_high,					\
-		.base = soc ## _IO_ADDRESS(				\
-				soc ## _GPIO ## _hwid ## _BASE_ADDR),	\
-		.virtual_irq_start = MXC_GPIO_IRQ_START + (_id) * 32,	\
-	}
-
-#define DEFINE_IMX_GPIO_PORT_IRQ(soc, _id, _hwid, _irq)			\
-	DEFINE_IMX_GPIO_PORT_IRQ_HIGH(soc, _id, _hwid, _irq, 0)
-#define DEFINE_IMX_GPIO_PORT(soc, _id, _hwid)				\
-	DEFINE_IMX_GPIO_PORT_IRQ(soc, _id, _hwid, 0)
-
-int mxc_gpio_init(struct mxc_gpio_port*, int);
-
 #endif
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 6cd6d7f..844079a 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -24,11 +24,28 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <mach/hardware.h>
 #include <asm-generic/bug.h>
 
-static struct mxc_gpio_port *mxc_gpio_ports;
-static int gpio_table_size;
+struct mxc_gpio_port {
+	struct list_head node;
+	void __iomem *base;
+	int irq;
+	int irq_high;
+	int virtual_irq_start;
+	struct gpio_chip chip;
+	u32 both_edges;
+	spinlock_t lock;
+};
+
+/*
+ * MX2 has one interrupt *for all* gpio ports. The list is used
+ * to save the references to all ports, so that mx2_gpio_irq_handler
+ * can walk through all interrupt status registers.
+ */
+static LIST_HEAD(mxc_gpio_ports);
 
 #define cpu_is_mx1_mx2()	(cpu_is_mx1() || cpu_is_mx2())
 
@@ -50,7 +67,7 @@ static int gpio_table_size;
 
 static void _clear_gpio_irqstatus(struct mxc_gpio_port *port, u32 index)
 {
-	__raw_writel(1 << index, port->base + GPIO_ISR);
+	writel(1 << index, port->base + GPIO_ISR);
 }
 
 static void _set_gpio_irqenable(struct mxc_gpio_port *port, u32 index,
@@ -58,27 +75,30 @@ static void _set_gpio_irqenable(struct mxc_gpio_port *port, u32 index,
 {
 	u32 l;
 
-	l = __raw_readl(port->base + GPIO_IMR);
+	l = readl(port->base + GPIO_IMR);
 	l = (l & (~(1 << index))) | (!!enable << index);
-	__raw_writel(l, port->base + GPIO_IMR);
+	writel(l, port->base + GPIO_IMR);
 }
 
 static void gpio_ack_irq(struct irq_data *d)
 {
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 gpio = irq_to_gpio(d->irq);
-	_clear_gpio_irqstatus(&mxc_gpio_ports[gpio / 32], gpio & 0x1f);
+	_clear_gpio_irqstatus(port, gpio & 0x1f);
 }
 
 static void gpio_mask_irq(struct irq_data *d)
 {
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 gpio = irq_to_gpio(d->irq);
-	_set_gpio_irqenable(&mxc_gpio_ports[gpio / 32], gpio & 0x1f, 0);
+	_set_gpio_irqenable(port, gpio & 0x1f, 0);
 }
 
 static void gpio_unmask_irq(struct irq_data *d)
 {
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 gpio = irq_to_gpio(d->irq);
-	_set_gpio_irqenable(&mxc_gpio_ports[gpio / 32], gpio & 0x1f, 1);
+	_set_gpio_irqenable(port, gpio & 0x1f, 1);
 }
 
 static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset);
@@ -86,7 +106,7 @@ static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset);
 static int gpio_set_irq_type(struct irq_data *d, u32 type)
 {
 	u32 gpio = irq_to_gpio(d->irq);
-	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 bit, val;
 	int edge;
 	void __iomem *reg = port->base;
@@ -122,8 +142,8 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
-	val = __raw_readl(reg) & ~(0x3 << (bit << 1));
-	__raw_writel(val | (edge << (bit << 1)), reg);
+	val = readl(reg) & ~(0x3 << (bit << 1));
+	writel(val | (edge << (bit << 1)), reg);
 	_clear_gpio_irqstatus(port, gpio & 0x1f);
 
 	return 0;
@@ -137,7 +157,7 @@ static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
-	val = __raw_readl(reg);
+	val = readl(reg);
 	edge = (val >> (bit << 1)) & 3;
 	val &= ~(0x3 << (bit << 1));
 	if (edge == GPIO_INT_HIGH_LEV) {
@@ -151,7 +171,7 @@ static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 		       gpio, edge);
 		return;
 	}
-	__raw_writel(val | (edge << (bit << 1)), reg);
+	writel(val | (edge << (bit << 1)), reg);
 }
 
 /* handle 32 interrupts in one status register */
@@ -177,8 +197,7 @@ static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 	u32 irq_stat;
 	struct mxc_gpio_port *port = irq_get_handler_data(irq);
 
-	irq_stat = __raw_readl(port->base + GPIO_ISR) &
-			__raw_readl(port->base + GPIO_IMR);
+	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
 
 	mxc_gpio_irq_handler(port, irq_stat);
 }
@@ -186,19 +205,18 @@ static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 /* MX2 has one interrupt *for all* gpio ports */
 static void mx2_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 {
-	int i;
 	u32 irq_msk, irq_stat;
-	struct mxc_gpio_port *port = irq_get_handler_data(irq);
+	struct mxc_gpio_port *port;
 
 	/* walk through all interrupt status registers */
-	for (i = 0; i < gpio_table_size; i++) {
-		irq_msk = __raw_readl(port[i].base + GPIO_IMR);
+	list_for_each_entry(port, &mxc_gpio_ports, node) {
+		irq_msk = readl(port->base + GPIO_IMR);
 		if (!irq_msk)
 			continue;
 
-		irq_stat = __raw_readl(port[i].base + GPIO_ISR) & irq_msk;
+		irq_stat = readl(port->base + GPIO_ISR) & irq_msk;
 		if (irq_stat)
-			mxc_gpio_irq_handler(&port[i], irq_stat);
+			mxc_gpio_irq_handler(port, irq_stat);
 	}
 }
 
@@ -215,7 +233,7 @@ static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
 {
 	u32 gpio = irq_to_gpio(d->irq);
 	u32 gpio_idx = gpio & 0x1F;
-	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 
 	if (enable) {
 		if (port->irq_high && (gpio_idx >= 16))
@@ -250,12 +268,12 @@ static void _set_gpio_direction(struct gpio_chip *chip, unsigned offset,
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	l = __raw_readl(port->base + GPIO_GDIR);
+	l = readl(port->base + GPIO_GDIR);
 	if (dir)
 		l |= 1 << offset;
 	else
 		l &= ~(1 << offset);
-	__raw_writel(l, port->base + GPIO_GDIR);
+	writel(l, port->base + GPIO_GDIR);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -268,8 +286,8 @@ static void mxc_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	l = (__raw_readl(reg) & (~(1 << offset))) | (!!value << offset);
-	__raw_writel(l, reg);
+	l = (readl(reg) & (~(1 << offset))) | (!!value << offset);
+	writel(l, reg);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -278,7 +296,7 @@ static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct mxc_gpio_port *port =
 		container_of(chip, struct mxc_gpio_port, chip);
 
-	return (__raw_readl(port->base + GPIO_PSR) >> offset) & 1;
+	return (readl(port->base + GPIO_PSR) >> offset) & 1;
 }
 
 static int mxc_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -301,61 +319,116 @@ static int mxc_gpio_direction_output(struct gpio_chip *chip,
  */
 static struct lock_class_key gpio_lock_class;
 
-int __init mxc_gpio_init(struct mxc_gpio_port *port, int cnt)
+static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 {
-	int i, j;
-
-	/* save for local usage */
-	mxc_gpio_ports = port;
-	gpio_table_size = cnt;
-
-	printk(KERN_INFO "MXC GPIO hardware\n");
-
-	for (i = 0; i < cnt; i++) {
-		/* disable the interrupt and clear the status */
-		__raw_writel(0, port[i].base + GPIO_IMR);
-		__raw_writel(~0, port[i].base + GPIO_ISR);
-		for (j = port[i].virtual_irq_start;
-			j < port[i].virtual_irq_start + 32; j++) {
-			irq_set_lockdep_class(j, &gpio_lock_class);
-			irq_set_chip_and_handler(j, &gpio_irq_chip,
-						 handle_level_irq);
-			set_irq_flags(j, IRQF_VALID);
-		}
+	struct mxc_gpio_port *port;
+	struct resource *iores;
+	int err, i;
+
+	port = kzalloc(sizeof(struct mxc_gpio_port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
 
-		/* register gpio chip */
-		port[i].chip.direction_input = mxc_gpio_direction_input;
-		port[i].chip.direction_output = mxc_gpio_direction_output;
-		port[i].chip.get = mxc_gpio_get;
-		port[i].chip.set = mxc_gpio_set;
-		port[i].chip.base = i * 32;
-		port[i].chip.ngpio = 32;
+	port->virtual_irq_start = MXC_GPIO_IRQ_START + pdev->id * 32;
 
-		spin_lock_init(&port[i].lock);
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
+		err = -ENODEV;
+		goto out_kfree;
+	}
 
-		/* its a serious configuration bug when it fails */
-		BUG_ON( gpiochip_add(&port[i].chip) < 0 );
+	if (!request_mem_region(iores->start, resource_size(iores),
+				pdev->name)) {
+		err = -EBUSY;
+		goto out_kfree;
+	}
 
-		if (cpu_is_mx1() || cpu_is_mx3() || cpu_is_mx25() || cpu_is_mx51()) {
-			/* setup one handler for each entry */
-			irq_set_chained_handler(port[i].irq,
-						mx3_gpio_irq_handler);
-			irq_set_handler_data(port[i].irq, &port[i]);
-			if (port[i].irq_high) {
-				/* setup handler for GPIO 16 to 31 */
-				irq_set_chained_handler(port[i].irq_high,
-							mx3_gpio_irq_handler);
-				irq_set_handler_data(port[i].irq_high,
-						     &port[i]);
-			}
-		}
+	port->base = ioremap(iores->start, resource_size(iores));
+	if (!port->base) {
+		err = -ENOMEM;
+		goto out_release_mem;
+	}
+
+	port->irq_high = platform_get_irq(pdev, 1);
+	port->irq = platform_get_irq(pdev, 0);
+	if (port->irq < 0) {
+		err = -EINVAL;
+		goto out_iounmap;
+	}
+
+	/* disable the interrupt and clear the status */
+	writel(0, port->base + GPIO_IMR);
+	writel(~0, port->base + GPIO_ISR);
+
+	for (i = port->virtual_irq_start;
+		i < port->virtual_irq_start + 32; i++) {
+		irq_set_lockdep_class(i, &gpio_lock_class);
+		irq_set_chip_and_handler(i, &gpio_irq_chip, handle_level_irq);
+		set_irq_flags(i, IRQF_VALID);
+		irq_set_chip_data(i, port);
 	}
 
 	if (cpu_is_mx2()) {
 		/* setup one handler for all GPIO interrupts */
-		irq_set_chained_handler(port[0].irq, mx2_gpio_irq_handler);
-		irq_set_handler_data(port[0].irq, port);
+		if (pdev->id == 0)
+			irq_set_chained_handler(port->irq,
+						mx2_gpio_irq_handler);
+	} else {
+		/* setup one handler for each entry */
+		irq_set_chained_handler(port->irq, mx3_gpio_irq_handler);
+		irq_set_handler_data(port->irq, port);
+		if (port->irq_high > 0) {
+			/* setup handler for GPIO 16 to 31 */
+			irq_set_chained_handler(port->irq_high,
+						mx3_gpio_irq_handler);
+			irq_set_handler_data(port->irq_high, port);
+		}
 	}
 
+	/* register gpio chip */
+	port->chip.direction_input = mxc_gpio_direction_input;
+	port->chip.direction_output = mxc_gpio_direction_output;
+	port->chip.get = mxc_gpio_get;
+	port->chip.set = mxc_gpio_set;
+	port->chip.base = pdev->id * 32;
+	port->chip.ngpio = 32;
+
+	spin_lock_init(&port->lock);
+
+	err = gpiochip_add(&port->chip);
+	if (err)
+		goto out_iounmap;
+
+	list_add_tail(&port->node, &mxc_gpio_ports);
+
 	return 0;
+
+out_iounmap:
+	iounmap(port->base);
+out_release_mem:
+	release_mem_region(iores->start, resource_size(iores));
+out_kfree:
+	kfree(port);
+	dev_info(&pdev->dev, "%s failed with errno %d\n", __func__, err);
+	return err;
 }
+
+static struct platform_driver mxc_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-mxc",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= mxc_gpio_probe,
+};
+
+static int __init gpio_mxc_init(void)
+{
+	return platform_driver_register(&mxc_gpio_driver);
+}
+postcore_initcall(gpio_mxc_init);
+
+MODULE_AUTHOR("Freescale Semiconductor, "
+	      "Daniel Mack <danielncaiaq.de>, "
+	      "Juergen Beisert <kernel@pengutronix.de>");
+MODULE_DESCRIPTION("Freescale MXC GPIO");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

