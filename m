Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1K0MIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:08:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45353 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1K0MIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:08:14 -0500
Message-ID: <1322395677.2799.1.camel@phoenix>
Subject: [PATCH v2] regulator: Avoid potential NULL dereference in
 reg_fixed_voltage_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 27 Nov 2011 20:07:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_fixed_voltage_config() may return NULL, return -ENOMEM in this case
so we don't dereference NULL pointer.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/fixed.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 6828dce..72abbf5 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -163,12 +163,17 @@ static struct regulator_ops fixed_voltage_ops = {
 
 static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 {
-	struct fixed_voltage_config *config = pdev->dev.platform_data;
+	struct fixed_voltage_config *config;
 	struct fixed_voltage_data *drvdata;
 	int ret;
 
 	if (pdev->dev.of_node)
 		config = of_get_fixed_voltage_config(&pdev->dev);
+	else
+		config = pdev->dev.platform_data;
+
+	if (!config)
+		return -ENOMEM;
 
 	drvdata = kzalloc(sizeof(struct fixed_voltage_data), GFP_KERNEL);
 	if (drvdata == NULL) {
-- 
1.7.5.4



