Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1BXJUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:20:51 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:38501 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab1BXJUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:20:49 -0500
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
Cc: error27@gmail.com, grant.likely@secretlab.ca,
        Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH v3] gpio: Fix wrong pointer type in pca953x
Date: Thu, 24 Feb 2011 10:20:43 +0100
Message-Id: <1298539243-25150-1-git-send-email-eibach@gdsys.de>
In-Reply-To: <20110222123601.GA1966@bicker>
References: <20110222123601.GA1966@bicker>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110224092047Z
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.170; VDF: 7.11.3.207; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pca953x_get_alt_pdata() uses uint16_t* as result type for
of_get_property(), but numeric of values are __be32.

Checking for negative values is bogus because of-property
values are unsigned by definition.
Instead check for proper property size.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
Changes since v1:
- removed bogus check for negative property values

Changes since v2:
- assume big-endian properties
- check property size

 drivers/gpio/pca953x.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index a261972..694b0f9 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -448,7 +448,8 @@ pca953x_get_alt_pdata(struct i2c_client *client)
 {
 	struct pca953x_platform_data *pdata;
 	struct device_node *node;
-	const uint16_t *val;
+	const __be32 *val;
+	int size;
 
 	node = client->dev.of_node;
 	if (node == NULL)
@@ -461,13 +462,13 @@ pca953x_get_alt_pdata(struct i2c_client *client)
 	}
 
 	pdata->gpio_base = -1;
-	val = of_get_property(node, "linux,gpio-base", NULL);
+	val = of_get_property(node, "linux,gpio-base", &size);
 	if (val) {
-		if (*val < 0)
-			dev_warn(&client->dev,
-				 "invalid gpio-base in device tree\n");
+		if (size != sizeof(*val))
+			dev_warn(&client->dev, "%s: wrong linux,gpio-base\n",
+				 node->full_name);
 		else
-			pdata->gpio_base = *val;
+			pdata->gpio_base = be32_to_cpup(val);
 	}
 
 	val = of_get_property(node, "polarity", NULL);
-- 
1.5.6.5

