Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2FKHfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:35:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37692 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab2FKHfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:35:43 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-8c-4fd59fcaf879
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] clock: max77686: Add driver for Maxim 77686 32KHz crystal
 oscillator
Date: Mon, 11 Jun 2012 16:35:31 +0900
Message-id: <1339400131-28980-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQd3T86/6G+yexGRxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyvrTeYixoMK+43rqWsYFxhW4XIyeHhICJxJqHO9ggbDGJC/fW
	A9lcHEIC0xklevc+YIVwVjJJ9Gy/zw5SxSagI/F/300wW0QgU+LZ6WeMIEXMAi8YJWZPm8wE
	khAWiJLY/rKFEcRmEVCVeLvsO1icV8BD4tPV1awQ6xQkFtx7yzaBkXsBI8MqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjGAvPpPawbiyweIQowAHoxIP74FJV/2FWBPLiitzDzFKcDArifBu
	qwAK8aYkVlalFuXHF5XmpBYfYpTmYFES522yvuAvJJCeWJKanZpakFoEk2Xi4JRqYJSNut11
	ZHdFoPOXNJPrc0QeeGs0hye0qaomMrZdfng2Y/XXSBP2d5buZ6tjOCcy5VTXaE0yrdor8EDp
	3Y5eCR6easfmT85Ob1mjyzPsTp1KnLrHddnfa/KGPlf//XT+Kfp+K1PjcSH5c59eer/8UKG1
	ie3lz3eV0/7OTbrG3uwf4Jc7uXfbbiWW4oxEQy3mouJEALejnxjeAQAA
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
v2
 - Modify Kconfig symbol to depend on COMMON_CLK and MFD_MAX77686
 - Fix max77686_clk structure and get_max77686_clk fuction to remove obscure points.
 
 drivers/clk/Kconfig        |    8 ++
 drivers/clk/Makefile       |    2 +
 drivers/clk/clk-max77686.c |  196 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 206 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-max77686.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 165e1fe..3f63330 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -45,3 +45,11 @@ config COMMON_CLK_DEBUG
 	  clk_notifier_count.
 
 endmenu
+
+config CLK_MAX77686
+	tristate "Maxim 77686 32KHz crystal oscillator driver"
+	depends on MFD_MAX77686 && COMMON_CLK
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
index 0000000..1e76d58
--- /dev/null
+++ b/drivers/clk/clk-max77686.c
@@ -0,0 +1,196 @@
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
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+#include <linux/clk-private.h>
+
+enum {
+	MAX77686_32KH_AP,
+	MAX77686_32KH_CP,
+	MAX77686_P32KH,
+	MAX77686_CLKS_NUM,
+};
+
+struct max77686_clk {
+	struct max77686_dev *iodev;
+	u32 mask;
+	struct clk_hw hw;
+};
+
+struct clk *clk32khz_ap;
+struct clk *clk32khz_cp;
+struct clk *clk32khz_pmic;
+char *max77686_clks[] = {
+	"32khap",
+	"32khcp",
+	"p32kh",
+};
+
+static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
+{
+	return container_of(hw, struct max77686_clk, hw);
+}
+
+static int max77686_clk_enable(struct clk_hw *hw)
+{
+	struct max77686_clk *max77686 = NULL;
+
+	max77686 = get_max77686_clk(hw);
+	if (!max77686)
+		return -ENOMEM;
+
+	return regmap_update_bits(max77686->iodev->regmap,
+		MAX77686_REG_32KHZ, max77686->mask, max77686->mask);
+}
+
+static void max77686_clk_disable(struct clk_hw *hw)
+{
+	struct max77686_clk *max77686 = NULL;
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
+	struct max77686_clk *max77686 = NULL;
+	int ret;
+	u32 val;
+
+	max77686 = get_max77686_clk(hw);
+	if (!max77686)
+		return -ENOMEM;
+
+	ret = regmap_read(max77686->iodev->regmap,
+				MAX77686_REG_32KHZ, &val);
+	if (ret < 0)
+		return -EINVAL;
+
+	return val & max77686->mask;
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
+	struct max77686_clk *max77686[MAX77686_CLKS_NUM];
+	int i, ret;
+
+	for ( i = 0; i < MAX77686_CLKS_NUM; i++) {
+		max77686[i] = devm_kzalloc(&pdev->dev,
+				 sizeof(struct max77686_clk), GFP_KERNEL);
+		if (!max77686[i])
+			return -ENOMEM;
+
+		max77686[i]->iodev = iodev;
+		max77686[i]->mask = 1 << i;
+	}
+
+
+	clk32khz_ap = clk_register(&pdev->dev, max77686_clks[MAX77686_32KH_AP],
+				&max77686_clk_ops,
+				&max77686[MAX77686_32KH_AP]->hw,
+				NULL, 0, CLK_IS_ROOT);
+	if (IS_ERR(clk32khz_ap)) {
+		ret = PTR_ERR(clk32khz_ap);
+		goto err;
+	}
+
+	clk32khz_cp = clk_register(&pdev->dev, max77686_clks[MAX77686_32KH_CP],
+				&max77686_clk_ops,
+				&max77686[MAX77686_32KH_CP]->hw,
+				NULL, 0, CLK_IS_ROOT);
+	if (IS_ERR(clk32khz_cp)) {
+		ret = PTR_ERR(clk32khz_cp);
+		goto err;
+	}
+
+	clk32khz_pmic = clk_register(&pdev->dev, max77686_clks[MAX77686_P32KH],
+				&max77686_clk_ops,
+				&max77686[MAX77686_P32KH]->hw,
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
-- 
1.7.4.1

