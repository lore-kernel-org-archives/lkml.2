Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3ADLDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:03:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16179 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3ADLCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:02:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Jan 2013 03:02:34 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dmitry.torokhov@gmail.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/4] input: keyboard: tegra: use devm_* for resource allocation
Date: Fri, 4 Jan 2013 16:32:08 +0530
Message-ID: <1357297330-28878-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357297330-28878-1-git-send-email-ldewangan@nvidia.com>
References: <1357297330-28878-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* for memory, clock, input device allocation. This reduces
code for freeing these resources.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/input/keyboard/tegra-kbc.c |   93 +++++++++++-------------------------
 1 files changed, 28 insertions(+), 65 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index f1d3ba0..c036425 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -618,7 +618,7 @@ static struct tegra_kbc_platform_data *tegra_kbc_dt_parse_pdata(
 	if (!np)
 		return NULL;
 
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return NULL;
 
@@ -700,33 +700,36 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	if (!pdata)
 		pdata = tegra_kbc_dt_parse_pdata(pdev);
 
-	if (!pdata)
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data missing\n");
 		return -EINVAL;
-
-	if (!tegra_kbc_check_pin_cfg(pdata, &pdev->dev, &num_rows)) {
-		err = -EINVAL;
-		goto err_free_pdata;
 	}
 
+	if (!tegra_kbc_check_pin_cfg(pdata, &pdev->dev, &num_rows))
+		return -EINVAL;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get I/O memory\n");
-		err = -ENXIO;
-		goto err_free_pdata;
+		return -ENXIO;
 	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "failed to get keyboard IRQ\n");
-		err = -ENXIO;
-		goto err_free_pdata;
+		return -ENXIO;
+	}
+
+	kbc = devm_kzalloc(&pdev->dev, sizeof(*kbc), GFP_KERNEL);
+	if (!kbc) {
+		dev_err(&pdev->dev, "failed to alloc memory for kbc\n");
+		return -ENOMEM;
 	}
 
-	kbc = kzalloc(sizeof(*kbc), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!kbc || !input_dev) {
-		err = -ENOMEM;
-		goto err_free_mem;
+	input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!input_dev) {
+		dev_err(&pdev->dev, "failed to allocate input device\n");
+		return -ENOMEM;
 	}
 
 	kbc->pdata = pdata;
@@ -735,25 +738,16 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	spin_lock_init(&kbc->lock);
 	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
 
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		err = -EBUSY;
-		goto err_free_mem;
-	}
-
-	kbc->mmio = ioremap(res->start, resource_size(res));
+	kbc->mmio = devm_request_and_ioremap(&pdev->dev, res);
 	if (!kbc->mmio) {
-		dev_err(&pdev->dev, "failed to remap I/O memory\n");
-		err = -ENXIO;
-		goto err_free_mem_region;
+		dev_err(&pdev->dev, "Cannot request memregion/iomap address\n");
+		return -EADDRNOTAVAIL;
 	}
 
-	kbc->clk = clk_get(&pdev->dev, NULL);
+	kbc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(kbc->clk)) {
 		dev_err(&pdev->dev, "failed to get keyboard clock\n");
-		err = PTR_ERR(kbc->clk);
-		goto err_iounmap;
+		return PTR_ERR(kbc->clk);
 	}
 
 	/*
@@ -778,9 +772,9 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	input_dev->close = tegra_kbc_close;
 
 	err = tegra_kbd_setup_keymap(kbc);
-	if (err) {
+	if (err < 0) {
 		dev_err(&pdev->dev, "failed to setup keymap\n");
-		goto err_put_clk;
+		return err;
 	}
 
 	__set_bit(EV_REP, input_dev->evbit);
@@ -790,15 +784,15 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 
 	err = request_irq(kbc->irq, tegra_kbc_isr,
 			  IRQF_NO_SUSPEND | IRQF_TRIGGER_HIGH, pdev->name, kbc);
-	if (err) {
+	if (err < 0) {
 		dev_err(&pdev->dev, "failed to request keyboard IRQ\n");
-		goto err_put_clk;
+		return err;
 	}
 
 	disable_irq(kbc->irq);
 
 	err = input_register_device(kbc->idev);
-	if (err) {
+	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register input device\n");
 		goto err_free_irq;
 	}
@@ -810,46 +804,15 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 
 err_free_irq:
 	free_irq(kbc->irq, pdev);
-err_put_clk:
-	clk_put(kbc->clk);
-err_iounmap:
-	iounmap(kbc->mmio);
-err_free_mem_region:
-	release_mem_region(res->start, resource_size(res));
-err_free_mem:
-	input_free_device(input_dev);
-	kfree(kbc);
-err_free_pdata:
-	if (!pdev->dev.platform_data)
-		kfree(pdata);
-
 	return err;
 }
 
 static int tegra_kbc_remove(struct platform_device *pdev)
 {
 	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
-	struct resource *res;
-
-	platform_set_drvdata(pdev, NULL);
 
 	free_irq(kbc->irq, pdev);
-	clk_put(kbc->clk);
-
 	input_unregister_device(kbc->idev);
-	iounmap(kbc->mmio);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	/*
-	 * If we do not have platform data attached to the device we
-	 * allocated it ourselves and thus need to free it.
-	 */
-	if (!pdev->dev.platform_data)
-		kfree(kbc->pdata);
-
-	kfree(kbc);
-
 	return 0;
 }
 
-- 
1.7.1.1

