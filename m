Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2KFHqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:46:49 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:60078 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816Ab2KFHqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:46:48 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, rpurdie@rpsys.net, FlorianSchandinat@gmx.de,
        sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 6/7] mfd: max8925: support dt for backlight
Date: Tue,  6 Nov 2012 15:47:14 +0800
Message-Id: <1352188034-9982-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 06 Nov 2012 07:46:35.0323 (UTC) FILETIME=[D88D48B0:01CDBBF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/video/backlight/max8925_bl.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index f72ba54..7de02ed 100644
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
+	of_property_read_u32(np, "dual-string", &dual_string);
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

