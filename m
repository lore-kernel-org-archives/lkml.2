Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0LJKLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:11:10 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:59656 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671Ab0LJKLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:11:06 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 4/9] regulators: Added ab8500 v2 support
Date: Fri, 10 Dec 2010 11:08:43 +0100
Message-ID: <1291975728-12525-5-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AUX3 regulator voltage setting is changed in ab8500 v2 compared
to ab8500 v1. This patch adds v2 support while keeping support for
v1.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/ab8500.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 51ff569..9a3dc79 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -81,6 +81,17 @@ static const int ldo_vauxn_voltages[] = {
 	3300000,
 };
 
+static const int ldo_vaux3_voltages[] = {
+	1200000,
+	1500000,
+	1800000,
+	2100000,
+	2500000,
+	2750000,
+	2790000,
+	2910000,
+};
+
 static const int ldo_vintcore_voltages[] = {
 	1200000,
 	1225000,
@@ -326,8 +337,8 @@ static struct ab8500_regulator_info ab8500_regulator_info[] = {
 			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
 	AB8500_LDO(AUX2, 1100, 3300, 0x04, 0x09, 0xc, 0x4, 0x04, 0x20, 0xf,
 			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(AUX3, 1100, 3300, 0x04, 0x0a, 0x3, 0x1, 0x04, 0x21, 0xf,
-			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
+	AB8500_LDO(AUX3, 1100, 3300, 0x04, 0x0a, 0x3, 0x1, 0x04, 0x21, 0x7,
+			ldo_vaux3_voltages, ARRAY_SIZE(ldo_vaux3_voltages)),
 	AB8500_LDO(INTCORE, 1100, 3300, 0x03, 0x80, 0x44, 0x4, 0x03, 0x80, 0x38,
 		ldo_vintcore_voltages, ARRAY_SIZE(ldo_vintcore_voltages)),
 
@@ -369,6 +380,19 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 		info = &ab8500_regulator_info[i];
 		info->dev = &pdev->dev;
 
+		/* fix for hardware before ab8500v2.0 */
+		if (abx500_get_chip_id(info->dev) < 0x20) {
+			if (info->desc.id == AB8500_LDO_AUX3) {
+				info->desc.n_voltages =
+					ARRAY_SIZE(ldo_vauxn_voltages);
+				info->supported_voltages = ldo_vauxn_voltages;
+				info->voltages_len =
+					ARRAY_SIZE(ldo_vauxn_voltages);
+				info->voltage_mask = 0xf;
+			}
+		}
+
+		/* register regulator with framework */
 		info->regulator = regulator_register(&info->desc, &pdev->dev,
 				&pdata->regulator[i], info);
 		if (IS_ERR(info->regulator)) {
-- 
1.7.2.2

