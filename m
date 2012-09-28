Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423425Ab2I1Vi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:38:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58897 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423372Ab2I1Vg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 11/12] pinctrl: samsung: use __devinit section for init code
Date: Fri, 28 Sep 2012 23:36:16 +0200
Message-Id: <1348868177-21205-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:gLpzzgPiaTmBDVmu14LPHDlQ230NvtguEmDPZVwdRzK
 Ukzv2AweNryXogFexkVF4AyNxEZic03O/xjaZSuk45oGmTGkGj
 Fv/rRQHVHLGtgA7UCEQc9mVQv/p2qm2eB+L0BY+rsj73x+k1jl
 bWIr+mItOYaqrCW5JsRENR4G9+Qj3GOgzScTIM6FPkjRCmQ/iR
 DfeesTrRHV9rAb5ZrTehyhaMy7SfwP+t2NFhVbY3BXa17UbFkb
 gXBT+23TwXe5cnZNhD7T+GSii3+R+KaLYZC2keZVECn0p3FndF
 eLhxJ4ndGGlOEsezrDMsWRCRMtPZTXlopyYwlJSf/mVgTF/htJ
 Fj7pE0DgK65eTdt0kpfsDp/5Jv8yvYm+pcrXxfhxW1OhuIxO2m
 Q3pz2EuIC0Y0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The samsung pinctrl driver has a probe function that is
__devinit and that calls a lot of other functions that are
marked __init, which kbuild complains about.

Marking everything __devinit means that the code does not
discarded when CONFIG_HOTPLUG is set, which is a little
more wasteful, but also more consistent

Without this patch, building exynos_defconfig results in:

WARNING: drivers/pinctrl/built-in.o(.devinit.text+0x124): Section mismatch in reference from the function samsung_pinctrl_probe() to the function .init.text:samsung_gpiolib_register()
The function __devinit samsung_pinctrl_probe() references
a function __init samsung_gpiolib_register().
If samsung_gpiolib_register is only used by samsung_pinctrl_probe then
annotate samsung_gpiolib_register with a matching annotation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/pinctrl/pinctrl-samsung.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index dd108a9..861cd5f 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -513,7 +513,7 @@ static int samsung_gpio_direction_output(struct gpio_chip *gc, unsigned offset,
  * Parse the pin names listed in the 'samsung,pins' property and convert it
  * into a list of gpio numbers are create a pin group from it.
  */
-static int __init samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
+static int __devinit samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
 			struct device_node *cfg_np, struct pinctrl_desc *pctl,
 			unsigned int **pin_list, unsigned int *npins)
 {
@@ -560,7 +560,7 @@ static int __init samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
  * from device node of the pin-controller. A pin group is formed with all
  * the pins listed in the "samsung,pins" property.
  */
-static int __init samsung_pinctrl_parse_dt(struct platform_device *pdev,
+static int __devinit samsung_pinctrl_parse_dt(struct platform_device *pdev,
 				struct samsung_pinctrl_drv_data *drvdata)
 {
 	struct device *dev = &pdev->dev;
@@ -655,7 +655,7 @@ static int __init samsung_pinctrl_parse_dt(struct platform_device *pdev,
 }
 
 /* register the pinctrl interface with the pinctrl subsystem */
-static int __init samsung_pinctrl_register(struct platform_device *pdev,
+static int __devinit samsung_pinctrl_register(struct platform_device *pdev,
 				struct samsung_pinctrl_drv_data *drvdata)
 {
 	struct pinctrl_desc *ctrldesc = &drvdata->pctl;
@@ -729,7 +729,7 @@ static int __init samsung_pinctrl_register(struct platform_device *pdev,
 }
 
 /* register the gpiolib interface with the gpiolib subsystem */
-static int __init samsung_gpiolib_register(struct platform_device *pdev,
+static int __devinit samsung_gpiolib_register(struct platform_device *pdev,
 				struct samsung_pinctrl_drv_data *drvdata)
 {
 	struct gpio_chip *gc;
@@ -762,7 +762,7 @@ static int __init samsung_gpiolib_register(struct platform_device *pdev,
 }
 
 /* unregister the gpiolib interface with the gpiolib subsystem */
-static int __init samsung_gpiolib_unregister(struct platform_device *pdev,
+static int __devinit samsung_gpiolib_unregister(struct platform_device *pdev,
 				struct samsung_pinctrl_drv_data *drvdata)
 {
 	int ret = gpiochip_remove(drvdata->gc);
-- 
1.7.10

