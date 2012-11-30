Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2K3IxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:53:02 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:51084 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab2K3Iw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:52:59 -0500
Message-ID: <1354265569.3859.1.camel@phoenix>
Subject: [PATCH] regulator: tps51632: Ensure [base|max]_voltage_uV pdata
 settings are valid
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2012 16:52:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pdata->base_voltage_uV is missing or the settings of pdata->base_voltage_uV
and pdata->max_voltage_uV are out of range, TPS51632_VOLT_VSEL macro
returns wrong vsel.

Thus add checking [base|max]_voltage_uV pdata settings in probe.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps51632-regulator.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index 523b1e5..ab21133 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -236,6 +236,21 @@ static int tps51632_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
+	if (pdata->enable_pwm_dvfs) {
+		if ((pdata->base_voltage_uV < TPS51632_MIN_VOLATGE) ||
+		    (pdata->base_voltage_uV > TPS51632_MAX_VOLATGE)) {
+			dev_err(&client->dev, "Invalid base_voltage_uV setting\n");
+			return -EINVAL;
+		}
+
+		if ((pdata->max_voltage_uV) &&
+		    ((pdata->max_voltage_uV < TPS51632_MIN_VOLATGE) ||
+		     (pdata->max_voltage_uV > TPS51632_MAX_VOLATGE))) {
+			dev_err(&client->dev, "Invalid max_voltage_uV setting\n");
+			return -EINVAL;
+		}
+	}
+
 	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
 	if (!tps) {
 		dev_err(&client->dev, "Memory allocation failed\n");
-- 
1.7.9.5



