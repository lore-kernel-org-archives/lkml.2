Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2FAJJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:09:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34613 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2FAJJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:09:10 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-8f-4fc886b4df2a
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: H Hartley Sweeten <hsweetn@visionengravers.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] clock: max77686: Add driver for Maxim 77686 32KHz crystal
 oscillator
Date: Fri, 01 Jun 2012 18:08:56 +0900
Message-id: <1338541736-2978-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jQd0tbSf8DW5/MrS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZzy+zFRy0qth77AhLA+Msgy5GTg4JAROJ3h+HWSBsMYkL99az
	dTFycQgJTGeU+LjpOTOEs5JJoqljMSNIFZuAjsT/fTfZQWwRgUyJZ6efgcWZBV4ySrx65w9i
	CwuES0yYtJUZxGYRUJXYtKiVFcTmFXCX+DZlH9Q2BYkF996yTWDkXsDIsIpRNLUguaA4KT3X
	SK84Mbe4NC9dLzk/dxMj2IPPpHcwrmqwOMQowMGoxMPbUXvCX4g1say4MvcQowQHs5IIL8Ob
	4/5CvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZ8s2eEvJJCeWJKanZpakFoEk2Xi4JRqYFQyE9i2
	fPsm42/c/8//4Ttkp8nJvtDNfmN9rkye8fxAWUlGnuksEsX5rVcyeWZxTH+5I+PIvXAh+8u6
	IR9vqDg9Ob5ssaGB1+s1uf1RCtEiUdt+xXqG5j/47OKV0Hw1MbkpvpHlkc3fh/X50vKe4lGG
	T0Kvukv4MMjmmrC/i/0tUpeyvoBDiaU4I9FQi7moOBEAFauPQtwBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim 77686 has three 32KHz clock outputs through the its crystal oscillator.
This driver can control those ouputs by I2C bus. The clocks are used to supply
to SOC and peripheral chips as a clock source and can be enabled/disabled only.
It uses regmap interface to communicate with I2C bus.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/Kconfig        |    8 ++
 drivers/clk/Makefile       |    2 +
 drivers/clk/clk-max77686.c |  214 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 224 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-max77686.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 165e1fe..dda0e2e 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -45,3 +45,11 @@ config COMMON_CLK_DEBUG
 	  clk_notifier_count.
 
 endmenu
+
+config CLK_MAX77686
+	tristate "Maxim 77686 32KHz crystal oscillator driver"
+	depends on MFD_MAX77686
+	---help---
+	  This driver supports for Maxim 77686's crystal oscillator.
+	  Maxim 77686 has three 32KHz buffered outputs and It can
+	  controls them over I2C bus.
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
index 0000000..8c27cd6
--- /dev/null
+++ b/drivers/clk/clk-max77686.c
@@ -0,0 +1,214 @@
+/*
+ * clk-max77686.c - Clock driver for Maxim 77686
+ * 
+ * Copyright (C) 2012 Samsung Electornics
+ * Jonghwa Lee <jonghwa3.lee@samsung.com> 
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
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
+#ifdef COMMON_CONFIG_CLK
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+#include <linux/clk-private.h>
+
+#define to_max77686_clk(__name)		container_of(hw,		\
+					struct max77686_clk, __name)
+struct max77686_clk {
+	struct max77686_dev *iodev;
+	struct clk_hw clk32khz_ap_hw;
+	struct clk_hw clk32khz_cp_hw;
+	struct clk_hw clk32khz_pmic_hw;
+};
+
+static struct clk *clk32khz_ap;
+static struct clk *clk32khz_cp;
+static struct clk *clk32khz_pmic;
+static char *max77686_clk[] = {
+	"32khap",
+	"32khcp",
+	"p32kh",
+};
+
+static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
+{
+	struct clk *clk = hw->clk;
+	if (clk == clk32khz_ap)
+		return to_max77686_clk(clk32khz_ap_hw);
+	else if (clk == clk32khz_cp)
+		return to_max77686_clk(clk32khz_cp_hw);
+	else if (clk == clk32khz_pmic)
+		return to_max77686_clk(clk32khz_pmic_hw);
+	else
+		return NULL;
+}
+
+static int max77686_clk_get_mask(struct clk_hw *hw)
+{
+	struct clk *clk = hw->clk;
+	if (clk == clk32khz_ap)
+		return (1 << MAX77686_32KH_AP);
+	else if (clk == clk32khz_cp)
+		return (1 << MAX77686_32KH_CP);
+	else if (clk == clk32khz_pmic)
+		return  (1 << MAX77686_P32KH);
+	else
+		return 0;
+}
+
+static int max77686_clk_enable(struct clk_hw *hw)
+{
+	struct max77686_clk *max77686 = NULL;
+	int mask;
+
+	max77686 = get_max77686_clk(hw);
+	if (!max77686)
+		return -ENOMEM;
+	mask = max77686_clk_get_mask(hw);
+
+	return regmap_update_bits(max77686->iodev->regmap,
+				MAX77686_REG_32KHZ, mask, 1);
+}
+
+static void max77686_clk_disable(struct clk_hw *hw)
+{
+	struct max77686_clk *max77686 = NULL;
+	int mask;
+
+	max77686 = get_max77686_clk(hw);
+	if (!max77686)
+		return;
+	mask = max77686_clk_get_mask(hw);
+
+	regmap_update_bits(max77686->iodev->regmap,
+				MAX77686_REG_32KHZ, mask, 0);
+}
+
+static int max77686_clk_is_enabled(struct clk_hw *hw)
+{
+	struct max77686_clk *max77686 = NULL;
+	int mask, ret;
+	int val;
+
+	max77686 = get_max77686_clk(hw);
+	if (!max77686)
+		return -ENOMEM;
+	mask = max77686_clk_get_mask(hw);
+
+	ret = regmap_read(max77686->iodev->regmap,
+				MAX77686_REG_32KHZ, &val);
+	if (ret < 0)
+		return -EINVAL;
+
+	return val & mask;
+}
+
+static struct clk_ops max77686_clk_ops = {
+	.enable		= max77686_clk_enable,
+	.disable	= max77686_clk_disable,
+	.is_enabled	= max77686_clk_is_enabled,
+};
+
+
+static __devinit int max77686_clk_probe(struct platform_device *pdev)
+{
+	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max77686_clk *max77686;
+	int ret;
+
+	max77686 = devm_kzalloc(&pdev->dev, sizeof(struct max77686_clk),
+				GFP_KERNEL);
+	if (!max77686)
+		return -ENOMEM;
+
+	max77686->iodev = iodev;
+
+	clk32khz_ap = clk_register(&pdev->dev, max77686_clk[MAX77686_32KH_AP],
+				&max77686_clk_ops, &max77686->clk32khz_ap_hw,
+				NULL, 0, CLK_IS_ROOT);
+	if (IS_ERR(clk32khz_ap)) {
+		ret = PTR_ERR(clk32khz_ap);
+		goto err;
+	}
+
+	clk32khz_cp = clk_register(&pdev->dev, max77686_clk[MAX77686_32KH_CP],
+				&max77686_clk_ops, &max77686->clk32khz_cp_hw,
+				NULL, 0, CLK_IS_ROOT);
+	if (IS_ERR(clk32khz_cp)) {
+		ret = PTR_ERR(clk32khz_cp);
+		goto err;
+	}
+
+	clk32khz_pmic = clk_register(&pdev->dev, max77686_clk[MAX77686_P32KH],
+				&max77686_clk_ops, &max77686->clk32khz_pmic_hw,
+				NULL, 0, CLK_IS_ROOT);
+	if (IS_ERR(clk32khz_pmic)) {
+		ret = PTR_ERR(clk32khz_pmic);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	dev_err(&pdev->dev, "Fail to register clock\n");
+	return ret;
+}
+
+static int __devexit max77686_clk_remove(struct platform_device *pdev)
+{
+	kfree(clk32khz_ap);
+	kfree(clk32khz_cp);
+	kfree(clk32khz_pmic);
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
+#endif /* CONFIG_COMMON_CLK */
-- 
1.7.4.1

