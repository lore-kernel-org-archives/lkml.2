Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1GYVUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:20:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34667 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752505Ab1GYVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:20:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/6] regulator: Fix WM831x regulator ID lookups for multiple WM831xs
Date: Mon, 25 Jul 2011 22:20:29 +0100
Message-Id: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With multiple wm831x devices the device IDs used for the regulators will
not always be contiguous so simply taking the modulus is not sufficient
to look up the ID, we need to reverse the way the ID is generated.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |   16 ++++++++++++++--
 drivers/regulator/wm831x-ldo.c  |   25 ++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index a0982e8..0c7a9d5 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -504,11 +504,17 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
+	int id;
 	struct wm831x_dcdc *dcdc;
 	struct resource *res;
 	int ret, irq;
 
+	if (pdata && pdata->wm831x_num)
+		id = (pdata->wm831x_num * 10) + 1;
+	else
+		id = 0;
+	id = pdev->id - id;
+
 	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
 
 	if (pdata == NULL || pdata->dcdc[id] == NULL)
@@ -709,11 +715,17 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
+	int id;
 	struct wm831x_dcdc *dcdc;
 	struct resource *res;
 	int ret, irq;
 
+	if (pdata && pdata->wm831x_num)
+		id = (pdata->wm831x_num * 10) + 1;
+	else
+		id = 0;
+	id = pdev->id - id;
+
 	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
 
 	if (pdata == NULL || pdata->dcdc[id] == NULL)
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 2220cf8..6709710 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -310,11 +310,17 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
+	int id;
 	struct wm831x_ldo *ldo;
 	struct resource *res;
 	int ret, irq;
 
+	if (pdata && pdata->wm831x_num)
+		id = (pdata->wm831x_num * 10) + 1;
+	else
+		id = 0;
+	id = pdev->id - id;
+
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	if (pdata == NULL || pdata->ldo[id] == NULL)
@@ -574,11 +580,17 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
+	int id;
 	struct wm831x_ldo *ldo;
 	struct resource *res;
 	int ret, irq;
 
+	if (pdata && pdata->wm831x_num)
+		id = (pdata->wm831x_num * 10) + 1;
+	else
+		id = 0;
+	id = pdev->id - id;
+
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	if (pdata == NULL || pdata->ldo[id] == NULL)
@@ -764,11 +776,18 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
+	int id;
 	struct wm831x_ldo *ldo;
 	struct resource *res;
 	int ret;
 
+	if (pdata && pdata->wm831x_num)
+		id = (pdata->wm831x_num * 10) + 1;
+	else
+		id = 0;
+	id = pdev->id - id;
+
+
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	if (pdata == NULL || pdata->ldo[id] == NULL)
-- 
1.7.5.4

