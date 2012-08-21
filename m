Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2HUTBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:01:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56510 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919Ab2HUTBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:01:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: core: Push irqdomain mapping out into devices
Date: Tue, 21 Aug 2012 20:01:12 +0100
Message-Id: <1345575672-15729-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the MFD core supports remapping MFD cell interrupts using an
irqdomain but only if the MFD is being instantiated using device tree
and only if the device tree bindings use the pattern of registering IPs
in the device tree with compatible properties.  This will be actively
harmful for drivers which support non-DT platforms and use this pattern
for their DT bindings as it will mean that the core will silently change
remapping behaviour and it is also limiting for drivers which don't do
DT with this particular pattern.  There is also a potential fragility if
there are interrupts not associated with MFD cells and all the cells are
omitted from the device tree for some reason.

Instead change the code to take an IRQ domain as an optional argument,
allowing drivers to take the decision about the parent domain for their
interrupts.  The one current user of this feature is ab8500-core, it has
the domain lookup pushed out into the driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/88pm800.c             |    5 +++--
 drivers/mfd/88pm805.c             |    3 ++-
 drivers/mfd/88pm860x-core.c       |   21 +++++++++++----------
 drivers/mfd/aat2870-core.c        |    2 +-
 drivers/mfd/ab3100-core.c         |    2 +-
 drivers/mfd/ab8500-core.c         |   11 ++++++-----
 drivers/mfd/arizona-core.c        |    6 +++---
 drivers/mfd/asic3.c               |    6 +++---
 drivers/mfd/cs5535-mfd.c          |    2 +-
 drivers/mfd/da9052-core.c         |    2 +-
 drivers/mfd/davinci_voicecodec.c  |    2 +-
 drivers/mfd/db8500-prcmu.c        |    2 +-
 drivers/mfd/htc-pasic3.c          |    5 +++--
 drivers/mfd/intel_msic.c          |    4 ++--
 drivers/mfd/janz-cmodio.c         |    2 +-
 drivers/mfd/jz4740-adc.c          |    3 ++-
 drivers/mfd/lm3533-core.c         |    7 ++++---
 drivers/mfd/lpc_ich.c             |    4 ++--
 drivers/mfd/lpc_sch.c             |    6 ++++--
 drivers/mfd/max77686.c            |    2 +-
 drivers/mfd/max77693.c            |    2 +-
 drivers/mfd/max8925-core.c        |   12 ++++++------
 drivers/mfd/max8997.c             |    2 +-
 drivers/mfd/max8998.c             |    8 ++++----
 drivers/mfd/mc13xxx-core.c        |    2 +-
 drivers/mfd/mfd-core.c            |   12 ++++++------
 drivers/mfd/palmas.c              |    3 ++-
 drivers/mfd/rc5t583.c             |    2 +-
 drivers/mfd/rdc321x-southbridge.c |    3 ++-
 drivers/mfd/sec-core.c            |    8 ++++----
 drivers/mfd/sta2x11-mfd.c         |    4 ++--
 drivers/mfd/stmpe.c               |    2 +-
 drivers/mfd/t7l66xb.c             |    2 +-
 drivers/mfd/tc3589x.c             |    8 ++++----
 drivers/mfd/tc6387xb.c            |    2 +-
 drivers/mfd/tc6393xb.c            |    4 ++--
 drivers/mfd/ti-ssp.c              |    2 +-
 drivers/mfd/timberdale.c          |   12 ++++++------
 drivers/mfd/tps6105x.c            |    2 +-
 drivers/mfd/tps6507x.c            |    2 +-
 drivers/mfd/tps65090.c            |    2 +-
 drivers/mfd/tps6586x.c            |    3 ++-
 drivers/mfd/tps65910.c            |    2 +-
 drivers/mfd/tps65912-core.c       |    2 +-
 drivers/mfd/twl4030-audio.c       |    2 +-
 drivers/mfd/twl6040-core.c        |    2 +-
 drivers/mfd/vx855.c               |    2 +-
 drivers/mfd/wl1273-core.c         |    2 +-
 drivers/mfd/wm831x-core.c         |   16 ++++++++--------
 drivers/mfd/wm8400-core.c         |    2 +-
 drivers/mfd/wm8994-core.c         |    4 ++--
 include/linux/mfd/core.h          |    4 +++-
 52 files changed, 124 insertions(+), 110 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index b67a301..ce229ea 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -470,7 +470,8 @@ static int __devinit device_800_init(struct pm80x_chip *chip,
 
 	ret =
 	    mfd_add_devices(chip->dev, 0, &onkey_devs[0],
-			    ARRAY_SIZE(onkey_devs), &onkey_resources[0], 0);
+			    ARRAY_SIZE(onkey_devs), &onkey_resources[0], 0,
+			    NULL);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add onkey subdev\n");
 		goto out_dev;
@@ -481,7 +482,7 @@ static int __devinit device_800_init(struct pm80x_chip *chip,
 		rtc_devs[0].platform_data = pdata->rtc;
 		rtc_devs[0].pdata_size = sizeof(struct pm80x_rtc_pdata);
 		ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
-				      ARRAY_SIZE(rtc_devs), NULL, 0);
+				      ARRAY_SIZE(rtc_devs), NULL, 0, NULL);
 		if (ret < 0) {
 			dev_err(chip->dev, "Failed to add rtc subdev\n");
 			goto out_dev;
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 6146583..c20a311 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -216,7 +216,8 @@ static int __devinit device_805_init(struct pm80x_chip *chip)
 	}
 
 	ret = mfd_add_devices(chip->dev, 0, &codec_devs[0],
-			      ARRAY_SIZE(codec_devs), &codec_resources[0], 0);
+			      ARRAY_SIZE(codec_devs), &codec_resources[0], 0,
+			      NULL);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add codec subdev\n");
 		goto out_codec;
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 7586438..2f635d5 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -637,7 +637,7 @@ static void __devinit device_bk_init(struct pm860x_chip *chip,
 			bk_devs[i].resources = &bk_resources[j];
 			ret = mfd_add_devices(chip->dev, 0,
 					      &bk_devs[i], 1,
-					      &bk_resources[j], 0);
+					      &bk_resources[j], 0, NULL);
 			if (ret < 0) {
 				dev_err(chip->dev, "Failed to add "
 					"backlight subdev\n");
@@ -672,7 +672,7 @@ static void __devinit device_led_init(struct pm860x_chip *chip,
 			led_devs[i].resources = &led_resources[j],
 			ret = mfd_add_devices(chip->dev, 0,
 					      &led_devs[i], 1,
-					      &led_resources[j], 0);
+					      &led_resources[j], 0, NULL);
 			if (ret < 0) {
 				dev_err(chip->dev, "Failed to add "
 					"led subdev\n");
@@ -709,7 +709,7 @@ static void __devinit device_regulator_init(struct pm860x_chip *chip,
 		regulator_devs[i].resources = &regulator_resources[seq];
 
 		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[i], 1,
-				      &regulator_resources[seq], 0);
+				      &regulator_resources[seq], 0, NULL);
 		if (ret < 0) {
 			dev_err(chip->dev, "Failed to add regulator subdev\n");
 			goto out;
@@ -733,7 +733,7 @@ static void __devinit device_rtc_init(struct pm860x_chip *chip,
 	rtc_devs[0].resources = &rtc_resources[0];
 	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
 			      ARRAY_SIZE(rtc_devs), &rtc_resources[0],
-			      chip->irq_base);
+			      chip->irq_base, NULL);
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add rtc subdev\n");
 }
@@ -752,7 +752,7 @@ static void __devinit device_touch_init(struct pm860x_chip *chip,
 	touch_devs[0].resources = &touch_resources[0];
 	ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
 			      ARRAY_SIZE(touch_devs), &touch_resources[0],
-			      chip->irq_base);
+			      chip->irq_base, NULL);
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add touch subdev\n");
 }
@@ -770,7 +770,7 @@ static void __devinit device_power_init(struct pm860x_chip *chip,
 	power_devs[0].num_resources = ARRAY_SIZE(battery_resources);
 	power_devs[0].resources = &battery_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[0], 1,
-			      &battery_resources[0], chip->irq_base);
+			      &battery_resources[0], chip->irq_base, NULL);
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add battery subdev\n");
 
@@ -779,7 +779,7 @@ static void __devinit device_power_init(struct pm860x_chip *chip,
 	power_devs[1].num_resources = ARRAY_SIZE(charger_resources);
 	power_devs[1].resources = &charger_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[1], 1,
-			      &charger_resources[0], chip->irq_base);
+			      &charger_resources[0], chip->irq_base, NULL);
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add charger subdev\n");
 
@@ -788,7 +788,7 @@ static void __devinit device_power_init(struct pm860x_chip *chip,
 	power_devs[2].num_resources = ARRAY_SIZE(preg_resources);
 	power_devs[2].resources = &preg_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[2], 1,
-			      &preg_resources[0], chip->irq_base);
+			      &preg_resources[0], chip->irq_base, NULL);
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add preg subdev\n");
 }
@@ -802,7 +802,7 @@ static void __devinit device_onkey_init(struct pm860x_chip *chip,
 	onkey_devs[0].resources = &onkey_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
 			      ARRAY_SIZE(onkey_devs), &onkey_resources[0],
-			      chip->irq_base);
+			      chip->irq_base, NULL);
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add onkey subdev\n");
 }
@@ -815,7 +815,8 @@ static void __devinit device_codec_init(struct pm860x_chip *chip,
 	codec_devs[0].num_resources = ARRAY_SIZE(codec_resources);
 	codec_devs[0].resources = &codec_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &codec_devs[0],
-			      ARRAY_SIZE(codec_devs), &codec_resources[0], 0);
+			      ARRAY_SIZE(codec_devs), &codec_resources[0], 0,
+			      NULL);
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add codec subdev\n");
 }
diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index 44a3fdb..f1beb49 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -424,7 +424,7 @@ static int aat2870_i2c_probe(struct i2c_client *client,
 	}
 
 	ret = mfd_add_devices(aat2870->dev, 0, aat2870_devs,
-			      ARRAY_SIZE(aat2870_devs), NULL, 0);
+			      ARRAY_SIZE(aat2870_devs), NULL, 0, NULL);
 	if (ret != 0) {
 		dev_err(aat2870->dev, "Failed to add subdev: %d\n", ret);
 		goto out_disable;
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 78fca29..01781ae 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -946,7 +946,7 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 	}
 
 	err = mfd_add_devices(&client->dev, 0, ab3100_devs,
-		ARRAY_SIZE(ab3100_devs), NULL, 0);
+			      ARRAY_SIZE(ab3100_devs), NULL, 0, NULL);
 
 	ab3100_setup_debugfs(ab3100);
 
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 626b4ec..03d88c0 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1264,6 +1264,7 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct ab8500 *ab8500;
 	struct resource *resource;
+	struct irq_domain *domain = irq_find_host(pdev->dev.of_node);
 	int ret;
 	int i;
 	u8 value;
@@ -1418,25 +1419,25 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 
 	ret = mfd_add_devices(ab8500->dev, 0, abx500_common_devs,
 			ARRAY_SIZE(abx500_common_devs), NULL,
-			ab8500->irq_base);
+			ab8500->irq_base, domain);
 	if (ret)
 		goto out_freeirq;
 
 	if (is_ab9540(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
 				ARRAY_SIZE(ab9540_devs), NULL,
-				ab8500->irq_base);
+				ab8500->irq_base, domain);
 	else
 		ret = mfd_add_devices(ab8500->dev, 0, ab8500_devs,
 				ARRAY_SIZE(ab8500_devs), NULL,
-				ab8500->irq_base);
+				ab8500->irq_base, domain);
 	if (ret)
 		goto out_freeirq;
 
 	if (is_ab9540(ab8500) || is_ab8505(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_ab8505_devs,
 				ARRAY_SIZE(ab9540_ab8505_devs), NULL,
-				ab8500->irq_base);
+				ab8500->irq_base, domain);
 	if (ret)
 		goto out_freeirq;
 
@@ -1444,7 +1445,7 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 		/* Add battery management devices */
 		ret = mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
 				      ARRAY_SIZE(ab8500_bm_devs), NULL,
-				      ab8500->irq_base);
+				      ab8500->irq_base, domain);
 		if (ret)
 			dev_err(ab8500->dev, "error adding bm devices\n");
 	}
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index c7983e8..1b48f20 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -316,7 +316,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 	}
 
 	ret = mfd_add_devices(arizona->dev, -1, early_devs,
-			      ARRAY_SIZE(early_devs), NULL, 0);
+			      ARRAY_SIZE(early_devs), NULL, 0, NULL);
 	if (ret != 0) {
 		dev_err(dev, "Failed to add early children: %d\n", ret);
 		return ret;
@@ -516,11 +516,11 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 	switch (arizona->type) {
 	case WM5102:
 		ret = mfd_add_devices(arizona->dev, -1, wm5102_devs,
-				      ARRAY_SIZE(wm5102_devs), NULL, 0);
+				      ARRAY_SIZE(wm5102_devs), NULL, 0, NULL);
 		break;
 	case WM5110:
 		ret = mfd_add_devices(arizona->dev, -1, wm5110_devs,
-				      ARRAY_SIZE(wm5102_devs), NULL, 0);
+				      ARRAY_SIZE(wm5102_devs), NULL, 0, NULL);
 		break;
 	}
 
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 683e18a..62f0883 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -913,14 +913,14 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 	if (pdata->clock_rate) {
 		ds1wm_pdata.clock_rate = pdata->clock_rate;
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
-			&asic3_cell_ds1wm, 1, mem, asic->irq_base);
+			&asic3_cell_ds1wm, 1, mem, asic->irq_base, NULL);
 		if (ret < 0)
 			goto out;
 	}
 
 	if (mem_sdio && (irq >= 0)) {
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
-			&asic3_cell_mmc, 1, mem_sdio, irq);
+			&asic3_cell_mmc, 1, mem_sdio, irq, NULL);
 		if (ret < 0)
 			goto out;
 	}
@@ -934,7 +934,7 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 			asic3_cell_leds[i].pdata_size = sizeof(pdata->leds[i]);
 		}
 		ret = mfd_add_devices(&pdev->dev, 0,
-			asic3_cell_leds, ASIC3_NUM_LEDS, NULL, 0);
+			asic3_cell_leds, ASIC3_NUM_LEDS, NULL, 0, NULL);
 	}
 
  out:
diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index 3419e72..2b28213 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -149,7 +149,7 @@ static int __devinit cs5535_mfd_probe(struct pci_dev *pdev,
 	}
 
 	err = mfd_add_devices(&pdev->dev, -1, cs5535_mfd_cells,
-			ARRAY_SIZE(cs5535_mfd_cells), NULL, 0);
+			      ARRAY_SIZE(cs5535_mfd_cells), NULL, 0, NULL);
 	if (err) {
 		dev_err(&pdev->dev, "MFD add devices failed: %d\n", err);
 		goto err_disable;
diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 2544910..a0a62b2 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -803,7 +803,7 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);
 
 	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
-			      ARRAY_SIZE(da9052_subdev_info), NULL, 0);
+			      ARRAY_SIZE(da9052_subdev_info), NULL, 0, NULL);
 	if (ret)
 		goto err;
 
diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index 4e2af2c..45e83a6 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -129,7 +129,7 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	cell->pdata_size = sizeof(*davinci_vc);
 
 	ret = mfd_add_devices(&pdev->dev, pdev->id, davinci_vc->cells,
-			      DAVINCI_VC_CELLS, NULL, 0);
+			      DAVINCI_VC_CELLS, NULL, 0, NULL);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "fail to register client devices\n");
 		goto fail4;
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 7040a00..0e63cdd 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3010,7 +3010,7 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 		prcmu_config_esram0_deep_sleep(ESRAM0_DEEP_SLEEP_STATE_RET);
 
 	err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
-			ARRAY_SIZE(db8500_prcmu_devs), NULL, 0);
+			      ARRAY_SIZE(db8500_prcmu_devs), NULL, 0, NULL);
 	if (err) {
 		pr_err("prcmu: Failed to add subdevices\n");
 		return err;
diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 04c7093..9e5453d 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -168,7 +168,7 @@ static int __init pasic3_probe(struct platform_device *pdev)
 		/* the first 5 PASIC3 registers control the DS1WM */
 		ds1wm_resources[0].end = (5 << asic->bus_shift) - 1;
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
-				&ds1wm_cell, 1, r, irq);
+				      &ds1wm_cell, 1, r, irq, NULL);
 		if (ret < 0)
 			dev_warn(dev, "failed to register DS1WM\n");
 	}
@@ -176,7 +176,8 @@ static int __init pasic3_probe(struct platform_device *pdev)
 	if (pdata && pdata->led_pdata) {
 		led_cell.platform_data = pdata->led_pdata;
 		led_cell.pdata_size = sizeof(struct pasic3_leds_machinfo);
-		ret = mfd_add_devices(&pdev->dev, pdev->id, &led_cell, 1, r, 0);
+		ret = mfd_add_devices(&pdev->dev, pdev->id, &led_cell, 1, r,
+				      0, NULL);
 		if (ret < 0)
 			dev_warn(dev, "failed to register LED device\n");
 	}
diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index 59df558..266bdc5 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -344,13 +344,13 @@ static int __devinit intel_msic_init_devices(struct intel_msic *msic)
 			continue;
 
 		ret = mfd_add_devices(&pdev->dev, -1, &msic_devs[i], 1, NULL,
-				      pdata->irq[i]);
+				      pdata->irq[i], NULL);
 		if (ret)
 			goto fail;
 	}
 
 	ret = mfd_add_devices(&pdev->dev, 0, msic_other_devs,
-			      ARRAY_SIZE(msic_other_devs), NULL, 0);
+			      ARRAY_SIZE(msic_other_devs), NULL, 0, NULL);
 	if (ret)
 		goto fail;
 
diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index 2ea9998..965c480 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -147,7 +147,7 @@ static int __devinit cmodio_probe_submodules(struct cmodio_device *priv)
 	}
 
 	return mfd_add_devices(&pdev->dev, 0, priv->cells,
-			       num_probed, NULL, pdev->irq);
+			       num_probed, NULL, pdev->irq, NULL);
 }
 
 /*
diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 87662a1..c6b6d7d 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -287,7 +287,8 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 	writeb(0xff, adc->base + JZ_REG_ADC_CTRL);
 
 	ret = mfd_add_devices(&pdev->dev, 0, jz4740_adc_cells,
-		ARRAY_SIZE(jz4740_adc_cells), mem_base, irq_base);
+			      ARRAY_SIZE(jz4740_adc_cells), mem_base,
+			      irq_base, NULL);
 	if (ret < 0)
 		goto err_clk_put;
 
diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index 0b2879b..24212f4 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -393,7 +393,8 @@ static int __devinit lm3533_device_als_init(struct lm3533 *lm3533)
 	lm3533_als_devs[0].platform_data = pdata->als;
 	lm3533_als_devs[0].pdata_size = sizeof(*pdata->als);
 
-	ret = mfd_add_devices(lm3533->dev, 0, lm3533_als_devs, 1, NULL, 0);
+	ret = mfd_add_devices(lm3533->dev, 0, lm3533_als_devs, 1, NULL,
+			      0, NULL);
 	if (ret) {
 		dev_err(lm3533->dev, "failed to add ALS device\n");
 		return ret;
@@ -422,7 +423,7 @@ static int __devinit lm3533_device_bl_init(struct lm3533 *lm3533)
 	}
 
 	ret = mfd_add_devices(lm3533->dev, 0, lm3533_bl_devs,
-					pdata->num_backlights, NULL, 0);
+			      pdata->num_backlights, NULL, 0, NULL);
 	if (ret) {
 		dev_err(lm3533->dev, "failed to add backlight devices\n");
 		return ret;
@@ -451,7 +452,7 @@ static int __devinit lm3533_device_led_init(struct lm3533 *lm3533)
 	}
 
 	ret = mfd_add_devices(lm3533->dev, 0, lm3533_led_devs,
-						pdata->num_leds, NULL, 0);
+			      pdata->num_leds, NULL, 0, NULL);
 	if (ret) {
 		dev_err(lm3533->dev, "failed to add LED devices\n");
 		return ret;
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 027cc8f..9abf24d 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -750,7 +750,7 @@ gpe0_done:
 
 	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO], id);
 	ret = mfd_add_devices(&dev->dev, -1, &lpc_ich_cells[LPC_GPIO],
-				1, NULL, 0);
+			      1, NULL, 0, NULL);
 
 gpio_done:
 	if (acpi_conflict)
@@ -822,7 +822,7 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
 
 	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_WDT], id);
 	ret = mfd_add_devices(&dev->dev, -1, &lpc_ich_cells[LPC_WDT],
-				1, NULL, 0);
+			      1, NULL, 0, NULL);
 
 wdt_done:
 	if (acpi_conflict)
diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index 9f20abc..f6b9c5c 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -127,7 +127,8 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
 		lpc_sch_cells[i].id = id->device;
 
 	ret = mfd_add_devices(&dev->dev, 0,
-			lpc_sch_cells, ARRAY_SIZE(lpc_sch_cells), NULL, 0);
+			      lpc_sch_cells, ARRAY_SIZE(lpc_sch_cells), NULL,
+			      0, NULL);
 	if (ret)
 		goto out_dev;
 
@@ -153,7 +154,8 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
 			tunnelcreek_cells[i].id = id->device;
 
 		ret = mfd_add_devices(&dev->dev, 0, tunnelcreek_cells,
-			ARRAY_SIZE(tunnelcreek_cells), NULL, 0);
+				      ARRAY_SIZE(tunnelcreek_cells), NULL,
+				      0, NULL);
 	}
 
 	return ret;
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index c03e12b..d9e24c8 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -126,7 +126,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	max77686_irq_init(max77686);
 
 	ret = mfd_add_devices(max77686->dev, -1, max77686_devs,
-			      ARRAY_SIZE(max77686_devs), NULL, 0);
+			      ARRAY_SIZE(max77686_devs), NULL, 0, NULL);
 
 	if (ret < 0)
 		goto err_mfd;
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index a1811cb..4fdd03d 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -159,7 +159,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	pm_runtime_set_active(max77693->dev);
 
 	ret = mfd_add_devices(max77693->dev, -1, max77693_devs,
-			ARRAY_SIZE(max77693_devs), NULL, 0);
+			      ARRAY_SIZE(max77693_devs), NULL, 0, NULL);
 	if (ret < 0)
 		goto err_mfd;
 
diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index 08a5723..f2ff31f 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -598,7 +598,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 
 	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
 			      ARRAY_SIZE(rtc_devs),
-			      &rtc_resources[0], chip->irq_base);
+			      &rtc_resources[0], chip->irq_base, NULL);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add rtc subdev\n");
 		goto out;
@@ -606,7 +606,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 
 	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
 			      ARRAY_SIZE(onkey_devs),
-			      &onkey_resources[0], 0);
+			      &onkey_resources[0], 0, NULL);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add onkey subdev\n");
 		goto out_dev;
@@ -615,7 +615,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 	if (pdata) {
 		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
 				      ARRAY_SIZE(regulator_devs),
-				      &regulator_resources[0], 0);
+				      &regulator_resources[0], 0, NULL);
 		if (ret < 0) {
 			dev_err(chip->dev, "Failed to add regulator subdev\n");
 			goto out_dev;
@@ -625,7 +625,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 	if (pdata && pdata->backlight) {
 		ret = mfd_add_devices(chip->dev, 0, &backlight_devs[0],
 				      ARRAY_SIZE(backlight_devs),
-				      &backlight_resources[0], 0);
+				      &backlight_resources[0], 0, NULL);
 		if (ret < 0) {
 			dev_err(chip->dev, "Failed to add backlight subdev\n");
 			goto out_dev;
@@ -635,7 +635,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 	if (pdata && pdata->power) {
 		ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
 					ARRAY_SIZE(power_devs),
-					&power_supply_resources[0], 0);
+				      &power_supply_resources[0], 0, NULL);
 		if (ret < 0) {
 			dev_err(chip->dev, "Failed to add power supply "
 				"subdev\n");
@@ -646,7 +646,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 	if (pdata && pdata->touch) {
 		ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
 				      ARRAY_SIZE(touch_devs),
-				      &touch_resources[0], 0);
+				      &touch_resources[0], 0, NULL);
 		if (ret < 0) {
 			dev_err(chip->dev, "Failed to add touch subdev\n");
 			goto out_dev;
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 10b629c..f123517 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -160,7 +160,7 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 
 	mfd_add_devices(max8997->dev, -1, max8997_devs,
 			ARRAY_SIZE(max8997_devs),
-			NULL, 0);
+			NULL, 0, NULL);
 
 	/*
 	 * TODO: enable others (flash, muic, rtc, battery, ...) and
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 6ef56d28..d7218cc 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -161,13 +161,13 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	switch (id->driver_data) {
 	case TYPE_LP3974:
 		ret = mfd_add_devices(max8998->dev, -1,
-				lp3974_devs, ARRAY_SIZE(lp3974_devs),
-				NULL, 0);
+				      lp3974_devs, ARRAY_SIZE(lp3974_devs),
+				      NULL, 0, NULL);
 		break;
 	case TYPE_MAX8998:
 		ret = mfd_add_devices(max8998->dev, -1,
-				max8998_devs, ARRAY_SIZE(max8998_devs),
-				NULL, 0);
+				      max8998_devs, ARRAY_SIZE(max8998_devs),
+				      NULL, 0, NULL);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index b801dc7..1ec79b5 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -612,7 +612,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 	if (!cell.name)
 		return -ENOMEM;
 
-	return mfd_add_devices(mc13xxx->dev, -1, &cell, 1, NULL, 0);
+	return mfd_add_devices(mc13xxx->dev, -1, &cell, 1, NULL, 0, NULL);
 }
 
 static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 0c3a01c..f8b7771 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -74,12 +74,11 @@ static int mfd_platform_add_cell(struct platform_device *pdev,
 static int mfd_add_device(struct device *parent, int id,
 			  const struct mfd_cell *cell,
 			  struct resource *mem_base,
-			  int irq_base)
+			  int irq_base, struct irq_domain *domain)
 {
 	struct resource *res;
 	struct platform_device *pdev;
 	struct device_node *np = NULL;
-	struct irq_domain *domain = NULL;
 	int ret = -ENOMEM;
 	int r;
 
@@ -97,7 +96,6 @@ static int mfd_add_device(struct device *parent, int id,
 		for_each_child_of_node(parent->of_node, np) {
 			if (of_device_is_compatible(np, cell->of_compatible)) {
 				pdev->dev.of_node = np;
-				domain = irq_find_host(parent->of_node);
 				break;
 			}
 		}
@@ -177,7 +175,7 @@ fail_alloc:
 int mfd_add_devices(struct device *parent, int id,
 		    struct mfd_cell *cells, int n_devs,
 		    struct resource *mem_base,
-		    int irq_base)
+		    int irq_base, struct irq_domain *domain)
 {
 	int i;
 	int ret = 0;
@@ -191,7 +189,8 @@ int mfd_add_devices(struct device *parent, int id,
 	for (i = 0; i < n_devs; i++) {
 		atomic_set(&cnts[i], 0);
 		cells[i].usage_count = &cnts[i];
-		ret = mfd_add_device(parent, id, cells + i, mem_base, irq_base);
+		ret = mfd_add_device(parent, id, cells + i, mem_base,
+				     irq_base, domain);
 		if (ret)
 			break;
 	}
@@ -247,7 +246,8 @@ int mfd_clone_cell(const char *cell, const char **clones, size_t n_clones)
 	for (i = 0; i < n_clones; i++) {
 		cell_entry.name = clones[i];
 		/* don't give up if a single call fails; just report error */
-		if (mfd_add_device(pdev->dev.parent, -1, &cell_entry, NULL, 0))
+		if (mfd_add_device(pdev->dev.parent, -1, &cell_entry, NULL, 0,
+				   NULL))
 			dev_err(dev, "failed to create platform device '%s'\n",
 					clones[i]);
 	}
diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index c4a69f1..a345f9bb 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -453,7 +453,8 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 
 	ret = mfd_add_devices(palmas->dev, -1,
 			      children, ARRAY_SIZE(palmas_children),
-			      NULL, regmap_irq_chip_get_base(palmas->irq_data));
+			      NULL, regmap_irq_chip_get_base(palmas->irq_data),
+			      NULL);
 	kfree(children);
 
 	if (ret < 0)
diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index cdc1df7..3a8fa88 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -289,7 +289,7 @@ static int __devinit rc5t583_i2c_probe(struct i2c_client *i2c,
 	}
 
 	ret = mfd_add_devices(rc5t583->dev, -1, rc5t583_subdevs,
-			ARRAY_SIZE(rc5t583_subdevs), NULL, 0);
+			      ARRAY_SIZE(rc5t583_subdevs), NULL, 0, NULL);
 	if (ret) {
 		dev_err(&i2c->dev, "add mfd devices failed: %d\n", ret);
 		goto err_add_devs;
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 685d61e..0f70dce 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -87,7 +87,8 @@ static int __devinit rdc321x_sb_probe(struct pci_dev *pdev,
 	rdc321x_wdt_pdata.sb_pdev = pdev;
 
 	return mfd_add_devices(&pdev->dev, -1,
-		rdc321x_sb_cells, ARRAY_SIZE(rdc321x_sb_cells), NULL, 0);
+			       rdc321x_sb_cells, ARRAY_SIZE(rdc321x_sb_cells),
+			       NULL, 0, NULL);
 }
 
 static void __devexit rdc321x_sb_remove(struct pci_dev *pdev)
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 2988efd..49d361a 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -141,19 +141,19 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	switch (sec_pmic->device_type) {
 	case S5M8751X:
 		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8751_devs,
-					ARRAY_SIZE(s5m8751_devs), NULL, 0);
+				      ARRAY_SIZE(s5m8751_devs), NULL, 0, NULL);
 		break;
 	case S5M8763X:
 		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8763_devs,
-					ARRAY_SIZE(s5m8763_devs), NULL, 0);
+				      ARRAY_SIZE(s5m8763_devs), NULL, 0, NULL);
 		break;
 	case S5M8767X:
 		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8767_devs,
-					ARRAY_SIZE(s5m8767_devs), NULL, 0);
+				      ARRAY_SIZE(s5m8767_devs), NULL, 0, NULL);
 		break;
 	case S2MPS11X:
 		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps11_devs,
-					ARRAY_SIZE(s2mps11_devs), NULL, 0);
+				      ARRAY_SIZE(s2mps11_devs), NULL, 0, NULL);
 		break;
 	default:
 		/* If this happens the probe function is problem */
diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index d31fed0..d35da68 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -407,7 +407,7 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 			      sta2x11_mfd_bar0,
 			      ARRAY_SIZE(sta2x11_mfd_bar0),
 			      &pdev->resource[0],
-			      0);
+			      0, NULL);
 	if (err) {
 		dev_err(&pdev->dev, "mfd_add_devices[0] failed: %d\n", err);
 		goto err_disable;
@@ -417,7 +417,7 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 			      sta2x11_mfd_bar1,
 			      ARRAY_SIZE(sta2x11_mfd_bar1),
 			      &pdev->resource[1],
-			      0);
+			      0, NULL);
 	if (err) {
 		dev_err(&pdev->dev, "mfd_add_devices[1] failed: %d\n", err);
 		goto err_disable;
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 2dd8d49..c94f521 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -962,7 +962,7 @@ static int __devinit stmpe_add_device(struct stmpe *stmpe,
 				      struct mfd_cell *cell, int irq)
 {
 	return mfd_add_devices(stmpe->dev, stmpe->pdata->id, cell, 1,
-			       NULL, stmpe->irq_base + irq);
+			       NULL, stmpe->irq_base + irq, NULL);
 }
 
 static int __devinit stmpe_devices_init(struct stmpe *stmpe)
diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 2d9e879..b32940e 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -388,7 +388,7 @@ static int t7l66xb_probe(struct platform_device *dev)
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
 			      t7l66xb_cells, ARRAY_SIZE(t7l66xb_cells),
-			      iomem, t7l66xb->irq_base);
+			      iomem, t7l66xb->irq_base, NULL);
 
 	if (!ret)
 		return 0;
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 048bf05..b56ba6b 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -262,8 +262,8 @@ static int __devinit tc3589x_device_init(struct tc3589x *tc3589x)
 
 	if (blocks & TC3589x_BLOCK_GPIO) {
 		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_gpio,
-				ARRAY_SIZE(tc3589x_dev_gpio), NULL,
-				tc3589x->irq_base);
+				      ARRAY_SIZE(tc3589x_dev_gpio), NULL,
+				      tc3589x->irq_base, NULL);
 		if (ret) {
 			dev_err(tc3589x->dev, "failed to add gpio child\n");
 			return ret;
@@ -273,8 +273,8 @@ static int __devinit tc3589x_device_init(struct tc3589x *tc3589x)
 
 	if (blocks & TC3589x_BLOCK_KEYPAD) {
 		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_keypad,
-				ARRAY_SIZE(tc3589x_dev_keypad), NULL,
-				tc3589x->irq_base);
+				      ARRAY_SIZE(tc3589x_dev_keypad), NULL,
+				      tc3589x->irq_base, NULL);
 		if (ret) {
 			dev_err(tc3589x->dev, "failed to keypad child\n");
 			return ret;
diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index d20a284..413c891 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -192,7 +192,7 @@ static int __devinit tc6387xb_probe(struct platform_device *dev)
 	printk(KERN_INFO "Toshiba tc6387xb initialised\n");
 
 	ret = mfd_add_devices(&dev->dev, dev->id, tc6387xb_cells,
-			      ARRAY_SIZE(tc6387xb_cells), iomem, irq);
+			      ARRAY_SIZE(tc6387xb_cells), iomem, irq, NULL);
 
 	if (!ret)
 		return 0;
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 9612264..dcab026 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -700,8 +700,8 @@ static int __devinit tc6393xb_probe(struct platform_device *dev)
 	tc6393xb_cells[TC6393XB_CELL_FB].pdata_size = sizeof(*tcpd->fb_data);
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
-			tc6393xb_cells, ARRAY_SIZE(tc6393xb_cells),
-			iomem, tcpd->irq_base);
+			      tc6393xb_cells, ARRAY_SIZE(tc6393xb_cells),
+			      iomem, tcpd->irq_base, NULL);
 
 	if (!ret)
 		return 0;
diff --git a/drivers/mfd/ti-ssp.c b/drivers/mfd/ti-ssp.c
index 4fb0e6c..7c3675a 100644
--- a/drivers/mfd/ti-ssp.c
+++ b/drivers/mfd/ti-ssp.c
@@ -412,7 +412,7 @@ static int __devinit ti_ssp_probe(struct platform_device *pdev)
 		cells[id].data_size	= data->pdata_size;
 	}
 
-	error = mfd_add_devices(dev, 0, cells, 2, NULL, 0);
+	error = mfd_add_devices(dev, 0, cells, 2, NULL, 0, NULL);
 	if (error < 0) {
 		dev_err(dev, "cannot add mfd cells\n");
 		goto error_enable;
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index a447f4e..cccc626 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -757,25 +757,25 @@ static int __devinit timb_probe(struct pci_dev *dev,
 		err = mfd_add_devices(&dev->dev, -1,
 			timberdale_cells_bar0_cfg0,
 			ARRAY_SIZE(timberdale_cells_bar0_cfg0),
-			&dev->resource[0], msix_entries[0].vector);
+			&dev->resource[0], msix_entries[0].vector, NULL);
 		break;
 	case TIMB_HW_VER1:
 		err = mfd_add_devices(&dev->dev, -1,
 			timberdale_cells_bar0_cfg1,
 			ARRAY_SIZE(timberdale_cells_bar0_cfg1),
-			&dev->resource[0], msix_entries[0].vector);
+			&dev->resource[0], msix_entries[0].vector, NULL);
 		break;
 	case TIMB_HW_VER2:
 		err = mfd_add_devices(&dev->dev, -1,
 			timberdale_cells_bar0_cfg2,
 			ARRAY_SIZE(timberdale_cells_bar0_cfg2),
-			&dev->resource[0], msix_entries[0].vector);
+			&dev->resource[0], msix_entries[0].vector, NULL);
 		break;
 	case TIMB_HW_VER3:
 		err = mfd_add_devices(&dev->dev, -1,
 			timberdale_cells_bar0_cfg3,
 			ARRAY_SIZE(timberdale_cells_bar0_cfg3),
-			&dev->resource[0], msix_entries[0].vector);
+			&dev->resource[0], msix_entries[0].vector, NULL);
 		break;
 	default:
 		dev_err(&dev->dev, "Uknown IP setup: %d.%d.%d\n",
@@ -792,7 +792,7 @@ static int __devinit timb_probe(struct pci_dev *dev,
 
 	err = mfd_add_devices(&dev->dev, 0,
 		timberdale_cells_bar1, ARRAY_SIZE(timberdale_cells_bar1),
-		&dev->resource[1], msix_entries[0].vector);
+		&dev->resource[1], msix_entries[0].vector, NULL);
 	if (err) {
 		dev_err(&dev->dev, "mfd_add_devices failed: %d\n", err);
 		goto err_mfd2;
@@ -803,7 +803,7 @@ static int __devinit timb_probe(struct pci_dev *dev,
 		((priv->fw.config & TIMB_HW_VER_MASK) == TIMB_HW_VER3)) {
 		err = mfd_add_devices(&dev->dev, 1, timberdale_cells_bar2,
 			ARRAY_SIZE(timberdale_cells_bar2),
-			&dev->resource[2], msix_entries[0].vector);
+			&dev->resource[2], msix_entries[0].vector, NULL);
 		if (err) {
 			dev_err(&dev->dev, "mfd_add_devices failed: %d\n", err);
 			goto err_mfd2;
diff --git a/drivers/mfd/tps6105x.c b/drivers/mfd/tps6105x.c
index a293b97..14051bd 100644
--- a/drivers/mfd/tps6105x.c
+++ b/drivers/mfd/tps6105x.c
@@ -188,7 +188,7 @@ static int __devinit tps6105x_probe(struct i2c_client *client,
 	}
 
 	ret = mfd_add_devices(&client->dev, 0, tps6105x_cells,
-		ARRAY_SIZE(tps6105x_cells), NULL, 0);
+			      ARRAY_SIZE(tps6105x_cells), NULL, 0, NULL);
 	if (ret)
 		goto fail;
 
diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index 33ba772..1b20349 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -100,7 +100,7 @@ static int tps6507x_i2c_probe(struct i2c_client *i2c,
 
 	ret = mfd_add_devices(tps6507x->dev, -1,
 			      tps6507x_devs, ARRAY_SIZE(tps6507x_devs),
-			      NULL, 0);
+			      NULL, 0, NULL);
 
 	if (ret < 0)
 		goto err;
diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 80e24f4..50fd87c 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -292,7 +292,7 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 	}
 
 	ret = mfd_add_devices(tps65090->dev, -1, tps65090s,
-		ARRAY_SIZE(tps65090s), NULL, 0);
+			      ARRAY_SIZE(tps65090s), NULL, 0, NULL);
 	if (ret) {
 		dev_err(&client->dev, "add mfd devices failed with err: %d\n",
 			ret);
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 380a3c8..345960ca 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -506,7 +506,8 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 	}
 
 	ret = mfd_add_devices(tps6586x->dev, -1,
-			tps6586x_cell, ARRAY_SIZE(tps6586x_cell), NULL, 0);
+			      tps6586x_cell, ARRAY_SIZE(tps6586x_cell),
+			      NULL, 0, NULL);
 	if (ret < 0) {
 		dev_err(&client->dev, "mfd_add_devices failed: %d\n", ret);
 		goto err_mfd_add;
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 1c56379..d3ce4d5 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -254,7 +254,7 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	ret = mfd_add_devices(tps65910->dev, -1,
 			      tps65910s, ARRAY_SIZE(tps65910s),
-			      NULL, 0);
+			      NULL, 0, NULL);
 	if (ret < 0) {
 		dev_err(&i2c->dev, "mfd_add_devices failed: %d\n", ret);
 		return ret;
diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index 74fd8cb..4658b5b 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -146,7 +146,7 @@ int tps65912_device_init(struct tps65912 *tps65912)
 
 	ret = mfd_add_devices(tps65912->dev, -1,
 			      tps65912s, ARRAY_SIZE(tps65912s),
-			      NULL, 0);
+			      NULL, 0, NULL);
 	if (ret < 0)
 		goto err;
 
diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index 838ce4e..77c9acb 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -223,7 +223,7 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 
 	if (childs)
 		ret = mfd_add_devices(&pdev->dev, pdev->id, audio->cells,
-				      childs, NULL, 0);
+				      childs, NULL, 0, NULL);
 	else {
 		dev_err(&pdev->dev, "No platform data found for childs\n");
 		ret = -ENODEV;
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index b0fad0f..3dca5c1 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -632,7 +632,7 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	}
 
 	ret = mfd_add_devices(&client->dev, -1, twl6040->cells, children,
-			      NULL, 0);
+			      NULL, 0, NULL);
 	if (ret)
 		goto mfd_err;
 
diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
index 872aff2..b9a636d 100644
--- a/drivers/mfd/vx855.c
+++ b/drivers/mfd/vx855.c
@@ -102,7 +102,7 @@ static __devinit int vx855_probe(struct pci_dev *pdev,
 	vx855_gpio_resources[1].end = vx855_gpio_resources[1].start + 3;
 
 	ret = mfd_add_devices(&pdev->dev, -1, vx855_cells, ARRAY_SIZE(vx855_cells),
-			NULL, 0);
+			NULL, 0, NULL);
 
 	/* we always return -ENODEV here in order to enable other
 	 * drivers like old, not-yet-platform_device ported i2c-viapro */
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index f39b756..86e0e43 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -241,7 +241,7 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 		__func__, children);
 
 	r = mfd_add_devices(&client->dev, -1, core->cells,
-			    children, NULL, 0);
+			    children, NULL, 0, NULL);
 	if (r)
 		goto err;
 
diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 2e5d58e..521340a7 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1787,27 +1787,27 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8310:
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8310_devs, ARRAY_SIZE(wm8310_devs),
-				      NULL, 0);
+				      NULL, 0, NULL);
 		break;
 
 	case WM8311:
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8311_devs, ARRAY_SIZE(wm8311_devs),
-				      NULL, 0);
+				      NULL, 0, NULL);
 		if (!pdata || !pdata->disable_touch)
 			mfd_add_devices(wm831x->dev, wm831x_num,
 					touch_devs, ARRAY_SIZE(touch_devs),
-					NULL, 0);
+					NULL, 0, NULL);
 		break;
 
 	case WM8312:
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8312_devs, ARRAY_SIZE(wm8312_devs),
-				      NULL, 0);
+				      NULL, 0, NULL);
 		if (!pdata || !pdata->disable_touch)
 			mfd_add_devices(wm831x->dev, wm831x_num,
 					touch_devs, ARRAY_SIZE(touch_devs),
-					NULL, 0);
+					NULL, 0, NULL);
 		break;
 
 	case WM8320:
@@ -1816,7 +1816,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8326:
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
-				      NULL, 0);
+				      NULL, 0, NULL);
 		break;
 
 	default:
@@ -1841,7 +1841,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	if (ret & WM831X_XTAL_ENA) {
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      rtc_devs, ARRAY_SIZE(rtc_devs),
-				      NULL, 0);
+				      NULL, 0, NULL);
 		if (ret != 0) {
 			dev_err(wm831x->dev, "Failed to add RTC: %d\n", ret);
 			goto err_irq;
@@ -1854,7 +1854,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		/* Treat errors as non-critical */
 		ret = mfd_add_devices(wm831x->dev, wm831x_num, backlight_devs,
 				      ARRAY_SIZE(backlight_devs), NULL,
-				      0);
+				      0, NULL);
 		if (ret < 0)
 			dev_err(wm831x->dev, "Failed to add backlight: %d\n",
 				ret);
diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 4b7d378..639ca35 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -70,7 +70,7 @@ static int wm8400_register_codec(struct wm8400 *wm8400)
 		.pdata_size = sizeof(*wm8400),
 	};
 
-	return mfd_add_devices(wm8400->dev, -1, &cell, 1, NULL, 0);
+	return mfd_add_devices(wm8400->dev, -1, &cell, 1, NULL, 0, NULL);
 }
 
 /*
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index eec74aa..2febf88 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -414,7 +414,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	ret = mfd_add_devices(wm8994->dev, -1,
 			      wm8994_regulator_devs,
 			      ARRAY_SIZE(wm8994_regulator_devs),
-			      NULL, 0);
+			      NULL, 0, NULL);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to add children: %d\n", ret);
 		goto err;
@@ -648,7 +648,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 
 	ret = mfd_add_devices(wm8994->dev, -1,
 			      wm8994_devs, ARRAY_SIZE(wm8994_devs),
-			      NULL, 0);
+			      NULL, 0, NULL);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to add children: %d\n", ret);
 		goto err_irq;
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 3a8435a..cebe97e 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -16,6 +16,8 @@
 
 #include <linux/platform_device.h>
 
+struct irq_domain;
+
 /*
  * This struct describes the MFD part ("cell").
  * After registration the copy of this structure will become the platform data
@@ -98,7 +100,7 @@ static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
 extern int mfd_add_devices(struct device *parent, int id,
 			   struct mfd_cell *cells, int n_devs,
 			   struct resource *mem_base,
-			   int irq_base);
+			   int irq_base, struct irq_domain *irq_domain);
 
 extern void mfd_remove_devices(struct device *parent);
 
-- 
1.7.10.4

