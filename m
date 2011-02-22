Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1BVN2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:28:09 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:50473 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab1BVN2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:28:08 -0500
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
Cc: error27@gmail.com, Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH v2] gpio: Fix wrong pointer type in pca953x
Date: Tue, 22 Feb 2011 14:28:04 +0100
Message-Id: <1298381284-23317-1-git-send-email-eibach@gdsys.de>
In-Reply-To: <20110222123601.GA1966@bicker>
References: <20110222123601.GA1966@bicker>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110222132807Z
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.170; VDF: 7.11.3.178; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pca953x_get_alt_pdata() uses uint16_t* as result type for
of_get_property(), but numeric of values are u32.

Checking for negative values is bogus because of-property
values are unsigned by definition.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
Changes since v1:
- removed bogus check for negative property values

 drivers/gpio/pca953x.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index a261972..8acbfe9 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -448,7 +448,7 @@ pca953x_get_alt_pdata(struct i2c_client *client)
 {
 	struct pca953x_platform_data *pdata;
 	struct device_node *node;
-	const uint16_t *val;
+	const u32 *val;
 
 	node = client->dev.of_node;
 	if (node == NULL)
@@ -462,13 +462,8 @@ pca953x_get_alt_pdata(struct i2c_client *client)
 
 	pdata->gpio_base = -1;
 	val = of_get_property(node, "linux,gpio-base", NULL);
-	if (val) {
-		if (*val < 0)
-			dev_warn(&client->dev,
-				 "invalid gpio-base in device tree\n");
-		else
-			pdata->gpio_base = *val;
-	}
+	if (val)
+		pdata->gpio_base = *val;
 
 	val = of_get_property(node, "polarity", NULL);
 	if (val)
-- 
1.5.6.5

