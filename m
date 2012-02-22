Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2BVAnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 19:43:22 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3514 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2BVAnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 19:43:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 Feb 2012 16:43:20 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2] pinctrl: Assume map table entries can't have a NULL name field
Date: Tue, 21 Feb 2012 17:43:16 -0700
Message-Id: <1329871396-19381-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl_register_mappings() already requires that every mapping table
entry have a non-NULL name field.

Logically, this makes sense too; drivers should always request a specific
named state so they know what they're getting. Relying on getting the
first mentioned state in the mapping table is error-prone, and a nasty
special case to implement, given that a given the mapping table may define
multiple states for a device.

Update a few places in the code and documentation that still allowed for
NULL name fields.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This is an updated version of PATCH 8/20 of the series I posted on Sunday.
Hopefully patches 8, 9 at least can be applied now, assuming Dong is OK
with this patch after my explanation (and note that a later patch replaces
the need to pass "default" to pinctrl_get() by adding new API pinctrl_
get_select_default()).

v2: Update mach-u300/core.c and sirfsoc_uart.c not to request NULL state
names.

 Documentation/pinctrl.txt         |    8 ++------
 arch/arm/mach-u300/core.c         |    8 ++++----
 drivers/pinctrl/core.c            |   22 +++++++---------------
 drivers/tty/serial/sirfsoc_uart.c |    2 +-
 4 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index ee3266b..bfe83b1 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -934,7 +934,7 @@ foo_probe()
 	/* Allocate a state holder named "state" etc */
 	struct pinctrl p;
 
-	p = pinctrl_get(&device, NULL);
+	p = pinctrl_get(&device, "default");
 	if IS_ERR(p)
 		return PTR_ERR(p);
 	pinctrl_enable(p);
@@ -948,10 +948,6 @@ foo_remove()
 	pinctrl_put(state->p);
 }
 
-If you want to grab a specific control mapping and not just the first one
-found for this device you can specify a specific mapping name, for example in
-the above example the second i2c0 setting: pinctrl_get(&device, "spi0-pos-B");
-
 This get/enable/disable/put sequence can just as well be handled by bus drivers
 if you don't want each and every driver to handle it and you know the
 arrangement on your bus.
@@ -1003,7 +999,7 @@ Since it may be common to request the core to hog a few always-applicable
 mux settings on the primary pin controller, there is a convenience macro for
 this:
 
-PIN_MAP_PRIMARY_SYS_HOG("POWERMAP", "pinctrl-foo", "power_func")
+PIN_MAP_SYS_HOG("POWERMAP", "pinctrl-foo", "power_func")
 
 This gives the exact same result as the above construction.
 
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index d66bc97..aa0c46d 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1558,9 +1558,9 @@ static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	PIN_MAP_SYS_HOG("EMIF0", "pinmux-u300", "emif0"),
 	PIN_MAP_SYS_HOG("EMIF1", "pinmux-u300", "emif1"),
 	/* per-device maps for MMC/SD, SPI and UART */
-	PIN_MAP("MMCSD", "pinmux-u300", "mmc0", "mmci"),
-	PIN_MAP("SPI", "pinmux-u300", "spi0", "pl022"),
-	PIN_MAP("UART0", "pinmux-u300", "uart0", "uart0"),
+	PIN_MAP("default", "pinmux-u300", "mmc0", "mmci"),
+	PIN_MAP("default", "pinmux-u300", "spi0", "pl022"),
+	PIN_MAP("default", "pinmux-u300", "uart0", "uart0"),
 };
 
 struct u300_mux_hog {
@@ -1592,7 +1592,7 @@ static int __init u300_pinctrl_fetch(void)
 		struct pinctrl *p;
 		int ret;
 
-		p = pinctrl_get(u300_mux_hogs[i].dev, NULL);
+		p = pinctrl_get(u300_mux_hogs[i].dev, "default");
 		if (IS_ERR(p)) {
 			pr_err("u300: could not get pinmux hog %s\n",
 			       u300_mux_hogs[i].name);
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index fb3fbb7..9d421e3 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -488,8 +488,8 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 	int i;
 	struct pinctrl_map const *map;
 
-	/* We must have dev or ID or both */
-	if (!dev && !name)
+	/* We must have a state name */
+	if (WARN_ON(!name))
 		return ERR_PTR(-EINVAL);
 
 	if (dev)
@@ -529,23 +529,16 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		pr_debug("in map, found pctldev %s to handle function %s",
 			 dev_name(pctldev->dev), map->function);
 
-		/*
-		 * If we're looking for a specific named map, this must match,
-		 * else we loop and look for the next.
-		 */
-		if (name != NULL) {
-			if (map->name == NULL)
-				continue;
-			if (strcmp(map->name, name))
-				continue;
-		}
+		/* State name must be the one we're looking for */
+		if (strcmp(map->name, name))
+			continue;
 
 		/*
 		 * This is for the case where no device name is given, we
 		 * already know that the function name matches from above
 		 * code.
 		 */
-		if (!map->dev_name && (name != NULL))
+		if (!map->dev_name)
 			found_map = true;
 
 		/* If the mapping has a device set up it must match */
@@ -579,8 +572,7 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 
 	pr_debug("found %u mux maps for device %s, UD %s\n",
 		 num_maps,
-		 devname ? devname : "(anonymous)",
-		 name ? name : "(undefined)");
+		 devname ? devname : "(anonymous)", name);
 
 	/* Add the pinmux to the global list */
 	mutex_lock(&pinctrl_list_mutex);
diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
index c1a871e..51610a7 100644
--- a/drivers/tty/serial/sirfsoc_uart.c
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -673,7 +673,7 @@ int sirfsoc_uart_probe(struct platform_device *pdev)
 	port->irq = res->start;
 
 	if (sirfport->hw_flow_ctrl) {
-		sirfport->p = pinctrl_get(&pdev->dev, NULL);
+		sirfport->p = pinctrl_get(&pdev->dev, "default");
 		ret = IS_ERR(sirfport->p);
 		if (ret)
 			goto pin_err;
-- 
1.7.0.4

