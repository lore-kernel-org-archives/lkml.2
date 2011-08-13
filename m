Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab1HMES2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 00:18:28 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:58168 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab1HMES0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 00:18:26 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Date: Fri, 12 Aug 2011 21:18:18 -0700
Subject: [PATCH] power: max17042: divide by 0 Crash because r_sns init too
 late
Thread-Topic: [PATCH] power: max17042: divide by 0 Crash because r_sns init
 too late
Thread-Index: AcxZcAerCYz5f7n2RLOstgP1bww6Yw==
Message-ID: <019FE779-4090-404F-9CE0-A2966384F14C@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On MMP2 brownstone divide by 0 error since probe sets r_sns
after calling power_supply_register.

Move the code up a few lines.  r_sns comes from the platform
data.

PROP_CURRENT_AVG and PROP_CURRENT divide the result by r_sns.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/power/max17042_battery.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 9f0183c..4245806 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -210,6 +210,9 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	if (!chip->pdata->enable_current_sense)
 		chip->battery.num_properties -= 2;
 
+	if (chip->pdata->r_sns == 0)
+		chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
+
 	ret = power_supply_register(&client->dev, &chip->battery);
 	if (ret) {
 		dev_err(&client->dev, "failed: power supply register\n");
@@ -226,9 +229,6 @@ static int __devinit max17042_probe(struct i2c_client *client,
 		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
 		max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
 		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
-	} else {
-		if (chip->pdata->r_sns == 0)
-			chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
 	}
 
 	return 0;
-- 
1.7.0.4


