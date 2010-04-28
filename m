Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab0D1WVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:21:40 -0400
Received: from tex.lwn.net ([70.33.254.29]:48833 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab0D1WSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:20 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 17/30] viafb: Turn GPIO and i2c into proper platform devices
Date: Wed, 28 Apr 2010 16:17:18 -0600
Message-Id: <1272493051-25380-18-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another step toward making this thing a real multifunction device driver.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-core.c |   84 +++++++++++++++++++++++++++++++++++-------
 drivers/video/via/via-core.h |    1 +
 drivers/video/via/via-gpio.c |   49 +++++++++++++++++-------
 drivers/video/via/via-gpio.h |    5 +-
 drivers/video/via/via_i2c.c  |   29 +++++++++++++-
 drivers/video/via/via_i2c.h  |    6 +--
 6 files changed, 135 insertions(+), 39 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index a2e08ac..c7ce006 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -190,6 +190,68 @@ static void __devexit via_pci_teardown_mmio(struct viafb_dev *vdev)
 	iounmap(vdev->engine_mmio);
 }
 
+/*
+ * Create our subsidiary devices.
+ */
+static struct viafb_subdev_info {
+	char *name;
+	struct platform_device *platdev;
+} viafb_subdevs[] = {
+	{
+		.name = "viafb-gpio",
+	},
+	{
+		.name = "viafb-i2c",
+	}
+};
+#define N_SUBDEVS ARRAY_SIZE(viafb_subdevs)
+
+static int __devinit via_create_subdev(struct viafb_dev *vdev,
+		struct viafb_subdev_info *info)
+{
+	int ret;
+
+	info->platdev = platform_device_alloc(info->name, -1);
+	if (!info->platdev) {
+		dev_err(&vdev->pdev->dev, "Unable to allocate pdev %s\n",
+			info->name);
+		return -ENOMEM;
+	}
+	info->platdev->dev.parent = &vdev->pdev->dev;
+	info->platdev->dev.platform_data = vdev;
+	ret = platform_device_add(info->platdev);
+	if (ret) {
+		dev_err(&vdev->pdev->dev, "Unable to add pdev %s\n",
+				info->name);
+		platform_device_put(info->platdev);
+		info->platdev = NULL;
+	}
+	return ret;
+}
+
+static int __devinit via_setup_subdevs(struct viafb_dev *vdev)
+{
+	int i;
+
+	/*
+	 * Ignore return values.  Even if some of the devices
+	 * fail to be created, we'll still be able to use some
+	 * of the rest.
+	 */
+	for (i = 0; i < N_SUBDEVS; i++)
+		via_create_subdev(vdev, viafb_subdevs + i);
+	return 0;
+}
+
+static void __devexit via_teardown_subdevs(void)
+{
+	int i;
+
+	for (i = 0; i < N_SUBDEVS; i++)
+		if (viafb_subdevs[i].platdev)
+			platform_device_unregister(viafb_subdevs[i].platdev);
+}
+
 
 static int __devinit via_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
@@ -205,6 +267,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	memset(&global_dev, 0, sizeof(global_dev));
 	global_dev.pdev = pdev;
 	global_dev.chip_type = ent->driver_data;
+	global_dev.port_cfg = adap_configs;
 	spin_lock_init(&global_dev.reg_lock);
 	ret = via_pci_setup_mmio(&global_dev);
 	if (ret)
@@ -216,19 +279,9 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 	/*
-	 * Create the I2C busses.  Bailing out on failure seems extreme,
-	 * but that's what the code did before.
-	 */
-	ret = viafb_create_i2c_busses(&global_dev, adap_configs);
-	if (ret) {
-		via_fb_pci_remove(pdev);
-		return ret;
-	}
-	/*
-	 * Create the GPIOs.  We continue whether or not this succeeds;
-	 * the framebuffer might be useful even without GPIO ports.
+	 * Create our subdevices.
 	 */
-	ret = viafb_create_gpios(&global_dev, adap_configs);
+	via_setup_subdevs(&global_dev);
 	return 0;
 
 out_teardown:
@@ -238,8 +291,7 @@ out_teardown:
 
 static void __devexit via_pci_remove(struct pci_dev *pdev)
 {
-	viafb_destroy_gpios();
-	viafb_delete_i2c_busses();
+	via_teardown_subdevs();
 	via_fb_pci_remove(pdev);
 	via_pci_teardown_mmio(&global_dev);
 	pci_disable_device(pdev);
@@ -288,11 +340,15 @@ static int __init via_core_init(void)
 	if (ret)
 		return ret;
 	viafb_init();
+	viafb_i2c_init();
+	viafb_gpio_init();
 	return 0;
 }
 
 static void __exit via_core_exit(void)
 {
+	viafb_gpio_exit();
+	viafb_i2c_exit();
 	viafb_exit();
 	pci_unregister_driver(&via_driver);
 }
diff --git a/drivers/video/via/via-core.h b/drivers/video/via/via-core.h
index d004290..ac89c2a 100644
--- a/drivers/video/via/via-core.h
+++ b/drivers/video/via/via-core.h
@@ -63,6 +63,7 @@ struct via_port_cfg {
 struct viafb_dev {
 	struct pci_dev *pdev;
 	int chip_type;
+	struct via_port_cfg *port_cfg;
 	/*
 	 * Spinlock for access to device registers.  Not yet
 	 * globally used.
diff --git a/drivers/video/via/via-gpio.c b/drivers/video/via/via-gpio.c
index 6b36117..44537be 100644
--- a/drivers/video/via/via-gpio.c
+++ b/drivers/video/via/via-gpio.c
@@ -7,6 +7,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/gpio.h>
+#include <linux/platform_device.h>
 #include "via-core.h"
 #include "via-gpio.h"
 #include "global.h"
@@ -172,12 +173,27 @@ static void viafb_gpio_disable(struct viafb_gpio *gpio)
 	via_write_reg_mask(VIASR, gpio->vg_port_index, 0, 0x02);
 }
 
+/*
+ * Look up a specific gpio and return the number it was assigned.
+ */
+int viafb_gpio_lookup(const char *name)
+{
+	int i;
 
+	for (i = 0; i < gpio_config.gpio_chip.ngpio; i++)
+		if (!strcmp(name, gpio_config.active_gpios[i]->vg_name))
+			return gpio_config.gpio_chip.base + i;
+	return -1;
+}
+EXPORT_SYMBOL_GPL(viafb_gpio_lookup);
 
-
-int viafb_create_gpios(struct viafb_dev *vdev,
-		const struct via_port_cfg *port_cfg)
+/*
+ * Platform device stuff.
+ */
+static __devinit int viafb_gpio_probe(struct platform_device *platdev)
 {
+	struct viafb_dev *vdev = platdev->dev.platform_data;
+	struct via_port_cfg *port_cfg = vdev->port_cfg;
 	int i, ngpio = 0, ret;
 	struct viafb_gpio *gpio;
 	unsigned long flags;
@@ -222,11 +238,10 @@ int viafb_create_gpios(struct viafb_dev *vdev,
 		gpio_config.gpio_chip.ngpio = 0;
 	}
 	return ret;
-/* Port enable ? */
 }
 
 
-int viafb_destroy_gpios(void)
+static int viafb_gpio_remove(struct platform_device *platdev)
 {
 	unsigned long flags;
 	int ret = 0, i;
@@ -253,16 +268,20 @@ out:
 	return ret;
 }
 
-/*
- * Look up a specific gpio and return the number it was assigned.
- */
-int viafb_gpio_lookup(const char *name)
+static struct platform_driver via_gpio_driver = {
+	.driver = {
+		.name = "viafb-gpio",
+	},
+	.probe = viafb_gpio_probe,
+	.remove = viafb_gpio_remove,
+};
+
+int viafb_gpio_init(void)
 {
-	int i;
+	return platform_driver_register(&via_gpio_driver);
+}
 
-	for (i = 0; i < gpio_config.gpio_chip.ngpio; i++)
-		if (!strcmp(name, gpio_config.active_gpios[i]->vg_name))
-			return gpio_config.gpio_chip.base + i;
-	return -1;
+void viafb_gpio_exit(void)
+{
+	platform_driver_unregister(&via_gpio_driver);
 }
-EXPORT_SYMBOL_GPL(viafb_gpio_lookup);
diff --git a/drivers/video/via/via-gpio.h b/drivers/video/via/via-gpio.h
index 7b53f96..8281aea 100644
--- a/drivers/video/via/via-gpio.h
+++ b/drivers/video/via/via-gpio.h
@@ -8,8 +8,7 @@
 #ifndef __VIA_GPIO_H__
 #define __VIA_GPIO_H__
 
-extern int viafb_create_gpios(struct viafb_dev *vdev,
-		const struct via_port_cfg *port_cfg);
-extern int viafb_destroy_gpios(void);
 extern int viafb_gpio_lookup(const char *name);
+extern int viafb_gpio_init(void);
+extern void viafb_gpio_exit(void);
 #endif
diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 116fd3e..3ff60b2 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -19,6 +19,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/platform_device.h>
 #include "via-core.h"
 #include "via_i2c.h"
 #include "global.h"
@@ -185,11 +186,14 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
 	return i2c_bit_add_bus(adapter);
 }
 
-int viafb_create_i2c_busses(struct viafb_dev *dev, struct via_port_cfg *configs)
+static int viafb_i2c_probe(struct platform_device *platdev)
 {
 	int i, ret;
+	struct via_port_cfg *configs;
+
+	i2c_vdev = platdev->dev.platform_data;
+	configs = i2c_vdev->port_cfg;
 
-	i2c_vdev = dev;
 	for (i = 0; i < VIAFB_NUM_PORTS; i++) {
 		struct via_port_cfg *adap_cfg = configs++;
 		struct via_i2c_stuff *i2c_stuff = &via_i2c_par[i];
@@ -211,7 +215,7 @@ int viafb_create_i2c_busses(struct viafb_dev *dev, struct via_port_cfg *configs)
 	return 0;
 }
 
-void viafb_delete_i2c_busses(void)
+static int viafb_i2c_remove(struct platform_device *platdev)
 {
 	int i;
 
@@ -224,4 +228,23 @@ void viafb_delete_i2c_busses(void)
 		if (i2c_stuff->adapter.algo_data == &i2c_stuff->algo)
 			i2c_del_adapter(&i2c_stuff->adapter);
 	}
+	return 0;
+}
+
+static struct platform_driver via_i2c_driver = {
+	.driver = {
+		.name = "viafb-i2c",
+	},
+	.probe = viafb_i2c_probe,
+	.remove = viafb_i2c_remove,
+};
+
+int viafb_i2c_init(void)
+{
+	return platform_driver_register(&via_i2c_driver);
+}
+
+void viafb_i2c_exit(void)
+{
+	platform_driver_unregister(&via_i2c_driver);
 }
diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
index 0685de9..b2332cc 100644
--- a/drivers/video/via/via_i2c.h
+++ b/drivers/video/via/via_i2c.h
@@ -35,8 +35,6 @@ int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata);
 int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data);
 int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len);
 
-struct viafb_par;
-int viafb_create_i2c_busses(struct viafb_dev *vdev, struct via_port_cfg *cfg);
-void viafb_delete_i2c_busses(void);
-struct i2c_adapter *viafb_find_adapter(enum viafb_i2c_adap which);
+extern int viafb_i2c_init(void);
+extern void viafb_i2c_exit(void);
 #endif /* __VIA_I2C_H__ */
-- 
1.7.0.1

