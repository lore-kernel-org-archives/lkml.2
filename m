Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab1K3MdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:33:25 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:55284 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757730Ab1K3MdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:33:24 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2 v3] pinctrl: make a copy of pinmux map
Date: Wed, 30 Nov 2011 13:32:41 +0100
Message-ID: <1322656361-6463-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes a deep copy of the pinmux function map instead of
keeping the copy supplied from the platform around. This makes
it possible to tag the platforms map with __initdata as is also
done as part of this patch.

Rationale: a certain target platform (PXA) has numerous
pinmux maps, many of which will be lying around unused after
boot in a multi-platform binary. Instead, deep-copy the one
we're going to use and tag them all __initdata so they go away
after boot.

ChangeLog v1->v2:
- Fixup the deep copy, missed a few items on the struct,
  plus mark bool member non-const since we're making runtime
  copies if this stuff now.
ChangeLog v2->v3:
- Make a shallow copy (just copy the array of map structs)
  as Arnd noticed, string constants never get discarded by the
  kernel anyway, so these pointers may be safely copied over.

Suggested-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt       |    4 +-
 arch/arm/mach-u300/core.c       |    2 +-
 drivers/pinctrl/pinmux.c        |   44 ++++++++++++++++++++++++++++++--------
 include/linux/pinctrl/machine.h |    2 +-
 4 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 720dfea..d9d57c8 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -784,7 +784,7 @@ spi on the second function mapping:
 
 #include <linux/pinctrl/machine.h>
 
-static struct pinmux_map pmx_mapping[] = {
+static struct pinmux_map __initdata pmx_mapping[] = {
 	{
 		.ctrl_dev_name = "pinctrl.0",
 		.function = "spi0",
@@ -821,7 +821,7 @@ Since the above construct is pretty common there is a helper macro to make
 it even more compact which assumes you want to use pinctrl.0 and position
 0 for mapping, for example:
 
-static struct pinmux_map pmx_mapping[] = {
+static struct pinmux_map __initdata pmx_mapping[] = {
        PINMUX_MAP_PRIMARY("I2CMAP", "i2c0", "foo-i2c.0"),
 };
 
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index f399862..06bdae7 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1613,7 +1613,7 @@ static struct platform_device pinmux_device = {
 };
 
 /* Pinmux settings */
-static struct pinmux_map u300_pinmux_map[] = {
+static struct pinmux_map __initdata u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
 	PINMUX_MAP_PRIMARY_SYS_HOG("POWER", "power"),
 	PINMUX_MAP_PRIMARY_SYS_HOG("EMIF0", "emif0"),
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 15ae972..680f690 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/sysfs.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -37,7 +38,7 @@ static DEFINE_MUTEX(pinmux_hoglist_mutex);
 static LIST_HEAD(pinmux_hoglist);
 
 /* Global pinmux maps, we allow one set only */
-static struct pinmux_map const *pinmux_maps;
+static struct pinmux_map *pinmux_maps;
 static unsigned pinmux_maps_num;
 
 /**
@@ -337,7 +338,9 @@ EXPORT_SYMBOL_GPL(pinmux_gpio_direction_output);
 
 /**
  * pinmux_register_mappings() - register a set of pinmux mappings
- * @maps: the pinmux mappings table to register
+ * @maps: the pinmux mappings table to register, this should be marked with
+ *	__initdata so it can be discarded after boot, this function will
+ *	perform a shallow copy for the mapping entries.
  * @num_maps: the number of maps in the mapping table
  *
  * Only call this once during initialization of your machine, the function is
@@ -348,32 +351,48 @@ EXPORT_SYMBOL_GPL(pinmux_gpio_direction_output);
 int __init pinmux_register_mappings(struct pinmux_map const *maps,
 				    unsigned num_maps)
 {
+	int ret = 0;
 	int i;
 
-	if (pinmux_maps != NULL) {
+	if (pinmux_maps_num != 0) {
 		pr_err("pinmux mappings already registered, you can only "
 		       "register one set of maps\n");
 		return -EINVAL;
 	}
 
 	pr_debug("add %d pinmux maps\n", num_maps);
+
+	/*
+	 * Make a copy of the map array - string pointers will end up in the
+	 * kernel const section anyway so these do not need to be deep copied.
+	 */
+	pinmux_maps = kmemdup(maps, sizeof(struct pinmux_map) * num_maps,
+			      GFP_KERNEL);
+	if (!pinmux_maps)
+		return -ENOMEM;
+
 	for (i = 0; i < num_maps; i++) {
-		/* Sanity check the mapping */
+		/* Sanity check the mapping while copying it */
 		if (!maps[i].name) {
 			pr_err("failed to register map %d: "
 			       "no map name given\n", i);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_out_free;
 		}
+
 		if (!maps[i].ctrl_dev && !maps[i].ctrl_dev_name) {
 			pr_err("failed to register map %s (%d): "
 			       "no pin control device given\n",
 			       maps[i].name, i);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_out_free;
 		}
+
 		if (!maps[i].function) {
 			pr_err("failed to register map %s (%d): "
 			       "no function ID given\n", maps[i].name, i);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_out_free;
 		}
 
 		if (!maps[i].dev && !maps[i].dev_name)
@@ -384,12 +403,17 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 			pr_debug("register map %s, function %s\n",
 				 maps[i].name,
 				 maps[i].function);
-	}
 
-	pinmux_maps = maps;
-	pinmux_maps_num = num_maps;
+		pinmux_maps_num++;
+	}
 
 	return 0;
+
+err_out_free:
+	kfree(pinmux_maps);
+	pinmux_maps = NULL;
+	pinmux_maps_num = 0;
+	return ret;
 }
 
 /**
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index 8886353..f537231 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -48,7 +48,7 @@ struct pinmux_map {
 	const char *group;
 	struct device *dev;
 	const char *dev_name;
-	const bool hog_on_boot;
+	bool hog_on_boot;
 };
 
 /*
-- 
1.7.3.2

