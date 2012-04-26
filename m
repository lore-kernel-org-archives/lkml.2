Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2DZISK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:18:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49654 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2DZISB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:18:01 -0400
Date: Thu, 26 Apr 2012 01:17:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Stephen Warren <swarren@nvidia.com>, Kyle Manna <kyle.manna@fuel7.com>,
        Anirudh Ghayal <aghayal@codeaurora.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Hui Wang <jason77.wang@gmail.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Trilok Soni <tsoni@codeaurora.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Viresh Kumar <viresh.kumar@st.com>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>, Rakesh Iyer <riyer@nvidia.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] Input: matrix-keymap - uninline and prepare for device
 tree support
Message-ID: <20120426081750.GA2684@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change matrix-keymap helper to be out-of-line, like sparse keymap,
allow the helper perform basic keymap validation and return errors,
and prepare for device tree support.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

This was just compiled; no hardware to test.

 drivers/input/Kconfig                       |   17 +++-
 drivers/input/Makefile                      |    2 +-
 drivers/input/keyboard/Kconfig              |   19 ++++-
 drivers/input/keyboard/ep93xx_keypad.c      |   18 ++--
 drivers/input/keyboard/imx_keypad.c         |   17 ++--
 drivers/input/keyboard/intel_mid_keypad.c   |   14 ++-
 drivers/input/keyboard/lm8333.c             |   15 ++--
 drivers/input/keyboard/matrix_keypad.c      |   17 ++--
 drivers/input/keyboard/nomadik-ske-keypad.c |   20 ++--
 drivers/input/keyboard/omap-keypad.c        |   20 ++--
 drivers/input/keyboard/omap4-keypad.c       |   15 ++--
 drivers/input/keyboard/pmic8xxx-keypad.c    |   20 ++--
 drivers/input/keyboard/samsung-keypad.c     |   20 ++--
 drivers/input/keyboard/spear-keyboard.c     |   21 ++--
 drivers/input/keyboard/stmpe-keypad.c       |   16 ++--
 drivers/input/keyboard/tc3589x-keypad.c     |   19 ++--
 drivers/input/keyboard/tca8418_keypad.c     |   15 ++--
 drivers/input/keyboard/tegra-kbc.c          |   34 ++++---
 drivers/input/keyboard/tnetv107x-keypad.c   |   21 ++--
 drivers/input/keyboard/twl4030_keypad.c     |   25 +++---
 drivers/input/keyboard/w90p910_keypad.c     |   27 +++---
 drivers/input/matrix-keymap.c               |  142 +++++++++++++++++++++++++++
 drivers/input/of_keymap.c                   |   87 ----------------
 include/linux/input/matrix_keypad.h         |   38 +------
 24 files changed, 361 insertions(+), 298 deletions(-)

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 3325979..55f7e57 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -25,10 +25,6 @@ config INPUT
 
 if INPUT
 
-config INPUT_OF_MATRIX_KEYMAP
-	depends on USE_OF
-	bool
-
 config INPUT_FF_MEMLESS
 	tristate "Support for memoryless force-feedback devices"
 	help
@@ -68,6 +64,19 @@ config INPUT_SPARSEKMAP
 	  To compile this driver as a module, choose M here: the
 	  module will be called sparse-keymap.
 
+config INPUT_MATRIXKMAP
+	tristate "Matrix keymap support library"
+	help
+	  Say Y here if you are using a driver for an input
+	  device that uses matrix keymap. This option is only
+	  useful for out-of-tree drivers since in-tree drivers
+	  select it automatically.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called matrix-keymap.
+
 comment "Userland interfaces"
 
 config INPUT_MOUSEDEV
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index b173a13a..5ca3f63 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -10,6 +10,7 @@ input-core-y := input.o input-compat.o input-mt.o ff-core.o
 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
 obj-$(CONFIG_INPUT_SPARSEKMAP)	+= sparse-keymap.o
+obj-$(CONFIG_INPUT_MATRIXKMAP)	+= matrix-keymap.o
 
 obj-$(CONFIG_INPUT_MOUSEDEV)	+= mousedev.o
 obj-$(CONFIG_INPUT_JOYDEV)	+= joydev.o
@@ -24,4 +25,3 @@ obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
 obj-$(CONFIG_INPUT_MISC)	+= misc/
 
 obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
-obj-$(CONFIG_INPUT_OF_MATRIX_KEYMAP) += of_keymap.o
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 20a3753..34add1e 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -166,6 +166,7 @@ config KEYBOARD_LKKBD
 config KEYBOARD_EP93XX
 	tristate "EP93xx Matrix Keypad support"
 	depends on ARCH_EP93XX
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here to enable the matrix keypad on the Cirrus EP93XX.
 
@@ -224,6 +225,7 @@ config KEYBOARD_TCA6416
 config KEYBOARD_TCA8418
 	tristate "TCA8418 Keypad Support"
 	depends on I2C
+	select INPUT_MATRIXKMAP
 	help
 	  This driver implements basic keypad functionality
 	  for keys connected through TCA8418 keypad decoder.
@@ -240,6 +242,7 @@ config KEYBOARD_TCA8418
 config KEYBOARD_MATRIX
 	tristate "GPIO driven matrix keypad support"
 	depends on GENERIC_GPIO
+	select INPUT_MATRIXKMAP
 	help
 	  Enable support for GPIO driven matrix keypad.
 
@@ -312,6 +315,7 @@ config KEYBOARD_LM8323
 config KEYBOARD_LM8333
 	tristate "LM8333 keypad chip"
 	depends on I2C
+	select INPUT_MATRIXKMAP
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LM8333 keypad controller.
@@ -376,6 +380,7 @@ config KEYBOARD_MPR121
 config KEYBOARD_IMX
 	tristate "IMX keypad support"
 	depends on ARCH_MXC
+	select INPUT_MATRIXKMAP
 	help
 	  Enable support for IMX keypad port.
 
@@ -385,6 +390,7 @@ config KEYBOARD_IMX
 config KEYBOARD_INTEL_MID
 	tristate "Intel MID keypad support"
 	depends on GPIO_LANGWELL
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y if you want support for Intel MID keypad devices.
 
@@ -403,6 +409,7 @@ config KEYBOARD_NEWTON
 config KEYBOARD_NOMADIK
 	tristate "ST-Ericsson Nomadik SKE keyboard"
 	depends on PLAT_NOMADIK
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use a keypad provided on the SKE controller
 	  used on the Ux500 and Nomadik platforms
@@ -413,7 +420,7 @@ config KEYBOARD_NOMADIK
 config KEYBOARD_TEGRA
 	tristate "NVIDIA Tegra internal matrix keyboard controller support"
 	depends on ARCH_TEGRA
-	select INPUT_OF_MATRIX_KEYMAP if USE_OF
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use a matrix keyboard connected directly
 	  to the internal keyboard controller on Tegra SoCs.
@@ -451,6 +458,7 @@ config KEYBOARD_PXA930_ROTARY
 config KEYBOARD_PMIC8XXX
 	tristate "Qualcomm PMIC8XXX keypad support"
 	depends on MFD_PM8XXX
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to enable the driver for the PMIC8XXX
 	  keypad provided as a reference design from Qualcomm. This is intended
@@ -462,6 +470,7 @@ config KEYBOARD_PMIC8XXX
 config KEYBOARD_SAMSUNG
 	tristate "Samsung keypad support"
 	depends on HAVE_CLK
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the keypad on your Samsung mobile
 	  device.
@@ -504,6 +513,7 @@ config KEYBOARD_SH_KEYSC
 config KEYBOARD_STMPE
 	tristate "STMPE keypad support"
 	depends on MFD_STMPE
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the keypad controller on STMPE I/O
 	  expanders.
@@ -524,6 +534,7 @@ config KEYBOARD_DAVINCI
 config KEYBOARD_OMAP
 	tristate "TI OMAP keypad support"
 	depends on (ARCH_OMAP1 || ARCH_OMAP2)
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the OMAP keypad.
 
@@ -532,6 +543,7 @@ config KEYBOARD_OMAP
 
 config KEYBOARD_OMAP4
 	tristate "TI OMAP4 keypad support"
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the OMAP4 keypad.
 
@@ -541,6 +553,7 @@ config KEYBOARD_OMAP4
 config KEYBOARD_SPEAR
 	tristate "ST SPEAR keyboard support"
 	depends on PLAT_SPEAR
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the SPEAR keyboard.
 
@@ -550,6 +563,7 @@ config KEYBOARD_SPEAR
 config KEYBOARD_TC3589X
 	tristate "TC3589X Keypad support"
 	depends on MFD_TC3589X
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the keypad controller on
 	  TC35892/3 I/O expander.
@@ -560,6 +574,7 @@ config KEYBOARD_TC3589X
 config KEYBOARD_TNETV107X
 	tristate "TI TNETV107X keypad support"
 	depends on ARCH_DAVINCI_TNETV107X
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the TNETV107X keypad.
 
@@ -569,6 +584,7 @@ config KEYBOARD_TNETV107X
 config KEYBOARD_TWL4030
 	tristate "TI TWL4030/TWL5030/TPS659x0 keypad support"
 	depends on TWL4030_CORE
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if your board use the keypad controller on
 	  TWL4030 family chips.  It's safe to say enable this
@@ -592,6 +608,7 @@ config KEYBOARD_XTKBD
 config KEYBOARD_W90P910
 	tristate "W90P910 Matrix Keypad support"
 	depends on ARCH_W90X900
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here to enable the matrix keypad on evaluation board
 	  based on W90P910.
diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
index df194bd..c46fc81 100644
--- a/drivers/input/keyboard/ep93xx_keypad.c
+++ b/drivers/input/keyboard/ep93xx_keypad.c
@@ -303,19 +303,16 @@ static int __devinit ep93xx_keypad_probe(struct platform_device *pdev)
 	input_dev->open = ep93xx_keypad_open;
 	input_dev->close = ep93xx_keypad_close;
 	input_dev->dev.parent = &pdev->dev;
-	input_dev->keycode = keypad->keycodes;
-	input_dev->keycodesize = sizeof(keypad->keycodes[0]);
-	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
 
-	input_set_drvdata(input_dev, keypad);
+	err = matrix_keypad_build_keymap(keymap_data, NULL,
+					 EP93XX_MATRIX_ROWS, EP93XX_MATRIX_COLS,
+					 keypad->keycodes, input_dev);
+	if (err)
+		goto failed_free_dev;
 
-	input_dev->evbit[0] = BIT_MASK(EV_KEY);
 	if (keypad->pdata->flags & EP93XX_KEYPAD_AUTOREPEAT)
-		input_dev->evbit[0] |= BIT_MASK(EV_REP);
-
-	matrix_keypad_build_keymap(keymap_data, 3,
-				   input_dev->keycode, input_dev->keybit);
-	platform_set_drvdata(pdev, keypad);
+		__set_bit(EV_REP, input_dev->evbit);
+	input_set_drvdata(input_dev, keypad);
 
 	err = request_irq(keypad->irq, ep93xx_keypad_irq_handler,
 			  0, pdev->name, keypad);
@@ -326,6 +323,7 @@ static int __devinit ep93xx_keypad_probe(struct platform_device *pdev)
 	if (err)
 		goto failed_free_irq;
 
+	platform_set_drvdata(pdev, keypad);
 	device_init_wakeup(&pdev->dev, 1);
 
 	return 0;
diff --git a/drivers/input/keyboard/imx_keypad.c b/drivers/input/keyboard/imx_keypad.c
index fb87b3b..6ee7421 100644
--- a/drivers/input/keyboard/imx_keypad.c
+++ b/drivers/input/keyboard/imx_keypad.c
@@ -481,7 +481,7 @@ static int __devinit imx_keypad_probe(struct platform_device *pdev)
 	}
 
 	if (keypad->rows_en_mask > ((1 << MAX_MATRIX_KEY_ROWS) - 1) ||
-	   keypad->cols_en_mask > ((1 << MAX_MATRIX_KEY_COLS) - 1)) {
+	    keypad->cols_en_mask > ((1 << MAX_MATRIX_KEY_COLS) - 1)) {
 		dev_err(&pdev->dev,
 			"invalid key data (too many rows or colums)\n");
 		error = -EINVAL;
@@ -496,14 +496,17 @@ static int __devinit imx_keypad_probe(struct platform_device *pdev)
 	input_dev->dev.parent = &pdev->dev;
 	input_dev->open = imx_keypad_open;
 	input_dev->close = imx_keypad_close;
-	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
-	input_dev->keycode = keypad->keycodes;
-	input_dev->keycodesize = sizeof(keypad->keycodes[0]);
-	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
 
-	matrix_keypad_build_keymap(keymap_data, MATRIX_ROW_SHIFT,
-				keypad->keycodes, input_dev->keybit);
+	error = matrix_keypad_build_keymap(keymap_data, NULL,
+					   MAX_MATRIX_KEY_ROWS,
+					   MAX_MATRIX_KEY_COLS,
+					   keypad->keycodes, input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto failed_clock_put;
+	}
 
+	__set_bit(EV_REP, input_dev->evbit);
 	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
 	input_set_drvdata(input_dev, keypad);
 
diff --git a/drivers/input/keyboard/intel_mid_keypad.c b/drivers/input/keyboard/intel_mid_keypad.c
index b7034e7..a6870bc 100644
--- a/drivers/input/keyboard/intel_mid_keypad.c
+++ b/drivers/input/keyboard/intel_mid_keypad.c
@@ -238,7 +238,7 @@ struct mrst_keypad {
 	int rotary_down_key[2];
 };
 
-static void mrst_keypad_build_keycode(struct mrst_keypad *keypad)
+static int mrst_keypad_build_keycode(struct mrst_keypad *keypad)
 {
 	struct input_dev *input_dev = keypad->input_dev;
 	const struct matrix_keymap_data *keymap_data;
@@ -265,13 +265,15 @@ static void mrst_keypad_build_keycode(struct mrst_keypad *keypad)
 		keypad->enable_rotary1 = mrst_keypad_pdata->enable_rotary1 ?: 0;
 	}
 
-	matrix_keypad_build_keymap(keymap_data, MATRIX_ROW_SHIFT,
-		 input_dev->keycode, input_dev->keybit);
+	error = matrix_keypad_build_keymap(keymap_data, MATRIX_ROW_SHIFT,
+					   input_dev);
 
 	if (keypad->direct_key_num) {
 		matrix_keypad_build_keymap(direct_keymap_data, MATRIX_ROW_SHIFT,
 			 keypad->direct_keycode, input_dev->keybit);
 	}
+
+	return 0;
 }
 
 int __init mrst_keypad_set_pdata(const struct mrst_keypad_platform_data *data)
@@ -612,7 +614,11 @@ static int __devinit mrst_keypad_probe(struct pci_dev *pdev,
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) |
 		BIT_MASK(EV_REL);
 
-	mrst_keypad_build_keycode(keypad);
+	error = mrst_keypad_build_keycode(keypad);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto failed_free_iounmap;
+	}
 
 	error = request_irq(pdev->irq, mrst_keypad_irq_handler,
 			    IRQF_SHARED, pci_name(pdev), keypad);
diff --git a/drivers/input/keyboard/lm8333.c b/drivers/input/keyboard/lm8333.c
index 9a8c4a6..ca168a6 100644
--- a/drivers/input/keyboard/lm8333.c
+++ b/drivers/input/keyboard/lm8333.c
@@ -29,9 +29,9 @@
 
 #define LM8333_FIFO_TRANSFER_SIZE	16
 
-#define LM8333_ROW_SHIFT	4
 #define LM8333_NUM_ROWS		8
-
+#define LM8333_NUM_COLS		16
+#define LM8333_ROW_SHIFT	4
 
 struct lm8333 {
 	struct i2c_client *client;
@@ -159,14 +159,13 @@ static int __devinit lm8333_probe(struct i2c_client *client,
 	input->dev.parent = &client->dev;
 	input->id.bustype = BUS_I2C;
 
-	input->keycode = lm8333->keycodes;
-	input->keycodesize = sizeof(lm8333->keycodes[0]);
-	input->keycodemax = ARRAY_SIZE(lm8333->keycodes);
-	input->evbit[0] = BIT_MASK(EV_KEY);
 	input_set_capability(input, EV_MSC, MSC_SCAN);
 
-	matrix_keypad_build_keymap(pdata->matrix_data, LM8333_ROW_SHIFT,
-			input->keycode, input->keybit);
+	err = matrix_keypad_build_keymap(pdata->matrix_data, NULL,
+					 LM8333_NUM_ROWS, LM8333_NUM_COLS,
+					 lm8333->keycodes, input);
+	if (err)
+		goto free_mem;
 
 	if (pdata->debounce_time) {
 		err = lm8333_write8(lm8333, LM8333_DEBOUNCE,
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 98ae281..18b7237 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -437,19 +437,18 @@ static int __devinit matrix_keypad_probe(struct platform_device *pdev)
 	input_dev->name		= pdev->name;
 	input_dev->id.bustype	= BUS_HOST;
 	input_dev->dev.parent	= &pdev->dev;
-	input_dev->evbit[0]	= BIT_MASK(EV_KEY);
-	if (!pdata->no_autorepeat)
-		input_dev->evbit[0] |= BIT_MASK(EV_REP);
 	input_dev->open		= matrix_keypad_start;
 	input_dev->close	= matrix_keypad_stop;
 
-	input_dev->keycode	= keypad->keycodes;
-	input_dev->keycodesize	= sizeof(keypad->keycodes[0]);
-	input_dev->keycodemax	= pdata->num_row_gpios << row_shift;
-
-	matrix_keypad_build_keymap(keymap_data, row_shift,
-				   input_dev->keycode, input_dev->keybit);
+	err = matrix_keypad_build_keymap(keymap_data, NULL,
+					 pdata->num_row_gpios,
+					 pdata->num_col_gpios,
+					 keypad->keycodes, input_dev);
+	if (err)
+		goto err_free_mem;
 
+	if (!pdata->no_autorepeat)
+		__set_bit(EV_REP, input_dev->evbit);
 	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
 	input_set_drvdata(input_dev, keypad);
 
diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index 101e245..4ea4341 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -39,7 +39,8 @@
 #define SKE_KPRISA	(0x1 << 2)
 
 #define SKE_KEYPAD_ROW_SHIFT	3
-#define SKE_KPD_KEYMAP_SIZE	(8 * 8)
+#define SKE_KPD_NUM_ROWS	8
+#define SKE_KPD_NUM_COLS	8
 
 /* keypad auto scan registers */
 #define SKE_ASR0	0x20
@@ -63,7 +64,7 @@ struct ske_keypad {
 	void __iomem *reg_base;
 	struct input_dev *input;
 	const struct ske_keypad_platform_data *board;
-	unsigned short keymap[SKE_KPD_KEYMAP_SIZE];
+	unsigned short keymap[SKE_KPD_NUM_ROWS * SKE_KPD_NUM_COLS];
 	struct clk *clk;
 	spinlock_t ske_keypad_lock;
 };
@@ -261,19 +262,18 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 	input->name = "ux500-ske-keypad";
 	input->dev.parent = &pdev->dev;
 
-	input->keycode = keypad->keymap;
-	input->keycodesize = sizeof(keypad->keymap[0]);
-	input->keycodemax = ARRAY_SIZE(keypad->keymap);
+	error = matrix_keypad_build_keymap(plat->keymap_data, NULL,
+					   SKE_KPD_NUM_ROWS, SKE_KPD_NUM_COLS,
+					   keypad->keymap, input);
+	if (error) {
+		dev_err(&pdev->dev, "Failed to build keymap\n");
+		goto err_iounmap;
+	}
 
 	input_set_capability(input, EV_MSC, MSC_SCAN);
-
-	__set_bit(EV_KEY, input->evbit);
 	if (!plat->no_autorepeat)
 		__set_bit(EV_REP, input->evbit);
 
-	matrix_keypad_build_keymap(plat->keymap_data, SKE_KEYPAD_ROW_SHIFT,
-			input->keycode, input->keybit);
-
 	clk_enable(keypad->clk);
 
 	/* go through board initialization helpers */
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 6b630d9..a0222db 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -61,6 +61,7 @@ struct omap_kp {
 	unsigned int cols;
 	unsigned long delay;
 	unsigned int debounce;
+	unsigned short keymap[];
 };
 
 static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);
@@ -316,13 +317,6 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 	if (!cpu_is_omap24xx())
 		omap_writew(1, OMAP1_MPUIO_BASE + OMAP_MPUIO_KBD_MASKIT);
 
-	input_dev->keycode      = &omap_kp[1];
-	input_dev->keycodesize  = sizeof(unsigned short);
-	input_dev->keycodemax   = keycodemax;
-
-	if (pdata->rep)
-		__set_bit(EV_REP, input_dev->evbit);
-
 	if (pdata->delay)
 		omap_kp->delay = pdata->delay;
 
@@ -371,9 +365,6 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 		goto err2;
 
 	/* setup input device */
-	__set_bit(EV_KEY, input_dev->evbit);
-	matrix_keypad_build_keymap(pdata->keymap_data, row_shift,
-			input_dev->keycode, input_dev->keybit);
 	input_dev->name = "omap-keypad";
 	input_dev->phys = "omap-keypad/input0";
 	input_dev->dev.parent = &pdev->dev;
@@ -383,6 +374,15 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 	input_dev->id.product = 0x0001;
 	input_dev->id.version = 0x0100;
 
+	if (pdata->rep)
+		__set_bit(EV_REP, input_dev->evbit);
+
+	ret = matrix_keypad_build_keymap(pdata->keymap_data, NULL,
+					 pdata->rows, pdata->cols,
+					 omap_kp->keymap, input_dev);
+	if (ret < 0)
+		goto err3;
+
 	ret = input_register_device(omap_kp->input);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to register omap-keypad input device\n");
diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index e809ac0..81c9b16 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -258,20 +258,19 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 	input_dev->open = omap4_keypad_open;
 	input_dev->close = omap4_keypad_close;
 
-	input_dev->keycode	= keypad_data->keymap;
-	input_dev->keycodesize	= sizeof(keypad_data->keymap[0]);
-	input_dev->keycodemax	= max_keys;
+	error = matrix_keypad_build_keymap(pdata->keymap_data, NULL,
+					   pdata->rows, pdata->cols,
+					   keypad_data->keymap, input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto err_free_input;
+	}
 
-	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(EV_REP, input_dev->evbit);
-
 	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
 
 	input_set_drvdata(input_dev, keypad_data);
 
-	matrix_keypad_build_keymap(pdata->keymap_data, row_shift,
-			input_dev->keycode, input_dev->keybit);
-
 	error = request_irq(keypad_data->irq, omap4_keypad_interrupt,
 			     IRQF_TRIGGER_RISING,
 			     "omap4-keypad", keypad_data);
diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index 01a1c9f..52c3465 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -626,21 +626,21 @@ static int __devinit pmic8xxx_kp_probe(struct platform_device *pdev)
 	kp->input->id.product	= 0x0001;
 	kp->input->id.vendor	= 0x0001;
 
-	kp->input->evbit[0]	= BIT_MASK(EV_KEY);
-
-	if (pdata->rep)
-		__set_bit(EV_REP, kp->input->evbit);
-
-	kp->input->keycode	= kp->keycodes;
-	kp->input->keycodemax	= PM8XXX_MATRIX_MAX_SIZE;
-	kp->input->keycodesize	= sizeof(kp->keycodes);
 	kp->input->open		= pmic8xxx_kp_open;
 	kp->input->close	= pmic8xxx_kp_close;
 
-	matrix_keypad_build_keymap(keymap_data, PM8XXX_ROW_SHIFT,
-					kp->input->keycode, kp->input->keybit);
+	rc = matrix_keypad_build_keymap(keymap_data, NULL,
+					PM8XXX_MAX_ROWS, PM8XXX_MAX_COLS,
+					kp->keycodes, kp->input);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto err_get_irq;
+	}
 
+	if (pdata->rep)
+		__set_bit(EV_REP, kp->input->evbit);
 	input_set_capability(kp->input, EV_MSC, MSC_SCAN);
+
 	input_set_drvdata(kp->input, kp);
 
 	/* initialize keypad state */
diff --git a/drivers/input/keyboard/samsung-keypad.c b/drivers/input/keyboard/samsung-keypad.c
index f37441c..0c0fa46 100644
--- a/drivers/input/keyboard/samsung-keypad.c
+++ b/drivers/input/keyboard/samsung-keypad.c
@@ -457,23 +457,23 @@ static int __devinit samsung_keypad_probe(struct platform_device *pdev)
 	input_dev->name = pdev->name;
 	input_dev->id.bustype = BUS_HOST;
 	input_dev->dev.parent = &pdev->dev;
-	input_set_drvdata(input_dev, keypad);
 
 	input_dev->open = samsung_keypad_open;
 	input_dev->close = samsung_keypad_close;
 
-	input_dev->evbit[0] = BIT_MASK(EV_KEY);
-	if (!pdata->no_autorepeat)
-		input_dev->evbit[0] |= BIT_MASK(EV_REP);
+	error = matrix_keypad_build_keymap(keymap_data, NULL,
+					   pdata->rows, pdata->cols,
+					   keypad->keycodes, input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto err_put_clk;
+	}
 
 	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
+	if (!pdata->no_autorepeat)
+		__set_bit(EV_REP, input_dev->evbit);
 
-	input_dev->keycode = keypad->keycodes;
-	input_dev->keycodesize = sizeof(keypad->keycodes[0]);
-	input_dev->keycodemax = pdata->rows << row_shift;
-
-	matrix_keypad_build_keymap(keymap_data, row_shift,
-			input_dev->keycode, input_dev->keybit);
+	input_set_drvdata(input_dev, keypad);
 
 	keypad->irq = platform_get_irq(pdev, 0);
 	if (keypad->irq < 0) {
diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index 3b6b528..7c8f2bc 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -49,7 +49,9 @@
 #define KEY_VALUE	0x00FFFFFF
 #define ROW_MASK	0xF0
 #define COLUMN_MASK	0x0F
-#define ROW_SHIFT	4
+#define NUM_ROWS	16
+#define NUM_COLS	16
+
 #define KEY_MATRIX_SHIFT	6
 
 struct spear_kbd {
@@ -60,7 +62,7 @@ struct spear_kbd {
 	unsigned int irq;
 	unsigned int mode;
 	unsigned short last_key;
-	unsigned short keycodes[256];
+	unsigned short keycodes[NUM_ROWS * NUM_COLS];
 };
 
 static irqreturn_t spear_kbd_interrupt(int irq, void *dev_id)
@@ -212,18 +214,17 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
 	input_dev->open = spear_kbd_open;
 	input_dev->close = spear_kbd_close;
 
-	__set_bit(EV_KEY, input_dev->evbit);
+	error = matrix_keypad_build_keymap(keymap, NULL, NUM_ROWS, NUM_COLS,
+					   kbd->keycodes, input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "Failed to build keymap\n");
+		goto errr_put_clk;
+	}
+
 	if (pdata->rep)
 		__set_bit(EV_REP, input_dev->evbit);
 	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
 
-	input_dev->keycode = kbd->keycodes;
-	input_dev->keycodesize = sizeof(kbd->keycodes[0]);
-	input_dev->keycodemax = ARRAY_SIZE(kbd->keycodes);
-
-	matrix_keypad_build_keymap(keymap, ROW_SHIFT,
-			input_dev->keycode, input_dev->keybit);
-
 	input_set_drvdata(input_dev, kbd);
 
 	error = request_irq(irq, spear_kbd_interrupt, 0, "keyboard", kbd);
diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
index 9397cf9..470a877 100644
--- a/drivers/input/keyboard/stmpe-keypad.c
+++ b/drivers/input/keyboard/stmpe-keypad.c
@@ -289,19 +289,17 @@ static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
 	input->id.bustype = BUS_I2C;
 	input->dev.parent = &pdev->dev;
 
-	input_set_capability(input, EV_MSC, MSC_SCAN);
+	ret = matrix_keypad_build_keymap(plat->keymap_data, NULL,
+					 STMPE_KEYPAD_MAX_ROWS,
+					 STMPE_KEYPAD_MAX_COLS,
+					 keypad->keymap, input);
+	if (ret)
+		goto out_freeinput;
 
-	__set_bit(EV_KEY, input->evbit);
+	input_set_capability(input, EV_MSC, MSC_SCAN);
 	if (!plat->no_autorepeat)
 		__set_bit(EV_REP, input->evbit);
 
-	input->keycode = keypad->keymap;
-	input->keycodesize = sizeof(keypad->keymap[0]);
-	input->keycodemax = ARRAY_SIZE(keypad->keymap);
-
-	matrix_keypad_build_keymap(plat->keymap_data, STMPE_KEYPAD_ROW_SHIFT,
-				   input->keycode, input->keybit);
-
 	for (i = 0; i < plat->keymap_data->keymap_size; i++) {
 		unsigned int key = plat->keymap_data->keymap[i];
 
diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
index f4da2a7..7d498e6 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -78,7 +78,7 @@
  * @input:      pointer to input device object
  * @board:      keypad platform device
  * @krow:	number of rows
- * @kcol:	number of coloumns
+ * @kcol:	number of columns
  * @keymap:     matrix scan code table for keycodes
  * @keypad_stopped: holds keypad status
  */
@@ -333,23 +333,22 @@ static int __devinit tc3589x_keypad_probe(struct platform_device *pdev)
 	input->name = pdev->name;
 	input->dev.parent = &pdev->dev;
 
-	input->keycode = keypad->keymap;
-	input->keycodesize = sizeof(keypad->keymap[0]);
-	input->keycodemax = ARRAY_SIZE(keypad->keymap);
-
 	input->open = tc3589x_keypad_open;
 	input->close = tc3589x_keypad_close;
 
-	input_set_drvdata(input, keypad);
+	error = matrix_keypad_build_keymap(plat->keymap_data, NULL,
+					   TC3589x_MAX_KPROW, TC3589x_MAX_KPCOL,
+					   keypad->keymap, input);
+	if (error) {
+		dev_err(&pdev->dev, "Failed to build keymap\n");
+		goto err_free_mem;
+	}
 
 	input_set_capability(input, EV_MSC, MSC_SCAN);
-
-	__set_bit(EV_KEY, input->evbit);
 	if (!plat->no_autorepeat)
 		__set_bit(EV_REP, input->evbit);
 
-	matrix_keypad_build_keymap(plat->keymap_data, 0x3,
-			input->keycode, input->keybit);
+	input_set_drvdata(input, keypad);
 
 	error = request_threaded_irq(irq, NULL,
 			tc3589x_keypad_irq, plat->irqtype,
diff --git a/drivers/input/keyboard/tca8418_keypad.c b/drivers/input/keyboard/tca8418_keypad.c
index 958ec10..5f87b28 100644
--- a/drivers/input/keyboard/tca8418_keypad.c
+++ b/drivers/input/keyboard/tca8418_keypad.c
@@ -342,21 +342,20 @@ static int __devinit tca8418_keypad_probe(struct i2c_client *client,
 	input->id.product = 0x001;
 	input->id.version = 0x0001;
 
-	input->keycode     = keypad_data->keymap;
-	input->keycodesize = sizeof(keypad_data->keymap[0]);
-	input->keycodemax  = max_keys;
+	error = matrix_keypad_build_keymap(pdata->keymap_data, NULL,
+					   pdata->rows, pdata->cols,
+					   keypad_data->keymap, input);
+	if (error) {
+		dev_dbg(&client->dev, "Failed to build keymap\n");
+		goto fail2;
+	}
 
-	__set_bit(EV_KEY, input->evbit);
 	if (pdata->rep)
 		__set_bit(EV_REP, input->evbit);
-
 	input_set_capability(input, EV_MSC, MSC_SCAN);
 
 	input_set_drvdata(input, keypad_data);
 
-	matrix_keypad_build_keymap(pdata->keymap_data, row_shift,
-			input->keycode, input->keybit);
-
 	if (pdata->irq_is_gpio)
 		client->irq = gpio_to_irq(client->irq);
 
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index fe4ac95..6722d37 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -686,6 +686,7 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 	int num_rows = 0;
 	unsigned int debounce_cnt;
 	unsigned int scan_time_rows;
+	unsigned int keymap_rows;
 
 	if (!pdata)
 		pdata = tegra_kbc_dt_parse_pdata(pdev);
@@ -757,29 +758,34 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 	kbc->repoll_dly = KBC_ROW_SCAN_DLY + scan_time_rows + pdata->repeat_cnt;
 	kbc->repoll_dly = DIV_ROUND_UP(kbc->repoll_dly, KBC_CYCLE_MS);
 
+	kbc->wakeup_key = pdata->wakeup_key;
+	kbc->use_fn_map = pdata->use_fn_map;
+	kbc->use_ghost_filter = pdata->use_ghost_filter;
+
 	input_dev->name = pdev->name;
 	input_dev->id.bustype = BUS_HOST;
 	input_dev->dev.parent = &pdev->dev;
 	input_dev->open = tegra_kbc_open;
 	input_dev->close = tegra_kbc_close;
 
-	input_set_drvdata(input_dev, kbc);
-
-	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
-	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
-
-	input_dev->keycode = kbc->keycode;
-	input_dev->keycodesize = sizeof(kbc->keycode[0]);
-	input_dev->keycodemax = KBC_MAX_KEY;
+	keymap_rows = KBC_MAX_KEY;
 	if (pdata->use_fn_map)
-		input_dev->keycodemax *= 2;
+		keymap_rows *= 2;
 
-	kbc->use_fn_map = pdata->use_fn_map;
-	kbc->use_ghost_filter = pdata->use_ghost_filter;
 	keymap_data = pdata->keymap_data ?: &tegra_kbc_default_keymap_data;
-	matrix_keypad_build_keymap(keymap_data, KBC_ROW_SHIFT,
-				   input_dev->keycode, input_dev->keybit);
-	kbc->wakeup_key = pdata->wakeup_key;
+
+	err = matrix_keypad_build_keymap(keymap_data, NULL,
+					 keymap_rows, KBC_MAX_COL,
+					 kbc->keycode, input_dev);
+	if (err) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto err_put_clk;
+	}
+
+	__set_bit(EV_REP, input_dev->evbit);
+	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
+
+	input_set_drvdata(input_dev, kbc);
 
 	err = request_irq(kbc->irq, tegra_kbc_isr,
 			  IRQF_NO_SUSPEND | IRQF_TRIGGER_HIGH, pdev->name, kbc);
diff --git a/drivers/input/keyboard/tnetv107x-keypad.c b/drivers/input/keyboard/tnetv107x-keypad.c
index fb39c94..a4a445f 100644
--- a/drivers/input/keyboard/tnetv107x-keypad.c
+++ b/drivers/input/keyboard/tnetv107x-keypad.c
@@ -247,15 +247,11 @@ static int __devinit keypad_probe(struct platform_device *pdev)
 		error = -ENOMEM;
 		goto error_input;
 	}
-	input_set_drvdata(kp->input_dev, kp);
 
 	kp->input_dev->name	  = pdev->name;
 	kp->input_dev->dev.parent = &pdev->dev;
 	kp->input_dev->open	  = keypad_start;
 	kp->input_dev->close	  = keypad_stop;
-	kp->input_dev->evbit[0]	  = BIT_MASK(EV_KEY);
-	if (!pdata->no_autorepeat)
-		kp->input_dev->evbit[0] |= BIT_MASK(EV_REP);
 
 	clk_enable(kp->clk);
 	rev = keypad_read(kp, rev);
@@ -264,15 +260,20 @@ static int __devinit keypad_probe(struct platform_device *pdev)
 	kp->input_dev->id.version = ((rev >> 16) & 0xfff);
 	clk_disable(kp->clk);
 
-	kp->input_dev->keycode     = kp->keycodes;
-	kp->input_dev->keycodesize = sizeof(kp->keycodes[0]);
-	kp->input_dev->keycodemax  = kp->rows << kp->row_shift;
-
-	matrix_keypad_build_keymap(keymap_data, kp->row_shift, kp->keycodes,
-				   kp->input_dev->keybit);
+	error = matrix_keypad_build_keymap(keymap_data, NULL,
+					   kp->rows, kp->cols,
+					   kp->keycodes, kp->input_dev);
+	if (error) {
+		dev_err(dev, "Failed to build keymap\n");
+		goto error_reg;
+	}
 
+	if (!pdata->no_autorepeat)
+		kp->input_dev->evbit[0] |= BIT_MASK(EV_REP);
 	input_set_capability(kp->input_dev, EV_MSC, MSC_SCAN);
 
+	input_set_drvdata(kp->input_dev, kp);
+
 	error = input_register_device(kp->input_dev);
 	if (error < 0) {
 		dev_err(dev, "Could not register input device\n");
diff --git a/drivers/input/keyboard/twl4030_keypad.c b/drivers/input/keyboard/twl4030_keypad.c
index 67bec14..a2c6f79 100644
--- a/drivers/input/keyboard/twl4030_keypad.c
+++ b/drivers/input/keyboard/twl4030_keypad.c
@@ -361,14 +361,6 @@ static int __devinit twl4030_kp_probe(struct platform_device *pdev)
 	kp->irq = platform_get_irq(pdev, 0);
 
 	/* setup input device */
-	__set_bit(EV_KEY, input->evbit);
-
-	/* Enable auto repeat feature of Linux input subsystem */
-	if (pdata->rep)
-		__set_bit(EV_REP, input->evbit);
-
-	input_set_capability(input, EV_MSC, MSC_SCAN);
-
 	input->name		= "TWL4030 Keypad";
 	input->phys		= "twl4030_keypad/input0";
 	input->dev.parent	= &pdev->dev;
@@ -378,12 +370,19 @@ static int __devinit twl4030_kp_probe(struct platform_device *pdev)
 	input->id.product	= 0x0001;
 	input->id.version	= 0x0003;
 
-	input->keycode		= kp->keymap;
-	input->keycodesize	= sizeof(kp->keymap[0]);
-	input->keycodemax	= ARRAY_SIZE(kp->keymap);
+	error = matrix_keypad_build_keymap(keymap_data, NULL,
+					   TWL4030_MAX_ROWS,
+					   1 << TWL4030_ROW_SHIFT,
+					   kp->keymap, input);
+	if (error) {
+		dev_err(kp->dbg_dev, "Failed to build keymap\n");
+		goto err1;
+	}
 
-	matrix_keypad_build_keymap(keymap_data, TWL4030_ROW_SHIFT,
-				   input->keycode, input->keybit);
+	input_set_capability(input, EV_MSC, MSC_SCAN);
+	/* Enable auto repeat feature of Linux input subsystem */
+	if (pdata->rep)
+		__set_bit(EV_REP, input->evbit);
 
 	error = input_register_device(input);
 	if (error) {
diff --git a/drivers/input/keyboard/w90p910_keypad.c b/drivers/input/keyboard/w90p910_keypad.c
index 99bbb7e..085ede4 100644
--- a/drivers/input/keyboard/w90p910_keypad.c
+++ b/drivers/input/keyboard/w90p910_keypad.c
@@ -42,7 +42,8 @@
 #define KGET_RAW(n)		(((n) & KEY0R) >> 3)
 #define KGET_COLUMN(n)		((n) & KEY0C)
 
-#define W90P910_MAX_KEY_NUM	(8 * 8)
+#define W90P910_NUM_ROWS	8
+#define W90P910_NUM_COLS	8
 #define W90P910_ROW_SHIFT	3
 
 struct w90p910_keypad {
@@ -51,7 +52,7 @@ struct w90p910_keypad {
 	struct input_dev *input_dev;
 	void __iomem *mmio_base;
 	int irq;
-	unsigned short keymap[W90P910_MAX_KEY_NUM];
+	unsigned short keymap[W90P910_NUM_ROWS * W90P910_NUM_COLS];
 };
 
 static void w90p910_keypad_scan_matrix(struct w90p910_keypad *keypad,
@@ -190,17 +191,13 @@ static int __devinit w90p910_keypad_probe(struct platform_device *pdev)
 	input_dev->close = w90p910_keypad_close;
 	input_dev->dev.parent = &pdev->dev;
 
-	input_dev->keycode = keypad->keymap;
-	input_dev->keycodesize = sizeof(keypad->keymap[0]);
-	input_dev->keycodemax = ARRAY_SIZE(keypad->keymap);
-
-	input_set_drvdata(input_dev, keypad);
-
-	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
-	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
-
-	matrix_keypad_build_keymap(keymap_data, W90P910_ROW_SHIFT,
-				   input_dev->keycode, input_dev->keybit);
+	error = matrix_keypad_build_keymap(keymap_data, NULL,
+					   W90P910_NUM_ROWS, W90P910_NUM_COLS,
+					   keypad->keymap, input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to build keymap\n");
+		goto failed_put_clk;
+	}
 
 	error = request_irq(keypad->irq, w90p910_keypad_irq_handler,
 			    0, pdev->name, keypad);
@@ -209,6 +206,10 @@ static int __devinit w90p910_keypad_probe(struct platform_device *pdev)
 		goto failed_put_clk;
 	}
 
+	__set_bit(EV_REP, input_dev->evbit);
+	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
+	input_set_drvdata(input_dev, keypad);
+
 	/* Register the input device */
 	error = input_register_device(input_dev);
 	if (error) {
diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c
new file mode 100644
index 0000000..de7992d
--- /dev/null
+++ b/drivers/input/matrix-keymap.c
@@ -0,0 +1,142 @@
+/*
+ * Helpers for matrix keyboard bindings
+ *
+ * Copyright (C) 2012 Google, Inc
+ *
+ * Author:
+ *	Olof Johansson <olof@lixom.net>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/input.h>
+#include <linux/of.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/slab.h>
+#include <linux/input/matrix_keypad.h>
+
+
+/**
+ * matrix_keypad_build_keymap - convert platform keymap into matrix keymap
+ * @keymap_data: keymap supplied by the platform code
+ * @keymap_name: name of device tree property containing keymap (if device
+ *	tree support is enabled).
+ * @rows: number of rows in target keymap array
+ * @cols: number of cols in target keymap array
+ * @keymap: expanded version of keymap that is suitable for use by
+ * matrix keyboard driver
+ * @input_dev: input devices for which we are setting up the keymap
+ *
+ * This function converts platform keymap (encoded with KEY() macro) into
+ * an array of keycodes that is suitable for using in a standard matrix
+ * keyboard driver that uses row and col as indices.
+ */
+int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
+			       const char *keymap_name,
+			       unsigned int rows, unsigned int cols,
+			       unsigned short *keymap,
+			       struct input_dev *input_dev)
+{
+	unsigned int row_shift = get_count_order(cols);
+	int i;
+
+	input_dev->keycode = keymap;
+	input_dev->keycodesize = sizeof(*keymap);
+	input_dev->keycodemax = rows << row_shift;
+
+	__set_bit(EV_KEY, input_dev->evbit);
+
+	for (i = 0; i < keymap_data->keymap_size; i++) {
+		unsigned int key = keymap_data->keymap[i];
+		unsigned int row = KEY_ROW(key);
+		unsigned int col = KEY_COL(key);
+		unsigned short code = KEY_VAL(key);
+
+		if (row >= rows || col >= cols) {
+			dev_err(input_dev->dev.parent,
+				"%s: invalid keymap entry %d (row: %d, col: %d, rows: %d, cols: %d)\n",
+				__func__, i, row, col, rows, cols);
+			return -EINVAL;
+		}
+
+		keymap[MATRIX_SCAN_CODE(row, col, row_shift)] = code;
+		__set_bit(code, input_dev->keybit);
+	}
+	__clear_bit(KEY_RESERVED, input_dev->keybit);
+
+	return 0;
+}
+EXPORT_SYMBOL(matrix_keypad_build_keymap);
+
+#ifdef CONFIG_OF
+struct matrix_keymap_data *
+matrix_keyboard_of_fill_keymap(struct device_node *np,
+			       const char *propname)
+{
+	struct matrix_keymap_data *kd;
+	u32 *keymap;
+	int proplen, i;
+	const __be32 *prop;
+
+	if (!np)
+		return NULL;
+
+	if (!propname)
+		propname = "linux,keymap";
+
+	prop = of_get_property(np, propname, &proplen);
+	if (!prop)
+		return NULL;
+
+	if (proplen % sizeof(u32)) {
+		pr_warn("Malformed keymap property %s in %s\n",
+			propname, np->full_name);
+		return NULL;
+	}
+
+	kd = kzalloc(sizeof(*kd), GFP_KERNEL);
+	if (!kd)
+		return NULL;
+
+	kd->keymap = keymap = kzalloc(proplen, GFP_KERNEL);
+	if (!kd->keymap) {
+		kfree(kd);
+		return NULL;
+	}
+
+	kd->keymap_size = proplen / sizeof(u32);
+
+	for (i = 0; i < kd->keymap_size; i++) {
+		u32 tmp = be32_to_cpup(prop + i);
+		int key_code, row, col;
+
+		row = (tmp >> 24) & 0xff;
+		col = (tmp >> 16) & 0xff;
+		key_code = tmp & 0xffff;
+		keymap[i] = KEY(row, col, key_code);
+	}
+
+	return kd;
+}
+EXPORT_SYMBOL_GPL(matrix_keyboard_of_fill_keymap);
+
+void matrix_keyboard_of_free_keymap(const struct matrix_keymap_data *kd)
+{
+	if (kd) {
+		kfree(kd->keymap);
+		kfree(kd);
+	}
+}
+EXPORT_SYMBOL_GPL(matrix_keyboard_of_free_keymap);
+#endif
diff --git a/drivers/input/of_keymap.c b/drivers/input/of_keymap.c
deleted file mode 100644
index 061493d..0000000
--- a/drivers/input/of_keymap.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * Helpers for open firmware matrix keyboard bindings
- *
- * Copyright (C) 2012 Google, Inc
- *
- * Author:
- *	Olof Johansson <olof@lixom.net>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/input.h>
-#include <linux/of.h>
-#include <linux/input/matrix_keypad.h>
-#include <linux/export.h>
-#include <linux/gfp.h>
-#include <linux/slab.h>
-
-struct matrix_keymap_data *
-matrix_keyboard_of_fill_keymap(struct device_node *np,
-			       const char *propname)
-{
-	struct matrix_keymap_data *kd;
-	u32 *keymap;
-	int proplen, i;
-	const __be32 *prop;
-
-	if (!np)
-		return NULL;
-
-	if (!propname)
-		propname = "linux,keymap";
-
-	prop = of_get_property(np, propname, &proplen);
-	if (!prop)
-		return NULL;
-
-	if (proplen % sizeof(u32)) {
-		pr_warn("Malformed keymap property %s in %s\n",
-			propname, np->full_name);
-		return NULL;
-	}
-
-	kd = kzalloc(sizeof(*kd), GFP_KERNEL);
-	if (!kd)
-		return NULL;
-
-	kd->keymap = keymap = kzalloc(proplen, GFP_KERNEL);
-	if (!kd->keymap) {
-		kfree(kd);
-		return NULL;
-	}
-
-	kd->keymap_size = proplen / sizeof(u32);
-
-	for (i = 0; i < kd->keymap_size; i++) {
-		u32 tmp = be32_to_cpup(prop + i);
-		int key_code, row, col;
-
-		row = (tmp >> 24) & 0xff;
-		col = (tmp >> 16) & 0xff;
-		key_code = tmp & 0xffff;
-		keymap[i] = KEY(row, col, key_code);
-	}
-
-	return kd;
-}
-EXPORT_SYMBOL_GPL(matrix_keyboard_of_fill_keymap);
-
-void matrix_keyboard_of_free_keymap(const struct matrix_keymap_data *kd)
-{
-	if (kd) {
-		kfree(kd->keymap);
-		kfree(kd);
-	}
-}
-EXPORT_SYMBOL_GPL(matrix_keyboard_of_free_keymap);
diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
index 6c07ced..e8fe08e 100644
--- a/include/linux/input/matrix_keypad.h
+++ b/include/linux/input/matrix_keypad.h
@@ -75,39 +75,13 @@ struct matrix_keypad_platform_data {
 	bool		no_autorepeat;
 };
 
-/**
- * matrix_keypad_build_keymap - convert platform keymap into matrix keymap
- * @keymap_data: keymap supplied by the platform code
- * @row_shift: number of bits to shift row value by to advance to the next
- * line in the keymap
- * @keymap: expanded version of keymap that is suitable for use by
- * matrix keyboad driver
- * @keybit: pointer to bitmap of keys supported by input device
- *
- * This function converts platform keymap (encoded with KEY() macro) into
- * an array of keycodes that is suitable for using in a standard matrix
- * keyboard driver that uses row and col as indices.
- */
-static inline void
-matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
-			   unsigned int row_shift,
-			   unsigned short *keymap, unsigned long *keybit)
-{
-	int i;
-
-	for (i = 0; i < keymap_data->keymap_size; i++) {
-		unsigned int key = keymap_data->keymap[i];
-		unsigned int row = KEY_ROW(key);
-		unsigned int col = KEY_COL(key);
-		unsigned short code = KEY_VAL(key);
-
-		keymap[MATRIX_SCAN_CODE(row, col, row_shift)] = code;
-		__set_bit(code, keybit);
-	}
-	__clear_bit(KEY_RESERVED, keybit);
-}
+int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
+			       const char *keymap_name,
+			       unsigned int rows, unsigned int cols,
+			       unsigned short *keymap,
+			       struct input_dev *input_dev);
 
-#ifdef CONFIG_INPUT_OF_MATRIX_KEYMAP
+#ifdef CONFIG_OF
 struct matrix_keymap_data *
 matrix_keyboard_of_fill_keymap(struct device_node *np, const char *propname);
 
-- 
1.7.7.6


-- 
Dmitry
