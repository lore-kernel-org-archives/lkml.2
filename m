Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab1LFBwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:52:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8992 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab1LFBwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:52:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 05 Dec 2011 17:52:02 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 5/5 v2] power: sbs-battery: Change power supply name
Date: Mon,  5 Dec 2011 17:50:49 -0800
Message-Id: <1323136249-4134-5-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323136249-4134-1-git-send-email-rklein@nvidia.com>
References: <1323136249-4134-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power supply name used to be fixed as "battery". This change allows
for multiple batteries by generating the name rather than using a fixed
value.

v2: simplified kasprintf and cleaned up unneeded member of sbs_info.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/sbs-battery.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index 00bd9e0..b677b88 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -682,15 +682,24 @@ static int __devinit sbs_probe(struct i2c_client *client,
 	struct sbs_platform_data *pdata = client->dev.platform_data;
 	int rc;
 	int irq;
+	char *name;
 
-	chip = kzalloc(sizeof(struct sbs_info), GFP_KERNEL);
-	if (!chip)
+	name = kasprintf(GFP_KERNEL, "sbs-%s", dev_name(&client->dev));
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
+	chip->power_supply.name = name;
 	chip->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
 	chip->power_supply.properties = sbs_properties;
 	chip->power_supply.num_properties = ARRAY_SIZE(sbs_properties);
@@ -775,6 +784,9 @@ exit_psupply:
 
 	kfree(chip);
 
+exit_free_name:
+	kfree(name);
+
 	return rc;
 }
 
@@ -791,6 +803,7 @@ static int __devexit sbs_remove(struct i2c_client *client)
 
 	cancel_delayed_work_sync(&chip->work);
 
+	kfree(chip->power_supply.name);
 	kfree(chip);
 	chip = NULL;
 
-- 
1.7.0.4

