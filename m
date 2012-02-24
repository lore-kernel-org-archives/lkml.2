Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2BXAEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:04:46 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6959 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2BXAEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:04:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 23 Feb 2012 16:04:43 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define, and use it
Date: Thu, 23 Feb 2012 17:04:38 -0700
Message-ID: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a single centralized name for the default state.

Update PIN_MAP_* macros to use this state name, instead of requiring the
user to pass a state name in.

Update documentation and mapping tables to use this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
These 3 patches are small cleanup/fixes triggered by review comments from
the 20-long series I posted a few days ago.

These patches are based on the 4-long series that I posted yesterday.

 Documentation/pinctrl.txt       |    8 ++++----
 arch/arm/mach-u300/core.c       |    6 +++---
 include/linux/pinctrl/machine.h |   13 ++++++++-----
 include/linux/pinctrl/pinctrl.h |    2 ++
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index fa9163a..8bf46bc 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -814,7 +814,7 @@ it even more compact which assumes you want to use pinctrl-foo and position
 0 for mapping, for example:
 
 static struct pinctrl_map __initdata mapping[] = {
-       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
+	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "foo-i2c.0"),
 };
 
 
@@ -930,7 +930,7 @@ foo_probe()
 	/* Allocate a state holder named "state" etc */
 	struct pinctrl p;
 
-	p = pinctrl_get(&device, NULL);
+	p = pinctrl_get(&device, PINCTRL_STATE_DEFAULT);
 	if IS_ERR(p)
 		return PTR_ERR(p);
 	pinctrl_enable(p);
@@ -988,7 +988,7 @@ This is enabled by simply setting the .dev_name field in the map to the name
 of the pin controller itself, like this:
 
 {
-	.name = "POWERMAP"
+	.name = PINCTRL_STATE_DEFAULT,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "power_func",
 	.dev_name = "pinctrl-foo",
@@ -998,7 +998,7 @@ Since it may be common to request the core to hog a few always-applicable
 mux settings on the primary pin controller, there is a convenience macro for
 this:
 
-PIN_MAP_PRIMARY_SYS_HOG("POWERMAP", "pinctrl-foo", "power_func")
+PIN_MAP_SYS_HOG("pinctrl-foo", "power_func")
 
 This gives the exact same result as the above construction.
 
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index d66bc97..2388dc2 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1554,9 +1554,9 @@ static struct platform_device pinmux_device = {
 /* Pinmux settings */
 static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
-	PIN_MAP_SYS_HOG("POWER", "pinmux-u300", "power"),
-	PIN_MAP_SYS_HOG("EMIF0", "pinmux-u300", "emif0"),
-	PIN_MAP_SYS_HOG("EMIF1", "pinmux-u300", "emif1"),
+	PIN_MAP_SYS_HOG("pinmux-u300", "power"),
+	PIN_MAP_SYS_HOG("pinmux-u300", "emif0"),
+	PIN_MAP_SYS_HOG("pinmux-u300", "emif1"),
 	/* per-device maps for MMC/SD, SPI and UART */
 	PIN_MAP("MMCSD", "pinmux-u300", "mmc0", "mmci"),
 	PIN_MAP("SPI", "pinmux-u300", "spi0", "pl022"),
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index 400f192..4743f84 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -12,6 +12,8 @@
 #ifndef __LINUX_PINCTRL_MACHINE_H
 #define __LINUX_PINCTRL_MACHINE_H
 
+#include "pinctrl.h"
+
 /**
  * struct pinctrl_map - boards/machines shall provide this map for devices
  * @name: the name of this specific map entry for the particular machine.
@@ -49,17 +51,18 @@ struct pinctrl_map {
  * Convenience macro to map a system function onto a certain pinctrl device,
  * to be hogged by the pin control core until the system shuts down.
  */
-#define PIN_MAP_SYS_HOG(a, b, c) \
-	{ .name = a, .ctrl_dev_name = b, .dev_name = b, .function = c, }
+#define PIN_MAP_SYS_HOG(a, b) \
+	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
+	  .function = b, }
 
 /*
  * Convenience macro to map a system function onto a certain pinctrl device
  * using a specified group, to be hogged by the pin control core until the
  * system shuts down.
  */
-#define PIN_MAP_SYS_HOG_GROUP(a, b, c, d)		\
-	{ .name = a, .ctrl_dev_name = b, .dev_name = b, .function = c, \
-	  .group = d, }
+#define PIN_MAP_SYS_HOG_GROUP(a, b, c) \
+	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
+	  .function = b, .group = c, }
 
 #ifdef CONFIG_PINMUX
 
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 8bd22ee..411fe23 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -19,6 +19,8 @@
 #include <linux/list.h>
 #include <linux/seq_file.h>
 
+#define PINCTRL_STATE_DEFAULT "default"
+
 struct pinctrl_dev;
 struct pinmux_ops;
 struct pinconf_ops;
-- 
1.7.0.4

