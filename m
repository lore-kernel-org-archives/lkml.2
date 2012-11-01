Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab2KAPxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:53:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64702 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936020Ab2KAPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:53:52 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: swarren@wwwdotorg.org
Cc: digetx@gmail.com, linus.walleij@linaro.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: tegra: add suspend/resume support
Date: Thu,  1 Nov 2012 19:53:06 +0400
Message-Id: <1351785186-11431-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added suspend/resume pm ops. We need to store current regs vals on suspend and
restore them on resume.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
Tested on my tablet.

 drivers/pinctrl/pinctrl-tegra.c | 94 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 91 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 7da0b37..03a3afb 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -41,6 +41,11 @@ struct tegra_pmx {
 
 	int nbanks;
 	void __iomem **regs;
+
+	int *bank_size;
+#ifdef CONFIG_PM_SLEEP
+	u32 *regs_store;
+#endif
 };
 
 static inline u32 pmx_readl(struct tegra_pmx *pmx, u32 bank, u32 reg)
@@ -685,11 +690,72 @@ static struct pinctrl_desc tegra_pinctrl_desc = {
 	.owner = THIS_MODULE,
 };
 
+#ifdef CONFIG_PM_SLEEP
+static int tegra_pinctrl_suspend_noirq(struct device *dev)
+{
+	struct tegra_pmx *pmx = dev_get_drvdata(dev);
+	int store_offset = 0;
+	int i, reg;
+	u32 val;
+
+	if (!pmx)
+		return -ENOMEM;
+
+	for (i = 0; i < pmx->nbanks; i++) {
+
+		for (reg = 0; reg < pmx->bank_size[i]; reg += 4) {
+			val = pmx_readl(pmx, i, reg);
+			pmx->regs_store[store_offset] = val;
+			store_offset++;
+
+			dev_dbg(dev, "stored val: 0x%x bank: %d reg: 0x%x\n",
+				val, i, reg);
+		}
+	}
+
+	return 0;
+}
+
+static int tegra_pinctrl_resume_noirq(struct device *dev)
+{
+	struct tegra_pmx *pmx = dev_get_drvdata(dev);
+	int store_offset = 0;
+	int i, reg;
+	u32 val;
+
+	if (!pmx)
+		return -ENOMEM;
+
+	for (i = 0; i < pmx->nbanks; i++) {
+
+		for (reg = 0; reg < pmx->bank_size[i]; reg += 4) {
+			val = pmx->regs_store[store_offset];
+			pmx_writel(pmx, val, i, reg);
+			store_offset++;
+
+			dev_dbg(dev, "restored val: 0x%x bank: %d reg: 0x%x\n",
+				val, i, reg);
+		}
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops tegra_pinctrl_pm_ops = {
+	.suspend_noirq = tegra_pinctrl_suspend_noirq,
+	.resume_noirq = tegra_pinctrl_resume_noirq,
+};
+#define TEGRA_PINCTRL_PM	(&tegra_pinctrl_pm_ops)
+#else
+#define TEGRA_PINCTRL_PM	NULL
+#endif
+
 int __devinit tegra_pinctrl_probe(struct platform_device *pdev,
 			const struct tegra_pinctrl_soc_data *soc_data)
 {
 	struct tegra_pmx *pmx;
 	struct resource *res;
+	int nregs = 0;
 	int i;
 
 	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
@@ -712,6 +778,13 @@ int __devinit tegra_pinctrl_probe(struct platform_device *pdev,
 	}
 	pmx->nbanks = i;
 
+	pmx->bank_size = devm_kzalloc(&pdev->dev, pmx->nbanks * sizeof(int),
+				      GFP_KERNEL);
+	if (!pmx->bank_size) {
+		dev_err(&pdev->dev, "Can't alloc banks sizes pointer\n");
+		return -ENODEV;
+	}
+
 	pmx->regs = devm_kzalloc(&pdev->dev, pmx->nbanks * sizeof(*pmx->regs),
 				 GFP_KERNEL);
 	if (!pmx->regs) {
@@ -726,22 +799,35 @@ int __devinit tegra_pinctrl_probe(struct platform_device *pdev,
 			return -ENODEV;
 		}
 
+		pmx->bank_size[i] = resource_size(res);
+
 		if (!devm_request_mem_region(&pdev->dev, res->start,
-					    resource_size(res),
-					    dev_name(&pdev->dev))) {
+					     pmx->bank_size[i],
+					     dev_name(&pdev->dev))) {
 			dev_err(&pdev->dev,
 				"Couldn't request MEM resource %d\n", i);
 			return -ENODEV;
 		}
 
 		pmx->regs[i] = devm_ioremap(&pdev->dev, res->start,
-					    resource_size(res));
+					    pmx->bank_size[i]);
 		if (!pmx->regs[i]) {
 			dev_err(&pdev->dev, "Couldn't ioremap regs %d\n", i);
 			return -ENODEV;
 		}
+
+		nregs += pmx->bank_size[i] / 4;
 	}
 
+#ifdef CONFIG_PM_SLEEP
+	pmx->regs_store = devm_kzalloc(&pdev->dev, nregs * sizeof(u32),
+				       GFP_KERNEL);
+	if (!pmx->regs_store) {
+		dev_err(&pdev->dev, "Can't alloc regs store pointer\n");
+		return -ENODEV;
+	}
+#endif
+
 	pmx->pctl = pinctrl_register(&tegra_pinctrl_desc, &pdev->dev, pmx);
 	if (!pmx->pctl) {
 		dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
@@ -752,6 +838,8 @@ int __devinit tegra_pinctrl_probe(struct platform_device *pdev,
 
 	platform_set_drvdata(pdev, pmx);
 
+	pdev->dev.driver->pm = TEGRA_PINCTRL_PM;
+
 	dev_dbg(&pdev->dev, "Probed Tegra pinctrl driver\n");
 
 	return 0;
-- 
1.7.12

