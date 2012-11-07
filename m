Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2KGHHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:07:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54031 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab2KGHHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:07:45 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH RESEND 5/7] MFD: ti_am335x_tscadc: Add DT support
Date: Wed, 7 Nov 2012 12:22:02 +0530
Message-ID: <1352271124-5513-6-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352271124-5513-1-git-send-email-rachna@ti.com>
References: <1352271124-5513-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make changes to add DT support in the MFD core driver.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/mfd/ti_am335x_tscadc.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 8ca3bf0..07b7788 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -22,6 +22,8 @@
 #include <linux/regmap.h>
 #include <linux/mfd/core.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
 #include <linux/input/ti_am335x_tsc.h>
@@ -64,20 +66,31 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	struct resource		*res;
 	struct clk		*clk;
 	struct mfd_tscadc_board	*pdata = pdev->dev.platform_data;
+	struct device_node	*node = pdev->dev.of_node;
 	struct mfd_cell		*cell;
 	int			err, ctrl;
 	int			clk_value, clock_rate;
-	int			tsc_wires, adc_channels = 0, total_channels;
+	int			tsc_wires = 0, adc_channels = 0, total_channels;
 
-	if (!pdata) {
+	if (!pdata && !pdev->dev.of_node) {
 		dev_err(&pdev->dev, "Could not find platform data\n");
 		return -EINVAL;
 	}
 
-	if (pdata->adc_init)
-		adc_channels = pdata->adc_init->adc_channels;
+	if (pdev->dev.of_node) {
+		node = of_find_node_by_name(pdev->dev.of_node, "tsc");
+		of_property_read_u32(node, "wires", &tsc_wires);
+
+		node = of_find_node_by_name(pdev->dev.of_node, "adc");
+		of_property_read_u32(node, "adc-channels", &adc_channels);
+	} else {
+		if (pdata->tsc_init)
+			tsc_wires = pdata->tsc_init->wires;
+
+		if (pdata->adc_init)
+			adc_channels = pdata->adc_init->adc_channels;
+	}
 
-	tsc_wires = pdata->tsc_init->wires;
 	total_channels = tsc_wires + adc_channels;
 
 	if (total_channels > 8) {
@@ -256,11 +269,16 @@ static const struct dev_pm_ops tscadc_pm_ops = {
 #define TSCADC_PM_OPS NULL
 #endif
 
+static const struct of_device_id ti_tscadc_dt_ids[] = {
+	{ .compatible = "ti,ti-tscadc", },
+};
+
 static struct platform_driver ti_tscadc_driver = {
 	.driver = {
 		.name   = "ti_tscadc",
 		.owner	= THIS_MODULE,
 		.pm	= TSCADC_PM_OPS,
+		.of_match_table = of_match_ptr(ti_tscadc_dt_ids),
 	},
 	.probe	= ti_tscadc_probe,
 	.remove	= __devexit_p(ti_tscadc_remove),
-- 
1.7.0.4

