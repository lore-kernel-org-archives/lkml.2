Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1FVQRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:17:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38527 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab1FVQRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:17:01 -0400
Subject: [PATCH] i2c: Tegra: Add DeviceTree support
To: kradtke@nvidia.com, swarren@nvidia.com, lucas.demarchi@profusion.mobi,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, riyer@nvidia.com, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, khali@linux-fr.org
From: John Bonesio <bones@secretlab.ca>
Date: Wed, 22 Jun 2011 09:16:56 -0700
Message-ID: <20110622161656.30052.33366.stgit@riker>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the tegra i2c driver so that it can be initiailized
using the device tree along with the devices connected to the i2c bus.

Signed-off-by: John Bonesio <bones@secretlab.ca>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: OIof Johansson <olof@lixom.net>
---

 drivers/i2c/busses/i2c-tegra.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 4d93196..d2393e6 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/i2c-tegra.h>
+#include <linux/of_i2c.h>
 
 #include <asm/unaligned.h>
 
@@ -540,6 +541,7 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	struct resource *iomem;
 	struct clk *clk;
 	struct clk *i2c_clk;
+	const unsigned int *prop;
 	void *base;
 	int irq;
 	int ret = 0;
@@ -597,7 +599,17 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	i2c_dev->irq = irq;
 	i2c_dev->cont_id = pdev->id;
 	i2c_dev->dev = &pdev->dev;
-	i2c_dev->bus_clk_rate = pdata ? pdata->bus_clk_rate : 100000;
+
+	i2c_dev->bus_clk_rate = 100000; /* default clock rate */
+	if (pdata) {
+		i2c_dev->bus_clk_rate = pdata->bus_clk_rate;
+
+	} else if (i2c_dev->dev->of_node) {    /* if there is a device tree node ... */
+		prop = of_get_property(i2c_dev->dev->of_node,
+				"clock-frequency", NULL);
+		if (prop)
+			i2c_dev->bus_clk_rate = be32_to_cpup(prop);
+	}
 
 	if (pdev->id == 3)
 		i2c_dev->is_dvc = 1;
@@ -627,6 +639,7 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	i2c_dev->adapter.algo = &tegra_i2c_algo;
 	i2c_dev->adapter.dev.parent = &pdev->dev;
 	i2c_dev->adapter.nr = pdev->id;
+	i2c_dev->adapter.dev.of_node = pdev->dev.of_node;
 
 	ret = i2c_add_numbered_adapter(&i2c_dev->adapter);
 	if (ret) {
@@ -634,6 +647,8 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
+	of_i2c_register_devices(&i2c_dev->adapter);
+
 	return 0;
 err_free_irq:
 	free_irq(i2c_dev->irq, i2c_dev);

