Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2EEFnE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 01:43:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:23025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab2EEFnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 01:43:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="137249408"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] max17042_battery: Fix power supply and irq registration ordering
Date: Sat,  5 May 2012 03:08:37 +0530
Message-Id: <1336167517-29092-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ registration should happen only after power supply object usable.
This patch fixes the ordering of power supply and irq registration
calls.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/max17042_battery.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 915767d..3c16724 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -691,6 +691,12 @@ static int __devinit max17042_probe(struct i2c_client *client,
 		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
 	}
 
+	ret = power_supply_register(&client->dev, &chip->battery);
+	if (ret) {
+		dev_err(&client->dev, "failed: power supply register\n");
+		return ret;
+	}
+
 	if (client->irq) {
 		ret = request_threaded_irq(client->irq, NULL,
 						max17042_thread_handler,
@@ -707,7 +713,6 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	}
 
 	reg = max17042_read_reg(chip->client, MAX17042_STATUS);
-
 	if (reg & STATUS_POR_BIT) {
 		INIT_WORK(&chip->work, max17042_init_worker);
 		schedule_work(&chip->work);
@@ -715,10 +720,7 @@ static int __devinit max17042_probe(struct i2c_client *client,
 		chip->init_complete = 1;
 	}
 
-	ret = power_supply_register(&client->dev, &chip->battery);
-	if (ret)
-		dev_err(&client->dev, "failed: power supply register\n");
-	return ret;
+	return 0;
 }
 
 static int __devexit max17042_remove(struct i2c_client *client)
-- 
1.7.0.4

