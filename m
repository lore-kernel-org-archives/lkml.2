Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab1LEX73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:59:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13095 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab1LEX71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:59:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 05 Dec 2011 15:59:20 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 5/5] power: sbs-battery: Change power supply name
Date: Mon,  5 Dec 2011 15:58:07 -0800
Message-Id: <1323129487-24859-5-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power supply name used to be fixed as "battery". This change allows
for multiple batteries by generating the name rather than using a fixed
value.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/sbs-battery.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index 761500c..9ee6903 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -150,6 +150,7 @@ struct sbs_info {
 	int				poll_time;
 	struct delayed_work		work;
 	int				ignore_changes;
+	char				*name;
 };
 
 static int sbs_read_word_data(struct i2c_client *client, u8 address)
@@ -681,15 +682,25 @@ static int __devinit sbs_probe(struct i2c_client *client,
 	struct sbs_platform_data *pdata = client->dev.platform_data;
 	int rc;
 	int irq;
+	char *name;
 
-	chip = kzalloc(sizeof(struct sbs_info), GFP_KERNEL);
-	if (!chip)
+	name = kasprintf(GFP_KERNEL, "%s-%s", "sbs", dev_name(&client->dev));
+	if (!name) {
+		dev_err(&client->dev, "Failed to allocate device name\n");
 		return -ENOMEM;
+	}
+
+	chip = kzalloc(sizeof(struct sbs_info), GFP_KERNEL);
+	if (!chip) {
+		rc = -ENOMEM;
+		goto exit_free_name;
+	}
 
 	chip->client = client;
 	chip->enable_detection = false;
 	chip->gpio_detect = false;
-	chip->power_supply.name = "battery";
+	chip->name = name;
+	chip->power_supply.name = name;
 	chip->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
 	chip->power_supply.properties = sbs_properties;
 	chip->power_supply.num_properties = ARRAY_SIZE(sbs_properties);
@@ -774,6 +785,9 @@ exit_psupply:
 
 	kfree(chip);
 
+exit_free_name:
+	kfree(name);
+
 	return rc;
 }
 
@@ -790,6 +804,7 @@ static int __devexit sbs_remove(struct i2c_client *client)
 
 	cancel_delayed_work_sync(&chip->work);
 
+	kfree(chip->name);
 	kfree(chip);
 	chip = NULL;
 
-- 
1.7.0.4

