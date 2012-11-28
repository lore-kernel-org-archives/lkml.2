Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab2K1CGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:06:01 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:56272 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab2K1CGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:06:00 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rpurdie@rpsys.net, FlorianSchandinat@gmx.de,
        haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2 6/7] mfd: max8925: support dt for backlight
Date: Wed, 28 Nov 2012 10:06:45 +0800
Message-Id: <1354068405-9779-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 28 Nov 2012 02:05:18.0074 (UTC) FILETIME=[D03F8DA0:01CDCD0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/video/backlight/max8925_bl.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index f72ba54..1682d00 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -101,6 +101,29 @@ static const struct backlight_ops max8925_backlight_ops = {
 	.get_brightness	= max8925_backlight_get_brightness,
 };
 
+#ifdef CONFIG_OF
+static int max8925_backlight_dt_init(struct platform_device *pdev,
+			      struct max8925_backlight_pdata *pdata)
+{
+	struct device_node *nproot = pdev->dev.parent->of_node, *np;
+	int dual_string;
+
+	if (!nproot)
+		return -ENODEV;
+	np = of_find_node_by_name(nproot, "backlight");
+	if (!np) {
+		dev_err(&pdev->dev, "failed to find backlight node\n");
+		return -ENODEV;
+	}
+
+	of_property_read_u32(np, "max8925-dual-string", &dual_string);
+	pdata->dual_string = dual_string;
+	return 0;
+}
+#else
+#define max8925_backlight_dt_init(x, y)	(-1)
+#endif
+
 static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
@@ -150,6 +173,13 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bl);
 
 	value = 0;
+	if (pdev->dev.parent->of_node && !pdata) {
+		pdata = devm_kzalloc(&pdev->dev,
+				     sizeof(struct max8925_backlight_pdata),
+				     GFP_KERNEL);
+		max8925_backlight_dt_init(pdev, pdata);
+	}
+
 	if (pdata) {
 		if (pdata->lxw_scl)
 			value |= (1 << 7);
@@ -161,7 +191,6 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 	ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 0xfe, value);
 	if (ret < 0)
 		goto out_brt;
-
 	backlight_update_status(bl);
 	return 0;
 out_brt:
-- 
1.7.0.4

