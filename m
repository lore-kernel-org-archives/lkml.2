Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab2F0Kb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:31:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56213 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab2F0KbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:31:24 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-67-4feae0faad76
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v4] clock: max77686: Add driver for Maxim 77686 32KHz crystal
 oscillator
Date: Wed, 27 Jun 2012 19:31:17 +0900
Message-id: <1340793077-14300-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd1fD175G9yapW9xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgypjTtZS24aV4xq309ewPjX90uRk4OCQETiZ7Py9kgbDGJC/fW
	A9lcHEIC0xklPq3cwArhLGWSuLnpOFgVm4COxP99N9lBbBEBBYnNvc/AipgF/jNKXFjSxdLF
	yMEhLBAl0dtuAlLDIqAqcXfGdxYQm1fAQ+Lr9RusENsUJBbce8s2gZF7ASPDKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYxgHz6T2sG4ssHiEKMAB6MSD+/UW6/8hVgTy4orcw8xSnAwK4nw
	Hl8HFOJNSaysSi3Kjy8qzUktPsQozcGiJM7bZH3BX0ggPbEkNTs1tSC1CCbLxMEp1cDI/WbF
	zHOfpPffPSE2k/m4+Ra28CWB+h9f8aTorq/f/8Ni3wf7hIMi6lzxLDMFPsfX7VV5cH07Y68V
	v/DE2O9OtgdLt9nldf54eeqNz4HJP3s+eaQmOZ602/dZoEWSNcOus5NhSUR/Sc9xyfCwLvaV
	3dP+rsxyXW293sytj0vZhLGdNyjY6K8SS3FGoqEWc1FxIgB1xyVW3QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim 77686 has three 32KHz clock outputs through the its crystal oscillator.
This driver can control those ouputs by I2C bus. The clocks are used to supply
to SOC and peripheral chips as a clock source. Clocks can be enabled/disabled only.
It uses regmap interface to communicate with I2C bus.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v4
- Remove global definition of clk instances.
- Add max77686_clk_register() to simplify the registering clocks.
- Add support clkdev so user can get clocks with clkdev API.
- Replace enable/diable function to prepare/unprepare fuction to assure
  that it excutes in non-atomic context.

 drivers/clk/Kconfig        |    8 ++
 drivers/clk/Makefile       |    2 +
 drivers/clk/clk-max77686.c |  192 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 202 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-max77686.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 165e1fe..936c27a 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -44,4 +44,12 @@ config COMMON_CLK_DEBUG
 	  clk_flags, clk_prepare_count, clk_enable_count &
 	  clk_notifier_count.
 
+config CLK_MAX77686
+	tristate "Maxim 77686 32KHz crystal oscillator driver"
+	depends on MFD_MAX77686 && COMMON_CLK
+	---help---
+	  This driver supports for Maxim 77686's crystal oscillator.
+	  Maxim 77686 has three 32KHz buffered outputs and It can
+	  controls them over I2C bus.
 endmenu
+
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 1f736bc..a952555b 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -2,3 +2,5 @@
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
 				   clk-mux.o clk-divider.o
+
+obj-$(CONFIG_CLK_MAX77686)	+= clk-max77686.o
diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
new file mode 100644
index 0000000..fd3899e
--- /dev/null
+++ b/drivers/clk/clk-max77686.c
@@ -0,0 +1,192 @@
+/*
+ * clk-max77686.c - Clock driver for Maxim 77686
+ *
+ * Copyright (C) 2012 Samsung Electornics
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+#include <linux/clk-private.h>
+#include <linux/mutex.h>
+#include <linux/clkdev.h>
+
+#define	MAX77686_CLKS_NUM 3
+
+struct clk_max77686 {
+	struct max77686_dev *iodev;
+	u32 mask;
+	struct clk_hw hw;
+	struct clk_lookup *lookup;
+};
+
+static struct clk_max77686 *get_max77686_clk(struct clk_hw *hw)
+{
+	return container_of(hw, struct clk_max77686, hw);
+}
+
+static int max77686_clk_enable(struct clk_hw *hw)
+{
+	struct clk_max77686 *max77686;
+	int ret;
+
+	max77686 = get_max77686_clk(hw);
+	if (!max77686)
+		return -ENOMEM;
+
+	ret = regmap_update_bits(max77686->iodev->regmap,
+		MAX77686_REG_32KHZ, max77686->mask, max77686->mask);
+
+	return ret;
+}
+
+static void max77686_clk_disable(struct clk_hw *hw)
+{
+	struct clk_max77686 *max77686;
+
+	max77686 = get_max77686_clk(hw);
+	if (!max77686)
+		return;
+
+	regmap_update_bits(max77686->iodev->regmap,
+		MAX77686_REG_32KHZ, max77686->mask, ~max77686->mask);
+}
+
+static int max77686_clk_is_enabled(struct clk_hw *hw)
+{
+	struct clk_max77686 *max77686;
+	int ret;
+	u32 val;
+
+	max77686 = get_max77686_clk(hw);
+	if (!max77686)
+		return -ENOMEM;
+
+	ret = regmap_read(max77686->iodev->regmap,
+				MAX77686_REG_32KHZ, &val);
+
+	if (ret < 0)
+		return -EINVAL;
+
+	return val & max77686->mask;
+}
+
+static struct clk_ops clk_max77686_ops = {
+	.prepare	= max77686_clk_enable,
+	.unprepare	= max77686_clk_disable,
+	.is_enabled	= max77686_clk_is_enabled,
+};
+
+static int max77686_clk_register(struct device *dev,
+				struct clk_max77686 *max77686, int clk_id)
+{
+	char clk_name[][10] = {"32khap", "32kcp", "p32kh"};
+	struct clk *clk;
+
+	clk = clk_register(dev, clk_name[clk_id], &clk_max77686_ops,
+				&max77686->hw, NULL, 0, CLK_IS_ROOT);
+
+	if (IS_ERR(clk))
+		return -ENOMEM;
+
+	max77686->lookup = devm_kzalloc(dev, sizeof(struct clk_lookup),
+					GFP_KERNEL);
+	if (IS_ERR(max77686->lookup))
+		return -ENOMEM;
+
+	max77686->lookup->con_id = clk_name[clk_id];
+	max77686->lookup->clk = clk;
+
+	clkdev_add(max77686->lookup);
+
+	return 0;
+}
+
+static __devinit int max77686_clk_probe(struct platform_device *pdev)
+{
+	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct clk_max77686 *max77686[MAX77686_CLKS_NUM];
+	int i, ret;
+
+	for (i = 0; i < MAX77686_CLKS_NUM; i++) {
+		max77686[i] = devm_kzalloc(&pdev->dev,
+				 sizeof(struct clk_max77686), GFP_KERNEL);
+		if (!max77686[i])
+			return -ENOMEM;
+
+		max77686[i]->iodev = iodev;
+		max77686[i]->mask = 1 << i;
+
+		ret = max77686_clk_register(&pdev->dev, max77686[i], i);
+		if (ret) {
+			dev_err(&pdev->dev, "Fail to register clock\n");
+			return ret;
+		}
+	}
+
+	platform_set_drvdata(pdev, max77686);
+
+	return 0;
+}
+
+static int __devexit max77686_clk_remove(struct platform_device *pdev)
+{
+	struct clk_max77686 **max77686 = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < MAX77686_CLKS_NUM; i++) {
+		clkdev_drop(max77686[i]->lookup);
+		kfree(max77686[i]->hw.clk);
+	}
+	return 0;
+}
+
+static const struct platform_device_id max77686_clk_id[] = {
+	{ "max77686-clk", 0},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, max77686_clk_id);
+
+static struct platform_driver max77686_clk_driver = {
+	.driver = {
+		.name  = "max77686-clk",
+		.owner = THIS_MODULE,
+	},
+	.probe = max77686_clk_probe,
+	.remove = __devexit_p(max77686_clk_remove),
+	.id_table = max77686_clk_id,
+};
+
+static int __init max77686_clk_init(void)
+{
+	return platform_driver_register(&max77686_clk_driver);
+}
+subsys_initcall(max77686_clk_init);
+
+static void __init max77686_clk_cleanup(void)
+{
+	platform_driver_unregister(&max77686_clk_driver);
+}
+module_exit(max77686_clk_cleanup);
+
+MODULE_DESCRIPTION("MAXIM 77686 Clock Driver");
+MODULE_AUTHOR("Jonghwa Lee <jonghwa3.lee@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

