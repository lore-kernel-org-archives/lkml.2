Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2DHTXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 15:23:54 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41938 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab2DHTXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 15:23:53 -0400
From: Olof Johansson <olof@lixom.net>
To: grant.likely@secretlab.ca
Cc: linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        sangsu4u.park@samsung.com, Olof Johansson <olof@lixom.net>
Subject: [PATCH] gpio: samsung: refactor gpiolib init for exynos4/5
Date: Sun,  8 Apr 2012 12:23:27 -0700
Message-Id: <1333913007-16032-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.2.359.gebfc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only code move, no functional change.

Main reason to do this was to get rid of the warnings:

drivers/gpio/gpio-samsung.c: In function 'samsung_gpiolib_init':
drivers/gpio/gpio-samsung.c:2974:1: warning: label 'err_ioremap4' defined but not used [-Wunused-label]
drivers/gpio/gpio-samsung.c:2722:47: warning: unused variable 'gpio_base4' [-Wunused-variable]

without adding more ifdef mess.

I think this whole file would do well being coverted over to a platform
driver and moving most of the tables out to SoC code and/or device trees,
but since that changes init ordering it needs to be done with some care,
i.e. not at this time.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/gpio/gpio-samsung.c |  403 +++++++++++++++++++++++--------------------
 1 file changed, 215 insertions(+), 188 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 914ba64..f2c447e8 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2707,12 +2707,224 @@ static __init void exynos_gpiolib_attach_ofnode(struct samsung_gpio_chip *chip,
 }
 #endif /* defined(CONFIG_ARCH_EXYNOS) && defined(CONFIG_OF) */
 
+static __init void exynos4_gpiolib_init(void)
+{
+#ifdef CONFIG_CPU_EXYNOS4210
+	struct samsung_gpio_chip *chip;
+	int i, nr_chips;
+	void __iomem *gpio_base1, *gpio_base2, *gpio_base3;
+	int group = 0;
+	void __iomem *gpx_base;
+
+	/* gpio part1 */
+	gpio_base1 = ioremap(EXYNOS4_PA_GPIO1, SZ_4K);
+	if (gpio_base1 == NULL) {
+		pr_err("unable to ioremap for gpio_base1\n");
+		goto err_ioremap1;
+	}
+
+	chip = exynos4_gpios_1;
+	nr_chips = ARRAY_SIZE(exynos4_gpios_1);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (!chip->config) {
+			chip->config = &exynos_gpio_cfg;
+			chip->group = group++;
+		}
+		exynos_gpiolib_attach_ofnode(chip,
+				EXYNOS4_PA_GPIO1, i * 0x20);
+	}
+	samsung_gpiolib_add_4bit_chips(exynos4_gpios_1,
+				       nr_chips, gpio_base1);
+
+	/* gpio part2 */
+	gpio_base2 = ioremap(EXYNOS4_PA_GPIO2, SZ_4K);
+	if (gpio_base2 == NULL) {
+		pr_err("unable to ioremap for gpio_base2\n");
+		goto err_ioremap2;
+	}
+
+	/* need to set base address for gpx */
+	chip = &exynos4_gpios_2[16];
+	gpx_base = gpio_base2 + 0xC00;
+	for (i = 0; i < 4; i++, chip++, gpx_base += 0x20)
+		chip->base = gpx_base;
+
+	chip = exynos4_gpios_2;
+	nr_chips = ARRAY_SIZE(exynos4_gpios_2);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (!chip->config) {
+			chip->config = &exynos_gpio_cfg;
+			chip->group = group++;
+		}
+		exynos_gpiolib_attach_ofnode(chip,
+				EXYNOS4_PA_GPIO2, i * 0x20);
+	}
+	samsung_gpiolib_add_4bit_chips(exynos4_gpios_2,
+				       nr_chips, gpio_base2);
+
+	/* gpio part3 */
+	gpio_base3 = ioremap(EXYNOS4_PA_GPIO3, SZ_256);
+	if (gpio_base3 == NULL) {
+		pr_err("unable to ioremap for gpio_base3\n");
+		goto err_ioremap3;
+	}
+
+	chip = exynos4_gpios_3;
+	nr_chips = ARRAY_SIZE(exynos4_gpios_3);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (!chip->config) {
+			chip->config = &exynos_gpio_cfg;
+			chip->group = group++;
+		}
+		exynos_gpiolib_attach_ofnode(chip,
+				EXYNOS4_PA_GPIO3, i * 0x20);
+	}
+	samsung_gpiolib_add_4bit_chips(exynos4_gpios_3,
+				       nr_chips, gpio_base3);
+
+#if defined(CONFIG_CPU_EXYNOS4210) && defined(CONFIG_S5P_GPIO_INT)
+	s5p_register_gpioint_bank(IRQ_GPIO_XA, 0, IRQ_GPIO1_NR_GROUPS);
+	s5p_register_gpioint_bank(IRQ_GPIO_XB, IRQ_GPIO1_NR_GROUPS, IRQ_GPIO2_NR_GROUPS);
+#endif
+
+	return;
+
+err_ioremap3:
+	iounmap(gpio_base2);
+err_ioremap2:
+	iounmap(gpio_base1);
+err_ioremap1:
+	return;
+#endif	/* CONFIG_CPU_EXYNOS4210 */
+}
+
+static __init void exynos5_gpiolib_init(void)
+{
+#ifdef CONFIG_SOC_EXYNOS5250
+	struct samsung_gpio_chip *chip;
+	int i, nr_chips;
+	void __iomem *gpio_base1, *gpio_base2, *gpio_base3, *gpio_base4;
+	int group = 0;
+	void __iomem *gpx_base;
+
+	/* gpio part1 */
+	gpio_base1 = ioremap(EXYNOS5_PA_GPIO1, SZ_4K);
+	if (gpio_base1 == NULL) {
+		pr_err("unable to ioremap for gpio_base1\n");
+		goto err_ioremap1;
+	}
+
+	/* need to set base address for gpx */
+	chip = &exynos5_gpios_1[20];
+	gpx_base = gpio_base1 + 0xC00;
+	for (i = 0; i < 4; i++, chip++, gpx_base += 0x20)
+		chip->base = gpx_base;
+
+	chip = exynos5_gpios_1;
+	nr_chips = ARRAY_SIZE(exynos5_gpios_1);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (!chip->config) {
+			chip->config = &exynos_gpio_cfg;
+			chip->group = group++;
+		}
+		exynos_gpiolib_attach_ofnode(chip,
+				EXYNOS5_PA_GPIO1, i * 0x20);
+	}
+	samsung_gpiolib_add_4bit_chips(exynos5_gpios_1,
+				       nr_chips, gpio_base1);
+
+	/* gpio part2 */
+	gpio_base2 = ioremap(EXYNOS5_PA_GPIO2, SZ_4K);
+	if (gpio_base2 == NULL) {
+		pr_err("unable to ioremap for gpio_base2\n");
+		goto err_ioremap2;
+	}
+
+	chip = exynos5_gpios_2;
+	nr_chips = ARRAY_SIZE(exynos5_gpios_2);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (!chip->config) {
+			chip->config = &exynos_gpio_cfg;
+			chip->group = group++;
+		}
+		exynos_gpiolib_attach_ofnode(chip,
+				EXYNOS5_PA_GPIO2, i * 0x20);
+	}
+	samsung_gpiolib_add_4bit_chips(exynos5_gpios_2,
+				       nr_chips, gpio_base2);
+
+	/* gpio part3 */
+	gpio_base3 = ioremap(EXYNOS5_PA_GPIO3, SZ_4K);
+	if (gpio_base3 == NULL) {
+		pr_err("unable to ioremap for gpio_base3\n");
+		goto err_ioremap3;
+	}
+
+	/* need to set base address for gpv */
+	exynos5_gpios_3[0].base = gpio_base3;
+	exynos5_gpios_3[1].base = gpio_base3 + 0x20;
+	exynos5_gpios_3[2].base = gpio_base3 + 0x60;
+	exynos5_gpios_3[3].base = gpio_base3 + 0x80;
+	exynos5_gpios_3[4].base = gpio_base3 + 0xC0;
+
+	chip = exynos5_gpios_3;
+	nr_chips = ARRAY_SIZE(exynos5_gpios_3);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (!chip->config) {
+			chip->config = &exynos_gpio_cfg;
+			chip->group = group++;
+		}
+		exynos_gpiolib_attach_ofnode(chip,
+				EXYNOS5_PA_GPIO3, i * 0x20);
+	}
+	samsung_gpiolib_add_4bit_chips(exynos5_gpios_3,
+				       nr_chips, gpio_base3);
+
+	/* gpio part4 */
+	gpio_base4 = ioremap(EXYNOS5_PA_GPIO4, SZ_4K);
+	if (gpio_base4 == NULL) {
+		pr_err("unable to ioremap for gpio_base4\n");
+		goto err_ioremap4;
+	}
+
+	chip = exynos5_gpios_4;
+	nr_chips = ARRAY_SIZE(exynos5_gpios_4);
+
+	for (i = 0; i < nr_chips; i++, chip++) {
+		if (!chip->config) {
+			chip->config = &exynos_gpio_cfg;
+			chip->group = group++;
+		}
+		exynos_gpiolib_attach_ofnode(chip,
+				EXYNOS5_PA_GPIO4, i * 0x20);
+	}
+	samsung_gpiolib_add_4bit_chips(exynos5_gpios_4,
+				       nr_chips, gpio_base4);
+	return;
+
+err_ioremap4:
+	iounmap(gpio_base3);
+err_ioremap3:
+	iounmap(gpio_base2);
+err_ioremap2:
+	iounmap(gpio_base1);
+err_ioremap1:
+	return;
+
+#endif	/* CONFIG_SOC_EXYNOS5250 */
+}
+
 /* TODO: cleanup soc_is_* */
 static __init int samsung_gpiolib_init(void)
 {
 	struct samsung_gpio_chip *chip;
 	int i, nr_chips;
-	void __iomem *gpio_base1, *gpio_base2, *gpio_base3, *gpio_base4;
 	int group = 0;
 
 	samsung_gpiolib_set_cfg(samsung_gpio_cfgs, ARRAY_SIZE(samsung_gpio_cfgs));
@@ -2778,200 +2990,15 @@ static __init int samsung_gpiolib_init(void)
 		s5p_register_gpioint_bank(IRQ_GPIOINT, 0, S5P_GPIOINT_GROUP_MAXNR);
 #endif
 	} else if (soc_is_exynos4210()) {
-#ifdef CONFIG_CPU_EXYNOS4210
-		void __iomem *gpx_base;
-
-		/* gpio part1 */
-		gpio_base1 = ioremap(EXYNOS4_PA_GPIO1, SZ_4K);
-		if (gpio_base1 == NULL) {
-			pr_err("unable to ioremap for gpio_base1\n");
-			goto err_ioremap1;
-		}
-
-		chip = exynos4_gpios_1;
-		nr_chips = ARRAY_SIZE(exynos4_gpios_1);
-
-		for (i = 0; i < nr_chips; i++, chip++) {
-			if (!chip->config) {
-				chip->config = &exynos_gpio_cfg;
-				chip->group = group++;
-			}
-			exynos_gpiolib_attach_ofnode(chip,
-					EXYNOS4_PA_GPIO1, i * 0x20);
-		}
-		samsung_gpiolib_add_4bit_chips(exynos4_gpios_1,
-					       nr_chips, gpio_base1);
-
-		/* gpio part2 */
-		gpio_base2 = ioremap(EXYNOS4_PA_GPIO2, SZ_4K);
-		if (gpio_base2 == NULL) {
-			pr_err("unable to ioremap for gpio_base2\n");
-			goto err_ioremap2;
-		}
-
-		/* need to set base address for gpx */
-		chip = &exynos4_gpios_2[16];
-		gpx_base = gpio_base2 + 0xC00;
-		for (i = 0; i < 4; i++, chip++, gpx_base += 0x20)
-			chip->base = gpx_base;
-
-		chip = exynos4_gpios_2;
-		nr_chips = ARRAY_SIZE(exynos4_gpios_2);
-
-		for (i = 0; i < nr_chips; i++, chip++) {
-			if (!chip->config) {
-				chip->config = &exynos_gpio_cfg;
-				chip->group = group++;
-			}
-			exynos_gpiolib_attach_ofnode(chip,
-					EXYNOS4_PA_GPIO2, i * 0x20);
-		}
-		samsung_gpiolib_add_4bit_chips(exynos4_gpios_2,
-					       nr_chips, gpio_base2);
-
-		/* gpio part3 */
-		gpio_base3 = ioremap(EXYNOS4_PA_GPIO3, SZ_256);
-		if (gpio_base3 == NULL) {
-			pr_err("unable to ioremap for gpio_base3\n");
-			goto err_ioremap3;
-		}
-
-		chip = exynos4_gpios_3;
-		nr_chips = ARRAY_SIZE(exynos4_gpios_3);
-
-		for (i = 0; i < nr_chips; i++, chip++) {
-			if (!chip->config) {
-				chip->config = &exynos_gpio_cfg;
-				chip->group = group++;
-			}
-			exynos_gpiolib_attach_ofnode(chip,
-					EXYNOS4_PA_GPIO3, i * 0x20);
-		}
-		samsung_gpiolib_add_4bit_chips(exynos4_gpios_3,
-					       nr_chips, gpio_base3);
-
-#if defined(CONFIG_CPU_EXYNOS4210) && defined(CONFIG_S5P_GPIO_INT)
-		s5p_register_gpioint_bank(IRQ_GPIO_XA, 0, IRQ_GPIO1_NR_GROUPS);
-		s5p_register_gpioint_bank(IRQ_GPIO_XB, IRQ_GPIO1_NR_GROUPS, IRQ_GPIO2_NR_GROUPS);
-#endif
-
-#endif	/* CONFIG_CPU_EXYNOS4210 */
+		exynos4_gpiolib_init();
 	} else if (soc_is_exynos5250()) {
-#ifdef CONFIG_SOC_EXYNOS5250
-		void __iomem *gpx_base;
-
-		/* gpio part1 */
-		gpio_base1 = ioremap(EXYNOS5_PA_GPIO1, SZ_4K);
-		if (gpio_base1 == NULL) {
-			pr_err("unable to ioremap for gpio_base1\n");
-			goto err_ioremap1;
-		}
-
-		/* need to set base address for gpx */
-		chip = &exynos5_gpios_1[20];
-		gpx_base = gpio_base1 + 0xC00;
-		for (i = 0; i < 4; i++, chip++, gpx_base += 0x20)
-			chip->base = gpx_base;
-
-		chip = exynos5_gpios_1;
-		nr_chips = ARRAY_SIZE(exynos5_gpios_1);
-
-		for (i = 0; i < nr_chips; i++, chip++) {
-			if (!chip->config) {
-				chip->config = &exynos_gpio_cfg;
-				chip->group = group++;
-			}
-			exynos_gpiolib_attach_ofnode(chip,
-					EXYNOS5_PA_GPIO1, i * 0x20);
-		}
-		samsung_gpiolib_add_4bit_chips(exynos5_gpios_1,
-					       nr_chips, gpio_base1);
-
-		/* gpio part2 */
-		gpio_base2 = ioremap(EXYNOS5_PA_GPIO2, SZ_4K);
-		if (gpio_base2 == NULL) {
-			pr_err("unable to ioremap for gpio_base2\n");
-			goto err_ioremap2;
-		}
-
-		chip = exynos5_gpios_2;
-		nr_chips = ARRAY_SIZE(exynos5_gpios_2);
-
-		for (i = 0; i < nr_chips; i++, chip++) {
-			if (!chip->config) {
-				chip->config = &exynos_gpio_cfg;
-				chip->group = group++;
-			}
-			exynos_gpiolib_attach_ofnode(chip,
-					EXYNOS5_PA_GPIO2, i * 0x20);
-		}
-		samsung_gpiolib_add_4bit_chips(exynos5_gpios_2,
-					       nr_chips, gpio_base2);
-
-		/* gpio part3 */
-		gpio_base3 = ioremap(EXYNOS5_PA_GPIO3, SZ_4K);
-		if (gpio_base3 == NULL) {
-			pr_err("unable to ioremap for gpio_base3\n");
-			goto err_ioremap3;
-		}
-
-		/* need to set base address for gpv */
-		exynos5_gpios_3[0].base = gpio_base3;
-		exynos5_gpios_3[1].base = gpio_base3 + 0x20;
-		exynos5_gpios_3[2].base = gpio_base3 + 0x60;
-		exynos5_gpios_3[3].base = gpio_base3 + 0x80;
-		exynos5_gpios_3[4].base = gpio_base3 + 0xC0;
-
-		chip = exynos5_gpios_3;
-		nr_chips = ARRAY_SIZE(exynos5_gpios_3);
-
-		for (i = 0; i < nr_chips; i++, chip++) {
-			if (!chip->config) {
-				chip->config = &exynos_gpio_cfg;
-				chip->group = group++;
-			}
-			exynos_gpiolib_attach_ofnode(chip,
-					EXYNOS5_PA_GPIO3, i * 0x20);
-		}
-		samsung_gpiolib_add_4bit_chips(exynos5_gpios_3,
-					       nr_chips, gpio_base3);
-
-		/* gpio part4 */
-		gpio_base4 = ioremap(EXYNOS5_PA_GPIO4, SZ_4K);
-		if (gpio_base4 == NULL) {
-			pr_err("unable to ioremap for gpio_base4\n");
-			goto err_ioremap4;
-		}
-
-		chip = exynos5_gpios_4;
-		nr_chips = ARRAY_SIZE(exynos5_gpios_4);
-
-		for (i = 0; i < nr_chips; i++, chip++) {
-			if (!chip->config) {
-				chip->config = &exynos_gpio_cfg;
-				chip->group = group++;
-			}
-			exynos_gpiolib_attach_ofnode(chip,
-					EXYNOS5_PA_GPIO4, i * 0x20);
-		}
-		samsung_gpiolib_add_4bit_chips(exynos5_gpios_4,
-					       nr_chips, gpio_base4);
-#endif	/* CONFIG_SOC_EXYNOS5250 */
+		exynos5_gpiolib_init();
 	} else {
 		WARN(1, "Unknown SoC in gpio-samsung, no GPIOs added\n");
 		return -ENODEV;
 	}
 
 	return 0;
-
-err_ioremap4:
-	iounmap(gpio_base3);
-err_ioremap3:
-	iounmap(gpio_base2);
-err_ioremap2:
-	iounmap(gpio_base1);
-err_ioremap1:
-	return -ENOMEM;
 }
 core_initcall(samsung_gpiolib_init);
 
-- 
1.7.9.2.359.gebfc2

